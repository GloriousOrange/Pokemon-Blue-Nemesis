; Curated Mutagenstone movesets, one row per species.
;
; A Mutagenstone jumps a mon to level 100, and left to itself WriteMonMoves
; hands it whatever the last NUM_MOVES entries of its learnset happen to be --
; which is rarely the set that species actually wants. These rows override that.
;
; ONE TABLE, TWO CONSUMERS: the player's mutagenated mons read it (via
; .useLevelStone in engine/items/item_effects.asm) and so will the S.S. Olympia's
; one-Pokemon trainers, so a signature move only has to appear in the row here --
; it needs no separate LoneMoves entry or read_trainer_party.asm case.
;
; The table is SPARSE and keyed by species id, terminated by a 0 species byte.
; Species indices run $01-$C3 with gaps, so a dense index-addressed table would
; burn ~975 bytes to hold ~155 real rows; a linear scan costs nothing here
; because this runs once per item use, not per frame. A species with no row
; falls back to WriteMonMoves, so this table can be filled in a few rows at a
; time without ever leaving the game in a broken state.
;
; Every row below is Josh's own curation -- do not invent rows.

MutagenMovesets::
	;                species,     move 1,         move 2,        move 3,        move 4,       move 5

; --- S.S. Olympia, the 16 named trainers ---
	mutagen_moveset GOLEM,       ROCK_FISTS,     EXPLOSION,     CRYSTALLIZE,   EARTHQUAKE,   SAND_ATTACK
	mutagen_moveset STARMIE,     PSYCHIC_M,      SURF,          THUNDERBOLT,   RECOVER,      ICE_BEAM
; NOVA_BLITZ replaces THUNDERBOLT rather than joining it: the row was already
; full at 5, and NOVA_BLITZ is the bigger Electric STAB (35 x 2-5 against 95).
; STATIC_SHOCK stays for the guaranteed paralysis. -- Josh's call to change.
	mutagen_moveset RAICHU,      NOVA_BLITZ,     THUNDER,       BODY_SLAM,     AGILITY,      HYPER_BEAM
	mutagen_moveset VENUSAUR,    GIGA_DRAIN,     RAZOR_LEAF,    SLEEP_POWDER,  TOXIC,        BODY_SLAM
	mutagen_moveset WEEZING,     SLUDGE,         REST,          THUNDERBOLT,   FIRE_BLAST,   EXPLOSION
	mutagen_moveset ALAKAZAM,    PSYCHIC_M,      RECOVER,       THUNDER_WAVE,  REFLECT,      TOXIC
	mutagen_moveset CHARIZARD,   FLAME_WHIP,     SLASH,         EARTHQUAKE,    SWORDS_DANCE, HYPER_BEAM
	mutagen_moveset PERSIAN,     JACKPOT,        SLASH,         HYPER_BEAM,    DOUBLE_TEAM,  THUNDERBOLT
	mutagen_moveset LAPRAS,      ICE_BOMB,       SURF,          THUNDERBOLT,   BODY_SLAM,    CONFUSE_RAY
	mutagen_moveset MACHAMP,     UPPERCUT,       MEGA_PUNCH,    EARTHQUAKE,    CHOKEHOLD,    ROCK_FISTS
	mutagen_moveset GENGAR,      GHOST_BEAM,     SHADOW_PUNCH,  HYPNOSIS,      DREAM_EATER,  THUNDERBOLT
	mutagen_moveset DRAGONITE,   HYPER_BEAM,     HURRICANE,     BLIZZARD,      THUNDERBOLT,  AGILITY
	mutagen_moveset PINSIR,      WEB_CANNON,     GUILLOTINE,    VIBRATE,       SLASH,        EARTHQUAKE
	mutagen_moveset ALAKACHAMP,  UPPERCUT,       PSYCHIC_M,     AGILITY,       EARTHQUAKE,   RECOVER
	mutagen_moveset MEWTWO,      PSYCHIC_M,      AMNESIA,       RECOVER,       ICE_BEAM,     THUNDERBOLT
	mutagen_moveset SLOWBRO,     PSYCHIC_M,      SURF,          AMNESIA,       BODY_SLAM,    EARTHQUAKE

; --- S.S. Olympia, the 24 NPC classes ---
	mutagen_moveset RATICATE,    HYPER_BEAM,     SUPER_FANG,    BODY_SLAM,     BLOOD_SUCK,   QUICK_ATTACK
	mutagen_moveset BEEDRILL,    CHAOS_STING,    TWINEEDLE,     SWORDS_DANCE,  CRYSTALLIZE,  SLUDGE
	mutagen_moveset CLEFABLE,    BODY_SLAM,      THUNDERBOLT,   ICE_BEAM,      MINIMIZE,     TOXIC
	mutagen_moveset POLIWRATH,   SURF,           SUBMISSION,    AMNESIA,       HYPNOSIS,     ICE_BEAM
	mutagen_moveset NIDOKING,    EARTHQUAKE,     THUNDERBOLT,   ICE_BEAM,      ROCK_SLIDE,   BODY_SLAM
	mutagen_moveset WIGGLYTUFF,  BODY_SLAM,      THUNDERBOLT,   SING,          REST,         TOXIC
	mutagen_moveset RHYDON,      EARTHQUAKE,     GRAVITY_SLAM,  HORN_DRILL,    AGILITY,      BODY_SLAM
	mutagen_moveset MAGNETON,    THUNDERBOLT,    STATIC_SHOCK,  REFLECT,       SWIFT,        TOXIC
	mutagen_moveset ONIX,        EARTHQUAKE,     ROCK_SLIDE,    TOXIC,         SUBSTITUTE,   BODY_SLAM
	mutagen_moveset MUK,         SLUDGE,         CRUSH_COIL,    FIRE_BLAST,    BODY_SLAM,    THUNDERBOLT
	mutagen_moveset ARCANINE,    FIRE_BLAST,     SWIFT,         HYPER_BEAM,    BODY_SLAM,    AGILITY
	mutagen_moveset ELECTRODE,   THUNDERBOLT,    EXPLOSION,     THUNDER_WAVE,  SCREECH,      AGILITY
	mutagen_moveset GYARADOS,    SURF,           HURRICANE,     HYPER_BEAM,    BLIZZARD,     CRUSH_JAW
	mutagen_moveset TENTACRUEL,  POWER_CLAMP,    ICE_BEAM,      CRUSH_COIL,    SLUDGE,       BARRIER
	mutagen_moveset PRIMEAPE,    CHOKEHOLD,      FOCUS_ENERGY,  HYPER_BEAM,    BODY_SLAM,    ROCK_SLIDE
	mutagen_moveset GOLDUCK,     SURF,           PSYCHIC_M,     ICE_BEAM,      AMNESIA,      BODY_SLAM
	mutagen_moveset VILEPLUME,   PETAL_DANCE,    TANGLE,        SLEEP_POWDER,  SLUDGE,       TOXIC
	mutagen_moveset HYPNO,       BAD_TOUCH,      HYPNOSIS,      DREAM_EATER,   FLASH,        PSYCHIC_M
	mutagen_moveset JOLTEON,     THUNDERBOLT,    STATIC_SHOCK,  PIN_MISSILE,   BODY_SLAM,    HYPER_BEAM
	mutagen_moveset MR_MIME,     PSYCHIC_M,      BARRIER,       THUNDERBOLT,   HYPNOSIS,     SUBSTITUTE
	mutagen_moveset ARBOK,       CRUSH_COIL,     SLUDGE,        EARTHQUAKE,    SCREECH,      BODY_SLAM
	mutagen_moveset PIDGEOT,     HYPER_BEAM,     SKY_ATTACK,    SWIFT,         AGILITY,      DOUBLE_TEAM
	mutagen_moveset HITMONLEE,   SUPER_INSTINCT, BODY_SLAM,     HI_JUMP_KICK,  MEGA_KICK,    TOXIC
	mutagen_moveset NIDOQUEEN,   EARTHQUAKE,     SLUDGE,        TOXIC,         BODY_SLAM,    ICE_BEAM

; --- curated ahead of the ship ---
	mutagen_moveset MAGMAR,      FIRE_BLAST,     HOT_OIL,       HYPER_BEAM,    CONFUSE_RAY,  BODY_SLAM
	mutagen_moveset TAUROS,      HYPER_BEAM,     STAMPEDE,      THUNDERBOLT,   BLIZZARD,     BODY_SLAM

; --- the S.S. Olympia's own clearing-prize mutants ---
; Not just for the Mutagenstone: whatever eventually delivers the ship's
; "choice of three" prize can farcall ApplyMutagenMoveset the same way
; ReadTrainer's Olympia hook does, rather than hardcoding these five moves a
; second time. Also covers the ordinary case of stoning a low-level one later.
	mutagen_moveset PINSIRITE,   WEB_CANNON,     GUILLOTINE,    VIBRATE,       DOUBLE_TEAM,  GRANIT_CLAMP
	mutagen_moveset NINEFROST,   FIRE_BLAST,     BLIZZARD,      SWIFT,         CONFUSE_RAY,  RECOVER
	mutagen_moveset DIGNEMITE,   EARTHQUAKE,     THUNDERBOLT,   STATIC_SHOCK,  SCREECH,      THIRD_RAIL

; --- reduced 58-species list, first batch of 5 (2026-08-02) ---
; Pre-evolutions (Bulbasaur, Charmander, etc.) are NOT listed separately --
; once Mutagenstone evolution-on-use exists, they'll evolve to their final
; form and read this table under THAT species' row. Until then they fall back
; to WriteMonMoves like any other uncurated species; see the "Evolution on
; use" section of the plan for why that's deliberate, not a gap.
	mutagen_moveset AERODACTYL,  SKY_ATTACK,     GRAVITY_SLAM,  EARTHQUAKE,    HYPER_BEAM,   AGILITY
	mutagen_moveset ARTICUNO,    BLIZZARD,       SKY_ATTACK,    HYPER_BEAM,    REFLECT,      SWIFT
	mutagen_moveset BLASTOISE,   SURF,           ICE_BEAM,      EARTHQUAKE,    BODY_SLAM,    TOXIC
	mutagen_moveset BUTTERFREE,  PSYCHIC_M,      MEGA_DRAIN,    SOLARBEAM,     REFLECT,      SWIFT
	mutagen_moveset CHANSEY,     SEISMIC_TOSS,   TOXIC,         THUNDER_WAVE,  SOFTBOILED,   THUNDERBOLT

; --- reduced 58-species list, second batch of 5 (2026-08-02) ---
; DITTO deliberately has no row and never will -- Josh: "it only learns moves
; via TM or HM" and this mod gives it none at all (empty tmhm list), so there
; is no broader movepool to draw a curated upgrade from. Standing exclusion,
; see tools/mutagen_remaining.py.
	mutagen_moveset CLEFAIRY,    SEISMIC_TOSS,   THUNDER_WAVE,  REFLECT,       METRONOME,    TOXIC
	mutagen_moveset CLOYSTER,    POWER_CLAMP,    BLIZZARD,      EXPLOSION,     TOXIC,        REST
	mutagen_moveset DEWGONG,     SURF,           ICE_BEAM,      REST,          SUBSTITUTE,   BODY_SLAM
	mutagen_moveset DODRIO,      DRILL_PECK,     TRI_ATTACK,    AGILITY,       BODY_SLAM,    DOUBLE_EDGE

; --- reduced list, third batch of 5 (2026-08-03) ---
	mutagen_moveset DUGTRIO,     EARTHQUAKE,     ROCK_SLIDE,    FISSURE,       SLASH,        SUBSTITUTE
	mutagen_moveset EEVEE,       BODY_SLAM,      SWIFT,         SUBSTITUTE,    REFLECT,      REST
	mutagen_moveset ELECTABUZZ,  THUNDERPUNCH,   STATIC_SHOCK,  THUNDER,       PSYCHIC_M,    COUNTER
	mutagen_moveset EXEGGCUTE,   SLEEP_POWDER,   REFLECT,       PSYCHIC_M,     SUBSTITUTE,   EXPLOSION
	mutagen_moveset EXEGGUTOR,   PSYCHIC_M,      SOLARBEAM,     HYPNOSIS,      EXPLOSION,    REST

; --- reduced list, fourth batch of 5 (2026-08-03) ---
	mutagen_moveset FARFETCHD,   SWORDS_DANCE,   SLASH,         AGILITY,       DOUBLE_EDGE,  SUBSTITUTE
	mutagen_moveset FEAROW,      DRILL_PECK,     AGILITY,       DOUBLE_EDGE,   SWIFT,        SUBSTITUTE
	mutagen_moveset FLAREON,     FIRE_BLAST,     BODY_SLAM,     HYPER_BEAM,    SWIFT,        SUBSTITUTE
	mutagen_moveset GLOOM,       SLEEP_POWDER,   STUN_SPORE,    MEGA_DRAIN,    REFLECT,      REST
	mutagen_moveset GOLBAT,      BLOOD_SUCK,     DOUBLE_TEAM,   WING_ATTACK,   SCREECH,      DOUBLE_EDGE

; --- reduced list, fifth batch of 5 (2026-08-03) ---
	mutagen_moveset GROWLITHE,   FLAMETHROWER,   AGILITY,       REFLECT,       TOXIC,        SUBSTITUTE
	mutagen_moveset HITMONCHAN,  FIRE_PUNCH,     ICE_PUNCH,     THUNDERPUNCH,  MEGA_PUNCH,   UPPERCUT
	mutagen_moveset JIGGLYPUFF,  DISABLE,        THUNDER_WAVE,  SEISMIC_TOSS,  SUBSTITUTE,   REST
	mutagen_moveset JYNX,        BLIZZARD,       PSYCHIC_M,     LOVELY_KISS,   REFLECT,      ICE_SCULPTURE
	mutagen_moveset KABUTOPS,    SWORDS_DANCE,   SLASH,         SURF,          BODY_SLAM,    REST

; --- reduced list, sixth batch of 5 (2026-08-03) ---
	mutagen_moveset KANGASKHAN,  EARTHQUAKE,     BODY_SLAM,     ROCK_SLIDE,    SUBSTITUTE,   REST
	mutagen_moveset KINGLER,     SWORDS_DANCE,   CRABHAMMER,    GUILLOTINE,    BODY_SLAM,    SURF
	mutagen_moveset LICKITUNG,   EARTHQUAKE,     ICE_BEAM,      BODY_SLAM,     SWORDS_DANCE, REST
	mutagen_moveset MAROWAK,     BONEMERANG,     EARTHQUAKE,    FOCUS_ENERGY,  SUBSTITUTE,   REST
	mutagen_moveset MEW,         PSYCHIC_M,      EARTHQUAKE,    ICE_BEAM,      THUNDERBOLT,  SOFTBOILED

; --- reduced list, seventh batch of 5 (2026-08-03) ---
	mutagen_moveset MEWTHREE,    TELEKINESIS,    BARRIER,       MIST,          PSYCHIC_M,    REST
	mutagen_moveset MIASMA,      SMOKESCREEN,    DRILL_PECK,    BLIGHT_VOMIT,  CARRION_WIND, SWIFT
	mutagen_moveset MOLTRES,     FIRE_BLAST,     SKY_ATTACK,    AGILITY,       SUBSTITUTE,   REST
	mutagen_moveset NIDORINA,    BODY_SLAM,      ICE_BEAM,      THUNDERBOLT,   TOXIC,        SUBSTITUTE
	mutagen_moveset NIDORINO,    FOCUS_ENERGY,   HORN_DRILL,    BODY_SLAM,     ICE_BEAM,     SUBSTITUTE

; --- reduced list, eighth batch of 5 (2026-08-03) ---
	mutagen_moveset NINETALES,   FIRE_BLAST,     REFLECT,       DIG,           SUBSTITUTE,   REST
	mutagen_moveset NOCTURN,     GUST,           NIGHT_SHADE,   PHANTOM_WING,  MIND_FEVER,   SWIFT
	mutagen_moveset OMASTAR,     SURF,           ICE_BEAM,      REFLECT,       REST,         TOXIC
	mutagen_moveset PARASECT,    SPORE,          SLASH,         SWORDS_DANCE,  MEGA_DRAIN,   SUBSTITUTE
	mutagen_moveset PIKACHU,     THUNDERBOLT,    SEISMIC_TOSS,  THUNDER_WAVE,  REFLECT,      SUBSTITUTE

; --- reduced list, ninth batch of 5 (2026-08-03) ---
	mutagen_moveset POLIWHIRL,   EARTHQUAKE,     BUBBLEBEAM,    BODY_SLAM,     COUNTER,      SUBSTITUTE
	mutagen_moveset PORYGON,     SPORE,          DREAM_EATER,   RECOVER,       PSYCHIC_M,    THUNDERBOLT
	mutagen_moveset RAPIDASH,    FIRE_BLAST,     BODY_SLAM,     DOUBLE_EDGE,   AGILITY,      SUBSTITUTE
	mutagen_moveset SANDSLASH,   EARTHQUAKE,     SLASH,         SWORDS_DANCE,  ROCK_SLIDE,   REST
	mutagen_moveset SCYTHER,     SWORDS_DANCE,   FOCUS_ENERGY,  SLASH,         TWINEEDLE,    AGILITY

; --- reduced list, tenth batch of 5 (2026-08-03) ---
	mutagen_moveset SEADRA,      SURF,           ICE_BEAM,      AGILITY,       REST,         SUBSTITUTE
	mutagen_moveset SEAKING,     HORN_DRILL,     AGILITY,       SURF,          ICE_BEAM,     SUBSTITUTE
	mutagen_moveset SHELLDER,    CRYSTALLIZE,    ICE_BEAM,      CLAMP,         SUBSTITUTE,   REST
	mutagen_moveset SNORLAX,     BODY_SLAM,      AMNESIA,       REST,          EARTHQUAKE,   SUBSTITUTE
	mutagen_moveset STARYU,      SURF,           RECOVER,       LIGHT_SCREEN,  SWIFT,        THUNDER_WAVE

; --- reduced list, eleventh and final batch (2026-08-03) ---
	mutagen_moveset TANGELA,     SOLARBEAM,      SLEEP_POWDER,  STUN_SPORE,    REST,         SUBSTITUTE
	mutagen_moveset TYRANIS,     DOUBLE_DRILL,   HYPER_BEAMS,   BODY_SLAM,     SAND_ATTACK,  SWIFT
	mutagen_moveset VAPOREON,    SURF,           ICE_BEAM,      ACID_ARMOR,    REST,         SUBSTITUTE
	mutagen_moveset VENOMOTH,    SLEEP_POWDER,   PSYCHIC_M,     MEGA_DRAIN,    STUN_SPORE,   SUBSTITUTE
	mutagen_moveset VICTREEBEL,  SWORDS_DANCE,   GIGA_DRAIN,    SLUDGE,        STUN_SPORE,   SUBSTITUTE
	mutagen_moveset VULPIX,      FLAMETHROWER,   CONFUSE_RAY,   SWIFT,         TOXIC,        SUBSTITUTE
	mutagen_moveset WEEPINBELL,  MEGA_DRAIN,     SOLARBEAM,     STUN_SPORE,    POISONPOWDER, REFLECT
	mutagen_moveset ZAPDOS,      THUNDERBOLT,    DRILL_PECK,    THUNDER_WAVE,  LIGHT_SCREEN, AGILITY

	db 0 ; end of table -- species with no row above fall back to WriteMonMoves
