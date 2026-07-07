OaksLab_Script:
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
	call nz, OaksLabLoadTextPointers2Script
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLab_ScriptPointers
	ld a, [wOaksLabCurScript]
	jp CallFunctionInTable

OaksLab_ScriptPointers:
	def_script_pointers
	dw_const OaksLabDefaultScript,                   SCRIPT_OAKSLAB_DEFAULT
	dw_const OaksLabOakEntersLabScript,              SCRIPT_OAKSLAB_OAK_ENTERS_LAB
	dw_const OaksLabToggleOaksScript,                SCRIPT_OAKSLAB_TOGGLE_OAKS
	dw_const OaksLabPlayerEntersLabScript,           SCRIPT_OAKSLAB_PLAYER_ENTERS_LAB
	dw_const OaksLabFollowedOakScript,               SCRIPT_OAKSLAB_FOLLOWED_OAK
	dw_const OaksLabOakChooseMonSpeechScript,        SCRIPT_OAKSLAB_OAK_CHOOSE_MON_SPEECH
	dw_const OaksLabPlayerDontGoAwayScript,          SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	dw_const OaksLabPlayerForcedToWalkBackScript,    SCRIPT_OAKSLAB_PLAYER_FORCED_TO_WALK_BACK_SCRIPT
	dw_const OaksLabChoseStarterScript,              SCRIPT_OAKSLAB_CHOSE_STARTER_SCRIPT
	dw_const OaksLabRivalChoosesStarterScript,       SCRIPT_OAKSLAB_RIVAL_CHOOSES_STARTER
	dw_const OaksLabRivalChallengesPlayerScript,     SCRIPT_OAKSLAB_RIVAL_CHALLENGES_PLAYER
	dw_const OaksLabRivalStartBattleScript,          SCRIPT_OAKSLAB_RIVAL_START_BATTLE
	dw_const OaksLabRivalEndBattleScript,            SCRIPT_OAKSLAB_RIVAL_END_BATTLE
	dw_const OaksLabRivalStartsExitScript,           SCRIPT_OAKSLAB_RIVAL_STARTS_EXIT
	dw_const OaksLabPlayerWatchRivalExitScript,      SCRIPT_OAKSLAB_PLAYER_WATCH_RIVAL_EXIT
	dw_const OaksLabRivalArrivesAtOaksRequestScript, SCRIPT_OAKSLAB_RIVAL_ARRIVES_AT_OAKS_REQUEST
	dw_const OaksLabOakGivesPokedexScript,           SCRIPT_OAKSLAB_OAK_GIVES_POKEDEX
	dw_const OaksLabRivalLeavesWithPokedexScript,    SCRIPT_OAKSLAB_RIVAL_LEAVES_WITH_POKEDEX
	dw_const OaksLabPickerLoopScript,                SCRIPT_OAKSLAB_PICKER_LOOP
	dw_const OaksLabNoopScript,                      SCRIPT_OAKSLAB_NOOP

OaksLabDefaultScript:
	CheckEvent EVENT_OAK_APPEARED_IN_PALLET
	ret z
	ld a, [wNPCMovementScriptFunctionNum]
	and a
	ret nz
	ld a, TOGGLE_OAKS_LAB_OAK_2
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld hl, wStatusFlags4
	res BIT_NO_BATTLES, [hl]

	ld a, SCRIPT_OAKSLAB_OAK_ENTERS_LAB
	ld [wOaksLabCurScript], a
	ret

OaksLabOakEntersLabScript:
	ld a, OAKSLAB_OAK2
	ldh [hSpriteIndex], a
	ld de, OakEntryMovement
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_TOGGLE_OAKS
	ld [wOaksLabCurScript], a
	ret

OakEntryMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

OaksLabToggleOaksScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_OAKS_LAB_OAK_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_OAKS_LAB_OAK_1
	ld [wToggleableObjectIndex], a
	predef ShowObject

	ld a, SCRIPT_OAKSLAB_PLAYER_ENTERS_LAB
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerEntersLabScript:
	call Delay3
	ld hl, wSimulatedJoypadStatesEnd
	ld de, PlayerEntryMovementRLE
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	xor a
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	ld a, SCRIPT_OAKSLAB_FOLLOWED_OAK
	ld [wOaksLabCurScript], a
	ret

PlayerEntryMovementRLE:
	db PAD_UP, 8
	db -1 ; end

OaksLabFollowedOakScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld hl, wStatusFlags7
	res BIT_NO_MAP_MUSIC, [hl]
	call PlayDefaultMusic

	ld a, SCRIPT_OAKSLAB_OAK_CHOOSE_MON_SPEECH
	ld [wOaksLabCurScript], a
	ret

OaksLabOakChooseMonSpeechScript:
	ld a, TEXT_OAKSLAB_OAK_CHOOSE_MON
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_OAK_ASKED_TO_CHOOSE_MON
	ld a, SCRIPT_OAKSLAB_PICKER_LOOP
	ld [wOaksLabCurScript], a
	ret

OaksLabPickerLoopScript:
	ld a, TEXT_OAKSLAB_PICKER_LOOP
	ldh [hTextID], a
	call DisplayTextID
	ret

OaksLabPlayerDontGoAwayScript:
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld a, TEXT_OAKSLAB_OAK_DONT_GO_AWAY_YET
	ldh [hTextID], a
	call DisplayTextID
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	ld a, SCRIPT_OAKSLAB_PLAYER_FORCED_TO_WALK_BACK_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabPlayerForcedToWalkBackScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	ld a, SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	ld [wOaksLabCurScript], a
	ret

OaksLabChoseStarterScript:
	ld a, [wPlayerStarter]
	cp STARTER1
	jr z, .Charmander
	cp STARTER2
	jr z, .Squirtle
	jr .Bulbasaur
.Charmander
	ld de, .MiddleBallMovement1
	ld a, [wYCoord]
	cp 4 ; is the player standing below the table?
	jr z, .moveBlue
	ld de, .MiddleBallMovement2
	jr .moveBlue

.MiddleBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1 ; end

.MiddleBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

.Squirtle
	ld de, .RightBallMovement1
	ld a, [wYCoord]
	cp 4 ; is the player standing below the table?
	jr z, .moveBlue
	ld de, .RightBallMovement2
	jr .moveBlue

.RightBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db -1 ; end

.RightBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

.Bulbasaur
	ld de, .LeftBallMovement1
	ld a, [wXCoord]
	cp 9 ; is the player standing to the right of the table?
	jr nz, .moveBlue
	push hl
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_YPIXELS
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	push hl
	ld [hl], $4c ; SPRITESTATEDATA1_YPIXELS
	inc hl
	inc hl
	ld [hl], $0 ; SPRITESTATEDATA1_XPIXELS
	pop hl
	inc h
	ld [hl], 8 ; SPRITESTATEDATA2_MAPY
	inc hl
	ld [hl], 9 ; SPRITESTATEDATA2_MAPX
	ld de, .LeftBallMovement2 ; the rival is not currently onscreen, so account for that
	pop hl
	jr .moveBlue

.LeftBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
.LeftBallMovement2
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

.moveBlue
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_CHOOSES_STARTER
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalChoosesStarterScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_OAKSLAB_RIVAL_ILL_TAKE_THIS_ONE
	ldh [hTextID], a
	call DisplayTextID
	ld a, [wRivalStarterBallSpriteIndex]
	cp OAKSLAB_CHARMANDER_POKE_BALL
	jr nz, .not_charmander
	ld a, TOGGLE_STARTER_BALL_1
	jr .hideBallAndContinue
.not_charmander
	cp OAKSLAB_SQUIRTLE_POKE_BALL
	jr nz, .not_squirtle
	ld a, TOGGLE_STARTER_BALL_2
	jr .hideBallAndContinue
.not_squirtle
	ld a, TOGGLE_STARTER_BALL_3
.hideBallAndContinue
	ld [wToggleableObjectIndex], a
	predef HideObject
	call Delay3
	ld a, [wRivalStarterTemp]
	ld [wRivalStarter], a
	ld [wCurPartySpecies], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_OAKSLAB_RIVAL_RECEIVED_MON
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_STARTER
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_RIVAL_CHALLENGES_PLAYER
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalChallengesPlayerScript:
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, TEXT_OAKSLAB_RIVAL_ILL_TAKE_YOU_ON
	ldh [hTextID], a
	call DisplayTextID
	ld a, $1
	ldh [hNPCPlayerRelativePosPerspective], a
	ld a, $1
	swap a
	ldh [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ldh a, [hNPCPlayerYDistance]
	dec a
	ldh [hNPCPlayerYDistance], a
	predef FindPathToPlayer
	ld de, wNPCMovementDirections2
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_START_BATTLE
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalStartBattleScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz

	; define which team rival uses, and fight it
	ld a, OPP_RIVAL1
	ld [wCurOpponent], a
	ld a, [wRivalStarter]
	ld hl, RivalSpeciesTeamTable
.searchTeam:
	ld b, [hl]
	inc hl
	cp b
	jr z, .foundTeam
	inc hl
	jr .searchTeam
.foundTeam:
	ld a, [hl]
	ld [wTrainerNo], a
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call GetSpritePosition1
	ld hl, OaksLabRivalIPickedTheWrongPokemonText
	ld de, OaksLabRivalAmIGreatOrWhatText
	call SaveEndBattleTextPointers
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	xor a
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, SCRIPT_OAKSLAB_RIVAL_END_BATTLE
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalEndBattleScript:
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	predef HealParty
	SetEvent EVENT_BATTLED_RIVAL_IN_OAKS_LAB

	ld a, SCRIPT_OAKSLAB_RIVAL_STARTS_EXIT
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalStartsExitScript:
	ld c, 20
	call DelayFrames
	ld a, TEXT_OAKSLAB_RIVAL_SMELL_YOU_LATER
	ldh [hTextID], a
	call DisplayTextID
	farcall Music_RivalAlternateStart
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld de, .RivalExitMovement
	call MoveSprite
	ld a, [wXCoord]
	cp 4
	; move left or right depending on where the player is standing
	jr nz, .moveLeft
	ld a, NPC_MOVEMENT_RIGHT
	jr .next
.moveLeft
	ld a, NPC_MOVEMENT_LEFT
.next
	ld [wNPCMovementDirections], a

	ld a, SCRIPT_OAKSLAB_PLAYER_WATCH_RIVAL_EXIT
	ld [wOaksLabCurScript], a
	ret

.RivalExitMovement
	db NPC_CHANGE_FACING
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN ; walk all the way to the lab door (y=3 -> y=11) and exit
	db -1 ; end

OaksLabPlayerWatchRivalExitScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	jr nz, .checkRivalPosition
	ld a, TOGGLE_OAKS_LAB_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	call PlayDefaultMusic ; reset to map music
	; skip the rival-walks-back-in POKéDEX ceremony (you already have the dex);
	; go straight to the leaves-with-pokedex bookkeeping
	ld a, SCRIPT_OAKSLAB_RIVAL_LEAVES_WITH_POKEDEX
	ld [wOaksLabCurScript], a
	jr .done
; make the player keep facing the rival as he walks away
.checkRivalPosition
	ld a, [wNPCNumScriptedSteps]
	cp $5
	jr nz, .turnPlayerDown
	ld a, [wXCoord]
	cp 4
	jr nz, .turnPlayerLeft
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a
	jr .done
.turnPlayerLeft
	ld a, SPRITE_FACING_LEFT
	ld [wSpritePlayerStateData1FacingDirection], a
	jr .done
.turnPlayerDown
	cp $4
	ret nz
	xor a ; ld a, SPRITE_FACING_DOWN
	ld [wSpritePlayerStateData1FacingDirection], a
.done
	ret

OaksLabRivalArrivesAtOaksRequestScript:
	xor a
	ldh [hJoyHeld], a
	call EnableAutoTextBoxDrawing
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	farcall Music_RivalAlternateStart
	ld a, TEXT_OAKSLAB_RIVAL_GRAMPS
	ldh [hTextID], a
	call DisplayTextID
	call OaksLabCalcRivalMovementScript
	ld a, TOGGLE_OAKS_LAB_RIVAL
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	ld a, NPC_MOVEMENT_UP
	call FillMemory
	ld [hl], $ff
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_OAK_GIVES_POKEDEX
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalFaceUpOakFaceDownScript:
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, OAKSLAB_OAK2
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	jp SetSpriteFacingDirectionAndDelay

OaksLabOakGivesPokedexScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	call EnableAutoTextBoxDrawing
	call PlayDefaultMusic
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_RIVAL_WHAT_DID_YOU_CALL_ME_FOR
	ldh [hTextID], a
	call DisplayTextID
	call DelayFrame
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_OAK_I_HAVE_A_REQUEST
	ldh [hTextID], a
	call DisplayTextID
	call DelayFrame
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_OAK_MY_INVENTION_POKEDEX
	ldh [hTextID], a
	call DisplayTextID
	call DelayFrame
	ld a, TEXT_OAKSLAB_OAK_GOT_POKEDEX
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld a, TOGGLE_POKEDEX_1
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_POKEDEX_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	call OaksLabRivalFaceUpOakFaceDownScript
	ld a, TEXT_OAKSLAB_OAK_THAT_WAS_MY_DREAM
	ldh [hTextID], a
	call DisplayTextID
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	ld a, TEXT_OAKSLAB_RIVAL_LEAVE_IT_ALL_TO_ME
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_POKEDEX
	SetEvent EVENT_OAK_GOT_PARCEL
	ld a, TOGGLE_LYING_OLD_MAN
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_OLD_MAN
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, [wSavedNPCMovementDirections2Index]
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	xor a ; NPC_MOVEMENT_DOWN
	call FillMemory
	ld [hl], $ff
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	farcall Music_RivalAlternateStart
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, SCRIPT_OAKSLAB_RIVAL_LEAVES_WITH_POKEDEX
	ld [wOaksLabCurScript], a
	ret

OaksLabRivalLeavesWithPokedexScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	call PlayDefaultMusic
	ld a, TOGGLE_OAKS_LAB_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject
	; the walk-back-in POKéDEX ceremony is cut; apply its lingering visual side
	; effects here so the lab table and the Viridian old man end up correct
	ld a, TOGGLE_POKEDEX_1
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_POKEDEX_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_LYING_OLD_MAN
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_OLD_MAN
	ld [wToggleableObjectIndex], a
	predef ShowObject
	SetEvent EVENT_1ST_ROUTE22_RIVAL_BATTLE
	ResetEventReuseHL EVENT_2ND_ROUTE22_RIVAL_BATTLE
	SetEventReuseHL EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, TOGGLE_ROUTE_22_RIVAL_1
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, SCRIPT_PALLETTOWN_DAISY
	ld [wPalletTownCurScript], a
	xor a
	ld [wJoyIgnore], a

	ld a, SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a
	ret

OaksLabNoopScript:
	ret

OaksLabScript_RemoveParcel:
	ld hl, wBagItems
	ld bc, 0
.loop
	ld a, [hli]
	cp $ff
	ret z
	cp OAKS_PARCEL
	jr z, .foundParcel
	inc hl
	inc c
	jr .loop
.foundParcel
	ld hl, wNumBagItems
	ld a, c
	ld [wWhichPokemon], a
	ld a, 1
	ld [wItemQuantity], a
	jp RemoveItemFromInventory

OaksLabCalcRivalMovementScript:
	ld a, $7c
	ldh [hSpriteScreenYCoord], a
	ld a, 8
	ldh [hSpriteMapXCoord], a
	ld a, [wYCoord]
	cp 3
	jr nz, .not_below_oak
	ld a, $4
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, 11
	jr .done
.not_below_oak
	cp 1
	jr nz, .not_above_oak
	ld a, $2
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, 9
	jr .done
.not_above_oak
	ld a, $3
	ld [wNPCMovementDirections2Index], a
	ld b, 10
	ld a, [wXCoord]
	cp 4
	jr nz, .not_left_of_oak
	ld a, $40
	jr .done
.not_left_of_oak
	ld a, $20
.done
	ldh [hSpriteScreenXCoord], a
	ld a, b
	ldh [hSpriteMapYCoord], a
	ld a, OAKSLAB_RIVAL
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ret

OaksLabLoadTextPointers2Script:
	ld hl, OaksLab_TextPointers2
	ld a, l
	ld [wCurMapTextPtr], a
	ld a, h
	ld [wCurMapTextPtr + 1], a
	ret

OaksLab_TextPointers:
	def_text_pointers
	dw_const OaksLabRivalText,                    TEXT_OAKSLAB_RIVAL
	dw_const OaksLabCharmanderPokeBallText,       TEXT_OAKSLAB_CHARMANDER_POKE_BALL
	dw_const OaksLabSquirtlePokeBallText,         TEXT_OAKSLAB_SQUIRTLE_POKE_BALL
	dw_const OaksLabBulbasaurPokeBallText,        TEXT_OAKSLAB_BULBASAUR_POKE_BALL
	dw_const OaksLabOak1Text,                     TEXT_OAKSLAB_OAK1
	dw_const OaksLabPokedexText,                  TEXT_OAKSLAB_POKEDEX1
	dw_const OaksLabPokedexText,                  TEXT_OAKSLAB_POKEDEX2
	dw_const OaksLabOak2Text,                     TEXT_OAKSLAB_OAK2
	dw_const OaksLabGirlText,                     TEXT_OAKSLAB_GIRL
	dw_const OaksLabScientistText,                TEXT_OAKSLAB_SCIENTIST1
	dw_const OaksLabScientist2Text,               TEXT_OAKSLAB_SCIENTIST2
	dw_const OaksLabOakDontGoAwayYetText,         TEXT_OAKSLAB_OAK_DONT_GO_AWAY_YET
	dw_const OaksLabRivalIllTakeThisOneText,      TEXT_OAKSLAB_RIVAL_ILL_TAKE_THIS_ONE
	dw_const OaksLabRivalReceivedMonText,         TEXT_OAKSLAB_RIVAL_RECEIVED_MON
	dw_const OaksLabRivalIllTakeYouOnText,        TEXT_OAKSLAB_RIVAL_ILL_TAKE_YOU_ON
	dw_const OaksLabRivalSmellYouLaterText,       TEXT_OAKSLAB_RIVAL_SMELL_YOU_LATER
	dw_const OaksLabRivalFedUpWithWaitingText,    TEXT_OAKSLAB_RIVAL_FED_UP_WITH_WAITING
	dw_const OaksLabOakChooseMonText,             TEXT_OAKSLAB_OAK_CHOOSE_MON
	dw_const OaksLabRivalWhatAboutMeText,         TEXT_OAKSLAB_RIVAL_WHAT_ABOUT_ME
	dw_const OaksLabOakBePatientText,             TEXT_OAKSLAB_OAK_BE_PATIENT
	dw_const OaksLabRivalGrampsText,              TEXT_OAKSLAB_RIVAL_GRAMPS
	dw_const OaksLabRivalWhatDidYouCallMeForText, TEXT_OAKSLAB_RIVAL_WHAT_DID_YOU_CALL_ME_FOR
	dw_const OaksLabOakIHaveARequestText,         TEXT_OAKSLAB_OAK_I_HAVE_A_REQUEST
	dw_const OaksLabOakMyInventionPokedexText,    TEXT_OAKSLAB_OAK_MY_INVENTION_POKEDEX
	dw_const OaksLabOakGotPokedexText,            TEXT_OAKSLAB_OAK_GOT_POKEDEX
	dw_const OaksLabOakThatWasMyDreamText,        TEXT_OAKSLAB_OAK_THAT_WAS_MY_DREAM
	dw_const OaksLabRivalLeaveItAllToMeText,      TEXT_OAKSLAB_RIVAL_LEAVE_IT_ALL_TO_ME
	dw_const OaksLabPickerLoopText,               TEXT_OAKSLAB_PICKER_LOOP

OaksLab_TextPointers2:
	dw OaksLabRivalText
	dw OaksLabCharmanderPokeBallText
	dw OaksLabSquirtlePokeBallText
	dw OaksLabBulbasaurPokeBallText
	dw OaksLabOak1Text
	dw OaksLabPokedexText
	dw OaksLabPokedexText
	dw OaksLabOak2Text
	dw OaksLabGirlText
	dw OaksLabScientistText
	dw OaksLabScientistText

OaksLabRivalText:
	text_asm
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	jr nz, .beforeChooseMon
	ld hl, .GrampsIsntAroundText
	call PrintText
	jr .done
.beforeChooseMon
	CheckEventReuseA EVENT_GOT_STARTER
	jr nz, .afterChooseMon
	ld hl, .GoAheadAndChooseText
	call PrintText
	jr .done
.afterChooseMon
	ld hl, .MyPokemonLooksStrongerText
	call PrintText
.done
	jp TextScriptEnd

.GrampsIsntAroundText:
	text_far _OaksLabRivalGrampsIsntAroundText
	text_end

.GoAheadAndChooseText:
	text_far _OaksLabRivalGoAheadAndChooseText
	text_end

.MyPokemonLooksStrongerText:
	text_far _OaksLabRivalMyPokemonLooksStrongerText
	text_end

OaksLabPickerLoopText:
	text_asm
	call OaksLabChooseAnyStarterMenu
	call OaksLabSetRivalCounter
	ld a, [wCurPartySpecies]
	ld b, OAKSLAB_BULBASAUR_POKE_BALL
	jr OaksLabSelectedPokeBallScript

OaksLabCharmanderPokeBallText:
	text_asm
	call OaksLabChooseAnyStarterMenu
	call OaksLabSetRivalCounter
	ld a, [wCurPartySpecies]
	ld b, OAKSLAB_BULBASAUR_POKE_BALL
	jr OaksLabSelectedPokeBallScript

OaksLabSquirtlePokeBallText:
	text_asm
	call OaksLabChooseAnyStarterMenu
	call OaksLabSetRivalCounter
	ld a, [wCurPartySpecies]
	ld b, OAKSLAB_BULBASAUR_POKE_BALL
	jr OaksLabSelectedPokeBallScript

OaksLabBulbasaurPokeBallText:
	text_asm
	call OaksLabChooseAnyStarterMenu
	call OaksLabSetRivalCounter
	ld a, [wCurPartySpecies]
	ld b, OAKSLAB_BULBASAUR_POKE_BALL

OaksLabSelectedPokeBallScript:
	ld [wCurPartySpecies], a
	ld [wPokedexNum], a
	ld a, b
	ld [wSpriteIndex], a
	CheckEvent EVENT_GOT_STARTER
	jp nz, OaksLabLastMonScript
	CheckEventReuseA EVENT_OAK_ASKED_TO_CHOOSE_MON
	jr nz, OaksLabCustomShowAndChoose
	ld hl, OaksLabThoseArePokeBallsText
	call PrintText
	jp TextScriptEnd

OaksLabThoseArePokeBallsText:
	text_far _OaksLabThoseArePokeBallsText
	text_end

OaksLabCustomShowAndChoose:
	; Orient Oak and Rival sprites, reload map, then go straight to the
	; "You want this MON?" prompt — skipping predef StarterDex (only works
	; for the original 3 starters).
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_RIGHT
	call ReloadMapData
	ld c, 10
	call DelayFrames
	ld hl, OaksLabWantThisMonText
	jr OaksLabMonChoiceMenu

OaksLabWantThisMonText:
	text_far _OaksLabWantThisMonText
	text_end

OaksLabShowPokeBallPokemonScript:
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_RIGHT
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	predef StarterDex
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call ReloadMapData
	ld c, 10
	call DelayFrames
	ld a, [wSpriteIndex]
	cp OAKSLAB_CHARMANDER_POKE_BALL
	jr z, OaksLabYouWantCharmanderText
	cp OAKSLAB_SQUIRTLE_POKE_BALL
	jr z, OaksLabYouWantSquirtleText
	jr OaksLabYouWantBulbasaurText

OaksLabYouWantCharmanderText:
	ld hl, .Text
	jr OaksLabMonChoiceMenu
.Text:
	text_far _OaksLabYouWantCharmanderText
	text_end

OaksLabYouWantSquirtleText:
	ld hl, .Text
	jr OaksLabMonChoiceMenu
.Text:
	text_far _OaksLabYouWantSquirtleText
	text_end

OaksLabYouWantBulbasaurText:
	ld hl, .Text
	jr OaksLabMonChoiceMenu
.Text:
	text_far _OaksLabYouWantBulbasaurText
	text_end

OaksLabMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jp nz, OaksLabMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, [wSpriteIndex]
	cp OAKSLAB_CHARMANDER_POKE_BALL
	jr nz, .not_charmander
	ld a, TOGGLE_STARTER_BALL_1
	jr .continue
.not_charmander
	cp OAKSLAB_SQUIRTLE_POKE_BALL
	jr nz, .not_squirtle
	ld a, TOGGLE_STARTER_BALL_2
	jr .continue
.not_squirtle
	ld a, TOGGLE_STARTER_BALL_3
.continue
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wOakRemarkStarterIndex]
	ld c, a
	ld b, 0
	ld hl, OakRemarkTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	ld hl, OaksLabReceivedMonText
	call PrintText
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	call AddPartyMon
	ld hl, wStatusFlags4
	set BIT_GOT_STARTER, [hl]
	SetEvent EVENT_GOT_POKEDEX ; start the game with the Pokedex (skips the parcel-return give-scene)
	SetEvent EVENT_OAK_GOT_PARCEL
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, SCRIPT_OAKSLAB_CHOSE_STARTER_SCRIPT
	ld [wOaksLabCurScript], a
OaksLabMonChoiceEnd:
	jp TextScriptEnd

OaksLabRemarkBulbasaurText:
	text_far _OaksLabRemarkBulbasaurText
	text_end

OaksLabRemarkCharmanderText:
	text_far _OaksLabRemarkCharmanderText
	text_end

OaksLabRemarkSquirtleText:
	text_far _OaksLabRemarkSquirtleText
	text_end

OaksLabRemarkCaterpieText:
	text_far _OaksLabRemarkCaterpieText
	text_end

OaksLabRemarkWeedleText:
	text_far _OaksLabRemarkWeedleText
	text_end

OaksLabRemarkPidgeyText:
	text_far _OaksLabRemarkPidgeyText
	text_end

OaksLabRemarkRattataText:
	text_far _OaksLabRemarkRattataText
	text_end

OaksLabRemarkSpearowText:
	text_far _OaksLabRemarkSpearowText
	text_end

OaksLabRemarkEkansText:
	text_far _OaksLabRemarkEkansText
	text_end

OaksLabRemarkPikachuText:
	text_far _OaksLabRemarkPikachuText
	text_end

OaksLabRemarkSandshrewText:
	text_far _OaksLabRemarkSandshrewText
	text_end

OaksLabRemarkNidoranFText:
	text_far _OaksLabRemarkNidoranFText
	text_end

OaksLabRemarkNidoranMText:
	text_far _OaksLabRemarkNidoranMText
	text_end

OaksLabRemarkClefairyText:
	text_far _OaksLabRemarkClefairyText
	text_end

OaksLabRemarkVulpixText:
	text_far _OaksLabRemarkVulpixText
	text_end

OaksLabRemarkJigglypuffText:
	text_far _OaksLabRemarkJigglypuffText
	text_end

OaksLabRemarkZubatText:
	text_far _OaksLabRemarkZubatText
	text_end

OaksLabRemarkOddishText:
	text_far _OaksLabRemarkOddishText
	text_end

OaksLabRemarkParasText:
	text_far _OaksLabRemarkParasText
	text_end

OaksLabRemarkVenonatText:
	text_far _OaksLabRemarkVenonatText
	text_end

OaksLabRemarkDiglettText:
	text_far _OaksLabRemarkDiglettText
	text_end

OaksLabRemarkMeowthText:
	text_far _OaksLabRemarkMeowthText
	text_end

OaksLabRemarkPsyduckText:
	text_far _OaksLabRemarkPsyduckText
	text_end

OaksLabRemarkMankeyText:
	text_far _OaksLabRemarkMankeyText
	text_end

OaksLabRemarkGrowlitheText:
	text_far _OaksLabRemarkGrowlitheText
	text_end

OaksLabRemarkPoliwagText:
	text_far _OaksLabRemarkPoliwagText
	text_end

OaksLabRemarkAbraText:
	text_far _OaksLabRemarkAbraText
	text_end

OaksLabRemarkMachopText:
	text_far _OaksLabRemarkMachopText
	text_end

OaksLabRemarkBellsproutText:
	text_far _OaksLabRemarkBellsproutText
	text_end

OaksLabRemarkTentacoolText:
	text_far _OaksLabRemarkTentacoolText
	text_end

OaksLabRemarkGeodudeText:
	text_far _OaksLabRemarkGeodudeText
	text_end

OaksLabRemarkPonytaText:
	text_far _OaksLabRemarkPonytaText
	text_end

OaksLabRemarkSlowpokeText:
	text_far _OaksLabRemarkSlowpokeText
	text_end

OaksLabRemarkMagnemiteText:
	text_far _OaksLabRemarkMagnemiteText
	text_end

OaksLabRemarkFarfetchdText:
	text_far _OaksLabRemarkFarfetchdText
	text_end

OaksLabRemarkDoduoText:
	text_far _OaksLabRemarkDoduoText
	text_end

OaksLabRemarkSeelText:
	text_far _OaksLabRemarkSeelText
	text_end

OaksLabRemarkGrimerText:
	text_far _OaksLabRemarkGrimerText
	text_end

OaksLabRemarkShellderText:
	text_far _OaksLabRemarkShellderText
	text_end

OaksLabRemarkOnixText:
	text_far _OaksLabRemarkOnixText
	text_end

OaksLabRemarkDrowzeeText:
	text_far _OaksLabRemarkDrowzeeText
	text_end

OaksLabRemarkKrabbyText:
	text_far _OaksLabRemarkKrabbyText
	text_end

OaksLabRemarkVoltorbText:
	text_far _OaksLabRemarkVoltorbText
	text_end

OaksLabRemarkExeggcuteText:
	text_far _OaksLabRemarkExeggcuteText
	text_end

OaksLabRemarkCuboneText:
	text_far _OaksLabRemarkCuboneText
	text_end

OaksLabRemarkHitmonleeText:
	text_far _OaksLabRemarkHitmonleeText
	text_end

OaksLabRemarkHitmonchanText:
	text_far _OaksLabRemarkHitmonchanText
	text_end

OaksLabRemarkLickitungText:
	text_far _OaksLabRemarkLickitungText
	text_end

OaksLabRemarkKoffingText:
	text_far _OaksLabRemarkKoffingText
	text_end

OaksLabRemarkRhyhornText:
	text_far _OaksLabRemarkRhyhornText
	text_end

OaksLabRemarkChanseyText:
	text_far _OaksLabRemarkChanseyText
	text_end

OaksLabRemarkTangelaText:
	text_far _OaksLabRemarkTangelaText
	text_end

OaksLabRemarkKangaskhanText:
	text_far _OaksLabRemarkKangaskhanText
	text_end

OaksLabRemarkHorseaText:
	text_far _OaksLabRemarkHorseaText
	text_end

OaksLabRemarkGoldeenText:
	text_far _OaksLabRemarkGoldeenText
	text_end

OaksLabRemarkStaryuText:
	text_far _OaksLabRemarkStaryuText
	text_end

OaksLabRemarkMrMimeText:
	text_far _OaksLabRemarkMrMimeText
	text_end

OaksLabRemarkScytherText:
	text_far _OaksLabRemarkScytherText
	text_end

OaksLabRemarkJynxText:
	text_far _OaksLabRemarkJynxText
	text_end

OaksLabRemarkElectabuzzText:
	text_far _OaksLabRemarkElectabuzzText
	text_end

OaksLabRemarkMagmarText:
	text_far _OaksLabRemarkMagmarText
	text_end

OaksLabRemarkPinsirText:
	text_far _OaksLabRemarkPinsirText
	text_end

OaksLabRemarkTaurosText:
	text_far _OaksLabRemarkTaurosText
	text_end

OaksLabRemarkMagikarpText:
	text_far _OaksLabRemarkMagikarpText
	text_end

OaksLabRemarkLaprasText:
	text_far _OaksLabRemarkLaprasText
	text_end

OaksLabRemarkDittoText:
	text_far _OaksLabRemarkDittoText
	text_end

OaksLabRemarkEeveeText:
	text_far _OaksLabRemarkEeveeText
	text_end

OaksLabRemarkPorygonText:
	text_far _OaksLabRemarkPorygonText
	text_end

OaksLabRemarkOmanyteText:
	text_far _OaksLabRemarkOmanyteText
	text_end

OaksLabRemarkKabutoText:
	text_far _OaksLabRemarkKabutoText
	text_end

OaksLabRemarkAerodactylText:
	text_far _OaksLabRemarkAerodactylText
	text_end

OaksLabRemarkSnorlaxText:
	text_far _OaksLabRemarkSnorlaxText
	text_end

OaksLabRemarkArticunoText:
	text_far _OaksLabRemarkArticunoText
	text_end

OaksLabRemarkZapdosText:
	text_far _OaksLabRemarkZapdosText
	text_end

OaksLabRemarkMoltresText:
	text_far _OaksLabRemarkMoltresText
	text_end

OaksLabRemarkDratiniText:
	text_far _OaksLabRemarkDratiniText
	text_end

OaksLabRemarkMewtwoText:
	text_far _OaksLabRemarkMewtwoText
	text_end

OaksLabRemarkMewText:
	text_far _OaksLabRemarkMewText
	text_end

; ============================================================
; OakRemarkTable
; Word pointer table indexed by wPokedexNum (0-77, same index as
; StarterSpeciesTable) -> Oak's per-species remark after you pick it.
; Manually maintained; keep in sync with StarterSpeciesTable order.
; ============================================================
OakRemarkTable:
	dw OaksLabRemarkBulbasaurText
	dw OaksLabRemarkCharmanderText
	dw OaksLabRemarkSquirtleText
	dw OaksLabRemarkCaterpieText
	dw OaksLabRemarkWeedleText
	dw OaksLabRemarkPidgeyText
	dw OaksLabRemarkRattataText
	dw OaksLabRemarkSpearowText
	dw OaksLabRemarkEkansText
	dw OaksLabRemarkPikachuText
	dw OaksLabRemarkSandshrewText
	dw OaksLabRemarkNidoranFText
	dw OaksLabRemarkNidoranMText
	dw OaksLabRemarkClefairyText
	dw OaksLabRemarkVulpixText
	dw OaksLabRemarkJigglypuffText
	dw OaksLabRemarkZubatText
	dw OaksLabRemarkOddishText
	dw OaksLabRemarkParasText
	dw OaksLabRemarkVenonatText
	dw OaksLabRemarkDiglettText
	dw OaksLabRemarkMeowthText
	dw OaksLabRemarkPsyduckText
	dw OaksLabRemarkMankeyText
	dw OaksLabRemarkGrowlitheText
	dw OaksLabRemarkPoliwagText
	dw OaksLabRemarkAbraText
	dw OaksLabRemarkMachopText
	dw OaksLabRemarkBellsproutText
	dw OaksLabRemarkTentacoolText
	dw OaksLabRemarkGeodudeText
	dw OaksLabRemarkPonytaText
	dw OaksLabRemarkSlowpokeText
	dw OaksLabRemarkMagnemiteText
	dw OaksLabRemarkFarfetchdText
	dw OaksLabRemarkDoduoText
	dw OaksLabRemarkSeelText
	dw OaksLabRemarkGrimerText
	dw OaksLabRemarkShellderText
	dw OaksLabRemarkOnixText
	dw OaksLabRemarkDrowzeeText
	dw OaksLabRemarkKrabbyText
	dw OaksLabRemarkVoltorbText
	dw OaksLabRemarkExeggcuteText
	dw OaksLabRemarkCuboneText
	dw OaksLabRemarkHitmonleeText
	dw OaksLabRemarkHitmonchanText
	dw OaksLabRemarkLickitungText
	dw OaksLabRemarkKoffingText
	dw OaksLabRemarkRhyhornText
	dw OaksLabRemarkChanseyText
	dw OaksLabRemarkTangelaText
	dw OaksLabRemarkKangaskhanText
	dw OaksLabRemarkHorseaText
	dw OaksLabRemarkGoldeenText
	dw OaksLabRemarkStaryuText
	dw OaksLabRemarkMrMimeText
	dw OaksLabRemarkScytherText
	dw OaksLabRemarkJynxText
	dw OaksLabRemarkElectabuzzText
	dw OaksLabRemarkMagmarText
	dw OaksLabRemarkPinsirText
	dw OaksLabRemarkTaurosText
	dw OaksLabRemarkMagikarpText
	dw OaksLabRemarkLaprasText
	dw OaksLabRemarkDittoText
	dw OaksLabRemarkEeveeText
	dw OaksLabRemarkPorygonText
	dw OaksLabRemarkOmanyteText
	dw OaksLabRemarkKabutoText
	dw OaksLabRemarkAerodactylText
	dw OaksLabRemarkSnorlaxText
	dw OaksLabRemarkArticunoText
	dw OaksLabRemarkZapdosText
	dw OaksLabRemarkMoltresText
	dw OaksLabRemarkDratiniText
	dw OaksLabRemarkMewtwoText
	dw OaksLabRemarkMewText

OaksLabReceivedMonText:
	text_far _OaksLabReceivedMonText
	sound_get_key_item
	text_end

OaksLabLastMonScript:
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld hl, OaksLabLastMonText
	call PrintText
	jp TextScriptEnd

OaksLabLastMonText:
	text_far _OaksLabLastMonText
	text_end

OaksLabOak1Text:
	text_asm
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
	jr nz, .already_got_poke_balls
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	jr c, .check_for_poke_balls
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .check_for_poke_balls
.already_got_poke_balls
	ld hl, .HowIsYourPokedexComingText
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	predef DisplayDexRating
	jp .done
.check_for_poke_balls
	ld b, POKE_BALL
	call IsItemInBag
	jr nz, .come_see_me_sometimes
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr nz, .give_poke_balls
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .mon_around_the_world
	CheckEventReuseA EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	jr nz, .check_got_parcel
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jr nz, .already_got_pokemon
	ld hl, .WhichPokemonDoYouWantText
	call PrintText
	jr .done
.already_got_pokemon
	ld hl, .YourPokemonCanFightText
	call PrintText
	jr .done
.check_got_parcel
	ld b, OAKS_PARCEL
	call IsItemInBag
	jr nz, .got_parcel
	ld hl, .RaiseYourYoungPokemonText
	call PrintText
	jr .done
.got_parcel
	ld hl, .DeliverParcelText
	call PrintText
	call OaksLabScript_RemoveParcel
	ld a, SCRIPT_OAKSLAB_RIVAL_ARRIVES_AT_OAKS_REQUEST
	ld [wOaksLabCurScript], a
	jr .done
.mon_around_the_world
	ld hl, .PokemonAroundTheWorldText
	call PrintText
	jr .done
.give_poke_balls
	CheckAndSetEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr nz, .come_see_me_sometimes
	lb bc, POKE_BALL, 5
	call GiveItem
	ld hl, .GivePokeballsText
	call PrintText
	jr .done
.come_see_me_sometimes
	ld hl, .ComeSeeMeSometimesText
	call PrintText
.done
	jp TextScriptEnd

.WhichPokemonDoYouWantText:
	text_far _OaksLabOak1WhichPokemonDoYouWantText
	text_end

.YourPokemonCanFightText:
	text_far _OaksLabOak1YourPokemonCanFightText
	text_end

.RaiseYourYoungPokemonText:
	text_far _OaksLabOak1RaiseYourYoungPokemonText
	text_end

.DeliverParcelText:
	text_far _OaksLabOak1DeliverParcelText
	sound_get_key_item
	text_far _OaksLabOak1ParcelThanksText
	text_end

.PokemonAroundTheWorldText:
	text_far _OaksLabOak1PokemonAroundTheWorldText
	text_end

.GivePokeballsText:
	text_far _OaksLabOak1ReceivedPokeballsText
	sound_get_key_item
	text_far _OaksLabGivePokeballsExplanationText
	text_end

.ComeSeeMeSometimesText:
	text_far _OaksLabOak1ComeSeeMeSometimesText
	text_end

.HowIsYourPokedexComingText:
	text_far _OaksLabOak1HowIsYourPokedexComingText
	text_end

OaksLabPokedexText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabPokedexText
	text_end

OaksLabOak2Text:
	text_far _OaksLabOak2Text
	text_end

OaksLabGirlText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabGirlText
	text_end

OaksLabRivalFedUpWithWaitingText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalFedUpWithWaitingText
	text_end

OaksLabOakChooseMonText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabOakChooseMonText
	text_end

OaksLabRivalWhatAboutMeText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalWhatAboutMeText
	text_end

OaksLabOakBePatientText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabOakBePatientText
	text_end

OaksLabOakDontGoAwayYetText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabOakDontGoAwayYetText
	text_end

OaksLabRivalIllTakeThisOneText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalIllTakeThisOneText
	text_end

OaksLabRivalReceivedMonText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalReceivedMonText
	sound_get_key_item
	text_end

OaksLabRivalIllTakeYouOnText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalIllTakeYouOnText
	text_end

OaksLabRivalIPickedTheWrongPokemonText:
	text_far _OaksLabRivalIPickedTheWrongPokemonText
	text_end

OaksLabRivalAmIGreatOrWhatText:
	text_far _OaksLabRivalAmIGreatOrWhatText
	text_end

OaksLabRivalSmellYouLaterText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabRivalSmellYouLaterText
	text_end

OaksLabRivalGrampsText:
	text_far _OaksLabRivalGrampsText
	text_end

OaksLabRivalWhatDidYouCallMeForText:
	text_far _OaksLabRivalWhatDidYouCallMeForText
	text_end

OaksLabOakIHaveARequestText:
	text_far _OaksLabOakIHaveARequestText
	text_end

OaksLabOakMyInventionPokedexText:
	text_far _OaksLabOakMyInventionPokedexText
	text_end

OaksLabOakGotPokedexText:
	text_far _OaksLabOakGotPokedexText
	sound_get_key_item
	text_end

OaksLabOakThatWasMyDreamText:
	text_far _OaksLabOakThatWasMyDreamText
	text_end

OaksLabRivalLeaveItAllToMeText:
	text_far _OaksLabRivalLeaveItAllToMeText
	text_end

OaksLabScientistText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabScientistText
	text_end

OaksLabScientist2Text:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _OaksLabScientist2Text
	text_end


; ============================================================
; Picker constant — defined here before its first use below.
def NUM_VALID_STARTERS equ 78

; ============================================================
; OaksLabChooseAnyStarterMenu
; Scrollable picker for all 79 base-form Pokemon.
; Returns: wCurPartySpecies = chosen internal species ID
;          wPokedexNum      = absolute StarterSpeciesTable index (0-78)
; ============================================================
OaksLabChooseAnyStarterMenu:
	; Single-spaced cursor (1 row per step); default is 2 rows which skips entries
	ldh a, [hUILayoutFlags]
	set BIT_DOUBLE_SPACED_MENU, a
	ldh [hUILayoutFlags], a

	; Hide OAM sprites (Oak, rival, player) so they don't show over the white picker
	ldh a, [rLCDC]
	res 1, a
	ldh [rLCDC], a

	xor a
	ld [wListScrollOffset], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a

.redraw:
	xor a
	ldh [hAutoBGTransferEnabled], a

	; Suppress PrintLetterDelay so names draw instantly (text engine sets BIT_TEXT_DELAY)
	ld a, [wLetterPrintingDelayFlags]
	res BIT_TEXT_DELAY, a
	ld [wLetterPrintingDelayFlags], a

	; Clear all 18 tile rows (including text box at bottom)
	hlcoord 0, 0
	lb bc, 18, 20
	call ClearScreenArea

	; Header "WHICH MON?"
	hlcoord 1, 0
	ld de, .HeaderText
	call PlaceString

	; Draw up to 7 names starting at wListScrollOffset
	ld a, [wListScrollOffset]
	ld b, 0                      ; B = rows drawn
	hlcoord 2, 2                 ; HL = tile address of first list row

.nameLoop:
	cp NUM_VALID_STARTERS
	jp nc, .nameDone
	ld d, a                      ; D = current table index
	ld a, b
	cp 7
	jp z, .nameDone
	ld a, d                      ; restore table index

	push hl                      ; [1] tile address
	push bc                      ; [2] B=rows_drawn (GetMonName clobbers BC)

	ld hl, StarterSpeciesTable
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetMonName              ; -> wNameBuffer (clobbers BC)

	pop bc                       ; [2] restore B=rows_drawn
	pop hl                       ; [1] restore tile address

	push bc                      ; [3] PlaceString returns BC=last tile addr (clobbers B)
	ld de, wNameBuffer
	call PlaceString             ; clobbers BC, preserves HL
	pop bc                       ; [3] restore B=rows_drawn

	ld de, SCREEN_WIDTH
	add hl, de                   ; advance to next tile row

	ld a, [wListScrollOffset]
	add b
	inc a                        ; table index for next iteration
	inc b                        ; rows drawn++
	jp .nameLoop

.nameDone:
	; wMaxMenuItem = rows_drawn - 1
	ld a, b
	and a
	jr nz, .setMax
	ld a, 1
.setMax:
	dec a
	ld [wMaxMenuItem], a

	; Clamp cursor to wMaxMenuItem
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMaxMenuItem]
	cp b
	jr nc, .cursorOK
	ld [wCurrentMenuItem], a
.cursorOK:

	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a

	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	call PlaceMenuCursor

.waitInput:
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and a
	jr z, .waitInput

	; A button: confirm
	bit B_PAD_A, a
	jr z, .checkB
	ld a, [wListScrollOffset]
	ld b, a
	ld a, [wCurrentMenuItem]
	add b
	ld [wPokedexNum], a
	ld [wOakRemarkStarterIndex], a ; wPokedexNum gets clobbered before OaksLabMonChoiceMenu reads it back
	ld hl, StarterSpeciesTable
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wCurPartySpecies], a
	; Restore default cursor spacing before returning (YES/NO menu needs 2-row spacing)
	ldh a, [hUILayoutFlags]
	res BIT_DOUBLE_SPACED_MENU, a
	ldh [hUILayoutFlags], a
	; Restore sprite layer
	ldh a, [rLCDC]
	set 1, a
	ldh [rLCDC], a
	xor a
	ld [wLastMenuItem], a
	ret

.checkB:
	bit B_PAD_B, a
	jr nz, .pageBack
	bit B_PAD_LEFT, a
	jr z, .checkRight
.pageBack:
	ld a, [wListScrollOffset]
	sub 7
	jr nc, .setBackScroll
	xor a
.setBackScroll:
	ld [wListScrollOffset], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	jp .redraw

.checkRight:
	bit B_PAD_RIGHT, a
	jr z, .checkUp
	ld a, [wListScrollOffset]
	add 7
	cp NUM_VALID_STARTERS
	jr c, .setForwardScroll
	ld a, NUM_VALID_STARTERS - 7
.setForwardScroll:
	ld [wListScrollOffset], a
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	jp .redraw

.checkUp:
	bit B_PAD_UP, a
	jr z, .checkDown
	ld a, [wCurrentMenuItem]
	and a
	jr z, .upFromTop
	dec a
	ld [wCurrentMenuItem], a
	call PlaceMenuCursor
	call Delay3
	jp .waitInput
.upFromTop:
	ld a, [wListScrollOffset]
	and a
	jp z, .waitInput
	dec a
	ld [wListScrollOffset], a
	ld a, 6
	ld [wCurrentMenuItem], a
	xor a
	ld [wLastMenuItem], a
	jp .redraw

.checkDown:
	bit B_PAD_DOWN, a
	jp z, .waitInput
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMaxMenuItem]
	cp b
	jr z, .downFromBottom
	ld a, b
	inc a
	ld [wCurrentMenuItem], a
	call PlaceMenuCursor
	call Delay3
	jp .waitInput
.downFromBottom:
	ld a, [wListScrollOffset]
	add b
	inc a
	cp NUM_VALID_STARTERS
	jp nc, .waitInput
	ld a, [wListScrollOffset]
	inc a
	ld [wListScrollOffset], a
	jp .redraw

.HeaderText:
	db "WHICH MON?@"

; ============================================================
; OaksLabSetRivalCounter
; Input:  wPokedexNum = absolute StarterSpeciesTable index (0-78)
; Output: wRivalStarterTemp = rival's internal species ID
; ============================================================
OaksLabSetRivalCounter:
	ld a, [wPokedexNum]
	ld hl, RivalCounterTable
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wRivalStarterTemp], a
	ret

; ============================================================
; ============================================================
; GENERATED BY scripts/gen_tables.py — do not edit manually
; Re-run to regenerate after changing pools or base-form list
; ============================================================

; NUM_VALID_STARTERS = 78 (defined via 'def' in the code section above)

StarterSpeciesTable:
	db BULBASAUR        ; #001 BULBASAUR
	db CHARMANDER       ; #004 CHARMANDER
	db SQUIRTLE         ; #007 SQUIRTLE
	db CATERPIE         ; #010 CATERPIE
	db WEEDLE           ; #013 WEEDLE
	db PIDGEY           ; #016 PIDGEY
	db RATTATA          ; #019 RATTATA
	db SPEAROW          ; #021 SPEAROW
	db EKANS            ; #023 EKANS
	db PIKACHU          ; #025 PIKACHU
	db SANDSHREW        ; #027 SANDSHREW
	db NIDORAN_F        ; #029 NIDORANF
	db NIDORAN_M        ; #032 NIDORANM
	db CLEFAIRY         ; #035 CLEFAIRY
	db VULPIX           ; #037 VULPIX
	db JIGGLYPUFF       ; #039 JIGGLYPUFF
	db ZUBAT            ; #041 ZUBAT
	db ODDISH           ; #043 ODDISH
	db PARAS            ; #046 PARAS
	db VENONAT          ; #048 VENONAT
	db DIGLETT          ; #050 DIGLETT
	db MEOWTH           ; #052 MEOWTH
	db PSYDUCK          ; #054 PSYDUCK
	db MANKEY           ; #056 MANKEY
	db GROWLITHE        ; #058 GROWLITHE
	db POLIWAG          ; #060 POLIWAG
	db ABRA             ; #063 ABRA
	db MACHOP           ; #066 MACHOP
	db BELLSPROUT       ; #069 BELLSPROUT
	db TENTACOOL        ; #072 TENTACOOL
	db GEODUDE          ; #074 GEODUDE
	db PONYTA           ; #077 PONYTA
	db SLOWPOKE         ; #079 SLOWPOKE
	db MAGNEMITE        ; #081 MAGNEMITE
	db FARFETCHD        ; #083 FARFETCHD
	db DODUO            ; #084 DODUO
	db SEEL             ; #086 SEEL
	db GRIMER           ; #088 GRIMER
	db SHELLDER         ; #090 SHELLDER
	db ONIX             ; #095 ONIX
	db DROWZEE          ; #096 DROWZEE
	db KRABBY           ; #098 KRABBY
	db VOLTORB          ; #100 VOLTORB
	db EXEGGCUTE        ; #102 EXEGGCUTE
	db CUBONE           ; #104 CUBONE
	db HITMONLEE        ; #106 HITMONLEE
	db HITMONCHAN       ; #107 HITMONCHAN
	db LICKITUNG        ; #108 LICKITUNG
	db KOFFING          ; #109 KOFFING
	db RHYHORN          ; #111 RHYHORN
	db CHANSEY          ; #113 CHANSEY
	db TANGELA          ; #114 TANGELA
	db KANGASKHAN       ; #115 KANGASKHAN
	db HORSEA           ; #116 HORSEA
	db GOLDEEN          ; #118 GOLDEEN
	db STARYU           ; #120 STARYU
	db MR_MIME          ; #122 MRMIME
	db SCYTHER          ; #123 SCYTHER
	db JYNX             ; #124 JYNX
	db ELECTABUZZ       ; #125 ELECTABUZZ
	db MAGMAR           ; #126 MAGMAR
	db PINSIR           ; #127 PINSIR
	db TAUROS           ; #128 TAUROS
	db MAGIKARP         ; #129 MAGIKARP
	db LAPRAS           ; #131 LAPRAS
	db DITTO            ; #132 DITTO
	db EEVEE            ; #133 EEVEE
	db PORYGON          ; #137 PORYGON
	db OMANYTE          ; #138 OMANYTE
	db KABUTO           ; #140 KABUTO
	db AERODACTYL       ; #142 AERODACTYL
	db SNORLAX          ; #143 SNORLAX
	db ARTICUNO         ; #144 ARTICUNO
	db ZAPDOS           ; #145 ZAPDOS
	db MOLTRES          ; #146 MOLTRES
	db DRATINI          ; #147 DRATINI
	db MEWTWO           ; #150 MEWTWO
	db MEW              ; #151 MEW

RivalCounterTable:
	db CHARMANDER       ; #001 BULBASAUR (GRASS)
	db SQUIRTLE         ; #004 CHARMANDER (FIRE)
	db PIKACHU          ; #007 SQUIRTLE (WATER)
	db GROWLITHE        ; #010 CATERPIE (BUG)
	db CHARMANDER       ; #013 WEEDLE (BUG)
	db MANKEY           ; #016 PIDGEY (NORMAL)
	db MACHOP           ; #019 RATTATA (NORMAL)
	db HITMONLEE        ; #021 SPEAROW (NORMAL)
	db SANDSHREW        ; #023 EKANS (POISON)
	db SANDSHREW        ; #025 PIKACHU (ELECTRIC)
	db BULBASAUR        ; #027 SANDSHREW (GROUND)
	db ABRA             ; #029 NIDORANF (POISON)
	db DROWZEE          ; #032 NIDORANM (POISON)
	db HITMONCHAN       ; #035 CLEFAIRY (NORMAL)
	db PSYDUCK          ; #037 VULPIX (FIRE)
	db PRIMEAPE         ; #039 JIGGLYPUFF (NORMAL)
	db PSYDUCK          ; #041 ZUBAT (POISON)
	db GROWLITHE        ; #043 ODDISH (GRASS)
	db PONYTA           ; #046 PARAS (BUG)
	db GROWLITHE        ; #048 VENONAT (BUG)
	db ODDISH           ; #050 DIGLETT (GROUND)
	db MANKEY           ; #052 MEOWTH (NORMAL)
	db VOLTORB          ; #054 PSYDUCK (WATER)
	db DROWZEE          ; #056 MANKEY (FIGHTING)
	db POLIWAG          ; #058 GROWLITHE (FIRE)
	db MAGNEMITE        ; #060 POLIWAG (WATER)
	db CATERPIE         ; #063 ABRA (PSYCHIC_TYPE)
	db ABRA             ; #066 MACHOP (FIGHTING)
	db PONYTA           ; #069 BELLSPROUT (GRASS)
	db ELECTABUZZ       ; #072 TENTACOOL (WATER)
	db SQUIRTLE         ; #074 GEODUDE (ROCK)
	db STARYU           ; #077 PONYTA (FIRE)
	db JOLTEON          ; #079 SLOWPOKE (WATER)
	db DIGLETT          ; #081 MAGNEMITE (ELECTRIC)
	db MACHOP           ; #083 FARFETCHD (NORMAL)
	db HITMONLEE        ; #084 DODUO (NORMAL)
	db PIKACHU          ; #086 SEEL (WATER)
	db SANDSHREW        ; #088 GRIMER (POISON)
	db VOLTORB          ; #090 SHELLDER (WATER)
	db POLIWAG          ; #095 ONIX (ROCK)
	db WEEDLE           ; #096 DROWZEE (PSYCHIC_TYPE)
	db MAGNEMITE        ; #098 KRABBY (WATER)
	db GEODUDE          ; #100 VOLTORB (ELECTRIC)
	db MAGMAR           ; #102 EXEGGCUTE (GRASS)
	db BELLSPROUT       ; #104 CUBONE (GROUND)
	db JYNX             ; #106 HITMONLEE (FIGHTING)
	db DROWZEE          ; #107 HITMONCHAN (FIGHTING)
	db HITMONCHAN       ; #108 LICKITUNG (NORMAL)
	db ABRA             ; #109 KOFFING (POISON)
	db EXEGGCUTE        ; #111 RHYHORN (GROUND)
	db PRIMEAPE         ; #113 CHANSEY (NORMAL)
	db CHARMANDER       ; #114 TANGELA (GRASS)
	db MANKEY           ; #115 KANGASKHAN (NORMAL)
	db ELECTABUZZ       ; #116 HORSEA (WATER)
	db JOLTEON          ; #118 GOLDEEN (WATER)
	db PIKACHU          ; #120 STARYU (WATER)
	db VENONAT          ; #122 MRMIME (PSYCHIC_TYPE)
	db CHARMANDER       ; #123 SCYTHER (BUG)
	db GROWLITHE        ; #124 JYNX (ICE)
	db CUBONE           ; #125 ELECTABUZZ (ELECTRIC)
	db SEEL             ; #126 MAGMAR (FIRE)
	db PONYTA           ; #127 PINSIR (BUG)
	db MACHOP           ; #128 TAUROS (NORMAL)
	db VOLTORB          ; #129 MAGIKARP (WATER)
	db MAGNEMITE        ; #131 LAPRAS (WATER)
	db HITMONLEE        ; #132 DITTO (NORMAL)
	db HITMONCHAN       ; #133 EEVEE (NORMAL)
	db PRIMEAPE         ; #137 PORYGON (NORMAL)
	db HORSEA           ; #138 OMANYTE (ROCK)
	db MACHOP           ; #140 KABUTO (ROCK)
	db SQUIRTLE         ; #142 AERODACTYL (ROCK)
	db MANKEY           ; #143 SNORLAX (NORMAL)
	db PONYTA           ; #144 ARTICUNO (ICE)
	db SANDSHREW        ; #145 ZAPDOS (ELECTRIC)
	db HORSEA           ; #146 MOLTRES (FIRE)
	db DRATINI          ; #147 DRATINI (DRAGON)
	db SCYTHER          ; #150 MEWTWO (PSYCHIC_TYPE)
	db PINSIR           ; #151 MEW (PSYCHIC_TYPE)

RivalSpeciesTeamTable:
	db SQUIRTLE, 1
	db BULBASAUR, 2
	db CHARMANDER, 3
	db PIKACHU, 10
	db GROWLITHE, 11
	db MANKEY, 12
	db MACHOP, 13
	db HITMONLEE, 14
	db SANDSHREW, 15
	db ABRA, 16
	db DROWZEE, 17
	db HITMONCHAN, 18
	db PSYDUCK, 19
	db PRIMEAPE, 20
	db PONYTA, 21
	db ODDISH, 22
	db VOLTORB, 23
	db POLIWAG, 24
	db MAGNEMITE, 25
	db CATERPIE, 26
	db ELECTABUZZ, 27
	db STARYU, 28
	db JOLTEON, 29
	db DIGLETT, 30
	db WEEDLE, 31
	db GEODUDE, 32
	db MAGMAR, 33
	db BELLSPROUT, 34
	db JYNX, 35
	db EXEGGCUTE, 36
	db VENONAT, 37
	db CUBONE, 38
	db SEEL, 39
	db HORSEA, 40
	db DRATINI, 41
	db SCYTHER, 42
	db PINSIR, 43
	db 0  ; terminator

; End of generated tables
