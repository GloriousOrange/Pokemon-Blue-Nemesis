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
; one-time difficulty choice, asked here (LCD is on, so the prompts render)
; rather than in the RedsHouse2F map tick where PrintText is unreliable.
; wDifficulty was set to $ff by InitPlayerData2; clear it to 0 first so declining
; both prompts defaults to Normal.
	xor a
	ld [wDifficulty], a
	ld hl, EasyModeText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .askHardMode
	ld a, DIFFICULTY_EASY
	ld [wDifficulty], a
	jr .difficultyChosen
.askHardMode
	ld hl, HardModeText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .difficultyChosen
	ld a, DIFFICULTY_HARD
	ld [wDifficulty], a
.difficultyChosen
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

EasyModeText:
	text "Play on EASY?"

	para "More TRAINER EXP"
	line "and better gifts"
	cont "from MEGAN."
	prompt

HardModeText:
	text "Play on HARD?"

	para "No items allowed"
	line "in battle."

	para "MEGAN gives"
	line "little, and only"
	cont "near the end."
	prompt

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
