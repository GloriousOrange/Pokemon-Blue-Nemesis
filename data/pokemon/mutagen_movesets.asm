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
	mutagen_moveset RAICHU,      THUNDERBOLT,    STATIC_SHOCK,  BODY_SLAM,     AGILITY,      HYPER_BEAM
	mutagen_moveset VENUSAUR,    GIGA_DRAIN,     RAZOR_LEAF,    SLEEP_POWDER,  TOXIC,        BODY_SLAM
	mutagen_moveset WEEZING,     SLUDGE,         BLIGHT_VOMIT,  THUNDERBOLT,   FIRE_BLAST,   TOXIC
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
	mutagen_moveset BEEDRILL,    CHAOS_STING,    TWINEEDLE,     SWORDS_DANCE,  CRYSTALLIZE,  TOXIC
	mutagen_moveset CLEFABLE,    BODY_SLAM,      THUNDERBOLT,   ICE_BEAM,      MINIMIZE,     TOXIC
	mutagen_moveset POLIWRATH,   SURF,           SUBMISSION,    AMNESIA,       HYPNOSIS,     ICE_BEAM
	mutagen_moveset NIDOKING,    EARTHQUAKE,     THUNDERBOLT,   ICE_BEAM,      ROCK_SLIDE,   BODY_SLAM
	mutagen_moveset WIGGLYTUFF,  BODY_SLAM,      THUNDERBOLT,   SING,          REST,         TOXIC
	mutagen_moveset RHYDON,      EARTHQUAKE,     GRAVITY_SLAM,  ROCK_SLIDE,    SWORDS_DANCE, BODY_SLAM
	mutagen_moveset MAGNETON,    THUNDERBOLT,    STATIC_SHOCK,  REFLECT,       SWIFT,        TOXIC
	mutagen_moveset ONIX,        EARTHQUAKE,     ROCK_SLIDE,    TOXIC,         SUBSTITUTE,   BODY_SLAM
	mutagen_moveset MUK,         SLUDGE,         CRUSH_COIL,    TOXIC,         BODY_SLAM,    THUNDERBOLT
	mutagen_moveset ARCANINE,    FIRE_BLAST,     SWIFT,         HYPER_BEAM,    BODY_SLAM,    AGILITY
	mutagen_moveset ELECTRODE,   THUNDERBOLT,    EXPLOSION,     THUNDER_WAVE,  SCREECH,      AGILITY
	mutagen_moveset GYARADOS,    SURF,           HURRICANE,     HYPER_BEAM,    BLIZZARD,     CRUSH_JAW
	mutagen_moveset TENTACRUEL,  SURF,           ICE_BEAM,      CRUSH_COIL,    TOXIC,        BARRIER
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

	db 0 ; end of table -- species with no row above fall back to WriteMonMoves
