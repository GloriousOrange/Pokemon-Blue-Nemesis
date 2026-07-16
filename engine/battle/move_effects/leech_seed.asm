LeechSeedEffect_:
	callfar MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, .moveMissed
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMonType1
	ldh a, [hWhoseTurn]
	and a
	jr z, .leechSeedEffect
	ld hl, wPlayerBattleStatus2
	ld de, wBattleMonType1
.leechSeedEffect
; miss if the target is grass-type or already seeded
	ld a, [de]
	cp GRASS
	jr z, .moveMissed
	inc de
	ld a, [de]
	cp GRASS
	jr z, .moveMissed
	bit SEEDED, [hl]
	jr nz, .moveMissed
	set SEEDED, [hl]
; Nemesis: 50% chance the seeded target also flinches. hl currently points at
; the target's BattleStatus2; BattleStatus1 (which holds FLINCHED) sits one
; byte before it in WRAM, so dec hl reaches it. Also clear NEEDS_TO_RECHARGE
; on the flinched target, exactly as ClearHyperBeam/FlinchSideEffect do.
	call BattleRandom
	cp 50 percent + 1
	jr nc, .noFlinch
	res NEEDS_TO_RECHARGE, [hl]
	dec hl ; BattleStatus2 -> BattleStatus1
	set FLINCHED, [hl]
.noFlinch
	callfar PlayCurrentMoveAnimation
	ld hl, WasSeededText
	jp PrintText
.moveMissed
	ld c, 50
	call DelayFrames
	ld hl, EvadedAttackText
	jp PrintText

WasSeededText:
	text_far _WasSeededText
	text_end

EvadedAttackText:
	text_far _EvadedAttackText
	text_end
