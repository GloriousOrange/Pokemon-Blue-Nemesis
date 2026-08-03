#!/usr/bin/env python3
"""
Call GetMonHeader on hardware for a species and dump wMonHeader back out.

This is the highest-risk check for a newly registered species: GetMonHeader
resolves the sprite pointer/dimension byte and calls `predef IndexToPokedex`,
and a bad .pic file, wrong dimension byte, or bank mismatch is exactly the
kind of thing that hangs or corrupts silently rather than erroring at build
time. Same crit_probe.py WRAM-stub trick -- mask interrupts, write a stub that
banks in GetMonHeader and calls it, run until it returns.

Usage:
    .venv-emu/bin/python tools/mon_header_probe.py PINSIRITE NINEFROST DIGNEMITE
"""
import os
import re
import sys

try:
    from pyboy import PyBoy
except ImportError:
    sys.exit("needs the .venv-emu PyBoy environment -- see tools/screenshot.py")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, "pokeblue.gbc")
SYM = os.path.join(ROOT, "pokeblue.sym")

STUB = 0xC000
STACK = 0xDFF0
FRAME_BUDGET = 30


def parse_consts(path, start=0):
    names, value = {}, None
    for line in open(os.path.join(ROOT, path)):
        line = line.split(";")[0].strip()
        m = re.match(r"const_def(?:\s+(-?\w+))?$", line)
        if m:
            value = int(m.group(1), 0) if m.group(1) else start
        elif value is not None:
            mm = re.match(r"const_skip(?:\s+(\d+))?$", line)
            if mm:
                value += int(mm.group(1) or 1)
                continue
            mm = re.match(r"const\s+(\w+)$", line)
            if mm:
                names[mm.group(1)] = value
                value += 1
    return names


def load_symbols(*wanted):
    found = {}
    for line in open(SYM):
        parts = line.split()
        if len(parts) == 2 and ":" in parts[0] and parts[1] in wanted:
            found.setdefault(parts[1], tuple(int(x, 16) for x in parts[0].split(":")))
    missing = set(wanted) - set(found)
    if missing:
        sys.exit(f"symbols not found in {SYM}: {', '.join(sorted(missing))}")
    return found


def build_stub(bank, addr):
    return bytes([
        0x3E, bank, 0xEA, 0x00, 0x20, 0xE0, 0xB8,
        0xCD, addr & 0xFF, addr >> 8,
        0x18, 0xFE,
    ])


def main():
    species = parse_consts("constants/pokemon_constants.asm")
    types = parse_consts("constants/type_constants.asm")

    sym = load_symbols("GetMonHeader", "wCurSpecies", "wMonHeader",
                       "wMonHFrontSprite" if False else "wMonHeader")
    # Header field offsets from wMonHeader (see ram/wram.asm): dex-idx, hp,
    # atk, def, spd, spc, type1, type2, catch, exp, then a 2-byte sprite-dim
    # pointer field and the front/back .pic pointers.
    header = sym["wMonHeader"][1]

    pyboy = PyBoy(ROM, window="null", cgb=True)
    pyboy.tick(600, False)  # generous boot warm-up; frame 60 raced the boot ROM handoff
    mem = pyboy.memory

    for name in sys.argv[1:]:
        if name not in species:
            print(f"{name}: unknown species")
            continue
        mem[0xFFFF] = 0
        mem[0xFF0F] = 0
        mem[sym["wCurSpecies"][1]] = species[name]
        for i in range(29):
            mem[header + i] = 0xAA  # canary

        stub = build_stub(*sym["GetMonHeader"])
        for off, b in enumerate(stub):
            mem[STUB + off] = b
        pyboy.register_file.SP = STACK
        pyboy.register_file.PC = STUB
        spin = STUB + len(stub) - 2
        for _ in range(FRAME_BUDGET):
            pyboy.tick(1, False)
            if pyboy.register_file.PC == spin:
                break
        else:
            print(f"{name}: DID NOT RETURN within {FRAME_BUDGET} frames "
                 f"(PC={pyboy.register_file.PC:#06x}) -- likely a hang")
            continue

        row = [mem[header + i] for i in range(10)]
        idx, hp, atk, de, spd, spc, t1, t2, catch, exp = row
        t1n, t2n = types.get(t1, f"${t1:02x}"), types.get(t2, f"${t2:02x}")
        touched = any(mem[header + i] != 0xAA for i in range(29))
        print(f"{name:<12} returned OK  wMonHIndex=${idx:02x}  "
              f"HP{hp:>4} ATK{atk:>4} DEF{de:>4} SPD{spd:>4} SPC{spc:>4}  "
              f"{t1n}/{t2n}  catch={catch} exp={exp}  header_written={touched}")

    pyboy.stop(save=False)


if __name__ == "__main__":
    main()
