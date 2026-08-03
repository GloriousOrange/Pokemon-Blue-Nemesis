RestoreScreenTilesAndReloadTilePatterns::
	call ClearSprites
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	call ReloadMapSpriteTilePatterns
	call LoadScreenTilesFromBuffer2
	call LoadTextBoxTilePatterns
	call RunDefaultPaletteCommand
	jr Delay3

GBPalWhiteOutWithDelay3::
	call GBPalWhiteOut

Delay3::
; The bg map is updated each frame in thirds.
; Wait three frames to let the bg map fully update.
	ld c, 3
	jp DelayFrames

GBPalNormal::
; Reset BGP and OBP0.
	ld b, %11100100 ; 3210
	ld c, %11010000 ; 3100
	ldh a, [rOBP1] ; vanilla leaves OBP1 alone, so keep whatever it holds
	ld d, a
	jr SetGBPalShades

GBPalWhiteOut::
; White out all palettes.
	ld b, 0
	ld c, 0
	ld d, 0
	; fallthrough

SetGBPalShades::
; b = BGP, c = OBP0, d = OBP1.
; Writes the DMG palette registers and, on a Game Boy Color, rebuilds the real
; color palettes from the same shade mapping. Everything that fades the screen
; by rewriting rBGP goes through here so that it fades on a CGB too, where
; those registers do nothing at all.
	ld a, b
	ldh [rBGP], a
	ld a, c
	ldh [rOBP0], a
	ld a, d
	ldh [rOBP1], a
; Only queue a color rebuild when the shades actually moved. The overworld loop
; calls LoadGBPal every single frame with the same values, and queueing on each
; one left VBlank rebuilding palettes forever, using up the room the tilemap
; transfers need.
	ld a, [wCGBShadowBGP]
	cp b
	jr nz, .changed
	ld a, [wCGBShadowOBP0]
	cp c
	jr nz, .changed
	ld a, [wCGBShadowOBP1]
	cp d
	ret z
.changed
	ld a, b
	ld [wCGBShadowBGP], a
	ld a, c
	ld [wCGBShadowOBP0], a
	ld a, d
	ld [wCGBShadowOBP1], a
	ld a, [wOnCGB]
	and a
	ret z
	push bc
	push de
	push hl
	farcall ApplyCGBPalettes
	pop hl
	pop de
	pop bc
	ret

SyncCGBPalettesToDMGRegs::
; Top of VBlank: hand the hardware whatever colors are waiting in the buffer.
; Palette RAM is only writable outside LCD mode 3, and this is the one point in
; the frame with room to spare -- the tilemap transfers below run VBlank right
; down to its last line.
	ld a, [wOnCGB]
	and a
	ret z
	ld a, [wCGBPalSync]
	and a
	ret z
	farjp BlitQueuedCGBPalette

ServeCGBPaletteQueue::
; End of VBlank: notice anything that changed the DMG palette registers behind
; our back, and work out the next palette's colors ready for the next frame.
;
; Plenty of code fades or flashes the screen by writing rBGP/rOBP0/rOBP1 straight
; -- the intro, the credits, battle transitions, move animations -- and none of
; it goes through SetGBPalShades. Those registers do nothing at all on a Game Boy
; Color, so without this the screen simply stops responding: the Game Freak intro
; stayed washed out and battle flashes never flashed.
;
; Only WRAM is touched here, so running past the end of VBlank costs nothing.
	ld a, [wOnCGB]
	and a
	ret z
	ldh a, [rBGP]
	ld hl, wCGBShadowBGP
	cp [hl]
	jr nz, .changed
	ldh a, [rOBP0]
	ld hl, wCGBShadowOBP0
	cp [hl]
	jr nz, .changed
	ldh a, [rOBP1]
	ld hl, wCGBShadowOBP1
	cp [hl]
	jr z, .prepare
.changed
	ldh a, [rBGP]
	ld [wCGBShadowBGP], a
	ldh a, [rOBP0]
	ld [wCGBShadowOBP0], a
	ldh a, [rOBP1]
	ld [wCGBShadowOBP1], a
	xor a ; start the rebuild over with the new shades
	ld [wCGBPalSync], a
	ld [wCGBPalNextToPrepare], a
.prepare
	farjp PrepareNextCGBPalette

RunDefaultPaletteCommand::
	ld b, SET_PAL_DEFAULT
RunPaletteCommand::
; The palette engine drives the SGB packets and, on a Game Boy Color, the CGB
; palette and attribute registers. Before this checked [wOnCGB] as well, none of
; the game's palettes reached a CGB and every phone emulator invented its own.
	ld a, [wOnSGB]
	ld hl, wOnCGB
	or [hl]
	ret z
	predef_jump _RunPaletteCommand

GetHealthBarColor::
; Return at hl the palette of
; an HP bar e pixels long.
	ld a, e
	cp 27
	ld d, 0 ; green
	jr nc, .gotColor
	cp 10
	inc d ; yellow
	jr nc, .gotColor
	inc d ; red
.gotColor
	ld [hl], d
	ret
