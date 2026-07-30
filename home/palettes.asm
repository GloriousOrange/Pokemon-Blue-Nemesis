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
	ld [wCGBShadowBGP], a
	ld a, c
	ldh [rOBP0], a
	ld [wCGBShadowOBP0], a
	ld a, d
	ldh [rOBP1], a
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
; Called once a frame from VBlank. Plenty of code fades or flashes the screen by
; writing rBGP/rOBP0/rOBP1 straight -- the intro, the credits, battle
; transitions, move animations -- and none of it goes through SetGBPalShades.
; Those registers do nothing at all on a Game Boy Color, so without this the
; screen simply stops responding: the Game Freak intro stayed washed out and
; battle flashes never flashed. Catch such a write on the frame it happens and
; rebuild the real palettes from the same shade mapping.
;
; Sits after the VRAM transfers in VBlank and costs about a dozen cycles on the
; frames where nothing changed. VBlank is also the only place palette RAM is
; reliably writable, so this is where the queued rebuild gets served -- a
; palette at a time, for as long as the frame has room.
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
	jr z, .serveQueue
.changed
	ldh a, [rBGP]
	ld [wCGBShadowBGP], a
	ldh a, [rOBP0]
	ld [wCGBShadowOBP0], a
	ldh a, [rOBP1]
	ld [wCGBShadowOBP1], a
	ld a, 1
	ld [wCGBPalSync], a
.serveQueue
	ld a, [wCGBPalSync]
	and a
	ret z
	farjp ApplyCGBPalettesInVBlank

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
