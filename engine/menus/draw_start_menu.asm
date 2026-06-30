; function that displays the start menu
DrawStartMenu::
	hlcoord 10, 0
	ld c, $08
	ld b, $0c ; base height (no POKéDEX, no CALL MEGAN)
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .checkMeganBox
	ld b, $0e ; +2 rows for the POKéDEX entry
.checkMeganBox
	ld a, [wPostGameMisc]
	bit BIT_GOT_GIRLFRIEND, a
	jr z, .drawTextBoxBorder
	inc b
	inc b ; +2 rows for the CALL MEGAN entry
.drawTextBoxBorder
	call TextBoxBorder
	ld a, PAD_DOWN | PAD_UP | PAD_START | PAD_B | PAD_A
	ld [wMenuWatchedKeys], a
	ld a, $02
	ld [wTopMenuItemY], a ; Y position of first menu choice
	ld a, $0b
	ld [wTopMenuItemX], a ; X position of first menu choice
	ld a, [wBattleAndStartSavedMenuItem] ; remembered menu selection from last time
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 12, 2
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokedex
	ld a, $06
	jr z, .countMegan
; case for having pokedex
	ld de, StartMenuPokedexText
	call PrintStartMenuItem
	ld a, $07
.countMegan
	ld b, a
	ld a, [wPostGameMisc]
	bit BIT_GOT_GIRLFRIEND, a
	jr z, .storeMenuItemCount
	inc b ; +1 menu item for CALL MEGAN
.storeMenuItemCount
	ld a, b
	ld [wMaxMenuItem], a ; number of menu items
	ld de, StartMenuPokemonText
	call PrintStartMenuItem
	ld de, StartMenuItemText
	call PrintStartMenuItem
	ld de, wPlayerName ; player's name
	call PrintStartMenuItem
	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
; case for not using link feature
	ld de, StartMenuSaveText
	jr z, .printSaveOrResetText
; case for using link feature
	ld de, StartMenuResetText
.printSaveOrResetText
	call PrintStartMenuItem
	ld de, StartMenuOptionText
	call PrintStartMenuItem
	ld a, [wPostGameMisc]
	bit BIT_GOT_GIRLFRIEND, a
	jr z, .noMegan
	ld de, StartMenuMeganText
	call PrintStartMenuItem
.noMegan
	ld de, StartMenuExitText
	call PlaceString
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret

StartMenuPokedexText:
	db "POKéDEX@"

StartMenuPokemonText:
	db "POKéMON@"

StartMenuItemText:
	db "ITEM@"

StartMenuSaveText:
	db "SAVE@"

StartMenuResetText:
	db "RESET@"

StartMenuExitText:
	db "EXIT@"

StartMenuOptionText:
	db "OPTION@"

StartMenuMeganText:
	db "MEGAN@"

PrintStartMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret
