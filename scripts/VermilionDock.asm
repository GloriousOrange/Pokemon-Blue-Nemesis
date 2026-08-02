VermilionDock_Script:
	call EnableAutoTextBoxDrawing
	call VermilionDockSetBerthScript
	call VermilionDockCheckOlympiaGuard
	CheckEventHL EVENT_STARTED_WALKING_OUT_OF_DOCK
	jr nz, .walking_out_of_dock
	CheckEventReuseHL EVENT_GOT_HM01
	ret z
	ld a, [wDestinationWarpID]
	cp $1 ; arrived down the gangway (warp 2, stored 0-based)
	ret nz
	CheckEventReuseHL EVENT_SS_ANNE_LEFT
	jp z, VermilionDockSSAnneLeavesScript
	SetEventReuseHL EVENT_STARTED_WALKING_OUT_OF_DOCK
	call Delay3
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wSimulatedJoypadStatesEnd
	ld a, PAD_UP
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $3
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	dec a
	ld [wJoyIgnore], a
	ret
.walking_out_of_dock
	CheckEventAfterBranchReuseHL EVENT_WALKED_OUT_OF_DOCK, EVENT_STARTED_WALKING_OUT_OF_DOCK
	ret nz
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld [wJoyIgnore], a
	SetEventReuseHL EVENT_WALKED_OUT_OF_DOCK
	ret

VermilionDockSSAnneLeavesScript:
	SetEventForceReuseHL EVENT_SS_ANNE_LEFT
	ld a, SFX_STOP_ALL_MUSIC
	ld [wJoyIgnore], a
	ld [wNewSoundID], a
	call PlaySound
	ld c, BANK(Music_Surfing)
	ld a, MUSIC_SURFING
	call PlayMusic
	farcall LoadSmokeTileFourTimes
	xor a
	ld [wSpritePlayerStateData1ImageIndex], a
	ld c, 120
	call DelayFrames
	ld b, HIGH(vBGMap1)
	call CopyScreenTileBufferToVRAM
	hlcoord 0, 10
	ld bc, SCREEN_WIDTH * 6
	ld a, $14 ; water tile
	call FillMemory
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld [wSSAnneSmokeDriftAmount], a
	ldh [rOBP1], a
	ld a, 88
	ld [wSSAnneSmokeX], a
	ld hl, wMapViewVRAMPointer
	ld c, [hl]
	inc hl
	ld b, [hl]
	push bc
	push hl
	ld a, SFX_SS_ANNE_HORN
	call PlaySoundWaitForCurrent
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld d, $0
	ld e, $8
.shift_columns_up
	ld hl, $2
	add hl, bc
	ld a, l
	ld [wMapViewVRAMPointer], a
	ld a, h
	ld [wMapViewVRAMPointer + 1], a
	push hl
	push de
	call ScheduleEastColumnRedraw
	call VermilionDock_EmitSmokePuff
	pop de
	ld b, $10
.smoke_puff_drift_loop
	call VermilionDock_AnimSmokePuffDriftRight
	ld c, $8
.delay_between_drifts
	call VermilionDock_SyncScrollWithLY
	dec c
	jr nz, .delay_between_drifts
	inc d
	dec b
	jr nz, .smoke_puff_drift_loop
	pop bc
	dec e
	jr nz, .shift_columns_up
	xor a
	ldh [rWY], a
	ldh [hWY], a
	call VermilionDock_EraseSSAnne
	ld a, $90
	ldh [hWY], a
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	pop hl
	pop bc
	ld [hl], b
	dec hl
	ld [hl], c
	call LoadPlayerSpriteGraphics
	ld hl, wNumberOfWarps
	dec [hl]
	ret

VermilionDock_AnimSmokePuffDriftRight:
	push bc
	push de
	ld hl, wShadowOAMSprite04XCoord
	ld a, [wSSAnneSmokeDriftAmount]
	swap a
	ld c, a
	ld de, OBJ_SIZE
.drift_loop
	inc [hl]
	inc [hl]
	add hl, de
	dec c
	jr nz, .drift_loop
	pop de
	pop bc
	ret

VermilionDock_EmitSmokePuff:
; new smoke puff above the S.S. Anne's front smokestack
	ld a, [wSSAnneSmokeX]
	sub 16
	ld [wSSAnneSmokeX], a
	ld c, a
	ld b, 100 ; Y
	ld a, [wSSAnneSmokeDriftAmount]
	inc a
	ld [wSSAnneSmokeDriftAmount], a
	ld a, $1
	ld de, VermilionDockOAMBlock
	call WriteOAMBlock
	ret

VermilionDockOAMBlock:
; tile ID, attributes
	db $fc, OAM_PAL1
	db $fd, OAM_PAL1
	db $fe, OAM_PAL1
	db $ff, OAM_PAL1

VermilionDock_SyncScrollWithLY:
	ld h, d
	ld l, $50
	call .sync_scroll_ly
	ld h, $0
	ld l, $80
.sync_scroll_ly
	ldh a, [rLY]
	cp l
	jr nz, .sync_scroll_ly
	ld a, h
	ldh [rSCX], a
.wait_for_ly_match
	ldh a, [rLY]
	cp h
	jr z, .wait_for_ly_match
	ret

VermilionDock_EraseSSAnne:
; Fill the area the S.S. Anne occupies in BG map 0 with water tiles.
	ld hl, wVermilionDockTileMapBuffer
	ld bc, wVermilionDockTileMapBufferEnd - wVermilionDockTileMapBuffer
	ld a, $14 ; water tile
	call FillMemory
	hlbgcoord 0, 10
	ld de, wVermilionDockTileMapBuffer
	lb bc, BANK(wVermilionDockTileMapBuffer), 12
	call CopyVideoData

; Replace the blocks of the lower half of the ship with water blocks. This
; leaves the upper half alone, but that doesn't matter because replacing any of
; the blocks is unnecessary because the blocks the ship occupies are south of
; the player and won't be redrawn when the player automatically walks north and
; exits the map. This code could be removed without affecting anything.
	hlowcoord 5, 2, VERMILION_DOCK_WIDTH
	ld a, $d ; water block
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld a, SFX_SS_ANNE_HORN
	call PlaySound
	ld c, 120
	call DelayFrames
	ret

; Which ship is tied up at the gangway (14,2).
;
;   before the S.S. Anne sails : the Anne, exactly as vanilla
;   after she sails            : nothing -- the warp is retired
;   after the Champion falls   : the S.S. Olympia
;
; The Olympia used to have a berth warp of its own at (14,3). That is a WALL in
; ship_port's collision, so it could never be stepped on -- which is why the
; ship was never reachable. Both ships share this gangway now.
;
; Note the departure cutscene's own `dec [wNumberOfWarps]` only holds for the
; visit it runs in: warp counts reload from the map's object data on every map
; load. So the retire has to be redone on each entry, clamped so that running
; every frame can't chew through the rest of the list.
VermilionDockSetBerthScript:
	CheckEvent EVENT_SS_ANNE_LEFT
	ret z
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	jr nz, .olympiaIsIn
; no ship: drop the gangway warp
	ld a, [wNumberOfWarps]
	cp 2 ; only while the gangway is still listed
	ret nz
	dec a
	ld [wNumberOfWarps], a
	ret
.olympiaIsIn
; keep the warp, repoint it. Entry 1 is the gangway; the bytes are Y, X, warp
; ID, map ID, so +2 is the destination warp and +3 the destination map.
	ld a, 2
	ld [wNumberOfWarps], a
	ld hl, wWarpEntries + 1 * 4 + 2
	xor a
	ld [hli], a ; arrive at the Olympia's own gangway (her warp 1)
	ld [hl], SS_OLYMPIA_1F
	ret

; The GENTLEMAN stands on (14,1), the one-tile corridor between the dock
; entrance and the gangway, so he genuinely blocks boarding. He is only there
; once the Champion has been beaten -- before that the dock reads as vanilla --
; and he steps aside as soon as the party is down to the single Pokemon the
; cruise allows.
;
; He used to also demand a MASTER BALL in the bag, which is the other reason
; nobody ever saw this ship: the MASTER BALL moved to Giovanni's Hideout, and
; anyone who spent theirs on a legendary could never board at all.
VermilionDockCheckOlympiaGuard:
	ld a, TOGGLE_VERMILION_DOCK_OLYMPIA_GUARD
	ld [wToggleableObjectIndex], a
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	jr z, .stepAside ; no cruise yet -- keep the dock clear
	ld a, [wPartyCount]
	dec a
	jr nz, .blockTheWay ; more than one Pokemon: he holds the gangway
.stepAside
	predef_jump HideObject
.blockTheWay
	predef_jump ShowObject

VermilionDock_TextPointers:
	def_text_pointers
	dw_const VermilionDockOlympiaGuardText, TEXT_VERMILIONDOCK_OLYMPIA_GUARD
	dw_const VermilionDockUnusedText, TEXT_VERMILIONDOCK_UNUSED

VermilionDockUnusedText:
	text_far _VermilionDockUnusedText
	text_end

VermilionDockOlympiaGuardText:
	text_far _VermilionDockOlympiaGuardText
	text_end
