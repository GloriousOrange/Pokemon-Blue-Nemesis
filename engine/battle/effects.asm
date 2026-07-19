JumpMoveEffect:
	call _JumpMoveEffect
	ld b, $1
	ret

_JumpMoveEffect:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .next
	ld a, [wEnemyMoveEffect]
.next
	dec a ; subtract 1, there is no special effect for 00
	add a ; x2, 16bit pointers
	ld hl, MoveEffectPointerTable
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl ; jump to special effect handler

INCLUDE "data/moves/effects_pointers.asm"

SleepEffect:
	ld de, wEnemyMonStatus
	ld bc, wEnemyBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jp z, .sleepEffect
	ld de, wBattleMonStatus
	ld bc, wPlayerBattleStatus2

.sleepEffect
	ld a, [bc]
	bit NEEDS_TO_RECHARGE, a ; does the target need to recharge? (hyper beam)
	res NEEDS_TO_RECHARGE, a ; target no longer needs to recharge
	ld [bc], a
	jr nz, .setSleepCounter ; if the target had to recharge, all hit tests will be skipped
	                        ; including the event where the target already has another status
	ld a, [de]
	ld b, a
	and SLP_MASK
	jr z, .notAlreadySleeping ; can't affect a mon that is already asleep
	ld hl, AlreadyAsleepText
	jp PrintText
.notAlreadySleeping
	push de
	call MoveHitTest ; apply accuracy tests
	pop de
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
.setSleepCounter
; set target's sleep counter to a random number between 1 and 7
	call BattleRandom
	and SLP_MASK
	jr z, .setSleepCounter
; Nemesis: OR the counter in so an existing PSN/BRN/FRZ/PAR status is preserved
	ld b, a
	ld a, [de]
	and %11111000
	or b
	ld [de], a
	call PlayCurrentMoveAnimation2
	ld hl, FellAsleepText
	jp PrintText
.didntAffect
	jp PrintDidntAffectText

FellAsleepText:
	text_far _FellAsleepText
	text_end

AlreadyAsleepText:
	text_far _AlreadyAsleepText
	text_end

PoisonEffect:
	ld hl, wEnemyMonStatus
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .poisonEffect
	ld hl, wBattleMonStatus
	ld de, wEnemyMoveEffect
.poisonEffect
	call CheckTargetSubstitute
	jp nz, .noEffect ; can't poison a substitute target
	ld a, [hli]
	ld b, a
	bit PSN, a
	jp nz, .noEffect ; Nemesis: only skip if already poisoned; other statuses can stack
	ld a, [hli]
	cp POISON ; can't poison a poison-type target
	jr z, .noEffect
	ld a, [hld]
	cp POISON ; can't poison a poison-type target
	jr z, .noEffect
	ld a, [de]
	cp POISON_SIDE_EFFECT1
	ld b, 20 percent + 1 ; chance of poisoning
	jr z, .sideEffectTest
	cp POISON_SIDE_EFFECT2
	jr nz, .notSideEffect2
	ld b, 40 percent + 1 ; chance of poisoning (Smog / Sludge)
; Twineedle's effect was swapped to POISON_SIDE_EFFECT2 above, but it gets a
; higher poison chance than Smog/Sludge: 50%.
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .gotPoisonMoveNum
	ld a, [wEnemyMoveNum]
.gotPoisonMoveNum
	cp TWINEEDLE
	jr nz, .sideEffectTest
	ld b, 50 percent + 1 ; Twineedle poison chance
	jr .sideEffectTest
.notSideEffect2
	push hl
	push de
	call MoveHitTest ; apply accuracy tests
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
	jr .inflictPoison
.sideEffectTest
	call BattleRandom
	cp b ; was side effect successful?
	ret nc
.inflictPoison
	dec hl
	set PSN, [hl]
	push de
	dec de
	ldh a, [hWhoseTurn]
	and a
	ld b, SHAKE_SCREEN_ANIM
	ld hl, wPlayerBattleStatus3
	ld a, [de]
	ld de, wPlayerToxicCounter
	jr nz, .ok
	ld b, ENEMY_HUD_SHAKE_ANIM
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
.ok
	cp TOXIC
	jr nz, .normalPoison ; done if move is not Toxic
	set BADLY_POISONED, [hl] ; else set Toxic battstatus
	xor a
	ld [de], a
	ld hl, BadlyPoisonedText
	jr .continue
.normalPoison
	res BADLY_POISONED, [hl] ; a fresh poisoning must not inherit a stale Toxic multiplier from an earlier battle
	xor a
	ld [de], a ; reset the toxic counter too
	ld hl, PoisonedText
.continue
	pop de
	ld a, [de]
	cp POISON_EFFECT
	jr z, .regularPoisonEffect
	ld a, b
	call PlayBattleAnimation2
	jp PrintText
.regularPoisonEffect
	call PlayCurrentMoveAnimation2
	jp PrintText
.noEffect
	ld a, [de]
	cp POISON_EFFECT
	ret nz
.didntAffect
	ld c, 50
	call DelayFrames
	jp PrintDidntAffectText

PoisonedText:
	text_far _PoisonedText
	text_end

BadlyPoisonedText:
	text_far _BadlyPoisonedText
	text_end

; Nemesis: Carrion Wind (Miasma's signature). On ANY accurate hit it flinches the
; target; then it badly-poisons the target unless the target is a Poison-type.
; Combined with its guaranteed-first priority (turn-order code), the flinch makes
; the target lose its turn. Statuses stack, so no "already statused" check.
CarrionWindEffect:
	call CheckTargetSubstitute
	jr nz, .didntAffect ; can't flinch or poison through a substitute
	call MoveHitTest ; accuracy test
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
; hit -> flinch the target unconditionally
	ld hl, wEnemyBattleStatus1 ; player attacking -> flinch the enemy
	ldh a, [hWhoseTurn]
	and a
	jr z, .gotFlinchTarget
	ld hl, wPlayerBattleStatus1 ; enemy attacking -> flinch the player
.gotFlinchTarget
	set FLINCHED, [hl]
	call ClearHyperBeam
; then badly-poison the target unless it is Poison-type
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatus
	ld de, wEnemyBattleStatus3
	ld bc, wEnemyToxicCounter
	jr z, .gotPoisonTarget
	ld hl, wBattleMonStatus
	ld de, wPlayerBattleStatus3
	ld bc, wPlayerToxicCounter
.gotPoisonTarget
	inc hl
	ld a, [hli] ; type 1 (status byte skipped)
	cp POISON
	jr z, .poisonImmune
	ld a, [hl] ; type 2
	cp POISON
	jr z, .poisonImmune
	dec hl
	dec hl ; hl -> status byte
	set PSN, [hl]
	ld a, [de]
	set BADLY_POISONED, a
	ld [de], a
	xor a
	ld [bc], a ; reset the toxic counter for a fresh badly-poison
	call PlayCurrentMoveAnimation2
	ld hl, BadlyPoisonedText
	jp PrintText
.poisonImmune ; still flinched, just no poison
	call PlayCurrentMoveAnimation2
	ret
.didntAffect
	jp PrintDidntAffectText

; Nemesis: Chaos Sting (Beedrill's lv38). A 70-power Bug attack that, after its
; normal damage, has a 30% chance to inflict ONE random non-volatile status:
; poison, burn, freeze, or paralysis -- never sleep. Honors the multi-status
; system (ORs the chosen bit, never re-applies a status already present) and the
; usual type immunities (Poison can't be poisoned, Fire can't be burned). Being
; a damaging move whose effect is NOT in the SpecialEffects list, this runs
; after damage is dealt, same dispatch path as Body Slam's paralysis chance.
ChaosStingEffect:
	call CheckTargetSubstitute
	ret nz ; can't status a substitute
	call BattleRandom
	cp 30 percent + 1
	ret nc ; 70% of the time, no bonus status
; point hl at the target's status byte and de at its type1
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatus
	ld de, wEnemyMonType1
	jr z, .gotTarget
	ld hl, wBattleMonStatus
	ld de, wBattleMonType1
.gotTarget
	bit FRZ, [hl]
	ret nz ; a frozen target is already fully locked; don't layer onto freeze
; roll the ailment: 0 = poison, 1 = burn, 2 = freeze, 3 = paralysis
	call BattleRandom
	and $03
	jr z, .poison
	dec a
	jr z, .burn
	dec a
	jp z, .freeze
	jp .paralyze
.poison
	bit PSN, [hl]
	ret nz ; already poisoned
	ld a, [de]
	cp POISON
	ret z ; Poison-type is immune
	inc de
	ld a, [de]
	cp POISON
	ret z
	set PSN, [hl]
	call ChaosStingResetToxic ; regular (not badly-) poison: clear stale Toxic state
	ld hl, PoisonedText
	jp PrintText
.burn
	bit BRN, [hl]
	ret nz ; already burned
	ld a, [de]
	cp FIRE
	ret z ; Fire-type is immune
	inc de
	ld a, [de]
	cp FIRE
	ret z
	set BRN, [hl]
	call HalveAttackDueToBurn
	ld hl, BurnedText
	jp PrintText
.freeze
	call ClearHyperBeam ; a freshly frozen mon drops any Hyper Beam recharge
	set FRZ, [hl]
	ld hl, FrozenText
	jp PrintText
.paralyze
	bit PAR, [hl]
	ret nz ; already paralyzed
	set PAR, [hl]
	call QuarterSpeedDueToParalysis
	jp PrintMayNotAttackText

ChaosStingResetToxic:
; clear BADLY_POISONED + the Toxic counter on the target, so a plain poisoning
; from Chaos Sting never inherits a stale Toxic multiplier (mirrors PoisonEffect)
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
	jr z, .ok
	ld hl, wPlayerBattleStatus3
	ld de, wPlayerToxicCounter
.ok
	res BADLY_POISONED, [hl]
	xor a
	ld [de], a
	ret

; Nemesis: Hot Oil (Magmar's lv36). A 40-power Fire attack that, after its
; normal damage, ALWAYS burns the target (unless it's a Fire-type or already
; burned). Like Chaos Sting's burn branch but guaranteed, no random roll. Being
; a damaging move whose effect is NOT in the SpecialEffects list, this runs
; after damage, same dispatch path as Body Slam's paralysis chance.
HotOilEffect:
	call CheckTargetSubstitute
	ret nz ; can't burn through a substitute
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyMonStatus
	ld de, wEnemyMonType1
	jr z, .gotTarget
	ld hl, wBattleMonStatus
	ld de, wBattleMonType1
.gotTarget
	bit BRN, [hl]
	ret nz ; already burned
	ld a, [de]
	cp FIRE
	ret z ; Fire-type is immune to burn
	inc de
	ld a, [de]
	cp FIRE
	ret z
	set BRN, [hl]
	call HalveAttackDueToBurn
	ld hl, BurnedText
	jp PrintText

DrainHPEffect:
	jpfar DrainHPEffect_

ExplodeEffect:
	ld hl, wBattleMonHP
	ld de, wPlayerBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .faintUser
	ld hl, wEnemyMonHP
	ld de, wEnemyBattleStatus2
.faintUser
	xor a
	ld [hli], a ; set the mon's HP to 0
	ld [hli], a
	inc hl
	ld [hl], a ; set mon's status to 0
	ld a, [de]
	res SEEDED, a ; clear mon's leech seed status
	ld [de], a
	ret

FreezeBurnParalyzeEffect:
	xor a
	ld [wAnimationType], a
	call CheckTargetSubstitute
	ret nz ; return if they have a substitute, can't effect them
	ldh a, [hWhoseTurn]
	and a
	jp nz, .opponentAttacker
	ld a, [wEnemyMonStatus]
	and 1 << FRZ
	jp nz, CheckDefrost ; Nemesis: only a frozen target short-circuits (thaw on fire); other statuses stack
	ld a, [wPlayerMoveType]
	ld b, a
	ld a, [wEnemyMonType1]
	cp b ; do target type 1 and move type match?
	ret z  ; return if they match (an ice move can't freeze an ice-type, body slam can't paralyze a normal-type, etc.)
	ld a, [wEnemyMonType2]
	cp b ; do target type 2 and move type match?
	ret z  ; return if they match
	ld a, [wPlayerMoveEffect]
	cp PARALYZE_SIDE_EFFECT1 + 1
	ld b, 10 percent + 1
	jr c, .regular_effectiveness
; extra effectiveness
	ld b, 30 percent + 1
	ASSERT PARALYZE_SIDE_EFFECT2 - PARALYZE_SIDE_EFFECT1 == BURN_SIDE_EFFECT2 - BURN_SIDE_EFFECT1
	ASSERT PARALYZE_SIDE_EFFECT2 - PARALYZE_SIDE_EFFECT1 == FREEZE_SIDE_EFFECT2 - FREEZE_SIDE_EFFECT1
	sub PARALYZE_SIDE_EFFECT2 - PARALYZE_SIDE_EFFECT1 ; treat extra effective as regular from now on
.regular_effectiveness
	push af
	call BattleRandom ; get random 8bit value for probability test
	cp b
	pop bc
	ret nc ; do nothing if random value is >= 1A or 4D [no status applied]
	ld a, b ; what type of effect is this?
	cp BURN_SIDE_EFFECT1
	jr z, .burn1
	cp FREEZE_SIDE_EFFECT1
	jr z, .freeze1
; paralyze1
	ld a, [wEnemyMonStatus]
	bit PAR, a
	ret nz ; Nemesis: already paralyzed -> don't re-apply (would re-quarter speed)
	or 1 << PAR
	ld [wEnemyMonStatus], a
	call QuarterSpeedDueToParalysis ; quarter speed of affected mon
	ld a, ENEMY_HUD_SHAKE_ANIM
	call PlayBattleAnimation
	jp PrintMayNotAttackText ; print paralysis text
.burn1
	ld a, [wEnemyMonStatus]
	bit BRN, a
	ret nz ; Nemesis: already burned -> don't re-apply (would re-halve attack)
	or 1 << BRN
	ld [wEnemyMonStatus], a
	call HalveAttackDueToBurn ; halve attack of affected mon
	ld a, ENEMY_HUD_SHAKE_ANIM
	call PlayBattleAnimation
	ld hl, BurnedText
	jp PrintText
.freeze1
	call ClearHyperBeam ; resets hyper beam (recharge) condition from target
	ld a, [wEnemyMonStatus]
	or 1 << FRZ
	ld [wEnemyMonStatus], a
	ld a, ENEMY_HUD_SHAKE_ANIM
	call PlayBattleAnimation
	ld hl, FrozenText
	jp PrintText
.opponentAttacker
	ld a, [wBattleMonStatus] ; mostly same as above with addresses swapped for opponent
	and 1 << FRZ
	jp nz, CheckDefrost ; Nemesis: only a frozen target short-circuits; other statuses stack
	ld a, [wEnemyMoveType]
	ld b, a
	ld a, [wBattleMonType1]
	cp b
	ret z
	ld a, [wBattleMonType2]
	cp b
	ret z
	ld a, [wEnemyMoveEffect]
	cp PARALYZE_SIDE_EFFECT1 + 1
	ld b, 10 percent + 1
	jr c, .regular_effectiveness2
; extra effectiveness
	ld b, 30 percent + 1
	sub BURN_SIDE_EFFECT2 - BURN_SIDE_EFFECT1 ; treat extra effective as regular from now on
.regular_effectiveness2
	push af
	call BattleRandom
	cp b
	pop bc
	ret nc
	ld a, b
	cp BURN_SIDE_EFFECT1
	jr z, .burn2
	cp FREEZE_SIDE_EFFECT1
	jr z, .freeze2
; paralyze2
	ld a, [wBattleMonStatus]
	bit PAR, a
	ret nz ; Nemesis: already paralyzed -> don't re-apply (would re-quarter speed)
	or 1 << PAR
	ld [wBattleMonStatus], a
	call QuarterSpeedDueToParalysis
	jp PrintMayNotAttackText
.burn2
	ld a, [wBattleMonStatus]
	bit BRN, a
	ret nz ; Nemesis: already burned -> don't re-apply (would re-halve attack)
	or 1 << BRN
	ld [wBattleMonStatus], a
	call HalveAttackDueToBurn
	ld hl, BurnedText
	jp PrintText
.freeze2
; hyper beam bits aren't reset for opponent's side
	ld a, [wBattleMonStatus]
	or 1 << FRZ
	ld [wBattleMonStatus], a
	ld hl, FrozenText
	jp PrintText

BurnedText:
	text_far _BurnedText
	text_end

FrozenText:
	text_far _FrozenText
	text_end

CheckDefrost:
; any fire-type move that has a chance inflict burn (all but Fire Spin) will defrost a frozen target
	and 1 << FRZ ; are they frozen?
	ret z ; return if so
	ldh a, [hWhoseTurn]
	and a
	jr nz, .opponent
	;player [attacker]
	ld a, [wPlayerMoveType]
	sub FIRE
	ret nz ; return if type of move used isn't fire
	ld [wEnemyMonStatus], a ; set opponent status to 00 ["defrost" a frozen monster]
	ld hl, wEnemyMon1Status
	ld a, [wEnemyMonPartyPos]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	xor a
	ld [hl], a ; clear status in roster
	ld hl, FireDefrostedText
	jr .common
.opponent
	ld a, [wEnemyMoveType] ; same as above with addresses swapped
	sub FIRE
	ret nz
	ld [wBattleMonStatus], a
	ld hl, wPartyMon1Status
	ld a, [wPlayerMonNumber]
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	xor a
	ld [hl], a
	ld hl, FireDefrostedText
.common
	jp PrintText

FireDefrostedText:
	text_far _FireDefrostedText
	text_end

SuperInstinctEffect:
; Nemesis (Hitmonlee lv22): raise the user's own accuracy AND evasion by one
; stage each. Runs the standard +1 stat-up routine twice, once per stat --
; StatModifierUpEffect picks which stat from the move-effect byte, so we point
; it at ACCURACY_UP1_EFFECT then EVASION_UP1_EFFECT. Clobbering that byte is
; safe: it's reloaded from the move data at the start of each turn. The two
; calls also give two "rose!" messages/animations, which reads clearly.
	ldh a, [hWhoseTurn]
	and a
	ld hl, wPlayerMoveEffect
	jr z, .gotEffectPtr
	ld hl, wEnemyMoveEffect
.gotEffectPtr
	ld [hl], ACCURACY_UP1_EFFECT
	push hl
	call StatModifierUpEffect
	pop hl
	ld [hl], EVASION_UP1_EFFECT
	jp StatModifierUpEffect

CrystallizeEffect:
; Nemesis (Beedrill lv22): Harden-style self-buff that raises the user's own
; Defense by two stages and Special by one. Same twice-through-the-stat-up-
; routine trick as SuperInstinctEffect: point the move-effect byte at
; DEFENSE_UP2_EFFECT, then SPECIAL_UP1_EFFECT. The byte is reloaded from the
; move data each turn, so clobbering it here is safe.
	ldh a, [hWhoseTurn]
	and a
	ld hl, wPlayerMoveEffect
	jr z, .gotEffectPtr
	ld hl, wEnemyMoveEffect
.gotEffectPtr
	ld [hl], DEFENSE_UP2_EFFECT
	push hl
	call StatModifierUpEffect
	pop hl
	ld [hl], SPECIAL_UP1_EFFECT
	jp StatModifierUpEffect

RecalcModifiedStatsFor:
; Nemesis bug fix for the vanilla "badge boost" bug. Recompute ONE mon's four
; battle stats from its UNMODIFIED base using the current stat-stage mods, then
; re-apply the burn/paralysis penalty and (player only) badge boosts exactly
; once -- the same sequence used when a mon is sent out. Vanilla instead re-ran
; ApplyBadgeStatBoosts and the status penalties directly on the live, already-
; boosted stats after every stat-changing move, so badge boosts (and burn/para
; penalties) compounded on every stat the move didn't touch.
;   a = 0 -> recalc the player's mon, nonzero -> recalc the enemy's mon
	ld [wCalculateWhoseStats], a
	ldh a, [hWhoseTurn]
	push af ; ApplyBurnAndParalysisPenaltiesTo* overwrite hWhoseTurn; preserve it
	call CalculateModifiedStats
	ld a, [wCalculateWhoseStats]
	and a
	jr nz, .enemyMon
	call ApplyBurnAndParalysisPenaltiesToPlayer
	call ApplyBadgeStatBoosts ; badges only ever boost the player's mon
	jr .done
.enemyMon
	call ApplyBurnAndParalysisPenaltiesToEnemy
.done
	pop af
	ldh [hWhoseTurn], a
	ret

StatModifierUpEffect:
	ld hl, wPlayerMonStatMods
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .statModifierUpEffect
	ld hl, wEnemyMonStatMods
	ld de, wEnemyMoveEffect
.statModifierUpEffect
	ld a, [de]
	sub ATTACK_UP1_EFFECT
	cp EVASION_UP1_EFFECT + $3 - ATTACK_UP1_EFFECT ; covers all +1 effects
	jr c, .incrementStatMod
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to equivalent +1 effect
.incrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	inc b ; increment corresponding stat mod
	ld a, $d
	cp b ; can't raise stat past +6 ($d or 13)
	jp c, PrintNothingHappenedText
	ld a, [de]
	cp ATTACK_UP1_EFFECT + $8 ; is it a +2 effect?
	jr c, .ok
	inc b ; if so, increment stat mod again
	ld a, $d
	cp b ; unless it's already +6
	jr nc, .ok
	ld b, a
.ok
	ld [hl], b
	ld a, c
	cp $4
	jr nc, UpdateStatDone ; jump if mod affected is evasion/accuracy
	push hl
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
	ldh a, [hWhoseTurn]
	and a
	jr z, .pointToStats
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
.pointToStats
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .checkIf999
	inc d ; de = unmodified (original) stat
.checkIf999
	pop bc
	; check if stat is already 999
	ld a, [hld]
	sub LOW(MAX_STAT_VALUE)
	jr nz, .recalculateStat
	ld a, [hl]
	sbc HIGH(MAX_STAT_VALUE)
	jp z, RestoreOriginalStatModifier
.recalculateStat ; recalculate affected stat
                 ; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ldh [hMultiplicand], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply
	ld a, [hl]
	ldh [hDivisor], a
	ld b, $4
	call Divide
	pop hl
; cap at MAX_STAT_VALUE (999)
	ldh a, [hProduct + 3]
	sub LOW(MAX_STAT_VALUE)
	ldh a, [hProduct + 2]
	sbc HIGH(MAX_STAT_VALUE)
	jp c, UpdateStat
	ld a, HIGH(MAX_STAT_VALUE)
	ldh [hMultiplicand + 1], a
	ld a, LOW(MAX_STAT_VALUE)
	ldh [hMultiplicand + 2], a

UpdateStat:
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	pop hl
UpdateStatDone:
	ld b, c
	inc b
	call PrintStatText
	ld hl, wPlayerBattleStatus2
	ld de, wPlayerMoveNum
	ld bc, wPlayerMonMinimized
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerTurn
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMoveNum
	ld bc, wEnemyMonMinimized
.playerTurn
	ld a, [de]
	cp MINIMIZE
	jr nz, .notMinimize
 ; if a substitute is up, slide off the substitute and show the mon pic before
 ; playing the minimize animation
	bit HAS_SUBSTITUTE_UP, [hl]
	push af
	push bc
	ld hl, HideSubstituteShowMonAnim
	ld b, BANK(HideSubstituteShowMonAnim)
	push de
	call nz, Bankswitch
	pop de
.notMinimize
	call PlayCurrentMoveAnimation
	ld a, [de]
	cp MINIMIZE
	jr nz, .applyBadgeBoostsAndStatusPenalties
	pop bc
	ld a, $1
	ld [bc], a
	ld hl, ReshowSubstituteAnim
	ld b, BANK(ReshowSubstituteAnim)
	pop af
	call nz, Bankswitch
.applyBadgeBoostsAndStatusPenalties
	ld hl, MonsStatsRoseText
	call PrintText
; Nemesis bug fix: cleanly recompute the buffed mon's stats from its unmodified
; base (badge boosts + burn/para penalty applied once) instead of re-multiplying
; them onto the live stats. The buffed mon is the one whose turn it is.
	ldh a, [hWhoseTurn]
	jp RecalcModifiedStatsFor

RestoreOriginalStatModifier:
	pop hl
	dec [hl]

PrintNothingHappenedText:
	ld hl, NothingHappenedText
	jp PrintText

MonsStatsRoseText:
	text_far _MonsStatsRoseText
	text_asm
	ld hl, GreatlyRoseText
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .playerTurn
	ld a, [wEnemyMoveEffect]
.playerTurn
	cp ATTACK_DOWN1_EFFECT
	ret nc
	ld hl, RoseText
	ret

GreatlyRoseText:
	text_pause
	text_far _GreatlyRoseText
; fallthrough
RoseText:
	text_far _RoseText
	text_end

StatModifierDownEffect:
	ld hl, wEnemyMonStatMods
	ld de, wPlayerMoveEffect
	ld bc, wEnemyBattleStatus1
	ldh a, [hWhoseTurn]
	and a
	jr z, .statModifierDownEffect
	ld hl, wPlayerMonStatMods
	ld de, wEnemyMoveEffect
	ld bc, wPlayerBattleStatus1
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .statModifierDownEffect
	call BattleRandom
	cp 25 percent + 1 ; chance to miss by in regular battle
	jp c, MoveMissed
.statModifierDownEffect
	call CheckTargetSubstitute ; can't hit through substitute
	jp nz, MoveMissed
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	jr c, .nonSideEffect
	call BattleRandom
	cp 33 percent + 1 ; chance for side effects
	jp nc, CantLowerAnymore
	ld a, [de]
	sub ATTACK_DOWN_SIDE_EFFECT ; map each stat to 0-3
	jr .decrementStatMod
.nonSideEffect ; non-side effects only
	push hl
	push de
	push bc
	call MoveHitTest ; apply accuracy tests
	pop bc
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jp nz, MoveMissed
	ld a, [bc]
	bit INVULNERABLE, a ; fly/dig
	jp nz, MoveMissed
; WEB_CANNON: custom Bug move -- drops target Speed to the minimum (-6) in one hit.
; Special-cased here so the generic -1/-2 path below is left untouched. Once the
; target is already at -6, it falls through to CantLowerAnymore instead of
; re-applying endlessly.
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .gotMoveNumForWebCannon
	ld a, [wEnemyMoveNum]
.gotMoveNumForWebCannon
	cp WEB_CANNON
	jr nz, .notWebCannon
	ld c, 2 ; SPEED stat-mod index
	ld b, $0
	add hl, bc ; hl -> target's Speed stat mod
	ld a, [hl]
	cp 2 ; already at -6 (mod stored as 1)?
	jp c, CantLowerAnymore ; if so, don't keep "lowering" it
	ld b, 1 ; drop Speed to the minimum (-6) in one hit
	ld c, 2 ; ensure SPEED index for the stat recalc below
	jr .ok
.notWebCannon
	ld a, [de]
	sub ATTACK_DOWN1_EFFECT
	cp EVASION_DOWN1_EFFECT + $3 - ATTACK_DOWN1_EFFECT ; covers all -1 effects
	jr c, .decrementStatMod
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map -2 effects to corresponding -1 effect
.decrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	dec b ; dec corresponding stat mod
	jp z, CantLowerAnymore ; if stat mod is 1 (-6), can't lower anymore
	ld a, [de]
	cp ATTACK_DOWN2_EFFECT - $16 ; $24
	jr c, .ok
	cp ATTACK_DOWN_SIDE_EFFECT ; move side effects, stat mod decrease is always 1
	jr nc, .ok
	dec b ; stat down 2 effects only (dec mod again)
	jr nz, .ok
	inc b ; increment mod to 1 (-6) if it would become 0 (-7)
.ok
	ld [hl], b ; save modified mod
	ld a, c
	cp $4
	jr nc, UpdateLoweredStatDone ; jump for evasion/accuracy
	push hl
	push de
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
	ldh a, [hWhoseTurn]
	and a
	jr z, .pointToStat
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
.pointToStat
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .noCarry
	inc d ; de = unmodified stat
.noCarry
	pop bc
	ld a, [hld]
	sub $1 ; can't lower stat below 1 (-6)
	jr nz, .recalculateStat
	ld a, [hl]
	and a
	jp z, CantLowerAnymore_Pop
.recalculateStat
; recalculate affected stat
; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ldh [hMultiplicand], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply
	ld a, [hl]
	ldh [hDivisor], a
	ld b, $4
	call Divide
	pop hl
	ldh a, [hProduct + 3]
	ld b, a
	ldh a, [hProduct + 2]
	or b
	jp nz, UpdateLoweredStat
	ldh [hMultiplicand + 1], a
	ld a, $1
	ldh [hMultiplicand + 2], a

UpdateLoweredStat:
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	pop de
	pop hl
UpdateLoweredStatDone:
	ld b, c
	inc b
	push de
	call PrintStatText
	pop de
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT ; for all side effects, move animation has already played, skip it
	jr nc, .ApplyBadgeBoostsAndStatusPenalties
	call PlayCurrentMoveAnimation2
.ApplyBadgeBoostsAndStatusPenalties
	ld hl, MonsStatsFellText
	call PrintText
; Nemesis bug fix: cleanly recompute the debuffed mon's stats from its
; unmodified base (see RecalcModifiedStatsFor). The debuffed mon is the OPPONENT
; of whoever used the move.
	ldh a, [hWhoseTurn]
	and a
	ld a, 1 ; player used the move -> the enemy mon was debuffed
	jr z, .recalcLoweredMon
	xor a ; enemy used the move -> the player's mon was debuffed
.recalcLoweredMon
	jp RecalcModifiedStatsFor

CantLowerAnymore_Pop:
	pop de
	pop hl
	inc [hl]

CantLowerAnymore:
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	ret nc
	ld hl, NothingHappenedText
	jp PrintText

MoveMissed:
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	ret nc
	jp ConditionalPrintButItFailed

MonsStatsFellText:
	text_far _MonsStatsFellText
	text_asm
	ld hl, FellText
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .playerTurn
	ld a, [wEnemyMoveEffect]
.playerTurn
; check if the move's effect decreases a stat by 2
	cp BIDE_EFFECT
	ret c
	cp ATTACK_DOWN_SIDE_EFFECT
	ret nc
	ld hl, GreatlyFellText
	ret

GreatlyFellText:
	text_pause
	text_far _GreatlyFellText
; fallthrough
FellText:
	text_far _FellText
	text_end

PrintStatText:
	ld hl, StatModTextStrings
	ld c, '@'
.findStatName_outer
	dec b
	jr z, .foundStatName
.findStatName_inner
	ld a, [hli]
	cp c
	jr z, .findStatName_outer
	jr .findStatName_inner
.foundStatName
	ld de, wStringBuffer
	ld bc, STAT_NAME_LENGTH
	jp CopyData

INCLUDE "data/battle/stat_mod_names.asm"

INCLUDE "data/battle/stat_modifiers.asm"

BideEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerBideAccumulatedDamage
	ld bc, wPlayerNumAttacksLeft
	ldh a, [hWhoseTurn]
	and a
	jr z, .bideEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyBideAccumulatedDamage
	ld bc, wEnemyNumAttacksLeft
.bideEffect
	set STORING_ENERGY, [hl] ; mon is now using bide
	xor a
	ld [de], a
	inc de
	ld [de], a
	ld [wPlayerMoveEffect], a
	ld [wEnemyMoveEffect], a
	call BattleRandom
	and $1
	inc a
	inc a
	ld [bc], a ; set Bide counter to 2 or 3 at random
	ldh a, [hWhoseTurn]
	add XSTATITEM_ANIM
	jp PlayBattleAnimation2

ThrashPetalDanceEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ldh a, [hWhoseTurn]
	and a
	jr z, .thrashPetalDanceEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.thrashPetalDanceEffect
	set THRASHING_ABOUT, [hl] ; mon is now using thrash/petal dance
	call BattleRandom
	and $1
	inc a
	inc a
	ld [de], a ; set thrash/petal dance counter to 2 or 3 at random
	ldh a, [hWhoseTurn]
	add SHRINKING_SQUARE_ANIM
	jp PlayBattleAnimation2

SwitchAndTeleportEffect:
	ldh a, [hWhoseTurn]
	and a
	jr nz, .handleEnemy
	ld a, [wIsInBattle]
	dec a
	jr nz, .notWildBattle1
	ld a, [wCurEnemyLevel]
	ld b, a
	ld a, [wBattleMonLevel]
	cp b ; is the player's level greater than the enemy's level?
	jr nc, .playerMoveWasSuccessful ; if so, teleport will always succeed
	add b
	ld c, a
	inc c ; c = playerLevel + enemyLevel + 1
.rejectionSampleLoop1
	call BattleRandom
	cp c ; get a random number between 0 and c
	jr nc, .rejectionSampleLoop1
	srl b
	srl b  ; b = enemyLevel / 4
	cp b ; is rand[0, playerLevel + enemyLevel] >= (enemyLevel / 4)?
	jr nc, .playerMoveWasSuccessful ; if so, allow teleporting
	ld c, 50
	call DelayFrames
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp PrintButItFailedText_
.playerMoveWasSuccessful
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wPlayerMoveNum]
	jr .playAnimAndPrintText
.notWildBattle1
	ld c, 50
	call DelayFrames
	ld hl, IsUnaffectedText
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, PrintText
	jp PrintButItFailedText_
.handleEnemy
	ld a, [wIsInBattle]
	dec a
	jr nz, .notWildBattle2
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wCurEnemyLevel]
	cp b
	jr nc, .enemyMoveWasSuccessful
	add b
	ld c, a
	inc c
.rejectionSampleLoop2
	call BattleRandom
	cp c
	jr nc, .rejectionSampleLoop2
	srl b
	srl b
	cp b
	jr nc, .enemyMoveWasSuccessful
	ld c, 50
	call DelayFrames
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp PrintButItFailedText_
.enemyMoveWasSuccessful
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wEnemyMoveNum]
	jr .playAnimAndPrintText
.notWildBattle2
	ld c, 50
	call DelayFrames
	ld hl, IsUnaffectedText
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, PrintText
	jp ConditionalPrintButItFailed
.playAnimAndPrintText
	push af
	call PlayBattleAnimation
	ld c, 20
	call DelayFrames
	pop af
	ld hl, RanFromBattleText
	cp TELEPORT
	jr z, .printText
	ld hl, RanAwayScaredText
	cp ROAR
	jr z, .printText
	ld hl, WasBlownAwayText
.printText
	jp PrintText

RanFromBattleText:
	text_far _RanFromBattleText
	text_end

RanAwayScaredText:
	text_far _RanAwayScaredText
	text_end

WasBlownAwayText:
	text_far _WasBlownAwayText
	text_end

TwoToFiveAttacksEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld bc, wPlayerNumHits
	ldh a, [hWhoseTurn]
	and a
	jr z, .twoToFiveAttacksEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
	ld bc, wEnemyNumHits
.twoToFiveAttacksEffect
	bit ATTACKING_MULTIPLE_TIMES, [hl] ; is mon attacking multiple times?
	ret nz
	set ATTACKING_MULTIPLE_TIMES, [hl] ; mon is now attacking multiple times
	ld hl, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .setNumberOfHits
	ld hl, wEnemyMoveEffect
.setNumberOfHits
	ld a, [hl]
	cp TWINEEDLE_EFFECT
	jr z, .twineedle
	cp ATTACK_TWICE_EFFECT
	ld a, $2 ; number of hits it's always 2 for ATTACK_TWICE_EFFECT
	jr z, .saveNumberOfHits
; for TWO_TO_FIVE_ATTACKS_EFFECT 3/8 chance for 2 and 3 hits, and 1/8 chance for 4 and 5 hits
	call BattleRandom
	and $3
	cp $2
	jr c, .gotNumHits
; if the number of hits was greater than 2, re-roll again for a lower chance
	call BattleRandom
	and $3
.gotNumHits
	inc a
	inc a
.saveNumberOfHits
	ld [de], a
	ld [bc], a
	ret
.twineedle
	ld a, POISON_SIDE_EFFECT2
	ld [hl], a ; set Twineedle's effect to poison effect
	ld a, $2 ; Twineedle always hits exactly twice
	jr .saveNumberOfHits

FlinchSideEffect:
	call CheckTargetSubstitute
	ret nz
	ld hl, wEnemyBattleStatus1
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .flinchSideEffect
	ld hl, wPlayerBattleStatus1
	ld de, wEnemyMoveEffect
.flinchSideEffect
	ld a, [de]
	cp FLINCH_SIDE_EFFECT1
	ld b, 10 percent + 1 ; chance of flinch (FLINCH_SIDE_EFFECT1)
	jr z, .gotEffectChance
	ld b, 30 percent + 1 ; chance of flinch otherwise
.gotEffectChance
	call BattleRandom
	cp b
	ret nc
	set FLINCHED, [hl] ; set mon's status to flinching
	call ClearHyperBeam
	ret

OneHitKOEffect:
	jpfar OneHitKOEffect_

ChargeEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	ld b, XSTATITEM_ANIM
	jr z, .chargeEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyMoveEffect
	ld b, XSTATITEM_DUPLICATE_ANIM
.chargeEffect
	set CHARGING_UP, [hl]
	ld a, [de]
	dec de ; de contains enemy or player MOVENUM
	cp FLY_EFFECT
	jr nz, .notFly
	set INVULNERABLE, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, TELEPORT ; load Teleport's animation
.notFly
	ld a, [de]
	cp DIG
	jr nz, .notDigOrFly
	set INVULNERABLE, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, SLIDE_DOWN_ANIM
.notDigOrFly
	xor a
	ld [wAnimationType], a
	ld a, b
	call PlayBattleAnimation
	ld a, [de]
	ld [wChargeMoveNum], a
	ld hl, ChargeMoveEffectText
	jp PrintText

ChargeMoveEffectText:
	text_far _ChargeMoveEffectText
	text_asm
	ld a, [wChargeMoveNum]
	cp RAZOR_WIND
	ld hl, MadeWhirlwindText
	jr z, .gotText
	cp SOLARBEAM
	ld hl, TookInSunlightText
	jr z, .gotText
	cp SKULL_BASH
	ld hl, LoweredItsHeadText
	jr z, .gotText
	cp SKY_ATTACK
	ld hl, SkyAttackGlowingText
	jr z, .gotText
	cp FLY
	ld hl, FlewUpHighText
	jr z, .gotText
	cp DIG
	ld hl, DugAHoleText
.gotText
	ret

MadeWhirlwindText:
	text_far _MadeWhirlwindText
	text_end

TookInSunlightText:
	text_far _TookInSunlightText
	text_end

LoweredItsHeadText:
	text_far _LoweredItsHeadText
	text_end

SkyAttackGlowingText:
	text_far _SkyAttackGlowingText
	text_end

FlewUpHighText:
	text_far _FlewUpHighText
	text_end

DugAHoleText:
	text_far _DugAHoleText
	text_end

TrappingEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ldh a, [hWhoseTurn]
	and a
	jr z, .trappingEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.trappingEffect
	bit USING_TRAPPING_MOVE, [hl]
	ret nz
	call ClearHyperBeam ; since this effect is called before testing whether the move will hit,
                        ; the target won't need to recharge even if the trapping move missed
	set USING_TRAPPING_MOVE, [hl] ; mon is now using a trapping move
	call BattleRandom ; 3/8 chance for 2 and 3 attacks, and 1/8 chance for 4 and 5 attacks
	and $3
	cp $2
	jr c, .setTrappingCounter
	call BattleRandom
	and $3
.setTrappingCounter
	inc a
	ld [de], a
	ret

MistEffect:
	jpfar MistEffect_

FocusEnergyEffect:
	jpfar FocusEnergyEffect_

RecoilEffect:
	jpfar RecoilEffect_

ConfusionSideEffect:
	call BattleRandom
	cp 10 percent ; chance of confusion
	ret nc
	jr ConfusionSideEffectSuccess

ConfusionEffect:
	call CheckTargetSubstitute
	jr nz, ConfusionEffectFailed
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, ConfusionEffectFailed

ConfusionSideEffectSuccess:
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyBattleStatus1
	ld bc, wEnemyConfusedCounter
	ld a, [wPlayerMoveEffect]
	jr z, .confuseTarget
	ld hl, wPlayerBattleStatus1
	ld bc, wPlayerConfusedCounter
	ld a, [wEnemyMoveEffect]
.confuseTarget
	bit CONFUSED, [hl] ; is mon confused?
	jr nz, ConfusionEffectFailed
	set CONFUSED, [hl] ; mon is now confused
	push af
	call BattleRandom
	and $3
	inc a
	inc a
	ld [bc], a ; confusion status will last 2-5 turns
	pop af
	cp CONFUSION_SIDE_EFFECT
	call nz, PlayCurrentMoveAnimation2
	ld hl, BecameConfusedText
	call PrintText
	jp MindFeverBurn ; Nemesis: Mind Fever also burns ("curse"); no-op for other confuse moves

BecameConfusedText:
	text_far _BecameConfusedText
	text_end

ConfusionEffectFailed:
	cp CONFUSION_SIDE_EFFECT
	ret z
	ld c, 50
	call DelayFrames
	jp ConditionalPrintButItFailed

; Nemesis: Mind Fever (Nocturn's signature) burns the target in addition to
; confusing it, and only if the target isn't already burned and isn't a
; Fire-type. Returns immediately for every other confusion move. (Placed after
; ConfusionEffectFailed so it doesn't push that label out of jr range of the
; confusion checks above.)
MindFeverBurn:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .checkMove
	ld a, [wEnemyMoveNum]
.checkMove
	cp MIND_FEVER
	ret nz
	ld hl, wEnemyMonStatus ; player attacking -> burn the enemy
	ldh a, [hWhoseTurn]
	and a
	jr z, .gotTarget
	ld hl, wBattleMonStatus ; enemy attacking -> burn the player
.gotTarget
	ld a, [hli]
	bit BRN, a
	ret nz ; already burned -> skip (would re-halve attack)
	ld a, [hli]
	cp FIRE
	ret z ; Fire-types can't be burned
	ld a, [hl]
	cp FIRE
	ret z
	dec hl
	dec hl ; hl -> target status byte
	set BRN, [hl]
	call HalveAttackDueToBurn
	ld hl, BurnedText
	jp PrintText

ParalyzeEffect:
	jpfar ParalyzeEffect_

SubstituteEffect:
	jpfar SubstituteEffect_

HyperBeamEffect:
	ld hl, wPlayerBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .hyperBeamEffect
	ld hl, wEnemyBattleStatus2
.hyperBeamEffect
	set NEEDS_TO_RECHARGE, [hl] ; mon now needs to recharge
	ret

ClearHyperBeam:
	push hl
	ld hl, wEnemyBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerTurn
	ld hl, wPlayerBattleStatus2
.playerTurn
	res NEEDS_TO_RECHARGE, [hl] ; mon no longer needs to recharge
	pop hl
	ret

RageEffect:
	ld hl, wPlayerBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .player
	ld hl, wEnemyBattleStatus2
.player
	set USING_RAGE, [hl] ; mon is now in "rage" mode
	ret

MimicEffect:
	ld c, 50
	call DelayFrames
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, .mimicMissed
	ldh a, [hWhoseTurn]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerBattleStatus1]
	jr nz, .enemyTurn
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .letPlayerChooseMove
	ld hl, wEnemyMonMoves
	ld a, [wEnemyBattleStatus1]
.enemyTurn
	bit INVULNERABLE, a
	jr nz, .mimicMissed
.getRandomMove
	push hl
	call BattleRandom
	and $3
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .getRandomMove
	ld d, a
	ldh a, [hWhoseTurn]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerMoveListIndex]
	jr z, .playerTurn
	ld hl, wEnemyMonMoves
	ld a, [wEnemyMoveListIndex]
	jr .playerTurn
.letPlayerChooseMove
	ld a, [wEnemyBattleStatus1]
	bit INVULNERABLE, a
	jr nz, .mimicMissed
	ld a, [wCurrentMenuItem]
	push af
	ld a, $1
	ld [wMoveMenuType], a
	call MoveSelectionMenu
	call LoadScreenTilesFromBuffer1
	ld hl, wEnemyMonMoves
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld d, [hl]
	pop af
	ld hl, wBattleMonMoves
.playerTurn
	ld c, a
	ld b, $0
	add hl, bc
	ld a, d
	ld [hl], a
	ld [wNamedObjectIndex], a
	call GetMoveName
	call PlayCurrentMoveAnimation
	ld hl, MimicLearnedMoveText
	jp PrintText
.mimicMissed
	jp PrintButItFailedText_

MimicLearnedMoveText:
	text_far _MimicLearnedMoveText
	text_end

LeechSeedEffect:
	jpfar LeechSeedEffect_

SplashEffect:
	call PlayCurrentMoveAnimation
	jp PrintNoEffectText

DisableEffect:
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, .moveMissed
	ld de, wEnemyDisabledMove
	ld hl, wEnemyMonMoves
	ldh a, [hWhoseTurn]
	and a
	jr z, .disableEffect
	ld de, wPlayerDisabledMove
	ld hl, wBattleMonMoves
.disableEffect
; no effect if target already has a move disabled
	ld a, [de]
	and a
	jr nz, .moveMissed
.pickMoveToDisable
	push hl
	call BattleRandom
	and $3
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .pickMoveToDisable ; loop until a non-00 move slot is found
	ld [wNamedObjectIndex], a ; store move number
	push hl
	ldh a, [hWhoseTurn]
	and a
	ld hl, wBattleMonPP
	jr nz, .enemyTurn
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	pop hl ; wEnemyMonMoves
	jr nz, .playerTurnNotLinkBattle
; player's turn, Link Battle
	push hl
	ld hl, wEnemyMonPP
.enemyTurn
	push hl
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and PP_MASK
	pop hl ; wBattleMonPP or wEnemyMonPP
	jr z, .moveMissedPopHL ; nothing to do if all moves have no PP left
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .pickMoveToDisable ; pick another move if this one had 0 PP
.playerTurnNotLinkBattle
; non-link battle enemies have unlimited PP so the previous checks aren't needed
	call BattleRandom
	and $7
	inc a ; 1-8 turns disabled
	inc c ; move 1-4 will be disabled
	swap c
	add c ; map disabled move to high nibble of wEnemyDisabledMove / wPlayerDisabledMove
	ld [de], a
	call PlayCurrentMoveAnimation2
	ld hl, wPlayerDisabledMoveNumber
	ldh a, [hWhoseTurn]
	and a
	jr nz, .printDisableText
	inc hl ; wEnemyDisabledMoveNumber
.printDisableText
	ld a, [wNamedObjectIndex] ; move number
	ld [hl], a
	call GetMoveName
	ld hl, MoveWasDisabledText
	jp PrintText
.moveMissedPopHL
	pop hl
.moveMissed
	jp PrintButItFailedText_

MoveWasDisabledText:
	text_far _MoveWasDisabledText
	text_end

PayDayEffect:
	jpfar PayDayEffect_

JackpotEffect:
	jpfar JackpotEffect_

ConversionEffect:
	jpfar ConversionEffect_

HazeEffect:
	jpfar HazeEffect_

HealEffect:
	jpfar HealEffect_

TransformEffect:
	jpfar TransformEffect_

ReflectLightScreenEffect:
	jpfar ReflectLightScreenEffect_

NothingHappenedText:
	text_far _NothingHappenedText
	text_end

PrintNoEffectText:
	ld hl, NoEffectText
	jp PrintText

NoEffectText:
	text_far _NoEffectText
	text_end

ConditionalPrintButItFailed:
	ld a, [wMoveDidntMiss]
	and a
	ret nz ; return if the side effect failed, yet the attack was successful

PrintButItFailedText_:
	ld hl, ButItFailedText
	jp PrintText

ButItFailedText:
	text_far _ButItFailedText
	text_end

PrintDidntAffectText:
	ld hl, DidntAffectText
	jp PrintText

DidntAffectText:
	text_far _DidntAffectText
	text_end

IsUnaffectedText:
	text_far _IsUnaffectedText
	text_end

PrintMayNotAttackText:
	ld hl, ParalyzedMayNotAttackText
	jp PrintText

ParalyzedMayNotAttackText:
	text_far _ParalyzedMayNotAttackText
	text_end

CheckTargetSubstitute:
	push hl
	ld hl, wEnemyBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .next
	ld hl, wPlayerBattleStatus2
.next
	bit HAS_SUBSTITUTE_UP, [hl]
	pop hl
	ret

PlayCurrentMoveAnimation2:
; animation at MOVENUM will be played unless MOVENUM is 0
; plays wAnimationType 3 or 6
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z
; fallthrough

PlayBattleAnimation2:
; play animation ID at a and animation type 6 or 3
	ld [wAnimationID], a
	ldh a, [hWhoseTurn]
	and a
	ld a, ANIMATIONTYPE_SHAKE_SCREEN_HORIZONTALLY_SLOW_2
	jr z, .storeAnimationType
	ld a, ANIMATIONTYPE_SHAKE_SCREEN_HORIZONTALLY_SLOW
.storeAnimationType
	ld [wAnimationType], a
	jp PlayBattleAnimationGotID

PlayCurrentMoveAnimation:
; animation at MOVENUM will be played unless MOVENUM is 0
; resets wAnimationType
	xor a
	ld [wAnimationType], a
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z
; fallthrough

PlayBattleAnimation:
; play animation ID at a and predefined animation type
	ld [wAnimationID], a

PlayBattleAnimationGotID:
; play animation at wAnimationID
	push hl
	push de
	push bc
	predef MoveAnimation
	pop bc
	pop de
	pop hl
	ret
