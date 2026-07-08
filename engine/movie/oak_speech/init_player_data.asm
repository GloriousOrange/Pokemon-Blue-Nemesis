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
	ld a, 4
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
