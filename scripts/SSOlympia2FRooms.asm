SSOlympia2FRooms_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympia2FRoomsTrainerHeaders
	ld de, SSOlympia2FRooms_ScriptPointers
	ld a, [wSSOlympia2FRoomsCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympia2FRoomsCurScript], a
	ret

SSOlympia2FRooms_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIA2FROOMS_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIA2FROOMS_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIA2FROOMS_END_BATTLE

SSOlympia2FRooms_TextPointers:
	def_text_pointers
	dw_const PickUpItemText, TEXT_SSOLYMPIA2FROOMS_MAX_ETHER
	dw_const SSOlympia2FRoomsGrampsText, TEXT_SSOLYMPIA2FROOMS_GRAMPS
	dw_const PickUpItemText, TEXT_SSOLYMPIA2FROOMS_RARE_CANDY
	dw_const SSOlympia2FRoomsLittleBoyText, TEXT_SSOLYMPIA2FROOMS_LITTLE_BOY
	dw_const SSOlympia2FRoomsBrunetteGirlText, TEXT_SSOLYMPIA2FROOMS_BRUNETTE_GIRL
	dw_const SSOlympia2FRoomsBeautyText, TEXT_SSOLYMPIA2FROOMS_BEAUTY
	dw_const SSOlympia2FRoomsRocket1Text, TEXT_SSOLYMPIA2FROOMS_ROCKET1
	dw_const SSOlympia2FRoomsRocket2Text, TEXT_SSOLYMPIA2FROOMS_ROCKET2
	dw_const SSOlympia2FRoomsRocket3Text, TEXT_SSOLYMPIA2FROOMS_ROCKET3

SSOlympia2FRoomsTrainerHeaders:
	def_trainers 2
SSOlympia2FRoomsTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_2FROOMS_ROCKET_0, 57, SSOlympia2FRoomsRocket1BattleText, SSOlympia2FRoomsRocket1EndBattleText, SSOlympia2FRoomsRocket1AfterBattleText
SSOlympia2FRoomsTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_2FROOMS_ROCKET_1, 58, SSOlympia2FRoomsRocket2BattleText, SSOlympia2FRoomsRocket2EndBattleText, SSOlympia2FRoomsRocket2AfterBattleText
SSOlympia2FRoomsTrainerHeader2:
	trainer EVENT_BEAT_SS_OLYMPIA_2FROOMS_ROCKET_2, 59, SSOlympia2FRoomsRocket3BattleText, SSOlympia2FRoomsRocket3EndBattleText, SSOlympia2FRoomsRocket3AfterBattleText
	db -1 ; end

SSOlympia2FRoomsGrampsText:
	text_far _SSOlympia2FRoomsGrampsText
	text_end

SSOlympia2FRoomsLittleBoyText:
	text_far _SSOlympia2FRoomsLittleBoyText
	text_end

SSOlympia2FRoomsBrunetteGirlText:
	text_far _SSOlympia2FRoomsBrunetteGirlText
	text_end

SSOlympia2FRoomsBeautyText:
	text_far _SSOlympia2FRoomsBeautyText
	text_end
SSOlympia2FRoomsRocket1Text:
	text_asm
	ld hl, SSOlympia2FRoomsTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FRoomsRocket2Text:
	text_asm
	ld hl, SSOlympia2FRoomsTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia2FRoomsRocket3Text:
	text_asm
	ld hl, SSOlympia2FRoomsTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd


SSOlympia2FRoomsRocket1BattleText:
	text_far _SSOlympia2FRoomsRocket1BattleText
	text_end

SSOlympia2FRoomsRocket1EndBattleText:
	text_far _SSOlympia2FRoomsRocket1EndBattleText
	text_end

SSOlympia2FRoomsRocket1AfterBattleText:
	text_far _SSOlympia2FRoomsRocket1AfterBattleText
	text_end

SSOlympia2FRoomsRocket2BattleText:
	text_far _SSOlympia2FRoomsRocket2BattleText
	text_end

SSOlympia2FRoomsRocket2EndBattleText:
	text_far _SSOlympia2FRoomsRocket2EndBattleText
	text_end

SSOlympia2FRoomsRocket2AfterBattleText:
	text_far _SSOlympia2FRoomsRocket2AfterBattleText
	text_end

SSOlympia2FRoomsRocket3BattleText:
	text_far _SSOlympia2FRoomsRocket3BattleText
	text_end

SSOlympia2FRoomsRocket3EndBattleText:
	text_far _SSOlympia2FRoomsRocket3EndBattleText
	text_end

SSOlympia2FRoomsRocket3AfterBattleText:
	text_far _SSOlympia2FRoomsRocket3AfterBattleText
	text_end

