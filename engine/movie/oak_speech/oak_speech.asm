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
; one-time challenge options, asked here (LCD is on, so the prompts render)
; rather than in the RedsHouse2F map tick where PrintText is unreliable.
; wUnusedPlayerDataByte was set to $ff (all bits) by InitPlayerData2; clear it to
; 0 first so both challenges default off, then set a bit per YES answer.
	xor a
	ld [wUnusedPlayerDataByte], a
	ld hl, ChallengeDoubleXpText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .askChallengeNoItems
	ld hl, wUnusedPlayerDataByte
	set BIT_CHALLENGE_DOUBLE_XP, [hl]
.askChallengeNoItems
	ld hl, ChallengeNoItemsText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .challengeOptionsDone
	ld hl, wUnusedPlayerDataByte
	set BIT_CHALLENGE_NO_ITEMS, [hl]
.challengeOptionsDone
	ld hl, wNumBoxItems
	ld a, HP_UP
	ld [wCurItem], a
	ld a, 10
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, PROTEIN
	ld [wCurItem], a
	ld a, 10
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, IRON
	ld [wCurItem], a
	ld a, 10
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, CALCIUM
	ld [wCurItem], a
	ld a, 10
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, CARBOS
	ld [wCurItem], a
	ld a, 10
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, RARE_CANDY
	ld [wCurItem], a
	ld a, 99
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, SUPER_REPEL
	ld [wCurItem], a
	ld a, 99
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TM_THUNDERBOLT
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TM_BODY_SLAM
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TM_HYPER_BEAM
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TM_PSYCHIC_M
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TM_ICE_BEAM
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TM_FIRE_BLAST
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TM_EARTHQUAKE
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld hl, wNumBagItems
	ld a, HM_CUT
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, HM_FLY
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, HM_SURF
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, HM_STRENGTH
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, HM_FLASH
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	ld a, TOWN_MAP
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
	; All 8 badges unlocked from the start
	ld a, $ff
	ld [wObtainedBadges], a
	ld [wBeatGymFlags], a
	; All cities visited — enables full fly destination list
	ld [wTownVisitedFlag], a
	ld [wTownVisitedFlag + 1], a
	; Max money: $99,$99,$99 = 999,999 (BCD)
	ld hl, wPlayerMoney
	ld [hl], $99
	inc hl
	ld [hl], $99
	inc hl
	ld [hl], $99
	; 255 repel steps so wilds are suppressed immediately
	ld a, 255
	ld [wRepelRemainingSteps], a
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

ChallengeDoubleXpText:
	text "CHALLENGE: earn"
	line "DOUBLE EXP from"
	cont "TRAINER battles?"
	prompt

ChallengeNoItemsText:
	text "CHALLENGE: forbid"
	line "ITEMS during"
	cont "battle?"
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
