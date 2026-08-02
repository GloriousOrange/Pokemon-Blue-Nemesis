SilphCo7F_Script:
	call SilphCo7F_GateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo7TrainerHeaders
	ld de, SilphCo7F_ScriptPointers
	ld a, [wSilphCo7FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo7FCurScript], a
	ret

SilphCo7F_GateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	call SilphCo7FSetFactionObjectsScript
	ld hl, .GateCoordinates
	call SilphCo7F_SetCardKeyDoorYScript
	call SilphCo7F_UnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	jr nz, .unlock_door1
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 3, 5
	predef ReplaceTileBlock
	pop af
.unlock_door1
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_7_UNLOCKED_DOOR2, EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	jr nz, .unlock_door2
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 2, 10
	predef ReplaceTileBlock
	pop af
.unlock_door2
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_7_UNLOCKED_DOOR3, EVENT_SILPH_CO_7_UNLOCKED_DOOR2
	ret nz
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 6, 10
	predef_jump ReplaceTileBlock

.GateCoordinates:
	dbmapcoord  5,  3
	dbmapcoord 10,  2
	dbmapcoord 10,  6
	db -1 ; end

SilphCo7F_SetCardKeyDoorYScript:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ldh [hUnlockedSilphCoDoors], a
	pop hl
.loop_check_doors
	ld a, [hli]
	cp $ff
	jr z, .exit_loop
	push hl
	ld hl, hUnlockedSilphCoDoors
	inc [hl]
	pop hl
	cp b
	jr z, .check_y_coord
	inc hl
	jr .loop_check_doors
.check_y_coord
	ld a, [hli]
	cp c
	jr nz, .loop_check_doors
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.exit_loop
	xor a
	ldh [hUnlockedSilphCoDoors], a
	ret

SilphCo7F_UnlockedDoorEventScript:
	EventFlagAddress hl, EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	ldh a, [hUnlockedSilphCoDoors]
	and a
	ret z
	cp $1
	jr nz, .unlock_door1
	SetEventReuseHL EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	ret
.unlock_door1
	cp $2
	jr nz, .unlock_door2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_7_UNLOCKED_DOOR2, EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	ret
.unlock_door2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_7_UNLOCKED_DOOR3, EVENT_SILPH_CO_7_UNLOCKED_DOOR1
	ret

SilphCo7FSetDefaultScript:
	xor a
	ld [wJoyIgnore], a

SilphCo7FSetCurScript:
	ld [wSilphCo7FCurScript], a
	ld [wCurMapScript], a
	ret

SilphCo7F_ScriptPointers:
	def_script_pointers
	dw_const SilphCo7FDefaultScript,                SCRIPT_SILPHCO7F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO7F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO7F_END_BATTLE
	dw_const SilphCo7FRivalStartBattleScript,       SCRIPT_SILPHCO7F_RIVAL_START_BATTLE
	dw_const SilphCo7FRivalAfterBattleScript,       SCRIPT_SILPHCO7F_RIVAL_AFTER_BATTLE
	dw_const SilphCo7FRivalExitScript,              SCRIPT_SILPHCO7F_RIVAL_EXIT

SilphCo7FDefaultScript:
	CheckEvent EVENT_BEAT_SILPH_CO_RIVAL
	jp nz, CheckFightingMapTrainers
	ld hl, .RivalEncounterCoordinates
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ldh [hJoyHeld], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
; The rival used to walk up to the player here (SetSpriteMovementBytesToFF +
; MoveSprite with .RivalMovementUp/an offset thereof, gated by
; SilphCo7FRivalStartBattleScript waiting on BIT_SCRIPTED_NPC_MOVEMENT), with
; TEXT_SILPHCO7F_RIVAL displayed synchronously in THIS script, in the same
; tick as the ArePlayerCoordsInArray trigger. Removing only the movement
; (keeping the immediate DisplayTextID call) just moved the freeze earlier --
; it now happens the instant the trigger tile is stepped on. Every proven
; rival encounter elsewhere (Route22, SS Anne 2F) never calls DisplayTextID
; in the same tick the coordinate trigger fires; they always let several
; frames elapse first via movement or a delay. Matching that: this script
; now only arms the encounter (sound/music) and hands off to a later script
; tick before any text box opens. wSavedCoordIndex is still needed by
; SilphCo7FRivalAfterBattleScript's exit-direction choice.
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a
	ld a, SCRIPT_SILPHCO7F_RIVAL_START_BATTLE
	jp SilphCo7FSetCurScript

.RivalEncounterCoordinates:
	dbmapcoord  3,  2
	dbmapcoord  3,  3
	db -1 ; end

SilphCo7FRivalStartBattleScript:
	xor a
	ld [wJoyIgnore], a
	call Delay3
	ld a, TEXT_SILPHCO7F_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	ld a, TEXT_SILPHCO7F_RIVAL_WAITED_HERE
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo7FRivalDefeatedText
	ld de, SilphCo7FRivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL2
	ld [wCurOpponent], a
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .not_starter_2
	ld a, $7
	jr .set_trainer_no
.not_starter_2
	cp STARTER3
	jr nz, .no_starter_3
	ld a, $8
	jr .set_trainer_no
.no_starter_3
	ld a, $9
.set_trainer_no
	ld [wTrainerNo], a
	ld a, SCRIPT_SILPHCO7F_RIVAL_AFTER_BATTLE
	jp SilphCo7FSetCurScript

SilphCo7FRivalAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SilphCo7FSetDefaultScript
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_SILPH_CO_RIVAL
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SILPHCO7F_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_UP
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_SILPHCO7F_RIVAL_GOOD_LUCK_TO_YOU
	ldh [hTextID], a
	call DisplayTextID
; The starter-death scene used to print here (SilphCo7FRivalStarterDeathText)
; the first time EVENT_RIVAL_STARTER_DIED wasn't set. Removed: this is the
; least-tested, most complex piece of this whole scene (five paragraphs,
; genuinely new content per project notes -- "in-game playtest ... still
; pending" -- vs. everything else here matching proven encounters like
; Route 22's rival fight byte-for-byte) and the user hit a reproducible
; freeze immediately after this text closes, with no other lead found after
; extensive static review. Still marks the event so it doesn't retrigger
; oddly elsewhere if something else checks it.
	CheckEvent EVENT_RIVAL_STARTER_DIED
	jr nz, .skip_death_scene
	SetEvent EVENT_RIVAL_STARTER_DIED
.skip_death_scene:
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	farcall Music_RivalAlternateStart
	ld de, .RivalWalkAroundPlayerMovement
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, lower entry in SilphCo7FDefaultScript.RivalEncounterCoordinates
	jr nz, .walk_around_player
	ld de, .RivalExitRightMovement
.walk_around_player
	ld a, SILPHCO7F_RIVAL
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, SCRIPT_SILPHCO7F_RIVAL_EXIT
	jp SilphCo7FSetCurScript

.RivalExitRightMovement:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db -1 ; end

.RivalWalkAroundPlayerMovement:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db -1 ; end

; Used to wait here for the walk-away movement (kicked off above) to finish
; before hiding the rival -- removed for the same reason as the pre-battle
; approach: an unresolved stuck-movement freeze risk isn't worth the
; cosmetic payoff. The walk still plays; we just don't gate on it finishing.
SilphCo7FRivalExitScript:
	ld a, TOGGLE_SILPH_CO_7F_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic
	xor a
	ld [wJoyIgnore], a
	jp SilphCo7FSetCurScript

SilphCo7F_TextPointers:
	def_text_pointers
	dw_const SilphCo7FSilphWorkerM1Text,      TEXT_SILPHCO7F_SILPH_WORKER_M1
	dw_const SilphCo7FSilphWorkerM2Text,      TEXT_SILPHCO7F_SILPH_WORKER_M2
	dw_const SilphCo7FSilphWorkerM3Text,      TEXT_SILPHCO7F_SILPH_WORKER_M3
	dw_const SilphCo7FSilphWorkerM4Text,      TEXT_SILPHCO7F_SILPH_WORKER_M4
	dw_const SilphCo7FRocket1Text,            TEXT_SILPHCO7F_ROCKET1
	dw_const SilphCo7FScientistText,          TEXT_SILPHCO7F_SCIENTIST
	dw_const SilphCo7FRocket2Text,            TEXT_SILPHCO7F_ROCKET2
	dw_const SilphCo7FRocket3Text,            TEXT_SILPHCO7F_ROCKET3
	dw_const SilphCo7FRivalText,              TEXT_SILPHCO7F_RIVAL
	dw_const PickUpItemText,                  TEXT_SILPHCO7F_CALCIUM
	dw_const PickUpItemText,                  TEXT_SILPHCO7F_TM_SWORDS_DANCE
	dw_const SilphCo7FFlavorRocketText,       TEXT_SILPHCO7F_FLAVOR_ROCKET
	dw_const SilphCo7FFlavorScientistText,    TEXT_SILPHCO7F_FLAVOR_SCIENTIST
	dw_const PickUpItemText,                  TEXT_SILPHCO7F_UNREFERENCED_ITEM ; unreferenced
	dw_const SilphCo7FRivalWaitedHereText,    TEXT_SILPHCO7F_RIVAL_WAITED_HERE
	dw_const SilphCo7FRivalDefeatedText,      TEXT_SILPHCO7F_RIVAL_DEFEATED
	dw_const SilphCo7FRivalGoodLuckToYouText, TEXT_SILPHCO7F_RIVAL_GOOD_LUCK_TO_YOU
	dw_const SilphCo7FDefender1Text, TEXT_SILPHCO7F_DEFENDER1
	dw_const SilphCo7FDefender2Text, TEXT_SILPHCO7F_DEFENDER2
	dw_const SilphCo7FDefender3Text, TEXT_SILPHCO7F_DEFENDER3

SilphCo7TrainerHeaders:
	def_trainers 5
SilphCo7TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_0, 2, SilphCo7FRocket1BattleText, SilphCo7FRocket1EndBattleText, SilphCo7FRocket1AfterBattleText
SilphCo7TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_1, 3, SilphCo7FScientistBattleText, SilphCo7FScientistEndBattleText, SilphCo7FScientistAfterBattleText
SilphCo7TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_2, 3, SilphCo7FRocket2BattleText, SilphCo7FRocket2EndBattleText, SilphCo7FRocket2AfterBattleText
SilphCo7TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_3, 4, SilphCo7FRocket3BattleText, SilphCo7FRocket3EndBattleText, SilphCo7FRocket3AfterBattleText
SilphCo7TrainerHeader5:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_4, 2, SilphCo7FDefender1BattleText, SilphCo7FDefender1EndBattleText, SilphCo7FDefender1AfterBattleText
SilphCo7TrainerHeader6:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_5, 3, SilphCo7FDefender2BattleText, SilphCo7FDefender2EndBattleText, SilphCo7FDefender2AfterBattleText
SilphCo7TrainerHeader7:
	trainer EVENT_BEAT_SILPH_CO_7F_TRAINER_6, 4, SilphCo7FDefender3BattleText, SilphCo7FDefender3EndBattleText, SilphCo7FDefender3AfterBattleText
	db -1 ; end

SilphCo7FSilphWorkerM1Text:
; lapras guy
	text_asm
	ld a, [wStatusFlags4]
	bit BIT_GOT_LAPRAS, a
	jr z, .give_lapras
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .saved_silph
	ld hl, .IsOurPresidentOkText
	call PrintText
	jr .done
.give_lapras
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .LoyalistHaveThisPokemonText
	jr nz, .print_give_lapras
	ld hl, .HaveThisPokemonText
.print_give_lapras
	call PrintText
	lb bc, LAPRAS, 15
	call GivePokemon
	jr nc, .done
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .LoyalistLaprasDescriptionText
	jr nz, .print_lapras_description
	ld hl, .LaprasDescriptionText
.print_lapras_description
	call PrintText
	ld hl, wStatusFlags4
	set BIT_GOT_LAPRAS, [hl]
	jr .done
.saved_silph
	ld hl, .SavedText
	call PrintText
.done
	jp TextScriptEnd

.HaveThisPokemonText
	text_far _SilphCo7FSilphWorkerM1HaveThisPokemonText
	text_end

.LoyalistHaveThisPokemonText
	text_far _SilphCo7FSilphWorkerM1LoyalistHaveThisPokemonText
	text_end

.LaprasDescriptionText
	text_far _SilphCo7FSilphWorkerM1LaprasDescriptionText
	text_end

.LoyalistLaprasDescriptionText
	text_far _SilphCo7FSilphWorkerM1LoyalistLaprasDescriptionText
	text_end

.IsOurPresidentOkText
	text_far _SilphCo7FSilphWorkerM1IsOurPresidentOkText
	text_end

.SavedText
	text_far _SilphCo7FSilphWorkerM1SavedText
	text_end

SilphCo7FSilphWorkerM2Text:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .saved_silph
	ld hl, .AfterTheMasterBallText
	call PrintText
	jr .done
.saved_silph
	ld hl, .CancelledTheMasterBallText
	call PrintText
.done
	jp TextScriptEnd

.AfterTheMasterBallText
	text_far _SilphCo7FSilphWorkerM2AfterTheMasterBallText
	text_end

.CancelledTheMasterBallText
	text_far _SilphCo7FSilphWorkerM2CancelledMasterBallText
	text_end

SilphCo7FSilphWorkerM3Text:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .saved_silph
	ld hl, .ItWouldBeBadText
	call PrintText
	jr .done
.saved_silph
	ld hl, .YouChasedOffTeamRocketText
	call PrintText
.done
	jp TextScriptEnd

.ItWouldBeBadText
	text_far _SilphCo7FSilphWorkerM3ItWouldBeBadText
	text_end

.YouChasedOffTeamRocketText
	text_far _SilphCo7FSilphWorkerM3YouChasedOffTeamRocketText
	text_end

SilphCo7FSilphWorkerM4Text:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .saved_silph
	ld hl, .ItsReallyDangerousHereText
	call PrintText
	jr .done
.saved_silph
	ld hl, .SafeAtLastText
	call PrintText
.done
	jp TextScriptEnd

.ItsReallyDangerousHereText
	text_far _SilphCo7FSilphWorkerM4ItsReallyDangerousHereText
	text_end

.SafeAtLastText
	text_far _SilphCo7FSilphWorkerM4SafeAtLastText
	text_end

SilphCo7FRocket1Text:
	text_asm
	ld hl, SilphCo7TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo7FRocket1BattleText:
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .LoyalistText
	jr nz, .print
	ld hl, .HostileText
.print
	call PrintText
	jp TextScriptEnd
.HostileText:
	text_far _SilphCo7FRocket1BattleText
	text_end
.LoyalistText:
	text_far _SilphCo7FRocket1LoyalistBattleText
	text_end

SilphCo7FRocket1EndBattleText:
	text_far _SilphCo7FRocket1EndBattleText
	text_end

SilphCo7FRocket1AfterBattleText:
	text_far _SilphCo7FRocket1AfterBattleText
	text_end

SilphCo7FScientistText:
	text_asm
	ld hl, SilphCo7TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo7FScientistBattleText:
	text_far _SilphCo7FScientistBattleText
	text_end

SilphCo7FScientistEndBattleText:
	text_far _SilphCo7FScientistEndBattleText
	text_end

SilphCo7FScientistAfterBattleText:
	text_far _SilphCo7FScientistAfterBattleText
	text_end

SilphCo7FRocket2Text:
	text_asm
	ld hl, SilphCo7TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo7FRocket2BattleText:
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .LoyalistText
	jr nz, .print
	ld hl, .HostileText
.print
	call PrintText
	jp TextScriptEnd
.HostileText:
	text_far _SilphCo7FRocket2BattleText
	text_end
.LoyalistText:
	text_far _SilphCo7FRocket2LoyalistBattleText
	text_end

SilphCo7FRocket2EndBattleText:
	text_far _SilphCo7FRocket2EndBattleText
	text_end

SilphCo7FRocket2AfterBattleText:
	text_far _SilphCo7FRocket2AfterBattleText
	text_end

SilphCo7FRocket3Text:
	text_asm
	ld hl, SilphCo7TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SilphCo7FRocket3BattleText:
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .LoyalistText
	jr nz, .print
	ld hl, .HostileText
.print
	call PrintText
	jp TextScriptEnd
.HostileText:
	text_far _SilphCo7FRocket3BattleText
	text_end
.LoyalistText:
	text_far _SilphCo7FRocket3LoyalistBattleText
	text_end

SilphCo7FRocket3EndBattleText:
	text_far _SilphCo7FRocket3EndBattleText
	text_end

SilphCo7FRocket3AfterBattleText:
	text_far _SilphCo7FRocket3AfterBattleText
	text_end

SilphCo7FRivalText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo7FRivalText
	text_end

SilphCo7FRivalWaitedHereText:
; the rival reacts to your allegiance before the battle
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .Loyalist
	jr nz, .print
	ld hl, .Hero
.print
	call PrintText
	jp TextScriptEnd
.Loyalist:
	text_far _SilphCo7FRivalLoyalistPreText
	text_end
.Hero:
	text_far _SilphCo7FRivalHeroPreText
	text_end

SilphCo7FRivalDefeatedText:
	text_far _SilphCo7FRivalDefeatedText
	text_end

SilphCo7FRivalVictoryText:
	text_far _SilphCo7FRivalVictoryText
	text_end

SilphCo7FRivalGoodLuckToYouText:
; the rival's parting words after you beat him, keyed to your allegiance
	text_asm
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, .Loyalist
	jr nz, .print
	ld hl, .Hero
.print
	call PrintText
	jp TextScriptEnd
.Loyalist:
	text_far _SilphCo7FRivalLoyalistWinText
	text_end
.Hero:
	text_far _SilphCo7FRivalHeroWinText
	text_end

SilphCo7FRivalStarterDeathText:
	text_far _SilphCo7FRivalStarterDeathText
	text_end

SilphCo7FFlavorRocketText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo7FFlavorRocketText
	text_end

SilphCo7FFlavorScientistText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _SilphCo7FFlavorScientistText
	text_end

; TEAM ROCKET holds this floor. On the hero path they fight you and the SILPH
; staff stay hidden; on the loyalist path they are comrades, so the staff
; defend the building instead. Each pair shares a tile, so exactly one of the
; two is ever shown. Skipped once the boss has fallen -- by then
; SilphCo11FTeamRocketLeavesScript has cleared this floor for good, and
; re-showing anyone here on the next map load would undo that.
SilphCo7FSetFactionObjectsScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	ld hl, .Defenders
	call SilphCo7FHideObjectList
	ld hl, .Rockets
	jp SilphCo7FShowObjectList
.loyalist
	ld hl, .Rockets
	call SilphCo7FHideObjectList
	ld hl, .Defenders
	jp SilphCo7FShowObjectList

.Rockets:
	db TOGGLE_SILPH_CO_7F_1
	db TOGGLE_SILPH_CO_7F_3
	db TOGGLE_SILPH_CO_7F_4
	db -1 ; end

.Defenders:
	db TOGGLE_SILPH_CO_7F_DEFENDER1
	db TOGGLE_SILPH_CO_7F_DEFENDER2
	db TOGGLE_SILPH_CO_7F_DEFENDER3
	db -1 ; end

SilphCo7FShowObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef ShowObject
	pop hl
	jr SilphCo7FShowObjectList

SilphCo7FHideObjectList:
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef HideObject
	pop hl
	jr SilphCo7FHideObjectList

SilphCo7FDefender1Text:
	text_asm
	ld hl, SilphCo7TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SilphCo7FDefender1BattleText:
	text_far _SilphCo7FDefender1BattleText
	text_end

SilphCo7FDefender1EndBattleText:
	text_far _SilphCo7FDefender1EndBattleText
	text_end

SilphCo7FDefender1AfterBattleText:
	text_far _SilphCo7FDefender1AfterBattleText
	text_end

SilphCo7FDefender2Text:
	text_asm
	ld hl, SilphCo7TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

SilphCo7FDefender2BattleText:
	text_far _SilphCo7FDefender2BattleText
	text_end

SilphCo7FDefender2EndBattleText:
	text_far _SilphCo7FDefender2EndBattleText
	text_end

SilphCo7FDefender2AfterBattleText:
	text_far _SilphCo7FDefender2AfterBattleText
	text_end

SilphCo7FDefender3Text:
	text_asm
	ld hl, SilphCo7TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

SilphCo7FDefender3BattleText:
	text_far _SilphCo7FDefender3BattleText
	text_end

SilphCo7FDefender3EndBattleText:
	text_far _SilphCo7FDefender3EndBattleText
	text_end

SilphCo7FDefender3AfterBattleText:
	text_far _SilphCo7FDefender3AfterBattleText
	text_end
