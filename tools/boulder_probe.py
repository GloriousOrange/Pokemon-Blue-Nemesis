#!/usr/bin/env python3
"""
Drive the game to a boulder and push it, to prove a Strength push does not
crash.

This exists because the boulder gray-screen could not be found by reading the
source: the object data, the map, the collision and the push routine were all
correct. The bug was a bare `jp hl` reaching a routine that had been floated
into a different ROM bank, which only shows up when the code actually runs.
Reproducing it took ~40 seconds; reading for it got nowhere twice.

REQUIRES a one-line temporary edit, because walking from a new game to the
Archipelago Cave is far too long to script:

    data/maps/objects/RedsHouse2F.asm
    -   warp_event  7,  1, REDS_HOUSE_1F, 3
    +   warp_event  3,  7, ARCHIPELAGO_CAVE_3F, 1

That puts the cave one step below the player's bed. Build with
`make blue SPEEDTEST=1` (the kit carries HM STRENGTH and the Rainbow Badge,
which is what the boulder shortcut checks), run this, then revert the warp.

Usage:
    .venv-emu/bin/python tools/boulder_probe.py pokeblue.gbc [out.png]

A healthy run walks the player down to the boulder row and shows y advancing
one cell per successful push, with wCurMap steady at $74 and PC inside ROM.
A crashed run shows wCurMap turning to garbage and PC at $0038 -- RST 38, the
CPU falling through blank $ff padding.
"""
import os
import sys

try:
    from pyboy import PyBoy
except ImportError:
    sys.exit("needs pyboy: python3 -m venv .venv-emu && .venv-emu/bin/pip install pyboy pillow")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CAVE_3F = 0x74


def load_syms():
    sym = {}
    for line in open(os.path.join(ROOT, "pokeblue.sym")):
        parts = line.split()
        if len(parts) == 2 and ":" in parts[0]:
            bank, addr = parts[0].split(":")
            sym.setdefault(parts[1], int(addr, 16))
    return sym


def main():
    rom = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "pokeblue.gbc")
    out = sys.argv[2] if len(sys.argv) > 2 else None
    sym = load_syms()
    pb = PyBoy(rom, cgb=True, window="null", sound_emulated=False, log_level="ERROR")
    mem = pb.memory

    def pos():
        return mem[sym["wCurMap"]], mem[sym["wXCoord"]], mem[sym["wYCoord"]]

    def hold(btn, frames, render=False):
        pb.button_press(btn); pb.tick(frames, render)
        pb.button_release(btn); pb.tick(10, render)

    pb.tick(620, False)
    for f in range(2600):                      # mash through the intro
        if f % 60 == 20: pb.button("a", 3)
        if f % 60 == 50: pb.button("start", 3)
        pb.tick(1, False)
    for _ in range(8):
        pb.button("b", 4); pb.tick(20, False)

    hold("down", 24)                           # step onto the temporary warp
    if pos()[0] != CAVE_3F:
        sys.exit(f"not in the cave ({pos()}) -- is the temporary warp applied?")
    for _ in range(9):
        hold("down", 20)                       # south to the boulder row
    print("reached the boulder row:", pos())

    for i in range(8):
        hold("down", 30, render=True)
        m, x, y = pos()
        print(f"  push {i+1}: map=${m:02X} x={x} y={y} PC=${pb.register_file.PC:04X}")
        if m != CAVE_3F or pb.register_file.PC == 0x0038:
            sys.exit(f"CRASHED on push {i+1}: map=${m:02X} PC=${pb.register_file.PC:04X}")

    seen = []
    for btn in ("up", "left", "down", "right", "up"):
        hold(btn, 20, render=True); seen.append(pos())
    alive = len(set(seen)) > 2 and pos()[0] == CAVE_3F
    print("post-push walk:", seen)
    print("RESULT:", "alive, pushes worked" if alive else "STUCK")
    if out:
        pb.screen.image.convert("RGB").resize((320, 288)).save(out)
        print("wrote", out)
    pb.stop(save=False)
    sys.exit(0 if alive else 1)


if __name__ == "__main__":
    main()
