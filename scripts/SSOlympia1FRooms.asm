SSOlympia1FRooms_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympia1FRoomsTrainerHeaders
	ld de, SSOlympia1FRooms_ScriptPointers
	ld a, [wSSOlympia1FRoomsCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympia1FRoomsCurScript], a
	ret

SSOlympia1FRooms_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIA1FROOMS_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIA1FROOMS_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIA1FROOMS_END_BATTLE

SSOlympia1FRooms_TextPointers:
	def_text_pointers
	dw_const SSOlympia1FRoomsGirl1Text, TEXT_SSOLYMPIA1FROOMS_GIRL1
	dw_const SSOlympia1FRoomsMiddleAgedManText, TEXT_SSOLYMPIA1FROOMS_MIDDLE_AGED_MAN
	dw_const SSOlympia1FRoomsLittleGirlText, TEXT_SSOLYMPIA1FROOMS_LITTLE_GIRL
	dw_const SSOlympia1FRoomsWigglytuffText, TEXT_SSOLYMPIA1FROOMS_WIGGLYTUFF
	dw_const SSOlympia1FRoomsGirl2Text, TEXT_SSOLYMPIA1FROOMS_GIRL2
	dw_const PickUpItemText, TEXT_SSOLYMPIA1FROOMS_TM_BODY_SLAM
	dw_const SSOlympia1FRoomsGentleman3Text, TEXT_SSOLYMPIA1FROOMS_GENTLEMAN3
	dw_const SSOlympia1FRoomsRocket1Text, TEXT_SSOLYMPIA1FROOMS_ROCKET1
	dw_const SSOlympia1FRoomsRocket2Text, TEXT_SSOLYMPIA1FROOMS_ROCKET2
	dw_const SSOlympia1FRoomsRocket3Text, TEXT_SSOLYMPIA1FROOMS_ROCKET3

SSOlympia1FRoomsTrainerHeaders:
	def_trainers 7
SSOlympia1FRoomsTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_ROCKET_0, 54, SSOlympia1FRoomsRocket1BattleText, SSOlympia1FRoomsRocket1EndBattleText, SSOlympia1FRoomsRocket1AfterBattleText
SSOlympia1FRoomsTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_ROCKET_1, 55, SSOlympia1FRoomsRocket2BattleText, SSOlympia1FRoomsRocket2EndBattleText, SSOlympia1FRoomsRocket2AfterBattleText
SSOlympia1FRoomsTrainerHeader2:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_ROCKET_2, 56, SSOlympia1FRoomsRocket3BattleText, SSOlympia1FRoomsRocket3EndBattleText, SSOlympia1FRoomsRocket3AfterBattleText
	db -1 ; end

SSOlympia1FRoomsGirl1Text:
	text_far _SSOlympia1FRoomsGirl1Text
	text_end

SSOlympia1FRoomsMiddleAgedManText:
	text_far _SSOlympia1FRoomsMiddleAgedManText
	text_end

SSOlympia1FRoomsLittleGirlText:
	text_far _SSOlympia1FRoomsLittleGirlText
	text_end

SSOlympia1FRoomsWigglytuffText:
	text_far _SSOlympia1FRoomsWigglytuffText
	text_asm
	ld a, WIGGLYTUFF
	call PlayCry
	jp TextScriptEnd

SSOlympia1FRoomsGirl2Text:
	text_far _SSOlympia1FRoomsGirl2Text
	text_end

SSOlympia1FRoomsGentleman3Text:
	text_far _SSOlympia1FRoomsGentleman3Text
	text_end
SSOlympia1FRoomsRocket1Text:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRoomsRocket2Text:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRoomsRocket3Text:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd


SSOlympia1FRoomsRocket1BattleText:
	text_far _SSOlympia1FRoomsRocket1BattleText
	text_end

SSOlympia1FRoomsRocket1EndBattleText:
	text_far _SSOlympia1FRoomsRocket1EndBattleText
	text_end

SSOlympia1FRoomsRocket1AfterBattleText:
	text_far _SSOlympia1FRoomsRocket1AfterBattleText
	text_end

SSOlympia1FRoomsRocket2BattleText:
	text_far _SSOlympia1FRoomsRocket2BattleText
	text_end

SSOlympia1FRoomsRocket2EndBattleText:
	text_far _SSOlympia1FRoomsRocket2EndBattleText
	text_end

SSOlympia1FRoomsRocket2AfterBattleText:
	text_far _SSOlympia1FRoomsRocket2AfterBattleText
	text_end

SSOlympia1FRoomsRocket3BattleText:
	text_far _SSOlympia1FRoomsRocket3BattleText
	text_end

SSOlympia1FRoomsRocket3EndBattleText:
	text_far _SSOlympia1FRoomsRocket3EndBattleText
	text_end

SSOlympia1FRoomsRocket3AfterBattleText:
	text_far _SSOlympia1FRoomsRocket3AfterBattleText
	text_end

