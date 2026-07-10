SSOlympiaB1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympiaB1FTrainerHeaders
	ld de, SSOlympiaB1F_ScriptPointers
	ld a, [wSSOlympiaB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympiaB1FCurScript], a
	ret

SSOlympiaB1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIAB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIAB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIAB1F_END_BATTLE

SSOlympiaB1F_TextPointers:
	def_text_pointers
	dw_const SSOlympiaB1FDetectiveText, TEXT_SSOLYMPIAB1F_DETECTIVE
	dw_const SSOlympiaB1FRocket1Text, TEXT_SSOLYMPIAB1F_ROCKET1
	dw_const SSOlympiaB1FRocket2Text, TEXT_SSOLYMPIAB1F_ROCKET2

SSOlympiaB1FTrainerHeaders:
	def_trainers
SSOlympiaB1FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_B1F_ROCKET_0, 48, SSOlympiaB1FRocket1BattleText, SSOlympiaB1FRocket1EndBattleText, SSOlympiaB1FRocket1AfterBattleText
SSOlympiaB1FTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_B1F_ROCKET_1, 49, SSOlympiaB1FRocket2BattleText, SSOlympiaB1FRocket2EndBattleText, SSOlympiaB1FRocket2AfterBattleText
	db -1 ; end

SSOlympiaB1FDetectiveText:
	text_far _SSOlympiaB1FDetectiveText
	text_end
SSOlympiaB1FRocket1Text:
	text_asm
	ld hl, SSOlympiaB1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaB1FRocket2Text:
	text_asm
	ld hl, SSOlympiaB1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd


SSOlympiaB1FRocket1BattleText:
	text_far _SSOlympiaB1FRocket1BattleText
	text_end

SSOlympiaB1FRocket1EndBattleText:
	text_far _SSOlympiaB1FRocket1EndBattleText
	text_end

SSOlympiaB1FRocket1AfterBattleText:
	text_far _SSOlympiaB1FRocket1AfterBattleText
	text_end

SSOlympiaB1FRocket2BattleText:
	text_far _SSOlympiaB1FRocket2BattleText
	text_end

SSOlympiaB1FRocket2EndBattleText:
	text_far _SSOlympiaB1FRocket2EndBattleText
	text_end

SSOlympiaB1FRocket2AfterBattleText:
	text_far _SSOlympiaB1FRocket2AfterBattleText
	text_end

