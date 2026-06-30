DisplayStartMenu::
	ld a, BANK(StartMenu_Pokedex)
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ld a, [wWalkBikeSurfState] ; walking/biking/surfing
	ld [wWalkBikeSurfStateCopy], a
	ld a, SFX_START_MENU
	call PlaySound

RedisplayStartMenu::
	farcall DrawStartMenu
	farcall PrintSafariZoneSteps ; print Safari Zone info, if in Safari Zone
	call UpdateSprites
.loop
	call HandleMenuInput
	ld b, a
; check if Up pressed
	bit B_PAD_UP, a
	jr z, .checkIfDownPressed
	ld a, [wCurrentMenuItem] ; menu selection
	and a
	jr nz, .loop
	ld a, [wLastMenuItem]
	and a
	jr nz, .loop
; if the player pressed tried to go past the top item, wrap around to the bottom
	ld a, [wMaxMenuItem] ; item count; the highest index is one less
	dec a
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.checkIfDownPressed
	bit B_PAD_DOWN, a
	jr z, .buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top
	ld a, [wMaxMenuItem] ; item count (EXIT's index + 1 = the past-bottom sentinel)
	ld c, a
	ld a, [wCurrentMenuItem]
	cp c
	jr nz, .loop
; the player went past the bottom, so wrap to the top
	xor a
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr .loop
.buttonPressed ; A, B, or Start button pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a ; save current menu selection
	ld a, b
	and PAD_B | PAD_START ; was the Start button or B button pressed?
	jp nz, CloseStartMenu
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
.displayMenuItem
	cp 0
	jp z, StartMenu_Pokedex
	cp 1
	jp z, StartMenu_Pokemon
	cp 2
	jp z, StartMenu_Item
	cp 3
	jp z, StartMenu_TrainerInfo
	cp 4
	jp z, StartMenu_SaveReset
	cp 5
	jp z, StartMenu_Option
	cp 6
	jr nz, CloseStartMenu ; index 7 = EXIT (when CALL MEGAN is present)
; canonical index 6 is CALL MEGAN if Megan has been met, otherwise EXIT
	ld a, [wPostGameMisc]
	bit BIT_GOT_GIRLFRIEND, a
	jp nz, StartMenu_Megan

; EXIT falls through to here
CloseStartMenu::
	call Joypad
	ldh a, [hJoyPressed]
	bit B_PAD_A, a
	jr nz, CloseStartMenu
	call LoadTextBoxTilePatterns
	jp CloseTextDisplay
