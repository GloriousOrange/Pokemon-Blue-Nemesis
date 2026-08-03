; Starter Ashes system:
; SaveStarterToAshes - called after Rival2 battle if starter was KO'd.
; The purification itself is no longer an instant party-add (that path
; corrupted whatever mon sat in the last party slot instead of appending --
; see scripts/PokemonTower5F.asm's ghost-battle script for the replacement:
; stepping into the purified zone starts an actual wild encounter for the
; ashes' mon, and only a genuine catch (the standard, well-tested capture
; path) consumes the urn and applies the GHOST-type patch.

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
