#!/usr/bin/env python3
"""
Generate StarterSpeciesTable, RivalCounterTable, and RivalTeamTable for the
Pokemon Blue custom starter mod.  Run from anywhere; uses absolute paths.
Output is printed to stdout; paste the relevant sections into:
  - scripts/OaksLab.asm  (StarterSpeciesTable, RivalCounterTable, RivalTeamTable)
  - data/trainers/parties.asm  (new Rival1Data teams, printed at the end)
"""
import os, re, sys

BASE = os.path.dirname(os.path.abspath(__file__)) + "/.."

# ── 1. DEX_ constants (pokedex number → name) ────────────────────────────────
dex_values = {}  # "DEX_BULBASAUR" → 1
with open(f"{BASE}/constants/pokedex_constants.asm") as f:
    val = 0
    for line in f:
        s = line.strip()
        if "const_def" in s:
            val = 0
        elif re.match(r"const\s+DEX_", s):
            m = re.match(r"const\s+(DEX_\w+)", s)
            if m:
                val += 1
                dex_values[m.group(1)] = val
        elif "const_skip" in s:
            val += 1

# ── 2. PokedexOrder: internal_id (1-indexed) → dex_number ───────────────────
internal_to_dex = {}
dex_to_internal = {}
with open(f"{BASE}/data/pokemon/dex_order.asm") as f:
    internal_id = 0
    for line in f:
        s = line.strip()
        if not s.startswith("db "):
            continue
        internal_id += 1
        m = re.search(r"db\s+(DEX_\w+)", line)
        if m:
            dex_num = dex_values.get(m.group(1), 0)
            if dex_num:
                internal_to_dex[internal_id] = dex_num
                dex_to_internal[dex_num] = internal_id

# ── 3. Species constants: internal_id → constant name ───────────────────────
internal_to_const = {}
with open(f"{BASE}/constants/pokemon_constants.asm") as f:
    val = 0
    in_block = False
    for line in f:
        s = line.strip()
        if "const_def" in s:
            val = 0
            in_block = True
        elif in_block:
            m = re.match(r"const\s+(\w+)", s)
            if m:
                name = m.group(1)
                if name != "const_skip":
                    internal_to_const[val] = name
                val += 1
            elif "const_skip" in s:
                val += 1

dex_to_const = {dex: internal_to_const[iid]
                for dex, iid in dex_to_internal.items()
                if iid in internal_to_const}

# ── 4. Base stats: dex_number → primary type ────────────────────────────────
includes = []
with open(f"{BASE}/data/pokemon/base_stats.asm") as f:
    for line in f:
        m = re.search(r'INCLUDE "data/pokemon/base_stats/(\w+)\.asm"', line)
        if m:
            includes.append(m.group(1))
includes.append("mew")

dex_to_type = {}
TYPES = {"NORMAL","FIRE","WATER","GRASS","ELECTRIC","ICE","FIGHTING","POISON",
         "GROUND","FLYING","BIRD","PSYCHIC_TYPE","BUG","ROCK","GHOST","DRAGON"}

for dex_num, fname in enumerate(includes, 1):
    path = f"{BASE}/data/pokemon/base_stats/{fname}.asm"
    if not os.path.exists(path):
        continue
    with open(path) as f:
        content = f.read()
    m = re.search(r"db\s+(\w+),\s*\w+\s*;.*type", content, re.IGNORECASE)
    if m and m.group(1) in TYPES:
        dex_to_type[dex_num] = m.group(1)
    else:
        for word in re.findall(r'\b([A-Z_]+)\b', content):
            if word in TYPES:
                dex_to_type[dex_num] = word
                break

# ── 5. Base-form Pokédex numbers (79 total) ──────────────────────────────────
BASE_FORMS = [
    1, 4, 7, 10, 13, 16, 19, 21, 23, 25, 27, 29, 32, 35, 37, 39, 41,
    43, 46, 48, 50, 52, 54, 56, 58, 60, 63, 66, 69, 72, 74, 77, 79,
    81, 83, 84, 86, 88, 90, 95, 96, 98, 100, 102, 104, 106, 107,
    108, 109, 111, 113, 114, 115, 116, 118, 120, 122, 123, 124, 125,
    126, 127, 128, 129, 131, 132, 133, 137, 138, 140, 142, 143, 144,
    145, 146, 147, 150, 151,
]

# ── 6. Counter pools ──────────────────────────────────────────────────────────
POOLS = {
    "NORMAL":       ["MANKEY",    "MACHOP",    "HITMONLEE",  "HITMONCHAN", "PRIMEAPE"],
    "FIRE":         ["SQUIRTLE",  "PSYDUCK",   "POLIWAG",    "STARYU",     "SEEL",     "HORSEA"],
    "WATER":        ["PIKACHU",   "VOLTORB",   "MAGNEMITE",  "ELECTABUZZ", "JOLTEON"],
    "GRASS":        ["CHARMANDER","GROWLITHE", "PONYTA",     "MAGMAR"],
    "ELECTRIC":     ["SANDSHREW", "DIGLETT",   "GEODUDE",    "CUBONE"],
    "ICE":          ["GROWLITHE", "PONYTA",    "MAGMAR",     "CHARMANDER"],
    "FIGHTING":     ["DROWZEE",   "ABRA",      "JYNX"],
    "POISON":       ["SANDSHREW", "ABRA",      "DROWZEE",    "PSYDUCK"],
    "GROUND":       ["BULBASAUR", "ODDISH",    "BELLSPROUT", "EXEGGCUTE",  "TANGELA"],
    "FLYING":       ["PIKACHU",   "VOLTORB",   "ELECTABUZZ", "MAGNEMITE"],
    "BIRD":         ["PIKACHU",   "VOLTORB",   "ELECTABUZZ", "MAGNEMITE"],
    "PSYCHIC_TYPE": ["CATERPIE",  "WEEDLE",    "VENONAT",    "SCYTHER",    "PINSIR"],
    "BUG":          ["GROWLITHE", "CHARMANDER","PONYTA"],
    "ROCK":         ["SQUIRTLE",  "POLIWAG",   "HORSEA",     "MACHOP"],
    "GHOST":        ["GASTLY"],
    "DRAGON":       ["DRATINI",   "LAPRAS",    "JYNX"],
}

LEGENDARY_OVERRIDE = {}  # All Pokemon use type pool logic, no special cases

# ── 7. Compute rival species for every starter (single pass) ─────────────────
pool_counters = {t: 0 for t in POOLS}
rivals = []  # rivals[i] = rival species const for BASE_FORMS[i]

for dex in BASE_FORMS:
    if dex in LEGENDARY_OVERRIDE:
        rival = LEGENDARY_OVERRIDE[dex]
    else:
        ptype = dex_to_type.get(dex, "NORMAL")
        pool  = POOLS.get(ptype, POOLS["NORMAL"])
        idx   = pool_counters[ptype]
        rival = pool[idx % len(pool)]
        pool_counters[ptype] = idx + 1
    rivals.append(rival)

# ── 8. Assign team numbers ────────────────────────────────────────────────────
# Teams 1-3 already exist in Rival1Data for the original starters.
# Teams 4-9 are Route 22 and Cerulean — do NOT reuse.
# Teams 10+ are new, one per unique counter species not in {SQUIRTLE,BULBASAUR,CHARMANDER}.
TEAM_EXISTING = {"SQUIRTLE": 1, "BULBASAUR": 2, "CHARMANDER": 3}
custom_team_map = {}   # species → team number (10+)
custom_species_list = []  # ordered list of new species (for trainer data output)

for rival in rivals:
    if rival not in TEAM_EXISTING and rival not in custom_team_map:
        team_num = 10 + len(custom_species_list)
        custom_team_map[rival] = team_num
        custom_species_list.append(rival)

def team_number(rival):
    if rival in TEAM_EXISTING:
        return TEAM_EXISTING[rival]
    return custom_team_map[rival]

# ── 9. Display name helpers ───────────────────────────────────────────────────
dex_to_display = {dex: fname.upper().replace("_", " ")
                  for dex, fname in enumerate(includes, 1)}

# ── 10. Output ────────────────────────────────────────────────────────────────
print("; ============================================================")
print("; GENERATED BY scripts/gen_tables.py — do not edit manually")
print("; Re-run to regenerate after changing pools or base-form list")
print("; ============================================================")
print()
print(f"; NUM_VALID_STARTERS = {len(BASE_FORMS)} (defined via 'def' in the code section above)")
print()

# StarterSpeciesTable
print("StarterSpeciesTable:")
for dex in BASE_FORMS:
    const = dex_to_const.get(dex, f"MISSING_{dex}")
    name  = dex_to_display.get(dex, "???")
    print(f"\tdb {const:<16} ; #{dex:03d} {name}")

print()

# RivalCounterTable
print("RivalCounterTable:")
for i, dex in enumerate(BASE_FORMS):
    rival        = rivals[i]
    player_name  = dex_to_display.get(dex, "???")
    ptype        = dex_to_type.get(dex, "NORMAL")
    if dex in LEGENDARY_OVERRIDE:
        note = "legendary triangle"
    else:
        note = ptype
    print(f"\tdb {rival:<16} ; #{dex:03d} {player_name} ({note})")

print()

# RivalSpeciesTeamTable — compact (species, team_num) pairs for OaksLabRivalStartBattleScript
# Scanned at battle time using wRivalStarter (safer than pre-stored wRivalStarterBallSpriteIndex)
print("RivalSpeciesTeamTable:")
for species, tnum in TEAM_EXISTING.items():
    print(f"\tdb {species}, {tnum}")
for species in custom_species_list:
    tnum = custom_team_map[species]
    print(f"\tdb {species}, {tnum}")
print("\tdb 0  ; terminator")

print()
print("; End of generated tables")
print()
print("; ============================================================")
print("; NEW Rival1Data entries — paste after existing team 9 in")
print("; data/trainers/parties.asm, before ProfOakData")
print("; (teams 1-3 = Oak's lab originals; 4-9 = Route22/Cerulean)")
print("; ============================================================")
for rival in custom_species_list:
    tnum = custom_team_map[rival]
    print(f"\tdb 5, {rival}, 0 ; team {tnum}")

# ── Rival3Data entries (one per counter species, numbered 1-43) ──────────────
# Rival3 trainer numbers are SEPARATE from Rival1 numbers — 1 through N.
# The Rival3StarterTable (below) maps wRivalStarter species → Rival3 trainer no.
all_counter_species_ordered = list(TEAM_EXISTING.keys()) + custom_species_list

print()
print("; ============================================================")
print("; Rival3Data entries — replace the 3 existing entries in")
print("; data/trainers/parties.asm under 'Rival3Data:'")
print("; Rival3 trainer numbers 1 to", len(all_counter_species_ordered))
print("; ============================================================")
print("Rival3Data:")
for i, species in enumerate(all_counter_species_ordered, 1):
    print(f"\t; trainer {i} — rival starter: {species}")
    print(f"\tdb $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, {species}, 0")

print()
print("; ============================================================")
print("; Rival3StarterTable — paste inside scripts/ChampionsRoom.asm")
print("; after the last text_end before the end of that file.")
print("; Scanned by ChampionsRoomGetRivalTrainerNo (species, trainer_no pairs).")
print("; ============================================================")
print("Rival3StarterTable:")
for i, species in enumerate(all_counter_species_ordered, 1):
    print(f"\tdb {species}, {i}")
