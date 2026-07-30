IndigoPlateauLobby_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ld hl, IndigoPlateauLobbyTrainerHeaders
	ld de, IndigoPlateauLobby_ScriptPointers
	ld a, [wMeganSparCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMeganSparCurScript], a
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	ret z
	ResetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	; Reset Elite Four events if the player started challenging them before
	ld hl, wElite4Flags
	bit BIT_STARTED_ELITE_4, [hl]
	res BIT_STARTED_ELITE_4, [hl]
	ret z
	ResetEventRange INDIGO_PLATEAU_EVENTS_START, EVENT_LANCES_ROOM_LOCK_DOOR
	ret

IndigoPlateauLobby_ScriptPointers:
	def_script_pointers
	dw_const IndigoPlateauLobbyDefaultScript, SCRIPT_INDIGOPLATEAULOBBY_DEFAULT
	dw_const IndigoPlateauLobbyMeganTrained,  SCRIPT_INDIGOPLATEAULOBBY_MEGAN_TRAINED

IndigoPlateauLobbyTrainerHeaders:
	def_trainers
	db -1 ; nobody here fights on sight; Megan is engaged from her own text

IndigoPlateauLobbyDefaultScript:
	ret

; Aftermath of Megan's optional sparring match. Losing leaves her flag clear so
; she will spar again, the same way a lost gym leader fight can be retried.
IndigoPlateauLobbyMeganTrained:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset
	ld a, MEGAN_LOC_INDIGO_LOBBY
	ld [wMeganLocIndex], a
	farcall MeganMarkTrained
.reset
	xor a
	ld [wJoyIgnore], a
	ld [wMeganSparCurScript], a
	ld [wCurMapScript], a
	ret

IndigoPlateauLobby_TextPointers:
	def_text_pointers
	dw_const IndigoPlateauLobbyNurseText,            TEXT_INDIGOPLATEAULOBBY_NURSE
	dw_const IndigoPlateauLobbyMeganText,            TEXT_INDIGOPLATEAULOBBY_MEGAN
	dw_const IndigoPlateauLobbyCooltrainerFText,     TEXT_INDIGOPLATEAULOBBY_COOLTRAINER_F
	dw_const IndigoPlateauLobbyClerkText,            TEXT_INDIGOPLATEAULOBBY_CLERK
	dw_const IndigoPlateauLobbyLinkReceptionistText, TEXT_INDIGOPLATEAULOBBY_LINK_RECEPTIONIST

IndigoPlateauLobbyNurseText:
	script_pokecenter_nurse

IndigoPlateauLobbyCooltrainerFText:
	text_far _IndigoPlateauLobbyCooltrainerFText
	text_end

IndigoPlateauLobbyLinkReceptionistText:
	script_cable_club_receptionist

; She heals here like everywhere else, and offers one last sparring match
; (Slowbro L70) before the Elite Four. Always optional.
IndigoPlateauLobbyMeganText:
	text_asm
	ld a, MEGAN_LOC_INDIGO_LOBBY
	ld [wMeganLocIndex], a
	farcall MeganSparOffer
	jr nc, .done
	ld a, SCRIPT_INDIGOPLATEAULOBBY_MEGAN_TRAINED
	ld [wMeganSparCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd
