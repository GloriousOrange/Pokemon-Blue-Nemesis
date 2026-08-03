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
	dw_const SSOlympia2FSabrinaText, TEXT_SSOLYMPIA2F_SABRINA
	dw_const SSOlympia2FBlaineText, TEXT_SSOLYMPIA2F_BLAINE
	dw_const SSOlympia2FBikerText, TEXT_SSOLYMPIA2F_BIKER
	dw_const SSOlympia2FCueBallText, TEXT_SSOLYMPIA2F_CUEBALL

SSOlympia2FTrainerHeaders:
	def_trainers 6
SSOlympia2FTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_2F_TRAINER_0, 3, SSOlympia2FSabrinaBattleText, SSOlympia2FSabrinaEndBattleText, SSOlympia2FSabrinaAfterBattleText
SSOlympia2FTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_2F_TRAINER_1, 3, SSOlympia2FBlaineBattleText, SSOlympia2FBlaineEndBattleText, SSOlympia2FBlaineAfterBattleText
SSOlympia2FTrainerHeader2:
	trainer_in wOlympiaTrainerFlags, 0, 2, SSOlympia2FBikerBattleText, SSOlympia2FBikerEndBattleText, SSOlympia2FBikerAfterBattleText
SSOlympia2FTrainerHeader3:
	trainer_in wOlympiaTrainerFlags, 1, 2, SSOlympia2FCueBallBattleText, SSOlympia2FCueBallEndBattleText, SSOlympia2FCueBallAfterBattleText
	db -1 ; end

SSOlympia2FWaiterText:
	text_far _SSOlympia2FWaiterText
	text_end

SSOlympia2FSabrinaText:
	text_asm
	ld hl, SSOlympia2FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FBlaineText:
	text_asm
	ld hl, SSOlympia2FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FSabrinaBattleText:
	text_far _SSOlympia2FSabrinaBattleText
	text_end

SSOlympia2FSabrinaEndBattleText:
	text_far _SSOlympia2FSabrinaEndBattleText
	text_end

SSOlympia2FSabrinaAfterBattleText:
	text_far _SSOlympia2FSabrinaAfterBattleText
	text_end

SSOlympia2FBlaineBattleText:
	text_far _SSOlympia2FBlaineBattleText
	text_end

SSOlympia2FBlaineEndBattleText:
	text_far _SSOlympia2FBlaineEndBattleText
	text_end

SSOlympia2FBlaineAfterBattleText:
	text_far _SSOlympia2FBlaineAfterBattleText
	text_end

SSOlympia2FBikerText:
	text_asm
	ld hl, SSOlympia2FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FBikerBattleText:
	text_far _SSOlympia2FBikerBattleText
	text_end

SSOlympia2FBikerEndBattleText:
	text_far _SSOlympia2FBikerEndBattleText
	text_end

SSOlympia2FBikerAfterBattleText:
	text_far _SSOlympia2FBikerAfterBattleText
	text_end

SSOlympia2FCueBallText:
	text_asm
	ld hl, SSOlympia2FTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FCueBallBattleText:
	text_far _SSOlympia2FCueBallBattleText
	text_end

SSOlympia2FCueBallEndBattleText:
	text_far _SSOlympia2FCueBallEndBattleText
	text_end

SSOlympia2FCueBallAfterBattleText:
	text_far _SSOlympia2FCueBallAfterBattleText
	text_end
