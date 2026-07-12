# Pokemon Nemesis — Beta Notes

Thanks for testing! This is a Pokemon Blue ROM hack. Below is everything
that's changed from the vanilla game, mechanically — no story spoilers, just
patch notes. If something looks broken, weird, or unfinished, that's exactly
what this beta is for; please report it.

Runs on any Game Boy Color emulator (tested on Pizza Boy GBC for Android).
Saves to battery, same as a real cartridge.

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
  the 5 legendary birds, Mewtwo, and Mew each placed at a rare (~1%)
  encounter slot on their island.
- **S.S. Olympia** — an endgame ship, reachable from Vermilion Dock once
  you've beaten the Champion and hold a Master Ball. Rocket-crewed, with 20
  Level 100 trainers spread across its decks and a Rival superboss fight on
  the open deck with its own Level 100 team, followed by a rare in-game
  trade.

## New Pokemon, Moves & Species Changes

- **New species**: Tyranis, Miasma, and Nocturn (three new legendary-tier
  birds), plus Alakachamp (a Fighting/Psychic Machamp variant, Pokedex #155).
- **New moves**: Web Cannon (Bug, no damage, sharply lowers target Speed),
  Uppercut (Fighting, guaranteed critical hit if you outspeed the target),
  Carrion Wind, Blight Vomit, Mind Fever, Phantom Wing (signature moves for
  the new birds), Double Drill (a signature Flying move), Hyper Beams (a
  double-hit Hyper Beam variant).
- **Type/move changes**: Ghost-type moves are now Special category (not
  Physical); Guillotine is now Bug-type; Rock Throw moved to TM34 (replacing
  Bide, which was removed from every Pokemon's compatible-move list);
  Porygon starts with Mimic instead of Tackle; several Pokemon had extra
  HM/TM compatibility added (e.g. more Pokemon can learn Fly).
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
- Several custom Pokemon (Tyranis, Miasma, Nocturn) and Alakachamp currently
  use placeholder or reused sprites/cries rather than fully original art.
- This is an active beta. If you hit a freeze, crash, or obviously broken
  interaction, that's exactly the kind of thing to report — several major
  freeze bugs were found and fixed in the lead-up to this build, but more
  may surface.

## Reporting Issues

If something breaks: note where you were, what you just did, and (if
possible) a save state right before it happened. That's the fastest path to
a fix.

Have fun, and thanks for playtesting!
