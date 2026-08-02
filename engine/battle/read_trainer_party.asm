ReadTrainer:

; don't change any moves in a link battle
	ld a, [wLinkState]
	and a
	ret nz

; set [wEnemyPartyCount] to 0, [wEnemyPartySpecies] to FF
; XXX first is total enemy pokemon?
; XXX second is species of first pokemon?
	ld hl, wEnemyPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

; get the pointer to trainer data for this class
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET + 1 ; convert value from pokemon to trainer
	add a
	ld hl, TrainerDataPointers
	ld c, a
	ld b, 0
	add hl, bc ; hl points to trainer class
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTrainerNo]
	ld b, a
; At this point b contains the trainer number,
; and hl points to the trainer class.
; Our next task is to iterate through the trainers,
; decrementing b each time, until we get to the right one.
.CheckNextTrainer
	dec b
	jr z, .IterateTrainer
.SkipTrainer
	ld a, [hli]
	and a
	jr nz, .SkipTrainer
	jr .CheckNextTrainer

; if the first byte of trainer data is FF,
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [wLoneAttackNo] != 0, one pokemon on the team has a special move
; else the first byte is the level of every pokemon on the team
.IterateTrainer
	ld a, [hli]
	cp $FF ; is the trainer special?
	jr z, .SpecialTrainer ; if so, check for special moves
	ld [wCurEnemyLevel], a
.LoopTrainerData
	ld a, [hli]
	and a ; have we reached the end of the trainer data?
	jp z, .FinishUp
	ld [wCurPartySpecies], a
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a
	push hl
	call AddPartyMon
	pop hl
	jr .LoopTrainerData
.SpecialTrainer
; if this code is being run:
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [wLoneAttackNo] != 0, one pokemon on the team has a special move
	ld a, [hli]
	and a ; have we reached the end of the trainer data?
	jr z, .AddLoneMove
	ld [wCurEnemyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a
	push hl
	call AddPartyMon
	pop hl
	jr .SpecialTrainer
.AddLoneMove
; does the trainer have a single monster with a different move?
	ld a, [wLoneAttackNo] ; Brock is 01, Misty is 02, Erika is 04, etc
	and a
	jr z, .AddTeamMove
	dec a
	add a
	ld c, a
	ld b, 0
	ld hl, LoneMoves
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld hl, wEnemyMon1Moves + 2
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld [hl], d
	jp .FinishUp
.AddTeamMove
; check if our trainer's team has special moves

; get trainer class number
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET
	ld b, a
	ld hl, TeamMoves

; iterate through entries in TeamMoves, checking each for our trainer class
.IterateTeamMoves
	ld a, [hli]
	cp b
	jr z, .GiveTeamMoves ; is there a match?
	inc hl ; if not, go to the next entry
	inc a
	jr nz, .IterateTeamMoves

; no matches found. is this trainer champion rival?
	ld a, b
	cp RIVAL3
	jr z, .MaybeChampionOrOlympiaRival
	cp SCIENTIST
	jr z, .MaybeLoyalistScientist
	cp RIVAL2
	jr z, .MaybeRival2Special
	cp BUG_CATCHER
	jp z, .MaybeToby
	cp JR_TRAINER_M
	jp z, .MaybeNuggetBridge
	cp LASS
	jp z, .MaybeNuggetBridge
	cp YOUNGSTER
	jp z, .MaybeNuggetBridge
	jp .FinishUp ; nope
.GiveTeamMoves
	ld a, [hl]
	ld [wEnemyMon5Moves + 2], a
	jp .FinishUp
.MaybeChampionOrOlympiaRival
; RIVAL3 covers both the Champion fight (trainer_no 1-37, per-starter) and the
; S.S. Olympia deck superboss (trainer_no 38-40, one per path) -- their
; rosters don't share a shape (Pidgeot/ghost-starter in slots 1/6 vs
; Zapdos/Alakachamp), so branch on wTrainerNo before patching either.
	ld a, [wTrainerNo]
	cp 38
	jp nc, .OlympiaRival
.ChampionRival ; give moves to his team

; pidgeot
	ld a, SKY_ATTACK
	ld [wEnemyMon1Moves + 2], a

; ghost starter — patch TYPE2 to GHOST so type matchups work correctly
	ld a, MON_TYPE2
	ld hl, wEnemyMon6
	add l
	ld l, a
	jr nc, .nc_rival3_type2
	inc h
.nc_rival3_type2:
	ld [hl], GHOST
	jp .FinishUp
.OlympiaRival
; Alakachamp (mon6) comes with Double Team/Counter/Psychic/Mind Fever from its
; own base-stats learnset (4 of 5 slots); patch the empty 5th slot to its
; signature move, Uppercut. The Gengar (mon4, his dead starter's ghost) needs
; no patch -- it's natively GHOST/POISON already.
	ld a, UPPERCUT
	ld [wEnemyMon6Moves + 4], a
	jp .FinishUp
.MaybeLoyalistScientist
; Silph Co 11F Loyalist path scientist (data/trainers/parties.asm #21): Porygon
; (mon 1) knows only Metronome2, no fallback moves, so it always shows the
; move off. LoneMoves/TeamMoves can only patch one of the four move slots,
; not clear the rest, so this needs its own hardcoded case (same reason
; .ChampionRival exists above).
	ld a, [wTrainerNo]
	cp 21
	jp nz, .FinishUp
	ld a, METRONOME2
	ld [wEnemyMon1Moves], a
	xor a
	ld [wEnemyMon1Moves + 1], a
	ld [wEnemyMon1Moves + 2], a
	ld [wEnemyMon1Moves + 3], a
	ld [wEnemyMon1Moves + 4], a ; 5th slot too (NUM_MOVES is 5 in this mod)
	jp .FinishUp
.MaybeRival2Special
	ld a, [wTrainerNo]
	cp 13
	jr z, .LabMewtwo
	cp 10
	jp c, .FinishUp
	cp 12 + 1
	jp nc, .FinishUp
; Route 22 pre-League fight (sets 10-12): the rival's starter died at Silph Co
; and fights on as a true ghost -- both types become GHOST (grants the
; pure-ghost physical immunity, see AdjustDamageForMoveType in core.asm) and
; it knows Night Shade in its 5th move slot.
	ld a, MON_TYPE1
	ld hl, wEnemyMon6
	add l
	ld l, a
	jr nc, .nc_rival2_type1
	inc h
.nc_rival2_type1:
	ld a, GHOST
	ld [hli], a ; MON_TYPE1
	ld [hl], a  ; MON_TYPE2
	ld a, NIGHT_SHADE
	ld [wEnemyMon6Moves + 4], a
	jp .FinishUp
.LabMewtwo
; Burned-lab ambush (set 13): Oak's Mewtwo, custom 5-move set.
	ld hl, wEnemyMon1Moves
	ld a, PSYCHIC_M
	ld [hli], a
	ld a, ICE_BEAM
	ld [hli], a
	ld a, SWIFT
	ld [hli], a
	ld a, AMNESIA
	ld [hli], a
	ld a, RECOVER
	ld [hl], a
	jp .FinishUp
.MaybeNuggetBridge
; The Nugget Bridge line is the custom-move proving ground: five trainers, six
; level 100 mons each, every moveset replaced with Nemesis moves and no vanilla
; moves at all, so one walk across exercises every move added since vanilla.
; Works out which of the five this is (0-4 in e), then copies 6x5 moves in.
	ld a, [wTrainerNo]
	ld c, a
	ld a, b
	cp JR_TRAINER_M
	jr nz, .nbNotJrM
	ld a, c
	cp 2
	ld e, 0
	jr z, .nbCopy
	cp 3
	ld e, 1
	jr z, .nbCopy
	jp .FinishUp
.nbNotJrM
	cp LASS
	jr nz, .nbNotLass
	ld a, c
	cp 7
	ld e, 2
	jr z, .nbCopy
	cp 8
	ld e, 3
	jr z, .nbCopy
	jp .FinishUp
.nbNotLass
	ld a, c
	cp 4 ; YOUNGSTER #4
	ld e, 4
	jr z, .nbCopy
	jp .FinishUp
.nbCopy
; hl = .nbTable + e * 30
	ld hl, .nbTable
	ld bc, 30
.nbSeek
	ld a, e
	and a
	jr z, .nbSeekDone
	add hl, bc
	dec e
	jr .nbSeek
.nbSeekDone
	ld de, wEnemyMon1Moves
	ld c, PARTY_LENGTH
.nbMonLoop
	push bc
	ld b, NUM_MOVES
.nbMoveLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .nbMoveLoop
; step de on to the next mon's move block
	push hl
	ld hl, (wEnemyMon2Moves - wEnemyMon1Moves) - NUM_MOVES
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec c
	jr nz, .nbMonLoop
	jp .FinishUp

.nbTable
; bridge trainer 1
	db HYPER_BEAMS, CARRION_WIND, BLIGHT_VOMIT, MIND_FEVER, PHANTOM_WING
	db WEB_CANNON, UPPERCUT, JACKPOT, SUPER_INSTINCT, CRYSTALLIZE
	db CHAOS_STING, CHOKEHOLD, ROCK_FISTS, HOT_OIL, BAD_TOUCH
	db CRUSH_COIL, BLOOD_SUCK, HURRICANE, ICE_SPIKE, MIGRAIN
	db DIVE, STATIC_SHOCK, GRAVITY_SLAM, VIBRATE, STEALTH
	db TANGLE, ICE_BOMB, ICE_SCULPTURE, STAMPEDE, ROLL
; bridge trainer 2
	db VENOM_BITE, MUD_SLAP, MANDIBLE_BITE, PALM_STRIKE, SCORCH
	db SPARK, PSY_CHOP, DRAGON_BREATH, GLITTER_WING, TELEKINESIS
	db FLAME_WHIP, HYDRO_JET, GIGA_DRAIN, GHOST_BEAM, HYPER_BEAMS
	db CARRION_WIND, BLIGHT_VOMIT, MIND_FEVER, PHANTOM_WING, WEB_CANNON
	db UPPERCUT, JACKPOT, SUPER_INSTINCT, CRYSTALLIZE, CHAOS_STING
	db CHOKEHOLD, ROCK_FISTS, HOT_OIL, BAD_TOUCH, CRUSH_COIL
; bridge trainer 3
	db BLOOD_SUCK, HURRICANE, ICE_SPIKE, MIGRAIN, DIVE
	db STATIC_SHOCK, GRAVITY_SLAM, VIBRATE, STEALTH, TANGLE
	db ICE_BOMB, ICE_SCULPTURE, STAMPEDE, ROLL, VENOM_BITE
	db MUD_SLAP, MANDIBLE_BITE, PALM_STRIKE, SCORCH, SPARK
	db PSY_CHOP, DRAGON_BREATH, GLITTER_WING, TELEKINESIS, FLAME_WHIP
	db HYDRO_JET, GIGA_DRAIN, GHOST_BEAM, HYPER_BEAMS, CARRION_WIND
; bridge trainer 4
	db BLIGHT_VOMIT, MIND_FEVER, PHANTOM_WING, WEB_CANNON, UPPERCUT
	db JACKPOT, SUPER_INSTINCT, CRYSTALLIZE, CHAOS_STING, CHOKEHOLD
	db ROCK_FISTS, HOT_OIL, BAD_TOUCH, CRUSH_COIL, BLOOD_SUCK
	db HURRICANE, ICE_SPIKE, MIGRAIN, DIVE, STATIC_SHOCK
	db GRAVITY_SLAM, VIBRATE, STEALTH, TANGLE, ICE_BOMB
	db ICE_SCULPTURE, STAMPEDE, ROLL, VENOM_BITE, MUD_SLAP
; bridge trainer 5
	db MANDIBLE_BITE, PALM_STRIKE, SCORCH, SPARK, PSY_CHOP
	db DRAGON_BREATH, GLITTER_WING, TELEKINESIS, FLAME_WHIP, HYDRO_JET
	db GIGA_DRAIN, GHOST_BEAM, HYPER_BEAMS, CARRION_WIND, BLIGHT_VOMIT
	db MIND_FEVER, PHANTOM_WING, WEB_CANNON, UPPERCUT, JACKPOT
	db SUPER_INSTINCT, CRYSTALLIZE, CHAOS_STING, CHOKEHOLD, ROCK_FISTS
	db HOT_OIL, BAD_TOUCH, CRUSH_COIL, BLOOD_SUCK, HURRICANE

.MaybeToby
; Elite Four Bug Catcher Toby (BugCatcherData #16). Custom movesets:
; Parasect (mon1) -- Spore + Slash, plus Cut (Bug) so it can hit Ghosts that
; are immune to Normal-type Slash; the generic AI picks the effective move.
	ld a, [wTrainerNo]
	cp 16
	jp nz, .FinishUp
	ld hl, wEnemyMon1Moves
	ld a, SPORE
	ld [hli], a
	ld a, SLASH
	ld [hli], a
	ld a, CUT
	ld [hli], a
	ld a, LEECH_LIFE
	ld [hli], a
	ld a, GROWTH
	ld [hl], a
; Butterfree (mon2) -- Psychic, Sleep Powder, Dream Eater, Stun Spore, Glitter Wing
	ld hl, wEnemyMon2Moves
	ld a, PSYCHIC_M
	ld [hli], a
	ld a, SLEEP_POWDER
	ld [hli], a
	ld a, DREAM_EATER
	ld [hli], a
	ld a, STUN_SPORE
	ld [hli], a
	ld a, GLITTER_WING
	ld [hl], a
; Pinsir (mon5) -- Guillotine, Twineedle, Web Cannon, Slash, Swords Dance
	ld hl, wEnemyMon5Moves
	ld a, GUILLOTINE
	ld [hli], a
	ld a, TWINEEDLE
	ld [hli], a
	ld a, WEB_CANNON
	ld [hli], a
	ld a, SLASH
	ld [hli], a
	ld a, SWORDS_DANCE
	ld [hl], a
.FinishUp
; clear wAmountMoneyWon addresses
	xor a
	ld de, wAmountMoneyWon
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	ld a, [wCurEnemyLevel]
	ld b, a
.LastLoop
; update wAmountMoneyWon addresses (money to win) based on enemy's level
	ld hl, wTrainerBaseMoney + 1
	ld c, 2 ; wAmountMoneyWon is a 3-byte number
	push bc
	predef AddBCDPredef
	pop bc
	inc de
	inc de
	dec b
	jr nz, .LastLoop ; repeat wCurEnemyLevel times
	ret
