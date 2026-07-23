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
	dw_const BattleIslandDefaultScript,        SCRIPT_BATTLEISLAND_DEFAULT
	dw_const BattleIslandPostBattleScript,     SCRIPT_BATTLEISLAND_POSTBATTLE
	dw_const BattleIslandScientistPostBattle,  SCRIPT_BATTLEISLAND_SCIENTIST_POSTBATTLE

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
	dw_const BattleIslandGatekeeperText, TEXT_BATTLEISLAND_GATEKEEPER ; object 1
	dw_const BattleIslandScientist0Text, TEXT_BATTLEISLAND_SCIENTIST0  ; object 2
	dw_const BattleIslandScientist1Text, TEXT_BATTLEISLAND_SCIENTIST1  ; object 3
	dw_const BattleIslandScientist2Text, TEXT_BATTLEISLAND_SCIENTIST2  ; object 4
	dw_const BattleIslandScientist3Text, TEXT_BATTLEISLAND_SCIENTIST3  ; object 5
	dw_const BattleIslandScientist4Text, TEXT_BATTLEISLAND_SCIENTIST4  ; object 6
	dw_const BattleIslandScientist5Text, TEXT_BATTLEISLAND_SCIENTIST5  ; object 7
	dw_const BattleIslandSignText,       TEXT_BATTLEISLAND_SIGN        ; bg 8
	dw_const BattleIslandScientistStonesText, TEXT_BATTLEISLAND_SCIENTIST_STONES ; internal (stone handoff)

BattleIslandSignText:
	text_far _BattleIslandSignText
	text_end

; --- Emporium scientists, relocated outdoors near the entrance (indoor building
; was flaky). Same proven battle flow as the arena challengers below: inline
; text, direct wCurOpponent, and a dedicated post-battle state. ---
BattleIslandScientist0Text:
	text_asm
	ld b, 0
	jr BattleIslandScientistTalk
BattleIslandScientist1Text:
	text_asm
	ld b, 1
	jr BattleIslandScientistTalk
BattleIslandScientist2Text:
	text_asm
	ld b, 2
	jr BattleIslandScientistTalk
BattleIslandScientist3Text:
	text_asm
	ld b, 3
	jr BattleIslandScientistTalk
BattleIslandScientist4Text:
	text_asm
	ld b, 4
	jr BattleIslandScientistTalk
BattleIslandScientist5Text:
	text_asm
	ld b, 5
BattleIslandScientistTalk:
; b = scientist index 0-5
	ld a, b
	ld [wCurArenaChallenger], a ; scratch: which scientist, for the post-battle
	ld d, 1 ; build bit mask (1 << index) in d
	ld a, b
	and a
	jr z, .haveMask
.maskLoop
	sla d
	dec a
	jr nz, .maskLoop
.haveMask
	ld a, [wScientistsDefeated]
	and d
	jr nz, .beaten
	ld a, [wCurArenaChallenger] ; unique challenge line per scientist index
	add a
	ld e, a
	ld d, 0
	ld hl, BattleIslandLabSciChallengeTexts
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, BattleIslandLabSciDefeatedText
	ld de, BattleIslandScientistVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, [wCurArenaChallenger]
	add 14 ; ScientistData parties #14-19
	ld [wTrainerNo], a
	ld a, SCRIPT_BATTLEISLAND_SCIENTIST_POSTBATTLE
	ld [wBattleIslandCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd
.beaten
	ld hl, BattleIslandScientistBeatenText
	call PrintText
	jp TextScriptEnd

; Set the beaten scientist's bit; the sixth (index 5) also hands over the six
; MUTAGENSTONES and reveals OAK (EVENT_USED_MUTAGEN_MACHINE).
BattleIslandScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset
	ld d, 1
	ld a, [wCurArenaChallenger]
	and a
	jr z, .haveMask
.maskLoop
	sla d
	dec a
	jr nz, .maskLoop
.haveMask
	ld a, [wScientistsDefeated]
	or d
	ld [wScientistsDefeated], a
	ld a, [wCurArenaChallenger]
	cp 5
	jr nz, .reset
	SetEvent EVENT_USED_MUTAGEN_MACHINE
	ld a, TEXT_BATTLEISLAND_SCIENTIST_STONES
	ldh [hTextID], a
	call DisplayTextID
.reset
	xor a
	ld [wBattleIslandCurScript], a
	ld [wCurMapScript], a
	ret

BattleIslandScientistStonesText:
	text_asm
	ld hl, .Text
	call PrintText
	lb bc, LEVEL_STONE, 6
	call GiveItem
	jp TextScriptEnd
.Text:
	text "Take our six"
	line "MUTAGENSTONES."

	para "Use one from your"
	line "BAG on a #MON --"
	cont "straight to 100."

	para "PROF. OAK is in"
	line "the CAVE, by the"
	cont "water."
	prompt

BattleIslandLabSciChallengeTexts:
	dw BattleIslandLabSci0Challenge
	dw BattleIslandLabSci1Challenge
	dw BattleIslandLabSci2Challenge
	dw BattleIslandLabSci3Challenge
	dw BattleIslandLabSci4Challenge
	dw BattleIslandLabSci5Challenge

BattleIslandLabSci0Challenge:
	text "Your #MON is"
	line "analog. Soft."

	para "Hold still while I"
	line "overwrite it."
	prompt

BattleIslandLabSci1Challenge:
	text "A #MON is just"
	line "stored energy."

	para "Let's see how much"
	line "I can let out."
	prompt

BattleIslandLabSci2Challenge:
	text "Life is only parts"
	line "assembled by"
	cont "accident."

	para "Let me correct"
	line "yours."
	prompt

BattleIslandLabSci3Challenge:
	text "I've already read"
	line "this battle to"
	cont "its end."

	para "You lose."
	prompt

BattleIslandLabSci4Challenge:
	text "We died down here"
	line "once, just to see"
	cont "what lingered."

	para "Come say hello."
	prompt

BattleIslandLabSci5Challenge:
	text "MEW could become"
	line "anything alive."

	para "So can I -- given"
	line "your #MON to copy."
	prompt

BattleIslandLabSciDefeatedText:
	text "Unquantifiable..."
	prompt

BattleIslandScientistVictoryText:
	text "As predicted."
	prompt

BattleIslandScientistBeatenText:
	text "SCIENTIST: Go on."
	line "The others are"
	cont "waiting."
	prompt

BattleIslandTooManyMonsText:
	text_far _BattleIslandTooManyMonsText
	text_end

; Talk to the gatekeeper -> face a random challenger you haven't beaten yet.
; Once all 26 are beaten, Giovanni; afterward, endless random rematches.
; ARENA RULE: 3-on-3 only. Every challenger fields exactly 3 mons, so the
; player must too -- more than 3 in the party and the gatekeeper turns you
; away to the house PC (north edge of the island) to store the rest.
BattleIslandGatekeeperText:
	text_asm
; Gate the arena on OAK's ISLAND DEED (won by beating OAK in the cave).
	ld b, BATTLE_ISLAND_DEED
	call IsItemInBag
	jr nz, .hasDeed
	ld hl, .NoDeedText
	call PrintText
	jp TextScriptEnd
.NoDeedText:
	text "The ARENA is"
	line "sealed."

	para "Bring PROF. OAK's"
	line "ISLAND DEED and"
	cont "it's yours."
	prompt
.hasDeed
	ld a, [wPartyCount]
	cp 3 + 1
	jr c, .partySizeOk
	ld hl, BattleIslandTooManyMonsText
	call PrintText
	jp TextScriptEnd
.partySizeOk
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
	jp .printApproachText
.checkSuperNerdApproach
	cp 1 ; ARENA #2, the dad-energy Hiker
	jr nz, .checkYoshiApproach
	ld hl, BattleIslandHikerApproachesText
	jp .printApproachText
.checkYoshiApproach
	cp 21 ; ARENA #22, the rumor-spreading Youngster
	jr nz, .checkPsychicApproach
	ld hl, BattleIslandYoungsterApproachesText
	jp .printApproachText
.checkPsychicApproach
	cp 19 ; ARENA #20, the dark-visions Psychic
	jr nz, .checkSuperNerd23Approach
	ld hl, BattleIslandPsychicApproachesText
	jp .printApproachText
.checkSuperNerd23Approach
	cp 22 ; ARENA #23, the Super Nerd looking for a Yoshi
	jr nz, .checkGamblerApproach
	ld hl, BattleIslandSuperNerdApproachesText
	jp .printApproachText
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
	jr nz, .checkChannelerApproach
	ld hl, BattleIslandTamerApproachesText
	jr .printApproachText
.checkChannelerApproach
	cp 14 ; ARENA #15, the war-dead Channeler
	jr nz, .checkSwimmerApproach
	ld hl, BattleIslandChannelerApproachesText
	jr .printApproachText
.checkSwimmerApproach
	cp 23 ; ARENA #24, the himbo Swimmer
	jr nz, .checkRockerApproach
	ld hl, BattleIslandSwimmerApproachesText
	jr .printApproachText
.checkRockerApproach
	cp 25 ; ARENA #26, the garage-band Rocker
	jr nz, .checkCooltrainerApproach
	ld hl, BattleIslandRockerApproachesText
	jr .printApproachText
.checkCooltrainerApproach
	cp 3 ; ARENA #4, cringe Cooltrainer
	jr z, .cooltrainerApproach
	cp 15 ; ARENA #16, cringe Cooltrainer
	jr nz, .checkGentlemanApproach
.cooltrainerApproach
	ld hl, BattleIslandCooltrainerApproachesText
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
	jp .notSuperNerdWinText
.checkSuperNerdWinText
	cp 1 ; ARENA #2, the dad-energy Hiker
	jr nz, .checkYoshiWinText
	ld hl, BattleIslandHikerDefeatedText
	jp .notSuperNerdWinText
.checkYoshiWinText
	cp 21 ; ARENA #22, the rumor-spreading Youngster
	jr nz, .checkPsychicWinText
	ld hl, BattleIslandYoungsterDefeatedText
	jp .notSuperNerdWinText
.checkPsychicWinText
	cp 19 ; ARENA #20, the dark-visions Psychic
	jr nz, .checkSuperNerd23WinText
	ld hl, BattleIslandPsychicDefeatedText
	jp .notSuperNerdWinText
.checkSuperNerd23WinText
	cp 22 ; ARENA #23, the Super Nerd looking for a Yoshi
	jr nz, .checkGamblerWinText
	ld hl, BattleIslandSuperNerdDefeatedText
	jp .notSuperNerdWinText
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
	jr nz, .checkChannelerWinText
	ld hl, BattleIslandTamerDefeatedText
	jr .notSuperNerdWinText
.checkChannelerWinText
	cp 14 ; ARENA #15, the war-dead Channeler
	jr nz, .checkSwimmerWinText
	ld hl, BattleIslandChannelerDefeatedText
	jr .notSuperNerdWinText
.checkSwimmerWinText
	cp 23 ; ARENA #24, the himbo Swimmer
	jr nz, .checkRockerWinText
	ld hl, BattleIslandSwimmerDefeatedText
	jr .notSuperNerdWinText
.checkRockerWinText
	cp 25 ; ARENA #26, the garage-band Rocker
	jr nz, .checkCooltrainerWinText
	ld hl, BattleIslandRockerDefeatedText
	jr .notSuperNerdWinText
.checkCooltrainerWinText
	cp 3 ; ARENA #4, cringe Cooltrainer
	jr z, .cooltrainerWinText
	cp 15 ; ARENA #16, cringe Cooltrainer
	jr nz, .checkGentlemanWinText
.cooltrainerWinText
	ld hl, BattleIslandCooltrainerDefeatedText
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
	db OPP_TAMER,          2 ; 25
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

BattleIslandPsychicApproachesText:
	text_far _BattleIslandPsychicApproachesText
	text_end

BattleIslandPsychicDefeatedText:
	text_far _BattleIslandPsychicDefeatedText
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

BattleIslandChannelerApproachesText:
	text_far _BattleIslandChannelerApproachesText
	text_end

BattleIslandChannelerDefeatedText:
	text_far _BattleIslandChannelerDefeatedText
	text_end

BattleIslandSwimmerApproachesText:
	text_far _BattleIslandSwimmerApproachesText
	text_end

BattleIslandSwimmerDefeatedText:
	text_far _BattleIslandSwimmerDefeatedText
	text_end

BattleIslandRockerApproachesText:
	text_far _BattleIslandRockerApproachesText
	text_end

BattleIslandRockerDefeatedText:
	text_far _BattleIslandRockerDefeatedText
	text_end

BattleIslandCooltrainerApproachesText:
	text_far _BattleIslandCooltrainerApproachesText
	text_end

BattleIslandCooltrainerDefeatedText:
	text_far _BattleIslandCooltrainerDefeatedText
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
