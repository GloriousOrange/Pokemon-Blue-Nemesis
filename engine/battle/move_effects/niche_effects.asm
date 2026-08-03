; Nemesis niche-move effect bodies, floated out of the completely full Battle
; Core bank. Reached via jpfar wrappers in effects.asm (and callfar from
; AttackSubstitute for the frost check). To stay bank-agnostic these bodies only
; use home-bank routines (Random $3ea1, PrintText), predefs, WRAM, local text_far
; strings, and callfar for argless/void Battle Core helpers. They must NOT call
; the Battle Core BattleRandom directly (wrong bank once floated) -- the home
; `Random` is used for the freeze rolls instead.

; --- Static Shock (Electabuzz) / Gravity Slam (Aerodactyl) -------------------
; A damaging move that, after its damage, ALWAYS paralyzes the target unless it
; already has a status or shares the MOVE's own type (Electric can't paralyze
; Electric, Rock can't paralyze Rock). The substitute check is inlined because
; CheckTargetSubstitute returns its result in flags, which a callfar would lose.
StaticShockEffect_:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wEnemyBattleStatus2] ; player attacking -> enemy is the target
	jr z, .subChecked
	ld a, [wPlayerBattleStatus2]
.subChecked
	bit HAS_SUBSTITUTE_UP, a
	ret nz ; can't paralyze through a substitute
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatus
	ld de, wEnemyMonType1
	ld a, [wPlayerMoveType]
	jr z, .gotMoveType
	ld hl, wBattleMonStatus
	ld de, wBattleMonType1
	ld a, [wEnemyMoveType]
.gotMoveType
	ld b, a ; b = the move's own type
	ld a, [hl]
	and a
	ret nz ; single-status: don't paralyze an already-statused mon
	ld a, [de]
	cp b
	ret z ; target that shares the move's type is immune
	inc de
	ld a, [de]
	cp b
	ret z
	set PAR, [hl]
	callfar QuarterSpeedDueToParalysis
	jpfar PrintMayNotAttackText

; --- Hot Oil (Magmar) -------------------------------------------------------
; After its Fire damage, ALWAYS burns the target unless it already has a status
; or is Fire-type. Substitute check inlined (flag-returning helper can't callfar).
HotOilEffect_:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wEnemyBattleStatus2]
	jr z, .subChecked
	ld a, [wPlayerBattleStatus2]
.subChecked
	bit HAS_SUBSTITUTE_UP, a
	ret nz ; can't burn through a substitute
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatus
	ld de, wEnemyMonType1
	jr z, .gotTarget
	ld hl, wBattleMonStatus
	ld de, wBattleMonType1
.gotTarget
	ld a, [hl]
	and a
	ret nz ; single-status: don't burn an already-statused mon
	ld a, [de]
	cp FIRE
	ret z ; Fire-type is immune to burn
	inc de
	ld a, [de]
	cp FIRE
	ret z
	set BRN, [hl]
	callfar HalveAttackDueToBurn
	ld hl, HotOilBurnedText
	jp PrintText

HotOilBurnedText:
	text_far _BurnedText
	text_end

; --- Tangle (Tangela) -------------------------------------------------------
; After its 50-power Grass damage, lowers the target's Speed by three stages
; (floored at -6). Manual drop + recalc like WebCannonEffect. The recalc must hit
; the OPPONENT, so hWhoseTurn is flipped only around the argless RecalcSelfStats
; trampoline -- safe because RecalcModifiedStatsFor just recomputes stats and has
; no turn-dependent side effects (no animation or accuracy roll).
TangleEffect_:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wEnemyBattleStatus2] ; player attacking -> enemy is the target
	jr z, .subChecked
	ld a, [wPlayerBattleStatus2]
.subChecked
	bit HAS_SUBSTITUTE_UP, a
	ret nz ; a substitute blocks the debuff
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatMods + 2 ; player attacking -> enemy is the target
	jr z, .gotSpeedMod
	ld hl, wPlayerMonStatMods + 2
.gotSpeedMod
	ld a, [hl]
	cp 1
	ret z ; already at -6, can't lower further
	cp 4
	jr nc, .noClamp ; old >= 4 -> old-3 stays >= 1
	ld a, 4 ; old is 2 or 3 -> treat as 4 so the result floors at -6 (1)
.noClamp
	sub 3
	ld [hl], a
	ldh a, [hWhoseTurn]
	xor 1
	ldh [hWhoseTurn], a ; flip so RecalcSelfStats refreshes the opponent's stats
	callfar RecalcSelfStats
	ldh a, [hWhoseTurn]
	xor 1
	ldh [hWhoseTurn], a ; restore the real turn
	ld hl, TangleSpeedFellText
	jp PrintText

TangleSpeedFellText:
	text_far _TangleSpeedFellText
	text_end

; --- Ice Bomb (Lapras) ------------------------------------------------------
; After its 100-power Ice damage, a flat 50% chance to freeze the target (vanilla
; Ice moves are only 10%). Honors the single-status rule and Ice-type immunity.
IceBombEffect_:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wEnemyBattleStatus2]
	jr z, .subChecked
	ld a, [wPlayerBattleStatus2]
.subChecked
	bit HAS_SUBSTITUTE_UP, a
	ret nz ; can't freeze through a substitute
	call Random
	cp 50 percent + 1
	ret nc ; 50% of the time: no freeze
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatus
	ld de, wEnemyMonType1
	jr z, .gotTarget
	ld hl, wBattleMonStatus
	ld de, wBattleMonType1
.gotTarget
	ld a, [hl]
	and a
	ret nz ; single-status: don't freeze an already-statused mon
	ld a, [de]
	cp ICE
	ret z ; Ice-types can't be frozen
	inc de
	ld a, [de]
	cp ICE
	ret z
	set FRZ, [hl]
	ld hl, IceBombFrozeText
	jp PrintText

IceBombFrozeText:
	text_far _FrozenText ; "<TARGET> was frozen solid!"
	text_end

; --- Roll (Snorlax) ---------------------------------------------------------
; After its damage, lowers the USER's OWN Defense by two stages (floored at -6).
; StatModifierDownEffect always targets the opponent, so the drop + recalc are
; done manually here (same shape as WebCannonEffect's Speed drop). The live stat
; is refreshed through the argless RecalcSelfStats trampoline back in Battle Core.
RollEffect_:
	ldh a, [hWhoseTurn]
	and a
	ld hl, wPlayerMonStatMods + 1 ; player attacking -> lower player's own Defense
	jr z, .gotDefMod
	ld hl, wEnemyMonStatMods + 1
.gotDefMod
	ld a, [hl]
	cp 1
	ret z ; already at -6, can't lower further
	cp 3
	jr nc, .noClamp ; old >= 3 -> old-2 stays >= 1
	ld a, 3 ; old is 2 -> treat as 3 so the result floors at -6 (1)
.noClamp
	sub 2
	ld [hl], a
	callfar RecalcSelfStats ; recompute the acting mon's own live stats
	ld hl, RollDefenseFellText
	jp PrintText

RollDefenseFellText:
	text_far _RollDefenseFellText
	text_end

; --- Ice Sculpture (Jynx) ---------------------------------------------------
; Makes a normal Substitute, then flags it as a "frost" Substitute for this side
; so FrostSubstituteFreezeCheck can freeze anything that damages it.
; SubstituteEffect_ clears the flag at its start, so it must be set afterward.
IceSculptureEffect_:
	farcall SubstituteEffect_
	ldh a, [hWhoseTurn]
	and a
	ld hl, wPlayerFrostSubstitute
	jr z, .gotFlag
	ld hl, wEnemyFrostSubstitute
.gotFlag
	ld [hl], 1
	ret

; --- Ice Sculpture's frost-Substitute freeze (called from AttackSubstitute) --
; If the Substitute that just took damage is a frost Substitute, the attacker has
; a 50% chance to be frozen. hWhoseTurn is the attacker; the damaged Substitute
; belongs to the defender (the opposite side). Already-statused/Ice-type attackers
; are immune. The flag stays set while the Substitute stands, so every hit rolls.
FrostSubstituteFreezeCheck:
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyFrostSubstitute ; player attacking -> the enemy's sub was hit
	jr z, .gotFlag
	ld hl, wPlayerFrostSubstitute ; enemy attacking -> the player's sub was hit
.gotFlag
	ld a, [hl]
	and a
	ret z ; not a frost Substitute
	call Random
	cp 50 percent + 1
	ret nc ; 50% of the time: no freeze
	ldh a, [hWhoseTurn]
	and a
	jr nz, .freezeEnemy
; the attacker is the player's mon
	ld a, [wBattleMonStatus]
	and a
	ret nz ; single-status: skip if already statused
	ld a, [wBattleMonType1]
	cp ICE
	ret z ; Ice-types can't be frozen
	ld a, [wBattleMonType2]
	cp ICE
	ret z
	ld a, [wBattleMonStatus]
	or 1 << FRZ
	ld [wBattleMonStatus], a
	ld hl, FrostSubstituteFrozeText
	jp PrintText
.freezeEnemy
; the attacker is the enemy's mon
	ld a, [wEnemyMonStatus]
	and a
	ret nz
	ld a, [wEnemyMonType1]
	cp ICE
	ret z
	ld a, [wEnemyMonType2]
	cp ICE
	ret z
	ld a, [wEnemyMonStatus]
	or 1 << FRZ
	ld [wEnemyMonStatus], a
	ld hl, FrostSubstituteFrozeText
	jp PrintText

FrostSubstituteFrozeText:
	text_far _FrostSubstituteFrozeText ; "<USER> was frozen solid!"
	text_end

; --- Glitter Wing (Butterfree) -----------------------------------------------
; After its 35-power Bug damage, a ~30% chance to put the target to sleep.
; Honors the single-status rule (no Gen 1 type is immune to sleep). Sleep is a
; 1-7 turn counter (SLP_MASK), not a single status bit, so it's rolled and
; written directly like vanilla SleepEffect -- just re-hosted on the home
; Random call since this body is floated to a different bank.
GlitterWingEffect_:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wEnemyBattleStatus2]
	jr z, .subChecked
	ld a, [wPlayerBattleStatus2]
.subChecked
	bit HAS_SUBSTITUTE_UP, a
	ret nz ; can't sleep through a substitute
	call Random
	cp 30 percent + 1
	ret nc ; 70% of the time: no sleep
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatus
	jr z, .gotTarget
	ld hl, wBattleMonStatus
.gotTarget
	ld a, [hl]
	and a
	ret nz ; single-status: don't sleep an already-statused mon
.setSleepCounter
	call Random
	and SLP_MASK
	jr z, .setSleepCounter
	ld [hl], a ; single-status: sleep counter replaces the (empty) status byte
	ld hl, GlitterWingFellAsleepText
	jp PrintText

GlitterWingFellAsleepText:
	text_far _FellAsleepText
	text_end
