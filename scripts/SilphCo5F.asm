SilphCo5F_Script:
	call SilphCo5FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo5TrainerHeaders
	ld de, SilphCo5F_ScriptPointers
	ld a, [wSilphCo5FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo5FCurScript], a
	ret

SilphCo5FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	call SilphCo5FSetFactionObjectsScript
	ld hl, .GateCoordinates
	call SilphCo4F_SetCardKeyDoorYScript
	call SilphCo5F_SetUnlockedSilphCoDoorsScript
	CheckEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	jr nz, .unlock_door1
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 2, 3
	predef ReplaceTileBlock
	pop af
.unlock_door1
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_5_UNLOCKED_DOOR2, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	jr nz, .unlock_door2
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 6, 3
	predef ReplaceTileBlock
	pop af
.unlock_door2
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_5_UNLOCKED_DOOR3, EVENT_SILPH_CO_5_UNLOCKED_DOOR2
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 5, 7
	predef_jump ReplaceTileBlock

.GateCoordinates:
	dbmapcoord  3,  2
	dbmapcoord  3,  6
	dbmapcoord  7,  5
	db -1 ; end

SilphCo5F_SetUnlockedSilphCoDoorsScript:
	EventFlagAddress hl, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ldh a, [hUnlockedSilphCoDoors]
	and a
	ret z
	cp $1
	jr nz, .unlock_door1
	SetEventReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret
.unlock_door1
	cp $2
	jr nz, .unlock_door2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR2, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret
.unlock_door2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR3, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret

SilphCo5F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO5F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO5F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO5F_END_BATTLE

SilphCo5F_TextPointers:
	def_text_pointers
	dw_const SilphCo5FSilphWorkerMText,   TEXT_SILPHCO5F_SILPH_WORKER_M
	dw_const SilphCo5FRocket1Text,        TEXT_SILPHCO5F_ROCKET1
	dw_const SilphCo5FScientistText,      TEXT_SILPHCO5F_SCIENTIST
	dw_const SilphCo5FRockerText,         TEXT_SILPHCO5F_ROCKER
	dw_const SilphCo5FRocket2Text,        TEXT_SILPHCO5F_ROCKET2
	dw_const PickUpItemText,              TEXT_SILPHCO5F_TM_TAKE_DOWN
	dw_const PickUpItemText,              TEXT_SILPHCO5F_PROTEIN
	dw_const PickUpItemText,              TEXT_SILPHCO5F_CARD_KEY
	dw_const SilphCo5FPokemonReport1Text, TEXT_SILPHCO5F_POKEMON_REPORT1
	dw_const SilphCo5FPokemonReport2Text, TEXT_SILPHCO5F_POKEMON_REPORT2
	dw_const SilphCo5FPokemonReport3Text, TEXT_SILPHCO5F_POKEMON_REPORT3
	dw_const SilphCo5FFlavorRocketText,   TEXT_SILPHCO5F_FLAVOR_ROCKET
	dw_const SilphCo5FFlavorScientistText, TEXT_SILPHCO5F_FLAVOR_SCIENTIST
	dw_const SilphCo5FDefender1Text, TEXT_SILPHCO5F_DEFENDER1
	dw_const SilphCo5FDefender2Text, TEXT_SILPHCO5F_DEFENDER2
	dw_const SilphCo5FDefender3Text, TEXT_SILPHCO5F_DEFENDER3

SilphCo5TrainerHeaders:
	def_trainers 2
SilphCo5TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_0, 1, SilphCo5FRocket1BattleText, SilphCo5FRocket1EndBattleText, SilphCo5FRocket1AfterBattleText
SilphCo5TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_1, 2, SilphCo5FScientistBattleText, SilphCo5FScientistEndBattleText, SilphCo5FScientistAfterBattleText
SilphCo5TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_2, 4, SilphCo5FRockerBattleText, SilphCo5FRockerEndBattleText, SilphCo5FRockerAfterBattleText
SilphCo5TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_3, 3, SilphCo5FRocket2BattleText, SilphCo5FRocket2EndBattleText, SilphCo5FRocket2AfterBattleText
SilphCo5TrainerHeader5:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_4, 1, SilphCo5FDefender1BattleText, SilphCo5FDefender1EndBattleText, SilphCo5FDefender1AfterBattleText
SilphCo5TrainerHeader6:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_5, 3, SilphCo5FDefender2BattleText, SilphCo5FDefender2EndBattleText, SilphCo5FDefender2AfterBattleText
SilphCo5TrainerHeader7:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_6, 4, SilphCo5FDefender3BattleText, SilphCo5FDefender3EndBattleText, SilphCo5FDefender3AfterBattleText
	db -1 ; end

SilphCo5FSilphWorkerMText:
	text_asm
	ld hl, .ThatsYouRightText
	ld de, .YoureOurHeroText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	jp TextScriptEnd

.ThatsYouRightText:
	text_far _SilphCo5FSilphWorkerMThatsYouRightText
	text_end

.YoureOurHeroText:
	text_far _SilphCo5FSilphWorkerMYoureOurHeroText
	text_end

SilphCo5FRocket1Text:
	text_asm
	ld hl, SilphCo5TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FRocket1BattleText:
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .LoyalistText
	jr nz, .print
	ld hl, .HostileText
.print
	call PrintText
	jp TextScriptEnd
.HostileText:
	text_far _SilphCo5FRocket1BattleText
	text_end
.LoyalistText:
	text_far _SilphCo5FRocket1LoyalistBattleText
	text_end

SilphCo5FRocket1EndBattleText:
	text_far _SilphCo5FRocket1EndBattleText
	text_end

SilphCo5FRocket1AfterBattleText:
	text_far _SilphCo5FRocket1AfterBattleText
	text_end

SilphCo5FScientistText:
	text_asm
	ld hl, SilphCo5TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FScientistBattleText:
	text_far _SilphCo5FScientistBattleText
	text_end

SilphCo5FScientistEndBattleText:
	text_far _SilphCo5FScientistEndBattleText
	text_end

SilphCo5FScientistAfterBattleText:
	text_far _SilphCo5FScientistAfterBattleText
	text_end

SilphCo5FRockerText:
	text_asm
	ld hl, SilphCo5TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FRockerBattleText:
	text_far _SilphCo5FRockerBattleText
	text_end

SilphCo5FRockerEndBattleText:
	text_far _SilphCo5FRockerEndBattleText
	text_end

SilphCo5FRockerAfterBattleText:
	text_far _SilphCo5FRockerAfterBattleText
	text_end

SilphCo5FRocket2Text:
	text_asm
	ld hl, SilphCo5TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FRocket2BattleText:
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .LoyalistText
	jr nz, .print
	ld hl, .HostileText
.print
	call PrintText
	jp TextScriptEnd
.HostileText:
	text_far _SilphCo5FRocket2BattleText
	text_end
.LoyalistText:
	text_far _SilphCo5FRocket2LoyalistBattleText
	text_end

SilphCo5FRocket2EndBattleText:
	text_far _SilphCo5FRocket2EndBattleText
	text_end

SilphCo5FRocket2AfterBattleText:
	text_far _SilphCo5FRocket2AfterBattleText
	text_end

SilphCo5FPokemonReport1Text:
	text_far _SilphCo5FPokemonReport1Text
	text_end

SilphCo5FPokemonReport2Text:
	text_far _SilphCo5FPokemonReport2Text
	text_end

SilphCo5FPokemonReport3Text:
	text_far _SilphCo5FPokemonReport3Text
	text_end

SilphCo5FFlavorRocketText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo5FFlavorRocketText
	text_end

SilphCo5FFlavorScientistText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo5FFlavorScientistText
	text_end

; TEAM ROCKET holds this floor. On the hero path they fight you and the SILPH
; staff stay hidden; on the loyalist path they are comrades, so the staff
; defend the building instead. Each pair shares a tile, so exactly one of the
; two is ever shown. Skipped once the boss has fallen -- by then
; SilphCo11FTeamRocketLeavesScript has cleared this floor for good, and
; re-showing anyone here on the next map load would undo that.
SilphCo5FSetFactionObjectsScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	ld hl, .Defenders
	call SilphCo5FHideObjectList
	ld hl, .Rockets
	jp SilphCo5FShowObjectList
.loyalist
	ld hl, .Rockets
	call SilphCo5FHideObjectList
	ld hl, .Defenders
	jp SilphCo5FShowObjectList

.Rockets:
	db TOGGLE_SILPH_CO_5F_1
	db TOGGLE_SILPH_CO_5F_4
	db TOGGLE_SILPH_CO_5F_3
	db -1 ; end

.Defenders:
	db TOGGLE_SILPH_CO_5F_DEFENDER1
	db TOGGLE_SILPH_CO_5F_DEFENDER2
	db TOGGLE_SILPH_CO_5F_DEFENDER3
	db -1 ; end

SilphCo5FShowObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef ShowObject
	pop hl
	jr SilphCo5FShowObjectList

SilphCo5FHideObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef HideObject
	pop hl
	jr SilphCo5FHideObjectList

SilphCo5FDefender1Text:
	text_asm
	ld hl, SilphCo5TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FDefender1BattleText:
	text_far _SilphCo5FDefender1BattleText
	text_end

SilphCo5FDefender1EndBattleText:
	text_far _SilphCo5FDefender1EndBattleText
	text_end

SilphCo5FDefender1AfterBattleText:
	text_far _SilphCo5FDefender1AfterBattleText
	text_end

SilphCo5FDefender2Text:
	text_asm
	ld hl, SilphCo5TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FDefender2BattleText:
	text_far _SilphCo5FDefender2BattleText
	text_end

SilphCo5FDefender2EndBattleText:
	text_far _SilphCo5FDefender2EndBattleText
	text_end

SilphCo5FDefender2AfterBattleText:
	text_far _SilphCo5FDefender2AfterBattleText
	text_end

SilphCo5FDefender3Text:
	text_asm
	ld hl, SilphCo5TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FDefender3BattleText:
	text_far _SilphCo5FDefender3BattleText
	text_end

SilphCo5FDefender3EndBattleText:
	text_far _SilphCo5FDefender3EndBattleText
	text_end

SilphCo5FDefender3AfterBattleText:
	text_far _SilphCo5FDefender3AfterBattleText
	text_end
