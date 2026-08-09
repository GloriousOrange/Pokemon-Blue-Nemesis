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
; Silph Co repro build (user request 2026-08-09): exactly ONE mon in storage --
; a level 100 Pidgeot -- so nothing else in the box can influence the glitch
; being chased. The nine other debug mons that used to live here were dropped
; deliberately; restore them from git history if a future build wants them.
;
; SendNewMonToBox has no overflow guard, so bail without setting the flag if
; the box lacks room; it retries on a later Continue.
	CheckEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	ret nz
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need one free slot
	ret nc
	SetEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	lb bc, PIDGEOT, 100
	ld hl, .PidgeotMoves
	call .GiveBoxedMonWithMoves
ENDC
	ret

; FLY is on the moveset so HM02 in the bag is a spare, not a prerequisite.
; Hyper Beam's power is now Attack + Speed; Pidgeot takes the NORMAL -30 branch
.PidgeotMoves:     db HYPER_BEAM, WING_ATTACK, AGILITY, MIRROR_MOVE, FLY

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

; Landon's custom speed-test kit (user request 2026-08-03, mons updated
; 2026-08-05): the first time any PC is opened, silently deposits 6 L10 mons --
; Dratini, Zapdos, Growlithe, Pinsir, Bulbasaur, Omanyte -- straight into the PC
; box, keeping each one's natural level-10 learnset (no custom moveset patch,
; unlike SpeedtestGiveDebugMons above). Compile with `make blue LANDOSPEEDTEST=1`.
GiveLandoBoxMons::
IF DEF(_LANDOSPEEDTEST)
	CheckEvent EVENT_GOT_LANDO_SPEEDTEST_MONS
	ret nz
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 6 ; need six free slots
	ret nc
	SetEvent EVENT_GOT_LANDO_SPEEDTEST_MONS
	lb bc, DRATINI, 10
	call .GiveNaturalBoxedMon
	lb bc, ZAPDOS, 10
	call .GiveNaturalBoxedMon
	lb bc, GROWLITHE, 10
	call .GiveNaturalBoxedMon
	lb bc, PINSIR, 10
	call .GiveNaturalBoxedMon
	lb bc, BULBASAUR, 10
	call .GiveNaturalBoxedMon
	lb bc, OMANYTE, 10
	call .GiveNaturalBoxedMon
ENDC
	ret

IF DEF(_LANDOSPEEDTEST)
; b = species, c = level -- unmodified natural learnset for that level
.GiveNaturalBoxedMon:
	ld a, b
	ld [wCurPartySpecies], a
	ld a, c
	ld [wCurEnemyLevel], a
	xor a
	ld [wEnemyBattleStatus3], a
	ld a, [wCurPartySpecies]
	ld [wEnemyMonSpecies2], a
	callfar LoadEnemyMonData
	call SetPokedexOwnedFlag
	callfar SendNewMonToBox
	ret
ENDC

; Josh's 6 L10 box mons (Tauros/Pinsir/Zubat/Starmie/Pidgey/Pikachu, added
; 2026-08-05) were removed on 2026-08-09: the Silph Co repro build wants a
; single L100 Pidgeot in storage and nothing else. SpeedtestGiveDebugMons
; above is now the only thing that stocks the box. Restore from git history
; if a later speed-test build wants a starting team again.

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
