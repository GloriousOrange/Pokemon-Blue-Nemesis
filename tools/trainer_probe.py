#!/usr/bin/env python3
"""
Dump the party a trainer actually loads, by calling ReadTrainer on hardware.

Reaching a trainer in-game is slow and fragile, so this uses the crit_probe
WRAM-stub trick instead: boot the ROM, write a stub that banks in ReadTrainer's
bank and calls it, point the CPU at the stub, then read wEnemyMon* back out.

This is the check that catches roster mistakes the assembler cannot see -- a
party whose shape doesn't match the ReadTrainer special-case that patches it
(patching mon6's move slot on a one-mon team writes into nothing), a trainer
number that lands on the wrong roster, or a signature move that silently never
gets applied.

Setup (once):
    python3 -m venv .venv-emu && .venv-emu/bin/pip install pyboy pillow

Usage:
    .venv-emu/bin/python tools/trainer_probe.py                 # default cases
    .venv-emu/bin/python tools/trainer_probe.py RIVAL3:41       # class:trainer_no
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
PARTYMON_STRUCT_LENGTH = 46   # NUM_MOVES is 5 in this fork, so a party mon
                              # is 46 bytes, not vanilla's 44
FRAME_BUDGET = 60             # frames to let ReadTrainer finish before calling it a hang

# what we expect, so this fails loudly instead of just printing
EXPECTED = {
    ("RIVAL3", 41): [("ALAKACHAMP", 100, "UPPERCUT")],
}

DEFAULT_CASES = [("RIVAL3", 41)]


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


def parse_trainer_consts():
    """trainer_const lines build OPP_* ids at OPP_ID_OFFSET + n."""
    names, value = {}, 0
    for line in open(os.path.join(ROOT, "constants/trainer_constants.asm")):
        line = line.split(";")[0].strip()
        m = re.match(r"trainer_const\s+(\w+)$", line)
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


def build_stub(bank, addr):
    return bytes([
        0x3E, bank,                      # ld a, <bank>
        0xEA, 0x00, 0x20,                # ld [$2000], a
        0xE0, 0xB8,                      # ldh [hLoadedROMBank], a
        0xCD, addr & 0xFF, addr >> 8,    # call ReadTrainer
        0x18, 0xFE,                      # jr -2
    ])


def read_party(pyboy, sym, opp_id, trainer_no, num_moves):
    mem = pyboy.memory
    mem[0xFFFF] = 0x00
    mem[0xFF0F] = 0x00
    mem[sym["wLinkState"][1]] = 0x00      # ReadTrainer bails out on a link battle
    mem[sym["wIsInBattle"][1]] = 0x02     # trainer battle
    mem[sym["wCurOpponent"][1]] = opp_id
    mem[sym["wTrainerNo"][1]] = trainer_no
    mem[0xFFD3] = 0x5A                    # hRandomAdd/Sub feed the DV roll
    mem[0xFFD4] = 0xA5

    stub = build_stub(*sym["ReadTrainer"])
    for off, byte in enumerate(stub):
        mem[STUB + off] = byte

    pyboy.register_file.SP = STACK
    pyboy.register_file.PC = STUB
    # ReadTrainer builds the whole roster -- CalcStats, CalcExperience and a
    # FarCopyData per move, per mon -- which overruns a single frame's cycles on
    # a six-mon team. Cutting it short leaves a half-built party (moves and HP
    # written, MON_LEVEL not yet), so run until the stub reaches its `jr -2`
    # spin rather than assuming one tick is enough.
    spin = STUB + len(stub) - 2
    for _ in range(FRAME_BUDGET):
        pyboy.tick(1, False)
        if pyboy.register_file.PC == spin:
            break
    else:
        sys.exit(f"ReadTrainer did not return within {FRAME_BUDGET} frames "
                 f"(PC={pyboy.register_file.PC:#06x}) -- likely a hang")

    count = mem[sym["wEnemyPartyCount"][1]]
    species_base = sym["wEnemyMon1Species"][1]
    moves_base = sym["wEnemyMon1Moves"][1]
    level_base = sym["wEnemyMon1Level"][1]

    party = []
    for i in range(min(count, 6)):
        off = i * PARTYMON_STRUCT_LENGTH
        party.append((
            mem[species_base + off],
            mem[level_base + off],
            [mem[moves_base + off + m] for m in range(num_moves)],
        ))
    return count, party


def main():
    species = {v: k for k, v in parse_consts("constants/pokemon_constants.asm").items()}
    moves = {v: k for k, v in parse_consts("constants/move_constants.asm").items()}
    classes = parse_trainer_consts()

    battle = open(os.path.join(ROOT, "constants/battle_constants.asm")).read()
    num_moves = int(re.search(r"DEF NUM_MOVES EQU (\d+)", battle).group(1))

    cases = []
    for arg in sys.argv[1:]:
        cls, _, no = arg.partition(":")
        if cls not in classes:
            sys.exit(f"unknown trainer class {cls}")
        cases.append((cls, int(no)))
    cases = cases or DEFAULT_CASES

    sym = load_symbols("ReadTrainer", "wLinkState", "wIsInBattle", "wCurOpponent",
                       "wTrainerNo", "wEnemyPartyCount", "wEnemyMon1Species",
                       "wEnemyMon1Moves", "wEnemyMon1Level")

    pyboy = PyBoy(ROM, window="null", cgb=True)
    pyboy.tick(120, False)

    failures = []
    for cls, no in cases:
        opp = 200 + classes[cls]
        count, party = read_party(pyboy, sym, opp, no, num_moves)
        print(f"\n{cls} #{no}  (wCurOpponent={opp})  party of {count}")
        for i, (sp, lvl, mv) in enumerate(party, 1):
            names = [moves.get(m, f"${m:02x}") for m in mv if m]
            print(f"  {i}. L{lvl:<3} {species.get(sp, f'${sp:02x}'):<12} {', '.join(names)}")

        want = EXPECTED.get((cls, no))
        if want:
            if count != len(want):
                failures.append(f"{cls} #{no}: party of {count}, expected {len(want)}")
            for i, (wsp, wlvl, wmove) in enumerate(want):
                if i >= len(party):
                    break
                sp, lvl, mv = party[i]
                got_names = [moves.get(m) for m in mv if m]
                if species.get(sp) != wsp:
                    failures.append(f"{cls} #{no} mon{i+1}: {species.get(sp)} != {wsp}")
                if lvl != wlvl:
                    failures.append(f"{cls} #{no} mon{i+1}: L{lvl} != L{wlvl}")
                if wmove and wmove not in got_names:
                    failures.append(f"{cls} #{no} mon{i+1}: missing {wmove}, has {got_names}")

    pyboy.stop(save=False)

    if failures:
        print("\nFAILURES:")
        for f in failures:
            print(f"  - {f}")
        sys.exit(1)
    print("\nAll probed trainers match expectations.")


if __name__ == "__main__":
    main()
