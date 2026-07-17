InitPlayerData:
InitPlayerData2:

	call Random
	ldh a, [hRandomSub]
	ld [wPlayerID], a

	call Random
	ldh a, [hRandomAdd]
	ld [wPlayerID + 1], a

	ld a, $ff
	ld [wDifficulty], a

	ld hl, wPartyCount
	call InitializeEmptyList
	ld hl, wBoxCount
	call InitializeEmptyList
	ld hl, wNumBagItems
	call InitializeEmptyList
	ld hl, wNumBoxItems
	call InitializeEmptyList

DEF START_MONEY EQU $3000
	ld hl, wPlayerMoney + 1
	ld a, HIGH(START_MONEY)
	ld [hld], a
	xor a ; LOW(START_MONEY)
	ld [hli], a
	inc hl
	ld [hl], a

IF DEF(_SPEEDTEST)
; Speed-testing kit: max money and a stocked bag so play-throughs move fast.
	ld hl, wPlayerMoney
	ld a, $99 ; packed BCD: $99 $99 $99 = 999999
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wNumBagItems
	ld a, 8
	ld [hli], a
	ld a, RARE_CANDY
	ld [hli], a
	ld a, 99
	ld [hli], a
	ld a, SUPER_REPEL
	ld [hli], a
	ld a, 99
	ld [hli], a
	ld a, POKE_BALL
	ld [hli], a
	ld a, 99
	ld [hli], a
	ld a, FULL_RESTORE
	ld [hli], a
	ld a, 99
	ld [hli], a
	ld a, HM_FLY
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, HM_SURF
	ld [hli], a
	ld a, 1
	ld [hli], a
	; SILPH SCOPE + MASTER BALL so testers can reach Pokemon Tower / the Mathus
	; quest without doing the Hideout+Silph Co questline first.
	ld a, SILPH_SCOPE
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, MASTER_BALL
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, $ff ; terminator
	ld [hl], a
ENDC

	xor a
	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hl], a        ; no badges (a = 0)
	inc hl
	ASSERT wObtainedBadges + 1 == wUnusedObtainedBadges
	ld [hl], a

	ld hl, wTownVisitedFlag + 1
	set 3, [hl]              ; bit 11 = BATTLE_ISLAND always flyable

IF DEF(_SPEEDTEST)
; Every town flyable from the start, and the Boulder/Cascade/Rainbow/Soul/
; Marsh badges pre-granted (obedience + field HMs; those gyms can still be
; fought, rebeating them just re-awards the badge).
	ld a, (1 << BIT_BOULDERBADGE) | (1 << BIT_CASCADEBADGE) | (1 << BIT_THUNDERBADGE) | (1 << BIT_RAINBOWBADGE) | (1 << BIT_SOULBADGE) | (1 << BIT_MARSHBADGE)
	ld [wObtainedBadges], a ; Thunder included: Fly's field use requires it
	ld hl, wTownVisitedFlag
	ld a, $ff       ; towns 0-7
	ld [hli], a
	ld a, %00001111 ; towns 8-11 (through BATTLE_ISLAND)
	ld [hl], a
	xor a ; restore a = 0 for the inits below
ENDC

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wPostGameFlagsEnd - wGameProgressFlags ; also clears wPostGameFlags (arena/post-game state)
	call FillMemory ; clear all game progress flags

	jp InitializeToggleableObjectsFlags

InitializeEmptyList:
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret
