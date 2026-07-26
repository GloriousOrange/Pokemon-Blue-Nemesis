_GivePokemon::
; returns success in carry
; and whether the mon was added to the party in [wAddedToParty]
	call EnableAutoTextBoxDrawing
	xor a
	ld [wAddedToParty], a
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr c, .addToParty
	ld a, [wBoxCount]
	cp MONS_PER_BOX
	jr c, .addToBox
	farcall AutoSwitchBox
	jr nc, .boxFull
.addToBox
; add to box
	xor a
	ld [wEnemyBattleStatus3], a
	ld a, [wCurPartySpecies]
	ld [wEnemyMonSpecies2], a
	callfar LoadEnemyMonData
	call SetPokedexOwnedFlag
	callfar SendNewMonToBox
	ld hl, wStringBuffer
	ld a, [wCurrentBoxNum]
	and BOX_NUM_MASK
	cp 9
	jr c, .singleDigitBoxNum
	sub 9
	ld [hl], '1'
	inc hl
	add '0'
	jr .next
.singleDigitBoxNum
	add '1'
.next
	ld [hli], a
	ld [hl], '@'
	ld hl, SentToBoxText
	call PrintText
	scf
	ret
.boxFull
	ld hl, BoxIsFullText
	call PrintText
	and a
	ret
.addToParty
	call SetPokedexOwnedFlag
	call AddPartyMon
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld [wAddedToParty], a
	scf
	ret

SetPokedexOwnedFlag:
	ld a, [wCurPartySpecies]
	push af
	ld [wPokedexNum], a
	predef IndexToPokedex
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld hl, wPokedexOwned
	ld b, FLAG_SET
	predef FlagActionPredef
	pop af
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, GotMonText
	jp PrintText

GotMonText:
	text_far _GotMonText
	sound_get_item_1
	text_end

SentToBoxText:
	text_far _SentToBoxText
	text_end

BoxIsFullText:
	text_far _BoxIsFullText
	text_end

; One-time debug convenience (user request 2026-07-10): deposits 3 L100
; Pokemon with hand-picked movesets straight into the PC box on the next
; "Continue", regardless of current party/box state -- called from
; engine/menus/main_menu.asm's .pressedA. Always adds to the BOX (mirrors
; _GivePokemon's .addToBox path exactly, but unconditionally, since the user
; asked for "storage" specifically), and patches the moveset after the
; natural level-up moves load (same technique as the burned-lab Farfetch'd
; gift) -- LoadMovePPs then derives correct PP from the patched move IDs.
SpeedtestGiveDebugMons::
IF DEF(_SPEEDTEST)
; Need 4 free box slots -- SendNewMonToBox has no overflow guard of its own,
; so depositing into a (nearly) full box would corrupt it. If there's no
; room, bail WITHOUT setting the flag so it retries on a later Continue.
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 2 ; need 3 free box slots for the legendary-bird test roster
	ret nc
	CheckEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	ret nz
	SetEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
; The legendary-bird test roster, at L100 with signature moves first so they
; can be tried immediately from storage.
	lb bc, TYRANIS, 100
	ld hl, .TyranisMoves
	call .GiveBoxedMonWithMoves
	lb bc, MIASMA, 100
	ld hl, .MiasmaMoves
	call .GiveBoxedMonWithMoves
	lb bc, NOCTURN, 100
	ld hl, .NocturnMoves
	call .GiveBoxedMonWithMoves
ENDC
	ret

.TyranisMoves:    db DOUBLE_DRILL, HYPER_BEAMS, SKY_ATTACK, BODY_SLAM, FLY
.MiasmaMoves:     db CARRION_WIND, BLIGHT_VOMIT, DRILL_PECK, TOXIC, FLY
.NocturnMoves:    db MIND_FEVER, PHANTOM_WING, NIGHT_SHADE, GUST, CONFUSE_RAY

; b = species, c = level, hl = pointer to a NUM_MOVES-byte moveset
.GiveBoxedMonWithMoves:
	push hl
	ld a, b
	ld [wCurPartySpecies], a
	ld a, c
	ld [wCurEnemyLevel], a
	xor a
	ld [wEnemyBattleStatus3], a
	ld a, [wCurPartySpecies]
	ld [wEnemyMonSpecies2], a
	callfar LoadEnemyMonData
	pop hl
	ld de, wEnemyMonMoves
	REPT NUM_MOVES
	ld a, [hli]
	ld [de], a
	inc de
	ENDR
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP - 1
	predef LoadMovePPs
	call SetPokedexOwnedFlag
	callfar SendNewMonToBox
	ret

; Test-party kit (user request 2026-07-15): the first time the bedroom PC is
; opened, silently drops five L100 mons -- Alakachamp, a Web Cannon Pinsir, and
; the three legendary birds -- straight into the PARTY with hand-picked movesets,
; so their signature mechanics can be tested immediately. AddPartyMon with
; wMonDataLocation != 0 adds to the player's party, skips the naming screen, and
; updates the Pokedex, all with no text/menu UI. Compile with `make blue TESTPARTY=1`.
GiveTestParty::
IF DEF(_TESTPARTY)
	ld a, [wPartyCount]
	cp PARTY_LENGTH - 4 ; need 5 free slots; bail and retry later if the party is too full
	ret nc
	CheckEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	ret nz
	SetEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	ld a, $80
	ld [wMonDataLocation], a ; player party, skip the naming screen
	lb bc, ALAKACHAMP, 100
	ld hl, .AlakachampMoves
	call .GivePartyMonWithMoves
	lb bc, PINSIR, 100
	ld hl, .PinsirMoves
	call .GivePartyMonWithMoves
	lb bc, TYRANIS, 100
	ld hl, .TyranisMoves
	call .GivePartyMonWithMoves
	lb bc, MIASMA, 100
	ld hl, .MiasmaMoves
	call .GivePartyMonWithMoves
	lb bc, NOCTURN, 100
	ld hl, .NocturnMoves
	call .GivePartyMonWithMoves
	xor a
	ld [wMonDataLocation], a ; restore PLAYER_PARTY_DATA
	ld hl, .TestPartyLoadedText
	call PrintText
ENDC
	ret

IF DEF(_TESTPARTY)
; b = species, c = level, hl = NUM_MOVES-byte moveset
.GivePartyMonWithMoves:
	push hl
	ld a, b
	ld [wCurPartySpecies], a
	ld a, c
	ld [wCurEnemyLevel], a
	call AddPartyMon ; silent: builds the mon (natural moves) and updates the Pokedex
	pop de ; de = moveset source
; overwrite the newly added (last) party slot's moves, then recompute PP
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Moves
	call AddNTimes ; hl -> that slot's Moves
	push hl
	REPT NUM_MOVES
	ld a, [de]
	ld [hli], a
	inc de
	ENDR
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1PP
	call AddNTimes ; hl -> that slot's PP
	ld d, h
	ld e, l
	dec de ; LoadMovePPs expects de = PP - 1
	pop hl ; hl = Moves address
	predef LoadMovePPs
	ret

.AlakachampMoves: db UPPERCUT, PSYCHIC_M, EARTHQUAKE, SUBMISSION, SWORDS_DANCE
.PinsirMoves:     db WEB_CANNON, VICEGRIP, TWINEEDLE, SWORDS_DANCE, SEISMIC_TOSS
.TyranisMoves:    db DOUBLE_DRILL, HYPER_BEAMS, SKY_ATTACK, BODY_SLAM, FLY
.MiasmaMoves:     db CARRION_WIND, BLIGHT_VOMIT, DRILL_PECK, TOXIC, FLY
.NocturnMoves:    db MIND_FEVER, PHANTOM_WING, NIGHT_SHADE, GUST, CONFUSE_RAY

.TestPartyLoadedText:
	text "Test party loaded!"
	line "5 L100 mons ready."
	prompt
ENDC
