#!/usr/bin/env python3
"""
Verify AllOlympiaTrainersBeaten (scripts/SSOlympiaBow.asm) on hardware: it
must return Z (locked) when any of the ship's 39 trainers is unbeaten, and NZ
(unlocked) only once every one of them is. Also confirms the deck rival's
toggle object actually flips when SSOlympiaBowSetRivalVisibilityScript runs.

Same crit_probe.py WRAM-stub trick.

Usage:
    .venv-emu/bin/python tools/olympia_gate_probe.py
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
FRAME_BUDGET = 30


def parse_consts(path, start=0):
    """A second, independent bug from the same family as the DEX numbering
    one: this file (constants/event_constants.asm) uses `const_next $XXX`
    throughout to jump the running counter to an absolute value -- a version
    of this parser that didn't handle it computed wildly wrong event indices
    for everything past the first jump, which meant an earlier run of this
    probe was poking the WRONG WRAM bits entirely and "failing" against a
    routine that was very likely correct the whole time."""
    names, value = {}, None
    for line in open(os.path.join(ROOT, path)):
        line = line.split(";")[0].strip()
        m = re.match(r"const_def(?:\s+(-?\w+))?$", line)
        if m:
            value = int(m.group(1), 0) if m.group(1) else start
        elif value is not None:
            mm = re.match(r"const_next\s+(.+)$", line)
            if mm:
                expr = re.sub(r"\$([0-9A-Fa-f]+)", r"0x\1", mm.group(1))
                value = eval(expr, {}, {})  # e.g. "$F0 - 2" -> "0xF0 - 2"
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


TRAINER_FLAGS = [
    "EVENT_BEAT_SS_OLYMPIA_1F_TRAINER_0", "EVENT_BEAT_SS_OLYMPIA_1F_TRAINER_1",
    "EVENT_BEAT_SS_OLYMPIA_2F_TRAINER_0", "EVENT_BEAT_SS_OLYMPIA_2F_TRAINER_1",
    "EVENT_BEAT_SS_OLYMPIA_3F_TRAINER_0",
    "EVENT_BEAT_SS_OLYMPIA_B1F_TRAINER_0", "EVENT_BEAT_SS_OLYMPIA_B1F_TRAINER_1",
    "EVENT_BEAT_SS_OLYMPIA_BOW_TRAINER_0", "EVENT_BEAT_SS_OLYMPIA_BOW_TRAINER_1",
    "EVENT_BEAT_SS_OLYMPIA_KITCHEN_TRAINER_0",
    "EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_0", "EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_1",
    "EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_2",
    "EVENT_BEAT_SS_OLYMPIA_2FROOMS_TRAINER_0", "EVENT_BEAT_SS_OLYMPIA_2FROOMS_TRAINER_1",
    "EVENT_BEAT_SS_OLYMPIA_2FROOMS_TRAINER_2",
    "EVENT_BEAT_SS_OLYMPIA_B1FROOMS_TRAINER_0", "EVENT_BEAT_SS_OLYMPIA_B1FROOMS_TRAINER_1",
    "EVENT_BEAT_SS_OLYMPIA_B1FROOMS_TRAINER_2",
]


def build_stub(bank, addr):
    return bytes([
        0x3E, bank, 0xEA, 0x00, 0x20, 0xE0, 0xB8,
        0xCD, addr & 0xFF, addr >> 8,
        0x18, 0xFE,
    ])


def call_gate(pyboy, sym, bank_addr):
    mem = pyboy.memory
    mem[0xFFFF] = 0
    mem[0xFF0F] = 0
    stub = build_stub(*bank_addr)
    for off, b in enumerate(stub):
        mem[STUB + off] = b
    pyboy.register_file.SP = STACK
    pyboy.register_file.PC = STUB
    pyboy.register_file.F = 0  # clear Z going in, so a false "already NZ" can't leak through
    spin = STUB + len(stub) - 2
    for _ in range(FRAME_BUDGET):
        pyboy.tick(1, False)
        if pyboy.register_file.PC == spin:
            break
    else:
        sys.exit(f"did not return within {FRAME_BUDGET} frames -- hang")
    return bool(pyboy.register_file.F & 0x80)  # Z flag


def main():
    events = parse_consts("constants/event_constants.asm")
    sym = load_symbols("AllOlympiaTrainersBeaten", "wEventFlags",
                       "wOlympiaTrainerFlags", "wOlympiaTrainerFlags2",
                       "SSOlympiaBowSetRivalVisibilityScript",
                       "wToggleableObjectFlags", "wCurMap")

    pyboy = PyBoy(ROM, window="null", cgb=True)
    pyboy.tick(600, False)
    mem = pyboy.memory
    ev_base = sym["wEventFlags"][1]
    gate = sym["AllOlympiaTrainersBeaten"]

    def clear_all():
        for i in range(3):
            mem[sym["wOlympiaTrainerFlags"][1] + i] = 0
        mem[sym["wOlympiaTrainerFlags2"][1]] = 0
        # zero just the bytes the 20 flags live in, to avoid disturbing unrelated events
        for name in TRAINER_FLAGS:
            byte = events[name] // 8
            mem[ev_base + byte] = 0

    def set_event(name):
        v = events[name]
        byte, bit = v // 8, v % 8
        mem[ev_base + byte] |= (1 << bit)

    print("--- case: nothing beaten ---")
    clear_all()
    z = call_gate(pyboy, sym, gate)
    print(f"AllOlympiaTrainersBeaten: Z={z} (want True/locked)")
    if not z:
        sys.exit("FAIL: gate reports unlocked with nothing beaten")

    print("--- case: 20 event-flag trainers beaten, 18-bit trainers not ---")
    clear_all()
    for name in TRAINER_FLAGS:
        set_event(name)
    z = call_gate(pyboy, sym, gate)
    print(f"AllOlympiaTrainersBeaten: Z={z} (want True/locked -- 18 more still owed)")
    if not z:
        sys.exit("FAIL: gate reports unlocked with the 18-bit trainers still unbeaten")

    print("--- case: everything beaten ---")
    clear_all()
    for name in TRAINER_FLAGS:
        set_event(name)
    mem[sym["wOlympiaTrainerFlags"][1] + 0] = 0xCF
    mem[sym["wOlympiaTrainerFlags"][1] + 1] = 0xFE
    mem[sym["wOlympiaTrainerFlags"][1] + 2] = 0x63
    mem[sym["wOlympiaTrainerFlags2"][1]] = 1 << 6
    z = call_gate(pyboy, sym, gate)
    print(f"AllOlympiaTrainersBeaten: Z={z} (want False/unlocked)")
    if z:
        sys.exit("FAIL: gate still reports locked with everyone beaten")

    print("--- case: one single 18-bit trainer missing (bit 22, Juggler) ---")
    mem[sym["wOlympiaTrainerFlags"][1] + 2] = 0x63 & ~(1 << (22 - 16))
    z = call_gate(pyboy, sym, gate)
    print(f"AllOlympiaTrainersBeaten: Z={z} (want True/locked -- one holdout)")
    if not z:
        sys.exit("FAIL: gate ignored a single missing bit")

    print("\n--- toggle visibility: hidden -> shown once everything is beaten ---")
    # wToggleableObjectFlags: "bit set = toggled off" (ram/wram.asm). A freshly
    # booted, map-never-loaded WRAM starts every bit CLEAR (= shown by
    # default), which is NOT what real play looks like -- the map's own load
    # code applies the default OFF state (bit SET = hidden) from
    # data/maps/toggleable_objects.asm before the player ever sees it. Preset
    # the bit to simulate that, so ShowObject clearing it is an observable,
    # meaningful change rather than a no-op on an already-clear bit.
    TOGGLE_RIVAL = 234  # constants/toggle_constants.asm
    toggle_flags = sym["wToggleableObjectFlags"][1]
    byte, bit = TOGGLE_RIVAL // 8, TOGGLE_RIVAL % 8
    mem[sym["wOlympiaTrainerFlags"][1] + 2] = 0x63
    mem[toggle_flags + byte] |= (1 << bit)  # simulate hidden-by-default
    before = mem[toggle_flags + byte]
    z = call_gate(pyboy, sym, sym["SSOlympiaBowSetRivalVisibilityScript"])
    after = mem[toggle_flags + byte]
    print(f"byte {byte} bit {bit}: before={before:#04x} after={after:#04x}")
    if after & (1 << bit):
        sys.exit("FAIL: still hidden after the reveal script ran with everyone beaten")
    print("rival's hidden bit cleared -- ShowObject fired correctly")

    print("\n--- toggle visibility: shown -> hidden again if not everyone is beaten ---")
    mem[sym["wOlympiaTrainerFlags"][1] + 2] = 0x63 & ~(1 << (22 - 16))  # un-beat Juggler
    call_gate(pyboy, sym, sym["SSOlympiaBowSetRivalVisibilityScript"])
    after2 = mem[toggle_flags + byte]
    print(f"byte {byte} bit {bit}: after={after2:#04x}")
    if not (after2 & (1 << bit)):
        sys.exit("FAIL: rival stayed visible after un-beating a trainer")
    print("rival hidden again -- HideObject fired correctly")

    pyboy.stop(save=False)
    print("\nAll gate cases pass.")


if __name__ == "__main__":
    main()
