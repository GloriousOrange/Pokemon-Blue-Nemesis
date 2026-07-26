; Megan follower companion (Pokemon Nemesis). Once wPostGameMisc's
; BIT_GOT_GIRLFRIEND is set (Route 1 recruitment), she trails one tile
; behind the player on INDOOR maps only (Pokemon Centers, Marts, gyms,
; houses, etc.) -- Pokemon Centers, Marts, gyms, houses, etc.
;
; Outdoor overworld maps are deliberately excluded. Every outdoor
; sprite-set region (data/maps/sprite_sets.asm) is already at its hard
; 9-distinct-NPC-type VRAM cap with zero slack, so showing her outdoors
; would require borrowing an existing NPC type's tiles and hand-deriving
; which VRAM slot that graphic lands in -- exactly the class of bug that
; made her Route 1 debut render wrong, and not reliable enough to ship.
; Indoor maps load NPC tile patterns dynamically per-slot with no such
; fixed table, so her real SPRITE_MEGAN graphic just works there.
;
; Pieces that work together:
;  - TryAddMeganFollowerSprite (this file): injects her as an extra NPC slot
;    on indoor maps, called from LoadMapData (home/overworld.asm) between
;    LoadMapHeader and InitMapSprites, so the normal per-slot dynamic
;    tile-pattern loading picks up her graphic like it would any other
;    object_event.
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
; InitMapSprites.
TryAddMeganFollowerSprite::
	xor a
	ld [wFollowerSpriteOffset], a
	ld [wFollowerPendingStep], a
	ld [wFollowerBumpCount], a
	call ShouldMeganFollow
	ret nc
	ld a, SPRITE_MEGAN
	ld [wFollowerPictureIDTemp], a
	call InjectFollowerSlotCommon
	ret

; Called from LoadMapData (home/overworld.asm), right after InitMapSprites
; returns -- her IMAGEBASEOFFSET is only valid once that's finished, so this
; can't run any earlier. Forces her visible on her very first frame, instead
; of leaving IMAGEINDEX at $ff (invisible, set by InjectFollowerSlotCommon's
; MOVEMENTSTATUS=1) until she happens to take her first queued step.
TryShowMeganFollowerSprite::
	ld a, [wFollowerSpriteOffset]
	and a
	ret z
	ldh [hCurrentSpriteOffset], a
	farcall InitializeSpriteScreenPosition
	call GetFollowerStateData2Ptr
	ld a, l
	add SPRITESTATEDATA2_IMAGEBASEOFFSET
	ld l, a
	ld a, [hl] ; her IMAGEBASEOFFSET
	dec a
	swap a
	ldh [hTilePlayerStandingOn], a ; matches UpdateNonPlayerSprite's own (imagebaseoffset-1)*16 computation
	farcall UpdateSpriteImage
	ret

; Shared checks. Returns carry SET if she should be following on this map,
; clear otherwise (and the caller should bail out having already cleared
; wFollowerSpriteOffset).
ShouldMeganFollow:
	ld a, [wPostGameMisc]
	bit BIT_GOT_GIRLFRIEND, a
	jr z, .no ; not recruited yet
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP
	jr c, .no ; outdoor map -- not supported, see file header
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
; StateData1: picture ID + initial facing (match the player's for now).
; MOVEMENTSTATUS is set to 1 (ready) directly rather than left at 0 --
; skipping InitializeSpriteStatus's "fresh sprite" bootstrap entirely, since
; TryShowMeganFollowerSprite (called after InitMapSprites, once her
; IMAGEBASEOFFSET is valid) does that setup itself so she's visible from
; her very first frame instead of only after she takes her first step.
	ld h, HIGH(wSpritePlayerStateData1)
	ld a, [wFollowerSpriteOffset]
	ld l, a
	ld a, [wFollowerPictureIDTemp]
	ld [hl], a ; x#SPRITESTATEDATA1_PICTUREID
	ld a, [wFollowerSpriteOffset]
	add SPRITESTATEDATA1_MOVEMENTSTATUS
	ld l, a
	ld [hl], 1
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
; YDISPLACEMENT/XDISPLACEMENT: normally set to 8 by InitializeSpriteStatus,
; which we're skipping (see above) -- CanWalkOntoTile's displacement
; tracking expects these initialized.
	ld a, [wFollowerSpriteOffset]
	add SPRITESTATEDATA2_YDISPLACEMENT
	ld l, a
	ld [hl], 8
	ld a, [wFollowerSpriteOffset]
	add SPRITESTATEDATA2_XDISPLACEMENT
	ld l, a
	ld [hl], 8
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
