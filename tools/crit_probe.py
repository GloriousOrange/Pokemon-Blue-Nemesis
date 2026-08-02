#!/usr/bin/env python3
"""
Measure critical-hit rates on real hardware by calling CriticalHitTest directly.

Getting into a battle headlessly is slow and fragile, so this skips gameplay
entirely: it boots the ROM, writes a five-instruction stub into WRAM that banks
in Battle Core and `call`s CriticalHitTest, then points the CPU at the stub and
reads wCriticalHitOrOHKO back out. Interrupts are masked first so nothing but
the routine under test runs.

Setup (once):
    python3 -m venv .venv-emu && .venv-emu/bin/pip install pyboy pillow

Usage:
    .venv-emu/bin/python tools/crit_probe.py                # default 2000 trials
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

GETTING_PUMPED = 1 << 2


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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--trials", type=int, default=2000)
    ap.add_argument("--seed", type=int, default=1234)
    args = ap.parse_args()
    random.seed(args.seed)

    sym = load_symbols(
        "CriticalHitTest", "wBattleMonSpecies", "wPlayerMoveNum",
        "wPlayerMovePower", "wPlayerBattleStatus2", "wCriticalHitOrOHKO",
        "hWhoseTurn",
    )
    bank, addr = sym["CriticalHitTest"]
    stub = build_stub(bank, addr)

    pyboy = PyBoy(ROM, window="null", log_level="ERROR")
    for _ in range(300):                       # let the boot ROM and init settle
        pyboy.tick(1, False)

    half_speed = BASE_SPEED >> 1
    cases = [
        ("normal move, no Focus Energy", NORMAL_MOVE, False, half_speed),
        ("normal move, FOCUS ENERGY", NORMAL_MOVE, True, 0x7F),
        ("high-crit move, no Focus Energy", HIGH_CRIT_MOVE, False, min(half_speed * 8, 0xFF)),
        ("high-crit move, FOCUS ENERGY", HIGH_CRIT_MOVE, True, 0xFF),
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
