SilphCo10F_Script:
	call SilphCo10FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo10TrainerHeaders
	ld de, SilphCo10F_ScriptPointers
	ld a, [wSilphCo10FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo10FCurScript], a
	ret

SilphCo10FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	call SilphCo10FSetFactionObjectsScript
	ld hl, .GateCoordinates
	call SilphCo2F_SetCardKeyDoorYScript
	call SilphCo10F_SetUnlockedSilphCoDoorsScript
	CheckEvent EVENT_SILPH_CO_10_UNLOCKED_DOOR
	ret nz
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 4, 5
	predef_jump ReplaceTileBlock

.GateCoordinates:
	dbmapcoord  5,  4
	db -1 ; end

SilphCo10F_SetUnlockedSilphCoDoorsScript:
	ldh a, [hUnlockedSilphCoDoors]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_10_UNLOCKED_DOOR
	ret

SilphCo10F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO10F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO10F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO10F_END_BATTLE

SilphCo10F_TextPointers:
	def_text_pointers
	dw_const SilphCo10FRocketText,       TEXT_SILPHCO10F_ROCKET
	dw_const SilphCo10FScientistText,    TEXT_SILPHCO10F_SCIENTIST
	dw_const SilphCo10FSilphWorkerFText, TEXT_SILPHCO10F_SILPH_WORKER_F
	dw_const PickUpItemText,             TEXT_SILPHCO10F_TM_EARTHQUAKE
	dw_const PickUpItemText,             TEXT_SILPHCO10F_RARE_CANDY
	dw_const PickUpItemText,             TEXT_SILPHCO10F_CARBOS
	dw_const SilphCo10FFlavorRocketText, TEXT_SILPHCO10F_FLAVOR_ROCKET
	dw_const SilphCo10FFlavorScientistText, TEXT_SILPHCO10F_FLAVOR_SCIENTIST
	dw_const SilphCo10FDefender1Text, TEXT_SILPHCO10F_DEFENDER1

SilphCo10TrainerHeaders:
	def_trainers
SilphCo10TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_10F_TRAINER_0, 3, SilphCo10FRocketBattleText, SilphCo10FRocketEndBattleText, SilphCo10FRocketAfterBattleText
SilphCo10TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_10F_TRAINER_1, 4, SilphCo10FScientistBattleText, SilphCo10FScientistEndBattleText, SilphCo10FScientistAfterBattleText
SilphCo10TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_10F_TRAINER_2, 3, SilphCo10FDefender1BattleText, SilphCo10FDefender1EndBattleText, SilphCo10FDefender1AfterBattleText
	db -1 ; end

SilphCo10FRocketText:
	text_asm
	ld hl, SilphCo10TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo10FScientistText:
	text_asm
	ld hl, SilphCo10TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo10FSilphWorkerFText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .QuietAboutMyCryingText
	jr nz, .beat_giovanni
	ld hl, .ImScaredText
.beat_giovanni
	call PrintText
	jp TextScriptEnd

.ImScaredText:
	text_far _SilphCo10FSilphWorkerFImScaredText
	text_end

.QuietAboutMyCryingText:
	text_far _SilphCo10FSilphWorkerFQuietAboutMyCryingText
	text_end

SilphCo10FRocketBattleText:
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
	text_far _SilphCo10FRocketBattleText
	text_end
.LoyalistText:
	text_far _SilphCo10FRocketLoyalistBattleText
	text_end

SilphCo10FRocketEndBattleText:
	text_far _SilphCo10FRocketEndBattleText
	text_end

SilphCo10FRocketAfterBattleText:
	text_far _SilphCo10FRocketAfterBattleText
	text_end

SilphCo10FScientistBattleText:
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .HeroText
	jr z, .print
	ld hl, .HostileText
.print
	call PrintText
	jp TextScriptEnd
.HostileText:
	text_far _SilphCo10FScientistBattleText
	text_end
.HeroText:
	text_far _SilphCo10FScientistHeroBattleText
	text_end

SilphCo10FScientistEndBattleText:
	text_far _SilphCo10FScientistEndBattleText
	text_end

SilphCo10FScientistAfterBattleText:
	text_far _SilphCo10FScientistAfterBattleText
	text_end

SilphCo10FFlavorRocketText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo10FFlavorRocketText
	text_end

SilphCo10FFlavorScientistText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo10FFlavorScientistText
	text_end

; TEAM ROCKET holds this floor. On the hero path they fight you and the SILPH
; staff stay hidden; on the loyalist path they are comrades, so the staff
; defend the building instead. Each pair shares a tile, so exactly one of the
; two is ever shown. Skipped once the boss has fallen -- by then
; SilphCo11FTeamRocketLeavesScript has cleared this floor for good, and
; re-showing anyone here on the next map load would undo that.
SilphCo10FSetFactionObjectsScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	ld hl, .Defenders
	call SilphCo10FHideObjectList
	ld hl, .Rockets
	jp SilphCo10FShowObjectList
.loyalist
	ld hl, .Rockets
	call SilphCo10FHideObjectList
	ld hl, .Defenders
	jp SilphCo10FShowObjectList

.Rockets:
	db TOGGLE_SILPH_CO_10F_1
	db -1 ; end

.Defenders:
	db TOGGLE_SILPH_CO_10F_DEFENDER1
	db -1 ; end

SilphCo10FShowObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef ShowObject
	pop hl
	jr SilphCo10FShowObjectList

SilphCo10FHideObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef HideObject
	pop hl
	jr SilphCo10FHideObjectList

SilphCo10FDefender1Text:
	text_asm
	ld hl, SilphCo10TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo10FDefender1BattleText:
	text_far _SilphCo10FDefender1BattleText
	text_end

SilphCo10FDefender1EndBattleText:
	text_far _SilphCo10FDefender1EndBattleText
	text_end

SilphCo10FDefender1AfterBattleText:
	text_far _SilphCo10FDefender1AfterBattleText
	text_end
