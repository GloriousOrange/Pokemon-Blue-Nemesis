SilphCo9F_Script:
	call SilphCo9FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo9TrainerHeaders
	ld de, SilphCo9F_ScriptPointers
	ld a, [wSilphCo9FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo9FCurScript], a
	ret

SilphCo9FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	call SilphCo9FSetFactionObjectsScript
	ld hl, .GateCoordinates
	call SilphCo9F_SetCardKeyDoorYScript
	call SilphCo9F_SetUnlockedSilphCoDoorsScript
	CheckEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	jr nz, .unlock_door1
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 1
	predef ReplaceTileBlock
	pop af
.unlock_door1
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_9_UNLOCKED_DOOR2, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	jr nz, .unlock_door2
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 2, 9
	predef ReplaceTileBlock
	pop af
.unlock_door2
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_9_UNLOCKED_DOOR3, EVENT_SILPH_CO_9_UNLOCKED_DOOR2
	jr nz, .unlock_door3
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 5, 9
	predef ReplaceTileBlock
	pop af
.unlock_door3
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_9_UNLOCKED_DOOR4, EVENT_SILPH_CO_9_UNLOCKED_DOOR3
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 6, 5
	predef_jump ReplaceTileBlock

.GateCoordinates:
	dbmapcoord  1,  4
	dbmapcoord  9,  2
	dbmapcoord  9,  5
	dbmapcoord  5,  6
	db -1 ; end

SilphCo9F_SetCardKeyDoorYScript:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ldh [hUnlockedSilphCoDoors], a
	pop hl
.loop_card_key_doors
	ld a, [hli]
	cp $ff
	jr z, .exit_loop
	push hl
	ld hl, hUnlockedSilphCoDoors
	inc [hl]
	pop hl
	cp b
	jr z, .check_door
	inc hl
	jr .loop_card_key_doors
.check_door
	ld a, [hli]
	cp c
	jr nz, .loop_card_key_doors
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.exit_loop
	xor a
	ldh [hUnlockedSilphCoDoors], a
	ret

SilphCo9F_SetUnlockedSilphCoDoorsScript:
	EventFlagAddress hl, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ldh a, [hUnlockedSilphCoDoors]
	and a
	ret z
	cp $1
	jr nz, .unlock_door1
	SetEventReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret
.unlock_door1
	cp $2
	jr nz, .unlock_door2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR2, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret
.unlock_door2
	cp $3
	jr nz, .unlock_door3
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR3, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret
.unlock_door3
	cp $4
	ret nz
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR4, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret

SilphCo9F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO9F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO9F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO9F_END_BATTLE

SilphCo9F_TextPointers:
	def_text_pointers
	dw_const SilphCo9FNurseText,     TEXT_SILPHCO9F_NURSE
	dw_const SilphCo9FRocket1Text,   TEXT_SILPHCO9F_ROCKET1
	dw_const SilphCo9FScientistText, TEXT_SILPHCO9F_SCIENTIST
	dw_const SilphCo9FRocket2Text,   TEXT_SILPHCO9F_ROCKET2
	dw_const SilphCo9FFlavorRocketText, TEXT_SILPHCO9F_FLAVOR_ROCKET
	dw_const SilphCo9FFlavorScientistText, TEXT_SILPHCO9F_FLAVOR_SCIENTIST
	dw_const SilphCo9FDefender1Text, TEXT_SILPHCO9F_DEFENDER1
	dw_const SilphCo9FDefender2Text, TEXT_SILPHCO9F_DEFENDER2

SilphCo9TrainerHeaders:
	def_trainers 2
SilphCo9TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_9F_TRAINER_0, 4, SilphCo9FRocket1BattleText, SilphCo9FRocket1EndBattleText, SilphCo9FRocket1AfterBattleText
SilphCo9TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_9F_TRAINER_1, 2, SilphCo9FScientistBattleText, SilphCo9FScientistEndBattleText, SilphCo9FScientistAfterBattleText
SilphCo9TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_9F_TRAINER_2, 4, SilphCo9FRocket2BattleText, SilphCo9FRocket2EndBattleText, SilphCo9FRocket2AfterBattleText
SilphCo9TrainerHeader4:
	trainer EVENT_BEAT_SILPH_CO_9F_TRAINER_3, 4, SilphCo9FDefender1BattleText, SilphCo9FDefender1EndBattleText, SilphCo9FDefender1AfterBattleText
SilphCo9TrainerHeader5:
	trainer EVENT_BEAT_SILPH_CO_9F_TRAINER_4, 4, SilphCo9FDefender2BattleText, SilphCo9FDefender2EndBattleText, SilphCo9FDefender2AfterBattleText
	db -1 ; end

SilphCo9FNurseText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .beat_giovanni
	ld hl, .YouLookTiredText
	call PrintText
	predef HealParty
	call GBFadeOutToWhite
	call Delay3
	call GBFadeInFromWhite
	ld hl, .DontGiveUpText
	call PrintText
	jr .text_script_end
.beat_giovanni
	ld hl, .ThankYouText
	call PrintText
.text_script_end
	jp TextScriptEnd

.YouLookTiredText:
	text_far SilphCo9FNurseYouLookTiredText
	text_end

.DontGiveUpText:
	text_far SilphCo9FNurseDontGiveUpText
	text_end

.ThankYouText:
	text_far SilphCo9FNurseThankYouText
	text_end

SilphCo9FRocket1Text:
	text_asm
	ld hl, SilphCo9TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9FScientistText:
	text_asm
	ld hl, SilphCo9TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9FRocket2Text:
	text_asm
	ld hl, SilphCo9TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9FRocket1BattleText:
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
	text_far _SilphCo9FRocket1BattleText
	text_end
.LoyalistText:
	text_far _SilphCo9FRocket1LoyalistBattleText
	text_end

SilphCo9FRocket1EndBattleText:
	text_far _SilphCo9FRocket1EndBattleText
	text_end

SilphCo9FRocket1AfterBattleText:
	text_far _SilphCo9FRocket1AfterBattleText
	text_end

SilphCo9FScientistBattleText:
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
	text_far _SilphCo9FScientistBattleText
	text_end
.HeroText:
	text_far _SilphCo9FScientistHeroBattleText
	text_end

SilphCo9FScientistEndBattleText:
	text_far _SilphCo9FScientistEndBattleText
	text_end

SilphCo9FScientistAfterBattleText:
	text_far _SilphCo9FScientistAfterBattleText
	text_end

SilphCo9FRocket2BattleText:
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
	text_far _SilphCo9FRocket2BattleText
	text_end
.LoyalistText:
	text_far _SilphCo9FRocket2LoyalistBattleText
	text_end

SilphCo9FRocket2EndBattleText:
	text_far _SilphCo9FRocket2EndBattleText
	text_end

SilphCo9FRocket2AfterBattleText:
	text_far _SilphCo9FRocket2AfterBattleText
	text_end

; Flavor pair: pure dialogue, never a battle (see data/maps/objects/SilphCo9F.asm).
SilphCo9FFlavorRocketText:
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
	text_far _SilphCo9FFlavorRocketText
	text_end
.LoyalistText:
	text_far _SilphCo9FFlavorRocketLoyalistText
	text_end

SilphCo9FFlavorScientistText:
	text_far _SilphCo9FFlavorScientistText
	text_end

; TEAM ROCKET holds this floor. On the hero path they fight you and the SILPH
; staff stay hidden; on the loyalist path they are comrades, so the staff
; defend the building instead. Each pair shares a tile, so exactly one of the
; two is ever shown. Skipped once the boss has fallen -- by then
; SilphCo11FTeamRocketLeavesScript has cleared this floor for good, and
; re-showing anyone here on the next map load would undo that.
SilphCo9FSetFactionObjectsScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	ld hl, .Defenders
	call SilphCo9FHideObjectList
	ld hl, .Rockets
	jp SilphCo9FShowObjectList
.loyalist
	ld hl, .Rockets
	call SilphCo9FHideObjectList
	ld hl, .Defenders
	jp SilphCo9FShowObjectList

.Rockets:
	db TOGGLE_SILPH_CO_9F_1
	db TOGGLE_SILPH_CO_9F_3
	db -1 ; end

.Defenders:
	db TOGGLE_SILPH_CO_9F_DEFENDER1
	db TOGGLE_SILPH_CO_9F_DEFENDER2
	db -1 ; end

SilphCo9FShowObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef ShowObject
	pop hl
	jr SilphCo9FShowObjectList

SilphCo9FHideObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef HideObject
	pop hl
	jr SilphCo9FHideObjectList

SilphCo9FDefender1Text:
	text_asm
	ld hl, SilphCo9TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9FDefender1BattleText:
	text_far _SilphCo9FDefender1BattleText
	text_end

SilphCo9FDefender1EndBattleText:
	text_far _SilphCo9FDefender1EndBattleText
	text_end

SilphCo9FDefender1AfterBattleText:
	text_far _SilphCo9FDefender1AfterBattleText
	text_end

SilphCo9FDefender2Text:
	text_asm
	ld hl, SilphCo9TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9FDefender2BattleText:
	text_far _SilphCo9FDefender2BattleText
	text_end

SilphCo9FDefender2EndBattleText:
	text_far _SilphCo9FDefender2EndBattleText
	text_end

SilphCo9FDefender2AfterBattleText:
	text_far _SilphCo9FDefender2AfterBattleText
	text_end
