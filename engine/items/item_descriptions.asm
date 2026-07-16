; Prints a short description of the currently-selected bag item (wCurItem) in the
; bottom message box. Invoked via farcall from the bag's INFO option. TMs/HMs and
; anything at/above HM01 share one generic "machine" blurb; everything else indexes
; ItemDescriptionPointers by (item ID - 1). PrintText reads the local text scripts
; from this bank (the farcall has it loaded).
PrintItemDescription::
	ld a, [wCurItem]
	cp HM01
	jr nc, .machine
	dec a ; item IDs start at 1
	ld e, a
	ld d, 0
	ld hl, ItemDescriptionPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText
.machine
; HMs and TMs are contiguous item IDs from HM01 up; index by (id - HM01).
	sub HM01
	ld e, a
	ld d, 0
	ld hl, MachineDescriptionPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PrintText

ItemDescriptionPointers:
	dw MasterBallDesc   ; MASTER_BALL
	dw UltraBallDesc    ; ULTRA_BALL
	dw GreatBallDesc    ; GREAT_BALL
	dw PokeBallDesc     ; POKE_BALL
	dw TownMapDesc      ; TOWN_MAP
	dw BicycleDesc      ; BICYCLE
	dw UnknownItemDesc  ; SURFBOARD ("?????")
	dw SafariBallDesc   ; SAFARI_BALL
	dw PokedexDesc      ; POKEDEX
	dw EvoStoneDesc     ; MOON_STONE
	dw AntidoteDesc     ; ANTIDOTE
	dw BurnHealDesc     ; BURN_HEAL
	dw IceHealDesc      ; ICE_HEAL
	dw AwakeningDesc    ; AWAKENING
	dw ParlyzHealDesc   ; PARLYZ_HEAL
	dw FriedDragonDesc  ; FULL_RESTORE ("FRIED DRAGON")
	dw DittoJelloDesc   ; MAX_POTION ("DITTO JELLO")
	dw TaurosJerkyDesc  ; HYPER_POTION ("TAUROS JERKY")
	dw SnorlaxJerkyDesc ; SUPER_POTION ("SNORLAX JRKY")
	dw MankeyJerkyDesc  ; POTION ("MANKEY JERKY")
	dw GymBadgeDesc     ; BOULDERBADGE
	dw GymBadgeDesc     ; CASCADEBADGE
	dw GymBadgeDesc     ; THUNDERBADGE
	dw GymBadgeDesc     ; RAINBOWBADGE
	dw GymBadgeDesc     ; SOULBADGE
	dw GymBadgeDesc     ; MARSHBADGE
	dw GymBadgeDesc     ; VOLCANOBADGE
	dw GymBadgeDesc     ; EARTHBADGE
	dw EscapeRopeDesc   ; ESCAPE_ROPE
	dw RepelDesc        ; REPEL
	dw FossilDesc       ; OLD_AMBER
	dw EvoStoneDesc     ; FIRE_STONE
	dw EvoStoneDesc     ; THUNDER_STONE
	dw EvoStoneDesc     ; WATER_STONE
	dw HPUpDesc         ; HP_UP
	dw ProteinDesc      ; PROTEIN
	dw IronDesc         ; IRON
	dw CarbosDesc       ; CARBOS
	dw CalciumDesc      ; CALCIUM
	dw RareCandyDesc    ; RARE_CANDY
	dw FossilDesc       ; DOME_FOSSIL
	dw FossilDesc       ; HELIX_FOSSIL
	dw SecretKeyDesc    ; SECRET_KEY
	dw MonsterMeatDesc  ; MONSTER_MEAT
	dw BikeVoucherDesc  ; BIKE_VOUCHER
	dw XAccuracyDesc    ; X_ACCURACY
	dw EvoStoneDesc     ; LEAF_STONE
	dw CardKeyDesc      ; CARD_KEY
	dw NuggetDesc       ; NUGGET
	dw UrnOfAshDesc     ; URN_OF_ASHES
	dw PokeDollDesc     ; POKE_DOLL
	dw FullHealDesc     ; FULL_HEAL
	dw ReviveDesc       ; REVIVE
	dw MaxReviveDesc    ; MAX_REVIVE
	dw GuardSpecDesc    ; GUARD_SPEC
	dw SuperRepelDesc   ; SUPER_REPEL
	dw MaxRepelDesc     ; MAX_REPEL
	dw DireHitDesc      ; DIRE_HIT
	dw CoinDesc         ; COIN
	dw SlowpokeTailDesc ; FRESH_WATER ("SLOWPOKETAIL")
	dw SardinesDesc     ; SODA_POP ("SARDINES")
	dw KangSteakDesc    ; LEMONADE ("KANG STEAK")
	dw SSTicketDesc     ; S_S_TICKET
	dw GoldTeethDesc    ; GOLD_TEETH
	dw XAttackDesc      ; X_ATTACK
	dw XDefendDesc      ; X_DEFEND
	dw XSpeedDesc       ; X_SPEED
	dw XSpecialDesc     ; X_SPECIAL
	dw CoinCaseDesc     ; COIN_CASE
	dw OaksParcelDesc   ; OAKS_PARCEL
	dw ItemfinderDesc   ; ITEMFINDER
	dw SilphScopeDesc   ; SILPH_SCOPE
	dw PokeFluteDesc    ; POKE_FLUTE
	dw LiftKeyDesc      ; LIFT_KEY
	dw ExpAllDesc       ; EXP_ALL
	dw OldRodDesc       ; OLD_ROD
	dw GoodRodDesc      ; GOOD_ROD
	dw SuperRodDesc     ; SUPER_ROD
	dw PPUpDesc         ; PP_UP
	dw EtherDesc        ; ETHER
	dw MaxEtherDesc     ; MAX_ETHER
	dw ElixerDesc       ; ELIXER
	dw MaxElixerDesc    ; MAX_ELIXER
	dw LevelStoneDesc   ; LEVEL_STONE
	dw LabKeyDesc       ; LAB_KEY
	dw IslandDeedDesc   ; BATTLE_ISLAND_DEED ("ISLAND DEED")
	dw CallMeganDesc    ; GF_KEEPSAKE ("CALL MEGAN")

MasterBallDesc:
	text "The finest BALL."
	line "Never misses."
	prompt

UltraBallDesc:
	text "A BALL with a"
	line "high catch rate."
	prompt

GreatBallDesc:
	text "A BALL with a"
	line "good catch rate."
	prompt

PokeBallDesc:
	text "Catches wild"
	line "POKéMON."
	prompt

TownMapDesc:
	text "Shows a map of"
	line "the region."
	prompt

BicycleDesc:
	text "A folding bike"
	line "for fast travel."
	prompt

UnknownItemDesc:
	text "A mysterious,"
	line "unknown item."
	prompt

SafariBallDesc:
	text "A BALL for the"
	line "SAFARI ZONE."
	prompt

PokedexDesc:
	text "Records data on"
	line "POKéMON."
	prompt

EvoStoneDesc:
	text "Evolves certain"
	line "POKéMON."
	prompt

AntidoteDesc:
	text "Cures poisoning."
	prompt

BurnHealDesc:
	text "Heals a burn."
	prompt

IceHealDesc:
	text "Thaws a frozen"
	line "POKéMON."
	prompt

AwakeningDesc:
	text "Wakes a sleeping"
	line "POKéMON."
	prompt

ParlyzHealDesc:
	text "Cures paralysis."
	prompt

FriedDragonDesc:
	text "Seared dragon."
	line "Fully heals HP"
	cont "and all status."
	prompt

DittoJelloDesc:
	text "Wobbly jelly."
	line "Fully heals HP."
	prompt

TaurosJerkyDesc:
	text "Dried TAUROS."
	line "Restores 200 HP."
	prompt

SnorlaxJerkyDesc:
	text "Cured SNORLAX."
	line "Restores 50 HP."
	prompt

MankeyJerkyDesc:
	text "Tough MANKEY."
	line "Restores 20 HP."
	prompt

GymBadgeDesc:
	text "A GYM BADGE from"
	line "a LEADER."
	prompt

EscapeRopeDesc:
	text "Warps you out of"
	line "a cave."
	prompt

RepelDesc:
	text "Repels weak wild"
	line "POKéMON awhile."
	prompt

FossilDesc:
	text "A fossil. Revive"
	line "it at CINNABAR."
	prompt

HPUpDesc:
	text "Raises max HP."
	prompt

ProteinDesc:
	text "Raises ATTACK."
	prompt

IronDesc:
	text "Raises DEFENSE."
	prompt

CarbosDesc:
	text "Raises SPEED."
	prompt

CalciumDesc:
	text "Raises SPECIAL."
	prompt

RareCandyDesc:
	text "Raises a POKéMON's"
	line "level by one."
	prompt

SecretKeyDesc:
	text "Opens BLAINE's"
	line "GYM door."
	prompt

MonsterMeatDesc:
	text "A slab of strange"
	line "meat."
	prompt

BikeVoucherDesc:
	text "Trade for a bike"
	line "in CERULEAN."
	prompt

XAccuracyDesc:
	text "Ups accuracy in"
	line "one battle."
	prompt

CardKeyDesc:
	text "Unlocks doors in"
	line "SILPH CO."
	prompt

NuggetDesc:
	text "Pure gold. Sell"
	line "it for cash."
	prompt

UrnOfAshDesc:
	text "Holds a fallen"
	line "partner's ashes."
	prompt

PokeDollDesc:
	text "Flee any wild"
	line "POKéMON battle."
	prompt

FullHealDesc:
	text "Cures all status"
	line "problems."
	prompt

ReviveDesc:
	text "Revives a fainted"
	line "POKéMON, half HP."
	prompt

MaxReviveDesc:
	text "Revives a fainted"
	line "POKéMON, full HP."
	prompt

GuardSpecDesc:
	text "Blocks status"
	line "moves a while."
	prompt

SuperRepelDesc:
	text "Repels weak wild"
	line "POKéMON longer."
	prompt

MaxRepelDesc:
	text "Repels weak wild"
	line "POKéMON longest."
	prompt

DireHitDesc:
	text "Ups critical-hit"
	line "rate in battle."
	prompt

CoinDesc:
	text "A GAME CORNER"
	line "coin."
	prompt

SlowpokeTailDesc:
	text "A tasty tail."
	line "Restores 50 HP."
	prompt

SardinesDesc:
	text "Oily SARDINES."
	line "Restores 60 HP."
	prompt

KangSteakDesc:
	text "KANGASKHAN steak."
	line "Restores 80 HP."
	prompt

SSTicketDesc:
	text "A ticket for the"
	line "S.S. ANNE."
	prompt

GoldTeethDesc:
	text "Return to the"
	line "SAFARI warden."
	prompt

XAttackDesc:
	text "Ups ATTACK in"
	line "one battle."
	prompt

XDefendDesc:
	text "Ups DEFENSE in"
	line "one battle."
	prompt

XSpeedDesc:
	text "Ups SPEED in"
	line "one battle."
	prompt

XSpecialDesc:
	text "Ups SPECIAL in"
	line "one battle."
	prompt

CoinCaseDesc:
	text "Holds your GAME"
	line "CORNER coins."
	prompt

OaksParcelDesc:
	text "A parcel for"
	line "PROF.OAK."
	prompt

ItemfinderDesc:
	text "Finds hidden"
	line "items nearby."
	prompt

SilphScopeDesc:
	text "Reveals GHOSTs in"
	line "POKéMON TOWER."
	prompt

PokeFluteDesc:
	text "Wakes any"
	line "sleeping POKéMON."
	prompt

LiftKeyDesc:
	text "Runs the ROCKET"
	line "HIDEOUT lift."
	prompt

ExpAllDesc:
	text "Shares EXP with"
	line "the whole party."
	prompt

OldRodDesc:
	text "A rod for"
	line "fishing POKéMON."
	prompt

GoodRodDesc:
	text "A good rod for"
	line "fishing POKéMON."
	prompt

SuperRodDesc:
	text "The best fishing"
	line "rod."
	prompt

PPUpDesc:
	text "Raises a move's"
	line "max PP."
	prompt

EtherDesc:
	text "Restores 10 PP to"
	line "one move."
	prompt

MaxEtherDesc:
	text "Fully restores"
	line "one move's PP."
	prompt

ElixerDesc:
	text "Restores 10 PP to"
	line "all moves."
	prompt

MaxElixerDesc:
	text "Fully restores"
	line "all moves' PP."
	prompt

LevelStoneDesc:
	text "Upgrades a POKé-"
	line "MON to LEVEL 100."
	prompt

LabKeyDesc:
	text "Unlocks the burnt"
	line "CINNABAR lab."
	prompt

IslandDeedDesc:
	text "Opens the BATTLE"
	line "ISLAND arena."
	prompt

CallMeganDesc:
	text "Call MEGAN to use"
	line "your PC anywhere."
	prompt

; Indexed by (item ID - HM01): the 6 HMs first, then TM01..TM52, in item-ID order.
MachineDescriptionPointers:
	dw MachineCutDesc         ; HM CUT
	dw MachineFlyDesc         ; HM FLY
	dw MachineSurfDesc        ; HM SURF
	dw MachineStrengthDesc    ; HM STRENGTH
	dw MachineFlashDesc       ; HM FLASH
	dw MachineMetronome2Desc  ; HM METRONOME2
	dw MachineMegaPunchDesc   ; TM01 MEGA_PUNCH
	dw MachineRazorWindDesc   ; TM02 RAZOR_WIND
	dw MachineSwordsDanceDesc ; TM03 SWORDS_DANCE
	dw MachineWhirlwindDesc   ; TM04 WHIRLWIND
	dw MachineMegaKickDesc    ; TM05 MEGA_KICK
	dw MachineToxicDesc       ; TM06 TOXIC
	dw MachineHornDrillDesc   ; TM07 HORN_DRILL
	dw MachineBodySlamDesc    ; TM08 BODY_SLAM
	dw MachineTakeDownDesc    ; TM09 TAKE_DOWN
	dw MachineDoubleEdgeDesc  ; TM10 DOUBLE_EDGE
	dw MachineBubblebeamDesc  ; TM11 BUBBLEBEAM
	dw MachineWaterGunDesc    ; TM12 WATER_GUN
	dw MachineIceBeamDesc     ; TM13 ICE_BEAM
	dw MachineBlizzardDesc    ; TM14 BLIZZARD
	dw MachineHyperBeamDesc   ; TM15 HYPER_BEAM
	dw MachinePayDayDesc      ; TM16 PAY_DAY
	dw MachineSubmissionDesc  ; TM17 SUBMISSION
	dw MachineCounterDesc     ; TM18 COUNTER
	dw MachineSeismicTossDesc ; TM19 SEISMIC_TOSS
	dw MachineRageDesc        ; TM20 RAGE
	dw MachineMegaDrainDesc   ; TM21 MEGA_DRAIN
	dw MachineSolarbeamDesc   ; TM22 SOLARBEAM
	dw MachineDragonRageDesc  ; TM23 DRAGON_RAGE
	dw MachineThunderboltDesc ; TM24 THUNDERBOLT
	dw MachineThunderDesc     ; TM25 THUNDER
	dw MachineEarthquakeDesc  ; TM26 EARTHQUAKE
	dw MachineFissureDesc     ; TM27 FISSURE
	dw MachineDigDesc         ; TM28 DIG
	dw MachinePsychicDesc     ; TM29 PSYCHIC_M
	dw MachineTeleportDesc    ; TM30 TELEPORT
	dw MachineMimicDesc       ; TM31 MIMIC
	dw MachineDoubleTeamDesc  ; TM32 DOUBLE_TEAM
	dw MachineReflectDesc     ; TM33 REFLECT
	dw MachineBideDesc        ; TM34 BIDE
	dw MachineMetronomeDesc   ; TM35 METRONOME
	dw MachineSelfdestructDesc; TM36 SELFDESTRUCT
	dw MachineEggBombDesc     ; TM37 EGG_BOMB
	dw MachineFireBlastDesc   ; TM38 FIRE_BLAST
	dw MachineSwiftDesc       ; TM39 SWIFT
	dw MachineSkullBashDesc   ; TM40 SKULL_BASH
	dw MachineSoftboiledDesc  ; TM41 SOFTBOILED
	dw MachineDreamEaterDesc  ; TM42 DREAM_EATER
	dw MachineSkyAttackDesc   ; TM43 SKY_ATTACK
	dw MachineRestDesc        ; TM44 REST
	dw MachineThunderWaveDesc ; TM45 THUNDER_WAVE
	dw MachinePsywaveDesc     ; TM46 PSYWAVE
	dw MachineExplosionDesc   ; TM47 EXPLOSION
	dw MachineRockSlideDesc   ; TM48 ROCK_SLIDE
	dw MachineTriAttackDesc   ; TM49 TRI_ATTACK
	dw MachineSubstituteDesc  ; TM50 SUBSTITUTE
	dw MachineNightShadeDesc  ; TM51 NIGHT_SHADE
	dw MachineConfuseRayDesc  ; TM52 CONFUSE_RAY

MachineCutDesc:
	text "CUT"
	line "Slashes the foe;"
	cont "fells small trees."
	prompt
MachineFlyDesc:
	text "FLY"
	line "Strikes from the"
	cont "sky. Travels fast."
	prompt
MachineSurfDesc:
	text "SURF"
	line "A wave hits the"
	cont "foe. Crosses water."
	prompt
MachineStrengthDesc:
	text "STRENGTH"
	line "A strong tackle."
	cont "Moves boulders."
	prompt
MachineFlashDesc:
	text "FLASH"
	line "Lowers the foe's"
	cont "accuracy. Lights up."
	prompt
MachineMetronome2Desc:
	text "METRONOME2"
	line "Unleashes a random"
	cont "powerful move."
	prompt
MachineMegaPunchDesc:
	text "MEGA PUNCH"
	line "A strong punch."
	prompt
MachineRazorWindDesc:
	text "RAZOR WIND"
	line "Charges, then cuts"
	cont "the foe next turn."
	prompt
MachineSwordsDanceDesc:
	text "SWORDS DANCE"
	line "Sharply raises the"
	cont "user's ATTACK."
	prompt
MachineWhirlwindDesc:
	text "WHIRLWIND"
	line "FLYING gust that"
	cont "lowers ACCURACY."
	prompt
MachineMegaKickDesc:
	text "MEGA KICK"
	line "A powerful kick."
	prompt
MachineToxicDesc:
	text "TOXIC"
	line "Badly poisons; the"
	cont "damage grows."
	prompt
MachineHornDrillDesc:
	text "HORN DRILL"
	line "A one-hit KO if it"
	cont "connects."
	prompt
MachineBodySlamDesc:
	text "BODY SLAM"
	line "A full-body tackle;"
	cont "may paralyze."
	prompt
MachineTakeDownDesc:
	text "TAKE DOWN"
	line "A strong hit; user"
	cont "takes recoil."
	prompt
MachineDoubleEdgeDesc:
	text "DOUBLE-EDGE"
	line "Very strong; heavy"
	cont "recoil to user."
	prompt
MachineBubblebeamDesc:
	text "BUBBLEBEAM"
	line "Water jet; may cut"
	cont "the foe's SPEED."
	prompt
MachineWaterGunDesc:
	text "WATER GUN"
	line "Squirts water at"
	cont "the foe."
	prompt
MachineIceBeamDesc:
	text "ICE BEAM"
	line "An icy beam; may"
	cont "freeze the foe."
	prompt
MachineBlizzardDesc:
	text "BLIZZARD"
	line "A fierce storm; may"
	cont "freeze the foe."
	prompt
MachineHyperBeamDesc:
	text "HYPER BEAM"
	line "Huge damage; must"
	cont "recharge after."
	prompt
MachinePayDayDesc:
	text "PAY DAY"
	line "Throws coins; you"
	cont "collect them after."
	prompt
MachineSubmissionDesc:
	text "SUBMISSION"
	line "A tackle; user"
	cont "takes some recoil."
	prompt
MachineCounterDesc:
	text "COUNTER"
	line "Returns double a"
	cont "physical hit."
	prompt
MachineSeismicTossDesc:
	text "SEISMIC TOSS"
	line "Damage equals the"
	cont "user's level."
	prompt
MachineRageDesc:
	text "RAGE"
	line "ATTACK rises each"
	cont "time user is hit."
	prompt
MachineMegaDrainDesc:
	text "MEGA DRAIN"
	line "Drains HP from the"
	cont "foe to heal user."
	prompt
MachineSolarbeamDesc:
	text "SOLARBEAM"
	line "Absorbs light, then"
	cont "fires next turn."
	prompt
MachineDragonRageDesc:
	text "DRAGON RAGE"
	line "Always deals 40"
	cont "damage."
	prompt
MachineThunderboltDesc:
	text "THUNDERBOLT"
	line "A bolt; may"
	cont "paralyze the foe."
	prompt
MachineThunderDesc:
	text "THUNDER"
	line "A huge bolt; may"
	cont "paralyze the foe."
	prompt
MachineEarthquakeDesc:
	text "EARTHQUAKE"
	line "A powerful GROUND"
	cont "attack."
	prompt
MachineFissureDesc:
	text "FISSURE"
	line "A one-hit KO if it"
	cont "connects."
	prompt
MachineDigDesc:
	text "DIG"
	line "Burrows turn 1,"
	cont "strikes turn 2."
	prompt
MachinePsychicDesc:
	text "PSYCHIC"
	line "Strong; may lower"
	cont "the foe's SPECIAL."
	prompt
MachineTeleportDesc:
	text "TELEPORT"
	line "Flees wild battles;"
	cont "warps outside."
	prompt
MachineMimicDesc:
	text "MIMIC"
	line "Copies one of the"
	cont "foe's moves."
	prompt
MachineDoubleTeamDesc:
	text "DOUBLE TEAM"
	line "Raises the user's"
	cont "evasion."
	prompt
MachineReflectDesc:
	text "REFLECT"
	line "Halves physical"
	cont "damage taken."
	prompt
MachineBideDesc:
	text "BIDE"
	line "Waits, then returns"
	cont "double the damage."
	prompt
MachineMetronomeDesc:
	text "METRONOME"
	line "Uses a random move."
	prompt
MachineSelfdestructDesc:
	text "SELFDESTRUCT"
	line "Big damage; the"
	cont "user faints."
	prompt
MachineEggBombDesc:
	text "EGG BOMB"
	line "Hurls a large egg"
	cont "at the foe."
	prompt
MachineFireBlastDesc:
	text "FIRE BLAST"
	line "A blast; may burn"
	cont "the foe."
	prompt
MachineSwiftDesc:
	text "SWIFT"
	line "Star rays that"
	cont "never miss."
	prompt
MachineSkullBashDesc:
	text "SKULL BASH"
	line "Lowers head turn 1,"
	cont "rams turn 2."
	prompt
MachineSoftboiledDesc:
	text "SOFTBOILED"
	line "Restores half the"
	cont "user's max HP."
	prompt
MachineDreamEaterDesc:
	text "DREAM EATER"
	line "Drains HP from a"
	cont "sleeping foe."
	prompt
MachineSkyAttackDesc:
	text "SKY ATTACK"
	line "Charges turn 1,"
	cont "strikes turn 2."
	prompt
MachineRestDesc:
	text "REST"
	line "User sleeps and"
	cont "fully heals."
	prompt
MachineThunderWaveDesc:
	text "THUNDER WAVE"
	line "Paralyzes the foe."
	prompt
MachinePsywaveDesc:
	text "PSYWAVE"
	line "Deals random"
	cont "damage."
	prompt
MachineExplosionDesc:
	text "EXPLOSION"
	line "Huge damage; the"
	cont "user faints."
	prompt
MachineRockSlideDesc:
	text "ROCK SLIDE"
	line "Drops boulders on"
	cont "the foe."
	prompt
MachineTriAttackDesc:
	text "TRI ATTACK"
	line "A three-beam"
	cont "attack."
	prompt
MachineSubstituteDesc:
	text "SUBSTITUTE"
	line "Makes a decoy from"
	cont "the user's HP."
	prompt
MachineNightShadeDesc:
	text "NIGHT SHADE"
	line "Damage equals the"
	cont "user's level."
	prompt
MachineConfuseRayDesc:
	text "CONFUSE RAY"
	line "Confuses the foe."
	prompt
