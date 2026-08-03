# PKMN Nemesis — Patch & Install

Nemesis is a Pokémon Blue ROM hack. This folder has the **patch** you apply to
your **own** legally-obtained Pokémon Blue cartridge dump. The patch contains
only the hack's changes — you supply the original game.

Once you're playing: **[Team Builder](https://gloriousorange.github.io/Pokemon-Blue-Nemesis/)** (plan a team of 6 with type coverage/gaps/weaknesses and full movepools) · **[Mutagenstone movesets](../MUTAGENSTONE.md)**

## What you need

A **retail Pokémon Blue (USA/Europe)** ROM, exactly this dump:

| | |
|---|---|
| **SHA1** | `d7037c83e1ae5b39bde3c30787637ba1d4c48ce2` |
| **CRC32** | `D6DA8A1A` |
| **Size** | 1,048,576 bytes (`.gb`/`.gbc`) |

If your ROM doesn't match, the patch won't apply correctly — see Troubleshooting.

## Patch files

- **`PKMN Nemesis.bps`** ← **use this one.** It checks your base ROM is correct
  and refuses a wrong/headered file (this is the usual reason patching "fails").
- `PKMN Nemesis.ips` — fallback only, for older patchers that can't do BPS. It
  does **not** verify your ROM, so a wrong base silently makes a broken game.

## How to apply (Android)

1. Put your **vanilla Blue ROM** and **`PKMN Nemesis.bps`** on your phone.
2. Open a patcher. Easiest with no install: the **Rom Patcher JS** web app in
   your mobile browser (it runs locally, nothing is uploaded). Any Android app
   that supports **BPS** works too.
3. Pick your vanilla ROM + the `.bps`, tap **Apply**, and save the output.
   Rename it **`PKMN Nemesis.gbc`**.
4. Open that file in any Game Boy Color emulator — **Pizza Boy GBC**,
   **Nostalgia**, mGBA, etc. Nemesis is a real GBC game now, so every emulator
   shows the same intended colors instead of guessing its own.
5. The cartridge title reads **PKMN NEMESIS** in-game, so you can tell it apart
   even if Android hides the filename. It battery-saves like a real cartridge.

Desktop is the same idea with any patcher (e.g. Floating IPS / "Flips").

## Troubleshooting

- **"Patch doesn't apply" / wrong checksum:** your base ROM isn't the exact dump
  above. Common causes: it's actually a different version, or it has a 512-byte
  copier header. Verify the SHA1/CRC32 first.
- **Game boots but looks corrupted:** you used the `.ips` on a mismatched ROM.
  Use the `.bps` instead — it would have caught it.
- **No color / black-and-white:** your emulator is running the game as an
  original Game Boy. Turn off any "force DMG / original Game Boy" setting so it
  runs in Game Boy Color mode.

## Color schemes

Nemesis ships two. On the **OPTION** screen (Start menu → OPTION), press
**SELECT** to switch the `COLOR` setting:

- **DIVERSE** (default) — each town, route and species gets its own palette,
  with deep blue water.
- **NEON** — one high-contrast ramp for the whole game: red where the Game Boy
  would draw white, plus bright green, deep blue and black.

The choice is stored in your save file.

This is an active beta — see `BETA_README.md` in the repo root for the full
change list and known caveats.
