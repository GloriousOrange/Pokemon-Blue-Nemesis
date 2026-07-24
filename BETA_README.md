# Pokemon Nemesis — Beta Notes

Thanks for testing! This is a Pokemon Blue ROM hack. Below is everything
that's changed from the vanilla game, mechanically — no story spoilers beyond
what you'd naturally discover in the first hour or two, just patch notes. If
something looks broken, weird, or unfinished, that's exactly what this beta
is for; please report it.

Runs on Game Boy Color emulators. **Pizza Boy GBC is recommended** — it runs
this build best, in full color. **Nostalgia** also works and battery-saves
fine, but currently only renders in black-and-white on this build (no other
known issues on it). Either way, saves work like a real cartridge.

## New Areas

- **Battle Island** — reachable once you've beaten every Gym Leader a second
  time (a full rematch tour, available after the Elite Four). Beating the
  last rematch marks the island on your map; Fly there anytime after that.
  It's an open-air post-game hub with:
  - **6 scientists** standing out in the open, each a one-Pokemon Level 100
    battle with their own dialogue. Beat all 6 and the last one hands you
    6 **Mutagenstones** and points you toward Professor Oak, who's made his
    way to the island's south shore.
  - **Professor Oak**, a Level 100 superboss with a signature 6-Pokemon team.
    Beating him unlocks the island's arena and hands over an HM,
    **Metronome2**.
  - **The Arena**: a 26-trainer battle gauntlet (party capped at 3 Pokemon
    per fight — you'll be sent to store extras at the island's PC first).
    Clear all 26 and Giovanni himself steps up for a final fight; after that,
    the gauntlet just keeps running endless rematches.
  - Its own wild-encounter zone, and a healer/PC building at the island's
    north edge.
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

The Pokemon Mansion on Cinnabar Island is a normal wild-encounter dungeon
(with some higher-level, evolved wilds compared to vanilla) — nothing about
reaching Battle Island runs through it.

## New Pokemon, Moves & Species Changes

- **New species**: Tyranis, Miasma, and Nocturn (three new legendary-tier
  birds), plus Alakachamp (a Fighting/Psychic Machamp variant, Pokedex #155).
- **New moves**:
  - **Web Cannon** (Bug) — no damage; drops the target's Speed to the minimum
    in a single hit.
  - **Uppercut** (Fighting) — guaranteed critical hit if you outspeed the
    target.
  - **Carrion Wind** (Poison, Miasma) — always strikes first and flinches on
    any hit that connects, then badly-poisons. Only 1 PP.
  - **Mind Fever** (Ghost, Nocturn) — confuses *and* burns the target. Only
    1 PP.
  - **Blight Vomit** (Poison, Miasma) — 80-power hit with a chance to paralyze.
  - **Phantom Wing** (Ghost, Nocturn) — 80-power hit that lowers the target's
    Special.
  - **Double Drill** (Flying) — 80-power hit that lowers the target's Defense.
  - **Hyper Beams** (Normal) — a double-hit Hyper Beam variant.
  - **Jackpot** (Normal, Persian Lv. 98) — deals damage and, like Pay Day,
    scatters $300–$1000 you collect after the battle.
  - **Instinct** (Normal, Hitmonlee Lv. 22) — self-buff that raises the user's
    own accuracy *and* evasion by one stage each.
  - **Crystallize** (Normal, Beedrill Lv. 22) — Harden-style self-buff: +2
    Defense and +1 Special.
  - **Chaos Sting** (Bug, Beedrill Lv. 38) — 70-power hit with a 30% chance to
    inflict a random status (poison, burn, freeze, or paralysis — never sleep).
  - **Rock Fists** (Rock, Geodude Lv. 28) — hits 2–5 times for 30 each.
  - **Chokehold** (Fighting, Primeape Lv. 33) — a Wrap-style trap, 20/turn for
    2–5 turns.
  - **Hot Oil** (Fire, Magmar Lv. 36) — 40-power hit that *always* burns.
  - **Bad Touch** (Drowzee Lv. 42) — always confuses; 100% accuracy.
  - **Crush Coil** (Poison, Ekans & Arbok Lv. 42) — a Wrap-style trap dealing
    30/turn.
  - **Blood Suck** (Poison, Zubat Lv. 32) — 80-power hit that heals the user
    for half the damage dealt.
- **Reworked moves**: Whirlwind is now a 20-power Flying attack that lowers
  the target's accuracy by one stage (it no longer ends/flees the battle);
  Razor Wind hits much harder (base power raised to 140).
- **Move type reassignments**: a handful of moves changed elemental type for
  balance/flavor reasons — most notably Guillotine and Vice Grip are now
  Bug-type instead of Normal.
- **New/earlier level-up moves** on several Pokemon, including: Charmander
  learns Fire Punch (Lv. 10); Pikachu learns Flash (Lv. 7); Grimer learns Acid
  (Lv. 7); Shellder learns Crystallize (Lv. 25). A few are deliberately placed
  *above* the mon's evolution level to reward keeping it unevolved (see below):
  Kabuto gets Cut (7), Crystallize (22) and Guillotine (42); Rhyhorn gets
  Agility (44); Slowpoke gets Thunder (50).
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
  cleared the League — these feed into unlocking Battle Island (see above).
- There's a branching allegiance system around Team Rocket vs. Oak's
  establishment: at a key point you can side with Team Rocket or refuse.
  Your choice changes your overworld sprite, which NPCs treat as friend or
  foe in certain questlines (Silph Co.'s floors play out differently
  depending on your allegiance), unlocks path-specific shops/prizes at the
  Game Corner, and affects which endgame content and legendary birds you
  encounter. A further "go rogue" branch exists later in the story, tied to
  a certain encounter at the top of Pokemon Tower.
- Team Rocket grunts in their hideout give Game Corner coins instead of
  cash on defeat, and the Rocket-loyal path unlocks an exclusive coin-shop
  prize list.
- On the Loyalist path, Silph Co.'s top floor swaps the usual Giovanni fight
  for a different boss encounter.

## Battle & Difficulty

- **Difficulty select** at the start of a new game: Easy (bonus trainer EXP,
  better default gifts from Megan), Normal, or Hard (no items usable in
  trainer battles, sparser gifts, one big reward cache later on).
- Enemy trainers never use items or switch Pokemon mid-battle, on any
  difficulty — they always just attack.
- The classic Gen 1 "badge boost" bug is fixed: repeatedly raising or lowering
  a stat no longer causes a Pokemon's *other* stats to slowly drift up or down.
  Stats are now recomputed cleanly after every stat-changing move.
- A separate, obscure Gen 1 engine bug is also fixed: a critical hit against
  a Pokemon with a very high Defense or Special stat (only really possible at
  Level 100) could previously cause the game to freeze outright. This only
  ever surfaced against the game's toughest post-game superbosses.
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
- **Mutagenstones** can level a Pokemon straight to 100 right from your bag
  (outside of battle — it can't be used mid-fight), correctly replaying every
  evolution and move it would have learned naturally along the way instead of
  just jumping to 100 with its original moveset. They're earned from Battle
  Island's scientists (see New Areas above), not handed out for free.

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
incidental dialogue. The Rival is played straight and serious throughout,
including a darker opening and a final confrontation on the S.S. Olympia's
deck (see New Areas). This is atmospheric flavor and doesn't block or change
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
- On Nostalgia specifically, the game currently renders in black-and-white
  instead of full Game Boy Color palettes. Battery saves and everything else
  work fine on it — this appears to be an emulator-specific display quirk.
  Pizza Boy GBC shows full color.
- After beating Professor Oak on Battle Island, you may find yourself unable
  to walk (though you can still talk to him). Flying to another town and
  back clears it. We haven't nailed down the root cause yet.
- This is an active beta. If you hit a freeze, crash, or obviously broken
  interaction, that's exactly the kind of thing to report — several major
  freeze bugs were found and fixed in the lead-up to this build, but more
  may surface, especially around the new Level 100 post-game content.

## Reporting Issues

If something breaks: note where you were, what you just did, and (if
possible) a save state right before it happened. That's the fastest path to
a fix.

Have fun, and thanks for playtesting!
