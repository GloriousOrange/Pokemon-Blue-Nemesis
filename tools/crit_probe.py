#!/usr/bin/env python3
"""
Measure battle-engine probabilities on real hardware by calling the routine
under test directly -- crit rates via CriticalHitTest, flinch rates via
FlinchSideEffect.

Getting into a battle headlessly is slow and fragile, so this skips gameplay
entirely: it boots the ROM, writes a five-instruction stub into WRAM that banks
in Battle Core and `call`s the routine, then points the CPU at the stub and
reads the result back out of WRAM. Interrupts are masked first so nothing but
the routine under test runs.

Setup (once):
    python3 -m venv .venv-emu && .venv-emu/bin/pip install pyboy pillow

Usage:
    .venv-emu/bin/python tools/crit_probe.py                # crit rates
    .venv-emu/bin/python tools/crit_probe.py --flinch       # flinch rates
    .venv-emu/bin/python tools/crit_probe.py --trials 500

Addresses come out of pokeblue.sym -- they are NOT vanilla pokered's, and they
move whenever WRAM shifts, so the script re-reads the symbol file every run.

Note the RNG seeding: hRandomAdd/hRandomSub are normally stirred by VBlank,
which is masked here, so each trial seeds them itself. That makes the sample
uniform, which is the point -- we are measuring the crit threshold, not the
quality of the game's RNG.
"""
import argparse
import os
import random
import sys

try:
    from pyboy import PyBoy
except ImportError:
    sys.exit(__doc__.split("Setup (once):")[1].strip())

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, "pokeblue.gbc")
SYM = os.path.join(ROOT, "pokeblue.sym")

STUB = 0xC000          # scratch WRAM; nothing else runs once we take the CPU
STACK = 0xDFF0
MOVE_POWER = 85        # any non-zero value; the routine only tests for zero

# base speed 115, and a Persian carries FOCUS_ENERGY-adjacent sets in this mod
SPECIES = 0x90         # PERSIAN
BASE_SPEED = 115
NORMAL_MOVE = 0x22     # BODY_SLAM
HIGH_CRIT_MOVE = 0xA3  # SLASH
GRANIT_CLAMP = 0xD4    # should behave as a high-crit move

GETTING_PUMPED = 1 << 2
FLINCHED = 1 << 3

# move id -> (effect id, expected flinch chance) for the flinch probe
FLINCH_CASES = [
    ("BITE (FLINCH_SIDE_EFFECT1)", 0x2C, 0x1F, 10),
    ("HYDRO_JET (FLINCH_SIDE_EFFECT2)", 0xD0, 0x25, 30),
    ("CRUSH_JAW (special-cased)", 0xD5, 0x25, 50),
]


def load_symbols(*names):
    """Pull `name -> address` out of the rgblink .sym file."""
    wanted, found = set(names), {}
    with open(SYM) as fh:
        for line in fh:
            parts = line.split()
            if len(parts) != 2 or ":" not in parts[0]:
                continue
            bank, addr = parts[0].split(":")
            if parts[1] in wanted and parts[1] not in found:
                found[parts[1]] = (int(bank, 16), int(addr, 16))
    missing = wanted - set(found)
    if missing:
        sys.exit(f"symbols not found in {SYM}: {', '.join(sorted(missing))}")
    return found


def build_stub(bank, addr):
    return bytes([
        0x3E, bank,                            # ld a, <bank>
        0xEA, 0x00, 0x20,                      # ld [$2000], a   ; MBC3 bank switch
        0xE0, 0xB8,                            # ldh [hLoadedROMBank], a
        0xCD, addr & 0xFF, addr >> 8,          # call CriticalHitTest
        0x18, 0xFE,                            # jr -2           ; spin till frame end
    ])


def trial(pyboy, sym, stub, move, focus_energy):
    mem = pyboy.memory
    mem[0xFFFF] = 0x00                         # IE: mask every interrupt
    mem[0xFF0F] = 0x00                         # IF: drop anything already pending
    mem[sym["hWhoseTurn"][1]] = 0x00           # player is attacking
    mem[sym["wBattleMonSpecies"][1]] = SPECIES
    mem[sym["wPlayerMoveNum"][1]] = move
    mem[sym["wPlayerMovePower"][1]] = MOVE_POWER
    mem[sym["wPlayerBattleStatus2"][1]] = GETTING_PUMPED if focus_energy else 0
    mem[sym["wCriticalHitOrOHKO"][1]] = 0
    mem[0xFFD3] = random.randrange(256)        # hRandomAdd
    mem[0xFFD4] = random.randrange(256)        # hRandomSub

    for offset, byte in enumerate(stub):
        mem[STUB + offset] = byte

    pyboy.register_file.SP = STACK
    pyboy.register_file.PC = STUB
    pyboy.tick(1, False)

    return mem[sym["wCriticalHitOrOHKO"][1]]


def flinch_trial(pyboy, sym, stub, move, effect):
    mem = pyboy.memory
    mem[0xFFFF] = 0x00
    mem[0xFF0F] = 0x00
    mem[sym["hWhoseTurn"][1]] = 0x00            # player is attacking
    mem[sym["wPlayerMoveNum"][1]] = move
    mem[sym["wPlayerMoveEffect"][1]] = effect
    mem[sym["wEnemyBattleStatus1"][1]] = 0      # clear FLINCHED
    mem[sym["wEnemyBattleStatus2"][1]] = 0      # no substitute, or the routine bails
    mem[0xFFD3] = random.randrange(256)
    mem[0xFFD4] = random.randrange(256)

    for offset, byte in enumerate(stub):
        mem[STUB + offset] = byte

    pyboy.register_file.SP = STACK
    pyboy.register_file.PC = STUB
    pyboy.tick(1, False)

    return 1 if mem[sym["wEnemyBattleStatus1"][1]] & FLINCHED else 0


def probe_flinch(pyboy, sym, trials):
    stub = build_stub(*sym["FlinchSideEffect"])
    print(f"{trials} trials per case\n")
    print(f"{'move':<34}{'measured':>10}{'expected':>10}")
    print("-" * 54)
    for label, move, effect, pct in FLINCH_CASES:
        hits = sum(flinch_trial(pyboy, sym, stub, move, effect) for _ in range(trials))
        # the game compares against `N percent + 1`, i.e. (N * 255 // 100) + 1
        expected = ((pct * 255 // 100) + 1) / 256
        print(f"{label:<34}{100.0 * hits / trials:>9.1f}%{100.0 * expected:>9.1f}%")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--trials", type=int, default=2000)
    ap.add_argument("--seed", type=int, default=1234)
    ap.add_argument("--flinch", action="store_true",
                    help="probe FlinchSideEffect instead of CriticalHitTest")
    args = ap.parse_args()
    random.seed(args.seed)

    sym = load_symbols(
        "CriticalHitTest", "FlinchSideEffect", "wBattleMonSpecies",
        "wPlayerMoveNum", "wPlayerMoveEffect", "wPlayerMovePower",
        "wPlayerBattleStatus2", "wEnemyBattleStatus1", "wEnemyBattleStatus2",
        "wCriticalHitOrOHKO", "hWhoseTurn",
    )

    pyboy = PyBoy(ROM, window="null", log_level="ERROR")
    for _ in range(300):                       # let the boot ROM and init settle
        pyboy.tick(1, False)

    if args.flinch:
        probe_flinch(pyboy, sym, args.trials)
        pyboy.stop(save=False)
        return

    stub = build_stub(*sym["CriticalHitTest"])
    half_speed = BASE_SPEED >> 1
    cases = [
        ("normal move, no Focus Energy", NORMAL_MOVE, False, half_speed),
        ("normal move, FOCUS ENERGY", NORMAL_MOVE, True, 0x7F),
        ("high-crit move, no Focus Energy", HIGH_CRIT_MOVE, False, min(half_speed * 8, 0xFF)),
        ("high-crit move, FOCUS ENERGY", HIGH_CRIT_MOVE, True, 0xFF),
        ("GRANIT_CLAMP, no Focus Energy", GRANIT_CLAMP, False, min(half_speed * 8, 0xFF)),
    ]

    print(f"PERSIAN (base speed {BASE_SPEED}), {args.trials} trials per case\n")
    print(f"{'case':<34}{'measured':>10}{'expected':>10}")
    print("-" * 54)
    for label, move, focus, threshold in cases:
        crits = sum(trial(pyboy, sym, stub, move, focus) for _ in range(args.trials))
        measured = 100.0 * crits / args.trials
        print(f"{label:<34}{measured:>9.1f}%{100.0 * threshold / 256:>9.1f}%")

    pyboy.stop(save=False)


if __name__ == "__main__":
    main()
