#!/usr/bin/env python3
"""
Recompute, fresh every run, which species still need a curated Mutagenstone
row -- and dump everything needed to draft the next batch without
re-deriving it by hand.

Never trust a hand-remembered "N remaining" count; this walks the real
source each time:
  1. every species id in constants/pokemon_constants.asm, minus NO_MON and
     the three non-party-eligible specials (FOSSIL_KABUTOPS, FOSSIL_AERODACTYL,
     MON_GHOST -- cosmetic-only, never real party members, see home/pokemon.asm's
     GetMonHeader special cases)
  2. each species' final LEVEL-evolution form, by walking evos_moves.asm
     (EVOLVE_TRADE edges are ignored when an EVOLVE_LEVEL edge to the same
     target also exists -- that's the one that actually functions in this
     mod, e.g. Machoke/Kadabra)
  3. the distinct set of final-evolution species is everyone eligible for a
     row; diff against data/pokemon/mutagen_movesets.asm's current rows

Usage:
    python3 tools/mutagen_remaining.py            # summary + full detail on
                                                    # the next 5 remaining
    python3 tools/mutagen_remaining.py --all       # detail on everyone remaining
    python3 tools/mutagen_remaining.py --count     # just the numbers
"""
import re
import sys
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
BATCH_SIZE = 5


def parse_consts(path, start=0):
    """const_def takes an optional start value (pokedex_constants.asm uses
    `const_def 1`) and const_next jumps the counter to an absolute value
    (event_constants.asm-style) -- both handled, since both classes of bug
    have bitten this project's tooling before."""
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


EXCLUDED = {
    "NO_MON", "FOSSIL_KABUTOPS", "FOSSIL_AERODACTYL", "MON_GHOST",
    # Josh, 2026-08-02: leave DITTO alone permanently -- it has no TM/HM list
    # at all and its whole identity is Transform, so there's no broader
    # movepool to draw a curated 5-move upgrade from the way every other
    # species gets one. Not a "revisit later," a standing decision.
    "DITTO",
}


def load_species():
    species = parse_consts("constants/pokemon_constants.asm")
    return {name: sid for name, sid in species.items() if name not in EXCLUDED}


def load_base_stats_file(species_name):
    """Map a species constant name to its base_stats/*.asm file by reading
    each file's own `db DEX_X` line -- DEX_<NAME> matches the species
    constant name exactly for every species (verified), so this needs no
    dex-number bridging at all."""
    for f in (ROOT / "data/pokemon/base_stats").glob("*.asm"):
        text = f.read_text()
        m = re.search(r"db DEX_(\w+) ; pokedex id", text)
        if m and m.group(1) == species_name:
            return f, text
    return None, None


def resolve_evo_label(label_upper, species):
    """EvosMoves labels are a loose title-case of the species name (e.g.
    NidoranMEvosMoves for NIDORAN_M) -- exact-match first, else compare with
    underscores stripped from both sides."""
    if label_upper in species:
        return label_upper
    for name in species:
        if name.replace("_", "") == label_upper.replace("_", ""):
            return name
    return None


def load_evos_moves(species):
    text = (ROOT / "data/pokemon/evos_moves.asm").read_text()
    # Split on the actual label POSITIONS, not a lookahead -- an earlier
    # version's `(?=\n\w+EvosMoves:|\Z)` lookahead required the next label to
    # immediately follow a bare newline, which breaks whenever a multi-line
    # comment sits between two blocks (e.g. PinsiriteEvosMoves's own header
    # comment). That silently merged MewthreeEvosMoves's block with the three
    # mutant species' blocks that follow it, since the lookahead only found
    # its next match after skipping all of them. Slicing between successive
    # label positions is boundary-proof regardless of what's between blocks.
    marks = list(re.finditer(r"(\w+)EvosMoves:", text))
    blocks = []
    for i, m in enumerate(marks):
        end = marks[i + 1].start() if i + 1 < len(marks) else len(text)
        blocks.append((m.group(1), text[m.end():end]))
    level_evo = {}
    learnsets = {}
    for label, body in blocks:
        src = resolve_evo_label(label.upper(), species)
        if src is None:
            continue
        m = re.search(r"db EVOLVE_LEVEL, \d+, (\w+)", body)
        if m:
            level_evo[src] = m.group(1)
        moves = re.findall(r"db (\d+), (\w+)\n", body)
        # the Learnset section comes after "; Learnset"; the Evolutions
        # section's own db lines don't match `db LEVEL, MOVE` shape (they're
        # `db EVOLVE_X, ...` or a bare `db 0`), so this regex only ever
        # matches real learnset entries
        learnsets[src] = [(int(lvl), mv) for lvl, mv in moves]
    return level_evo, learnsets


def final_form(sp, level_evo):
    seen = set()
    while sp in level_evo and sp not in seen:
        seen.add(sp)
        sp = level_evo[sp]
    return sp


def load_curated():
    text = (ROOT / "data/pokemon/mutagen_movesets.asm").read_text()
    return {m.group(1) for m in re.finditer(r"\tmutagen_moveset (\w+),", text)}


def base_moves(text):
    m = re.search(r"db ([A-Z0-9_, ]+) ; level 1 learnset", text)
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
    if not m:
        return None
    hp, atk, de, spd, spc = (int(x) for x in m.groups())
    return {"hp": hp, "atk": atk, "def": de, "spd": spd, "spc": spc}


def type_line(text):
    m = re.search(r"db (\w+), (\w+) ; type", text)
    return (m.group(1), m.group(2)) if m else (None, None)


def main():
    species = load_species()
    level_evo, learnsets = load_evos_moves(species)
    curated = load_curated()

    endpoints = sorted({final_form(sp, level_evo) for sp in species})
    remaining = [e for e in endpoints if e not in curated]

    print(f"eligible final-evolution species: {len(endpoints)}")
    print(f"already curated: {len(endpoints) - len(remaining)}")
    print(f"REMAINING: {len(remaining)}\n")

    if "--count" in sys.argv:
        return

    show = remaining if "--all" in sys.argv else remaining[:BATCH_SIZE]
    print(f"showing {len(show)} of {len(remaining)}:\n")

    for name in show:
        f, text = load_base_stats_file(name)
        if text is None:
            print(f"=== {name} === (base_stats file not found -- check resolve_evo_label)")
            continue
        stats = stat_line(text)
        t1, t2 = type_line(text)
        moves = base_moves(text) + [mv for _, mv in learnsets.get(name, [])]
        tms = tmhm_list(text)

        print(f"=== {name} ===  {t1}/{t2}" if t2 != t1 else f"=== {name} ===  {t1}")
        if stats:
            print(f"  HP {stats['hp']}  ATK {stats['atk']}  DEF {stats['def']}  "
                  f"SPD {stats['spd']}  SPC {stats['spc']}")
        lvl_moves = base_moves(text) + [f"{lvl}:{mv}" for lvl, mv in learnsets.get(name, [])]
        print(f"  level-up: {', '.join(base_moves(text))}"
              + (", " + ", ".join(f"L{lvl} {mv}" for lvl, mv in learnsets.get(name, [])) if learnsets.get(name) else ""))
        print(f"  tm/hm: {', '.join(tms)}")
        print()


if __name__ == "__main__":
    main()
