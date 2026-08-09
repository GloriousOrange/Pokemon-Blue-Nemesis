AnimateBoulderDust:
	ld a, $1
	ld [wWhichAnimationOffsets], a ; select the boulder dust offsets
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, %11100100
	ldh [rOBP1], a
	call LoadSmokeTileFourTimes
	farcall WriteCutOrBoulderDustAnimationOAMBlock
	ld c, 8 ; number of steps in animation
.loop
	push bc
	call GetMoveBoulderDustFunctionPointer
	ld bc, .returnAddress
	push bc
	ld c, 4
	jp hl
.returnAddress
	ldh a, [rOBP1]
	xor %01100100
	ldh [rOBP1], a
	call Delay3
	pop bc
	dec c
	jr nz, .loop
	pop af
	ld [wUpdateSpritesEnabled], a
	jp LoadPlayerSpriteGraphics

GetMoveBoulderDustFunctionPointer:
	ld a, [wSpritePlayerStateData1FacingDirection]
	ld hl, MoveBoulderDustFunctionPointerTable
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld [wCoordAdjustmentAmount], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, wShadowOAMSprite36
	ld d, $0
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ret

MACRO boulder_dust_adjust
	db \1, \2 ; coords
	dw \3 ; function
ENDM

MoveBoulderDustFunctionPointerTable:
	boulder_dust_adjust -1, 0, DustAdjustOAMBlockYPos ; down
	boulder_dust_adjust  1, 0, DustAdjustOAMBlockYPos ; up
	boulder_dust_adjust  1, 1, DustAdjustOAMBlockXPos ; left
	boulder_dust_adjust -1, 1, DustAdjustOAMBlockXPos ; right

; Same-bank copies of AdjustOAMBlockXPos / AdjustOAMBlockYPos, which really
; live in engine/battle/animations.asm.
;
; They have to be copies. The originals are in bank 1E, this file was floated
; out of bank 1E when new move animations refilled it, and .loop above reaches
; whichever adjuster the table names with a bare `jp hl` -- and `jp` cannot
; cross a bank. It jumped to bank 1E's address with bank 08 mapped, landed in
; padding, and fell through to RST 38. That was the gray screen on every
; boulder push in the game, not just the new cave's.
;
; main.asm's section comment ("only called via farcall/callfar, so any bank
; works") is true of how this file is ENTERED and false of what it does once
; inside. Anything else moved out of a bank needs the same check: farcall in
; does not make a bare jp/call out safe.
;
; cut2.asm still calls the bank 1E originals, and is itself in bank 1E, so it
; is unaffected either way.
DustAdjustOAMBlockXPos:
	ld l, e
	ld h, d
	ld de, OBJ_SIZE
.loop
	ld a, [wCoordAdjustmentAmount]
	ld b, a
	ld a, [hl]
	add b
	cp 168
	jr c, .skipPuttingEntryOffScreen
; put off-screen if X >= 168
	dec hl
	ld a, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld [hli], a
.skipPuttingEntryOffScreen
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	ret

DustAdjustOAMBlockYPos:
	ld l, e
	ld h, d
	ld de, OBJ_SIZE
.loop
	ld a, [wCoordAdjustmentAmount]
	ld b, a
	ld a, [hl]
	add b
	cp 112
	jr c, .skipSettingPreviousEntrysAttribute
	dec hl
	ld a, 160 ; bug kept from the original: sets the previous entry's attribute
	ld [hli], a
.skipSettingPreviousEntrysAttribute
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	ret

LoadSmokeTileFourTimes::
	ld hl, vChars1 tile $7c
	ld c, 4
.loop
	push bc
	push hl
	call LoadSmokeTile
	pop hl
	ld bc, TILE_SIZE
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

LoadSmokeTile:
	ld de, SSAnneSmokePuffTile
	lb bc, BANK(SSAnneSmokePuffTile), (SSAnneSmokePuffTileEnd - SSAnneSmokePuffTile) / TILE_SIZE
	jp CopyVideoData

SSAnneSmokePuffTile:
	INCBIN "gfx/overworld/smoke.2bpp"
SSAnneSmokePuffTileEnd:
