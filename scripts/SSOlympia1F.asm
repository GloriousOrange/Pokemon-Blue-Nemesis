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
	dw_const SSOlympia1FRocket1Text, TEXT_SSOLYMPIA1F_ROCKET1
	dw_const SSOlympia1FRocket2Text, TEXT_SSOLYMPIA1F_ROCKET2

SSOlympia1FTrainerHeaders:
	def_trainers 4
SSOlympia1FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_1F_ROCKET_0, 3, SSOlympia1FRocket1BattleText, SSOlympia1FRocket1EndBattleText, SSOlympia1FRocket1AfterBattleText
SSOlympia1FTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_1F_ROCKET_1, 3, SSOlympia1FRocket2BattleText, SSOlympia1FRocket2EndBattleText, SSOlympia1FRocket2AfterBattleText
	db -1 ; end

SSOlympia1FWaiterText:
	text_far _SSOlympia1FWaiterText
	text_end

SSOlympia1FSailorText:
	text_far _SSOlympia1FSailorText
	text_end

SSOlympia1FRocket1Text:
	text_asm
	ld hl, SSOlympia1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRocket2Text:
	text_asm
	ld hl, SSOlympia1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRocket1BattleText:
	text_far _SSOlympia1FRocket1BattleText
	text_end

SSOlympia1FRocket1EndBattleText:
	text_far _SSOlympia1FRocket1EndBattleText
	text_end

SSOlympia1FRocket1AfterBattleText:
	text_far _SSOlympia1FRocket1AfterBattleText
	text_end

SSOlympia1FRocket2BattleText:
	text_far _SSOlympia1FRocket2BattleText
	text_end

SSOlympia1FRocket2EndBattleText:
	text_far _SSOlympia1FRocket2EndBattleText
	text_end

SSOlympia1FRocket2AfterBattleText:
	text_far _SSOlympia1FRocket2AfterBattleText
	text_end
