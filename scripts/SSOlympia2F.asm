SSOlympia2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympia2FTrainerHeaders
	ld de, SSOlympia2F_ScriptPointers
	ld a, [wSSOlympia2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympia2FCurScript], a
	ret

SSOlympia2F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIA2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIA2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIA2F_END_BATTLE

SSOlympia2F_TextPointers:
	def_text_pointers
	dw_const SSOlympia2FWaiterText, TEXT_SSOLYMPIA2F_WAITER
	dw_const SSOlympia2FRocket1Text, TEXT_SSOLYMPIA2F_ROCKET1
	dw_const SSOlympia2FRocket2Text, TEXT_SSOLYMPIA2F_ROCKET2

SSOlympia2FTrainerHeaders:
	def_trainers 6
SSOlympia2FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_2F_ROCKET_0, 45, SSOlympia2FRocket1BattleText, SSOlympia2FRocket1EndBattleText, SSOlympia2FRocket1AfterBattleText
SSOlympia2FTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_2F_ROCKET_1, 46, SSOlympia2FRocket2BattleText, SSOlympia2FRocket2EndBattleText, SSOlympia2FRocket2AfterBattleText
	db -1 ; end

SSOlympia2FWaiterText:
	text_far _SSOlympia2FWaiterText
	text_end

SSOlympia2FRocket1Text:
	text_asm
	ld hl, SSOlympia2FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FRocket2Text:
	text_asm
	ld hl, SSOlympia2FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FRocket1BattleText:
	text_far _SSOlympia2FRocket1BattleText
	text_end

SSOlympia2FRocket1EndBattleText:
	text_far _SSOlympia2FRocket1EndBattleText
	text_end

SSOlympia2FRocket1AfterBattleText:
	text_far _SSOlympia2FRocket1AfterBattleText
	text_end

SSOlympia2FRocket2BattleText:
	text_far _SSOlympia2FRocket2BattleText
	text_end

SSOlympia2FRocket2EndBattleText:
	text_far _SSOlympia2FRocket2EndBattleText
	text_end

SSOlympia2FRocket2AfterBattleText:
	text_far _SSOlympia2FRocket2AfterBattleText
	text_end
