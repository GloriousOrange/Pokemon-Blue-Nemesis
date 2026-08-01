JackpotEffect_:
; Nemesis custom (Persian's lv98 signature). Like Pay Day, but instead of
; level*2 it scatters a flat random $300-$1000 per use, on top of dealing the
; move's normal (base power 80) damage. Builds the amount as packed BCD in
; wPayDayMoney and folds it into the running wTotalPayDayMoney, paid out at the
; end of battle exactly like Pay Day.
	xor a
	ld hl, wPayDayMoney
	ld [hli], a             ; wPayDayMoney+0 = 0 (most-significant BCD byte)
; roll the hundreds place: 3..10 with equal odds; 10 is the $1000 jackpot
	call Random ; home-bank Random: this file is not in the Battle Core bank
	and $07                 ; 0..7
	add 3                   ; 3..10
	cp 10
	jr nz, .notMax
; max roll: pay out exactly $1000 -> "001000"
	ld a, $10
	ld [hli], a             ; wPayDayMoney+1 = $10
	xor a
	ld [hl], a              ; wPayDayMoney+2 = $00
	jr .addMoney
.notMax
; a = 3..9 is already a valid single BCD nibble ($03..$09)
	ld [hli], a             ; wPayDayMoney+1 = $0h (hundreds digit)
; low two digits: a uniformly random 00..99, stored as packed BCD
	call Random ; home-bank Random: this file is not in the Battle Core bank
.reduce
	cp 100
	jr c, .under100
	sub 100
	jr .reduce
.under100
; convert binary a (0..99) to packed BCD
	ld b, 0                 ; tens count
.tens
	cp 10
	jr c, .ones
	sub 10
	inc b
	jr .tens
.ones
	ld c, a                 ; ones (0..9)
	ld a, b
	swap a                  ; tens -> high nibble
	or c
	ld [hl], a              ; wPayDayMoney+2 = packed BCD tens/ones
.addMoney
	ld de, wTotalPayDayMoney + 2
	ld c, $3
	predef AddBCDPredef
	ld hl, CoinsScatteredText ; reuse Pay Day's "coins scattered" flavor
	jp PrintText
