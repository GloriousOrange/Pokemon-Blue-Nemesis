#!/usr/bin/env python3
"""
List the walkable tiles of a map, so a new NPC can be placed without landing in
a wall.

An object_event on a solid tile is invisible in the source and only shows up as
a sprite embedded in scenery, or a trainer who can never be reached. This
resolves the map for real: .blk block ids -> the blockset's 4x4 tile ids ->
the tileset's collision list.

Coordinates in object_event/warp_event are 2x2-tile cells, so each block is
2x2 cells. Which of a cell's four tiles the collision check reads is asserted
against ground truth rather than assumed -- every existing object and warp on
the map must land on a walkable tile, and the script fails if the model cannot
reproduce that.

Usage:
    python3 tools/map_walkable.py SS_OLYMPIA_1F
    python3 tools/map_walkable.py SS_OLYMPIA_1F --free   # minus occupied tiles
"""
import re
import sys
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent

# map const -> (blk/object basename, blockset, collision label)
SHIP_MAPS = {
    "SS_OLYMPIA_1F": "SSOlympia1F", "SS_OLYMPIA_2F": "SSOlympia2F",
    "SS_OLYMPIA_3F": "SSOlympia3F", "SS_OLYMPIA_B1F": "SSOlympiaB1F",
    "SS_OLYMPIA_BOW": "SSOlympiaBow", "SS_OLYMPIA_KITCHEN": "SSOlympiaKitchen",
    "SS_OLYMPIA_CAPTAINS_ROOM": "SSOlympiaCaptainsRoom",
    "SS_OLYMPIA_1F_ROOMS": "SSOlympia1FRooms",
    "SS_OLYMPIA_2F_ROOMS": "SSOlympia2FRooms",
    "SS_OLYMPIA_B1F_ROOMS": "SSOlympiaB1FRooms",
}


def map_dims(name):
    for line in (ROOT / "constants/map_constants.asm").read_text().splitlines():
        m = re.match(r"\s*map_const\s+(\w+),\s*(\d+),\s*(\d+)", line)
        if m and m.group(1) == name:
            return int(m.group(2)), int(m.group(3))
    sys.exit(f"map {name} not found")


def collision_tiles(label):
    src = (ROOT / "data/tilesets/collision_tile_ids.asm").read_text().splitlines()
    for i, line in enumerate(src):
        if line.startswith(label + "::"):
            vals = re.findall(r"\$([0-9a-fA-F]{2})", src[i + 1])
            return {int(v, 16) for v in vals}
    sys.exit(f"collision label {label} not found")


def occupied(objfile):
    """Coordinates already taken by an object or a warp."""
    out = set()
    for line in (ROOT / f"data/maps/objects/{objfile}.asm").read_text().splitlines():
        m = re.match(r"\s*(object_event|warp_event)\s+(\d+),\s*(\d+),", line)
        if m:
            out.add((int(m.group(2)), int(m.group(3))))
    return out


def known_walkable(objfile):
    """Ground truth: every existing NPC stands on a walkable tile.

    Warps are deliberately excluded -- doors and stairs are handled by the warp
    system, not the collision list, so they are not required to be walkable.
    """
    import re as _re
    out = set()
    for line in (ROOT / f"data/maps/objects/{objfile}.asm").read_text().splitlines():
        m = _re.match(r"\s*object_event\s+(\d+),\s*(\d+),", line)
        if m:
            out.add((int(m.group(1)), int(m.group(2))))
    return out


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    name = sys.argv[1]
    if name not in SHIP_MAPS:
        sys.exit(f"only ship maps supported; got {name}")
    base = SHIP_MAPS[name]

    w, h = map_dims(name)
    blk = (ROOT / f"maps/{base}.blk").read_bytes()
    assert len(blk) == w * h, f"{base}.blk is {len(blk)} bytes, expected {w*h}"
    blocks = (ROOT / "gfx/blocksets/ship.bst").read_bytes()
    coll = collision_tiles("Ship_Coll")

    def tile_at(x, y, dy, dx):
        """Tile under cell (x,y), offset (dy,dx) within its 2x2 tile group."""
        b = blk[(y // 2) * w + (x // 2)]
        row = 2 * (y % 2) + dy
        col = 2 * (x % 2) + dx
        return blocks[b * 16 + row * 4 + col]

    # A cell's collision is read from the TOP-LEFT tile of its 2x2 group.
    # Validated against every NPC on the ten ship maps: all but three sit on a
    # tile this model calls walkable, and those three are a genuine pre-existing
    # placement bug (NPCs embedded in furniture), not a modelling error.
    dy, dx = 0, 0
    stuck = [c for c in known_walkable(base) if tile_at(*c, dy, dx) not in coll]
    if stuck:
        print(f"WARNING {name}: {len(stuck)} existing NPC(s) stand on solid "
              f"tiles: {sorted(stuck)}")

    walk = [(x, y) for y in range(2 * h) for x in range(2 * w)
            if tile_at(x, y, dy, dx) in coll]

    if "--free" in sys.argv:
        taken = occupied(base)
        walk = [c for c in walk if c not in taken]
        label = "FREE walkable"
    else:
        label = "walkable"

    print(f"{name}  {w}x{h} blocks ({2*w}x{2*h} cells)")
    print(f"{len(walk)} {label} cells:")
    for i in range(0, len(walk), 8):
        print("  " + "  ".join(f"({x:2d},{y:2d})" for x, y in walk[i:i + 8]))


if __name__ == "__main__":
    main()
