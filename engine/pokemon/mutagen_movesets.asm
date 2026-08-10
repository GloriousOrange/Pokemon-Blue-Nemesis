ApplyOlympiaTrainerMoveset::
; Called from ReadTrainer's .FinishUp for every trainer battle. Off the
; S.S. OLYMPIA it does nothing.
;
; Aboard, every trainer carries exactly one L100 Pokemon, so mon1 is the whole
; team -- and its moves come from the curated MutagenMovesets row for its
; species rather than from whatever its learnset happens to end on. This is the
; "one table, two consumers" wiring: the player's mutagenated mons and the
; ship's trainers read the same rows, so a trainer's signature move only has to
; appear in that species' row. No LoneMoves entry, no per-trainer case here.
;
; A species with no curated row yet keeps its learnset moves, so the ship stays
; playable while the table is still being filled in.
	ld a, [wCurMap]
	ld b, a
	ld hl, .Decks
.findDeck
	ld a, [hli]
	cp -1
	ret z ; ashore: leave the party exactly as ReadTrainer built it
	cp b
	jr nz, .findDeck

	ld a, [wEnemyMon1Species]
	and a
	ret z ; no mon loaded; nothing to re-arm
	ld [wCurPartySpecies], a
	ld de, wEnemyMon1Moves
	jp ApplyMutagenMoveset ; tail call; its hl return means nothing to ReadTrainer

.Decks:
INCLUDE "data/maps/ss_olympia_decks.asm"

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

ApplyNormanMoveset::
; Norman's Viridian Gym team -- the one roster in the game whose moves are all
; hand-picked rather than whatever its members' learnsets happen to end on.
; Called from ReadTrainer's class dispatch, for TamerData #1 only.
;
; His party uses the $FF per-mon-level format, so each mon arrives through
; AddPartyMon with learnset moves already written; this walks the slots named in
; .Team afterwards and overwrites them. SNORLAX has no row and keeps its
; learnset -- Josh's call, not an omission.
;
; Every row is a full NUM_MOVES set, so the PP block is rewritten to match:
; base stats only carry four moves, which leaves the 5th slot and its PP empty
; when AddPartyMon runs, and a move sitting on 0 PP cannot be used at all.
	ld hl, .Team
.nextMon
	ld a, [hli]
	and a
	ret z ; a 0 slot byte terminates the table

	dec a ; slot number -> party index
	push hl
	ld hl, wEnemyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes ; hl -> this mon's MON_MOVES
	ld d, h
	ld e, l
	pop hl ; hl -> this row's moves

	push de ; remember where MON_MOVES starts
	REPT NUM_MOVES
	ld a, [hli]
	ld [de], a
	inc de
	ENDR
	ld b, h
	ld c, l ; bc = our place in the table, past this row
	pop hl ; hl -> MON_MOVES, the moves just written
	push bc ; the table position has to outlive the PP write

; LoadMovePPs wants hl -> the moves and de -> one byte below the PP slots.
	push hl
	ld bc, MON_PP - MON_MOVES - 1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	predef LoadMovePPs ; Predef saves and restores our bank, so this is safe here

	pop hl ; hl -> the next row
	jr .nextMon

.Team:
; Party slot, then that mon's five moves. Slot 2 is SNORLAX and is deliberately
; absent. Slot order follows TamerData #1 in data/trainers/parties.asm -- reorder
; that roster and these slot numbers have to move with it.
	db 1, STOMP,       HYPER_BEAM,  STAMPEDE, THUNDERBOLT, DOUBLE_EDGE ; TAUROS
	db 3, SING,        MINIMIZE,    FLASH,    BODY_SLAM,   SUBSTITUTE  ; CHANSEY
	db 4, MEGA_PUNCH,  DIZZY_PUNCH, BODY_SLAM, LEER,       BITE        ; KANGASKHAN
	db 5, SAND_ATTACK, SWIFT,       RECOVER,  DOUBLE_EDGE, DOUBLE_TEAM ; EEVEE
	db 6, JACKPOT,     SCREECH,     SLASH,    HYPER_BEAM,  DOUBLE_TEAM ; PERSIAN
	db 0 ; end of table
