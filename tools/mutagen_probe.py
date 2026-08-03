#!/usr/bin/env python3
"""
Verify ApplyMutagenMoveset on real hardware without reaching gameplay.

Same trick as crit_probe.py: boot the ROM, write a stub into WRAM that banks in
the Mutagen Movesets section, points de at party slot 1's MON_MOVES and `call`s
the routine, then read the moves and PP back out of WRAM.

What this actually checks, which the table decode cannot:
  * a curated species gets exactly its five curated moves, in order
  * each move's PP is that move's real max PP (WriteMonMoves never wrote PP on
    this path, so a stale-PP regression would be silent in-game)
  * an UNCURATED species returns hl = 0 and leaves the move slots untouched,
    which is what makes the caller's WriteMonMoves fallback safe
  * the routine returns rather than hanging (a wrong-bank call would spin)

Setup (once):
    python3 -m venv .venv-emu && .venv-emu/bin/pip install pyboy pillow

Usage:
    .venv-emu/bin/python tools/mutagen_probe.py
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
CANARY = 0xAA  # pre-fill for move slots, so "untouched" is distinguishable from 0

# species to probe: (name, id, expected move names) -- ids resolved from constants
CASES = [
    ("PINSIR", ["WEB_CANNON", "GUILLOTINE", "VIBRATE", "SLASH", "EARTHQUAKE"]),
    ("GENGAR", ["GHOST_BEAM", "SHADOW_PUNCH", "HYPNOSIS", "DREAM_EATER", "THUNDERBOLT"]),
    ("MAGMAR", ["FIRE_BLAST", "HOT_OIL", "HYPER_BEAM", "CONFUSE_RAY", "BODY_SLAM"]),
    ("ALAKACHAMP", ["UPPERCUT", "PSYCHIC_M", "AGILITY", "EARTHQUAKE", "RECOVER"]),
]
# no curated row yet -> must fall through to the caller's WriteMonMoves
UNCURATED = "PIDGEY"


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


def move_max_pp(rom, moves_bank, moves_addr, move_id, move_length, pp_off):
    """Read a move's base PP straight out of the Moves table in the ROM."""
    base = moves_bank * 0x4000 + (moves_addr - 0x4000)
    return rom[base + (move_id - 1) * move_length + pp_off]


def build_stub(bank, addr, de):
    return bytes([
        0x3E, bank,                      # ld a, <bank>
        0xEA, 0x00, 0x20,                # ld [$2000], a
        0xE0, 0xB8,                      # ldh [hLoadedROMBank], a
        0x11, de & 0xFF, de >> 8,        # ld de, <MON_MOVES of party slot 1>
        0xCD, addr & 0xFF, addr >> 8,    # call ApplyMutagenMoveset
        0x18, 0xFE,                      # jr -2
    ])


def run(pyboy, sym, species_id, moves_addr, pp_addr, num_moves):
    mem = pyboy.memory
    mem[0xFFFF] = 0x00
    mem[0xFF0F] = 0x00
    mem[sym["wCurPartySpecies"][1]] = species_id
    for i in range(num_moves):
        mem[moves_addr + i] = CANARY
        mem[pp_addr + i] = CANARY

    stub = build_stub(*sym["ApplyMutagenMoveset"], moves_addr)
    for off, byte in enumerate(stub):
        mem[STUB + off] = byte

    pyboy.register_file.SP = STACK
    pyboy.register_file.PC = STUB
    pyboy.tick(1, False)

    return (pyboy.register_file.HL,
            [mem[moves_addr + i] for i in range(num_moves)],
            [mem[pp_addr + i] for i in range(num_moves)])


def main():
    species = parse_consts("constants/pokemon_constants.asm")
    moves = parse_consts("constants/move_constants.asm")
    by_id = {v: k for k, v in moves.items()}

    battle = open(os.path.join(ROOT, "constants/battle_constants.asm")).read()
    num_moves = int(re.search(r"DEF NUM_MOVES EQU (\d+)", battle).group(1))

    sym = load_symbols("ApplyMutagenMoveset", "wCurPartySpecies",
                       "wPartyMon1Moves", "wPartyMon1PP", "Moves")
    moves_addr = sym["wPartyMon1Moves"][1]
    pp_addr = sym["wPartyMon1PP"][1]
    rom = open(ROM, "rb").read()

    # derive the Moves struct layout rather than hardcode it, so a field added
    # to moves.asm shows up as a probe failure instead of silently wrong PP
    fields = re.findall(r"DEF (MOVE_\w+)\s+rb", battle)
    move_length, pp_off = len(fields), fields.index("MOVE_PP")

    pyboy = PyBoy(ROM, window="null", cgb=True)
    pyboy.tick(120, False)  # let the boot ROM settle before we seize the CPU

    failures = []
    print(f"{'species':<12}{'ret':>5}  moves (PP)")
    print("-" * 78)

    for name, expected in CASES:
        hl, got, pp = run(pyboy, sym, species[name], moves_addr, pp_addr, num_moves)
        got_names = [by_id.get(m, f"${m:02x}") for m in got]
        want_pp = [move_max_pp(rom, *sym["Moves"], m, move_length, pp_off) for m in got]
        shown = ", ".join(f"{n}({p})" for n, p in zip(got_names, pp))
        print(f"{name:<12}{hl:>5}  {shown}")

        if hl != 1:
            failures.append(f"{name}: returned hl={hl}, expected 1 (curated)")
        if got_names != expected:
            failures.append(f"{name}: moves {got_names} != curated {expected}")
        if pp != want_pp:
            failures.append(f"{name}: PP {pp} != each move's max PP {want_pp}")

    hl, got, pp = run(pyboy, sym, species[UNCURATED], moves_addr, pp_addr, num_moves)
    print(f"{UNCURATED:<12}{hl:>5}  {[hex(m) for m in got]} (expect all 0xaa, untouched)")
    if hl != 0:
        failures.append(f"{UNCURATED}: returned hl={hl}, expected 0 (no curated row)")
    if any(m != CANARY for m in got):
        failures.append(f"{UNCURATED}: clobbered the move slots -> {got}; the "
                        f"WriteMonMoves fallback would inherit garbage")

    pyboy.stop(save=False)

    if failures:
        print("\nFAILURES:")
        for f in failures:
            print(f"  - {f}")
        sys.exit(1)
    print("\nAll cases pass: curated sets written with correct PP, "
          "uncurated species left untouched for the WriteMonMoves fallback.")


if __name__ == "__main__":
    main()
