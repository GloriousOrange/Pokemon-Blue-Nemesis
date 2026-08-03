#!/usr/bin/env python3
"""
Call ApplyMutagenMoveset on hardware for EVERY currently curated species and
confirm what actually gets written matches what's in the table -- not a
per-batch spot check, full coverage every run.

Same crit_probe.py WRAM-stub trick as the rest of this project's probes.

Usage:
    .venv-emu/bin/python tools/mutagen_probe_all.py
"""
import os
import re
import sys

try:
    from pyboy import PyBoy
except ImportError:
    sys.exit("needs the .venv-emu PyBoy environment")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, "pokeblue.gbc")
SYM = os.path.join(ROOT, "pokeblue.sym")
STUB = 0xC000
STACK = 0xDFF0
NUM_MOVES = 5
CANARY = 0xAA


def parse_consts(path):
    names, value = {}, None
    for line in open(os.path.join(ROOT, path)):
        line = line.split(";")[0].strip()
        if re.match(r"const_def(\s|$)", line):
            value = 0
        elif value is not None:
            m = re.match(r"const_skip(?:\s+(\d+))?$", line)
            if m:
                value += int(m.group(1) or 1)
                continue
            m = re.match(r"const\s+(\w+)$", line)
            if m:
                names[m.group(1)] = value
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


def load_curated_rows():
    """Parse the table itself so this never needs a hardcoded species list."""
    text = open(os.path.join(ROOT, "data/pokemon/mutagen_movesets.asm")).read()
    rows = []
    # anchored to a single line -- an earlier version's `\s` in the moves
    # group matched across newlines into subsequent rows, silently merging
    # them and skipping most of the table (31 of 59 rows "found")
    for line in text.splitlines():
        m = re.match(r"\tmutagen_moveset (\w+),\s*([A-Z0-9_,\s]+)$", line)
        if not m:
            continue
        species = m.group(1)
        moves = [mv.strip() for mv in m.group(2).split(",") if mv.strip()][:NUM_MOVES]
        if len(moves) == NUM_MOVES:
            rows.append((species, moves))
    return rows


def build_stub(bank, addr, de):
    return bytes([0x3E, bank, 0xEA, 0x00, 0x20, 0xE0, 0xB8,
                  0x11, de & 0xFF, de >> 8,
                  0xCD, addr & 0xFF, addr >> 8, 0x18, 0xFE])


def main():
    species = parse_consts("constants/pokemon_constants.asm")
    moves = parse_consts("constants/move_constants.asm")
    by_id = {v: k for k, v in moves.items()}

    rows = load_curated_rows()
    print(f"checking {len(rows)} curated species against ApplyMutagenMoveset...\n")

    sym = load_symbols("ApplyMutagenMoveset", "wCurPartySpecies",
                       "wPartyMon1Moves", "wPartyMon1PP")
    moves_addr = sym["wPartyMon1Moves"][1]
    pp_addr = sym["wPartyMon1PP"][1]

    pyboy = PyBoy(ROM, window="null", cgb=True)
    pyboy.tick(600, False)
    mem = pyboy.memory

    fails = []
    for name, want in rows:
        if name not in species:
            fails.append(f"{name}: not a known species constant")
            continue
        mem[sym["wCurPartySpecies"][1]] = species[name]
        for i in range(NUM_MOVES):
            mem[moves_addr + i] = CANARY
            mem[pp_addr + i] = CANARY

        stub = build_stub(*sym["ApplyMutagenMoveset"], moves_addr)
        for i, b in enumerate(stub):
            mem[STUB + i] = b
        pyboy.register_file.SP = STACK
        pyboy.register_file.PC = STUB
        spin = STUB + len(stub) - 2
        for _ in range(30):
            pyboy.tick(1, False)
            if pyboy.register_file.PC == spin:
                break
        else:
            fails.append(f"{name}: did not return within budget -- hang")
            continue

        hl = pyboy.register_file.HL
        got = [mem[moves_addr + i] for i in range(NUM_MOVES)]
        got_names = [by_id.get(m, f"${m:02x}") for m in got]
        pp = [mem[pp_addr + i] for i in range(NUM_MOVES)]

        if hl != 1:
            fails.append(f"{name}: returned hl={hl}, expected 1 (curated)")
        if got_names != want:
            fails.append(f"{name}: applied {got_names}, table says {want}")
        if any(p == CANARY for p in pp):
            fails.append(f"{name}: PP left as canary -- {pp}")

    pyboy.stop(save=False)

    print(f"{len(rows) - len(fails)}/{len(rows)} clean" if not fails
          else f"{len(fails)} problem(s):")
    for f in fails:
        print(f"  - {f}")
    if fails:
        sys.exit(1)
    print("Every curated species applies correctly with real PP.")


if __name__ == "__main__":
    main()
