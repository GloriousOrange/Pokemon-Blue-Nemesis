DEF NUM_ARENA_CHALLENGERS    EQU 26
DEF ARENA_GIOVANNI_SENTINEL  EQU $ff
DEF BIT_ARENA_GIOVANNI_DEFEATED EQU 0 ; bit in wPostGameMisc

BattleIsland_Script:
	call EnableAutoTextBoxDrawing
	ld hl, BattleIsland_ScriptPointers
	ld a, [wBattleIslandCurScript]
	jp CallFunctionInTable

BattleIsland_ScriptPointers:
	def_script_pointers
	dw_const BattleIslandDefaultScript,    SCRIPT_BATTLEISLAND_DEFAULT
	dw_const BattleIslandPostBattleScript, SCRIPT_BATTLEISLAND_POSTBATTLE

BattleIslandDefaultScript:
	ret ; arena battles are triggered by talking to the gatekeeper

; Runs after winning an arena battle (a trainer loss black-outs instead).
BattleIslandPostBattleScript:
	ld a, [wCurArenaChallenger]
	cp ARENA_GIOVANNI_SENTINEL
	jr z, .giovanni
; mark this challenger beaten so it isn't chosen again
	ld hl, wArenaChallengersDefeated
	ld c, a
	ld b, 0
	add hl, bc
	ld [hl], 1
	jr .heal
.giovanni
	ld hl, wPostGameMisc
	set BIT_ARENA_GIOVANNI_DEFEATED, [hl]
.heal
	predef HealParty ; "healed afterwards"
	xor a ; SCRIPT_BATTLEISLAND_DEFAULT
	ld [wBattleIslandCurScript], a
	ld [wCurMapScript], a
	ret

BattleIsland_TextPointers:
	def_text_pointers
	dw_const BattleIslandGatekeeperText, TEXT_BATTLEISLAND_GATEKEEPER ; object_event (id 1)
	dw_const BattleIslandSignText,       TEXT_BATTLEISLAND_SIGN        ; bg_event (id 2)

BattleIslandSignText:
	text_far _BattleIslandSignText
	text_end

; Talk to the gatekeeper -> face a random challenger you haven't beaten yet.
; Once all 26 are beaten, Giovanni; afterward, endless random rematches.
BattleIslandGatekeeperText:
	text_asm
	ld hl, wPostGameMisc
	bit BIT_ARENA_GIOVANNI_DEFEATED, [hl]
	jr nz, .endlessRandom
	call PickArenaChallenger ; a = un-beaten index, or carry set if all beaten
	jr c, .fightGiovanni
	ld [wCurArenaChallenger], a
	call SetupArenaBattleFromIndex
	ld hl, BattleIslandChallengerApproachesText
	jr .startBattle
.fightGiovanni
	ld a, ARENA_GIOVANNI_SENTINEL
	ld [wCurArenaChallenger], a
	ld a, OPP_GIOVANNI
	ld [wCurOpponent], a
	ld a, 5 ; Giovanni party #5 = Battle Island final boss
	ld [wTrainerNo], a
	ld hl, BattleIslandGiovanniArrivesText
	jr .startBattle
.endlessRandom
	call Random
	and $1f
	cp NUM_ARENA_CHALLENGERS
	jr nc, .endlessRandom
	ld [wCurArenaChallenger], a
	call SetupArenaBattleFromIndex
	ld hl, BattleIslandChallengerApproachesText
.startBattle
	ld a, [wCurArenaChallenger]
	cp 0 ; ARENA #1, the weird bug-obsessed kid
	jr nz, .checkSuperNerdApproach
	ld hl, BattleIslandBugCatcherApproachesText
	jr .printApproachText
.checkSuperNerdApproach
	cp 1 ; ARENA #2, the dad-energy Hiker
	jr nz, .checkYoshiApproach
	ld hl, BattleIslandHikerApproachesText
	jr .printApproachText
.checkYoshiApproach
	cp 21 ; ARENA #22, the rumor-spreading Youngster
	jr nz, .checkSuperNerd23Approach
	ld hl, BattleIslandYoungsterApproachesText
	jr .printApproachText
.checkSuperNerd23Approach
	cp 22 ; ARENA #23, the Super Nerd looking for a Yoshi
	jr nz, .checkGamblerApproach
	ld hl, BattleIslandSuperNerdApproachesText
	jr .printApproachText
.checkGamblerApproach
	cp 16 ; ARENA #17, the sleazy Gambler
	jr nz, .checkEngineerApproach
	ld hl, BattleIslandGamblerApproachesText
	jr .printApproachText
.checkEngineerApproach
	cp 11 ; ARENA #12, the crunch-mode Engineer
	jr nz, .checkTamerApproach
	ld hl, BattleIslandEngineerApproachesText
	jr .printApproachText
.checkTamerApproach
	cp 24 ; ARENA #25, the livestock Tamer
	jr nz, .checkGentlemanApproach
	ld hl, BattleIslandTamerApproachesText
	jr .printApproachText
.checkGentlemanApproach
	cp 17 ; ARENA #18, the food-snob Gentleman
	jr nz, .checkBirdKeeperApproach
	ld hl, BattleIslandGentlemanApproachesText
	jr .printApproachText
.checkBirdKeeperApproach
	cp 20 ; ARENA #21, the fried-chicken Bird Keeper
	jr nz, .checkFisherApproach
	ld hl, BattleIslandBirdKeeperApproachesText
	jr .printApproachText
.checkFisherApproach
	cp 7 ; ARENA #8, the seafood-loving Fisher
	jr nz, .checkJugglerApproach
	ld hl, BattleIslandFisherApproachesText
	jr .printApproachText
.checkJugglerApproach
	cp 6 ; ARENA #7, the failed-magician Juggler
	jr nz, .checkBurglarApproach
	ld hl, BattleIslandJugglerApproachesText
	jr .printApproachText
.checkBurglarApproach
	cp 8 ; ARENA #9, the black-market Burglar
	jr nz, .checkRocketApproach
	ld hl, BattleIslandBurglarApproachesText
	jr .printApproachText
.checkRocketApproach
	cp 10 ; ARENA #11, the true-believer Rocket
	jr nz, .checkScientistApproach
	ld hl, BattleIslandRocketApproachesText
	jr .printApproachText
.checkScientistApproach
	cp 2 ; ARENA #3, the mad-science Scientist
	jr nz, .printApproachText
	ld hl, BattleIslandScientistApproachesText
.printApproachText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, BattleIslandChallengerDefeatedText
	ld a, [wCurArenaChallenger]
	cp 0 ; ARENA #1, the weird bug-obsessed kid
	jr nz, .checkSuperNerdWinText
	ld hl, BattleIslandBugCatcherDefeatedText
	jr .notSuperNerdWinText
.checkSuperNerdWinText
	cp 1 ; ARENA #2, the dad-energy Hiker
	jr nz, .checkYoshiWinText
	ld hl, BattleIslandHikerDefeatedText
	jr .notSuperNerdWinText
.checkYoshiWinText
	cp 21 ; ARENA #22, the rumor-spreading Youngster
	jr nz, .checkSuperNerd23WinText
	ld hl, BattleIslandYoungsterDefeatedText
	jr .notSuperNerdWinText
.checkSuperNerd23WinText
	cp 22 ; ARENA #23, the Super Nerd looking for a Yoshi
	jr nz, .checkGamblerWinText
	ld hl, BattleIslandSuperNerdDefeatedText
	jr .notSuperNerdWinText
.checkGamblerWinText
	cp 16 ; ARENA #17, the sleazy Gambler
	jr nz, .checkEngineerWinText
	ld hl, BattleIslandGamblerDefeatedText
	jr .notSuperNerdWinText
.checkEngineerWinText
	cp 11 ; ARENA #12, the crunch-mode Engineer
	jr nz, .checkTamerWinText
	ld hl, BattleIslandEngineerDefeatedText
	jr .notSuperNerdWinText
.checkTamerWinText
	cp 24 ; ARENA #25, the livestock Tamer
	jr nz, .checkGentlemanWinText
	ld hl, BattleIslandTamerDefeatedText
	jr .notSuperNerdWinText
.checkGentlemanWinText
	cp 17 ; ARENA #18, the food-snob Gentleman
	jr nz, .checkBirdKeeperWinText
	ld hl, BattleIslandGentlemanDefeatedText
	jr .notSuperNerdWinText
.checkBirdKeeperWinText
	cp 20 ; ARENA #21, the fried-chicken Bird Keeper
	jr nz, .checkFisherWinText
	ld hl, BattleIslandBirdKeeperDefeatedText
	jr .notSuperNerdWinText
.checkFisherWinText
	cp 7 ; ARENA #8, the seafood-loving Fisher
	jr nz, .checkJugglerWinText
	ld hl, BattleIslandFisherDefeatedText
	jr .notSuperNerdWinText
.checkJugglerWinText
	cp 6 ; ARENA #7, the failed-magician Juggler
	jr nz, .checkBurglarWinText
	ld hl, BattleIslandJugglerDefeatedText
	jr .notSuperNerdWinText
.checkBurglarWinText
	cp 8 ; ARENA #9, the black-market Burglar
	jr nz, .checkRocketWinText
	ld hl, BattleIslandBurglarDefeatedText
	jr .notSuperNerdWinText
.checkRocketWinText
	cp 10 ; ARENA #11, the true-believer Rocket
	jr nz, .checkScientistWinText
	ld hl, BattleIslandRocketDefeatedText
	jr .notSuperNerdWinText
.checkScientistWinText
	cp 2 ; ARENA #3, the mad-science Scientist
	jr nz, .notSuperNerdWinText
	ld hl, BattleIslandScientistDefeatedText
.notSuperNerdWinText
	ld de, BattleIslandChallengerVictoryText
	call SaveEndBattleTextPointers
	ld a, SCRIPT_BATTLEISLAND_POSTBATTLE
	ld [wBattleIslandCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

; a = challenger index 0-25 -> set wCurOpponent + wTrainerNo from the table
SetupArenaBattleFromIndex:
	add a ; 2 bytes per entry
	ld c, a
	ld b, 0
	ld hl, ArenaChallengerTable
	add hl, bc
	ld a, [hli]
	ld [wCurOpponent], a
	ld a, [hl]
	ld [wTrainerNo], a
	ret

; out: a = a random un-beaten challenger (0-25), carry clear; carry SET if all beaten
PickArenaChallenger:
	ld hl, wArenaChallengersDefeated
	ld b, NUM_ARENA_CHALLENGERS
	ld c, 0 ; count of un-beaten
.countLoop
	ld a, [hli]
	and a
	jr nz, .countNext
	inc c
.countNext
	dec b
	jr nz, .countLoop
	ld a, c
	and a
	jr nz, .pickOrdinal
	scf ; all beaten
	ret
.pickOrdinal
; choose a random ordinal in [0, count-1]
	call Random
	and $1f
	cp c
	jr nc, .pickOrdinal
	ld e, a ; target ordinal among un-beaten
	ld hl, wArenaChallengersDefeated
	ld b, 0 ; challenger index
	ld d, 0 ; un-beaten seen so far
.scanLoop
	ld a, [hli]
	and a
	jr nz, .scanNext ; beaten, skip
	ld a, d
	cp e
	jr z, .found
	inc d
.scanNext
	inc b
	jr .scanLoop
.found
	ld a, b
	and a ; clear carry
	ret

; index 0-25 -> OPP_<class>, party number (see "ARENA #" tags in data/trainers/parties.asm)
ArenaChallengerTable:
	db OPP_BUG_CATCHER,   15 ; 1
	db OPP_HIKER,         16 ; 2
	db OPP_SCIENTIST,     20 ; 3
	db OPP_COOLTRAINER_M, 11 ; 4
	db OPP_BIKER,         16 ; 5
	db OPP_POKEMANIAC,     9 ; 6
	db OPP_JUGGLER,       10 ; 7
	db OPP_FISHER,        12 ; 8
	db OPP_BURGLAR,       10 ; 9
	db OPP_BEAUTY,        16 ; 10
	db OPP_ROCKET,        42 ; 11
	db OPP_ENGINEER,       4 ; 12
	db OPP_JR_TRAINER_F,  25 ; 13
	db OPP_BLACKBELT,     10 ; 14
	db OPP_CHANNELER,     25 ; 15
	db OPP_COOLTRAINER_M, 12 ; 16
	db OPP_GAMBLER,        8 ; 17
	db OPP_GENTLEMAN,      6 ; 18
	db OPP_JR_TRAINER_M,  10 ; 19
	db OPP_PSYCHIC_TR,     5 ; 20
	db OPP_BIRD_KEEPER,   18 ; 21
	db OPP_YOUNGSTER,     14 ; 22
	db OPP_SUPER_NERD,    13 ; 23
	db OPP_SWIMMER,       16 ; 24
	db OPP_TAMER,          7 ; 25
	db OPP_ROCKER,         3 ; 26

BattleIslandBugCatcherApproachesText:
	text_far _BattleIslandBugCatcherApproachesText
	text_end

BattleIslandBugCatcherDefeatedText:
	text_far _BattleIslandBugCatcherDefeatedText
	text_end

BattleIslandYoungsterApproachesText:
	text_far _BattleIslandYoungsterApproachesText
	text_end

BattleIslandYoungsterDefeatedText:
	text_far _BattleIslandYoungsterDefeatedText
	text_end

BattleIslandHikerApproachesText:
	text_far _BattleIslandHikerApproachesText
	text_end

BattleIslandHikerDefeatedText:
	text_far _BattleIslandHikerDefeatedText
	text_end

BattleIslandChallengerApproachesText:
	text_far _BattleIslandChallengerApproachesText
	text_end

BattleIslandGiovanniArrivesText:
	text_far _BattleIslandGiovanniArrivesText
	text_end

BattleIslandSuperNerdApproachesText:
	text_far _BattleIslandSuperNerdApproachesText
	text_end

BattleIslandSuperNerdDefeatedText:
	text_far _BattleIslandSuperNerdDefeatedText
	text_end

BattleIslandGamblerApproachesText:
	text_far _BattleIslandGamblerApproachesText
	text_end

BattleIslandGamblerDefeatedText:
	text_far _BattleIslandGamblerDefeatedText
	text_end

BattleIslandEngineerApproachesText:
	text_far _BattleIslandEngineerApproachesText
	text_end

BattleIslandEngineerDefeatedText:
	text_far _BattleIslandEngineerDefeatedText
	text_end

BattleIslandTamerApproachesText:
	text_far _BattleIslandTamerApproachesText
	text_end

BattleIslandTamerDefeatedText:
	text_far _BattleIslandTamerDefeatedText
	text_end

BattleIslandGentlemanApproachesText:
	text_far _BattleIslandGentlemanApproachesText
	text_end

BattleIslandGentlemanDefeatedText:
	text_far _BattleIslandGentlemanDefeatedText
	text_end

BattleIslandBirdKeeperApproachesText:
	text_far _BattleIslandBirdKeeperApproachesText
	text_end

BattleIslandBirdKeeperDefeatedText:
	text_far _BattleIslandBirdKeeperDefeatedText
	text_end

BattleIslandFisherApproachesText:
	text_far _BattleIslandFisherApproachesText
	text_end

BattleIslandFisherDefeatedText:
	text_far _BattleIslandFisherDefeatedText
	text_end

BattleIslandJugglerApproachesText:
	text_far _BattleIslandJugglerApproachesText
	text_end

BattleIslandJugglerDefeatedText:
	text_far _BattleIslandJugglerDefeatedText
	text_end

BattleIslandBurglarApproachesText:
	text_far _BattleIslandBurglarApproachesText
	text_end

BattleIslandBurglarDefeatedText:
	text_far _BattleIslandBurglarDefeatedText
	text_end

BattleIslandRocketApproachesText:
	text_far _BattleIslandRocketApproachesText
	text_end

BattleIslandRocketDefeatedText:
	text_far _BattleIslandRocketDefeatedText
	text_end

BattleIslandScientistApproachesText:
	text_far _BattleIslandScientistApproachesText
	text_end

BattleIslandScientistDefeatedText:
	text_far _BattleIslandScientistDefeatedText
	text_end

BattleIslandChallengerDefeatedText:
	text_far _BattleIslandChallengerDefeatedText
	text_end

BattleIslandChallengerVictoryText:
	text_far _BattleIslandChallengerVictoryText
	text_end
