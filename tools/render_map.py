#!/usr/bin/env python3
"""
Render a map's .blk to a PNG, straight from the repo's own blockset/tileset.

Lets you see a map-layout change (water, shores, walls) without booting the
game and walking there. Colors come from an SGB palette row in
data/sgb/sgb_palettes.asm, so the preview shows the palette the map will
actually use -- see [PAL_ARCHIPELAGO_CAVE_LAKE] for a per-map row.

Usage:
    .venv-emu/bin/python tools/render_map.py ArchipelagoCave3F out.png
    .venv-emu/bin/python tools/render_map.py ArchipelagoCave3F out.png \
        --palette PAL_ARCHIPELAGO_CAVE_LAKE --scale 3 --grid

Tile ids are drawn over the image with --labels, which is what you want when
picking replacement blocks: the block id is printed in each block's corner.
"""
import argparse
import os
import re
import sys

try:
    from PIL import Image, ImageDraw
except ImportError:
    sys.exit("needs pillow: .venv-emu/bin/pip install pillow")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def map_dims(const):
    for line in open(os.path.join(ROOT, "constants/map_constants.asm")):
        m = re.match(r"\tmap_const (\w+),\s*(\d+),\s*(\d+)", line)
        if m and m.group(1) == const:
            return int(m.group(2)), int(m.group(3))
    sys.exit(f"no map_const for {const}")


def map_meta(name):
    """-> (map const, tileset name) from the map header."""
    hdr = os.path.join(ROOT, "data/maps/headers", name + ".asm")
    m = re.search(r"map_header \w+, (\w+), (\w+),", open(hdr).read())
    if not m:
        sys.exit(f"cannot parse {hdr}")
    return m.group(1), m.group(2).lower()


def palette(name):
    """-> 4 RGB tuples from an SGB palette row, scaled 5-bit to 8-bit."""
    for line in open(os.path.join(ROOT, "data/sgb/sgb_palettes.asm")):
        if name and name in line and line.strip().startswith("RGB"):
            nums = [int(n) for n in re.findall(r"\d+", line.split(";")[0])]
            return [tuple(round(c * 255 / 31) for c in nums[i:i + 3]) for i in range(0, 12, 3)]
    return [(255, 255, 255), (170, 170, 170), (85, 85, 85), (0, 0, 0)]


def tile_pixels(gfx, tile):
    """-> 8x8 of 0-3 shade indices for one 2bpp tile."""
    b = gfx[tile * 16:(tile + 1) * 16]
    return [[((b[y * 2 + 1] >> (7 - x)) & 1) * 2 | ((b[y * 2] >> (7 - x)) & 1)
             for x in range(8)] for y in range(8)]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("map")
    ap.add_argument("out")
    ap.add_argument("--palette", default=None, help="SGB palette row name")
    ap.add_argument("--scale", type=int, default=3)
    ap.add_argument("--grid", action="store_true", help="draw block boundaries")
    ap.add_argument("--labels", action="store_true", help="print block ids")
    args = ap.parse_args()

    const, tileset = map_meta(args.map)
    w, h = map_dims(const)
    blk = open(os.path.join(ROOT, "maps", args.map + ".blk"), "rb").read()
    bst = open(os.path.join(ROOT, "gfx/blocksets", tileset + ".bst"), "rb").read()
    gfx = open(os.path.join(ROOT, "gfx/tilesets", tileset + ".2bpp"), "rb").read()
    pal = palette(args.palette)

    img = Image.new("RGB", (w * 32, h * 32))
    px = img.load()
    for i, b in enumerate(blk[:w * h]):
        brow, bcol = divmod(i, w)
        block = bst[b * 16:(b + 1) * 16]
        for ty in range(4):
            for tx in range(4):
                pixels = tile_pixels(gfx, block[ty * 4 + tx])
                ox, oy = bcol * 32 + tx * 8, brow * 32 + ty * 8
                for y in range(8):
                    for x in range(8):
                        px[ox + x, oy + y] = pal[pixels[y][x]]

    img = img.resize((img.width * args.scale, img.height * args.scale), Image.NEAREST)
    if args.grid or args.labels:
        d = ImageDraw.Draw(img)
        s = 32 * args.scale
        if args.grid:
            for c in range(w + 1):
                d.line([(c * s, 0), (c * s, img.height)], fill=(255, 0, 0), width=1)
            for r in range(h + 1):
                d.line([(0, r * s), (img.width, r * s)], fill=(255, 0, 0), width=1)
        if args.labels:
            for i, b in enumerate(blk[:w * h]):
                r, c = divmod(i, w)
                d.text((c * s + 2, r * s + 2), "%02X" % b, fill=(255, 60, 60))

    img.save(args.out)
    print(f"wrote {args.out} ({w}x{h} blocks, tileset {tileset})")


if __name__ == "__main__":
    main()
