#!/usr/bin/env python3
"""
Prove that LoadEnemyMonData no longer leaves a stale move in the 5th slot.

NUM_MOVES is 5 in this mod but base stats only carry NUM_BASE_MOVES (4), so
LoadEnemyMonData's .copyStandardMoves has to zero the leftover slot itself.
When it didn't, slot 5 kept whatever the previous enemy mon left in
wEnemyMonMoves -- and SendNewMonToBox copies all five slots wholesale, so the
phantom move was stamped permanently onto anything caught or gifted into the
box.

The probe poisons wEnemyMonMoves + 4 with PSYCHIC_M, then calls
LoadEnemyMonData for a wild mon and reads the slots back. Same WRAM-stub trick
as crit_probe.py / mon_header_probe.py: mask interrupts, write a stub that
banks in the routine and calls it, run until it returns.

Usage:
    .venv-emu/bin/python tools/enemy_move_slot_probe.py ZUBAT:10 PIKACHU:10
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
FRAME_BUDGET = 60
NUM_MOVES = 5
POISON = "PSYCHIC_M"

DEFAULT_CASES = ["ZUBAT:10", "PIKACHU:10", "PIDGEY:10", "DRATINI:10",
                 "TAUROS:10", "PINSIR:10", "STARMIE:10"]


def parse_consts(path, start=0):
    names, value = {}, None
    for line in open(os.path.join(ROOT, path)):
        line = line.split(";")[0].strip()
        m = re.match(r"const_def(?:\s+(-?\w+))?$", line)
        if m:
            value = int(m.group(1), 0) if m.group(1) else start
        elif value is not None:
            mm = re.match(r"const_next\s+(\$?\w+)$", line)
            if mm:
                value = int(mm.group(1).replace("$", "0x"), 0)
                continue
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
        0x3E, bank, 0xEA, 0x00, 0x20, 0xE0, 0xB8,  # ld a,bank / ld [$2000],a / ldh [hLoadedROMBank],a
        0xCD, addr & 0xFF, addr >> 8,              # call addr
        0x18, 0xFE,                                # jr -2 (spin)
    ])


def main():
    species = parse_consts("constants/pokemon_constants.asm")
    moves = parse_consts("constants/move_constants.asm")
    move_name = {v: k for k, v in moves.items()}

    sym = load_symbols("LoadEnemyMonData", "wEnemyMonMoves", "wEnemyMonSpecies2",
                       "wCurEnemyLevel", "wEnemyBattleStatus3", "wIsInBattle",
                       "wLinkState", "wCurPartySpecies")
    slots = sym["wEnemyMonMoves"][1]
    poison_id = moves[POISON]

    pyboy = PyBoy(ROM, window="null", cgb=True)
    pyboy.tick(600, False)  # generous boot warm-up
    mem = pyboy.memory

    failures = 0
    for case in (sys.argv[1:] or DEFAULT_CASES):
        name, _, lvl = case.partition(":")
        level = int(lvl or 10)
        if name not in species:
            print(f"{name}: unknown species")
            failures += 1
            continue

        mem[0xFFFF] = 0
        mem[0xFF0F] = 0
        mem[sym["wLinkState"][1]] = 0
        mem[sym["wIsInBattle"][1]] = 1          # wild encounter, not a trainer battle
        mem[sym["wEnemyBattleStatus3"][1]] = 0
        mem[sym["wEnemyMonSpecies2"][1]] = species[name]
        mem[sym["wCurPartySpecies"][1]] = species[name]
        mem[sym["wCurEnemyLevel"][1]] = level
        # Poison every slot, so a slot that comes back clean was actually written.
        for i in range(NUM_MOVES):
            mem[slots + i] = poison_id

        stub = build_stub(*sym["LoadEnemyMonData"])
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
            print(f"{name}: DID NOT RETURN within {FRAME_BUDGET} frames -- likely a hang")
            failures += 1
            continue

        got = [mem[slots + i] for i in range(NUM_MOVES)]
        pretty = [move_name.get(m, f"${m:02x}") if m else "--" for m in got]
        phantom = got[NUM_MOVES - 1] == poison_id
        verdict = "PHANTOM MOVE SURVIVED" if phantom else "clean"
        if phantom:
            failures += 1
        print(f"{name+':'+str(level):<14} {', '.join(pretty):<58} {verdict}")

    pyboy.stop(save=False)
    print()
    print(f"{'FAIL' if failures else 'PASS'}: {failures} phantom/failed case(s)")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
