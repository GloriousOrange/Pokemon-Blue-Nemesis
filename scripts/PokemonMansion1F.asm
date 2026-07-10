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
	dw_const PokemonMansion1FRivalApproachWaitScript, SCRIPT_POKEMONMANSION1F_RIVAL_APPROACH
	dw_const PokemonMansion1FRivalStartBattleScript, SCRIPT_POKEMONMANSION1F_RIVAL_START_BATTLE
	dw_const PokemonMansion1FRivalAfterBattleScript, SCRIPT_POKEMONMANSION1F_RIVAL_AFTER_BATTLE
	dw_const PokemonMansion1FRivalLeaveWaitScript,   SCRIPT_POKEMONMANSION1F_RIVAL_LEAVE_WAIT

; The rival's revenge ambush: first time the player walks in from the
; entrance, he's waiting with Oak's Mewtwo (OPP_RIVAL2 party set 13). Same
; trigger discipline as the fixed Silph Co 7F fight: the trigger tick only
; arms sound/music and hands off; no text box opens until the movement
; finishes and the state after that ticks (see the Silph 7F freeze
; postmortem). He's visible ahead at (6,22) and walks down to end up
; face-to-face with the player, same shape as Route22FirstRivalBattleScript.
PokemonMansion1FDefaultScript:
	CheckEvent EVENT_BEAT_LAB_RIVAL_AMBUSH
	jp nz, CheckFightingMapTrainers
	ld hl, .AmbushCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, POKEMONMANSION1F_RIVAL
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, POKEMONMANSION1F_RIVAL
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, [wSavedCoordIndex]
	ld hl, .ApproachMovementPointers
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l
	call MoveSprite
	ld a, SCRIPT_POKEMONMANSION1F_RIVAL_APPROACH
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	ret

.AmbushCoords:
	dbmapcoord  4, 26
	dbmapcoord  5, 26
	dbmapcoord  6, 26
	dbmapcoord  7, 26
	db -1 ; end

; He starts at (6,22); each list walks him down to end adjacent-above
; whichever column the player entered on.
.ApproachMovementPointers:
	dw .ApproachToCol4
	dw .ApproachToCol5
	dw .ApproachToCol6
	dw .ApproachToCol7

; NOTE the leading extra step in each direction run: Gen-1 scripted NPC
; movement spends the first byte of a run turning to face that direction
; (no tile moved), so N tiles need N+1 bytes. Rival starts (6,22), must end
; one tile above the player (row 25) aligned to the entered column.
.ApproachToCol4: ; 3 down, 2 left
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1 ; end

.ApproachToCol5: ; 3 down, 1 left
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db -1 ; end

.ApproachToCol6: ; 3 down, aligned
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

.ApproachToCol7: ; 3 down, 1 right
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

PokemonMansion1FRivalApproachWaitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, POKEMONMANSION1F_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, SCRIPT_POKEMONMANSION1F_RIVAL_START_BATTLE
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	ret

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

; Everything below that prints or prompts goes through DisplayTextID (never
; bare PrintText/GivePokemon from a map-script tick) -- see the Mathus
; captured-flow postmortem, scripts/PokemonTower6F.asm, for why.
PokemonMansion1FRivalAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonMansion1FResetScripts
	xor a
	ld [wJoyIgnore], a
; One-time fight either way -- set the ambush-beaten event now, before the
; win/loss split, so a loss doesn't leave it retriggerable.
	SetEvent EVENT_BEAT_LAB_RIVAL_AMBUSH
	farcall AnyPartyAlive
	ld a, d
	and a
	jr z, .lost
; --- WON ---
; Starter permadeath: only if it was alive going into this fight (an
; already-dead-before-the-fight starter isn't THIS fight's doing). A full
; loss (the .lost branch below) always perishes it regardless, per design.
	CheckEvent EVENT_STARTER_ALIVE_BEFORE_RIVAL2
	jr z, .skip_perish_win
	ld a, TEXT_POKEMONMANSION1F_PERISH
	ldh [hTextID], a
	call DisplayTextID
.skip_perish_win:
	ld a, TEXT_POKEMONMANSION1F_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	call PlayDefaultMusic
	jp PokemonMansion1FResetScripts
; --- LOST --- no blackout on this map pre-ambush (home/overworld.asm). His
; gloat ("You got what you deserved...") already played automatically as the
; in-battle end-text (PokemonMansion1FRivalVictoryText, SaveEndBattleTextPointers'
; lose pointer) -- no second overworld print of it here, that would just be
; the same double-gloat we already fixed once for the Silph 11F Scientist.
; He retreats (MoveSprite, waited on in the next state) and the starter
; always perishes. One-time fight: the ambush-beaten event is already set
; above regardless of outcome, so this doesn't retrigger on a loss either.
.lost:
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a ; keep the player put through the retreat/fade/perish beat
	ld a, POKEMONMANSION1F_RIVAL
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld de, .RivalRetreatMovement
	call MoveSprite
	ld a, SCRIPT_POKEMONMANSION1F_RIVAL_LEAVE_WAIT
	ld [wPokemonMansion1FCurScript], a
	ld [wCurMapScript], a
	ret

.RivalRetreatMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

PokemonMansion1FRivalLeaveWaitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
; Dramatic flash to black as he escapes, but bring the screen back BEFORE any
; text box: DisplayTextID must run with the LCD on, and the perish text_asm
; can open GivePokemon's nickname YES/NO prompt, which needs the d-pad free.
; (Calling DisplayTextID while faded to black + with wJoyIgnore holding the
; d-pad is what froze the loss path -- same two rules as the Mathus/Nocturn
; captured-flow fixes.)
	call GBFadeOutToBlack
	call GBFadeInFromBlack
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_POKEMONMANSION1F_PERISH
	ldh [hTextID], a
	call DisplayTextID
	predef HealParty ; no blackout happened -- patch up the survivors
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
	dw_const PokemonMansion1FPerishText,    TEXT_POKEMONMANSION1F_PERISH

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

; Shared starter-permadeath handler, called from both the win and loss
; after-battle paths. Confirms the starter actually died (HP 0, not already a
; ghost, not already ashes), then either gifts a level 40 RATICATE first (if
; it was the player's only Pokemon -- gift BEFORE removal so the party never
; passes through zero) or goes straight to the ashes/urn text. Hosted in
; text_asm (not called bare) since GivePokemon's nickname prompt needs a
; DisplayTextID-safe context -- see the Mathus captured-flow postmortem.
PokemonMansion1FPerishText:
	text_asm
	CheckEvent EVENT_STARTER_BECAME_ASHES
	jp nz, .done
	ld a, [wPlayerStarter]
	ld b, a
	ld hl, wPartySpecies
	ld c, 0
.find_starter:
	ld a, [hli]
	cp $FF
	jp z, .done
	cp b
	jr z, .found_starter
	inc c
	jr .find_starter
.found_starter:
	push bc
	ld a, c
	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
	ld a, e
	add MON_TYPE2
	ld l, a
	jr nc, .nc_type2
	inc h
.nc_type2:
	ld a, [hl]
	cp GHOST
	jp z, .done ; already a resurrected ghost -- can't die again
	ld h, d
	ld l, e
	inc hl ; MON_HP at +$01
	ld a, [hli]
	or [hl]
	jp nz, .done ; HP > 0, didn't actually die
	ld a, [wPartyCount]
	cp 1
	jr nz, .notOnlyMon
	ld hl, .OnlyMonGiftText
	call PrintText
	lb bc, RATICATE, 40
	call GivePokemon
.notOnlyMon
	farcall SaveStarterToAshes
; Fill wNameBuffer with the starter's name ONLY NOW -- both GivePokemon
; (Raticate) and SaveStarterToAshes' GiveItem (URN OF ASHES) overwrite
; wNameBuffer with their own name, which previously clobbered the starter
; name into "URN OF ASH..." and hung the text box.
	ld a, [wPlayerStarter]
	ld [wNamedObjectIndex], a
	call GetMonName ; -> wNameBuffer, used by .PerishText below
	ld hl, .PerishText
	call PrintText
.done
	jp TextScriptEnd

.OnlyMonGiftText:
	text_far _PokemonMansion1FRivalRaticateGiftText
	text_end

.PerishText:
	text_far _PokemonMansion1FStarterPerishedText
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
