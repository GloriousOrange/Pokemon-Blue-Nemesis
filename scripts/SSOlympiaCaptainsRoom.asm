SSOlympiaCaptainsRoom_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympiaCaptainsRoomTrainerHeaders
	ld de, SSOlympiaCaptainsRoom_ScriptPointers
	ld a, [wSSOlympiaCaptainsRoomCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympiaCaptainsRoomCurScript], a
	ret

SSOlympiaCaptainsRoom_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIACAPTAINSROOM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIACAPTAINSROOM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIACAPTAINSROOM_END_BATTLE

SSOlympiaCaptainsRoom_TextPointers:
	def_text_pointers
	dw_const SSOlympiaCaptainsRoomRocket1Text, TEXT_SSOLYMPIACAPTAINSROOM_ROCKET1
	dw_const SSOlympiaCaptainsRoomTrashText, TEXT_SSOLYMPIACAPTAINSROOM_TRASH
	dw_const SSOlympiaCaptainsRoomLogbookText, TEXT_SSOLYMPIACAPTAINSROOM_LOGBOOK

SSOlympiaCaptainsRoomTrainerHeaders:
	def_trainers 6
SSOlympiaCaptainsRoomTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_CAPTAINS_ROOM_ROCKET_0, 53, SSOlympiaCaptainsRoomRocket1BattleText, SSOlympiaCaptainsRoomRocket1EndBattleText, SSOlympiaCaptainsRoomRocket1AfterBattleText
	db -1 ; end

SSOlympiaCaptainsRoomTrashText:
	text_far _SSOlympiaCaptainsRoomTrashText
	text_end

SSOlympiaCaptainsRoomLogbookText:
	text_far _SSOlympiaCaptainsRoomLogbookText
	text_end
SSOlympiaCaptainsRoomRocket1Text:
	text_asm
	ld hl, SSOlympiaCaptainsRoomTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd


SSOlympiaCaptainsRoomRocket1BattleText:
	text_far _SSOlympiaCaptainsRoomRocket1BattleText
	text_end

SSOlympiaCaptainsRoomRocket1EndBattleText:
	text_far _SSOlympiaCaptainsRoomRocket1EndBattleText
	text_end

SSOlympiaCaptainsRoomRocket1AfterBattleText:
	text_far _SSOlympiaCaptainsRoomRocket1AfterBattleText
	text_end

