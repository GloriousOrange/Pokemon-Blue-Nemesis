#!/usr/bin/env python3
"""
Boot a Nemesis build headlessly and save screenshots (a contact sheet by default).

Lets you check visual changes -- palettes, sprites, menu layout -- without a
phone or a desktop emulator in the loop.

Setup (once):
    python3 -m venv .venv-emu && .venv-emu/bin/pip install pyboy pillow

Usage:
    .venv-emu/bin/python tools/screenshot.py pokeblue.gbc shots.png
    .venv-emu/bin/python tools/screenshot.py pokeblue.gbc shots.png --dmg
    .venv-emu/bin/python tools/screenshot.py pokeblue.gbc shots.png --scheme 1

If <rom>.sav exists it is loaded, and the script mashes START/A to get past the
title screen into the save. Notes on driving PyBoy:

  * Hold buttons for ~15+ frames. Short taps get missed, and the CONTINUE prompt
    in particular polls hJoyHeld and needs the button still down.
  * PyBoy's bundled CGB boot ROM is a 256-byte stub, but it does set A=$11, so
    the game's Game Boy Color detection works.
  * WRAM addresses in this fork are NOT vanilla pokered's; read them out of
    pokeblue.sym (e.g. wCurMap is $d397 here, not $d35e).
"""
import argparse
import os
import sys

try:
    from PIL import Image, ImageDraw
    from pyboy import PyBoy
except ImportError:
    sys.exit(__doc__.split("Setup (once):")[1].strip())

# read out of pokeblue.sym if these ever move
WCURMAP = 0xD397
WISINBATTLE = 0xD05D
WCOLORSCHEME = 0xD6AB
WONCGB = 0xCF1A


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("rom")
    ap.add_argument("out", help="output .png contact sheet")
    ap.add_argument("--dmg", action="store_true", help="run as an original Game Boy")
    ap.add_argument("--scheme", type=int, help="force wColorScheme (0 diverse, 1 neon)")
    ap.add_argument("--walk", type=int, default=10, help="overworld steps to capture")
    args = ap.parse_args()

    sav = os.path.splitext(args.rom)[0] + ".sav"
    kwargs = dict(window="null", sound_emulated=False)
    if os.path.exists(sav):
        kwargs["ram_file"] = open(sav, "rb")
    pb = PyBoy(args.rom, cgb=not args.dmg, **kwargs)
    shots = []

    def shot(name):
        shots.append((name, pb.screen.image.convert("RGB")))
        print(f"{name}: map={pb.memory[WCURMAP]} battle={pb.memory[WISINBATTLE]} onCGB={pb.memory[WONCGB]}")

    def press(btn, hold=16, then=18):
        pb.button_press(btn)
        pb.tick(hold, True)
        pb.button_release(btn)
        pb.tick(then, True)

    pb.tick(620, True)
    shot("title")

    # mash into the save, then close whatever menu the mashing opened
    for f in range(1400):
        if f % 100 == 40:
            pb.button("start", 3)
        if f % 100 == 90:
            pb.button("a", 3)
        pb.tick(1, True)
    for _ in range(6):
        press("b", hold=10, then=12)
    if args.scheme is not None:
        pb.memory[WCOLORSCHEME] = args.scheme
        pb.tick(2, True)
    shot("overworld")

    for i in range(args.walk):
        for btn in ("down", "left", "up", "right"):
            press(btn, hold=18, then=8)
        if i % 5 == 4:
            shot(f"walk_{i}")
    shot("walk_end")
    press("start", hold=16, then=40)
    shot("startmenu")
    pb.stop(save=False)

    cols = 4
    rows = (len(shots) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * 160, rows * 158), (20, 20, 20))
    draw = ImageDraw.Draw(sheet)
    for i, (name, img) in enumerate(shots):
        x, y = (i % cols) * 160, (i // cols) * 158
        sheet.paste(img, (x, y))
        draw.text((x + 3, y + 145), name, fill=(210, 210, 210))
    sheet.save(args.out)
    print("wrote", args.out)


if __name__ == "__main__":
    main()
