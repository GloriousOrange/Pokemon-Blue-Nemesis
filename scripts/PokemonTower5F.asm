PokemonTower5F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower5TrainerHeaders
	ld de, PokemonTower5F_ScriptPointers
	ld a, [wPokemonTower5FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower5FCurScript], a
	ret

PokemonTower5F_ScriptPointers:
	def_script_pointers
	dw_const PokemonTower5FDefaultScript,           SCRIPT_POKEMONTOWER5F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER5F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONTOWER5F_END_BATTLE
	dw_const PokemonTower5FGhostBattleScript,       SCRIPT_POKEMONTOWER5F_GHOST_BATTLE

PokemonTower5FDefaultScript:
	ld hl, PokemonTower5FPurifiedZoneCoords
	call ArePlayerCoordsInArray
	jr c, .in_purified_zone
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]
	ResetEvent EVENT_IN_PURIFIED_ZONE
	jp CheckFightingMapTrainers
.in_purified_zone
	CheckAndSetEvent EVENT_IN_PURIFIED_ZONE
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wStatusFlags4
	set BIT_NO_BATTLES, [hl]
	predef HealParty
	call GBFadeOutToWhite
	call Delay3
	call Delay3
	call GBFadeInFromWhite
; If the player has starter ashes and hasn't completed the ritual yet, the
; purified ground stirs them into a wild encounter instead of just the usual
; heal/flavor text. Only an actual catch consumes the urn -- if the ghost
; flees or faints, the urn stays put and the player can just walk out and
; back in to try again.
	CheckEvent EVENT_STARTER_RESURRECTED
	jr nz, .justFlavorText
	CheckEvent EVENT_STARTER_BECAME_ASHES
	jr z, .justFlavorText
	ld b, URN_OF_ASHES
	call IsItemInBag
	jr z, .justFlavorText           ; Z = NOT in bag (shouldn't happen, but be safe)
	ld a, TEXT_POKEMONTOWER5F_GHOSTSTIRS
	ldh [hTextID], a
	call DisplayTextID
	ld a, [wPartyCount]
	ld [wGhostEncounterPartyCount], a
	ld a, [wStarterAshesSpecies]
	ld [wCurOpponent], a
	ld a, [wStarterAshesLevel]
	ld [wCurEnemyLevel], a
	ld a, SCRIPT_POKEMONTOWER5F_GHOST_BATTLE
	ld [wPokemonTower5FCurScript], a
	ld [wCurMapScript], a
	xor a
	ld [wJoyIgnore], a
	ret
.justFlavorText
	ld a, TEXT_POKEMONTOWER5F_PURIFIEDZONE
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ret

PokemonTower5FGhostBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .resetScripts
	call UpdateSprites
	ld a, [wBattleResult]
	cp $2
	jr nz, .notCaught
	call PatchCaughtGhostStarterType
	ld a, URN_OF_ASHES
	ldh [hItemToRemoveID], a
	call RemoveItemByID
	lb bc, TM_NIGHT_SHADE, 1
	call GiveItem
	lb bc, TM_CONFUSE_RAY, 1
	call GiveItem
	SetEvent EVENT_STARTER_RESURRECTED
	ld hl, PokemonTower5FPurificationText
	call PrintText
	jr .resetScripts
.notCaught
	ld hl, PokemonTower5FGhostFledText
	call PrintText
.resetScripts
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER5F_DEFAULT
	ld [wPokemonTower5FCurScript], a
	ld [wCurMapScript], a
	ret

; Only called right after wBattleResult == 2 (an actual catch, not just a win).
; Locates the newly-caught mon (party if it grew, else the box) and patches its
; type to GHOST + whatever its own OTHER type already was (its native secondary
; type, or its native primary if it was mono-typed) -- so each starter species
; keeps its own flavor (e.g. Pidgey -> GHOST/FLYING) without a per-species table.
PatchCaughtGhostStarterType:
	ld a, [wPartyCount]
	ld c, a
	ld a, [wGhostEncounterPartyCount]
	cp c
	jr z, .caughtInBox              ; count unchanged -> went to the box instead
	ld a, c
	dec a                            ; A = new party slot index (0-based)
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes                   ; HL = new party mon base
	jr .patchTypes
.caughtInBox
	ld a, [wBoxCount]
	dec a                            ; A = new box slot index (0-based)
	ld hl, wBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
	call AddNTimes                   ; HL = new box mon base
.patchTypes
	ld bc, MON_TYPE1
	add hl, bc
	ld a, [hl]                       ; native Type1
	ld d, a
	inc hl
	ld a, [hl]                       ; native Type2
	cp d
	jr nz, .keepNativeType2
	ld a, d                          ; mono-typed: mirror Type1 as the kept type
.keepNativeType2
	ld e, a                          ; E = the type to keep as the new secondary
	dec hl
	ld [hl], GHOST
	inc hl
	ld [hl], e
	ret

PokemonTower5FPurifiedZoneCoords:
	dbmapcoord 10,  8
	dbmapcoord 11,  8
	dbmapcoord 10,  9
	dbmapcoord 11,  9
	db -1 ; end

PokemonTower5F_TextPointers:
	def_text_pointers
	dw_const PokemonTower5FChanneler1Text,   TEXT_POKEMONTOWER5F_CHANNELER1
	dw_const PokemonTower5FChanneler2Text,   TEXT_POKEMONTOWER5F_CHANNELER2
	dw_const PokemonTower5FChanneler3Text,   TEXT_POKEMONTOWER5F_CHANNELER3
	dw_const PokemonTower5FChanneler4Text,   TEXT_POKEMONTOWER5F_CHANNELER4
	dw_const PokemonTower5FChanneler5Text,   TEXT_POKEMONTOWER5F_CHANNELER5
	dw_const PickUpItemText,                 TEXT_POKEMONTOWER5F_NUGGET
	dw_const PokemonTower5FPurifiedZoneText, TEXT_POKEMONTOWER5F_PURIFIEDZONE
	dw_const PokemonTower5FGhostStirsText,   TEXT_POKEMONTOWER5F_GHOSTSTIRS

PokemonTower5TrainerHeaders:
	def_trainers 2
PokemonTower5TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_0, 2, PokemonTower5FChanneler2BattleText, PokemonTower5FChanneler2EndBattleText, PokemonTower5FChanneler2AfterBattleText
PokemonTower5TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_1, 3, PokemonTower5FChanneler3BattleText, PokemonTower5FChanneler3EndBattleText, PokemonTower5FChanneler3AfterBattleText
PokemonTower5TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_2, 2, PokemonTower5FChanneler4BattleText, PokemonTower5FChanneler4EndBattleText, PokemonTower5FChanneler4AfterBattleText
PokemonTower5TrainerHeader3:
	trainer EVENT_BEAT_POKEMONTOWER_5_TRAINER_3, 2, PokemonTower5FChanneler5BattleText, PokemonTower5FChanneler5EndBattleText, PokemonTower5FChanneler5AfterBattleText
	db -1 ; end

; Flavor/hint text only -- the ritual itself now happens by stepping into the
; purified zone (PokemonTower5FDefaultScript/PokemonTower5FGhostBattleScript),
; which starts a real, catchable wild encounter instead of an instant add.
PokemonTower5FChanneler1Text:
	text_asm
	CheckEvent EVENT_STARTER_RESURRECTED
	jr nz, .after_ritual
	CheckEvent EVENT_STARTER_BECAME_ASHES
	jr z, .no_ashes
	ld hl, PokemonTower5FChanneler1SensesAshesText
	call PrintText
	jp TextScriptEnd
.after_ritual:
	ld hl, PokemonTower5FChanneler1AfterText
	call PrintText
	jp TextScriptEnd
.no_ashes:
	ld hl, PokemonTower5FChanneler1NormalText
	call PrintText
	jp TextScriptEnd

PokemonTower5FChanneler1NormalText:
	text_far _PokemonTower5FChanneler1NormalText
	text_end

PokemonTower5FChanneler1SensesAshesText:
	text_far _PokemonTower5FChanneler1SensesAshesText
	text_end

PokemonTower5FPurificationText:
	text_far _PokemonTower5FPurificationText
	text_end

PokemonTower5FChanneler1AfterText:
	text_far _PokemonTower5FChanneler1AfterText
	text_end

PokemonTower5FGhostStirsText:
	text_far _PokemonTower5FGhostStirsText
	text_end

PokemonTower5FGhostFledText:
	text_far _PokemonTower5FGhostFledText
	text_end

PokemonTower5FChanneler2Text:
	text_asm
	ld hl, PokemonTower5TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower5FChanneler2BattleText:
	text_far _PokemonTower5FChanneler2BattleText
	text_end

PokemonTower5FChanneler2EndBattleText:
	text_far _PokemonTower5FChanneler2EndBattleText
	text_end

PokemonTower5FChanneler2AfterBattleText:
	text_far _PokemonTower5FChanneler2AfterBattleText
	text_end

PokemonTower5FChanneler3Text:
	text_asm
	ld hl, PokemonTower5TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower5FChanneler3BattleText:
	text_far _PokemonTower5FChanneler3BattleText
	text_end

PokemonTower5FChanneler3EndBattleText:
	text_far _PokemonTower5FChanneler3EndBattleText
	text_end

PokemonTower5FChanneler3AfterBattleText:
	text_far _PokemonTower5FChanneler3AfterBattleText
	text_end

PokemonTower5FChanneler4Text:
	text_asm
	ld hl, PokemonTower5TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower5FChanneler4BattleText:
	text_far _PokemonTower5FChanneler4BattleText
	text_end

PokemonTower5FChanneler4EndBattleText:
	text_far _PokemonTower5FChanneler4EndBattleText
	text_end

PokemonTower5FChanneler4AfterBattleText:
	text_far _PokemonTower5FChanneler4AfterBattleText
	text_end

PokemonTower5FChanneler5Text:
	text_asm
	ld hl, PokemonTower5TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower5FChanneler5BattleText:
	text_far _PokemonTower5FChanneler5BattleText
	text_end

PokemonTower5FChanneler5EndBattleText:
	text_far _PokemonTower5FChanneler5EndBattleText
	text_end

PokemonTower5FChanneler5AfterBattleText:
	text_far _PokemonTower5FChanneler5AfterBattleText
	text_end

PokemonTower5FPurifiedZoneText:
	text_far _PokemonTower5FPurifiedZoneText
	text_end
