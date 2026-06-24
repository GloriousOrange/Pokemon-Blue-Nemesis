; Player HM helper — lives in home bank so bank3 and home code can both call it.

PlayerHMIsItemInBag::
; Input:  a = item ID to search
; Output: carry SET if found in wBagItems, carry CLEAR if not
	ld b, a
	ld hl, wBagItems
.scan:
	ld a, [hli]
	cp $ff
	jr z, .notFound
	cp b
	jr z, .found
	inc hl          ; skip quantity byte
	jr .scan
.found:
	scf
	ret
.notFound:
	and a           ; clear carry
	ret
