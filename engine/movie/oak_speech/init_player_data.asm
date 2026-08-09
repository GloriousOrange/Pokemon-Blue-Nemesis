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

; Every player starts with a TOWN MAP filed in the PC's item storage, so it is
; there from the first save whether or not they go and talk to DAISY.
	ld hl, wNumBoxItems
	ld a, 1
	ld [hli], a ; one item stored
	ld a, TOWN_MAP
	ld [hli], a
	ld a, 1
	ld [hli], a ; quantity
	ld a, -1
	ld [hl], a ; end of list

; Money is three bytes of packed BCD, most significant first -- so these are
; written as hex literals on purpose. `ld a, 50` would silently mean 32.
IF DEF(_LANDOSPEEDTEST)
; Landon's test build (2026-08-09): an otherwise completely stock game -- no
; box mons, no kit, no badges, no unlocks, normal text speed -- with exactly
; one change, a bigger starting wallet. He asked to test everything else the
; way a player would meet it, so this build does NOT define _SPEEDTEST.
DEF START_MONEY_HI  EQU $05 ; $05 $00 $00 = 50000
DEF START_MONEY_MID EQU $00
DEF START_MONEY_LO  EQU $00
ELSE
DEF START_MONEY_HI  EQU $00 ; $00 $30 $00 = 3000
DEF START_MONEY_MID EQU $30
DEF START_MONEY_LO  EQU $00
ENDC
	ld hl, wPlayerMoney
	ld a, START_MONEY_HI
	ld [hli], a
	ld a, START_MONEY_MID
	ld [hli], a
	ld a, START_MONEY_LO
	ld [hl], a

IF DEF(_SPEEDTEST)
; Speed-testing kit: max money and a stocked bag so play-throughs move fast.
	ld hl, wPlayerMoney
	ld a, $99 ; packed BCD: $99 $99 $99 = 999999
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wNumBagItems
; Josh's Silph Co repro build (user request 2026-08-09): a deliberately bare
; bag -- HM02 (Fly) to get across the map, and 90 Master Balls. Nothing else,
; so nothing in the bag can muddy the glitch repro.
	ld a, 4
	ld [hli], a
	ld a, HM_STRENGTH ; the Archipelago Cave pit is behind a boulder
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, HM_FLY
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, HM_SURF ; the Soul Badge below enables its field use
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, MASTER_BALL
	ld [hli], a
	ld a, 90
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

; BATTLE ISLAND is deliberately NOT flyable from the start: it is stocked with
; level 100 arena trainers, and a player could fly straight there and be wiped.
; PostGameCheckAllGymsRebeaten unlocks it once all the gym leaders have been
; re-beaten. The SPEEDTEST block below still grants it outright, since testers
; want to get there directly.

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

IF DEF(_SPEEDTEST)
; Set AFTER the flag clear above so it survives: jump testers straight into
; post-game, and open the Pallet ferry to Oak's island so the endgame
; department store (fresh scientists to test) + the archipelago are reachable.
	ld hl, wPostGameMisc
	set BIT_POST_GAME_STARTED, [hl]
	set BIT_OAK_ISLAND_UNLOCKED, [hl]
	SetEvent EVENT_USED_MUTAGEN_MACHINE ; testers: OAK pre-revealed in the Archipelago Cave
ENDC

IF DEF(_SPEEDTEST)
	call InitializeToggleableObjectsFlags
; The CERULEAN CAVE doorman is only ever removed by the Hall of Fame script, and
; a speed-test run never gets there -- so hide him up front, otherwise MEWTHREE
; is unreachable for testing. Set the flag directly rather than via HideObject:
; that ends in UpdateSprites, which has no map to work on this early.
	ld hl, wToggleableObjectFlags
	ld c, TOGGLE_CERULEAN_CAVE_GUY
	ld b, FLAG_SET ; "removed"
	jp ToggleableObjectFlagAction
ELSE
	jp InitializeToggleableObjectsFlags
ENDC

InitializeEmptyList:
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret
