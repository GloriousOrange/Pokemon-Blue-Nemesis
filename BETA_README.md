# Pokemon Nemesis — Beta Notes

Thanks for testing! This is a Pokemon Blue ROM hack. Below is everything
that's changed from the vanilla game, mechanically — just patch notes. If
something looks broken, weird, or unfinished, that's exactly what this beta
is for; please report it.

These notes are deliberately **mechanically complete**, which means they name
a few endgame items and areas you'd otherwise find yourself. They don't spoil
the story. If you want to go in completely cold, read the
[README](README.md) instead — it keeps all story material behind a collapsed
spoiler section.

Runs on Game Boy Color emulators — Pizza Boy GBC, Nostalgia, mGBA and friends
all show the same colors, because Nemesis is a real GBC game rather than a
black-and-white game the emulator has to colorize by guessing. Saves work like
a real cartridge. Two color schemes ship with it: press **SELECT** on the
OPTION screen to switch `COLOR` between **DIVERSE** (per-town palettes, deep
blue water) and **NEON** (one high-contrast red/green/blue ramp for
everything).

## Starting Out

- **78 starters.** Oak's lab lets you pick almost anything — Magikarp, Ditto,
  Mewtwo, any of 78 species — and he has a unique written remark for every
  one of them. Every starter that didn't already have one was given a
  35-power same-type attack at level 1 so nothing is unplayable early.
- **Pick your own overworld sprite** before naming your character: 34 looks
  to choose from.
- **Difficulty select** at the start of a new game:
  - **Easy** — 1.5x EXP from trainer battles; Megan's gifts unchanged
  - **Normal** — no EXP boost; Megan's Rare Candy/vitamin gifts become a
    healing item instead
  - **Hard** — no items usable in battle at all; Megan gives you nothing
    until Victory Road
- The **CODEX** (this game's Pokedex) is available from the start — no
  fetch-quest. It has a dedicated **MOVES** screen with full move data, and
  Seen entries are pre-seeded.

## New Areas

- **Battle Island** — reachable once you've beaten every Gym Leader a second
  time (a full rematch tour, available after the Elite Four). Beating the
  last rematch marks the island on your map; Fly there anytime after that.
  It's an open-air post-game hub with:
  - **6 scientists** standing out in the open, each a one-Pokemon Level 100
    battle with their own dialogue. Beat all 6 and the last one hands you
    6 **Mutagenstones** and tells you where to find Professor Oak.
  - **The Arena**: a 26-trainer battle gauntlet (party capped at 3 Pokemon
    per fight — you'll be sent to store extras at the island's PC first).
    Clear all 26 and Giovanni himself steps up for a final fight; after that,
    the gauntlet just keeps running endless rematches. **The arena stays
    locked until you've beaten Oak.**
  - Its own wild-encounter zone, and a healer/PC building at the island's
    north edge. Healing at Megan there also sets it as your blackout
    respawn point.
- **The Living-Dex Archipelago** — a chain of 8 seamlessly connected islands
  branching off Battle Island. Together they host all 151 catchable Pokemon
  at Lv. 50-60, with the 6 legendary birds (the three vanilla birds plus
  Tyranis, Miasma, and Nocturn), Mewtwo, and Mew each placed at a rare (~1%)
  encounter slot on their island.
- **The Archipelago Cave** — four floors, off Miasma Isle. The bottom floor
  holds **Professor Oak**, a Level 100 superboss with a signature 6-Pokemon
  team; beating him unlocks the Battle Island arena and hands over an HM,
  **Metronome2**. That floor also has a real underground lake:
  - **Surfable** from the stone quay along its north edge, with its own
    dragon-heavy encounter table
  - **Fishable** with the Super Rod
  - A gravel islet out in the water, reachable only by surfing, with an item
    on it
  - A **pit in the rock** on the west side drops you to a flooded grotto
    below, with a hidden trainer and an item. Bring an escape route.
- **S.S. Olympia** — a ten-map luxury cruise liner, reachable from Vermilion
  Dock once you've beaten the Champion and hold a Master Ball. **40 Level 100
  trainers** spread across its decks, each with a hand-curated moveset, and a
  Rival superboss on the open deck — locked until you've beaten the other 39.
  Megan has a cabin aboard. There's no phone signal on the ship.

The Pokemon Mansion on Cinnabar Island is a normal wild-encounter dungeon
(with higher-level, evolved wilds and a rare Charizard post-game) — nothing
about reaching Battle Island runs through it.

## New Pokemon, Moves & Species Changes

- **8 new species**, all with their own sprites and CODEX entries:
  - **Tyranis**, **Miasma**, **Nocturn** — three new legendary-tier birds
  - **Alakachamp** — Fighting/Psychic Machamp variant with its own crimson
    palette
  - **MewThree** — an armoured Mewtwo clone waiting in Cerulean Cave
  - **Pinsirite**, **Ninefrost**, **Dignemite** — awarded for clearing the
    S.S. Olympia
- **5 moves per Pokemon**, not the vanilla 4 — battle menus, the Summary
  screen, and Move Relearner/Mimic are all sized for this.
- **50 new moves** on top of vanilla's 165, nearly all with their own custom
  battle animations. A sample:
  - **Web Cannon** (Bug) — damaging, drops the target's Speed to the floor in
    one hit, with a flinch chance
  - **Uppercut** (Fighting) — guaranteed critical hit if you outspeed the
    target
  - **Jackpot** (Normal, Persian Lv. 98) — damage *and* scatters $300–$1000
  - **Super Instinct** (Hitmonlee Lv. 22) — raises the user's accuracy *and*
    evasion
  - **Crystallize** (Beedrill Lv. 22) — +2 Defense and +1 Special
  - **Chaos Sting** (Bug, Beedrill Lv. 38) — 70 power, 30% chance of a random
    status (never sleep)
  - **Rock Fists** (Rock, Geodude Lv. 28) — hits 2–5 times for 30 each
  - **Chokehold** (Fighting, Primeape Lv. 33) — Wrap-style trap, 20/turn
  - **Crush Coil** (Poison, Ekans/Arbok Lv. 42) — Wrap-style trap, 30/turn
  - **Hot Oil** (Fire, Magmar Lv. 30) — 40 power, *always* burns
  - **Bad Touch** (Drowzee Lv. 42) — always confuses, 100% accuracy
  - **Blood Suck** (Poison, Zubat Lv. 32) — drains the damage dealt
  - **Telekinesis** (Psychic) — a 2–5 hit psychic move
  - **Third Rail** (Electric) — an electric Dig
  - **Hydro Jet** (Water, unevolved Squirtle Lv. 40), **Flame Whip** (Fire),
    **Hurricane** (Gyarados), **Static Shock** (Electabuzz), **Ice Bomb**,
    **Ice Sculpture**, **Ice Spike**, **Gravity Slam**, **Vibrate**,
    **Stealth**, **Tangle**, **Stampede**, **Shadow Punch**, **Crush Jaw**,
    **Granit Clamp**, **Double Drill**, **Hyper Beams**
  - Miasma and Nocturn have signature moves: **Carrion Wind**, **Blight
    Vomit**, **Mind Fever**, **Phantom Wing**. Carrion Wind and Mind Fever
    have **1 PP on purpose** — that's not a bug.
  - Every starter without a same-type attack got a fixed **35-power STAB
    move**: Venom Bite, Mud Slap, Palm Strike, Spark, Psy Chop, Dragon
    Breath, Vine Whip, Ice Spike, Clamp.
- **Buffed drains**: Leech Life and the new Giga Drain both recover the full
  damage dealt.
- **Reworked moves**: Whirlwind is now a 20-power Flying attack that lowers
  accuracy (it no longer ends the battle); Razor Wind hits much harder;
  Mimic's PP was raised to 35; Twineedle hits twice (it hit 33 times in
  vanilla).
- **Move type reassignments**: most notably Guillotine and Vice Grip are now
  Bug-type.
- **Typing changes**: **Golduck is Water/Psychic**, **Gyarados is
  Water/Dragon**, **Butterfree is Bug/Psychic**.
- **New/earlier level-up moves** on many Pokemon: Charmander learns Fire
  Punch (Lv. 10), Pikachu learns Flash (Lv. 7), Abra gets Confusion at level
  1, Jigglypuff gets Pound, Dratini learns Slam at 10, Pidgeot learns Hyper
  Beam at 48. A few sit deliberately *above* the evolution level to reward
  staying unevolved: Kabuto gets Cut (7), Crystallize (22) and Guillotine
  (42); Rhyhorn gets Agility (44); Slowpoke gets Thunder (50).
- **Charizard, Gyarados, Scyther and Dragonite can learn Fly.**
- Some items display under new flavor names but work identically to their
  vanilla counterpart — check the in-game description if a name looks
  unfamiliar.

## Gym Leaders & Trainer Roster Changes

- Viridian Gym is now led by **Norman**, a Normal-type specialist (Tauros,
  Snorlax, Chansey, Kangaskhan, Eevee, Persian), awarding the **Harmony
  Badge** and TM Hyper Beam.
- **Bruno** now runs the Fighting Dojo instead of holding an Elite Four seat;
  his old slot is filled by **Toby**, a new Bug-type specialist with a custom
  team and unique movesets.
- **Blaine's quiz was replaced with riddles** about Nemesis's own mechanics.
- **Rock Throw is now TM34**, handed out by Brock, with 31 more species able
  to learn it.
- Lt. Surge's trash-can puzzle was simplified.
- Every Gym Leader has a full rematch team available post-game, once you've
  cleared the League — these feed into unlocking Battle Island.
- There's a **branching allegiance system**: at Nugget Bridge you can side
  with Team Rocket or refuse. Your choice changes your overworld sprite and
  battle back-sprite, which NPCs treat you as friend or foe, unlocks
  path-specific shops/prizes at the Game Corner, and changes who you fight.
  Silph Co. is the clearest case — every Rocket in the building has a Silph
  staff counterpart, so both paths fight the same number of battles against
  different people, and the top floor swaps its boss. A further "go rogue"
  branch exists later, tied to an encounter at the top of Pokemon Tower.
- Team Rocket grunts in their hideout give Game Corner coins instead of cash.

## Battle & Difficulty

- Enemy trainers never use items or switch Pokemon mid-battle, on any
  difficulty — they always just attack. Their AI does stop using a move after
  it misses twice in a row.
- The classic Gen 1 **"badge boost" bug is fixed**: repeatedly raising or
  lowering a stat no longer causes a Pokemon's *other* stats to drift.
- **Focus Energy and Dire Hit finally work.** In vanilla they *quartered*
  your critical-hit rate instead of quadrupling it. Enemy trainers get the
  same benefit, and moves that already crit often (Slash, Crabhammer, Razor
  Leaf) gain nothing on top.
- A crash on **critical hits against very high Defense/Special** at Level 100
  is fixed, as is a **Toxic bug** where its damage multiplier survived a
  switch and inflated a later Pokemon's burn or Leech Seed damage.
- Moves that deal no damage now say **"It had no effect!"** instead of
  silently doing nothing.
- **Type chart changes**: Psychic is now weak to Ghost; Flying attacks can
  hit pure Ghost types; the Gastly line keeps only its Normal/Fighting
  immunity; **Dragons have exactly one weakness, Bug**; floating Pokemon get
  a Levitate-style Ground immunity.
- **Cancelling an evolution now sticks** for 30 levels rather than asking
  every level-up. (Known beta limitation — see Caveats.)
- **Stat & growth-rate changes.** Onix (HP), Muk (Def), Slowpoke (Special),
  Ekans/Zubat (Speed), Shellder, Kabuto, Jynx and others got base-stat
  changes; unevolved forms are now generally **faster** than their
  evolutions. Pikachu, Sandshrew, Beedrill, Geodude and Kabuto are Fast
  growth, and every ordinary Slow-growth species moved to Medium-Slow.
- Wild encounter rates are reduced across routes, caves and water; early
  route tables were widened.
- Overworld poison can no longer faint a Pokemon.
- **Mutagenstones** level a Pokemon straight to 100 from your bag (not in
  battle), correctly replaying every evolution and move along the way. 102
  final-evolution species have hand-curated Level 100 movesets for this.
- **Mutagen Vials** are a separate mid-game item that forces a base species
  into its mutant form at its current level.

## Megan & the Phone System

- **Megan** is a recurring character you meet on **Route 1**. She is not a
  following sprite — she turns up at fixed places.
- She'll **spar with you before every Gym**, again in the Indigo Plateau
  lobby (Lv. 70), and once more on Battle Island (Lv. 100). These are
  optional training battles pitched just under each leader's team.
- She heals your party where she appears — including the Viridian Forest
  gate, the Battle Island house, and her cabin on the S.S. Olympia — and
  gives a one-time gift the first time you reach each location. What she
  gives depends on your difficulty.
- The **Start Menu** has a **PHONE** option: call Megan for item storage, Oak
  for your Pokemon Box storage, and — once unlocked — a third contact tied to
  your story path. Some contacts cut you off depending on the path you took.

## Quality of Life

- **Auto-Flash**: carry HM Flash with the Boulder Badge and caves stay lit —
  you never have to use the move.
- **Item Info** in the bag and **Move Info** on the summary screen, both with
  full descriptions, including real text for every TM and HM.
- **Instant Pokemon Center healing** — no dialogue.
- **Super Repel lasts 1000 steps**, and Repels cost $10.
- **Bag capacity raised to 26 slots.**
- **HM moves can be overwritten** like any other move.
- The bicycle can be **sold back for $5000**.
- **Town Map** navigates directionally with the d-pad instead of by list.

## Tone & Flavor

Nearly every NPC in the game has been rewritten. Each trainer class has its
own voice — the Bikers, Beauties, Fishers, Super Nerds, Channelers, Gamblers
and Black Belts all got full passes. The tone is darker and comedic: Pokemon
are casually referenced as food and livestock, and there's an ongoing
propaganda thread between the Gyms and the Elite Four running through
incidental dialogue. The Rival is played straight and serious throughout.
This is atmospheric flavor and doesn't block or change core gameplay.

## Known Beta Caveats

- The "cancel evolution suppresses it for 30 levels" feature tracks the timer
  by **party slot**, not by the individual Pokemon. If you reorder your party
  or deposit/withdraw the Pokemon during those 30 levels, the timer can
  attach to the wrong slot — one Pokemon might get asked again early, or
  another might briefly refuse. Cancel again and it sorts itself out.
- This is an active beta. If you hit a freeze, crash, or obviously broken
  interaction, that's exactly the kind of thing to report — several major
  freeze bugs were found and fixed in the lead-up to this build, but more may
  surface, especially around the new Level 100 post-game content.

### Fixed since the previous beta notes

These were listed as caveats before and are now resolved: the S.S. Olympia
rival's fallen partner is the real starter rather than a placeholder Gengar;
Tyranis, Miasma and Nocturn have original art instead of recolors; the
palette-flash effects that stayed static in Game Boy Color mode now fade
properly; and the post-Oak "can't walk" bug is gone.

## Reporting Issues

If something breaks: note where you were, what you just did, and (if
possible) a save state right before it happened. That's the fastest path to
a fix.

Have fun, and thanks for playtesting!
