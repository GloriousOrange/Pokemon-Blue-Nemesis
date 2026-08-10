; Hyper Beam's power in the Moves table is never used. This overwrites it with
; the user's BASE Attack + BASE Speed, minus 50 -- or minus 30 when the user is
; NORMAL-type, so the types that naturally learn it keep a STAB-like edge.
;
; BASE stats, deliberately, not the in-battle ones: the power is a property of
; the species, so it does not drift with level, DVs, stat experience, badge
; boosts or stat stages. An earlier version read the live stats, and by level
; 100 every single user overflowed the 255 ceiling, which flattened the whole
; point of scaling it. Across the 86 species that can learn it the range is now
; 25 (CHANSEY) to 230 (TYRANIS), against vanilla's flat 150.
;
; Setting wCurSpecies and calling GetMonHeader mid-battle is exactly what
; CriticalHitTest does on every attack, so clobbering wMonHeader here is
; established practice rather than a risk. GetMonHeader preserves bc/de/hl.
;
; Called at the tail of GetCurrentMove, which has just copied the move's row out
; of the Moves table into wPlayerMoveNum.. / wEnemyMoveNum.., so overwriting the
; power byte here is safe: loading any move puts the table value back first.

DEF HYPER_BEAM_PENALTY        EQU 50
DEF HYPER_BEAM_PENALTY_NORMAL EQU 30

ApplyHyperBeamPower::
	ldh a, [hWhoseTurn]
	and a
	jr nz, .enemyTurn
	ld a, [wPlayerMoveNum]
	cp HYPER_BEAM
	ret nz
	ld a, [wBattleMonSpecies]
	ld de, wPlayerMovePower
	jr .lookUpBaseStats

.enemyTurn
	ld a, [wEnemyMoveNum]
	cp HYPER_BEAM
	ret nz
	ld a, [wEnemyMonSpecies]
	ld de, wEnemyMovePower

.lookUpBaseStats
; a = the user's species, de = the power byte to overwrite
	ld [wCurSpecies], a
	call GetMonHeader
	ld a, [wMonHBaseAttack]
	ld b, a
	ld a, [wMonHBaseSpeed]
	add b
	ld l, a
	ld a, 0
	adc 0
	ld h, a ; hl = base Attack + base Speed, which can exceed 255

	ld c, HYPER_BEAM_PENALTY
	ld a, [wMonHType1]
	cp NORMAL
	jr z, .normalUser
	ld a, [wMonHType2]
	cp NORMAL
	jr nz, .havePenalty
.normalUser
	ld c, HYPER_BEAM_PENALTY_NORMAL
.havePenalty
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc 0
	jr c, .floorAtOne ; the penalty took it below zero
	and a
	jr nz, .capAt255 ; anything over 255 won't fit in a power byte
	ld a, l
	and a
	jr z, .floorAtOne
	jr .store
.capAt255
	ld a, 255
	jr .store
.floorAtOne
	ld a, 1
.store
	ld [de], a
	ret
