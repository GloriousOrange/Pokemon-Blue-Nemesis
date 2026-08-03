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
	dw_const SSOlympiaB1FAgathaText, TEXT_SSOLYMPIAB1F_AGATHA
	dw_const SSOlympiaB1FLanceText, TEXT_SSOLYMPIAB1F_LANCE
	dw_const SSOlympiaB1FHikerText, TEXT_SSOLYMPIAB1F_HIKER
	dw_const SSOlympiaB1FBurglarText, TEXT_SSOLYMPIAB1F_BURGLAR

SSOlympiaB1FTrainerHeaders:
	def_trainers
SSOlympiaB1FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_B1F_TRAINER_0, 3, SSOlympiaB1FAgathaBattleText, SSOlympiaB1FAgathaEndBattleText, SSOlympiaB1FAgathaAfterBattleText
SSOlympiaB1FTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_B1F_TRAINER_1, 3, SSOlympiaB1FLanceBattleText, SSOlympiaB1FLanceEndBattleText, SSOlympiaB1FLanceAfterBattleText
SSOlympiaB1FTrainerHeader2:
	trainer_in wOlympiaTrainerFlags, 11, 2, SSOlympiaB1FHikerBattleText, SSOlympiaB1FHikerEndBattleText, SSOlympiaB1FHikerAfterBattleText
SSOlympiaB1FTrainerHeader3:
	trainer_in wOlympiaTrainerFlags, 12, 2, SSOlympiaB1FBurglarBattleText, SSOlympiaB1FBurglarEndBattleText, SSOlympiaB1FBurglarAfterBattleText
	db -1 ; end

SSOlympiaB1FDetectiveText:
	text_far _SSOlympiaB1FDetectiveText
	text_end
SSOlympiaB1FAgathaText:
	text_asm
	ld hl, SSOlympiaB1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaB1FLanceText:
	text_asm
	ld hl, SSOlympiaB1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd


SSOlympiaB1FAgathaBattleText:
	text_far _SSOlympiaB1FAgathaBattleText
	text_end

SSOlympiaB1FAgathaEndBattleText:
	text_far _SSOlympiaB1FAgathaEndBattleText
	text_end

SSOlympiaB1FAgathaAfterBattleText:
	text_far _SSOlympiaB1FAgathaAfterBattleText
	text_end

SSOlympiaB1FLanceBattleText:
	text_far _SSOlympiaB1FLanceBattleText
	text_end

SSOlympiaB1FLanceEndBattleText:
	text_far _SSOlympiaB1FLanceEndBattleText
	text_end

SSOlympiaB1FLanceAfterBattleText:
	text_far _SSOlympiaB1FLanceAfterBattleText
	text_end

SSOlympiaB1FHikerText:
	text_asm
	ld hl, SSOlympiaB1FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaB1FHikerBattleText:
	text_far _SSOlympiaB1FHikerBattleText
	text_end

SSOlympiaB1FHikerEndBattleText:
	text_far _SSOlympiaB1FHikerEndBattleText
	text_end

SSOlympiaB1FHikerAfterBattleText:
	text_far _SSOlympiaB1FHikerAfterBattleText
	text_end

SSOlympiaB1FBurglarText:
	text_asm
	ld hl, SSOlympiaB1FTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaB1FBurglarBattleText:
	text_far _SSOlympiaB1FBurglarBattleText
	text_end

SSOlympiaB1FBurglarEndBattleText:
	text_far _SSOlympiaB1FBurglarEndBattleText
	text_end

SSOlympiaB1FBurglarAfterBattleText:
	text_far _SSOlympiaB1FBurglarAfterBattleText
	text_end
