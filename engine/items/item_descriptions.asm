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
	ld hl, MachineDesc
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

MachineDesc:
	text "Teaches a move to"
	line "a POKéMON."
	prompt
