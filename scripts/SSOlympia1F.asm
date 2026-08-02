SSOlympia1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympia1FTrainerHeaders
	ld de, SSOlympia1F_ScriptPointers
	ld a, [wSSOlympia1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympia1FCurScript], a
	ret

SSOlympia1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIA1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIA1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIA1F_END_BATTLE

SSOlympia1F_TextPointers:
	def_text_pointers
	dw_const SSOlympia1FWaiterText, TEXT_SSOLYMPIA1F_WAITER
	dw_const SSOlympia1FSailorText, TEXT_SSOLYMPIA1F_SAILOR
	dw_const SSOlympia1FBrockText, TEXT_SSOLYMPIA1F_BROCK
	dw_const SSOlympia1FMistyText, TEXT_SSOLYMPIA1F_MISTY
	dw_const SSOlympia1FYoungsterText, TEXT_SSOLYMPIA1F_YOUNGSTER
	dw_const SSOlympia1FLassText, TEXT_SSOLYMPIA1F_LASS

SSOlympia1FTrainerHeaders:
	def_trainers 4
SSOlympia1FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_1F_TRAINER_0, 3, SSOlympia1FBrockBattleText, SSOlympia1FBrockEndBattleText, SSOlympia1FBrockAfterBattleText
SSOlympia1FTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_1F_TRAINER_1, 3, SSOlympia1FMistyBattleText, SSOlympia1FMistyEndBattleText, SSOlympia1FMistyAfterBattleText
SSOlympia1FTrainerHeader2:
	trainer_in wOlympiaTrainerFlags, 6, 2, SSOlympia1FYoungsterBattleText, SSOlympia1FYoungsterEndBattleText, SSOlympia1FYoungsterAfterBattleText
SSOlympia1FTrainerHeader3:
	trainer_in wOlympiaTrainerFlags, 7, 2, SSOlympia1FLassBattleText, SSOlympia1FLassEndBattleText, SSOlympia1FLassAfterBattleText
	db -1 ; end

SSOlympia1FWaiterText:
	text_far _SSOlympia1FWaiterText
	text_end

SSOlympia1FSailorText:
	text_far _SSOlympia1FSailorText
	text_end

SSOlympia1FBrockText:
	text_asm
	ld hl, SSOlympia1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FMistyText:
	text_asm
	ld hl, SSOlympia1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FBrockBattleText:
	text_far _SSOlympia1FBrockBattleText
	text_end

SSOlympia1FBrockEndBattleText:
	text_far _SSOlympia1FBrockEndBattleText
	text_end

SSOlympia1FBrockAfterBattleText:
	text_far _SSOlympia1FBrockAfterBattleText
	text_end

SSOlympia1FMistyBattleText:
	text_far _SSOlympia1FMistyBattleText
	text_end

SSOlympia1FMistyEndBattleText:
	text_far _SSOlympia1FMistyEndBattleText
	text_end

SSOlympia1FMistyAfterBattleText:
	text_far _SSOlympia1FMistyAfterBattleText
	text_end

SSOlympia1FYoungsterText:
	text_asm
	ld hl, SSOlympia1FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FYoungsterBattleText:
	text_far _SSOlympia1FYoungsterBattleText
	text_end

SSOlympia1FYoungsterEndBattleText:
	text_far _SSOlympia1FYoungsterEndBattleText
	text_end

SSOlympia1FYoungsterAfterBattleText:
	text_far _SSOlympia1FYoungsterAfterBattleText
	text_end

SSOlympia1FLassText:
	text_asm
	ld hl, SSOlympia1FTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FLassBattleText:
	text_far _SSOlympia1FLassBattleText
	text_end

SSOlympia1FLassEndBattleText:
	text_far _SSOlympia1FLassEndBattleText
	text_end

SSOlympia1FLassAfterBattleText:
	text_far _SSOlympia1FLassAfterBattleText
	text_end
