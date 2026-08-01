; tests if mon [wCurPartySpecies] can learn move [wMoveNum]
CanLearnTM:
	; The ghost-move TMs (Night Shade / Confuse Ray) can be taught to any
	; species, since the resurrected starter may be any of them.
	ld a, [wMoveNum]
	cp NIGHT_SHADE
	jr z, .ghostMoveAlwaysLearnable
	cp CONFUSE_RAY
	jr z, .ghostMoveAlwaysLearnable
	cp GHOST_BEAM
	jr z, .ghostMoveAlwaysLearnable
	cp METRONOME2 ; Oak's reward HM is learnable by every species
	jr z, .ghostMoveAlwaysLearnable
	ld a, [wCurPartySpecies]
	cp DITTO ; Ditto can learn every TM/HM (it mimics everything anyway)
	jr z, .ghostMoveAlwaysLearnable
	ld [wCurSpecies], a
	call GetMonHeader
	ld hl, wMonHLearnset
	push hl
	ld a, [wMoveNum]
	ld b, a
	ld c, $0
	ld hl, TechnicalMachines
.findTMloop
	ld a, [hli]
	cp b
	jr z, .TMfoundLoop
	inc c
	jr .findTMloop
.TMfoundLoop
	pop hl
	ld b, FLAG_TEST
	predef_jump FlagActionPredef

.ghostMoveAlwaysLearnable
	ld c, 1 ; nonzero = can learn (callers test [c] != 0)
	ret

; converts TM/HM number in [wTempTMHM] into move number
; HMs start at 51
TMToMove:
	ld a, [wTempTMHM]
	dec a
	ld hl, TechnicalMachines
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wTempTMHM], a
	ret

INCLUDE "data/moves/tmhm_moves.asm"
