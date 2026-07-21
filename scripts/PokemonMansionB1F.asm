PokemonMansionB1F_Script:
	call MansionB1FCheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion4TrainerHeaders
	ld de, PokemonMansionB1F_ScriptPointers
	ld a, [wPokemonMansionB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansionB1FCurScript], a
	ret

MansionB1FCheckReplaceSwitchDoorBlocks:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
; Reveal the secret staircase (down to the Battle Island gate) beside the L100 machine
; once all 6 lab scientists have been beaten. $6e is the facility down-stairs block; its
; stairs tile lands at map coord (25,18), which is warp 2 (see the objects file).
	ld a, [wScientistsDefeated]
	cp %00111111
	jr nz, .noStaircase
	ld a, $6e
	lb bc, 12, 9
	call Mansion2ReplaceBlock
.noStaircase
; Post-game (and the SPEEDTEST kit, which sets this): drop EVERY switch barrier so
; the whole floor is walkable with no puzzle -- the 1F/2F/3F scripts already open in
; post-game, this completes that for B1F. The four switch tiles all take $e (floor)
; safely; each is already a walkable $e in one of the normal switch states.
	ld a, [wPostGameMisc]
	bit BIT_POST_GAME_STARTED, a
	jr nz, .allBarriersOpen
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	ld a, $e
	lb bc, 8, 13
	call Mansion2ReplaceBlock
	ld a, $e
	lb bc, 11, 6
	call Mansion2ReplaceBlock
	ld a, $5f
	lb bc, 3, 4
	call Mansion2ReplaceBlock
	ld a, $54
	lb bc, 8, 8
	call Mansion2ReplaceBlock
	ret
.allBarriersOpen
	ld a, $e
	lb bc, 8, 13
	call Mansion2ReplaceBlock
	ld a, $e
	lb bc, 11, 6
	call Mansion2ReplaceBlock
	ld a, $e
	lb bc, 3, 4
	call Mansion2ReplaceBlock
	ld a, $e
	lb bc, 8, 8
	call Mansion2ReplaceBlock
	ret
.switchTurnedOn
	ld a, $2d
	lb bc, 8, 13
	call Mansion2ReplaceBlock
	ld a, $5f
	lb bc, 11, 6
	call Mansion2ReplaceBlock
	ld a, $e
	lb bc, 3, 4
	call Mansion2ReplaceBlock
	ld a, $e
	lb bc, 8, 8
	call Mansion2ReplaceBlock
	ret

Mansion4Script_Switches::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_POKEMONMANSIONB1F_SWITCH
	ldh [hTextID], a
	jp DisplayTextID

PokemonMansionB1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONMANSIONB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSIONB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSIONB1F_END_BATTLE
	dw_const PokemonMansionB1FLabScientist1PostBattle, SCRIPT_POKEMONMANSIONB1F_LAB_SCIENTIST_1_POST_BATTLE
	dw_const PokemonMansionB1FLabScientist2PostBattle, SCRIPT_POKEMONMANSIONB1F_LAB_SCIENTIST_2_POST_BATTLE

PokemonMansionB1FResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonMansionB1FCurScript], a
	ld [wCurMapScript], a
	ret

; Awards the stone via DisplayTextID (never a bare PrintText from a map tick).
PokemonMansionB1FLabScientistStoneText:
	text_asm
	farcall LabScientistGiveStone
	jp TextScriptEnd

PokemonMansionB1FLabScientist1PostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonMansionB1FResetScripts
	ld hl, wScientistsDefeated
	set 4, [hl] ; lab scientist 5 (Gengar)
	ld a, TEXT_POKEMONMANSIONB1F_LAB_SCIENTIST_STONE
	ldh [hTextID], a
	call DisplayTextID
	jp PokemonMansionB1FResetScripts

PokemonMansionB1FLabScientist2PostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonMansionB1FResetScripts
	ld hl, wScientistsDefeated
	set 5, [hl] ; lab scientist 6 (Ditto)
	ld a, TEXT_POKEMONMANSIONB1F_LAB_SCIENTIST_STONE
	ldh [hTextID], a
	call DisplayTextID
	jp PokemonMansionB1FResetScripts

PokemonMansionB1F_TextPointers:
	def_text_pointers
	dw_const PokemonMansionB1FBurglarText,   TEXT_POKEMONMANSIONB1F_BURGLAR
	dw_const PokemonMansionB1FScientistText, TEXT_POKEMONMANSIONB1F_SCIENTIST
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_RARE_CANDY
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_FULL_RESTORE
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_TM_BLIZZARD
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_TM_SOLARBEAM
	dw_const PokemonMansionB1FDiaryText,     TEXT_POKEMONMANSIONB1F_DIARY
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_SECRET_KEY
	dw_const PokemonMansionB1FLabScientist1Text, TEXT_POKEMONMANSIONB1F_LAB_SCIENTIST_1
	dw_const PokemonMansionB1FLabScientist2Text, TEXT_POKEMONMANSIONB1F_LAB_SCIENTIST_2
	dw_const PokemonMansionB1FLevelMachineText,  TEXT_POKEMONMANSIONB1F_LEVEL_MACHINE
	dw_const PokemonMansion2FSwitchText,     TEXT_POKEMONMANSIONB1F_SWITCH ; This switch uses the text script from the 2F.
	dw_const PokemonMansionB1FLabScientistStoneText, TEXT_POKEMONMANSIONB1F_LAB_SCIENTIST_STONE

Mansion4TrainerHeaders:
	def_trainers
Mansion4TrainerHeader0:
	trainer EVENT_BEAT_MANSION_4_TRAINER_0, 0, PokemonMansionB1FBurglarBattleText, PokemonMansionB1FBurglarEndBattleText, PokemonMansionB1FBurglarAfterBattleText
Mansion4TrainerHeader1:
	trainer EVENT_BEAT_MANSION_4_TRAINER_1, 3, PokemonMansionB1FScientistBattleText, PokemonMansionB1FScientistEndBattleText, PokemonMansionB1FScientistAfterBattleText
	db -1 ; end

PokemonMansionB1FBurglarText:
	text_asm
	ld hl, Mansion4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansionB1FScientistText:
	text_asm
	ld hl, Mansion4TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansionB1FBurglarBattleText:
	text_far _PokemonMansionB1FBurglarBattleText
	text_end

PokemonMansionB1FBurglarEndBattleText:
	text_far _PokemonMansionB1FBurglarEndBattleText
	text_end

PokemonMansionB1FBurglarAfterBattleText:
	text_far _PokemonMansionB1FBurglarAfterBattleText
	text_end

PokemonMansionB1FScientistBattleText:
	text_far _PokemonMansionB1FScientistBattleText
	text_end

PokemonMansionB1FScientistEndBattleText:
	text_far _PokemonMansionB1FScientistEndBattleText
	text_end

PokemonMansionB1FScientistAfterBattleText:
	text_far _PokemonMansionB1FScientistAfterBattleText
	text_end

PokemonMansionB1FDiaryText:
	text_far _PokemonMansionB1FDiaryText
	text_end

PokemonMansionB1FLabScientist1Text:
	text_asm
	ld a, [wScientistsDefeated]
	bit 4, a
	jr nz, .afterBeat
	ld c, 4 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_POKEMONMANSIONB1F_LAB_SCIENTIST_1_POST_BATTLE
	ld [wPokemonMansionB1FCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text_far _PokemonMansionB1FLabScientist1AfterBeatText
	text_end

PokemonMansionB1FLabScientist2Text:
	text_asm
	ld a, [wScientistsDefeated]
	bit 5, a
	jr nz, .afterBeat
	ld c, 5 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_POKEMONMANSIONB1F_LAB_SCIENTIST_2_POST_BATTLE
	ld [wPokemonMansionB1FCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text_far _PokemonMansionB1FLabScientist2AfterBeatText
	text_end

PokemonMansionB1FLevelMachineText:
	text_asm
	ld a, [wScientistsDefeated]
	cp %00111111 ; all 6 lab scientists beaten?
	jr z, .machineReady
	ld hl, .NotReadyText
	call PrintText
	jp TextScriptEnd
.machineReady
; all 6 beaten: make sure the secret staircase (beside the machine) is revealed right now,
; not just on the next map load, so the player can descend on this same visit
	ld a, $6e
	lb bc, 12, 9
	call Mansion2ReplaceBlock
	ld a, [wPartyCount]
	and a
	jr nz, .hasParty
	jp TextScriptEnd ; guard: AnimateHealingMachine loops on wPartyCount
.hasParty
	ld hl, .OfferText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declined
	farcall AnimateHealingMachine
	call PlayDefaultMusic
	ld hl, wPostGameMisc
	set BIT_LEVEL_MACHINE_READY, [hl]
	ld hl, .ReadyText
	call PrintText
	jp TextScriptEnd
.declined
	ld hl, .DeclinedText
	call PrintText
	jp TextScriptEnd

.NotReadyText:
	text_far _PokemonMansionB1FLevelMachineNotReadyText
	text_end

.OfferText:
	text_far _PokemonMansionB1FLevelMachineOfferText
	text_end

.ReadyText:
	text_far _PokemonMansionB1FLevelMachineReadyText
	text_end

.DeclinedText:
	text_far _PokemonMansionB1FLevelMachineDeclinedText
	text_end
