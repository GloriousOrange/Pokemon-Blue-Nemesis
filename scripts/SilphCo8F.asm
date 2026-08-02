SilphCo8F_Script:
	call SilphCo8FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo8TrainerHeaders
	ld de, SilphCo8F_ScriptPointers
	ld a, [wSilphCo8FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo8FCurScript], a
	ret

SilphCo8FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	call SilphCo8FSetFactionObjectsScript
	ld hl, .GateCoordinates
	call SilphCo8F_SetCardKeyDoorYScript
	call SilphCo8F_UnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 3
	predef_jump ReplaceTileBlock

.GateCoordinates:
	dbmapcoord  3,  4
	db -1 ; end

SilphCo8F_SetCardKeyDoorYScript:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ldh [hUnlockedSilphCoDoors], a
	pop hl
.loop_check_doors
	ld a, [hli]
	cp $ff
	jr z, .exit_loop
	push hl
	ld hl, hUnlockedSilphCoDoors
	inc [hl]
	pop hl
	cp b
	jr z, .check_y_coord
	inc hl
	jr .loop_check_doors
.check_y_coord
	ld a, [hli]
	cp c
	jr nz, .loop_check_doors
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.exit_loop
	xor a
	ldh [hUnlockedSilphCoDoors], a
	ret

SilphCo8F_UnlockedDoorEventScript:
	ldh a, [hUnlockedSilphCoDoors]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	ret

SilphCo8F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO8F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO8F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO8F_END_BATTLE

SilphCo8F_TextPointers:
	def_text_pointers
	dw_const SilphCo8FSilphWorkerMText, TEXT_SILPHCO8F_SILPH_WORKER_M
	dw_const SilphCo8FRocket1Text,      TEXT_SILPHCO8F_ROCKET1
	dw_const SilphCo8FScientistText,    TEXT_SILPHCO8F_SCIENTIST
	dw_const SilphCo8FRocket2Text,      TEXT_SILPHCO8F_ROCKET2
	dw_const SilphCo8FFlavorRocketText, TEXT_SILPHCO8F_FLAVOR_ROCKET
	dw_const SilphCo8FFlavorScientistText, TEXT_SILPHCO8F_FLAVOR_SCIENTIST
	dw_const SilphCo8FDefender1Text, TEXT_SILPHCO8F_DEFENDER1
	dw_const SilphCo8FDefender2Text, TEXT_SILPHCO8F_DEFENDER2

SilphCo8TrainerHeaders:
	def_trainers 2
SilphCo8TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_0, 4, SilphCo8FRocket1BattleText, SilphCo8FRocket1EndBattleText, SilphCo8FRocket1AfterBattleText
SilphCo8TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_1, 4, SilphCo8FScientistBattleText, SilphCo8FScientistEndBattleText, SilphCo8FScientistAfterBattleText
SilphCo8TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_2, 4, SilphCo8FRocket2BattleText, SilphCo8FRocket2EndBattleText, SilphCo8FRocket2AfterBattleText
SilphCo8TrainerHeader4:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_3, 4, SilphCo8FDefender1BattleText, SilphCo8FDefender1EndBattleText, SilphCo8FDefender1AfterBattleText
SilphCo8TrainerHeader5:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_4, 4, SilphCo8FDefender2BattleText, SilphCo8FDefender2EndBattleText, SilphCo8FDefender2AfterBattleText
	db -1 ; end

SilphCo8FSilphWorkerMText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, .ThanksForSavingUsText
	jr nz, .beat_giovanni
	ld hl, .SilphIsFinishedText
.beat_giovanni
	call PrintText
	jp TextScriptEnd

.SilphIsFinishedText:
	text_far _SilphCo8FSilphWorkerMSilphIsFinishedText
	text_end

.ThanksForSavingUsText:
	text_far _SilphCo8FSilphWorkerMThanksForSavingUsText
	text_end

SilphCo8FRocket1Text:
	text_asm
	ld hl, SilphCo8TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FScientistText:
	text_asm
	ld hl, SilphCo8TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FRocket2Text:
	text_asm
	ld hl, SilphCo8TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FRocket1BattleText:
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
	text_far _SilphCo8FRocket1BattleText
	text_end
.LoyalistText:
	text_far _SilphCo8FRocket1LoyalistBattleText
	text_end

SilphCo8FRocket1EndBattleText:
	text_far _SilphCo8FRocket1EndBattleText
	text_end

SilphCo8FRocket1AfterBattleText:
	text_far _SilphCo8FRocket1AfterBattleText
	text_end

SilphCo8FScientistBattleText:
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
	text_far _SilphCo8FScientistBattleText
	text_end
.HeroText:
	text_far _SilphCo8FScientistHeroBattleText
	text_end

SilphCo8FScientistEndBattleText:
	text_far _SilphCo8FScientistEndBattleText
	text_end

SilphCo8FScientistAfterBattleText:
	text_far _SilphCo8FScientistAfterBattleText
	text_end

SilphCo8FRocket2BattleText:
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
	text_far _SilphCo8FRocket2BattleText
	text_end
.LoyalistText:
	text_far _SilphCo8FRocket2LoyalistBattleText
	text_end

SilphCo8FRocket2EndBattleText:
	text_far _SilphCo8FRocket2EndBattleText
	text_end

SilphCo8FRocket2AfterBattleText:
	text_far _SilphCo8FRocket2AfterBattleText
	text_end

; Flavor pair: pure dialogue, never a battle (see data/maps/objects/SilphCo8F.asm).
SilphCo8FFlavorRocketText:
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
	text_far _SilphCo8FFlavorRocketText
	text_end
.LoyalistText:
	text_far _SilphCo8FFlavorRocketLoyalistText
	text_end

SilphCo8FFlavorScientistText:
	text_far _SilphCo8FFlavorScientistText
	text_end

; TEAM ROCKET holds this floor. On the hero path they fight you and the SILPH
; staff stay hidden; on the loyalist path they are comrades, so the staff
; defend the building instead. Each pair shares a tile, so exactly one of the
; two is ever shown. Skipped once the boss has fallen -- by then
; SilphCo11FTeamRocketLeavesScript has cleared this floor for good, and
; re-showing anyone here on the next map load would undo that.
SilphCo8FSetFactionObjectsScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	ld hl, .Defenders
	call SilphCo8FHideObjectList
	ld hl, .Rockets
	jp SilphCo8FShowObjectList
.loyalist
	ld hl, .Rockets
	call SilphCo8FHideObjectList
	ld hl, .Defenders
	jp SilphCo8FShowObjectList

.Rockets:
	db TOGGLE_SILPH_CO_8F_1
	db TOGGLE_SILPH_CO_8F_3
	db -1 ; end

.Defenders:
	db TOGGLE_SILPH_CO_8F_DEFENDER1
	db TOGGLE_SILPH_CO_8F_DEFENDER2
	db -1 ; end

SilphCo8FShowObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef ShowObject
	pop hl
	jr SilphCo8FShowObjectList

SilphCo8FHideObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef HideObject
	pop hl
	jr SilphCo8FHideObjectList

SilphCo8FDefender1Text:
	text_asm
	ld hl, SilphCo8TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FDefender1BattleText:
	text_far _SilphCo8FDefender1BattleText
	text_end

SilphCo8FDefender1EndBattleText:
	text_far _SilphCo8FDefender1EndBattleText
	text_end

SilphCo8FDefender1AfterBattleText:
	text_far _SilphCo8FDefender1AfterBattleText
	text_end

SilphCo8FDefender2Text:
	text_asm
	ld hl, SilphCo8TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FDefender2BattleText:
	text_far _SilphCo8FDefender2BattleText
	text_end

SilphCo8FDefender2EndBattleText:
	text_far _SilphCo8FDefender2EndBattleText
	text_end

SilphCo8FDefender2AfterBattleText:
	text_far _SilphCo8FDefender2AfterBattleText
	text_end
