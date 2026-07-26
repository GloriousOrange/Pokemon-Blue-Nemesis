; Megan follower companion (Pokemon Nemesis). Once wPostGameMisc's
; BIT_GOT_GIRLFRIEND is set (Route 1 recruitment), she trails one tile
; behind the player on every subsequent map.
;
; Pieces that work together:
;  - TryAddMeganFollowerSprite (this file): injects her as an extra NPC slot
;    on INDOOR maps only, called from LoadMapData (home/overworld.asm)
;    between LoadMapHeader and InitMapSprites, so the normal per-slot
;    dynamic tile-pattern loading picks up her real SPRITE_MEGAN graphic
;    like it would any other object_event.
;  - TryFinishMeganFollowerOutdoorSprite (this file): injects her on
;    OUTDOOR maps only, called AFTER InitMapSprites, once wSpriteSetID is
;    valid. Every outdoor sprite-set region (data/maps/sprite_sets.asm) is
;    already at its hard 9-distinct-NPC-type VRAM cap with zero slack, so
;    outdoors she borrows the tiles of an existing type already present in
;    that region (FollowerStandInGraphics/FollowerStandInImageBaseOffset)
;    instead of her own dedicated graphic, and her IMAGEBASEOFFSET is set
;    directly rather than computed via the normal tile-loading pass.
;  - GetFollowerStateData2Ptr lives in home/overworld.asm (not here) so it
;    can be called with a plain `call` from both this bank and home-bank
;    code (CollisionCheckOnLand) without the af/bc clobbering that comes
;    back through farcall/Bankswitch.
;  - The UpdateNPCSprite patch (engine/overworld/movement.asm) forces her
;    slot to take one deliberate step whenever wFollowerPendingStep is set,
;    reusing the vanilla walk-animation/collision machinery unchanged.
;  - The CollisionCheckOnLand patch (home/overworld.asm) lets the player
;    swap places with her after being blocked by her for a while, so she
;    can never trap the player in a tight space.

; Called from LoadMapData (home/overworld.asm), between LoadMapHeader and
; InitMapSprites. Indoor maps only -- outdoor injection happens later, in
; TryFinishMeganFollowerOutdoorSprite, once wSpriteSetID is valid.
TryAddMeganFollowerSprite::
	xor a
	ld [wFollowerSpriteOffset], a
	ld [wFollowerPendingStep], a
	ld [wFollowerBumpCount], a
	call ShouldMeganFollow
	ret nc
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP
	ret c ; outdoor -- handled later by TryFinishMeganFollowerOutdoorSprite
	ld a, SPRITE_MEGAN
	ld [wFollowerPictureIDTemp], a
	call InjectFollowerSlotCommon
	ret

; Called from LoadMapData (home/overworld.asm), right after InitMapSprites
; returns. Outdoor maps only.
TryFinishMeganFollowerOutdoorSprite::
	call ShouldMeganFollow
	ret nc
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP
	ret nc ; indoor -- already handled by TryAddMeganFollowerSprite
	ld a, [wSpriteSetID]
	and a
	ret z ; shouldn't happen once ShouldMeganFollow passed, but be safe
	dec a ; 0-indexed
	ld hl, FollowerStandInGraphics
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wFollowerPictureIDTemp], a
	call InjectFollowerSlotCommon
; now overwrite her IMAGEBASEOFFSET with the hardcoded value for this
; region, instead of whatever InjectFollowerSlotCommon's normal path left
; there (it doesn't set one at all -- see below).
	ld a, [wSpriteSetID]
	dec a
	ld hl, FollowerStandInImageBaseOffset
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld b, a
	call GetFollowerStateData2Ptr
	ret c
	ld a, l
	add SPRITESTATEDATA2_IMAGEBASEOFFSET
	ld l, a
	ld [hl], b
	ret

; Shared checks. Returns carry SET if she should be following on this map,
; clear otherwise (and the caller should bail out having already cleared
; wFollowerSpriteOffset).
ShouldMeganFollow:
	ld a, [wPostGameMisc]
	bit BIT_GOT_GIRLFRIEND, a
	jr z, .no ; not recruited yet
	ld a, [wCurMap]
	cp ROUTE_1
	jr z, .no ; she's still her own object_event there; avoid a duplicate
	ld a, [wNumSprites]
	cp NUM_SPRITESTATEDATA_STRUCTS - 1 ; 15 -- map is already completely full
	jr nc, .no
	scf
	ret
.no
	and a
	ret

; Reads wFollowerPictureIDTemp. Bumps wNumSprites, sets wFollowerSpriteOffset,
; and populates her StateData1/2 fields (picture ID, facing, position one
; tile behind the player, movement mode) plus wMapSpriteExtraData/
; wMapSpriteData (zeroed -- she's not a real object_event, so there's no
; per-map trainer/item/dialogue entry for her). Does NOT set IMAGEBASEOFFSET
; -- indoor callers get it for free from the normal tile-loading pass that
; runs right after this (InitMapSprites); the outdoor caller sets it itself.
InjectFollowerSlotCommon:
	ld a, [wNumSprites]
	inc a
	ld [wNumSprites], a ; her new slot number (1-15)
	swap a              ; hCurrentSpriteOffset-style value (index * 16)
	ld [wFollowerSpriteOffset], a
; StateData1: picture ID + initial facing (match the player's for now)
	ld h, HIGH(wSpritePlayerStateData1)
	ld a, [wFollowerSpriteOffset]
	ld l, a
	ld a, [wFollowerPictureIDTemp]
	ld [hl], a ; x#SPRITESTATEDATA1_PICTUREID
	ld a, [wFollowerSpriteOffset]
	add SPRITESTATEDATA1_FACINGDIRECTION
	ld l, a
	ld a, [wSpritePlayerStateData1FacingDirection]
	ld [hl], a
; StateData2: position one tile behind the player + movement mode
; wFollowerPrevMapY/X (her walking target from here on) is the player's
; CURRENT position -- but she needs to actually START one tile behind that,
; opposite the player's current facing, or she'd visibly overlap the player
; for one full step before the trailing logic catches her up.
	ld a, [wSpritePlayerStateData2MapY]
	ld [wFollowerPrevMapY], a
	ld b, a
	ld a, [wSpritePlayerStateData2MapX]
	ld [wFollowerPrevMapX], a
	ld c, a
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_DOWN
	jr nz, .spawnCheckUp
	dec b
	jr .haveSpawnPos
.spawnCheckUp
	cp SPRITE_FACING_UP
	jr nz, .spawnCheckLeft
	inc b
	jr .haveSpawnPos
.spawnCheckLeft
	cp SPRITE_FACING_LEFT
	jr nz, .spawnRight
	inc c
	jr .haveSpawnPos
.spawnRight
	dec c
.haveSpawnPos
	ld h, HIGH(wSpritePlayerStateData2)
	ld a, [wFollowerSpriteOffset]
	add SPRITESTATEDATA2_MAPY
	ld l, a
	ld [hl], b
	ld a, [wFollowerSpriteOffset]
	add SPRITESTATEDATA2_MAPX
	ld l, a
	ld [hl], c
	ld a, [wFollowerSpriteOffset]
	add SPRITESTATEDATA2_MOVEMENTBYTE1
	ld l, a
	ld [hl], WALK
; zero her wMapSpriteExtraData and wMapSpriteData entries
	ld a, [wFollowerSpriteOffset]
	swap a
	dec a
	add a
	ld c, a
	ld b, 0
	ld hl, wMapSpriteExtraData
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wMapSpriteData
	add hl, bc
	xor a
	ld [hli], a
	ld [hl], a
	ret

FollowerStandInGraphics:
	db SPRITE_GIRL           ; SPRITESET_PALLET_VIRIDIAN
	db SPRITE_COOLTRAINER_F   ; SPRITESET_PEWTER_CERULEAN
	db SPRITE_GIRL            ; SPRITESET_LAVENDER
	db SPRITE_COOLTRAINER_F   ; SPRITESET_VERMILION
	db SPRITE_GIRL            ; SPRITESET_CELADON
	db SPRITE_COOLTRAINER_F   ; SPRITESET_INDIGO
	db SPRITE_SILPH_WORKER_F  ; SPRITESET_SAFFRON
	db SPRITE_COOLTRAINER_F   ; SPRITESET_SILENCE_BRIDGE
	db SPRITE_BIKER           ; SPRITESET_CYCLING_ROAD
	db SPRITE_SWIMMER         ; SPRITESET_FUCHSIA
	db SPRITE_MEGAN           ; SPRITESET_ROUTE_1 (unreachable -- Route 1 is excluded above)

; Hardcoded VRAM image-base-offset each stand-in above is guaranteed to get,
; derived from its fixed position in that region's 9-member walking list in
; data/maps/sprite_sets.asm (position N always resolves to offset N+1 --
; see engine/overworld/map_sprites.asm's InitOutsideMapSprites/
; LoadMapSpriteTilePatterns, where the player permanently occupies offset 1
; and the region's list is preloaded into VRAM strictly in list order).
; NOTE: if sprite_sets.asm's lists are ever reordered, these must be
; recomputed to match -- they intentionally don't derive automatically.
FollowerStandInImageBaseOffset:
	db 4  ; PALLET_VIRIDIAN: GIRL is list position 3
	db 9  ; PEWTER_CERULEAN: COOLTRAINER_F is list position 8
	db 3  ; LAVENDER: GIRL is list position 2
	db 9  ; VERMILION: COOLTRAINER_F is list position 8
	db 4  ; CELADON: GIRL is list position 3
	db 6  ; INDIGO: COOLTRAINER_F is list position 5
	db 5  ; SAFFRON: SILPH_WORKER_F is list position 4
	db 5  ; SILENCE_BRIDGE: COOLTRAINER_F is list position 4
	db 2  ; CYCLING_ROAD: BIKER is list position 1
	db 9  ; FUCHSIA: SWIMMER is list position 8
	db 3  ; ROUTE_1: unreachable

; Called once per completed player step (home/overworld.asm, the
; "walking animation finished" step-counting checkpoint). Queues Megan's
; next single-tile step toward wherever the player was standing at the end
; of the PREVIOUS step -- always exactly one tile behind, Pikachu-style.
MeganFollowerOnPlayerStep::
	call GetFollowerStateData2Ptr
	ret c ; no follower active this map
	ld a, l
	add SPRITESTATEDATA2_MAPY
	ld l, a
	ld a, [wFollowerPrevMapY]
	ld b, a
	ld a, [hl] ; her current MAPY
	cp b
	jr z, .checkX
	jr c, .down ; her Y < target Y (Y increases downward) -> move down
.up
	ld a, FOLLOWER_STEP_UP
	ld [wFollowerPendingStep], a
	jr .refresh
.down
	ld a, FOLLOWER_STEP_DOWN
	ld [wFollowerPendingStep], a
	jr .refresh
.checkX
	inc l ; StateData2 MAPX is the byte right after MAPY
	ld a, [wFollowerPrevMapX]
	ld b, a
	ld a, [hl] ; her current MAPX
	cp b
	jr z, .none
	jr c, .right ; her X < target X -> move right
.left
	ld a, FOLLOWER_STEP_LEFT
	ld [wFollowerPendingStep], a
	jr .refresh
.right
	ld a, FOLLOWER_STEP_RIGHT
	ld [wFollowerPendingStep], a
	jr .refresh
.none
	xor a
	ld [wFollowerPendingStep], a
.refresh
	ld a, [wSpritePlayerStateData2MapY]
	ld [wFollowerPrevMapY], a
	ld a, [wSpritePlayerStateData2MapX]
	ld [wFollowerPrevMapX], a
	ret
