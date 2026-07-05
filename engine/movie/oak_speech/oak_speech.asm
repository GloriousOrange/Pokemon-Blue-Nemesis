PrepareOakSpeech:
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, [wOptions]
	push af
	; Retrieve BIT_DEBUG_MODE set in DebugMenu for StartNewGameDebug.
	; BUG: StartNewGame carries over BIT_ALWAYS_ON_BIKE from previous save files,
	; which causes CheckForceBikeOrSurf to not return.
	; To fix this in debug builds, reset BIT_ALWAYS_ON_BIKE here or in StartNewGame.
	; In non-debug builds, the instructions can be removed.
	ld a, [wStatusFlags6]
	push af
	ld hl, wPlayerName
	ld bc, wBoxDataEnd - wPlayerName
	xor a
	call FillMemory
	ld hl, wSpriteDataStart
	ld bc, wSpriteDataEnd - wSpriteDataStart
	xor a
	call FillMemory
	pop af
	ld [wStatusFlags6], a
	pop af
	ld [wOptions], a
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld a, [wOptionsInitialized]
	and a
	call z, InitOptions
	; These debug names are used for StartNewGameDebug.
	; TestBattle uses the debug names from DebugMenu.
	; A variant of this process is performed in PrepareTitleScreen.
	ld hl, DebugNewGamePlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, DebugNewGameRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	jp CopyData

OakSpeech:
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ld a, BANK(Music_Routes2)
	ld c, a
	ld a, MUSIC_ROUTES2
	call PlayMusic
	call ClearScreen
	call LoadTextBoxTilePatterns
	call PrepareOakSpeech
	predef InitPlayerData2
; minimal intro naming: ask the player's name, then their brother's (the rival).
; No preset-name menu, no pics, no speech. Empty entries are re-asked.
.askPlayerName
	ld hl, wPlayerName
	xor a ; NAME_PLAYER_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	ld a, [wStringBuffer]
	cp '@' ; empty name?
	jr z, .askPlayerName
.askBrotherName
	ld hl, wRivalName
	ld a, NAME_RIVAL_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	ld a, [wStringBuffer]
	cp '@' ; empty name?
	jr z, .askBrotherName
	call ClearScreen
; one-time difficulty choice, asked here (LCD is on, so the menu renders)
; rather than in the RedsHouse2F map tick where PrintText is unreliable.
	call DifficultyMenu_Draw
	call HandleMenuInput
	ld a, [wCurrentMenuItem]
	ld e, a
	ld d, 0
	ld hl, DifficultyMenuValues
	add hl, de
	ld a, [hl]
	ld [wDifficulty], a
	call ClearScreen
	ld hl, OpeningColdOpenText ; a cold, dark mood-setter before the game world fades in
	call PrintText
	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call PrepareForSpecialWarp
	xor a
	ldh [hTileAnimations], a
.skipSpeech
	call ResetPlayerSpriteData
	call LoadTextBoxTilePatterns
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	call GBFadeOutToWhite
	jp ClearScreen

; draws a 3-item EASY/NORMAL/HARD selection box and sets up HandleMenuInput.
; No B in wMenuWatchedKeys -- a difficulty must be chosen, no cancelling out.
DifficultyMenu_Draw:
	hlcoord 0, 0
	ld b, 3
	ld c, 6
	call TextBoxBorder
	hlcoord 2, 1
	ld de, DifficultyEasyName
	call PlaceString
	hlcoord 2, 2
	ld de, DifficultyNormalName
	call PlaceString
	hlcoord 2, 3
	ld de, DifficultyHardName
	call PlaceString
	ld a, 1
	ld [wTopMenuItemY], a
	ld [wTopMenuItemX], a
	ld a, 1 ; default cursor on NORMAL
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, 2 ; highest index: EASY=0, NORMAL=1, HARD=2
	ld [wMaxMenuItem], a
	ld a, PAD_A
	ld [wMenuWatchedKeys], a
	ldh a, [hUILayoutFlags]
	set BIT_DOUBLE_SPACED_MENU, a ; rows are 1 tile apart (this flag is inverted: SET = single-spaced)
	ldh [hUILayoutFlags], a
	ret

; wCurrentMenuItem (0/1/2, EASY/NORMAL/HARD menu order) -> DIFFICULTY_* value
DifficultyMenuValues:
	db DIFFICULTY_EASY, DIFFICULTY_NORMAL, DIFFICULTY_HARD

DifficultyEasyName:
	db "EASY@"
DifficultyNormalName:
	db "NORMAL@"
DifficultyHardName:
	db "HARD@"

OpeningColdOpenText:
	text "The war nearly"
	line "ended us all."

	para "Now we huddle"
	line "behind walls, and"
	cont "the monsters own"
	cont "the dark."

	para "Your father went"
	line "out to make us"
	cont "safe. He did not"
	cont "come home."

	para "PROF.OAK has not"
	line "forgotten his"
	cont "name...nor the"
	cont "ones who took him."
	prompt

OakSpeechText1:
	text_far _OakSpeechText1
	text_end

OakSpeechText2:
	text_far _OakSpeechText2A
	; BUG: The cry played does not match the sprite displayed.
	sound_cry_nidorina
	text_far _OakSpeechText2B
	text_end

IntroducePlayerText:
	text_far _IntroducePlayerText
	text_end

IntroduceRivalText:
	text_far _IntroduceRivalText
	text_end

OakSpeechText3:
	text_far _OakSpeechText3
	text_end

FadeInIntroPic:
	ld hl, IntroFadePalettes
	ld b, 6
.next
	ld a, [hli]
	ldh [rBGP], a
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .next
	ret

IntroFadePalettes:
	dc 1, 1, 1, 0
	dc 2, 2, 2, 0
	dc 3, 3, 3, 0
	dc 3, 3, 2, 0
	dc 3, 3, 1, 0
	dc 3, 2, 1, 0

MovePicLeft:
	ld a, 119
	ldh [rWX], a
	call DelayFrame

	ld a, %11100100
	ldh [rBGP], a
.next
	call DelayFrame
	ldh a, [rWX]
	sub 8
	cp $FF
	ret z
	ldh [rWX], a
	jr .next

DisplayPicCenteredOrUpperRight:
	call GetPredefRegisters
IntroDisplayPicCenteredOrUpperRight:
; b = bank
; de = address of compressed pic
; c: 0 = centred, non-zero = upper-right
	push bc
	ld a, b
	call UncompressSpriteFromDE
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, 2 * SPRITEBUFFERSIZE
	call CopyData
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	pop bc
	ld a, c
	and a
	hlcoord 15, 1
	jr nz, .next
	hlcoord 6, 4
.next
	xor a
	ldh [hStartTileID], a
	predef_jump CopyUncompressedPicToTilemap
