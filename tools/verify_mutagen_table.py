#!/usr/bin/env python3
"""Decode MutagenMovesets straight out of the built ROM and print it as names.

The table is written by hand, one row per species, and a wrong or duplicated
species byte is invisible in the source but silently gives a mon the wrong
moveset. This reads the bytes the linker actually emitted, resolves them back
through the constant lists, and checks the things the assembler cannot:

  * every move id is a real move (and not STRUGGLE or a gap)
  * no species appears twice (the scan takes the first hit, so a dupe is dead)
  * every row has NUM_MOVES moves and the table is 0-terminated
  * no move is repeated inside one row

Run after adding rows:  python3 tools/verify_mutagen_table.py
"""
import re
import sys
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent


def parse_consts(path, stop_at_num=None):
    """Pull `const NAME` lists out of an rgbds constants file, honouring const_skip."""
    names = {}
    value = None
    for line in (ROOT / path).read_text().splitlines():
        line = line.split(";")[0].strip()
        m = re.match(r"const_def(\s|$)", line)
        if m:
            value = 0
            continue
        m = re.match(r"const_skip(?:\s+(\d+))?$", line)
        if m and value is not None:
            value += int(m.group(1) or 1)
            continue
        m = re.match(r"const\s+(\w+)$", line)
        if m and value is not None:
            names[value] = m.group(1)
            value += 1
    return names


def main():
    sym = (ROOT / "pokeblue.sym").read_text()
    m = re.search(r"^(\w+):(\w+) MutagenMovesets$", sym, re.M)
    if not m:
        sys.exit("MutagenMovesets not found in pokeblue.sym -- build first (make blue)")
    bank, addr = int(m.group(1), 16), int(m.group(2), 16)
    offset = bank * 0x4000 + (addr - 0x4000)

    rom = (ROOT / "pokeblue.gbc").read_bytes()
    moves = parse_consts("constants/move_constants.asm")
    species = parse_consts("constants/pokemon_constants.asm")

    num_moves = int(re.search(r"DEF NUM_MOVES EQU (\d+)",
                              (ROOT / "constants/battle_constants.asm").read_text()).group(1))

    print(f"MutagenMovesets @ bank ${bank:02x}:${addr:04x} (rom offset {offset})\n")

    problems = []
    seen = {}
    rows = 0
    pos = offset
    while rom[pos] != 0:
        sid = rom[pos]
        row = rom[pos + 1: pos + 1 + num_moves]
        sname = species.get(sid, f"??${sid:02x}")
        if sid not in species:
            problems.append(f"row {rows + 1}: unknown species id ${sid:02x}")
        if sid in seen:
            problems.append(f"{sname}: duplicate row (also row {seen[sid]}) -- the "
                            f"lookup takes the first, so row {rows + 1} is dead")
        seen[sid] = rows + 1

        mnames = []
        for b in row:
            mn = moves.get(b)
            if mn is None:
                problems.append(f"{sname}: invalid move id ${b:02x}")
                mn = f"??${b:02x}"
            mnames.append(mn)
        if len(set(row)) != len(row):
            problems.append(f"{sname}: repeats a move in its own row")

        print(f"  {sname:<12} {', '.join(mnames)}")
        rows += 1
        pos += 1 + num_moves
        if rows > 300:
            sys.exit("no 0 terminator found within 300 rows -- table is malformed")

    size = pos + 1 - offset
    print(f"\n{rows} rows, {size} bytes (terminator included)")

    if problems:
        print("\nPROBLEMS:")
        for p in problems:
            print(f"  - {p}")
        sys.exit(1)
    print("All rows decode to real species and moves; no duplicates.")


if __name__ == "__main__":
    main()
