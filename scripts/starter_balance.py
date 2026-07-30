#!/usr/bin/env python3
"""
Nemesis solo-run viability: rank pickable starters by early-game damage output.

Two separate questions, kept apart on purpose:
  1. RAW OFFENCE  - expected damage vs a neutral L5 Rattata (no type luck either
     way), i.e. "does this thing have a decent move at all".
  2. THE FIRST GATE - can it actually beat Megan's L2 Slowpoke on Route 1,
     including who moves first.

Model: DV 8 both sides, no stat exp, no crits, STAB 1.5x, real type chart,
expected damage = damage * accuracy. Starter received at L5 (OaksLab.asm).
Evolution chains walked by level. Mimic/Transform count as no damage of their own.
"""
import math
import os
import re
from collections import defaultdict

BASE = os.path.dirname(os.path.abspath(__file__)) + "/.."
BORROWED = {"MIMIC", "TRANSFORM", "METRONOME", "MIRROR_MOVE"}
# multi-hit moves land more than once, so listed power understates them
HIT_MULT = {"TWO_TO_FIVE_ATTACKS_EFFECT": 3.0, "ATTACK_TWICE_EFFECT": 2.0,
            "TWINEEDLE_EFFECT": 2.0}


def eff_power(move):
    mv = MOVES[move]
    return mv["power"] * HIT_MULT.get(mv["effect"], 1.0)

MOVES = {}
for line in open(f"{BASE}/data/moves/moves.asm"):
    m = re.match(r"\s*move\s+(\w+),\s*(\w+),\s*(\d+),\s*(\w+),\s*(\d+),\s*(\d+)", line)
    if m:
        MOVES[m.group(1)] = dict(effect=m.group(2), power=int(m.group(3)),
                                 type=m.group(4), acc=int(m.group(5)), pp=int(m.group(6)))

EFF = {"SUPER_EFFECTIVE": 2.0, "NOT_VERY_EFFECTIVE": 0.5, "NO_EFFECT": 0.0}
CHART = {}
for line in open(f"{BASE}/data/types/type_matchups.asm"):
    m = re.match(r"\s*db\s+(\w+),\s*(\w+),\s*(\w+)", line)
    if m and m.group(3) in EFF:
        CHART[(m.group(1), m.group(2))] = EFF[m.group(3)]

SPECIAL_TYPES = {"WATER", "GRASS", "FIRE", "ELECTRIC", "PSYCHIC_TYPE", "ICE", "DRAGON"}

MON = {}
for fn in os.listdir(f"{BASE}/data/pokemon/base_stats"):
    txt = open(f"{BASE}/data/pokemon/base_stats/{fn}").read()
    sm = re.search(r"db\s+(\d+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\s*\n\s*;\s*hp", txt)
    tm = re.search(r"db\s+(\w+),\s*(\w+)\s*;\s*type", txt)
    lm = re.search(r"db\s+([\w, ]+);\s*level 1 learnset", txt)
    if sm and tm and lm:
        MON[fn[:-4]] = dict(
            hp=int(sm.group(1)), atk=int(sm.group(2)), df=int(sm.group(3)),
            spd=int(sm.group(4)), spc=int(sm.group(5)),
            types=[tm.group(1), tm.group(2)],
            moves=[x.strip() for x in lm.group(1).split(",") if x.strip() not in ("NO_MOVE", "")])


def mon(c):
    return MON.get(c.lower().replace("_", ""), MON.get(c.lower()))


EVOS, LEARN = defaultdict(list), defaultdict(list)
cur = None
for line in open(f"{BASE}/data/pokemon/evos_moves.asm"):
    m = re.match(r"^(\w+)EvosMoves:", line)
    if m:
        cur = m.group(1).upper()
        continue
    if not cur:
        continue
    m = re.match(r"\s*db\s+EVOLVE_LEVEL,\s*(\d+),\s*(\w+)", line)
    if m:
        EVOS[cur].append((int(m.group(1)), m.group(2)))
        continue
    m = re.match(r"\s*db\s+(\d+),\s*(\w+)", line)
    if m and m.group(2) in MOVES:
        LEARN[cur].append((int(m.group(1)), m.group(2)))


def key(c):
    return c.upper().replace("_", "")


def chain_at(const, level):
    sp, moves, seen = const, list(mon(const)["moves"]), set()
    while True:
        for lv, mv in LEARN.get(key(sp), []):
            if lv <= level:
                moves.append(mv)
        nxt = [(lv, s) for lv, s in EVOS.get(key(sp), []) if lv <= level]
        if not nxt or sp in seen or mon(nxt[0][1]) is None:
            break
        seen.add(sp)
        sp = nxt[0][1]
    return sp, list(dict.fromkeys(moves))


def stat(base, lv, hp=False):
    if hp:
        return int(((base + 8) * 2 * lv) / 100) + lv + 10
    return int(((base + 8) * 2 * lv) / 100) + 5


def tmult(t, dts):
    m = 1.0
    for dt in set(dts):
        m *= CHART.get((t, dt), 1.0)
    return m


def dmg(ac, al, move, dc, dl):
    a, d, mv = mon(ac), mon(dc), MOVES[move]
    if mv["power"] == 0 or move in BORROWED:
        return 0.0
    if mv["type"] in SPECIAL_TYPES:
        A, D = stat(a["spc"], al), stat(d["spc"], dl)
    else:
        A, D = stat(a["atk"], al), stat(d["df"], dl)
    out = ((((2 * al / 5) + 2) * eff_power(move) * A / D) / 50) + 2
    if mv["type"] in a["types"]:
        out *= 1.5
    return out * tmult(mv["type"], d["types"]) * (mv["acc"] / 100.0)


def best(ac, al, dc, dl, moves):
    b, bd = None, 0.0
    for mv in moves:
        x = dmg(ac, al, mv, dc, dl)
        if x > bd:
            b, bd = mv, x
    return b, bd


starters = []
grab = False
for line in open(f"{BASE}/scripts/OaksLab.asm"):
    if line.startswith("StarterSpeciesTable:"):
        grab = True
        continue
    if grab:
        m = re.match(r"\s*db\s+(\w+)\s*;", line)
        if m:
            starters.append(m.group(1))
        elif line.strip() and not line.strip().startswith(";"):
            break

rows = []
for s in starters:
    if mon(s) is None:
        continue
    sp5, mv5 = chain_at(s, 5)
    r = dict(name=s, types="/".join(dict.fromkeys(mon(s)["types"])).replace("PSYCHIC_TYPE", "PSY"))

    # 1. raw offence vs a neutral target
    nb, nd = best(sp5, 5, "RATTATA", 5, mv5)
    r.update(neutral_move=nb or "-", neutral_dmg=nd,
             power=eff_power(nb) if nb else 0)

    # 2. the Megan gate, with turn order
    shp, ohp = stat(mon(s)["hp"], 5, hp=True), stat(mon("SLOWPOKE")["hp"], 2, hp=True)
    _, mydmg = best(sp5, 5, "SLOWPOKE", 2, mv5)
    _, theirdmg = best("SLOWPOKE", 2, sp5, 5, mon("SLOWPOKE")["moves"])
    my_turns = math.inf if mydmg <= 0 else math.ceil(ohp / mydmg)
    their_turns = math.inf if theirdmg <= 0 else math.ceil(shp / theirdmg)
    faster = stat(mon(s)["spd"], 5) >= stat(mon("SLOWPOKE")["spd"], 2)
    win = my_turns <= their_turns if faster else my_turns < their_turns
    r.update(my_turns=my_turns, their_turns=their_turns, faster=faster, win=win)

    # 3. when does it get a damaging move of its own that beats what it starts with?
    start_power = r["power"]
    up_lv = up_mv = None
    for lv in range(6, 31):
        sp, mvs = chain_at(s, lv)
        for mv in mvs:
            if mv in mv5 or mv in BORROWED:
                continue
            if eff_power(mv) > max(start_power, 0) and dmg(sp, lv, mv, "RATTATA", 5) > 0:
                lvs = [l for l, m in LEARN.get(key(sp), []) if m == mv] or \
                      [l for spp in [s] for l, m in LEARN.get(key(spp), []) if m == mv]
                if lvs and max(lvs) <= lv:
                    up_lv, up_mv = min(l for l in lvs if l <= lv), mv
                    break
            if up_mv:
                break
        if up_mv:
            break
    r.update(up_lv=up_lv, up_mv=up_mv,
             evo_lv=min([l for l, _ in EVOS.get(key(s), [])], default=None))
    rows.append(r)

rows.sort(key=lambda r: r["neutral_dmg"])

print(f"{len(rows)} starters, sorted by raw damage vs a neutral L5 Rattata\n")
print(f"{'starter':13} {'types':11} {'best move L5':14} {'pow':>3} {'dmg':>5} "
      f"{'Megan L2 Slowpoke':>19} {'next own move':>20} {'evo':>4}")
print("-" * 100)
for r in rows:
    gate = ("WINS " if r["win"] else "LOSES") + \
        f" {r['my_turns'] if r['my_turns']!=math.inf else '-'}v{r['their_turns'] if r['their_turns']!=math.inf else '-'}"
    nxt = f"L{r['up_lv']} {r['up_mv']}" if r["up_mv"] else "NONE by L30"
    print(f"{r['name'][:12]:13} {r['types'][:10]:11} {r['neutral_move'][:13]:14} "
          f"{r['power']:3.0f} {r['neutral_dmg']:5.1f} {gate:>19} {nxt[:20]:>20} "
          f"{('L'+str(r['evo_lv'])) if r['evo_lv'] else '-':>4}")

print("\n=== no damaging move of their own at L5 ===")
for r in rows:
    if r["power"] == 0:
        print(f"  {r['name']:12} {r['types']:12} first own damage: "
              f"{'L'+str(r['up_lv'])+' '+r['up_mv'] if r['up_mv'] else 'never by L30'}")

print("\n=== weak move (<=30 power) AND no upgrade before L15 ===")
for r in rows:
    if 0 < r["power"] <= 30 and (r["up_lv"] is None or r["up_lv"] >= 15):
        print(f"  {r['name']:12} {r['neutral_move']:14} {r['power']:3.0f} power, "
              f"next own move: {('L'+str(r['up_lv'])+' '+r['up_mv']) if r['up_mv'] else 'none by L30'}"
              f"   (evo L{r['evo_lv']})" if r["evo_lv"] else "")

print("\n=== loses the Megan fight at L5 ===")
print("  " + ", ".join(r["name"] for r in rows if not r["win"]))
