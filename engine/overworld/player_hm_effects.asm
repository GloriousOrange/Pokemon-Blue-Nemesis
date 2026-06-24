TryPlayerHMTileInteraction::
; Called from the overworld A-press handler (via farcall) after the
; bookshelf/hidden-event check.  If the tile in front is HM-usable and the
; player has the required badge + HM item in the bag, the action is performed
; silently and hItemAlreadyFound is set to 0 (handled).  Otherwise returns
; without touching hItemAlreadyFound.
; PlayerHMIsItemInBag is in home bank and callable directly from here.
	ld a, [wTileInFrontOfPlayer]
	cp $3d          ; cut tree (overworld)
	jr z, .tryCut
	cp $52          ; cut grass (overworld)
	jr z, .tryCut
	cp $50          ; cut tree (gym)
	jr z, .tryCut
	cp $14          ; water tile
	jr z, .trySurf
	ret

.tryCut:
	ld a, [wObtainedBadges]
	bit BIT_CASCADEBADGE, a
	ret z           ; Cascade Badge not earned
	ld a, HM01      ; HM Cut ($C4)
	call PlayerHMIsItemInBag
	ret nc          ; HM Cut not in bag
	call DoPlayerCut
	xor a
	ldh [hItemAlreadyFound], a
	ret

.trySurf:
	ld a, [wObtainedBadges]
	bit BIT_SOULBADGE, a
	ret z           ; Soul Badge not earned
	ld a, HM01 + 2  ; HM Surf ($C6)
	call PlayerHMIsItemInBag
	ret nc          ; HM Surf not in bag
	call DoPlayerSurf
	ld a, [wWalkBikeSurfState]
	cp 2
	ret nz          ; DoPlayerSurf found conditions not met
	xor a
	ldh [hItemAlreadyFound], a
	ret

DoPlayerCut::
; Performs the Cut field effect silently from the overworld (no menu teardown needed).
; Precondition: wTileInFrontOfPlayer is a cuttable tile.
	ld a, [wTileInFrontOfPlayer]
	ld [wCutTile], a
	ld a, 1
	ld [wActionResultOrTookBattleTurn], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call InitCutAnimOAM
	ld de, CutTreeBlockSwaps
	call ReplaceTreeTileBlock
	call RedrawMapView
	farcall AnimCut
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	ld a, SFX_CUT
	call PlaySound
	jp RedrawMapView

DoPlayerSurf::
; Activates surfing silently (no text).
; Replicates the start-surfing path of ItemUseSurfboard, minus the text print.
; Caller checks wWalkBikeSurfState == 2 to confirm success.
	ld a, [wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy], a
	cp 2
	ret z           ; already surfing — nothing to do
	call IsNextTileShoreOrWater
	ret c           ; not at a surfable water edge
	ld hl, TilePairCollisionsWater
	call CheckForTilePairCollisions
	ret c           ; tile pair blocks surfing here
	; Simulate a directional button press to step the player onto the water
	ld a, [wPlayerDirection]
	bit PLAYER_DIR_BIT_UP, a
	ld b, PAD_UP
	jr nz, .store
	bit PLAYER_DIR_BIT_DOWN, a
	ld b, PAD_DOWN
	jr nz, .store
	bit PLAYER_DIR_BIT_LEFT, a
	ld b, PAD_LEFT
	jr nz, .store
	ld b, PAD_RIGHT
.store:
	ld a, b
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wUnusedSimulatedJoypadStatesMask], a
	inc a
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld a, 2
	ld [wWalkBikeSurfState], a
	call PlayDefaultMusic
	ret
