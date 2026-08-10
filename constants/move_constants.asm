; move ids
; indexes for:
; - Moves (see data/moves/moves.asm)
; - MoveNames (see data/moves/names.asm)
; - AttackAnimationPointers (see data/moves/animations.asm)
; - MoveSoundTable (see data/moves/sfx.asm)
	const_def
	const NO_MOVE      ; 00
	const POUND        ; 01
	const KARATE_CHOP  ; 02
	const DOUBLESLAP   ; 03
	const COMET_PUNCH  ; 04
	const MEGA_PUNCH   ; 05
	const PAY_DAY      ; 06
	const FIRE_PUNCH   ; 07
	const ICE_PUNCH    ; 08
	const THUNDERPUNCH ; 09
	const SCRATCH      ; 0a
	const VICEGRIP     ; 0b
	const GUILLOTINE   ; 0c
	const RAZOR_WIND   ; 0d
	const SWORDS_DANCE ; 0e
	const CUT          ; 0f
	const GUST         ; 10
	const WING_ATTACK  ; 11
	const WHIRLWIND    ; 12
	const FLY          ; 13
	const BIND         ; 14
	const SLAM         ; 15
	const VINE_WHIP    ; 16
	const STOMP        ; 17
	const DOUBLE_KICK  ; 18
	const MEGA_KICK    ; 19
	const JUMP_KICK    ; 1a
	const ROLLING_KICK ; 1b
	const SAND_ATTACK  ; 1c
	const HEADBUTT     ; 1d
	const HORN_ATTACK  ; 1e
	const FURY_ATTACK  ; 1f
	const HORN_DRILL   ; 20
	const TACKLE       ; 21
	const BODY_SLAM    ; 22
	const WRAP         ; 23
	const TAKE_DOWN    ; 24
	const THRASH       ; 25
	const DOUBLE_EDGE  ; 26
	const TAIL_WHIP    ; 27
	const POISON_STING ; 28
	const TWINEEDLE    ; 29
	const PIN_MISSILE  ; 2a
	const LEER         ; 2b
	const BITE         ; 2c
	const GROWL        ; 2d
	const ROAR         ; 2e
	const SING         ; 2f
	const SUPERSONIC   ; 30
	const SONICBOOM    ; 31
	const DISABLE      ; 32
	const ACID         ; 33
	const EMBER        ; 34
	const FLAMETHROWER ; 35
	const MIST         ; 36
	const WATER_GUN    ; 37
	const HYDRO_PUMP   ; 38
	const SURF         ; 39
	const ICE_BEAM     ; 3a
	const BLIZZARD     ; 3b
	const PSYBEAM      ; 3c
	const BUBBLEBEAM   ; 3d
	const AURORA_BEAM  ; 3e
	const HYPER_BEAM   ; 3f
	const PECK         ; 40
	const DRILL_PECK   ; 41
	const SUBMISSION   ; 42
	const LOW_KICK     ; 43
	const COUNTER      ; 44
	const SEISMIC_TOSS ; 45
	const STRENGTH     ; 46
	const ABSORB       ; 47
	const MEGA_DRAIN   ; 48
	const LEECH_SEED   ; 49
	const GROWTH       ; 4a
	const RAZOR_LEAF   ; 4b
	const SOLARBEAM    ; 4c
	const POISONPOWDER ; 4d
	const STUN_SPORE   ; 4e
	const SLEEP_POWDER ; 4f
	const PETAL_DANCE  ; 50
	const STRING_SHOT  ; 51
	const DRAGON_RAGE  ; 52
	const FIRE_SPIN    ; 53
	const THUNDERSHOCK ; 54
	const THUNDERBOLT  ; 55
	const THUNDER_WAVE ; 56
	const THUNDER      ; 57
	const ROCK_THROW   ; 58
	const EARTHQUAKE   ; 59
	const FISSURE      ; 5a
	const DIG          ; 5b
	const TOXIC        ; 5c
	const CONFUSION    ; 5d
	const PSYCHIC_M    ; 5e
	const HYPNOSIS     ; 5f
	const MEDITATE     ; 60
	const AGILITY      ; 61
	const QUICK_ATTACK ; 62
	const RAGE         ; 63
	const TELEPORT     ; 64
	const NIGHT_SHADE  ; 65
	const MIMIC        ; 66
	const SCREECH      ; 67
	const DOUBLE_TEAM  ; 68
	const RECOVER      ; 69
	const HARDEN       ; 6a
	const MINIMIZE     ; 6b
	const SMOKESCREEN  ; 6c
	const CONFUSE_RAY  ; 6d
	const WITHDRAW     ; 6e
	const DEFENSE_CURL ; 6f
	const BARRIER      ; 70
	const LIGHT_SCREEN ; 71
	const HAZE         ; 72
	const REFLECT      ; 73
	const FOCUS_ENERGY ; 74
	const BIDE         ; 75
	const METRONOME    ; 76
	const MIRROR_MOVE  ; 77
	const SELFDESTRUCT ; 78
	const EGG_BOMB     ; 79
	const LICK         ; 7a
	const SMOG         ; 7b
	const SLUDGE       ; 7c
	const BONE_CLUB    ; 7d
	const FIRE_BLAST   ; 7e
	const WATERFALL    ; 7f
	const CLAMP        ; 80
	const SWIFT        ; 81
	const SKULL_BASH   ; 82
	const SPIKE_CANNON ; 83
	const CONSTRICT    ; 84
	const AMNESIA      ; 85
	const KINESIS      ; 86
	const SOFTBOILED   ; 87
	const HI_JUMP_KICK ; 88
	const GLARE        ; 89
	const DREAM_EATER  ; 8a
	const POISON_GAS   ; 8b
	const BARRAGE      ; 8c
	const LEECH_LIFE   ; 8d
	const LOVELY_KISS  ; 8e
	const SKY_ATTACK   ; 8f
	const TRANSFORM    ; 90
	const BUBBLE       ; 91
	const DIZZY_PUNCH  ; 92
	const SPORE        ; 93
	const FLASH        ; 94
	const PSYWAVE      ; 95
	const SPLASH       ; 96
	const ACID_ARMOR   ; 97
	const CRABHAMMER   ; 98
	const EXPLOSION    ; 99
	const FURY_SWIPES  ; 9a
	const BONEMERANG   ; 9b
	const REST         ; 9c
	const ROCK_SLIDE   ; 9d
	const HYPER_FANG   ; 9e
	const SHARPEN      ; 9f
	const CONVERSION   ; a0
	const TRI_ATTACK   ; a1
	const SUPER_FANG   ; a2
	const SLASH        ; a3
	const SUBSTITUTE   ; a4
	const DOUBLE_DRILL ; a5
	const HYPER_BEAMS  ; a6
	const METRONOME2   ; a7 - HM move: rolls a random move from a fixed 19-move list
	const CARRION_WIND ; a8 - Poison, badly-poison status (Miasma)
	const BLIGHT_VOMIT ; a9 - Poison, dmg + paralyze (Miasma)
	const MIND_FEVER   ; aa - Ghost, confuse + burn 'curse' (Nocturn)
	const PHANTOM_WING ; ab - Ghost, dmg + lower Special (Nocturn)
	const WEB_CANNON   ; ac - Bug, drops target Speed to minimum (-6) in one hit (Toby)
	const UPPERCUT     ; ad - Fighting, always crits if user outspeeds target (Alakachamp)
	const JACKPOT        ; ae - Normal, Pay Day-style: 80 dmg + scatters $300-$1000 (Persian, lv98)
	const SUPER_INSTINCT ; af - Normal, raises user's accuracy + evasion by 1 each (Hitmonlee, lv22)
	const CRYSTALLIZE    ; b0 - Normal, raises user's Defense by 2 + Special by 1 (Beedrill, lv22)
	const CHAOS_STING    ; b1 - Bug, 70 dmg, 30% random status (any but sleep) (Beedrill, lv38)
	const CHOKEHOLD      ; b2 - Fighting, Wrap-style trap: 25 dmg/turn for 2-5 turns (Primeape, lv33)
	const ROCK_FISTS     ; b3 - Rock, multi-hit: 30 dmg x 2-5 hits (Geodude, lv28)
	const HOT_OIL        ; b4 - Fire, 40 dmg + guaranteed burn (Magmar, lv36)
	const BAD_TOUCH      ; b5 - Normal, always confuses, 100 acc (Drowzee, lv42)
	const CRUSH_COIL     ; b6 - Poison, Wrap-style trap: 30 dmg/turn (Ekans/Arbok, lv42)
	const BLOOD_SUCK     ; b7 - Poison, 80 dmg, drains half as HP (Zubat, lv32)
	const HURRICANE      ; b8 - Dragon, 80 dmg, high crit ratio; Gust anim (Gyarados, lv42)
	const ICE_SPIKE      ; b9 - Ice, 25 dmg (Shellder)
	const MIGRAIN        ; ba - Psychic, 30 dmg (Caterpie)
	const DIVE           ; bb - Flying, 30 dmg (Zubat)
	const STATIC_SHOCK   ; bc - Electric, 40 dmg, always paralyzes (Electabuzz niche)
	const GRAVITY_SLAM   ; bd - Rock, 80 dmg, always paralyzes (Aerodactyl niche)
	const VIBRATE        ; be - raise user's Attack + Speed by 2 (Pinsir niche)
	const STEALTH        ; bf - raise user's Evasion by 2 (Scyther niche)
	const TANGLE         ; c0 - Grass, 50 dmg + lowers target Speed by 3 (Tangela niche)
	const ICE_BOMB       ; c1 - Ice, 100 dmg, 50% freeze, 100 acc (Lapras niche)
	const ICE_SCULPTURE  ; c2 - makes a Substitute; damaging it may freeze (Jynx niche)
	const STAMPEDE       ; c3 - Normal, 150 dmg, 2-turn charge like Dig (Tauros niche)
	const ROLL           ; c4 - Normal, 120 dmg, 85 acc, no side effect (Snorlax heavy hitter; self-Defense drop removed -- froze vs transformed mons)
; Fixed 35-power STAB fillers for starters whose level-1 moveset had no
; same-type move at all (see scripts/gen_tables.py's StarterSpeciesTable).
; Grass/Water/Flying already had a 35-power move (Vine Whip/Clamp/Peck) to
; reuse; these 8 cover the remaining types that didn't.
	const VENOM_BITE     ; c5 - Poison, 35 dmg (Ekans/Nidoran/Grimer starter STAB filler)
	const MUD_SLAP       ; c6 - Ground, 35 dmg (Sandshrew/Diglett/Geodude/Onix/Rhyhorn starter STAB filler)
	const MANDIBLE_BITE  ; c7 - Bug, 35 dmg (Paras/Venonat/Scyther starter STAB filler)
	const PALM_STRIKE    ; c8 - Fighting, 35 dmg (Mankey/Hitmonchan starter STAB filler)
	const SCORCH         ; c9 - Fire, 35 dmg (Growlithe starter STAB filler)
	const SPARK          ; ca - Electric, 35 dmg (Magnemite/Voltorb/Electabuzz starter STAB filler)
	const PSY_CHOP       ; cb - Psychic, 35 dmg (Drowzee/Jynx/Mew starter STAB filler)
	const DRAGON_BREATH  ; cc - Dragon, 35 dmg (Dratini starter STAB filler)
	const GLITTER_WING   ; cd - Bug, 35 dmg, 100 acc, ~30% sleep (Butterfree)
	const TELEKINESIS    ; ce - Psychic, 30 dmg x2-5 hits (Armored Mewtwo, L99)
	const FLAME_WHIP     ; cf - Fire, 100 dmg, 30% burn (unevolved Charmander, L40)
	const HYDRO_JET      ; d0 - Water, 90 dmg, 30% flinch (unevolved Squirtle, L40)
	const GIGA_DRAIN     ; d1 - Grass, 75 dmg, drains the full amount (unevolved Bulbasaur, L40)
	const GHOST_BEAM     ; d2 - Ghost, 150 dmg, recharge; TM53 (ghost-starter answer to Psychics)
	const SHADOW_PUNCH   ; d3 - Ghost, 80 dmg, 33% Spc drop (Gengar's repeatable STAB; GHOST_BEAM recharges, PHANTOM_WING stays Nocturn's)
	const GRANIT_CLAMP   ; d4 - Rock, 90 dmg, high crit (Pinsirite's damage; misspelled to hit the 12-char name ceiling)
	const CRUSH_JAW      ; d5 - Normal, 80 dmg, 50% flinch (Gyarados)
	const THIRD_RAIL     ; d6 - Electric DIG: burrow a turn, erupt electrified (DIGNEMITE's STAB)
	const NOVA_BLITZ     ; d7 - Electric, 2-5 hits of 35 (RAICHU's mutant move)
	const POWER_CLAMP    ; d8 - Water, trapping, 50 per turn (CLOYSTER's heavy CLAMP)
	const STRUGGLE       ; d9
DEF NUM_ATTACKS EQU const_value - 1

DEF CANNOT_MOVE EQU $ff

	; Moves do double duty as animation identifiers.

	const SHOWPIC_ANIM
	const STATUS_AFFECTED_ANIM
	const ANIM_A8
	const ENEMY_HUD_SHAKE_ANIM
	const TRADE_BALL_DROP_ANIM
	const TRADE_BALL_SHAKE_ANIM
	const TRADE_BALL_TILT_ANIM
	const TRADE_BALL_POOF_ANIM
	const XSTATITEM_ANIM ; use X Attack/Defense/Speed/Special
	const XSTATITEM_DUPLICATE_ANIM
	const SHRINKING_SQUARE_ANIM
	const ANIM_B1
	const ANIM_B2
	const ANIM_B3
	const ANIM_B4
	const ANIM_B5
	const ANIM_B6
	const ANIM_B7
	const ANIM_B8
	const ANIM_B9
	const BURN_PSN_ANIM ; Plays when a monster is burned or poisoned
	const ANIM_BB
	const SLP_PLAYER_ANIM
	const SLP_ANIM ; sleeping monster
	const CONF_PLAYER_ANIM
	const CONF_ANIM ; confused monster
	const SLIDE_DOWN_ANIM
	const TOSS_ANIM ; toss Poké Ball
	const SHAKE_ANIM ; shaking Poké Ball when catching monster
	const POOF_ANIM ; puff of smoke
	const BLOCKBALL_ANIM ; trainer knocks away Poké Ball
	const GREATTOSS_ANIM ; toss Great Ball
	const ULTRATOSS_ANIM ; toss Ultra Ball or Master Ball
	const SHAKE_SCREEN_ANIM
	const HIDEPIC_ANIM ; monster disappears
	const ROCK_ANIM ; throw rock
	const BAIT_ANIM ; throw bait

DEF NUM_ATTACK_ANIMS EQU const_value - 1
