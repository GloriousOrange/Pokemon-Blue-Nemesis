; Starter Ashes system:
; SaveStarterToAshes   - called after Rival2 battle if starter was KO'd
; RestoreStarterAsGhost - called at Pokemon Tower 5F purification ritual

SaveStarterToAshes::
; Finds the player's starter in party, saves species/level/OTID/nick,
; removes it via RemovePokemon, and gives URN_OF_ASHES.

	; Walk wPartySpecies to find the starter's slot
	ld a, [wPlayerStarter]
	ld b, a                         ; B = starter species
	ld hl, wPartySpecies
	ld c, 0                         ; C = slot index (0-based)
.findLoop:
	ld a, [hli]
	cp $FF
	ret z                           ; terminator — starter not in party, bail
	cp b
	jr z, .foundSlot
	inc c
	jr .findLoop
.foundSlot:
	; C = slot index

	ld a, c
	ld [wWhichPokemon], a           ; for RemovePokemon

	; Compute base of wPartyMon[C]
	push bc
	ld a, c
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes                  ; HL = wPartyMon[C]
	pop bc                          ; C = slot index

	; Save species (MON_SPECIES = +$00)
	ld a, [hl]
	ld [wStarterAshesSpecies], a

	; Save level (MON_LEVEL = +$21)
	push hl
	ld a, l
	add MON_LEVEL
	ld l, a
	jr nc, .nc_level
	inc h
.nc_level:
	ld a, [hl]
	ld [wStarterAshesLevel], a

	; Save OT ID (MON_OTID = +$0C, word)
	pop hl
	push hl
	ld a, l
	add MON_OTID
	ld l, a
	jr nc, .nc_otid
	inc h
.nc_otid:
	ld a, [hli]
	ld [wStarterAshesOTID], a
	ld a, [hl]
	ld [wStarterAshesOTID + 1], a
	pop hl

	; Save nickname (11 bytes from wPartyMonNicks[C])
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	call AddNTimes                  ; HL = nick for slot C
	ld de, wStarterAshesNick
	ld b, NAME_LENGTH
.copyNickLoop:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyNickLoop

	; Remove starter from party (shifts species, OT, nick, struct arrays)
	xor a
	ld [wRemoveMonFromBox], a       ; 0 = party (not box)
	call RemovePokemon

	; Give URN_OF_ASHES
	lb bc, URN_OF_ASHES, 1
	call GiveItem

	SetEvent EVENT_STARTER_BECAME_ASHES
	ret


RestoreStarterAsGhost::
; Adds the starter back at its original level with Ghost secondary type and
; restores its nickname/OTID. The ghost's signature moves (Night Shade and
; Confuse Ray) are no longer injected here; instead the player is handed the
; TMs for those moves (the only source of them), so they choose to teach them.
; Caller must verify party is not full before calling.

	; Set up species and level for AddPartyMon
	ld a, [wStarterAshesSpecies]
	ld [wCurPartySpecies], a
	ld a, [wStarterAshesLevel]
	ld [wCurEnemyLevel], a
	; $10 = player party data, non-zero → skip naming screen
	ld a, $10
	ld [wMonDataLocation], a
	; wIsInBattle = 0 in overworld → AddPartyMon generates fresh random DVs
	call AddPartyMon                ; adds to party, increments wPartyCount

	; The new slot is at (wPartyCount - 1)
	ld a, [wPartyCount]
	dec a
	ld c, a                         ; C = new slot index (0-based)

	; Compute base address of the new wPartyMon[C]
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes                  ; HL = wPartyMon[C] base
	ld a, c                         ; save slot index (AddNTimes clobbers A)
	ld d, h
	ld e, l                         ; DE = base

	; -- Patch MON_TYPE2 (+$06) = GHOST --
	ld a, e
	add MON_TYPE2
	ld l, a
	ld h, d
	jr nc, .nc_type2
	inc h
.nc_type2:
	ld [hl], GHOST

	; -- Overwrite OT ID (MON_OTID = +$0C) with saved value --
	ld a, e
	add MON_OTID
	ld l, a
	ld h, d
	jr nc, .nc_otid
	inc h
.nc_otid:
	ld a, [wStarterAshesOTID]
	ld [hli], a
	ld a, [wStarterAshesOTID + 1]
	ld [hl], a

	; -- Overwrite nickname with saved value --
	; C was the slot index but AddNTimes clobbered it — recalculate
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	call AddNTimes                  ; HL = nick slot for new mon
	ld de, wStarterAshesNick
	ld b, NAME_LENGTH
.copyNickRestore:
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .copyNickRestore

	; -- Remove URN_OF_ASHES from bag --
	ld a, URN_OF_ASHES
	ldh [hItemToRemoveID], a
	call RemoveItemByID

	; -- Hand over the ghost-move TMs: the only way to teach Night Shade and
	;    Confuse Ray. The player chooses to teach them to the revived starter. --
	lb bc, TM_NIGHT_SHADE, 1
	call GiveItem
	lb bc, TM_CONFUSE_RAY, 1
	call GiveItem

	SetEvent EVENT_STARTER_RESURRECTED
	ret
