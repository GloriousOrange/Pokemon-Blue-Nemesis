# Pokémon Nemesis

**A total-conversion ROM hack of Pokémon Blue.** Same Kanto, same 151 Pokémon,
almost nothing else left alone. Nemesis rewrites the story into a wartime
thriller, opens the starter choice to **78 different Pokémon**, forks the plot
into three mutually exclusive allegiances, adds **50 new moves** and **8 new
species**, fixes a pile of Generation 1's most notorious bugs, and bolts on an
endgame roughly the size of the original game's second half.

It is a real Game Boy Color title — genuine hardware palettes, not an
emulator's guess at colour.

<div align="center">

## ⬇️ &nbsp;[Download the latest release](https://github.com/GloriousOrange/Pokemon-Blue-Nemesis/releases/latest)

**You supply your own Pokémon Blue ROM.** The download is a *patch*, not a game.

</div>

1. Get a retail **Pokémon Blue (USA/Europe)** dump —
   SHA1 `d7037c83e1ae5b39bde3c30787637ba1d4c48ce2`
2. Apply **`PKMN Nemesis.bps`** with any BPS patcher
   ([Rom Patcher JS](https://www.marcrobledo.com/RomPatcher.js/) runs in your
   browser, nothing is uploaded)
3. Open the result in any Game Boy Color emulator — Pizza Boy GBC, Nostalgia,
   mGBA. The cartridge title reads **PKMN NEMESIS**.

**[Full install guide, troubleshooting and colour schemes →](dist/README.md)**

---

- **[Team Builder](https://gloriousorange.github.io/Pokemon-Blue-Nemesis/)** —
  build a party of six, check type coverage and weaknesses, browse every
  Pokémon's full movepool
- **[Beta notes](BETA_README.md)** — the tester-facing changelog

> There is a **[SPOILERS](#spoilers)** section at the very bottom. Everything
> above it is safe to read before you play.

---

## Table of contents

- [The premise](#the-premise)
- [Pick any of 78 starters](#pick-any-of-78-starters)
- [Three paths](#three-paths)
- [Megan](#megan)
- [Difficulty](#difficulty)
- [New Pokémon](#new-pokémon)
- [Moves](#moves)
- [Battle mechanics and Gen 1 bug fixes](#battle-mechanics-and-gen-1-bug-fixes)
- [Species rebalance](#species-rebalance)
- [New regions](#new-regions)
- [The world, rewritten](#the-world-rewritten)
- [Quality of life](#quality-of-life)
- [Presentation](#presentation)
- [SPOILERS](#spoilers)

---

## The premise

Kanto is at war. The League and Team Rocket are two arms of the same machine,
Pokémon are livestock and weapons rather than friends, and the cheerful
children's-adventure register of the original is gone entirely. Professor Oak
opens the game with a monologue about ownership, not wonder.

Nearly every NPC in the game has been rewritten. Not just the plot-critical
ones — all fifteen Bikers, all fifteen Beauties, every Fisher, every Super
Nerd, every Channeler, every Gambler, every Black Belt. Each trainer class has
its own voice and its own running joke or grievance, and the war is visible in
the background of almost all of them.

## Pick any of 78 starters

Oak's lab offers **78 species**, not three. Pick Magikarp. Pick Mewtwo. Pick
Ditto. **Oak has a unique, hand-written remark for every single one.**

To make that survivable, every starter that lacked one was given a **35-power
same-type attack at level 1**, learnsets were thickened across the board, and a
balance pass (`scripts/starter_balance.py`) ranks every starter by early-game
damage so none of them are dead on arrival. Your rival's team is generated to
counter whatever you chose.

## Three paths

At Nugget Bridge you choose a side, and the game forks:

- **Hero** — refuse Team Rocket. The default path.
- **Loyalist** — join them. Rockets stop attacking you, gym and Silph Co
  content reshuffles, the Game Corner runs a Rocket-only economy with
  exclusive prizes, and a large body of alternate dialogue unlocks.
- **Traitor** — later in the game, a third option to betray whichever side
  you're on.

This isn't cosmetic. Silph Co has an entirely different trainer roster per
path — every Rocket in the building has a Silph-staff counterpart, so a
Loyalist fights the same number of battles against different people. Your
overworld sprite, your battle back-sprite, who fights you, who talks to you,
and how several major scenes resolve all follow from the choice.

## Megan

Nemesis adds a companion. You meet **Megan** on Route 1 and she runs alongside
the whole game: her own trainer class, her own battle portrait and overworld
sprite, and a **PHONE** entry in the Start menu.

She'll spar with you **before every Gym**, again in the Indigo Plateau lobby,
and once more at Level 100 on Battle Island — optional training battles that
scale to just under each leader's team. She heals your party at several points
in the world, and how much she gives you depends on your difficulty setting.
The path you choose changes whether she keeps talking to you.

## Difficulty

Chosen at the start of the game:

| Mode | Effect |
|---|---|
| **Easy** | 1.5× EXP from trainer battles; Megan's gifts unchanged |
| **Normal** | No EXP boost; Megan's Rare Candy and vitamin gifts become a healing item |
| **Hard** | **No items usable in battle at all**; Megan gives you nothing until Victory Road |

## New Pokémon

Eight new species, all with original sprites and CODEX entries:

| Species | Notes |
|---|---|
| **Tyranis** | New legendary-tier bird |
| **Miasma** | New legendary-tier bird, Poison specialist |
| **Nocturn** | New legendary-tier bird, tied to the main quest |
| **Alakachamp** | Fighting/Psychic Machamp variant with its own crimson palette |
| **MewThree** | Armoured Cerulean Cave superboss |
| **Pinsirite** | Black-granite Pinsir |
| **Ninefrost** | Icy-blue Ninetales |
| **Dignemite** | Enlarged silver Diglett |

With the three vanilla birds, that makes **six legendary birds** to hunt.

## Moves

**Every Pokémon knows up to five moves instead of four**, and there are **50
new moves** on top of the original 165. A sample:

- **Web Cannon** (Bug) — drops the target's Speed to the floor in one hit
- **Uppercut** (Fighting) — guaranteed critical hit if you outspeed the target
- **Jackpot** (Normal) — deals damage *and* scatters money
- **Super Instinct** — raises accuracy and evasion together
- **Blood Suck**, **Giga Drain**, **Leech Life** — drain the full damage dealt
- **Hydro Jet**, **Flame Whip**, **Crystallize**, **Hot Oil**, **Ice Bomb**,
  **Ice Sculpture**, **Chaos Sting**, **Third Rail**, **Telekinesis**,
  **Gravity Slam**, **Static Shock**, **Shadow Punch**, **Crush Jaw**,
  **Granit Clamp**, **Chokehold**, **Rock Fists**, **Hurricane**…

Nearly all of them have **custom battle animations** rather than reused ones.

## Battle mechanics and Gen 1 bug fixes

Nemesis repairs several of Generation 1's most infamous defects:

- **The badge-boost bug is fixed.** Vanilla recalculated stats from unmodified
  base values, silently undoing your stat changes. Nemesis doesn't.
- **Focus Energy works.** In vanilla it *reduced* your critical hit rate.
- **Division-by-zero crash on certain critical hits** — fixed.
- **Toxic's damage multiplier surviving a switch** and inflating a later
  Pokémon's burn or Leech Seed damage — fixed.
- Moves that deal zero damage now say **"It had no effect!"** instead of
  silently doing nothing.
- **Twineedle** hit 33 times in vanilla. Now it hits twice.

Type chart and rule changes:

- **Psychic is weak to Ghost**, closing Gen 1's worst balance hole
- **Flying attacks can hit pure Ghost types**
- The Gastly line keeps only its Normal/Fighting immunity
- **Dragons have exactly one weakness: Bug**
- Floating Pokémon get a Levitate-style **Ground immunity**
- Smaller, unevolved forms are **faster** than their evolutions

Other systems: enemy AI shuns a move after two consecutive misses; **cancelling
an evolution suppresses it for 30 levels** rather than re-prompting every time;
overworld poison can no longer faint a Pokémon.

## Species rebalance

Base stats, growth rates, typings and learnsets were revised across a large
part of the roster. Highlights: **Golduck is Water/Psychic**, **Gyarados is
Water/Dragon**, **Butterfree is Bug/Psychic**, Pikachu's Speed and growth rate
were overhauled, and a broad sweep moved slow-growth species to medium-slow so
the mid-game isn't a grind.

## New regions

- **Battle Island** — a post-game hub unlocked by re-beating all eight Gym
  Leaders. Six Level 100 scientists standing in the open, a **26-trainer
  arena gauntlet** (parties capped at three), and Giovanni waiting at the end
  of it. Clear the gauntlet and it runs endless rematches.
- **The Living-Dex Archipelago** — eight seamlessly connected islands hosting
  all 151 Pokémon at Lv. 50–60, with each legendary at a rare encounter slot on
  its own island. Attached is a multi-floor cave with an underground lake:
  surfable, fishable, stocked with dragons, and hiding more than it first
  appears.
- **S.S. Olympia** — a ten-map luxury cruise liner reachable from Vermilion
  Dock after the Champion. **Forty Level 100 trainers**, each with a curated
  moveset, and a Rival superboss on the open deck locked behind the other
  thirty-nine.

## The world, rewritten

- **Viridian Gym** is now **Norman**, a Normal-type leader, awarding the
  **Harmony Badge** and a Hyper Beam TM
- **Bruno** moved to the Fighting Dojo; a new Elite Four **Bug Catcher, Toby**,
  took his slot
- **Blaine's quiz** was replaced with riddles about Nemesis's own mechanics
- **Rock Throw** became a real TM, handed out by Brock, with 31 more species
  able to learn it
- Lt. Surge's trash-can puzzle was simplified
- The legendary birds returned to their original perches, each announced before
  it appears
- Post-game Pokémon Mansion is a high-level dungeon with evolved wilds and a
  rare Charizard
- Wild encounter rates were cut substantially; early-route tables were widened

## Quality of life

- **The CODEX** — the Pokédex, rebuilt: pre-seeded Seen entries, a dedicated
  **MOVES screen**, and full move data
- **Item INFO** in the bag, with real descriptions for every TM and HM
- **Move info viewer** on the summary screen
- **Instant Pokémon Center healing** — no dialogue
- **PHONE** in the Start menu — a contact list, with different contacts and
  cut-offs depending on your path
- **Super Repel lasts 1000 steps**; Repels cost $10
- **Bag capacity raised** to 26 slots
- **HM moves can be overwritten** like any other move
- Charizard, Gyarados, Scyther and Dragonite **can learn Fly**
- **Auto-Flash** — carry HM Flash with the Boulder Badge and caves simply stay
  lit; you never have to use the move
- The bicycle can be sold back for $5000
- Directional (rather than list-based) **Town Map** navigation

## Presentation

- **Real Game Boy Color palettes**, written by the game rather than guessed at
  by the emulator. Two schemes: press **SELECT** on the OPTION screen to swap
  between **DIVERSE** (per-town colour, deep blue water) and **NEON**.
- **Pick your own overworld look** before naming your character — 34 sprites
- Original battle portraits and overworld sprites for new and reworked
  characters, plus new art for the legendary birds
- Custom animations for nearly every new move
- A rewritten title screen

---

# SPOILERS

**Everything below spoils the plot. Stop here if you haven't finished the
game.**

<details>
<summary><strong>Click to expand — major story and endgame spoilers</strong></summary>

<br>

### Professor Oak is the villain

The man who hands you your first Pokémon is the worst person in the game. The
opening monologue about ownership is not framing — it's a thesis statement.
Oak's research is the origin of the war, and the League and Team Rocket are
both downstream of his work.

He is a **Level 100 superboss** with a signature six-Pokémon team, fought at
the bottom of the Archipelago Cave, after you have beaten the six scientists
carrying on his work. Beating him is what unlocks the Battle Island arena.

### General Mathus

The other half of the game's villainy. Mathus is revealed to be **your
father** — the reveal is deliberately path-agnostic, so it lands the same
whichever side you chose. His chapter runs through Pokémon Tower and the
Nocturn capture quest, and the Tower's Marowak-ghost story was rewritten
around him.

### Your rival dies, and comes back

At Silph Co your rival's starter is killed. It returns as a **ghost** — the
same species, now Ghost-typed, rendered in a spectral violet palette unique to
resurrected Pokémon. You fight it again on Route 22, at the Champion battle,
and finally on the deck of the S.S. Olympia. The resurrection mechanic covers
**148 species** (all 78 starters plus their full evolution lines), so whatever
you picked in Oak's lab can come back wearing that palette.

### Mutagen Vials and Mutagenstones

The war's real product.

- **Mutagen Vials** are obtainable mid-game. A vial forces a base species into
  its **mutant form** at its current level — this is how Alakachamp,
  Pinsirite, Ninefrost and Dignemite exist, and it's why they look like
  something went wrong.
- **Mutagenstones** jump a Pokémon straight to **Level 100**, replaying its
  entire evolution and move-learning history on the way. The endgame hands you
  six of them.
- **102 final-evolution species** have hand-curated Level 100 movesets for
  exactly this, documented in **[MUTAGENSTONE.md](MUTAGENSTONE.md)** — that
  file is itself a spoiler.

### The Ghost Rocket

Beneath the Archipelago Cave lake, past a pit in the rock, is a flooded grotto
with one island in it. A Rocket has been down there long enough to stop
counting days. His entire team is **resurrected** — six Level 100 Pokémon, all
part-Ghost, all rendered spectral. There's an Escape Rope on the ground beside
him, because nothing else down there is going to help you leave.

### The three endings

Hero, Loyalist and Traitor resolve differently — including **who you fight at
Silph Co**. On the Rocket path the confrontation at the top of the building is
not Giovanni at all: it's **Oak**. On the Hero path a separate gatekeeper
stands between you and Giovanni, and a Loyalist never fights a single Rocket
in the building.

### Other things worth not knowing in advance

- **MewThree**, an armoured Mewtwo clone, waits in Cerulean Cave
- Mew and Mewtwo's CODEX entries were rewritten to tie both into the same DNA
  lineage the plot turns on
- Giovanni is the final trainer of the Battle Island gauntlet, not the boss of
  the story
- Clearing the S.S. Olympia is what awards the three mutant recolours

</details>

---

## Built on pokered

Nemesis is built on the [pret/pokered](https://github.com/pret/pokered)
disassembly of Pokémon Red and Blue. To set up the repository and build from
source, see [**INSTALL.md**](INSTALL.md).

```
make blue        # the ROM Nemesis ships
make nemesis     # the same ROM, stamped with the Nemesis cartridge title
```

For other pret projects, see [pret.github.io](https://pret.github.io/).
You can find the disassembly community on
[Discord (pret, #pokered)](https://discord.gg/d5dubZ3).
