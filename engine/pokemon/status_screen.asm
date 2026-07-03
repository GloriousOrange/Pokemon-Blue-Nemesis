DrawHP:
; Draws the HP bar in the stats screen
	call GetPredefRegisters
	ld a, $1
	jr DrawHP_

DrawHP2:
; Draws the HP bar in the party screen
	call GetPredefRegisters
	ld a, $2

DrawHP_:
	ld [wHPBarType], a
	push hl
	ld a, [wLoadedMonHP]
	ld b, a
	ld a, [wLoadedMonHP + 1]
	ld c, a
	or b
	jr nz, .nonzeroHP
	xor a
	ld c, a
	ld e, a
	ld a, $6
	ld d, a
	jp .drawHPBarAndPrintFraction
.nonzeroHP
	ld a, [wLoadedMonMaxHP]
	ld d, a
	ld a, [wLoadedMonMaxHP + 1]
	ld e, a
	predef HPBarLength
	ld a, $6
	ld d, a
	ld c, a
.drawHPBarAndPrintFraction
	pop hl
	push de
	push hl
	push hl
	call DrawHPBar
	pop hl
	ldh a, [hUILayoutFlags]
	bit BIT_PARTY_MENU_HP_BAR, a
	jr z, .printFractionBelowBar
	ld bc, $9 ; right of bar
	jr .printFraction
.printFractionBelowBar
	ld bc, SCREEN_WIDTH + 1 ; below bar
.printFraction
	add hl, bc
	ld de, wLoadedMonHP
	lb bc, 2, 3
	call PrintNumber
	ld a, '/'
	ld [hli], a
	ld de, wLoadedMonMaxHP
	lb bc, 2, 3
	call PrintNumber
	pop hl
	pop de
	ret

StatusScreen:
	call LoadMonData
	ld a, [wMonDataLocation]
	cp BOX_DATA
	jr c, .DontRecalculate
; mon is in a box or daycare
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
	ld [wCurEnemyLevel], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats
.DontRecalculate
	ld hl, wStatusFlags2
	set BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $33
	ldh [rAUDVOL], a ; Reduce the volume
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	call LoadHpBarAndStatusTilePatterns
	ld de, BattleHudTiles1  ; source
	ld hl, vChars2 tile $6d ; dest
	lb bc, BANK(BattleHudTiles1), 3
	call CopyVideoDataDouble ; ·│ :L and halfarrow line end
	ld de, BattleHudTiles2
	ld hl, vChars2 tile $78
	lb bc, BANK(BattleHudTiles2), 1
	call CopyVideoDataDouble ; │
	ld de, BattleHudTiles3
	ld hl, vChars2 tile $76
	lb bc, BANK(BattleHudTiles3), 2
	call CopyVideoDataDouble ; ─ ┘
	ld de, PTile
	ld hl, vChars2 tile $72
	lb bc, BANK(PTile), 1
	call CopyVideoDataDouble ; bold P (for PP)
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	hlcoord 19, 1
	lb bc, 6, 10
	call DrawLineBox ; Draws the box around name, HP and status
	ld de, -6
	add hl, de
	ld [hl], '<DOT>'
	dec hl
	ld [hl], '№'
	hlcoord 19, 9
	lb bc, 8, 6
	call DrawLineBox ; Draws the box around types, ID No. and OT
	hlcoord 10, 9
	ld de, TypesIDNoOTText
	call PlaceString
	hlcoord 11, 3
	predef DrawHP
	ld hl, wStatusScreenHPBarColor
	call GetHealthBarColor
	ld b, SET_PAL_STATUS_SCREEN
	call RunPaletteCommand
	hlcoord 16, 6
	ld de, wLoadedMonStatus
	call PrintStatusCondition
	jr nz, .StatusWritten
	hlcoord 16, 6
	ld de, OKText
	call PlaceString ; "OK"
.StatusWritten
	hlcoord 9, 6
	ld de, StatusText
	call PlaceString ; "STATUS/"
	hlcoord 14, 2
	call PrintLevel
	ld a, [wMonHIndex]
	ld [wPokedexNum], a
	ld [wCurSpecies], a
	predef IndexToPokedex
	hlcoord 3, 7
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; Pokémon no.
	hlcoord 11, 10
	predef PrintMonType
	ld hl, NamePointers2
	call .GetStringPointer
	ld d, h
	ld e, l
	hlcoord 9, 1
	call PlaceString ; Pokémon name
	ld hl, OTPointers
	call .GetStringPointer
	ld d, h
	ld e, l
	hlcoord 12, 16
	call PlaceString ; OT
	hlcoord 12, 14
	ld de, wLoadedMonOTID
	lb bc, LEADING_ZEROES | 2, 5
	call PrintNumber ; ID Number
	ld d, STATUS_SCREEN_STATS_BOX
	call PrintStatsBox
	call Delay3
	call GBPalNormal
	hlcoord 1, 0
	call LoadFlippedFrontSpriteByMonIndex ; draw Pokémon picture
	ld a, [wCurPartySpecies]
	call PlayCry
	call WaitForTextScrollButtonPress
	pop af
	ldh [hTileAnimations], a
	ret

.GetStringPointer
	ld a, [wMonDataLocation]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	ret z
	ld a, [wWhichPokemon]
	jp SkipFixedLengthTextEntries

OTPointers:
	dw wPartyMonOT
	dw wEnemyMonOT
	dw wBoxMonOT
	dw wDayCareMonOT

NamePointers2:
	dw wPartyMonNicks
	dw wEnemyMonNicks
	dw wBoxMonNicks
	dw wDayCareMonName

TypesIDNoOTText:
	db   "TYPE1/"
	next "TYPE2/"
	next "<ID>№/"
	next "OT/"
	next "@"

StatusText:
	db "STATUS/@"

OKText:
	db "OK@"

; Draws a line starting from hl high b and wide c
DrawLineBox:
	ld de, SCREEN_WIDTH ; New line
.PrintVerticalLine
	ld [hl], $78 ; │
	add hl, de
	dec b
	jr nz, .PrintVerticalLine
	ld [hl], $77 ; ┘
	dec hl
.PrintHorizLine
	ld [hl], $76 ; ─
	dec hl
	dec c
	jr nz, .PrintHorizLine
	ld [hl], $6f ; ← (halfarrow ending)
	ret

PTile: INCBIN "gfx/font/P.1bpp"

PrintStatsBox:
	ld a, d
	ASSERT STATUS_SCREEN_STATS_BOX == 0
	and a
	jr nz, .LevelUpStatsBox ; battle or Rare Candy
	hlcoord 0, 8
	ld b, 8
	ld c, 8
	call TextBoxBorder
	hlcoord 1, 9
	ld bc, SCREEN_WIDTH + 5 ; one row down and 5 columns right
	jr .PrintStats
.LevelUpStatsBox
	hlcoord 9, 2
	ld b, 8
	ld c, 9
	call TextBoxBorder
	hlcoord 11, 3
	ld bc, SCREEN_WIDTH + 4 ; one row down and 4 columns right
.PrintStats
	push bc
	push hl
	ld de, .StatsText
	call PlaceString
	pop hl
	pop bc
	add hl, bc
	ld de, wLoadedMonAttack
	lb bc, 2, 3
	call .PrintStat
	ld de, wLoadedMonDefense
	call .PrintStat
	ld de, wLoadedMonSpeed
	call .PrintStat
	ld de, wLoadedMonSpecial
	jp PrintNumber

.PrintStat:
	push hl
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

.StatsText:
	db   "ATTACK"
	next "DEFENSE"
	next "SPEED"
	next "SPECIAL@"

StatusScreen2:
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	ldh [hAutoBGTransferEnabled], a
	ld bc, NUM_MOVES + 1
	ld hl, wMoves
	call FillMemory
	ld hl, wLoadedMonMoves
	ld de, wMoves
	ld bc, NUM_MOVES
	call CopyData
	callfar FormatMovesString
	hlcoord 9, 2
	lb bc, 5, 10
	call ClearScreenArea ; Clear under name
	hlcoord 19, 3
	ld [hl], $78
	hlcoord 0, 8
	ld b, 6
	ld c, 18
	call TextBoxBorder ; Draw move container (sized for up to NUM_MOVES single-spaced)
	hlcoord 2, 9
	ld de, wMovesString
	ldh a, [hUILayoutFlags]
	set BIT_SINGLE_SPACED_LINES, a
	ldh [hUILayoutFlags], a
	call PlaceString ; Print moves single-spaced so all NUM_MOVES fit
	ldh a, [hUILayoutFlags]
	res BIT_SINGLE_SPACED_LINES, a
	ldh [hUILayoutFlags], a
	ld hl, wLoadedMonMoves
	decoord 14, 9 ; each move's PP shares its row (right-aligned)
	ld b, 0
.PrintPP
	ld a, [hli]
	and a
	jr z, .PPDone
	push bc
	push hl
	push de
	ld hl, wCurrentMenuItem
	ld a, [hl]
	push af
	ld a, b
	ld [hl], a
	push hl
	callfar GetMaxPP
	pop hl
	pop af
	ld [hl], a
	pop de
	pop hl
	push hl
	ld bc, MON_PP - MON_MOVES - 1
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ld [wStatusScreenCurrentPP], a
	ld h, d
	ld l, e
	push hl
	ld de, wStatusScreenCurrentPP
	lb bc, 1, 2
	call PrintNumber
	ld a, '/'
	ld [hli], a
	ld de, wMaxPP
	lb bc, 1, 2
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH ; single-spaced: next move's PP one row down
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .PrintPP
.PPDone
	hlcoord 9, 3
	ld de, StatusScreenExpText
	call PlaceString
	ld a, [wLoadedMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .Level100
	inc a
	ld [wLoadedMonLevel], a ; Increase temporarily if not 100
.Level100
	hlcoord 14, 6
	ld [hl], '<to>'
	inc hl
	inc hl
	call PrintLevel
	pop af
	ld [wLoadedMonLevel], a
	ld de, wLoadedMonExp
	hlcoord 12, 4
	lb bc, 3, 7
	call PrintNumber ; exp
	call CalcExpToLevelUp
	ld de, wLoadedMonExp
	hlcoord 7, 6
	lb bc, 3, 7
	call PrintNumber ; exp needed to level up

	; unneeded, this clears the diacritic characters in JPN versions
	hlcoord 9, 0
	call StatusScreen_ClearName

	hlcoord 9, 1
	call StatusScreen_ClearName
	ld a, [wMonHIndex]
	ld [wNamedObjectIndex], a
	call GetMonName
	hlcoord 9, 1
	call PlaceString
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	call StatusScreen2_MoveInfo
	pop af
	ldh [hTileAnimations], a
	ld hl, wStatusFlags2
	res BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $77
	ldh [rAUDVOL], a
	call GBPalWhiteOut
	jp ClearScreen

StatusScreen2_MoveInfo:
; Interactive move viewer on the status screen's move page: a cursor sits next to
; the moves; pressing A opens a box with the selected move's TYPE/POWER/ACCURACY,
; and B leaves the status screen (preserving the original "press a button to exit"
; behaviour). The clean move page is snapshotted so each popup can be erased.
; Disabled in battle: this screen is reached from the in-battle party menu, and
; .showMoveInfo overwrites the live wPlayerMove* block, so there we just wait for a
; button like before.
	ld a, [wIsInBattle]
	and a
	jp nz, WaitForTextScrollButtonPress
	call SaveScreenTilesToBuffer2
; count the mon's moves (0-terminated, up to NUM_MOVES) for the menu's max index
	ld hl, wLoadedMonMoves
	ld b, 0
.countLoop
	ld a, [hli]
	and a
	jr z, .counted
	inc b
	ld a, b
	cp NUM_MOVES
	jr c, .countLoop
.counted
	ld a, b
	and a
	ret z ; no moves: nothing to view, just exit
	dec a
	ld [wMaxMenuItem], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wMenuWrappingEnabled], a
	ld a, 9
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ldh a, [hUILayoutFlags]
	push af ; save the caller's flags so we can restore them on exit
	set BIT_DOUBLE_SPACED_MENU, a ; despite the name, SET here means 1-row cursor steps (moves are listed single-spaced); CLEAR means 2-row steps
	ldh [hUILayoutFlags], a
.loop
	xor a
	ld [wMenuJoypadPollCount], a ; wait indefinitely for a keypress
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, .exit
	call .showMoveInfo
	call LoadScreenTilesFromBuffer2 ; erase the popup, restore the clean move page
	jr .loop
.exit
	call LoadScreenTilesFromBuffer2 ; leave the clean page for the white-out
	pop af
	ldh [hUILayoutFlags], a ; restore, so later menus (bag, start menu) aren't left with our spacing
	ret

.showMoveInfo:
	ld a, [wCurrentMenuItem]
	ld e, a
	ld d, 0
	ld hl, wLoadedMonMoves
	add hl, de
	ld a, [hl]
	and a
	ret z
; copy this move's Moves-table entry into the wPlayerMove* block (identical layout:
; num/effect/power/type/accuracy/maxpp), so PrintMoveType and the fields work as-is
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wPlayerMoveNum
	ld a, BANK(Moves)
	call FarCopyData
	hlcoord 1, 4
	lb bc, 5, 16
	call TextBoxBorder
	hlcoord 2, 5
	ld de, MoveInfoTypeText
	call PlaceString
	hlcoord 2, 7
	ld de, MoveInfoPowerText
	call PlaceString
	hlcoord 2, 9
	ld de, MoveInfoAccText
	call PlaceString
	hlcoord 10, 5
	predef PrintMoveType
; power (--- when 0, e.g. status moves)
	ld a, [wPlayerMovePower]
	and a
	jr z, .noPower
	hlcoord 14, 7
	ld de, wPlayerMovePower
	lb bc, 1, 3
	call PrintNumber
	jr .doAccuracy
.noPower
	hlcoord 15, 7
	ld de, MoveInfoDashes
	call PlaceString
.doAccuracy
	ld a, [wPlayerMoveAccuracy]
	and a
	jr z, .noAccuracy
; accuracy is stored as percent * $ff / 100; recover the percentage:
; percent = (accuracy * 100 + 127) / 255
	xor a
	ldh [hMultiplicand], a
	ldh [hMultiplicand + 1], a
	ld a, [wPlayerMoveAccuracy]
	ldh [hMultiplicand + 2], a
	ld a, 100
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 3]
	add 127
	ldh [hProduct + 3], a
	ldh a, [hProduct + 2]
	adc 0
	ldh [hProduct + 2], a
	ld a, 255
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 3]
	ld [wStatusScreenCurrentPP], a ; scratch: PP was already drawn for this page
	hlcoord 14, 9
	ld de, wStatusScreenCurrentPP
	lb bc, 1, 3
	call PrintNumber
	jr .infoWait
.noAccuracy
	hlcoord 15, 9
	ld de, MoveInfoDashes
	call PlaceString
.infoWait
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	jp WaitForTextScrollButtonPress

MoveInfoTypeText:
	db "TYPE/@"
MoveInfoPowerText:
	db "POWER/@"
MoveInfoAccText:
	db "ACCURACY/@"
MoveInfoDashes:
	db "---@"

CalcExpToLevelUp:
	ld a, [wLoadedMonLevel]
	cp MAX_LEVEL
	jr z, .atMaxLevel
	inc a
	ld d, a
	callfar CalcExperience
	ld hl, wLoadedMonExp + 2
	ldh a, [hExperience + 2]
	sub [hl]
	ld [hld], a
	ldh a, [hExperience + 1]
	sbc [hl]
	ld [hld], a
	ldh a, [hExperience]
	sbc [hl]
	ld [hld], a
	ret
.atMaxLevel
	ld hl, wLoadedMonExp
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

StatusScreenExpText:
	db   "EXP POINTS"
	next "LEVEL UP@"

StatusScreen_ClearName:
	ld bc, NAME_LENGTH - 1
	ld a, ' '
	jp FillMemory

StatusScreen_PrintPP:
; print PP or -- c times, going down two rows each time
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, StatusScreen_PrintPP
	ret
