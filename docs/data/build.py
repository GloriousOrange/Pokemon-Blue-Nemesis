#!/usr/bin/env python3
"""
Extract every Pokemon Nemesis data table the team builder web app needs
straight from .asm source (never the built ROM -- source is the human-
authored ground truth for a static doc site, and this needs no `make blue`
dependency to regenerate). Writes docs/data/pokemon.json, plus recolored
sprite PNGs under docs/sprites/.

Rerun this any time source data changes (a new curated Mutagenstone row, a
palette tweak, a new species) to bake the update into the static site:

    python3 docs/data/build.py

Requires Pillow (`pip install pillow`) for the sprite recolor pass.
"""
from __future__ import annotations

import json
import re
import pathlib

from PIL import Image

ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
DOCS = ROOT / "docs"
SPRITES_FRONT = DOCS / "sprites" / "front"
SPRITES_BACK = DOCS / "sprites" / "back"
SPRITES_GHOST = DOCS / "sprites" / "front_ghost"

NUM_MOVES = 5  # Mutagenstone curated moves per row

# Excluded from the species list entirely -- not real party-eligible Pokemon.
# See GetMonHeader's own special-casing in home/pokemon.asm: these three are
# cosmetic-only reuses of another species' dex data (museum fossil display,
# Lavender Tower's ghost-Marowak), never a real party member.
NON_PARTY_SPECIES = {"FOSSIL_KABUTOPS", "FOSSIL_AERODACTYL", "MON_GHOST"}


# ---------------------------------------------------------------------------
# rgbds constant parsing (const_def / const_skip / const_next -- see
# feedback_nemesis_asm_verification_gotchas: a parser that only understands
# const_def/const_skip/const silently drifts wrong after the first const_next)
# ---------------------------------------------------------------------------

def parse_consts(path, start=0):
    names, value = {}, None
    for line in (ROOT / path).read_text().splitlines():
        line = line.split(";")[0].strip()
        m = re.match(r"const_def(?:\s+(-?\w+))?$", line)
        if m:
            value = int(m.group(1), 0) if m.group(1) else start
            continue
        if value is None:
            continue
        m = re.match(r"const_next\s+(.+)$", line)
        if m:
            expr = re.sub(r"\$([0-9A-Fa-f]+)", r"0x\1", m.group(1))
            value = eval(expr, {}, {})
            continue
        m = re.match(r"const_skip(?:\s+(\d+))?$", line)
        if m:
            value += int(m.group(1) or 1)
            continue
        m = re.match(r"const\s+(\w+)$", line)
        if m:
            names[m.group(1)] = value
            value += 1
    return names


def humanize(dname_text):
    """MonsterNames' raw dname strings are all-caps ('MR.MIME', 'FARFETCH'D',
    'NIDORAN♂') -- title-case each token while leaving punctuation and the
    gender symbols alone, and make sure a period always has a following space
    ('MR.MIME' -> 'Mr. Mime')."""
    s = re.sub(r"\.(?!\s)", ". ", dname_text)
    words = [w for w in s.split(" ") if w]
    return " ".join(w[0].upper() + w[1:].lower() for w in words)


# ---------------------------------------------------------------------------
# species id / dex id maps
# ---------------------------------------------------------------------------

def load_species_ids():
    return parse_consts("constants/pokemon_constants.asm")


def load_dex_ids():
    return parse_consts("constants/pokedex_constants.asm", start=1)


def load_display_names(species_ids):
    text = (ROOT / "data/pokemon/names.asm").read_text()
    raw = re.findall(r'dname\s+"([^"]*)"', text)
    by_id = {v: k for k, v in species_ids.items()}
    names = {}
    for sid, dname in enumerate(raw, start=1):
        sp = by_id.get(sid)
        if sp:
            names[sp] = humanize(dname)
    return names


# ---------------------------------------------------------------------------
# moves: constants, stats table, display names, TM/HM numbering
# ---------------------------------------------------------------------------

def load_moves():
    move_ids = parse_consts("constants/move_constants.asm")
    by_id = {v: k for k, v in move_ids.items()}

    text = (ROOT / "data/moves/moves.asm").read_text()
    rows = re.findall(
        r"move\s+(\w+),\s*\w+,\s*(-?\d+),\s*(\w+),\s*(\d+),\s*(\d+)",
        text,
    )
    moves = {}
    for i, (name, power, mtype, acc, pp) in enumerate(rows, start=1):
        moves[name] = {
            "power": int(power),
            "type": mtype,
            "accuracy": int(acc),
            "pp": int(pp),
        }

    names_text = (ROOT / "data/moves/names.asm").read_text()
    li_names = re.findall(r'li\s+"([^"]*)"', names_text)
    for i, disp in enumerate(li_names, start=1):
        name = by_id.get(i)
        if name in moves:
            moves[name]["display_name"] = humanize(disp)

    # TM/HM numbering: HMs are numbered first (54-59) but listed as HM01-06 in
    # game text, then TMs (1-53) -- see constants/item_constants.asm's
    # add_hm/add_tm macro order, confirmed directly against source.
    item_text = (ROOT / "constants/item_constants.asm").read_text()
    hm_block = re.search(r"DEF HM01 EQU const_value(.*?)DEF NUM_HMS", item_text, re.DOTALL).group(1)
    tm_block = re.search(r"DEF TM01 EQU const_value(.*?)ASSERT NUM_TMS", item_text, re.DOTALL).group(1)
    for i, name in enumerate(re.findall(r"add_hm\s+(\w+)", hm_block), start=1):
        if name in moves:
            moves[name]["tm_number"] = f"HM{i:02d}"
    for i, name in enumerate(re.findall(r"add_tm\s+(\w+)", tm_block), start=1):
        if name in moves:
            moves[name]["tm_number"] = f"TM{i:02d}"

    return moves


# ---------------------------------------------------------------------------
# type chart: dense NxN matrix, default 1.0 overlaid with type_matchups.asm's
# explicit rows (values are tenths -- SUPER_EFFECTIVE=20, NOT_VERY_EFFECTIVE=5,
# NO_EFFECT=0)
# ---------------------------------------------------------------------------

def load_types():
    consts = parse_consts("constants/type_constants.asm")
    # UNUSED_TYPES/UNUSED_TYPES_END/NUM_TYPES/PHYSICAL/SPECIAL are DEF markers,
    # not `const` entries, so they never appear in consts. BIRD ($06) *is* a
    # real const, but it's Gen 1's well-known dead type slot -- never assigned
    # to any move or Pokemon in vanilla or Nemesis -- so drop it explicitly;
    # every other remaining name is a real, usable type.
    del consts["BIRD"]
    return list(consts.keys())


def load_type_chart(types):
    chart = {atk: {defn: 1.0 for defn in types} for atk in types}
    text = (ROOT / "data/types/type_matchups.asm").read_text()
    for m in re.finditer(r"db\s+(\w+),\s*(\w+),\s*(\w+)", text):
        atk, defn, mult = m.groups()
        if atk not in chart or defn not in chart[atk]:
            continue
        chart[atk][defn] = {"SUPER_EFFECTIVE": 2.0, "NOT_VERY_EFFECTIVE": 0.5, "NO_EFFECT": 0.0}[mult]
    return chart


# ---------------------------------------------------------------------------
# evolution graph + learnsets (data/pokemon/evos_moves.asm)
# ---------------------------------------------------------------------------

def resolve_evo_label(label_upper, species_ids):
    if label_upper in species_ids:
        return label_upper
    for name in species_ids:
        if name.replace("_", "") == label_upper.replace("_", ""):
            return name
    return None


def load_evos_moves(species_ids):
    text = (ROOT / "data/pokemon/evos_moves.asm").read_text()
    # Slice between successive label POSITIONS, not a lookahead regex -- an
    # earlier lookahead approach broke across multi-line comments sitting
    # between two blocks (PinsiriteEvosMoves's own header comment), silently
    # merging unrelated species' learnsets. See
    # feedback_nemesis_asm_verification_gotchas for the full story.
    marks = list(re.finditer(r"(\w+)EvosMoves:", text))
    blocks = []
    for i, m in enumerate(marks):
        end = marks[i + 1].start() if i + 1 < len(marks) else len(text)
        blocks.append((m.group(1), text[m.end():end]))

    level_evo = {}
    learnsets = {}
    for label, body in blocks:
        sp = resolve_evo_label(label.upper(), species_ids)
        if sp is None:
            continue
        eq = re.search(r"db EVOLVE_LEVEL, \d+, (\w+)", body)
        if eq:
            level_evo[sp] = eq.group(1)
        moves = re.findall(r"db (\d+), (\w+)\n", body)
        learnsets[sp] = [(int(lvl), mv) for lvl, mv in moves]
    return level_evo, learnsets


def final_form(sp, level_evo):
    seen = set()
    while sp in level_evo and sp not in seen:
        seen.add(sp)
        sp = level_evo[sp]
    return sp


# ---------------------------------------------------------------------------
# curated Mutagenstone rows
# ---------------------------------------------------------------------------

def load_mutagen_movesets():
    text = (ROOT / "data/pokemon/mutagen_movesets.asm").read_text()
    rows = {}
    for line in text.splitlines():
        m = re.match(r"\tmutagen_moveset (\w+),\s*([A-Z0-9_,\s]+)$", line)
        if not m:
            continue
        moves = [mv.strip() for mv in m.group(2).split(",") if mv.strip()][:NUM_MOVES]
        if len(moves) == NUM_MOVES:
            rows[m.group(1)] = moves
    return rows


# ---------------------------------------------------------------------------
# base_stats/*.asm -- the main per-species record
# ---------------------------------------------------------------------------

def load_pics_paths():
    """Label (e.g. 'RhydonPicFront') -> literal INCBIN path, straight from
    gfx/pics.asm -- sprite filenames must never be derived from the species
    name (Mr. Mime's file is 'mr.mime.pic'; Alakachamp's own INCBIN reuses
    Machamp's art directly, no dedicated Alakachamp art exists)."""
    paths = {}
    # Mew is a genuine Gen 1 quirk: it wasn't part of the original 150 and its
    # pic labels are defined in data/pokemon/mew.asm, not gfx/pics.asm.
    for rel in ("gfx/pics.asm", "data/pokemon/mew.asm"):
        text = (ROOT / rel).read_text()
        for m in re.finditer(r'(\w+)::\s*INCBIN\s+"([^"]+)"', text):
            paths[m.group(1)] = m.group(2)
    return paths


def base_moves(text):
    m = re.search(r"db ([A-Z0-9_, ]+) ;[^\n]*\n\tdb GROWTH_\w+ ; growth rate", text)
    if not m:
        return []
    return [mv.strip() for mv in m.group(1).split(",") if mv.strip() != "NO_MOVE"]


def tmhm_list(text):
    m = re.search(r"tmhm(.*?)\n\t; end", text, re.DOTALL)
    if not m:
        return []
    raw = m.group(1).replace("\\", "").replace("\n", " ")
    return [mv.strip() for mv in raw.split(",") if mv.strip()]


def stat_line(text):
    m = re.search(r"db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\n\s*;\s*hp\s*atk\s*def\s*spd\s*spc", text)
    hp, atk, de, spd, spc = (int(x) for x in m.groups())
    return {"hp": hp, "atk": atk, "def": de, "spd": spd, "spc": spc}


def type_line(text):
    m = re.search(r"db (\w+), (\w+) ; type", text)
    t1, t2 = m.group(1), m.group(2)
    return [t1] if t1 == t2 else [t1, t2]


def sprite_labels(text):
    m = re.search(r"dw (\w+)PicFront, (\w+)PicBack", text)
    return f"{m.group(1)}PicFront", f"{m.group(2)}PicBack"


def load_ghost_eligible():
    text = (ROOT / "scripts/ChampionsRoom.asm").read_text()
    m = re.search(r"Rival3StarterTable:\n((?:\tdb \w+, \d+\n)+)", text)
    return {line.split(",")[0].replace("\tdb ", "").strip() for line in m.group(1).splitlines() if line.strip()}


# ---------------------------------------------------------------------------
# palettes: MonsterPalettes (dex-indexed) + SuperPalettes (PAL_ id-indexed,
# respecting the _RED/_BLUE branches -- this build is Blue-only)
# ---------------------------------------------------------------------------

def load_pal_assignments(dex_ids):
    text = (ROOT / "data/pokemon/palettes.asm").read_text()
    # Position, not the trailing comment text, is authoritative -- rows are
    # written in DEX order (index 0 = MISSINGNO, unused).
    pal_lines = re.findall(r"^\tdb (PAL_\w+)", text, re.MULTILINE)
    by_dex = {v: k[len("DEX_"):] for k, v in dex_ids.items()}
    assign_by_species = {}
    for dex, pal in enumerate(pal_lines):
        if dex == 0:
            continue
        sp = by_dex.get(dex)
        if sp:
            assign_by_species[sp] = pal
    return assign_by_species


def load_sgb_ramps():
    """PAL_ constant name -> list of 4 (r,g,b) tuples, 0-31 scale, white/
    light/dark/black order (matches DMG_SHADES order used for recoloring)."""
    pal_ids = parse_consts("constants/palette_constants.asm")
    # only the second const_def block (sgb palettes) matters here; the first
    # (SET_PAL_*) shares no names with it so a name-based lookup is safe
    text = (ROOT / "data/sgb/sgb_palettes.asm").read_text()

    # Strip conditional branches to the _BLUE-only lines -- this build never
    # defines _RED, so an _RED-only line would misalign every row after it.
    def strip_conditionals(t):
        out = []
        skip = False
        mode = None  # None, 'red', 'blue'
        for line in t.splitlines():
            s = line.strip()
            if s == "IF DEF(_RED)":
                mode = "red"
                continue
            if s == "IF DEF(_BLUE)":
                mode = "blue"
                continue
            if s == "ENDC":
                mode = None
                continue
            if mode == "red":
                continue
            out.append(line)
        return "\n".join(out)

    clean = strip_conditionals(text)
    rows = re.findall(r"RGB\s+([\d,\s]+?)\s*;", clean)
    ramps = {}
    by_id = {v: k for k, v in pal_ids.items()}
    for i, row in enumerate(rows):
        nums = [int(n) for n in row.split(",") if n.strip()]
        if len(nums) != 12:
            continue
        ramp = [tuple(nums[j:j + 3]) for j in range(0, 12, 3)]
        pal_name = by_id.get(i)
        if pal_name:
            ramps[pal_name] = ramp
    return ramps


# ---------------------------------------------------------------------------
# sprite recoloring (ported from PKMN-Nemesis/tools/palette_preview.py)
# ---------------------------------------------------------------------------

DMG_SHADES = (255, 170, 85, 0)  # white, light, dark, black -- matches RGB row order


def to_rgb255(components):
    return tuple(round(v * 255 / 31) for v in components)


def recolor(img, ramp):
    img = img.convert("RGBA")
    px = img.load()
    lut = {shade: to_rgb255(c) for shade, c in zip(DMG_SHADES, ramp)}
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            gray = min(DMG_SHADES, key=lambda s: abs(s - r))
            px[x, y] = (*lut[gray], a)
    return img


def render_sprite(src_path, ramp, out_path):
    # gfx/pics.asm's INCBIN paths point at the compiled .pic (raw 2bpp) --
    # the human-editable grayscale source sits alongside it as a .png.
    png_path = ROOT / re.sub(r"\.pic$", ".png", src_path)
    img = Image.open(png_path)
    recolor(img, ramp).save(out_path)


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    species_ids = load_species_ids()
    dex_ids = load_dex_ids()
    display_names = load_display_names(species_ids)
    moves = load_moves()
    types = load_types()
    type_chart = load_type_chart(types)
    level_evo, learnsets = load_evos_moves(species_ids)
    mutagen = load_mutagen_movesets()
    pics = load_pics_paths()
    ghost_eligible = load_ghost_eligible()
    pal_assign = load_pal_assignments(dex_ids)
    sgb_ramps = load_sgb_ramps()

    eligible_species = {n for n in species_ids if n != "NO_MON" and n not in NON_PARTY_SPECIES and n != "DITTO"}
    final_endpoints = {final_form(sp, level_evo) for sp in eligible_species}

    ghostmon_ramp = sgb_ramps["PAL_GHOSTMON"]

    species_out = {}
    for f in sorted((ROOT / "data/pokemon/base_stats").glob("*.asm")):
        text = f.read_text()
        dex_m = re.search(r"db DEX_(\w+) ; pokedex id", text)
        if not dex_m:
            continue
        sp = dex_m.group(1)
        if sp not in species_ids:
            continue

        stats = stat_line(text)
        sp_types = type_line(text)
        base = base_moves(text)
        tmhm = tmhm_list(text)
        front_label, back_label = sprite_labels(text)
        front_src = pics.get(front_label)
        back_src = pics.get(back_label)

        lvl_moves = [{"level": 1, "move": mv} for mv in base]
        lvl_moves += [{"level": lvl, "move": mv} for lvl, mv in learnsets.get(sp, [])]

        pal_name = pal_assign.get(sp)
        ramp = sgb_ramps.get(pal_name) if pal_name else None

        slug = sp.lower()
        front_out = None
        back_out = None
        ghost_out = None
        if front_src and ramp:
            front_out = f"sprites/front/{slug}.png"
            render_sprite(front_src, ramp, SPRITES_FRONT / f"{slug}.png")
        if back_src and ramp:
            back_out = f"sprites/back/{slug}.png"
            render_sprite(back_src, ramp, SPRITES_BACK / f"{slug}.png")
        if front_src and sp in ghost_eligible:
            ghost_out = f"sprites/front_ghost/{slug}.png"
            render_sprite(front_src, ghostmon_ramp, SPRITES_GHOST / f"{slug}.png")

        species_out[sp] = {
            "display_name": display_names.get(sp, sp.title()),
            "dex_number": dex_ids.get(f"DEX_{sp}"),
            "base_stats": stats,
            "types": sp_types,
            "front_sprite": front_out,
            "back_sprite": back_out,
            "ghost_sprite": ghost_out,
            "ghost_eligible": sp in ghost_eligible,
            "level_up_moves": lvl_moves,
            "tm_hm_moves": tmhm,
            "mutagen_moveset": mutagen.get(sp),
            "final_evolution_of_self": sp in final_endpoints,
        }

    data = {
        "meta": {
            "num_pokemon": len(species_out),
            "num_moves": len(moves),
        },
        "types": types,
        "type_chart": type_chart,
        "moves": moves,
        "species": species_out,
    }

    out_path = DOCS / "data" / "pokemon.json"
    out_path.write_text(json.dumps(data, indent=1, ensure_ascii=False))
    print(f"wrote {out_path} -- {len(species_out)} species, {len(moves)} moves")
    print(f"ghost-eligible sprites rendered: {sum(1 for s in species_out.values() if s['ghost_sprite'])}")
    curated = sum(1 for s in species_out.values() if s["mutagen_moveset"])
    print(f"curated mutagen movesets: {curated}")


if __name__ == "__main__":
    main()
