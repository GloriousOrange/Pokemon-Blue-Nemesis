; These routines manage gradual fading
; (e.g., entering a doorway)
LoadGBPal::
	ld a, [wMapPalOffset] ; tells if wCurMap is dark (requires HM5_FLASH?)
	ld b, a
	ld hl, FadePal4
	ld a, l
	sub b
	ld l, a
	jr nc, .ok
	dec h
.ok
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld d, a
	jp SetGBPalShades

GBFadeInFromBlack::
	ld hl, FadePal1
	ld b, 4
	jr GBFadeIncCommon

GBFadeOutToWhite::
	ld hl, FadePal6
	ld b, 3

GBFadeIncCommon:
	push bc ; step counter
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	push hl
	call SetGBPalShades
	pop hl
	pop bc
	ld c, 8
	call DelayFrames
	dec b
	jr nz, GBFadeIncCommon
	ret

GBFadeOutToBlack::
	ld hl, FadePal4 + 2
	ld b, 4
	jr GBFadeDecCommon

GBFadeInFromWhite::
	ld hl, FadePal7 + 2
	ld b, 3

GBFadeDecCommon:
	push bc ; step counter
	ld a, [hld]
	ld d, a
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld b, a
	push hl
	call SetGBPalShades
	pop hl
	pop bc
	ld c, 8
	call DelayFrames
	dec b
	jr nz, GBFadeDecCommon
	ret

FadePal1:: dc 3,3,3,3, 3,3,3,3, 3,3,3,3
FadePal2:: dc 3,3,3,2, 3,3,3,2, 3,3,2,0
FadePal3:: dc 3,3,2,1, 3,2,1,0, 3,2,1,0
FadePal4:: dc 3,2,1,0, 3,1,0,0, 3,2,0,0
;              rBGP     rOBP0    rOBP1
FadePal5:: dc 3,2,1,0, 3,1,0,0, 3,2,0,0
FadePal6:: dc 2,1,0,0, 2,0,0,0, 2,1,0,0
FadePal7:: dc 1,0,0,0, 1,0,0,0, 1,0,0,0
FadePal8:: dc 0,0,0,0, 0,0,0,0, 0,0,0,0
