SSOlympia3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympia3FTrainerHeaders
	ld de, SSOlympia3F_ScriptPointers
	ld a, [wSSOlympia3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympia3FCurScript], a
	ret

SSOlympia3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIA3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIA3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIA3F_END_BATTLE

SSOlympia3F_TextPointers:
	def_text_pointers
	dw_const SSOlympia3FSailorText, TEXT_SSOLYMPIA3F_SAILOR
	dw_const SSOlympia3FBrunoText, TEXT_SSOLYMPIA3F_BRUNO

SSOlympia3FTrainerHeaders:
	def_trainers 0
SSOlympia3FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_3F_TRAINER_0, 3, SSOlympia3FBrunoBattleText, SSOlympia3FBrunoEndBattleText, SSOlympia3FBrunoAfterBattleText
	db -1 ; end

SSOlympia3FSailorText:
	text_far _SSOlympia3FSailorText
	text_end
SSOlympia3FBrunoText:
	text_asm
	ld hl, SSOlympia3FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd


SSOlympia3FBrunoBattleText:
	text_far _SSOlympia3FBrunoBattleText
	text_end

SSOlympia3FBrunoEndBattleText:
	text_far _SSOlympia3FBrunoEndBattleText
	text_end

SSOlympia3FBrunoAfterBattleText:
	text_far _SSOlympia3FBrunoAfterBattleText
	text_end

