# Pokemon Nemesis — Beta Notes

Thanks for testing! This is a Pokemon Blue ROM hack. Below is everything
that's changed from the vanilla game, mechanically — no story spoilers, just
patch notes. If something looks broken, weird, or unfinished, that's exactly
what this beta is for; please report it.

Runs on Game Boy Color emulators — use **Nostalgia** on Android (Pizza Boy GBC
does *not* run this build correctly). Saves to battery, same as a real
cartridge.

## New Areas

- **Battle Island** — a post-game arena hub, reached via a hidden underground
  gate beneath Cinnabar's Pokemon Mansion (after defeating 6 lab scientists),
  or by Fly once you've discovered it. Features a 26-trainer battle gauntlet
  (endless rematches after clearing all 26, then a final Giovanni fight),
  a healer/PC building at the island's north edge, and its own wild-encounter
  zone.
- **The Living-Dex Archipelago** — a chain of 8 seamlessly connected islands
  (plus a 3-floor cave with a hidden "grotto" pool) branching off Battle
  Island. Together they host all 151 catchable Pokemon at Lv. 50-60, with
  the 6 legendary birds (the three vanilla birds plus Tyranis, Miasma, and
  Nocturn), Mewtwo, and Mew each placed at a rare (~1%) encounter slot on
  their island.
- **S.S. Olympia** — an endgame ship, reachable from Vermilion Dock once
  you've beaten the Champion and hold a Master Ball. Rocket-crewed, with 20
  Level 100 trainers spread across its decks and a Rival superboss fight on
  the open deck with its own Level 100 team, followed by a rare in-game
  trade.

## New Pokemon, Moves & Species Changes

- **New species**: Tyranis, Miasma, and Nocturn (three new legendary-tier
  birds), plus Alakachamp (a Fighting/Psychic Machamp variant, Pokedex #155).
- **New moves**: Web Cannon (Bug, no damage, drops the target's Speed all the
  way to the minimum in a single hit), Uppercut (Fighting, guaranteed critical
  hit if you outspeed the target), Carrion Wind (always strikes first and
  flinches on any hit that connects, then badly-poisons — but only 1 PP),
  Mind Fever (confuses and burns the target, also 1 PP), Blight Vomit, Phantom
  Wing (signature moves for the new birds), Double Drill (a signature Flying
  move), Hyper Beams (a double-hit Hyper Beam variant), and **Jackpot**
  (Persian's signature move, learned at Lv. 98 — Normal, deals damage and, like
  Pay Day, scatters coins you collect after the battle; a hefty $300-$1000
  per use), and **Instinct** (Hitmonlee's move at Lv. 22 — a Normal
  self-buff that raises the user's own accuracy *and* evasion by one stage
  each in a single turn), **Crystallize** (Beedrill, Lv. 22 — a Harden-style
  Normal self-buff that raises Defense by two stages and Special by one), and
  **Chaos Sting** (Beedrill, Lv. 38 — a 70-power Bug attack with a 30% chance
  to also inflict a random status: poison, burn, freeze, or paralysis, never
  sleep). Plus: **Rock Fists** (Geodude, Lv. 28 — a Rock move that hits 2-5
  times for 30 each), **Chokehold** (Primeape, Lv. 33 — a Fighting-type Wrap
  that traps for 2-5 turns at 20/turn), **Hot Oil** (Magmar, Lv. 36 — a
  40-power Fire attack that *always* burns), **Bad Touch** (Drowzee, Lv. 42 —
  always confuses, 100% accuracy), **Crush Coil** (Ekans & Arbok, Lv. 42 — a
  Poison-type Wrap dealing 30/turn), and **Blood Suck** (Zubat, Lv. 32 — an
  80-power Poison attack that heals the user for half the damage dealt).
- **Reworked moves**: Whirlwind is now a 20-power Flying attack that lowers
  the target's accuracy by one stage (it no longer ends/flees the battle);
  Razor Wind hits much harder (base power raised to 140).
- **New/earlier level-up moves** on several Pokemon, including: Charmander
  learns Fire Punch (Lv. 10); Pikachu learns Flash (Lv. 7); Grimer learns Acid
  (Lv. 7); Shellder learns Crystallize (Lv. 25). A few are deliberately placed
  *above* the mon's evolution level to reward keeping it unevolved (see below):
  Kabuto gets Cut (7), Crystallize (22) and Guillotine (42); Rhyhorn gets
  Agility (44); Slowpoke gets Thunder (50).
- **Status conditions can now stack** — a Pokemon can be, say, burned *and*
  confused at the same time, where the vanilla game only allowed one at a
  time. (Note: the battle HUD still only has room to show one status icon,
  and only one poison/burn tick's worth of end-of-turn damage is applied
  even when multiple are active — see Known Caveats.)
- **Type/move changes**: Ghost-type moves are now Special category (not
  Physical); Guillotine is now Bug-type; Rock Throw moved to TM34 (replacing
  Bide, which was removed from every Pokemon's compatible-move list);
  Porygon starts with Mimic instead of Tackle; several Pokemon had extra
  HM/TM compatibility added (e.g. more Pokemon can learn Fly); Leech Seed now
  has a 50% chance to also make the target flinch.
- **5 moves per Pokemon**, not the vanilla 4 — battle menus, the Summary
  screen, and Move Relearner/Mimic are all sized for this.
- Some items display under new flavor names but work identically to their
  vanilla counterpart — check the in-game description if a name looks
  unfamiliar.

## Gym Leaders & Trainer Roster Changes

- Viridian Gym is now led by a Normal-type specialist (Tauros, Snorlax,
  Chansey, Kangaskhan, Eevee, Persian), awarding a Normal-type badge and TM
  Hyper Beam.
- Bruno now runs a Fighting Dojo instead of holding an Elite Four seat; his
  old Elite Four slot is filled by a new Bug-type specialist with a custom
  team and unique movesets.
- Every Gym Leader has a full rematch team available post-game, once you've
  cleared the League — these feed into unlocking Battle Island.
- There's a branching allegiance system around Team Rocket vs. Oak's
  establishment: at a key point you can side with Team Rocket or refuse.
  Your choice changes your overworld sprite, which NPCs treat as friend or
  foe in certain questlines (Silph Co.'s floors play out differently
  depending on your allegiance), unlocks path-specific shops/prizes at the
  Game Corner, and affects which endgame content and legendary birds you
  encounter. A further "go rogue" branch exists later in the story.
- Team Rocket grunts in their hideout give Game Corner coins instead of
  cash on defeat, and the Rocket-loyal path unlocks an exclusive coin-shop
  prize list.

## Battle & Difficulty

- **Difficulty select** at the start of a new game: Easy (bonus trainer EXP,
  better default gifts from Megan), Normal, or Hard (no items usable in
  trainer battles, sparser gifts, one big reward cache later on).
- Enemy trainers never use items or switch Pokemon mid-battle, on any
  difficulty — they always just attack.
- The classic Gen 1 "badge boost" bug is fixed: repeatedly raising or lowering
  a stat no longer causes a Pokemon's *other* stats to slowly drift up or down.
  Stats are now recomputed cleanly after every stat-changing move.
- **Cancelling an evolution now sticks.** If you press B to stop a Pokemon
  evolving, it won't ask again until the Pokemon has gained 30 more levels
  (vanilla nagged you every single level-up). This makes it practical to keep a
  Pokemon in its earlier form to reach its unevolved-only moves. (Known beta
  limitation: if you reorder your party or box/withdraw the Pokemon during that
  30-level window, the "don't ask" timer can get misapplied — see Caveats.)
- **Stat & growth-rate changes.** Several Pokemon got base-stat bumps —
  e.g. Onix (HP), Muk (Def), Slowpoke (Special), Ekans/Zubat (Speed, Zubat is
  now blisteringly fast), Shellder (Special & Speed), Kabuto (Def & Speed), and
  Pikachu (very high Speed). Many species also level up faster: Pikachu,
  Sandshrew, Beedrill, Geodude and Kabuto are now Fast-growth, and every
  ordinary Slow-growth species was bumped to Medium-Slow (legendaries and
  pseudo-legendaries were left as-is).
- Wild encounter rates are reduced across routes, caves, and water tiles
  (Safari Zone is unchanged).
- Vitamin (HP Up/Protein/Iron/Calcium/Carbos) and PP Up pricing/behavior may
  differ from vanilla in places — check the in-game description if unsure.
- A "Mutagenstone" item can level a Pokemon straight to 100, correctly
  replaying every evolution and move it would have learned naturally along
  the way. It's earned through a post-game gauntlet, not handed out for
  free.

## Megan & the Phone System

- **Megan** is a recurring NPC (not a following sprite) found in every
  Pokemon Center, every gym, Silph Co., Rocket HQ, and partway through most
  caves. Talking to her heals your party, and gives a one-time gift the
  first time you visit each location.
- The **Start Menu** has a PHONE option: call Megan for item storage, Oak
  for your Pokemon Box storage, and — once unlocked — a third contact tied
  to your story path.
- The **Pokedex is available from the start** of the game — no separate
  fetch-quest required.
- Both an **Item Info** and a **Move Info** viewer are accessible in-menu
  (bag and Pokemon summary screen respectively), showing full
  stats/descriptions.

## Tone & Flavor

NPC dialogue throughout leans into a darker comedic tone — Pokemon are
casually referenced as food/livestock in this world's flavor text (diners,
mart chatter, etc.), and there's an ongoing "whose side are you on"
propaganda thread between the Gyms and the Elite Four that colors a lot of
incidental dialogue. This is atmospheric flavor and doesn't block or change
core gameplay.

## Known Beta Caveats

- The S.S. Olympia rival superboss fight's "fallen partner" callback
  Pokemon is currently a placeholder Gengar rather than a dynamic reflection
  of your own starter — a known simplification, not a bug.
- The "cancel evolution suppresses it for 30 levels" feature tracks the timer
  by party slot, not by the individual Pokemon. If you shuffle your party order
  or deposit/withdraw the Pokemon during those 30 levels, the timer can attach
  to the wrong slot — a Pokemon might get asked to evolve again early, or a
  different one might briefly refuse to evolve. Cancel again (or just keep
  playing) and it sorts itself out.
- Several custom Pokemon (Tyranis, Miasma, Nocturn) and Alakachamp currently
  use placeholder or reused sprites/cries rather than fully original art.
  (Alakachamp does now use its own crimson palette so it's easy to tell apart
  from Machamp.)
- With the new stacking status conditions, the in-battle status icon only
  shows one condition at a time and end-of-turn poison/burn damage is applied
  as a single tick, even if a Pokemon carries more than one status. The
  underlying effects (attack/speed drops, confusion, sleep/freeze skipping
  turns) all still apply — it's just the on-screen readout that's limited.
- This is an active beta. If you hit a freeze, crash, or obviously broken
  interaction, that's exactly the kind of thing to report — several major
  freeze bugs were found and fixed in the lead-up to this build, but more
  may surface.

## Reporting Issues

If something breaks: note where you were, what you just did, and (if
possible) a save state right before it happened. That's the fastest path to
a fix.

Have fun, and thanks for playtesting!
