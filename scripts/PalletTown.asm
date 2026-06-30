PalletTown_Script:
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr z, .next
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
.next
	call EnableAutoTextBoxDrawing
	ld hl, PalletTown_ScriptPointers
	ld a, [wPalletTownCurScript]
	jp CallFunctionInTable

PalletTown_ScriptPointers:
	def_script_pointers
	dw_const PalletTownDefaultScript,              SCRIPT_PALLETTOWN_DEFAULT
	dw_const PalletTownOakHeyWaitScript,           SCRIPT_PALLETTOWN_OAK_HEY_WAIT
	dw_const PalletTownOakWalksToPlayerScript,     SCRIPT_PALLETTOWN_OAK_WALKS_TO_PLAYER
	dw_const PalletTownOakNotSafeComeWithMeScript, SCRIPT_PALLETTOWN_OAK_NOT_SAFE_COME_WITH_ME
	dw_const PalletTownPlayerFollowsOakScript,     SCRIPT_PALLETTOWN_PLAYER_FOLLOWS_OAK
	dw_const PalletTownDaisyScript,                SCRIPT_PALLETTOWN_DAISY
	dw_const PalletTownNoopScript,                 SCRIPT_PALLETTOWN_NOOP
	dw_const PalletTownBird1DefeatedScript,        SCRIPT_PALLETTOWN_BIRD1_DEFEATED
	dw_const PalletTownBird2DefeatedScript,        SCRIPT_PALLETTOWN_BIRD2_DEFEATED
	dw_const PalletTownBird3DefeatedScript,        SCRIPT_PALLETTOWN_BIRD3_DEFEATED

PalletTownDefaultScript:
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB
	ret nz
	ld a, [wYCoord]
	cp 1 ; is player near north exit?
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ld a, BANK(Music_MeetProfOak)
	ld c, a
	ld a, MUSIC_MEET_PROF_OAK ; "oak appears" music
	call PlayMusic
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_OAK_APPEARED_IN_PALLET

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_HEY_WAIT
	ld [wPalletTownCurScript], a
	ret

PalletTownOakHeyWaitScript:
	xor a
	ld [wOakWalkedToPlayer], a
	ld a, TEXT_PALLETTOWN_OAK
	ldh [hTextID], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TOGGLE_PALLET_TOWN_OAK
	ld [wToggleableObjectIndex], a
	predef ShowObject

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_WALKS_TO_PLAYER
	ld [wPalletTownCurScript], a
	ret

PalletTownOakWalksToPlayerScript:
	ld a, PALLETTOWN_OAK
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	ld a, 1
	ld [wYCoord], a
	ld a, 1
	ldh [hNPCPlayerRelativePosPerspective], a
	ld a, 1
	swap a
	ldh [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ld hl, hNPCPlayerYDistance
	dec [hl]
	predef FindPathToPlayer ; load Oak's movement into wNPCMovementDirections2
	ld de, wNPCMovementDirections2
	ld a, PALLETTOWN_OAK
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_OAK_NOT_SAFE_COME_WITH_ME
	ld [wPalletTownCurScript], a
	ret

PalletTownOakNotSafeComeWithMeScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a ; ld a, SPRITE_FACING_DOWN
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, TRUE
	ld [wOakWalkedToPlayer], a
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_PALLETTOWN_OAK
	ldh [hTextID], a
	call DisplayTextID
; set up movement script that causes the player to follow Oak to his lab
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PALLETTOWN_OAK
	ld [wSpriteIndex], a
	xor a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, 1
	ld [wNPCMovementScriptPointerTableNum], a
	ldh a, [hLoadedROMBank]
	ld [wNPCMovementScriptBank], a

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_PLAYER_FOLLOWS_OAK
	ld [wPalletTownCurScript], a
	ret

PalletTownPlayerFollowsOakScript:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a ; is the movement script over?
	ret nz

	; trigger the next script
	ld a, SCRIPT_PALLETTOWN_DAISY
	ld [wPalletTownCurScript], a
	ret

PalletTownDaisyScript:
	CheckEvent EVENT_DAISY_WALKING
	jr nz, .next
	CheckBothEventsSet EVENT_GOT_TOWN_MAP, EVENT_ENTERED_BLUES_HOUSE, 1
	jr nz, .next
	SetEvent EVENT_DAISY_WALKING
	ld a, TOGGLE_DAISY_SITTING
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_DAISY_WALKING
	ld [wToggleableObjectIndex], a
	predef_jump ShowObject
.next
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	ret z
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
PalletTownNoopScript:
	ret

PalletTown_TextPointers:
	def_text_pointers
	dw_const PalletTownOakText,              TEXT_PALLETTOWN_OAK
	dw_const PalletTownGirlText,             TEXT_PALLETTOWN_GIRL
	dw_const PalletTownFisherText,           TEXT_PALLETTOWN_FISHER
	dw_const PalletTownBird1Text,            TEXT_PALLETTOWN_BIRD1
	dw_const PalletTownBird2Text,            TEXT_PALLETTOWN_BIRD2
	dw_const PalletTownBird3Text,            TEXT_PALLETTOWN_BIRD3
	dw_const PalletTownMachineText,          TEXT_PALLETTOWN_MACHINE
	dw_const PalletTownOaksLabSignText,      TEXT_PALLETTOWN_OAKSLAB_SIGN
	dw_const PalletTownSignText,             TEXT_PALLETTOWN_SIGN
	dw_const PalletTownPlayersHouseSignText, TEXT_PALLETTOWN_PLAYERSHOUSE_SIGN
	dw_const PalletTownRivalsHouseSignText,  TEXT_PALLETTOWN_RIVALSHOUSE_SIGN

PalletTownOakText:
	text_asm
	ld a, [wOakWalkedToPlayer]
	and a
	jr nz, .next
	ld hl, .PlayerThoughtText
	call PrintText
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .HeyWaitDontGoOutText
	jr .done
.next
	ld hl, .ItsUnsafeText
.done
	call PrintText
	jp TextScriptEnd

.PlayerThoughtText:
	text_far _PalletTownPlayerThoughtText
	text_end

.HeyWaitDontGoOutText:
	text_far _PalletTownOakHeyWaitDontGoOutText
	text_asm
	ld c, 10
	call DelayFrames
	xor a
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld [wWhichEmotionBubble], a ; EXCLAMATION_BUBBLE
	predef EmotionBubble
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	jp TextScriptEnd

.ItsUnsafeText:
	text_far _PalletTownOakItsUnsafeText
	text_end

PalletTownGirlText:
	text_far _PalletTownGirlText
	text_end

PalletTownFisherText:
	text_far _PalletTownFisherText
	text_end

PalletTownOaksLabSignText:
	text_far _PalletTownOaksLabSignText
	text_end

PalletTownSignText:
	text_far _PalletTownSignText
	text_end

PalletTownPlayersHouseSignText:
	text_far _PalletTownPlayersHouseSignText
	text_end

PalletTownRivalsHouseSignText:
	text_far _PalletTownRivalsHouseSignText
	text_end

PalletTownPlayerThoughtText:
	text_far _PalletTownPlayerThoughtText
	text_end

; --- speed-test: 3 legendary-bird keeper trainers (beat all 3 -> Tyranis at next PokeCenter) ---
PalletTownBird1DefeatedScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset
	SetEvent EVENT_BEAT_ZAPDOS
.reset
	xor a
	ld [wJoyIgnore], a
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ret

PalletTownBird2DefeatedScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset
	SetEvent EVENT_BEAT_ARTICUNO
.reset
	xor a
	ld [wJoyIgnore], a
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ret

PalletTownBird3DefeatedScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset
	SetEvent EVENT_BEAT_MOLTRES
.reset
	xor a
	ld [wJoyIgnore], a
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ret

PalletTownBird1Text:
	text_asm
	CheckEvent EVENT_BEAT_ZAPDOS
	jr nz, .beaten
	ld hl, PalletTownBirdZapdosText
	ld a, OPP_JUGGLER
	ld b, 9
	ld c, SCRIPT_PALLETTOWN_BIRD1_DEFEATED
	jr PalletTownBirdEngage
.beaten
	ld hl, PalletTownBirdBeatenText
	call PrintText
	jp TextScriptEnd

PalletTownBird2Text:
	text_asm
	CheckEvent EVENT_BEAT_ARTICUNO
	jr nz, .beaten
	ld hl, PalletTownBirdArticunoText
	ld a, OPP_HIKER
	ld b, 15
	ld c, SCRIPT_PALLETTOWN_BIRD2_DEFEATED
	jr PalletTownBirdEngage
.beaten
	ld hl, PalletTownBirdBeatenText
	call PrintText
	jp TextScriptEnd

PalletTownBird3Text:
	text_asm
	CheckEvent EVENT_BEAT_MOLTRES
	jr nz, .beaten
	ld hl, PalletTownBirdMoltresText
	ld a, OPP_POKEMANIAC
	ld b, 8
	ld c, SCRIPT_PALLETTOWN_BIRD3_DEFEATED
	jr PalletTownBirdEngage
.beaten
	ld hl, PalletTownBirdBeatenText
	call PrintText
	jp TextScriptEnd

; hl = pre-battle text, a = OPP class, b = party#, c = defeated map-script id
PalletTownBirdEngage:
	push af
	push bc
	call PrintText
	pop bc
	pop af
	ld [wCurOpponent], a
	ld a, b
	ld [wTrainerNo], a
	ld a, c
	ld [wPalletTownCurScript], a
	ld [wCurMapScript], a
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PalletTownBirdDefeatedText
	ld de, PalletTownBirdVictoryText
	call SaveEndBattleTextPointers
	jp TextScriptEnd

PalletTownBirdZapdosText:
	text_far _PalletTownBirdZapdosText
	text_end
PalletTownBirdArticunoText:
	text_far _PalletTownBirdArticunoText
	text_end
PalletTownBirdMoltresText:
	text_far _PalletTownBirdMoltresText
	text_end
PalletTownBirdDefeatedText:
	text_far _PalletTownBirdDefeatedText
	text_end
PalletTownBirdVictoryText:
	text_far _PalletTownBirdVictoryText
	text_end
PalletTownBirdBeatenText:
	text_far _PalletTownBirdBeatenText
	text_end

; speed-test level machine: arms the LEVEL STONE (cleared on map exit). The real one
; lives in the burned lab, gated on all 6 scientists. Talk -> use a STONE on a POKeMON.
PalletTownMachineText:
	text_asm
	ld hl, wPostGameMisc
	set BIT_LEVEL_MACHINE_READY, [hl]
	ld hl, .text
	call PrintText
	jp TextScriptEnd
.text:
	text_far _PalletTownMachineText
	text_end
