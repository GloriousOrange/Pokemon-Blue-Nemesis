ApplyMutagenMoveset::
; Writes the curated Mutagenstone moveset for [wCurPartySpecies] into the
; NUM_MOVES move slots at de, and fills in each move's full PP to match.
;
; Returns hl = 1 if this species has a curated row, hl = 0 if it does not --
; in which case de is untouched and the caller falls back to WriteMonMoves.
; The result comes back in hl rather than in a or the carry flag because
; Bankswitch's return path clobbers a and bc; only de and hl survive a callfar.
	ld a, [wCurPartySpecies]
	ld b, a
	ld hl, MutagenMovesets
.search
	ld a, [hl]
	and a
	jr z, .noRow ; a 0 species byte terminates the table
	cp b
	jr z, .found
	ld a, MUTAGEN_MOVESET_LENGTH
	add l
	ld l, a
	jr nc, .search
	inc h
	jr .search

.noRow
	ld hl, 0
	ret

.found
	inc hl ; step over the species byte, onto move 1
	push de ; remember where the mon's MON_MOVES starts
	REPT NUM_MOVES
	ld a, [hli]
	ld [de], a
	inc de
	ENDR
	pop hl ; hl -> MON_MOVES, the moves just written

; LoadMovePPs wants hl -> the moves and de -> one byte below the PP slots.
; The stone always writes a full fresh set, so every move gets its max PP --
; note WriteMonMoves would not have touched PP at all here, since it only
; maintains PP on the day-care path.
	push hl
	ld bc, MON_PP - MON_MOVES - 1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	predef LoadMovePPs ; Predef saves and restores our bank, so this is safe here

	ld hl, 1
	ret
