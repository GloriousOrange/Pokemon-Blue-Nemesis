#!/usr/bin/env python3
"""
Verify ApplyHyperBeamPower on real hardware.

HYPER BEAM's power is not the 150 in the Moves table -- ApplyHyperBeamPower
(engine/battle/hyper_beam_power.asm) overwrites it with the user's BASE Attack
plus BASE Speed, minus 50, or minus 30 when the user is NORMAL-type.

Same WRAM-stub trick as tools/crit_probe.py: rather than driving the emulator
into a battle, this boots the ROM, writes a short stub into WRAM that banks in
the routine's section and `call`s it, points the CPU at the stub, and reads
wPlayerMovePower back out. Interrupts are masked so nothing else runs.

The expected value is computed independently, from the .asm base-stat files --
so a pass means the ROM agrees with the source, not just with itself.

Setup (once):
    python3 -m venv .venv-emu && .venv-emu/bin/pip install pyboy pillow

Usage:
    .venv-emu/bin/python tools/hyper_beam_probe.py
"""
import os
import re
import sys

try:
    from pyboy import PyBoy
except ImportError:
    sys.exit(__doc__.split("Setup (once):")[1].strip())

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, "pokeblue.gbc")
SYM = os.path.join(ROOT, "pokeblue.sym")

STUB = 0xC000
STACK = 0xDFF0
HYPER_BEAM = 0x3F
PENALTY, PENALTY_NORMAL = 50, 30

# Spread across the range, both types, both sides of the NORMAL penalty.
CASES = ["tyranis", "mewtwo", "tauros", "dodrio", "chansey", "slowbro",
         "gyarados", "dragonite", "electrode", "porygon"]


def load_symbols(*names):
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


def species_ids():
    """name -> internal species id, from constants/pokemon_constants.asm.

    Borrows docs/data/build.py's parser rather than counting `const` lines by
    hand: that file uses const_skip *and* const_next, and a hand-rolled counter
    silently mis-numbers everything after the first jump. The first version of
    this probe did exactly that and reported ten false mismatches.
    """
    build = os.path.join(ROOT, "docs/data/build.py")
    src = open(build).read().split("def main(")[0]
    ns = {"__file__": build}
    sys.path.insert(0, os.path.dirname(build))  # build.py imports move_effects
    try:
        exec(compile(src, build, "exec"), ns)
    finally:
        sys.path.pop(0)
    return ns["parse_consts"]("constants/pokemon_constants.asm")


def expected(basename):
    """Power predicted straight from the .asm, independent of the ROM."""
    text = open(os.path.join(ROOT, "data/pokemon/base_stats", basename + ".asm")).read()
    m = re.search(r"db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\s*\n\s*;\s*hp", text)
    _, atk, _, spd, _ = (int(x) for x in m.groups())
    types = re.search(r"db (\w+), (\w+) ; type", text).groups()
    pen = PENALTY_NORMAL if "NORMAL" in types else PENALTY
    return max(1, min(255, atk + spd - pen)), atk, spd, pen


def main():
    sym = load_symbols("ApplyHyperBeamPower", "hWhoseTurn", "wBattleMonSpecies",
                       "wPlayerMoveNum", "wPlayerMovePower", "wCurSpecies")
    bank, addr = sym["ApplyHyperBeamPower"]
    stub = bytes([
        0x3E, bank,                     # ld a, <bank>
        0xEA, 0x00, 0x20,               # ld [$2000], a
        0xE0, 0xB8,                     # ldh [hLoadedROMBank], a
        0xCD, addr & 0xFF, addr >> 8,   # call ApplyHyperBeamPower
        0x18, 0xFE,                     # jr -2
    ])

    ids = species_ids()
    pyboy = PyBoy(ROM, window="null")
    pyboy.tick(120, False)
    mem = pyboy.memory

    print(f"{'species':12} {'atk':>4} {'spd':>4} {'pen':>4} {'expect':>7} {'rom':>5}")
    failures = 0
    for basename in CASES:
        want, atk, spd, pen = expected(basename)
        const = basename.upper()
        if const not in ids:
            print(f"{basename:12}   no such constant"); failures += 1; continue

        mem[0xFFFF] = 0x00
        mem[0xFF0F] = 0x00
        mem[sym["hWhoseTurn"][1]] = 0x00
        mem[sym["wBattleMonSpecies"][1]] = ids[const]
        mem[sym["wPlayerMoveNum"][1]] = HYPER_BEAM
        mem[sym["wPlayerMovePower"][1]] = 150  # the table value it must overwrite
        for i, byte in enumerate(stub):
            mem[STUB + i] = byte
        pyboy.register_file.SP = STACK
        pyboy.register_file.PC = STUB
        pyboy.tick(1, False)

        got = mem[sym["wPlayerMovePower"][1]]
        ok = got == want
        failures += not ok
        print(f"{basename:12} {atk:4} {spd:4} {pen:4} {want:7} {got:5}  {'ok' if ok else 'MISMATCH'}")

    # a non-HYPER_BEAM move must be left alone
    mem[sym["wPlayerMoveNum"][1]] = 0x21  # TACKLE
    mem[sym["wPlayerMovePower"][1]] = 35
    for i, byte in enumerate(stub):
        mem[STUB + i] = byte
    pyboy.register_file.SP = STACK
    pyboy.register_file.PC = STUB
    pyboy.tick(1, False)
    untouched = mem[sym["wPlayerMovePower"][1]] == 35
    failures += not untouched
    print(f"\nnon-HYPER_BEAM move left alone: {'ok' if untouched else 'MISMATCH'}")

    pyboy.stop(save=False)
    print("\nall cases match" if not failures else f"\n{failures} mismatch(es)")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
