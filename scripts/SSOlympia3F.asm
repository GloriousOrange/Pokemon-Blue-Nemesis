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
	dw_const SSOlympia3FBirdKeeperText, TEXT_SSOLYMPIA3F_BIRDKEEPER
	dw_const SSOlympia3FCooltrainerFText, TEXT_SSOLYMPIA3F_COOLTRAINERF

SSOlympia3FTrainerHeaders:
	def_trainers 0
SSOlympia3FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_3F_TRAINER_0, 3, SSOlympia3FBrunoBattleText, SSOlympia3FBrunoEndBattleText, SSOlympia3FBrunoAfterBattleText
SSOlympia3FTrainerHeader1:
	trainer_in wOlympiaTrainerFlags, 9, 2, SSOlympia3FBirdKeeperBattleText, SSOlympia3FBirdKeeperEndBattleText, SSOlympia3FBirdKeeperAfterBattleText
SSOlympia3FTrainerHeader2:
	trainer_in wOlympiaTrainerFlags, 10, 2, SSOlympia3FCooltrainerFBattleText, SSOlympia3FCooltrainerFEndBattleText, SSOlympia3FCooltrainerFAfterBattleText
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

SSOlympia3FBirdKeeperText:
	text_asm
	ld hl, SSOlympia3FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia3FBirdKeeperBattleText:
	text_far _SSOlympia3FBirdKeeperBattleText
	text_end

SSOlympia3FBirdKeeperEndBattleText:
	text_far _SSOlympia3FBirdKeeperEndBattleText
	text_end

SSOlympia3FBirdKeeperAfterBattleText:
	text_far _SSOlympia3FBirdKeeperAfterBattleText
	text_end

SSOlympia3FCooltrainerFText:
	text_asm
	ld hl, SSOlympia3FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia3FCooltrainerFBattleText:
	text_far _SSOlympia3FCooltrainerFBattleText
	text_end

SSOlympia3FCooltrainerFEndBattleText:
	text_far _SSOlympia3FCooltrainerFEndBattleText
	text_end

SSOlympia3FCooltrainerFAfterBattleText:
	text_far _SSOlympia3FCooltrainerFAfterBattleText
	text_end
