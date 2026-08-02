SilphCo3F_Script:
	call SilphCo3FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo3TrainerHeaders
	ld de, SilphCo3F_ScriptPointers
	ld a, [wSilphCo3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo3FCurScript], a
	ret

SilphCo3FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	call SilphCo3FSetFactionObjectsScript
	ld hl, .GateCoordinates
	call SilphCo2F_SetCardKeyDoorYScript
	call SilphCo3F_UnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	jr nz, .unlock_door1
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 4
	predef ReplaceTileBlock
	pop af
.unlock_door1
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_3_UNLOCKED_DOOR2, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 8
	predef_jump ReplaceTileBlock

.GateCoordinates:
	dbmapcoord  4,  4
	dbmapcoord  8,  4
	db -1 ; end

SilphCo3F_UnlockedDoorEventScript:
	EventFlagAddress hl, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ldh a, [hUnlockedSilphCoDoors]
	and a
	ret z
	cp $1
	jr nz, .unlock_door1
	SetEventReuseHL EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret
.unlock_door1
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_3_UNLOCKED_DOOR2, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret

SilphCo3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO3F_END_BATTLE

SilphCo3F_TextPointers:
	def_text_pointers
	dw_const SilphCo3FSilphWorkerMText, TEXT_SILPHCO3F_SILPH_WORKER_M
	dw_const SilphCo3FRocketText,       TEXT_SILPHCO3F_ROCKET
	dw_const SilphCo3FScientistText,    TEXT_SILPHCO3F_SCIENTIST
	dw_const PickUpItemText,            TEXT_SILPHCO3F_HYPER_POTION
	dw_const SilphCo3FFlavorRocketText, TEXT_SILPHCO3F_FLAVOR_ROCKET
	dw_const SilphCo3FFlavorScientistText, TEXT_SILPHCO3F_FLAVOR_SCIENTIST
	dw_const SilphCo3FDefender1Text, TEXT_SILPHCO3F_DEFENDER1

SilphCo3TrainerHeaders:
	def_trainers 2
SilphCo3TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_0, 2, SilphCo3FRocketBattleText, SilphCo3FRocketEndBattleText, SilphCo3FRocketAfterBattleText
SilphCo3TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_1, 3, SilphCo3FScientistBattleText, SilphCo3FScientistEndBattleText, SilphCo3FScientistAfterBattleText
SilphCo3TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_2, 2, SilphCo3FDefender1BattleText, SilphCo3FDefender1EndBattleText, SilphCo3FDefender1AfterBattleText
	db -1 ; end

SilphCo3FSilphWorkerMText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .YouSavedUsText
	jr nz, .beat_giovanni
	ld hl, .WhatShouldIDoText
.beat_giovanni
	call PrintText
	jp TextScriptEnd

.WhatShouldIDoText:
	text_far _SilphCo3FSilphWorkerMWhatShouldIDoText
	text_end

.YouSavedUsText:
	text_far _SilphCo3FSilphWorkerMYouSavedUsText
	text_end

SilphCo3FRocketText:
	text_asm
	ld hl, SilphCo3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo3FRocketBattleText:
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
	text_far _SilphCo3FRocketBattleText
	text_end
.LoyalistText:
	text_far _SilphCo3FRocketLoyalistBattleText
	text_end

SilphCo3FRocketEndBattleText:
	text_far _SilphCo3FRocketEndBattleText
	text_end

SilphCo3FRocketAfterBattleText:
	text_far _SilphCo3FRocketAfterBattleText
	text_end

SilphCo3FScientistText:
	text_asm
	ld hl, SilphCo3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo3FScientistBattleText:
	text_far _SilphCo3FScientistBattleText
	text_end

SilphCo3FScientistEndBattleText:
	text_far _SilphCo3FScientistEndBattleText
	text_end

SilphCo3FScientistAfterBattleText:
	text_far _SilphCo3FScientistAfterBattleText
	text_end

SilphCo3FFlavorRocketText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo3FFlavorRocketText
	text_end

SilphCo3FFlavorScientistText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo3FFlavorScientistText
	text_end

; TEAM ROCKET holds this floor. On the hero path they fight you and the SILPH
; staff stay hidden; on the loyalist path they are comrades, so the staff
; defend the building instead. Each pair shares a tile, so exactly one of the
; two is ever shown. Skipped once the boss has fallen -- by then
; SilphCo11FTeamRocketLeavesScript has cleared this floor for good, and
; re-showing anyone here on the next map load would undo that.
SilphCo3FSetFactionObjectsScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	ld hl, .Defenders
	call SilphCo3FHideObjectList
	ld hl, .Rockets
	jp SilphCo3FShowObjectList
.loyalist
	ld hl, .Rockets
	call SilphCo3FHideObjectList
	ld hl, .Defenders
	jp SilphCo3FShowObjectList

.Rockets:
	db TOGGLE_SILPH_CO_3F_1
	db -1 ; end

.Defenders:
	db TOGGLE_SILPH_CO_3F_DEFENDER1
	db -1 ; end

SilphCo3FShowObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef ShowObject
	pop hl
	jr SilphCo3FShowObjectList

SilphCo3FHideObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef HideObject
	pop hl
	jr SilphCo3FHideObjectList

SilphCo3FDefender1Text:
	text_asm
	ld hl, SilphCo3TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo3FDefender1BattleText:
	text_far _SilphCo3FDefender1BattleText
	text_end

SilphCo3FDefender1EndBattleText:
	text_far _SilphCo3FDefender1EndBattleText
	text_end

SilphCo3FDefender1AfterBattleText:
	text_far _SilphCo3FDefender1AfterBattleText
	text_end
