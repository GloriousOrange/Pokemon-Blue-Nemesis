ApplyHyperBeamPower::
; Hyper Beam doesn't use the power in the move table.  It hits for the user's
; Attack + Speed - 50, or Attack + Speed - 30 when the user is NORMAL-type, so
; the move keeps a STAB-like edge for the types that naturally learn it.
;
; Called at the tail of GetCurrentMove, which has just copied the move's row out
; of the Moves table into wPlayerMoveNum.. / wEnemyMoveNum.., so overwriting the
; power byte here is safe: loading any move puts the table value back first.
; Reads the in-battle stats, so badge boosts and stat stages feed into it.
	ldh a, [hWhoseTurn]
	and a
	jr nz, .enemyTurn
	ld a, [wPlayerMoveNum]
	cp HYPER_BEAM
	ret nz
	ld hl, wBattleMonAttack
	call .readStat
	push bc
	ld hl, wBattleMonSpeed
	call .readStat
	ld a, [wBattleMonType1]
	ld h, a
	ld a, [wBattleMonType2]
	ld de, wPlayerMovePower
	jr .combine

.enemyTurn
	ld a, [wEnemyMoveNum]
	cp HYPER_BEAM
	ret nz
	ld hl, wEnemyMonAttack
	call .readStat
	push bc
	ld hl, wEnemyMonSpeed
	call .readStat
	ld a, [wEnemyMonType1]
	ld h, a
	ld a, [wEnemyMonType2]
	ld de, wEnemyMovePower

.combine
; bc = Speed, top of stack = Attack, h = type 1, a = type 2,
; de = the power byte to overwrite
	ld l, 50
	cp NORMAL
	jr z, .normalUser
	ld a, h
	cp NORMAL
	jr nz, .havePenalty
.normalUser
	ld l, 30
.havePenalty
	ld a, l
	pop hl ; hl = Attack
	push af ; keep the penalty
	ld a, l
	add c
	ld l, a
	ld a, h
	adc b
	ld h, a ; hl = Attack + Speed
	pop af
	ld c, a
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

.readStat
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ret
