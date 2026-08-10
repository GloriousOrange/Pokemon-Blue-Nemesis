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
	push hl
	call SubstituteRivalStarter
	pop hl
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
	push hl
	call SubstituteRivalStarter
	pop hl
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
	cp GHOST_ROCKET
	jp z, .GhostRocketCrew
	cp ASH
	jp z, .AshTeam
	jp .FinishUp ; nope
.GiveTeamMoves
	ld a, [hl]
	ld [wEnemyMon5Moves + 2], a
	jp .FinishUp
.MaybeChampionOrOlympiaRival
; RIVAL3 covers the Champion fight (trainer_no 1-37, per-starter), the six-mon
; superboss (38-40, one per path) and the S.S. Olympia deck fight (41, a lone
; Alakachamp) -- their rosters don't share a shape, so branch on wTrainerNo
; before patching any of them.
	ld a, [wTrainerNo]
	cp 41
; The deck fight is a lone Alakachamp and its moves come from the Olympia hook
; in .FinishUp, so it needs no patch -- but it must still be diverted here, or
; it would fall into .OlympiaRival below and have its species overwritten with
; the rival's dead starter.
	jp z, .FinishUp
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
; mon1 is the rival's dead starter, fighting on as a true ghost. The roster
; can't name it -- he could have started with any of the 37 species in
; Rival3StarterTable -- so patch the species in from wRivalStarter instead of
; carrying 37 rosters per path. This is safe as a late swap because
; LoadEnemyMonData re-derives the mon from its species header and recalculates
; its stats when it is actually sent out (see core.asm, GetMonHeader/CalcStats).
	ld a, [wRivalStarter]
	and a
	jr z, .olympiaGhostTypes ; no starter recorded: keep the roster's fallback
	ld [wEnemyMon1Species], a
	ld [wCurPartySpecies], a
; AddPartyMon already filled its move slots from the *roster's* species
; learnset, which is the wrong mon now. Take the curated Mutagenstone row for
; the real species; if that species has no row yet ApplyMutagenMoveset returns
; without touching the slots, leaving the fallback's moves in place.
	ld de, wEnemyMon1Moves
	callfar ApplyMutagenMoveset
.olympiaGhostTypes
; Force both types to GHOST, which grants the pure-Ghost physical immunity --
; the same treatment the Route 22 dead starter gets in .MaybeRival2Special.
	ld a, GHOST
	ld [wEnemyMon1Type], a
	ld [wEnemyMon1Type + 1], a
; Alakachamp is mon3 in this roster (it was mon6 before the re-theme). It comes
; with Double Team/Counter/Psychic/Mind Fever from its own base-stats learnset,
; so patch the empty 5th slot to its signature move, Uppercut.
	ld a, UPPERCUT
	ld [wEnemyMon3Moves + 4], a
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
.AshTeam
; Only the islet fight (#2) -- the Victory Road ASH (#1) leads with an ordinary
; PIKACHU and takes his moves from its learnset like any other trainer.
	ld a, [wTrainerNo]
	cp 2
	jp nz, .FinishUp
; NOVA_BLITZ into RAICHU's 5th move slot, which AddPartyMon leaves empty because
; base stats only carry four moves -- so nothing natural is lost. PP is written
; by hand for the same reason: the slot was still empty when the PP block was
; filled. RAICHU is mon 1; keep it first in AshData or his opening line stops
; matching what he sends out.
; RAICHU's natural learnset is nearly bare -- it evolves by stone, so a level
; 100 one turns up with THUNDERSHOCK and GROWL. Hand it the curated Mutagenstone
; row instead, which is Josh's own data and already reads
; NOVA_BLITZ / STATIC_SHOCK / BODY_SLAM / AGILITY / HYPER_BEAM. That is also
; what "a mutagenated RAICHU" should look like in a fight.
; Delete these four lines to fall back to the natural learnset.
	ld a, RAICHU
	ld [wCurPartySpecies], a
	ld de, wEnemyMon1Moves
	callfar ApplyMutagenMoveset
	jp .FinishUp

.GhostRocketCrew
; The grotto crew below the Archipelago Cave are all resurrections, so force
; TYPE2 to GHOST on every one of the six -- the same patch .ChampionRival
; makes to the rival's dead starter, and it grants the Gen 1 Ghost immunities
; the fight is built around.
;
; That one write is also what makes them look dead: SetPal_Battle already
; recolours any enemy whose TYPE2 is GHOST to PAL_GHOSTMON, so the spectral
; sprite needs no palette hook of its own. GENGAR is included deliberately --
; its vanilla TYPE2 is POISON, so skipping it would leave the one member of
; the crew that still rendered alive.
;
; Placed down here next to .FinishUp rather than inline in the class-dispatch
; chain above: inserting 40-odd bytes mid-chain pushed that chain's `jr`s past
; their 128-byte reach.
	ld hl, wEnemyMon1Type2
	ld de, PARTYMON_STRUCT_LENGTH
	ld c, PARTY_LENGTH
.ghostTypeLoop
	ld [hl], GHOST
	add hl, de
	dec c
	jr nz, .ghostTypeLoop
; GHOST BEAM goes to ARBOK (mon2) and GENGAR (mon6) only, so the team doesn't
; open with the same move six times. It goes in the 5th move slot, which
; AddPartyMon leaves empty because base stats only carry four moves, so no
; natural move is lost. PP has to be written by hand for that same reason:
; the slot was still empty when AddPartyMon filled the PP block, so it is 0.
	ld a, GHOST_BEAM
	ld [wEnemyMon2Moves + 4], a
	ld [wEnemyMon6Moves + 4], a
	ld a, 5 ; GHOST BEAM's PP -- see data/moves/moves.asm
	ld [wEnemyMon2PP + 4], a
	ld [wEnemyMon6PP + 4], a
	jp .FinishUp

.FinishUp
; Aboard the S.S. OLYMPIA, re-arm the trainer's lone mon from the curated
; MutagenMovesets table. No-op everywhere else, so this sits on the shared
; path rather than being repeated per trainer class.
	callfar ApplyOlympiaTrainerMoveset
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

; ============================================================================
; The rival's starter, in every fight after Oak's Lab.
;
; gen_tables.py generates one Oak's Lab roster per counter species (Rival1Data
; teams 10-43), but the later rosters were never generated -- and the scripts
; that choose them still use vanilla's three-way test:
;
;     cp STARTER2 / cp STARTER3 / else -> the CHARMANDER team
;
; STARTER2 is SQUIRTLE and STARTER3 is BULBASAUR, so a rival holding any of the
; other 34 counter species fell straight through to the CHARMANDER roster.
; Landon's rival picked PONYTA at the lab and turned up at Cerulean with a
; CHARMANDER, then a CHARMELEON, then a CHARIZARD.
;
; Rather than write 102 new rosters, the species is swapped as each mon is
; added: if a roster names a member of a vanilla starter line, that IS the
; starter slot, so substitute what the rival actually carries. Doing it here,
; BEFORE AddPartyMon, means stats and the level-up moveset are both derived
; from the real species -- patching afterwards (what .OlympiaRival has to do)
; leaves the previous species' moves behind.
;
; The Pokemon Tower rosters name no starter at all -- his died at Silph -- so
; they are skipped for free. RIVAL3 already has proper per-species rosters.
;
; In: a = species the roster asked for. Out: a = species to actually add.
SubstituteRivalStarter:
	ld b, a                     ; b = the roster's species
	ld a, [wCurOpponent]
	sub OPP_ID_OFFSET
	cp RIVAL1
	jr z, .isRival
	cp RIVAL2
	jr z, .isRival
	ld a, b
	ret
.isRival
	ld a, [wRivalStarter]
	and a
	jr z, .keep                 ; a save from before the picker existed
	ld c, a                     ; c = the rival's real starter
	ld hl, .VanillaStarterLines
.scan
	ld a, [hli]
	cp -1
	jr z, .keep                 ; not the starter slot; leave this mon alone
	cp b
	jr nz, .scan
	ld a, [wCurEnemyLevel]
	ld b, a
	ld a, c
	jr GetSpeciesEvolvedToLevel ; tail call -- returns the species in a
.keep
	ld a, b
	ret

.VanillaStarterLines:
	db BULBASAUR, IVYSAUR, VENUSAUR
	db CHARMANDER, CHARMELEON, CHARIZARD
	db SQUIRTLE, WARTORTLE, BLASTOISE
	db -1

; Grows a species along its level-up evolutions until it outgrows the level it
; is being added at, so the PONYTA a roster wants at level 40 arrives as a
; RAPIDASH. Only EVOLVE_LEVEL steps are followed: the rival levels his team, he
; does not trade or use stones. EvosMovesPointerTable is in this same bank, so
; no bankswitch is needed.
; In: a = species, b = level. Out: a = species. Clobbers bc, de, hl.
GetSpeciesEvolvedToLevel:
	ld c, a                     ; c = current species; b stays the level
	ld d, 3                     ; guard: no Gen 1 line is longer than this
.restart
	dec d
	jr z, .done
	ld a, c
	dec a
	ld l, a
	ld h, 0
	add hl, hl                  ; (species - 1) * 2
	ld de, EvosMovesPointerTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a                     ; hl -> this species' evolution data
.entry
	ld a, [hli]
	and a
	jr z, .done                 ; end of the evolution list
	cp EVOLVE_LEVEL
	jr z, .levelEvo
	cp EVOLVE_ITEM
	jr z, .itemEvo
	inc hl                      ; EVOLVE_TRADE: level, species
	inc hl
	jr .entry
.itemEvo
	inc hl                      ; item, level, species
	inc hl
	inc hl
	jr .entry
.levelEvo
	ld a, [hli]                 ; the level it evolves at
	ld e, a
	ld a, b                     ; the level this mon is being added at
	cp e
	jr c, .notYet               ; mon's level < evolution level
; Read the target species WITHOUT advancing, so the not-yet path can skip it.
; Do not be tempted to `push af` the species across the compare: `pop af`
; restores the flags too and throws the comparison away, which had every
; starter evolving at level 1.
	ld a, [hl]
	ld c, a
	jr .restart                 ; evolved; rescan in case it evolves again
.notYet
	inc hl                      ; step over the species byte
	jr .entry
.done
	ld a, c
	ret
