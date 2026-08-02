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
	dw_const SSOlympia1FRoomsSurgeText, TEXT_SSOLYMPIA1FROOMS_SURGE
	dw_const SSOlympia1FRoomsErikaText, TEXT_SSOLYMPIA1FROOMS_ERIKA
	dw_const SSOlympia1FRoomsKogaText, TEXT_SSOLYMPIA1FROOMS_KOGA

SSOlympia1FRoomsTrainerHeaders:
	def_trainers 7
SSOlympia1FRoomsTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_0, 3, SSOlympia1FRoomsSurgeBattleText, SSOlympia1FRoomsSurgeEndBattleText, SSOlympia1FRoomsSurgeAfterBattleText
SSOlympia1FRoomsTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_1, 3, SSOlympia1FRoomsErikaBattleText, SSOlympia1FRoomsErikaEndBattleText, SSOlympia1FRoomsErikaAfterBattleText
SSOlympia1FRoomsTrainerHeader2:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_2, 3, SSOlympia1FRoomsKogaBattleText, SSOlympia1FRoomsKogaEndBattleText, SSOlympia1FRoomsKogaAfterBattleText
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
SSOlympia1FRoomsSurgeText:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRoomsErikaText:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRoomsKogaText:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd


SSOlympia1FRoomsSurgeBattleText:
	text_far _SSOlympia1FRoomsSurgeBattleText
	text_end

SSOlympia1FRoomsSurgeEndBattleText:
	text_far _SSOlympia1FRoomsSurgeEndBattleText
	text_end

SSOlympia1FRoomsSurgeAfterBattleText:
	text_far _SSOlympia1FRoomsSurgeAfterBattleText
	text_end

SSOlympia1FRoomsErikaBattleText:
	text_far _SSOlympia1FRoomsErikaBattleText
	text_end

SSOlympia1FRoomsErikaEndBattleText:
	text_far _SSOlympia1FRoomsErikaEndBattleText
	text_end

SSOlympia1FRoomsErikaAfterBattleText:
	text_far _SSOlympia1FRoomsErikaAfterBattleText
	text_end

SSOlympia1FRoomsKogaBattleText:
	text_far _SSOlympia1FRoomsKogaBattleText
	text_end

SSOlympia1FRoomsKogaEndBattleText:
	text_far _SSOlympia1FRoomsKogaEndBattleText
	text_end

SSOlympia1FRoomsKogaAfterBattleText:
	text_far _SSOlympia1FRoomsKogaAfterBattleText
	text_end

