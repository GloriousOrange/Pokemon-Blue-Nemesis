; Shared girlfriend (Megan) interaction, called via farcall from each Megan NPC's
; text. The caller stores the location index in wMeganLocIndex first (farcall would
; clobber `a`). She heals your party, and the first time you meet her at a given
; location she hands over that location's gift (MeganGiftTable, 0 = no gift yet).

MeganTalk::
	ld hl, MeganGreetingText
	call PrintText
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	predef HealParty
	ld a, [wDifficulty]
	cp DIFFICULTY_HARD
	jp z, .hardMode
	; look up this location's first-visit gift (item, quantity); item 0 = none yet
	ld a, [wMeganLocIndex]
	add a ; 2 bytes per table entry
	ld e, a
	ld d, 0
	ld hl, MeganGiftTable
	add hl, de
	ld a, [hli]
	and a
	jr z, .alreadyVisited ; no gift assigned here -> just heal and chat
	ld b, a ; b = gift item
	ld c, [hl] ; c = quantity
	; Normal mode: Rare Candy and every vitamin except PP Up become a healing
	; item instead (HP_UP..RARE_CANDY is a contiguous item-ID range; PP_UP is
	; a separate ID outside it, so it's untouched)
	ld a, [wDifficulty]
	cp DIFFICULTY_NORMAL
	jr nz, .giftTierOk
	ld a, b
	cp HP_UP
	jr c, .giftTierOk
	cp RARE_CANDY + 1
	jr nc, .giftTierOk
	ld b, SUPER_POTION
.giftTierOk
	push bc ; save item+qty across the visited-mask calc
	ld a, [wMeganLocIndex]
	call MeganGetVisitedMask ; hl = flag byte, a = bit mask for this location
	ld b, a
	and [hl]
	jr nz, .gotGiftAlready ; gift already given here
	ld a, [hl]
	or b
	ld [hl], a ; mark this location's gift as collected
	pop bc ; b = item, c = quantity
	call GiveItem
	ld hl, MeganGiftText
	jp PrintText
.gotGiftAlready
	pop bc ; balance the stack
.alreadyVisited
	ld hl, MeganHealedText
	jp PrintText

.hardMode
; Hard mode: no gifts anywhere except a one-time bundle at Victory Road
; (near the Elite Four) -- 3x PP Up, 1x Max Revive, 1x TM Body Slam.
	ld a, [wMeganLocIndex]
	cp MEGAN_LOC_VICTORY_ROAD
	jr nz, .alreadyVisited
	call MeganGetVisitedMask
	ld b, a
	and [hl]
	jr nz, .alreadyVisited ; already given
	ld a, [hl]
	or b
	ld [hl], a
	ld b, PP_UP
	ld c, 3
	call GiveItem
	ld b, MAX_REVIVE
	ld c, 1
	call GiveItem
	ld b, TM_BODY_SLAM
	ld c, 1
	call GiveItem
	ld hl, MeganGiftText
	jp PrintText


; a = location index -> hl = &wMeganVisitedFlags[index / 8], a = 1 << (index % 8)
MeganGetVisitedMask:
	ld c, a
	srl a
	srl a
	srl a
	ld e, a
	ld d, 0
	ld hl, wMeganVisitedFlags
	add hl, de
	ld a, c
	and %111
	ld b, a
	ld a, 1
	inc b
.shiftLoop
	dec b
	ret z
	add a
	jr .shiftLoop

; 2 bytes per Megan location index: db ITEM, QUANTITY (ITEM 0 = no gift yet).
; DRAFT of the user's gift list: list positions 1-24 mapped to indices 1-24.
; Custom items "Fried Dragon" / "Ditto Jello" don't exist yet -> 0,0 (TODO: create
; the items, then fill these in). Mapping needs user confirmation (esp. idx 11).
MeganGiftTable:
	db POTION,     1 ;  0 Viridian PC (placeholder; not in user's list)
	db PP_UP,      1 ;  1 Pewter PC
	db PROTEIN,    1 ;  2 Cerulean PC
	db CARBOS,     1 ;  3 Vermilion PC
	db CALCIUM,    1 ;  4 Lavender PC
	db HP_UP,      1 ;  5 Celadon PC
	db RARE_CANDY, 1 ;  6 Fuchsia PC
	db FULL_RESTORE, 1 ;  7 Cinnabar PC    -> Fried Dragon x1 (= FULL_RESTORE, renamed)
	db PP_UP,      1 ;  8 Saffron PC
	db MAX_POTION,   1 ;  9 Mt. Moon PC    -> Ditto Jello x1 (= MAX_POTION, renamed)
	db RARE_CANDY, 2 ; 10 Rock Tunnel PC
	db PP_UP,      2 ; 11 (reserved slot)  -> 2 PP Up
	db PROTEIN,    2 ; 12 Pewter Gym
	db CARBOS,     2 ; 13 Cerulean Gym
	db CALCIUM,    2 ; 14 Vermilion Gym
	db HP_UP,      2 ; 15 Celadon Gym
	db FULL_RESTORE, 2 ; 16 Fuchsia Gym    -> Fried Dragon x2 (= FULL_RESTORE, renamed)
	db MAX_POTION,   2 ; 17 Saffron Gym    -> Ditto Jello x2 (= MAX_POTION, renamed)
	db PP_UP,      3 ; 18 Cinnabar Gym
	db PROTEIN,    3 ; 19 Viridian Gym
	db CALCIUM,    3 ; 20 Rocket HQ (under Game Corner)
	db HP_UP,      3 ; 21 Silph Co.
	db RARE_CANDY, 3 ; 22 Mt. Moon cave
	db FULL_RESTORE, 3 ; 23 Rock Tunnel cave -> Fried Dragon x3 (= FULL_RESTORE, renamed)
	db MAX_POTION,   3 ; 24 Seafoam cave   -> Ditto Jello x3 (= MAX_POTION, renamed)
	db 0,          0 ; 25 Victory Road cave (TBD)
	db 0,          0 ; 26 Cerulean Cave (TBD)
	db 0,          0 ; 27 Diglett's Cave (TBD)
	db POTION,     1 ; 28 Viridian Forest South Gate
	db 0,          0 ; 29 Battle Island house (heal-only, no gift)
	db 0,          0 ; 30 Indigo Plateau Lobby (heal-only, no gift)
	ds 2             ; 31: spare

MeganGreetingText:
	text "MEGAN: Hi, honey!"
	line "Let me freshen up"
	cont "your team!"
	prompt

MeganGiftText:
	text "MEGAN: First time"
	line "here? Take this--"
	cont "with all my love!"
	prompt

MeganHealedText:
	text "MEGAN: All better!"
	line "Go knock 'em dead,"
	cont "sweetie!"
	prompt

; Offers the optional training battle at a gym. [wMeganLocIndex] must already be
; set (farcall clobbers a, so callers set it first). Returns carry set if the
; player accepted: the battle is armed and the caller must point its map script
; at its own Megan-trained script. Carry clear means she just healed as usual.
MeganSparOffer::
	call MeganGetSparParty
	and a
	jr z, .declined ; she does not spar at this location
	call MeganGetTrainedMask
	and [hl]
	jr nz, .declined ; already beaten her here, so just heal
	ld a, [wMeganLocIndex]
	ld hl, MeganTrainOfferText
	cp MEGAN_LOC_FIRST_GYM + 8 ; a gym, or one of the two endgame stops?
	jr c, .gotOffer
	ld hl, MeganSparOfferText
.gotOffer
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declined
	ld a, OPP_MEGAN
	ld [wCurOpponent], a
	call MeganGetSparParty
	ld [wTrainerNo], a
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
; the pointers are read back with this bank loaded, which is this one
	ld hl, MeganTrainWinText
	ld de, MeganTrainLoseText
	call SaveEndBattleTextPointers
	scf
	ret
.declined
	call MeganTalk
	and a ; clear carry: no battle
	ret

; Called from a gym's Megan-trained script once she has actually been beaten.
MeganMarkTrained::
	call MeganGetTrainedMask
	or [hl]
	ld [hl], a
	ret

; [wMeganLocIndex] -> a = her party for that location, 0 if she does not spar there
MeganGetSparParty:
	ld a, [wMeganLocIndex]
	ld e, a
	ld d, 0
	ld hl, MeganSparPartyTable
	add hl, de
	ld a, [hl]
	ret

; Which MeganData party she brings at each of her locations. The two endgame
; stops come after the gyms in party order, so the table is not a plain offset.
MeganSparPartyTable:
	ds 12, 0 ; 0-11 Pokecenters and reserved slots: no sparring
	db 2 ; 12 Pewter Gym      Slowpoke L10
	db 3 ; 13 Cerulean Gym    Slowpoke L16
	db 4 ; 14 Vermilion Gym   Slowpoke L20
	db 5 ; 15 Celadon Gym     Slowpoke L26
	db 6 ; 16 Fuchsia Gym     Slowpoke L32
	db 7 ; 17 Saffron Gym     Slowbro  L38
	db 8 ; 18 Cinnabar Gym    Slowbro  L44
	db 9 ; 19 Viridian Gym    Slowbro  L55
	ds 9, 0 ; 20-28 Rocket HQ, Silph, caves, forest gate: no sparring
	db 11 ; 29 Battle Island       Slowbro L100
	db 10 ; 30 Indigo Plateau Lobby Slowbro L70

; -> hl = the flag byte for this location, a = its bit mask
MeganGetTrainedMask:
	call MeganGetSparParty
	sub 2 ; parties #2-#11 map to bits 0-9
	ld b, a
	and %11111000
	rrca
	rrca
	rrca ; byte = bit / 8
	ld e, a
	ld d, 0
	ld hl, wMeganTrainedFlags
	add hl, de
	ld a, b
	and %111
	ld b, a
	ld a, 1
	inc b
.shiftLoop
	dec b
	jr z, .gotMask
	add a
	jr .shiftLoop
.gotMask
	ret

MeganTrainOfferText:
	text "MEGAN: Want to"
	line "train with me"
	cont "before you"
	cont "challenge the"
	cont "gym leader?"
	done

MeganSparOfferText:
	text "MEGAN: One more"
	line "sparring match"
	cont "before you go,"
	cont "sweetie?"
	done

MeganTrainWinText:
	text "MEGAN: That's my"
	line "champ! You're"
	cont "ready for them."
	prompt

MeganTrainLoseText:
	text "MEGAN: Hey, better"
	line "me than the"
	cont "leader, right?"

	para "Come back when"
	line "you've toughened"
	cont "up, sweetie."
	prompt
