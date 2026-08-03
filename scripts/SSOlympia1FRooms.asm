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
	dw_const SSOlympia1FRoomsMeganTrained,          SCRIPT_SSOLYMPIA1FROOMS_MEGAN_TRAINED

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
	dw_const SSOlympia1FRoomsJrTrainerMText, TEXT_SSOLYMPIA1FROOMS_JRTRAINERM
	dw_const SSOlympia1FRoomsJrTrainerFText, TEXT_SSOLYMPIA1FROOMS_JRTRAINERF
	dw_const SSOlympia1FRoomsMeganText, TEXT_SSOLYMPIA1FROOMS_MEGAN

SSOlympia1FRoomsTrainerHeaders:
	def_trainers 7
SSOlympia1FRoomsTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_0, 3, SSOlympia1FRoomsSurgeBattleText, SSOlympia1FRoomsSurgeEndBattleText, SSOlympia1FRoomsSurgeAfterBattleText
SSOlympia1FRoomsTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_1, 3, SSOlympia1FRoomsErikaBattleText, SSOlympia1FRoomsErikaEndBattleText, SSOlympia1FRoomsErikaAfterBattleText
SSOlympia1FRoomsTrainerHeader2:
	trainer EVENT_BEAT_SS_OLYMPIA_1FROOMS_TRAINER_2, 3, SSOlympia1FRoomsKogaBattleText, SSOlympia1FRoomsKogaEndBattleText, SSOlympia1FRoomsKogaAfterBattleText
SSOlympia1FRoomsTrainerHeader3:
	trainer_in wOlympiaTrainerFlags, 2, 2, SSOlympia1FRoomsJrTrainerMBattleText, SSOlympia1FRoomsJrTrainerMEndBattleText, SSOlympia1FRoomsJrTrainerMAfterBattleText
SSOlympia1FRoomsTrainerHeader4:
	trainer_in wOlympiaTrainerFlags, 3, 2, SSOlympia1FRoomsJrTrainerFBattleText, SSOlympia1FRoomsJrTrainerFEndBattleText, SSOlympia1FRoomsJrTrainerFAfterBattleText
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

SSOlympia1FRoomsJrTrainerMText:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRoomsJrTrainerMBattleText:
	text_far _SSOlympia1FRoomsJrTrainerMBattleText
	text_end

SSOlympia1FRoomsJrTrainerMEndBattleText:
	text_far _SSOlympia1FRoomsJrTrainerMEndBattleText
	text_end

SSOlympia1FRoomsJrTrainerMAfterBattleText:
	text_far _SSOlympia1FRoomsJrTrainerMAfterBattleText
	text_end

SSOlympia1FRoomsJrTrainerFText:
	text_asm
	ld hl, SSOlympia1FRoomsTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

SSOlympia1FRoomsJrTrainerFBattleText:
	text_far _SSOlympia1FRoomsJrTrainerFBattleText
	text_end

SSOlympia1FRoomsJrTrainerFEndBattleText:
	text_far _SSOlympia1FRoomsJrTrainerFEndBattleText
	text_end

SSOlympia1FRoomsJrTrainerFAfterBattleText:
	text_far _SSOlympia1FRoomsJrTrainerFAfterBattleText
	text_end

; MEGAN's cabin. Same shared sparring machinery as her gym stops: MeganSparOffer
; prints the offer, arms the battle and returns carry set, or just heals and
; returns carry clear.
SSOlympia1FRoomsMeganText:
	text_asm
; Blacking out aboard must not dump the player back at a mainland POKeMON
; CENTER -- they wake up here. wLastBlackoutMap is written directly rather than
; through SetLastBlackoutMap, which stores wLastMap (the deck outside) instead
; of the cabin itself. SS_OLYMPIA_1F_ROOMS has its own FlyWarpDataPtr entry so
; the blackout path can find landing coordinates for it.
	ld a, SS_OLYMPIA_1F_ROOMS
	ld [wLastBlackoutMap], a
	ld a, MEGAN_LOC_SS_OLYMPIA
	ld [wMeganLocIndex], a
	farcall MeganSparOffer
	jr nc, .done
	ld a, SCRIPT_SSOLYMPIA1FROOMS_MEGAN_TRAINED
	ld [wSSOlympia1FRoomsCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

SSOlympia1FRoomsMeganTrained:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset
	ld a, MEGAN_LOC_SS_OLYMPIA
	ld [wMeganLocIndex], a
	farcall MeganMarkTrained
.reset
	xor a
	ld [wJoyIgnore], a
	ld [wSSOlympia1FRoomsCurScript], a
	ld [wCurMapScript], a
	ret
