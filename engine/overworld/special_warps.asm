PrepareForSpecialWarp::
	call LoadSpecialWarpData
	predef LoadTilesetHeader
	ld hl, wStatusFlags6
	bit BIT_FLY_OR_DUNGEON_WARP, [hl]
	res BIT_FLY_OR_DUNGEON_WARP, [hl]
	jr z, .debugNewGameWarp
	ld a, [wDestinationMap]
	jr .next
.debugNewGameWarp
	bit BIT_DEBUG_MODE, [hl]
	jr z, .setNewGameMatWarp ; apply to StartNewGameDebug only
	call PrepareNewGameDebug
.setNewGameMatWarp
	; This is called by OakSpeech during StartNewGame and
	; loads the first warp event for the specified map index.
	ld a, PALLET_TOWN
.next
	ld b, a
	ld a, [wStatusFlags3]
	and a ; ???
	jr nz, .next2
	ld a, b
.next2
	ld hl, wStatusFlags6
	bit BIT_DUNGEON_WARP, [hl]
	ret nz
	; Flying into Mt Moon 1F or Seafoam Islands 1F lands the player just inside the
	; cave entrance, whose exit warp is LAST_MAP-relative. Left as `a` (the interior
	; map itself), that exit would loop back into the same map instead of leading
	; outside. Force wLastMap to the correct outdoor route so the exit warp resolves
	; properly, without touching the Fly destination map/coords themselves (those
	; can't safely point at a different map than the one being rendered).
	cp MT_MOON_1F
	jr nz, .notMtMoon
	ld a, ROUTE_4
	jr .setLastMap
.notMtMoon
	cp SEAFOAM_ISLANDS_1F
	jr nz, .setLastMap
	ld a, ROUTE_20
.setLastMap
	ld [wLastMap], a
	ret

LoadSpecialWarpData:
	ld a, [wCableClubDestinationMap]
	cp TRADE_CENTER
	jr nz, .notTradeCenter
	ld hl, TradeCenterPlayerWarp
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .copyWarpData
	ld hl, TradeCenterFriendWarp
	jr .copyWarpData
.notTradeCenter
	cp COLOSSEUM
	jr nz, .notColosseum
	ld hl, ColosseumPlayerWarp
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .copyWarpData
	ld hl, ColosseumFriendWarp
	jr .copyWarpData
.notColosseum
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	; warp to wLastMap (PALLET_TOWN) for StartNewGameDebug
	jr nz, .notNewGameWarp
	bit BIT_FLY_OR_DUNGEON_WARP, a
	jr nz, .notNewGameWarp
	ld hl, NewGameWarp
.copyWarpData
	ld de, wCurMap
	ld c, $7
.copyWarpDataLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyWarpDataLoop
	ld a, [hli]
	ld [wCurMapTileset], a
	xor a
	jr .done
.notNewGameWarp
	ld a, [wLastMap] ; this value is overwritten before it's ever read
	ld hl, wStatusFlags6
	bit BIT_DUNGEON_WARP, [hl]
	jr nz, .usedDungeonWarp
	bit BIT_ESCAPE_WARP, [hl]
	res BIT_ESCAPE_WARP, [hl]
	jr z, .otherDestination
	ld a, [wLastBlackoutMap]
	jr .usedFlyWarp
.usedDungeonWarp
	ld hl, wStatusFlags3
	res BIT_ON_DUNGEON_WARP, [hl]
	ld a, [wDungeonWarpDestinationMap]
	ld b, a
	ld [wCurMap], a
	ld a, [wWhichDungeonWarp]
	ld c, a
	ld hl, DungeonWarpList
	ld de, 0
	ld a, 6
	ld [wDungeonWarpDataEntrySize], a
.dungeonWarpListLoop
	ld a, [hli]
	cp b
	jr z, .matchedDungeonWarpDestinationMap
	inc hl
	jr .nextDungeonWarp
.matchedDungeonWarpDestinationMap
	ld a, [hli]
	cp c
	jr z, .matchedDungeonWarpID
.nextDungeonWarp
	ld a, [wDungeonWarpDataEntrySize]
	add e
	ld e, a
	jr .dungeonWarpListLoop
.matchedDungeonWarpID
	ld hl, DungeonWarpData
	add hl, de
	jr .copyWarpData2
.otherDestination
	ld a, [wDestinationMap]
.usedFlyWarp
	ld b, a
	ld [wCurMap], a
	ld hl, FlyWarpDataPtr
.flyWarpDataPtrLoop
	ld a, [hli]
	inc hl
	cp b
	jr z, .foundFlyWarpMatch
	inc hl
	inc hl
	jr .flyWarpDataPtrLoop
.foundFlyWarpMatch
	ld a, [hli]
	ld h, [hl]
	ld l, a
.copyWarpData2
	ld de, wCurrentTileBlockMapViewPointer
	ld c, $6
.copyWarpDataLoop2
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyWarpDataLoop2
	xor a ; OVERWORLD
	ld [wCurMapTileset], a
; Every other fly/blackout destination is outdoors, but MEGAN's cabin is a ship
; interior -- forcing OVERWORLD here would load the wrong blockset and draw the
; cabin as garbage. `a` must still be 0 on entry to .done, hence the push/pop.
	push af
	ld a, [wCurMap]
	cp SS_OLYMPIA_1F_ROOMS
	jr nz, .keepOverworldTileset
	ld a, SHIP
	ld [wCurMapTileset], a
.keepOverworldTileset
	pop af
.done
	ld [wYOffsetSinceLastSpecialWarp], a
	ld [wXOffsetSinceLastSpecialWarp], a
	ld a, -1 ; exclude normal warps
	ld [wDestinationWarpID], a
	ret

INCLUDE "data/maps/special_warps.asm"
