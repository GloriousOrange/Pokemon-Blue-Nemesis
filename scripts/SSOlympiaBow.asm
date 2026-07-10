SSOlympiaBow_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympiaBowTrainerHeaders
	ld de, SSOlympiaBow_ScriptPointers
	ld a, [wSSOlympiaBowCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympiaBowCurScript], a
	ret

SSOlympiaBow_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIABOW_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIABOW_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIABOW_END_BATTLE

SSOlympiaBow_TextPointers:
	def_text_pointers
	dw_const SSOlympiaBowSuperNerdText, TEXT_SSOLYMPIABOW_SUPER_NERD
	dw_const SSOlympiaBowRivalStubText, TEXT_SSOLYMPIABOW_RIVAL
	dw_const SSOlympiaBowRocket1Text, TEXT_SSOLYMPIABOW_ROCKET1
	dw_const SSOlympiaBowRocket2Text, TEXT_SSOLYMPIABOW_ROCKET2

SSOlympiaBowTrainerHeaders:
	def_trainers 3
SSOlympiaBowTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_BOW_ROCKET_0, 50, SSOlympiaBowRocket1BattleText, SSOlympiaBowRocket1EndBattleText, SSOlympiaBowRocket1AfterBattleText
SSOlympiaBowTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_BOW_ROCKET_1, 51, SSOlympiaBowRocket2BattleText, SSOlympiaBowRocket2EndBattleText, SSOlympiaBowRocket2AfterBattleText
	db -1 ; end

SSOlympiaBowSuperNerdText:
	text_far _SSOlympiaBowSuperNerdText
	text_end

; Placeholder -- replaced by the real bird->rival ambush script in the next build slice.
SSOlympiaBowRivalStubText:
	text_far _SSOlympiaBowRivalStubText
	text_end
SSOlympiaBowRocket1Text:
	text_asm
	ld hl, SSOlympiaBowTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaBowRocket2Text:
	text_asm
	ld hl, SSOlympiaBowTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd


SSOlympiaBowRocket1BattleText:
	text_far _SSOlympiaBowRocket1BattleText
	text_end

SSOlympiaBowRocket1EndBattleText:
	text_far _SSOlympiaBowRocket1EndBattleText
	text_end

SSOlympiaBowRocket1AfterBattleText:
	text_far _SSOlympiaBowRocket1AfterBattleText
	text_end

SSOlympiaBowRocket2BattleText:
	text_far _SSOlympiaBowRocket2BattleText
	text_end

SSOlympiaBowRocket2EndBattleText:
	text_far _SSOlympiaBowRocket2EndBattleText
	text_end

SSOlympiaBowRocket2AfterBattleText:
	text_far _SSOlympiaBowRocket2AfterBattleText
	text_end

