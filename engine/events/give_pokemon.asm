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
	CheckEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	ret nz
	SetEvent EVENT_GOT_SPEEDTEST_DEBUG_MONS
	lb bc, STARMIE, 100
	ld hl, .StarmieMoves
	call .GiveBoxedMonWithMoves
	lb bc, DITTO, 100
	ld hl, .DittoMoves
	call .GiveBoxedMonWithMoves
	lb bc, PINSIR, 100
	ld hl, .PinsirMoves
	call .GiveBoxedMonWithMoves
ENDC
	ret

.StarmieMoves:
	db PSYCHIC_M, ICE_BEAM, RECOVER, AMNESIA, SURF
.DittoMoves:
	db THUNDERBOLT, BODY_SLAM, ROCK_SLIDE, FLY, EARTHQUAKE
.PinsirMoves:
	db WEB_CANNON, VICEGRIP, TWINEEDLE, SWORDS_DANCE, SEISMIC_TOSS

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
