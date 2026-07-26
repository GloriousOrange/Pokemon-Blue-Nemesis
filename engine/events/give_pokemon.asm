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
; SendNewMonToBox has no overflow guard of its own, so depositing into a
; (nearly) full box would corrupt it -- each grant below checks its own room
; and bails WITHOUT setting its flag if there isn't enough, so it retries on
; a later Continue.
	CheckEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	jr nz, .birdsAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 2 ; need 3 free box slots for the legendary-bird roster
	jr nc, .birdsAlreadyGiven
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
.birdsAlreadyGiven
; Each signature-move test mon below is guarded by its own bit in
; wSpeedtestExtraMonsGiven (NOT an EVENT_* constant -- that shared array is a
; hard-capped fixed-size resource for real game state, and we ran out of room
; there partway through adding these debug-only conveniences), so each still
; fires independently on saves that already have earlier ones.
	ld hl, wSpeedtestExtraMonsGiven
	bit 0, [hl]
	jr nz, .pinsirAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Pinsir
	jr nc, .pinsirAlreadyGiven
	set 0, [hl]
	lb bc, PINSIR, 100
	ld hl, .PinsirMoves
	call .GiveBoxedMonWithMoves
.pinsirAlreadyGiven
; Persian normally learns Jackpot at level 98 -- boxed here at L100 so it's
; usable immediately.
	ld hl, wSpeedtestExtraMonsGiven
	bit 1, [hl]
	jr nz, .persianAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Persian
	jr nc, .persianAlreadyGiven
	set 1, [hl]
	lb bc, PERSIAN, 100
	ld hl, .PersianMoves
	call .GiveBoxedMonWithMoves
.persianAlreadyGiven
; Hitmonlee normally learns Super Instinct at level 22 -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven
	bit 2, [hl]
	jr nz, .hitmonleeAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Hitmonlee
	jr nc, .hitmonleeAlreadyGiven
	set 2, [hl]
	lb bc, HITMONLEE, 100
	ld hl, .HitmonleeMoves
	call .GiveBoxedMonWithMoves
.hitmonleeAlreadyGiven
; Magmar normally learns Hot Oil at level 36 -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven
	bit 3, [hl]
	jr nz, .magmarAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Magmar
	jr nc, .magmarAlreadyGiven
	set 3, [hl]
	lb bc, MAGMAR, 100
	ld hl, .MagmarMoves
	call .GiveBoxedMonWithMoves
.magmarAlreadyGiven
; Beedrill normally learns Crystallize at level 22 -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven
	bit 4, [hl]
	jr nz, .beedrillAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Beedrill
	jr nc, .beedrillAlreadyGiven
	set 4, [hl]
	lb bc, BEEDRILL, 100
	ld hl, .BeedrillMoves
	call .GiveBoxedMonWithMoves
.beedrillAlreadyGiven
; Zubat normally learns Blood Suck at level 32 -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven
	bit 5, [hl]
	jr nz, .zubatAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Zubat
	jr nc, .zubatAlreadyGiven
	set 5, [hl]
	lb bc, ZUBAT, 100
	ld hl, .ZubatMoves
	call .GiveBoxedMonWithMoves
.zubatAlreadyGiven
; Gyarados normally learns Hurricane at level 42 -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven
	bit 6, [hl]
	jr nz, .gyaradosAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Gyarados
	jr nc, .gyaradosAlreadyGiven
	set 6, [hl]
	lb bc, GYARADOS, 100
	ld hl, .GyaradosMoves
	call .GiveBoxedMonWithMoves
.gyaradosAlreadyGiven
; Electabuzz niche move Static Shock -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven
	bit 7, [hl]
	jr nz, .electabuzzAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Electabuzz
	jr nc, .electabuzzAlreadyGiven
	set 7, [hl]
	lb bc, ELECTABUZZ, 100
	ld hl, .ElectabuzzMoves
	call .GiveBoxedMonWithMoves
.electabuzzAlreadyGiven
; Aerodactyl niche move Gravity Slam -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven2
	bit 0, [hl]
	jr nz, .aerodactylAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Aerodactyl
	jr nc, .aerodactylAlreadyGiven
	set 0, [hl]
	lb bc, AERODACTYL, 100
	ld hl, .AerodactylMoves
	call .GiveBoxedMonWithMoves
.aerodactylAlreadyGiven
; Scyther niche move Stealth -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven2
	bit 1, [hl]
	jr nz, .scytherAlreadyGiven
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Scyther
	jr nc, .scytherAlreadyGiven
	set 1, [hl]
	lb bc, SCYTHER, 100
	ld hl, .ScytherMoves
	call .GiveBoxedMonWithMoves
.scytherAlreadyGiven
; Lapras niche move Ice Bomb -- boxed here at L100.
	ld hl, wSpeedtestExtraMonsGiven2
	bit 2, [hl]
	ret nz
	ld a, [wBoxCount]
	cp MONS_PER_BOX - 1 ; need 1 free box slot for Lapras
	ret nc
	set 2, [hl]
	lb bc, LAPRAS, 100
	ld hl, .LaprasMoves
	call .GiveBoxedMonWithMoves
ENDC
	ret

.TyranisMoves:    db DOUBLE_DRILL, HYPER_BEAMS, SKY_ATTACK, BODY_SLAM, FLY
.MiasmaMoves:     db CARRION_WIND, BLIGHT_VOMIT, DRILL_PECK, TOXIC, FLY
.NocturnMoves:    db MIND_FEVER, PHANTOM_WING, NIGHT_SHADE, GUST, CONFUSE_RAY
.PinsirMoves:     db WEB_CANNON, VIBRATE, TWINEEDLE, SWORDS_DANCE, SEISMIC_TOSS
.PersianMoves:    db JACKPOT, SLASH, SCREECH, BITE, FURY_SWIPES
.HitmonleeMoves:  db SUPER_INSTINCT, HI_JUMP_KICK, ROLLING_KICK, DOUBLE_KICK, MEGA_KICK
.MagmarMoves:     db HOT_OIL, FIRE_PUNCH, FLAMETHROWER, SMOKESCREEN, CONFUSE_RAY
.BeedrillMoves:   db CRYSTALLIZE, CHAOS_STING, TWINEEDLE, PIN_MISSILE, AGILITY
.ZubatMoves:      db BLOOD_SUCK, BITE, WING_ATTACK, CONFUSE_RAY, SUPERSONIC
.GyaradosMoves:   db HURRICANE, DRAGON_RAGE, HYDRO_PUMP, BITE, THRASH
.ElectabuzzMoves: db STATIC_SHOCK, THUNDERPUNCH, QUICK_ATTACK, SCREECH, LIGHT_SCREEN
.AerodactylMoves: db GRAVITY_SLAM, WING_ATTACK, ROCK_SLIDE, BITE, HYPER_BEAM
.ScytherMoves:    db STEALTH, SLASH, SWORDS_DANCE, AGILITY, QUICK_ATTACK
.LaprasMoves:     db ICE_BOMB, SURF, ICE_BEAM, BODY_SLAM, CONFUSE_RAY

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
