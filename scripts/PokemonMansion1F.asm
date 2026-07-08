PokemonMansion1F_Script:
	call Mansion1CheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion1TrainerHeaders
	ld de, PokemonMansion1F_ScriptPointers
	ld a, [wPokemonMansion1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansion1FCurScript], a
	ret

Mansion1CheckReplaceSwitchDoorBlocks:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	lb bc, 6, 12
	call Mansion1LoadEmptyFloorTileBlock
	lb bc, 3, 8
	call Mansion1LoadHorizontalGateBlock
	lb bc, 8, 10
	call Mansion1LoadHorizontalGateBlock
	lb bc, 13, 13
	jp Mansion1LoadHorizontalGateBlock
.switchTurnedOn
	lb bc, 6, 12
	call Mansion1LoadHorizontalGateBlock
	lb bc, 3, 8
	call Mansion1LoadEmptyFloorTileBlock
	lb bc, 8, 10
	call Mansion1LoadEmptyFloorTileBlock
	lb bc, 13, 13
	jp Mansion1LoadEmptyFloorTileBlock

Mansion1LoadHorizontalGateBlock:
	ld a, $2d
	ld [wNewTileBlockID], a
	jr Mansion1ReplaceBlock

Mansion1LoadEmptyFloorTileBlock:
	ld a, $e
	ld [wNewTileBlockID], a
Mansion1ReplaceBlock:
	predef ReplaceTileBlock
	ret

Mansion1Script_Switches::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_POKEMONMANSION1F_SWITCH
	ldh [hTextID], a
	jp DisplayTextID

PokemonMansion1F_ScriptPointers:
	def_script_pointers
	dw_const PokemonMansion1FDefaultScript,         SCRIPT_POKEMONMANSION1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSION1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSION1F_END_BATTLE
	dw_const PokemonMansion1FLabScientistPostBattle, SCRIPT_POKEMONMANSION1F_LAB_SCIENTIST_POST_BATTLE
	dw_const PokemonMansion1FRivalStartBattleScript, SCRIPT_POKEMONMANSION1F_RIVAL_START_BATTLE
	dw_const PokemonMansion1FRivalAfterBattleScript, SCRIPT_POKEMONMANSION1F_RIVAL_AFTER_BATTLE

; The rival's revenge ambush: first time the player walks in from the
; entrance, he's waiting with Oak's Mewtwo (OPP_RIVAL2 party set 13). Same
; trigger discipline as the fixed Silph Co 7F fight: the trigger tick only
; arms sound/music and hands off; no text box opens until the next script
; tick (see the Silph 7F freeze postmortem).
PokemonMansion1FDefaultScript:
	CheckEvent EVENT_BEAT_LAB_RIVAL_AMBUSH
	jp nz, CheckFightingMapTrainers
	ld hl, .AmbushCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, SCRIPT_POKEMONMANSION1F_RIVAL_START_BATTLE
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	ret

.AmbushCoords:
	dbmapcoord  4, 26
	dbmapcoord  5, 26
	dbmapcoord  6, 26
	dbmapcoord  7, 26
	db -1 ; end

PokemonMansion1FRivalStartBattleScript:
	xor a
	ld [wJoyIgnore], a
	call Delay3
	ld a, TEXT_POKEMONMANSION1F_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
; Record whether the starter is alive entering this battle -- if it faints in
; THIS fight it dies for real (SaveStarterToAshes in the after-battle script).
	CheckEvent EVENT_STARTER_BECAME_ASHES
	jr nz, .skip_pre_alive_check
	ld a, [wPlayerStarter]
	ld b, a
	ld hl, wPartySpecies
	ld c, 0
.find_starter_pre:
	ld a, [hli]
	cp $FF
	jr z, .skip_pre_alive_check
	cp b
	jr z, .found_starter_pre
	inc c
	jr .find_starter_pre
.found_starter_pre:
	push bc
	ld a, c
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	inc hl                         ; MON_HP at +$01
	ld a, [hli]
	or [hl]
	jr z, .skip_pre_alive_check    ; HP already 0, don't set flag
	SetEvent EVENT_STARTER_ALIVE_BEFORE_RIVAL2
.skip_pre_alive_check:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PokemonMansion1FRivalDefeatedText
	ld de, PokemonMansion1FRivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL2
	ld [wCurOpponent], a
	ld a, 13 ; solo L70 Mewtwo (data/trainers/parties.asm)
	ld [wTrainerNo], a
	ld a, SCRIPT_POKEMONMANSION1F_RIVAL_AFTER_BATTLE
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonMansion1FRivalAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonMansion1FResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_LAB_RIVAL_AMBUSH
; Starter permadeath: if it was alive going in and is at 0 HP now, it becomes
; ashes (unless it's already a resurrected ghost -- those can't die again).
	CheckEvent EVENT_STARTER_ALIVE_BEFORE_RIVAL2
	jr z, .skip_ashes_check
	CheckEvent EVENT_STARTER_BECAME_ASHES
	jr nz, .skip_ashes_check
	ld a, [wPlayerStarter]
	ld b, a
	ld hl, wPartySpecies
	ld c, 0
.find_starter_post:
	ld a, [hli]
	cp $FF
	jr z, .skip_ashes_check
	cp b
	jr z, .found_starter_post
	inc c
	jr .find_starter_post
.found_starter_post:
	push bc
	ld a, c
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	; Save base in DE; check TYPE2 -- ghost starters skip the ashes mechanic
	ld d, h
	ld e, l
	ld a, e
	add MON_TYPE2
	ld l, a
	jr nc, .nc_type2_post
	inc h
.nc_type2_post:
	ld a, [hl]
	cp GHOST
	jr z, .skip_ashes_check        ; already a ghost -- can't become ashes
	ld h, d
	ld l, e
	inc hl                         ; MON_HP at +$01
	ld a, [hli]
	or [hl]
	jr nz, .skip_ashes_check       ; HP > 0, starter survived
	farcall SaveStarterToAshes
; DisplayTextID, not bare PrintText -- printing from the map-script loop
; without DisplayTextID's VRAM setup/restore corrupts overworld sprites
; (see the Mathus captured-flow postmortem, scripts/PokemonTower6F.asm).
	ld a, TEXT_POKEMONMANSION1F_STARTER_ASHES
	ldh [hTextID], a
	call DisplayTextID
.skip_ashes_check:
	ld a, TEXT_POKEMONMANSION1F_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	call PlayDefaultMusic
	jp PokemonMansion1FResetScripts

PokemonMansion1FLabScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonMansion1FResetScripts
	ld hl, wScientistsDefeated
	set 0, [hl] ; lab scientist 1 (Porygon)
	farcall LabScientistGiveStone
PokemonMansion1FResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonMansion1F_TextPointers:
	def_text_pointers
	dw_const PokemonMansion1FScientistText, TEXT_POKEMONMANSION1F_SCIENTIST
	dw_const PickUpItemText,                TEXT_POKEMONMANSION1F_ESCAPE_ROPE
	dw_const PickUpItemText,                TEXT_POKEMONMANSION1F_CARBOS
	dw_const PokemonMansion1FLabScientistText, TEXT_POKEMONMANSION1F_LAB_SCIENTIST
	dw_const PokemonMansion1FRivalText,     TEXT_POKEMONMANSION1F_RIVAL
	dw_const PokemonMansion1FSwitchText,    TEXT_POKEMONMANSION1F_SWITCH
	dw_const PokemonMansion1FStarterAshesText, TEXT_POKEMONMANSION1F_STARTER_ASHES

Mansion1TrainerHeaders:
	def_trainers
Mansion1TrainerHeader0:
	trainer EVENT_BEAT_MANSION_1_TRAINER_0, 3, PokemonMansion1FScientistBattleText, PokemonMansion1FScientistEndBattleText, PokemonMansion1FScientistAfterBattleText
	db -1 ; end

PokemonMansion1FScientistText:
	text_asm
	ld hl, Mansion1TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansion1FScientistBattleText:
	text_far _PokemonMansion1FScientistBattleText
	text_end

PokemonMansion1FScientistEndBattleText:
	text_far _PokemonMansion1FScientistEndBattleText
	text_end

PokemonMansion1FScientistAfterBattleText:
	text_far _PokemonMansion1FScientistAfterBattleText
	text_end

PokemonMansion1FLabScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 0, a
	jr nz, .afterBeat
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_POKEMONMANSION1F_LAB_SCIENTIST_POST_BATTLE
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text_far _PokemonMansion1FLabScientistAfterBeatText
	text_end

; Shows the ambush challenge before the battle (also what the trigger tick's
; DisplayTextID lands on) and his parting line after it.
PokemonMansion1FRivalText:
	text_asm
	CheckEvent EVENT_BEAT_LAB_RIVAL_AMBUSH
	ld hl, .AfterBattleText
	jr nz, .print
	ld hl, .AmbushText
.print
	call PrintText
	jp TextScriptEnd

.AmbushText:
	text_far _PokemonMansion1FRivalAmbushText
	text_end

.AfterBattleText:
	text_far _PokemonMansion1FRivalAfterBattleText
	text_end

PokemonMansion1FRivalDefeatedText:
	text_far _PokemonMansion1FRivalDefeatedText
	text_end

PokemonMansion1FRivalVictoryText:
	text_far _PokemonMansion1FRivalVictoryText
	text_end

PokemonMansion1FStarterAshesText:
	text_far _Route22StarterAshesText
	text_end

PokemonMansion1FSwitchText:
	text_asm
	ld hl, .Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .not_pressed
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ld hl, .PressedText
	call PrintText
	ld a, SFX_GO_INSIDE
	call PlaySound
	CheckAndSetEvent EVENT_MANSION_SWITCH_ON
	jr z, .done
	ResetEventReuseHL EVENT_MANSION_SWITCH_ON
	jr .done
.not_pressed
	ld hl, .NotPressedText
	call PrintText
.done
	jp TextScriptEnd

.Text:
	text_far _PokemonMansion1FSwitchText
	text_end

.PressedText:
	text_far _PokemonMansion1FSwitchPressedText
	text_end

.NotPressedText:
	text_far _PokemonMansion1FSwitchNotPressedText
	text_end
