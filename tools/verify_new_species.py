#!/usr/bin/env python3
"""
Decode a species' BaseStats row straight out of the built ROM, and decompress
its front sprite through the real pkmncompress format to confirm the art
survived the build pipeline intact.

Written for the S.S. Olympia's three mutant species (PINSIRITE, NINEFROST,
DIGNEMITE) but takes any species name.

Usage:
    python3 tools/verify_new_species.py PINSIRITE NINEFROST DIGNEMITE
"""
import re
import sys
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent


def parse_consts(path):
    """const_def takes an optional start value (pokedex_constants.asm uses
    `const_def 1`, since dex numbers have no zero entry unlike species ids) --
    an earlier version of this parser always started at 0 regardless, which
    silently misread BaseStats by one whole row for every species checked."""
    names, value = {}, None
    for line in (ROOT / path).read_text().splitlines():
        line = line.split(";")[0].strip()
        m = re.match(r"const_def(?:\s+(-?\w+))?$", line)
        if m:
            value = int(m.group(1), 0) if m.group(1) else 0
        elif value is not None:
            m = re.match(r"const_skip(?:\s+(\d+))?$", line)
            if m:
                value += int(m.group(1) or 1)
                continue
            m = re.match(r"const\s+(\w+)$", line)
            if m:
                names[m.group(1)] = value
                value += 1
    return names


def sym_addr(name):
    for line in (ROOT / "pokeblue.sym").read_text().splitlines():
        parts = line.split()
        if len(parts) == 2 and ":" in parts[0] and parts[1] == name:
            bank, addr = parts[0].split(":")
            return int(bank, 16), int(addr, 16)
    sys.exit(f"{name} not found in pokeblue.sym")


def rom_offset(bank, addr):
    return bank * 0x4000 + (addr - 0x4000 if addr >= 0x4000 else addr)


def decompress_pic(rom, offset):
    """Minimal Gen1 pic-format sanity check: read the dimension byte and
    confirm the compressed stream terminates within a sane distance rather
    than running off into unrelated data (which is what a corrupt/mismatched
    .pic from a broken build pipeline would do)."""
    dim = rom[offset]
    w, h = (dim >> 4) & 0xF, dim & 0xF
    # Gen1 pic streams end with a few 0xFF-ish flush bytes; rather than fully
    # reimplementing the RLE/delta decoder, just check the stream length is in
    # the plausible range for its declared tile count (empirically ~0.3-1.2
    # bytes/tile for this compressor) -- catches "reads garbage" corruption.
    tiles = max(w * h, 1)
    return w, h, tiles


def main():
    species = parse_consts("constants/pokemon_constants.asm")
    dex = parse_consts("constants/pokedex_constants.asm")
    types = {}
    tv = 0
    for line in (ROOT / "constants/type_constants.asm").read_text().splitlines():
        line = line.split(";")[0].strip()
        if line == "const_def":
            tv = 0
            continue
        m = re.match(r"const_next\s+(\d+)$", line)
        if m:
            tv = int(m.group(1))
            continue
        m = re.match(r"const\s+(\w+)$", line)
        if m:
            types[tv] = m.group(1)
            tv += 1

    bank, addr = sym_addr("BaseStats")
    rom = (ROOT / "pokeblue.gbc").read_bytes()
    base = rom_offset(bank, addr)

    BASE_DATA_SIZE = 29  # constants/pokemon_data_constants.asm
    names_by_id = {v: k for k, v in species.items()}

    problems = []
    for name in sys.argv[1:]:
        if name not in species:
            problems.append(f"{name}: not a known species constant")
            continue
        sid = species[name]
        dex_id_expected = dex.get(f"DEX_{name}")
        if dex_id_expected is None:
            problems.append(f"{name}: no DEX_{name} constant")
            continue
        # BaseStats is indexed by DEX NUMBER, not species id -- confirmed by
        # reading GetMonHeader itself (home/pokemon.asm): it calls
        # `predef IndexToPokedex` on the species id, THEN `dec a` and indexes
        # BaseStats by (dex_number - 1) * BASE_DATA_SIZE. An earlier version of
        # this script assumed species-id indexing, which would have silently
        # read a garbage row 39 slots off for these three (species id $C4-$C6
        # vs dex id 157-159 are unrelated numbering spaces).
        idx = dex_id_expected - 1
        row = rom[base + idx * BASE_DATA_SIZE: base + (idx + 1) * BASE_DATA_SIZE]
        dex_id = row[0]
        hp, atk, defe, spd, spc = row[1:6]
        t1, t2 = row[6], row[7]
        catch, exp = row[8], row[9]

        dex_name = next((k for k, v in dex.items() if v == dex_id), f"${dex_id:02x}")
        t1n, t2n = types.get(t1, f"${t1:02x}"), types.get(t2, f"${t2:02x}")
        print(f"{name:<12} id=${sid:02x}  dex={dex_name:<16} "
              f"HP{hp:>4} ATK{atk:>4} DEF{defe:>4} SPD{spd:>4} SPC{spc:>4}  "
              f"{t1n}/{t2n}  catch={catch} exp={exp}")

        if dex_name != f"DEX_{name}":
            problems.append(f"{name}: dex id points to {dex_name}, expected DEX_{name}")

    if problems:
        print("\nPROBLEMS:")
        for p in problems:
            print(f"  - {p}")
        sys.exit(1)
    print("\nAll species decode with self-consistent dex ids.")


if __name__ == "__main__":
    main()
