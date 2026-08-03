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
	dw_const IndigoPlateauLobbyRocketMerchantText,   TEXT_INDIGOPLATEAULOBBY_ROCKET_MERCHANT

IndigoPlateauLobbyNurseText:
	script_pokecenter_nurse

IndigoPlateauLobbyCooltrainerFText:
	text_far _IndigoPlateauLobbyCooltrainerFText
	text_end

IndigoPlateauLobbyLinkReceptionistText:
	script_cable_club_receptionist

; TEAM ROCKET's quartermaster, running a back-room stall in the challengers'
; lobby. He only opens the case for players who stayed loyal -- everyone else
; gets brushed off.
;
; This can't use `script_mart`, which is a whole-text opcode (TX_SCRIPT_MART)
; picked up by DisplayTextID before any of this code runs, and it must not jump
; into DisplayPokemartDialogue either: that ends at AfterDisplayingTextID, which
; would abandon the text engine's own stack frame. So it does what
; DisplayPokemartDialogue does, then returns through TextScriptEnd like any
; other text_asm.
IndigoPlateauLobbyRocketMerchantText:
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	ld hl, .OutsiderText
	call PrintText
	jp TextScriptEnd
.loyalist
	ld hl, .LoyalistText
	call PrintText ; stands in for PokemartGreetingText
	ld hl, .MartInventory
	call LoadItemList
	ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
	homecall DisplayPokemartDialogue_
	jp TextScriptEnd
.OutsiderText:
	text_far _IndigoPlateauLobbyRocketMerchantOutsiderText
	text_end
.LoyalistText:
	text_far _IndigoPlateauLobbyRocketMerchantLoyalistText
	text_end
.MartInventory:
; count, then item ids -- the same layout script_mart emits, minus its leading
; opcode byte, since LoadItemList is entered directly here.
	db 9
	db TM_GHOST_BEAM, TM_NIGHT_SHADE, TM_CONFUSE_RAY, TM_FISSURE
	db ULTRA_BALL, FULL_RESTORE, MAX_REVIVE, RARE_CANDY, PP_UP
	db -1 ; end

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
