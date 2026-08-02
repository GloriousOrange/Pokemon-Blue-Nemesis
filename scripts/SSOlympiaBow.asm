SSOlympiaBow_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympiaBowTrainerHeaders
	ld de, SSOlympiaBow_ScriptPointers
	ld a, [wSSOlympiaBowCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympiaBowCurScript], a
	ret

SSOlympiaBow_ScriptPointers:
	def_script_pointers
	dw_const SSOlympiaBowDefaultScript,          SCRIPT_SSOLYMPIABOW_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIABOW_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIABOW_END_BATTLE
	dw_const SSOlympiaBowRivalApproachWaitScript,   SCRIPT_SSOLYMPIABOW_RIVAL_APPROACH
	dw_const SSOlympiaBowRivalStartBattleScript,    SCRIPT_SSOLYMPIABOW_RIVAL_START_BATTLE
	dw_const SSOlympiaBowRivalAfterBattleScript,    SCRIPT_SSOLYMPIABOW_RIVAL_AFTER_BATTLE

; The deck rival: he is simply standing out on the deck when the player walks
; out, and challenges once they near the far end. He used to fly in as a bird
; that "transformed" into him (two overlapping toggled objects at one tile);
; Josh cut that 2026-08-02 -- he is just there now.
;
; The bird object and both toggle constants are deliberately KEPT. Toggle
; indices are global and live in wToggleableObjectFlags inside the saved "Main
; Data" block, so deleting one renumbers every later index and corrupts existing
; saves. The bird is simply parked OFF in data/maps/toggleable_objects.asm and
; never shown; see feedback_toggleable_object_gotchas.
;
; Trigger-then-defer shape (arm sound, poll BIT_SCRIPTED_NPC_MOVEMENT next tick,
; THEN text) still matches the Route22/Silph-7F/burned-lab rival approaches --
; see their postmortems for why a bare same-tick text box freezes.
SSOlympiaBowDefaultScript:
	CheckEvent EVENT_BEAT_SS_OLYMPIA_RIVAL
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
	call Delay3
	ld a, SCRIPT_SSOLYMPIABOW_RIVAL_APPROACH
	ld [wSSOlympiaBowCurScript], a
	ld [wCurMapScript], a
	ret

.AmbushCoords:
	dbmapcoord  9,  6
	dbmapcoord  9,  7
	db -1 ; end

SSOlympiaBowRivalApproachWaitScript:
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, SSOLYMPIABOW_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, SCRIPT_SSOLYMPIABOW_RIVAL_START_BATTLE
	ld [wSSOlympiaBowCurScript], a
	ld [wCurMapScript], a
	ret

SSOlympiaBowRivalStartBattleScript:
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_SSOLYMPIABOW_RIVAL
	ldh [hTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SSOlympiaBowRivalDefeatedText
	ld de, SSOlympiaBowRivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL3
	ld [wCurOpponent], a
; Trainer 41: one L100 Alakachamp, the ship's one-Pokemon rule applied to its
; final fight (data/trainers/parties.asm). No GetPlayerPath branch any more --
; the path-tier birds belonged to the six-mon roster, which is moving elsewhere,
; so all three paths now meet the same deck fight.
	ld a, 41
	ld [wTrainerNo], a
	ld a, SCRIPT_SSOLYMPIABOW_RIVAL_AFTER_BATTLE
	ld [wSSOlympiaBowCurScript], a
	ld [wCurMapScript], a
	ret

; Win or lose, the ambush doesn't retrigger and the rival stays on deck
; afterward (talking to him offers the trade, see TEXT_SSOLYMPIABOW_RIVAL).
SSOlympiaBowRivalAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SSOlympiaBowResetScripts
	xor a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_SS_OLYMPIA_RIVAL
SSOlympiaBowResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wSSOlympiaBowCurScript], a
	ld [wCurMapScript], a
	ret

SSOlympiaBow_TextPointers:
	def_text_pointers
	dw_const SSOlympiaBowSuperNerdText, TEXT_SSOLYMPIABOW_SUPER_NERD
	dw_const SSOlympiaBowBirdText, TEXT_SSOLYMPIABOW_BIRD
	dw_const SSOlympiaBowRivalText, TEXT_SSOLYMPIABOW_RIVAL
	dw_const SSOlympiaBowSailorText, TEXT_SSOLYMPIABOW_SAILOR
	dw_const SSOlympiaBowSwimmerText, TEXT_SSOLYMPIABOW_SWIMMER
	dw_const SSOlympiaBowRockerText, TEXT_SSOLYMPIABOW_ROCKER
	dw_const SSOlympiaBowJugglerText, TEXT_SSOLYMPIABOW_JUGGLER

SSOlympiaBowTrainerHeaders:
	def_trainers 3
SSOlympiaBowTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_BOW_TRAINER_0, 3, SSOlympiaBowSailorBattleText, SSOlympiaBowSailorEndBattleText, SSOlympiaBowSailorAfterBattleText
SSOlympiaBowTrainerHeader1:
	trainer EVENT_BEAT_SS_OLYMPIA_BOW_TRAINER_1, 3, SSOlympiaBowSwimmerBattleText, SSOlympiaBowSwimmerEndBattleText, SSOlympiaBowSwimmerAfterBattleText
SSOlympiaBowTrainerHeader2:
	trainer_in wOlympiaTrainerFlags, 21, 2, SSOlympiaBowRockerBattleText, SSOlympiaBowRockerEndBattleText, SSOlympiaBowRockerAfterBattleText
SSOlympiaBowTrainerHeader3:
	trainer_in wOlympiaTrainerFlags, 22, 2, SSOlympiaBowJugglerBattleText, SSOlympiaBowJugglerEndBattleText, SSOlympiaBowJugglerAfterBattleText
	db -1 ; end

SSOlympiaBowSuperNerdText:
	text_far _SSOlympiaBowSuperNerdText
	text_end

SSOlympiaBowBirdText:
	text_far _SSOlympiaBowBirdText
	text_end

; Before the fight, this is the pre-battle challenge (shown by
; SSOlympiaBowRivalStartBattleScript above). After the fight, talking to the
; rival offers the Mew<->Alakachamp trade -- DoInGameTradeDialogue handles
; the "don't have a Mew"/"already traded" states itself, same as every other
; NPC trade in the game.
SSOlympiaBowRivalText:
	text_asm
	CheckEvent EVENT_BEAT_SS_OLYMPIA_RIVAL
	jr nz, .offerTrade
	ld hl, .AmbushText
	call PrintText
	jp TextScriptEnd
.offerTrade
	ld a, TRADE_FOR_OLYMPIA_RIVAL
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd

.AmbushText:
	text_far _SSOlympiaBowRivalAmbushText
	text_end

SSOlympiaBowSailorText:
	text_asm
	ld hl, SSOlympiaBowTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaBowSwimmerText:
	text_asm
	ld hl, SSOlympiaBowTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaBowRivalDefeatedText:
	text_far _SSOlympiaBowRivalDefeatedText
	text_end

SSOlympiaBowRivalVictoryText:
	text_far _SSOlympiaBowRivalVictoryText
	text_end

SSOlympiaBowSailorBattleText:
	text_far _SSOlympiaBowSailorBattleText
	text_end

SSOlympiaBowSailorEndBattleText:
	text_far _SSOlympiaBowSailorEndBattleText
	text_end

SSOlympiaBowSailorAfterBattleText:
	text_far _SSOlympiaBowSailorAfterBattleText
	text_end

SSOlympiaBowSwimmerBattleText:
	text_far _SSOlympiaBowSwimmerBattleText
	text_end

SSOlympiaBowSwimmerEndBattleText:
	text_far _SSOlympiaBowSwimmerEndBattleText
	text_end

SSOlympiaBowSwimmerAfterBattleText:
	text_far _SSOlympiaBowSwimmerAfterBattleText
	text_end

SSOlympiaBowRockerText:
	text_asm
	ld hl, SSOlympiaBowTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaBowRockerBattleText:
	text_far _SSOlympiaBowRockerBattleText
	text_end

SSOlympiaBowRockerEndBattleText:
	text_far _SSOlympiaBowRockerEndBattleText
	text_end

SSOlympiaBowRockerAfterBattleText:
	text_far _SSOlympiaBowRockerAfterBattleText
	text_end

SSOlympiaBowJugglerText:
	text_asm
	ld hl, SSOlympiaBowTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSOlympiaBowJugglerBattleText:
	text_far _SSOlympiaBowJugglerBattleText
	text_end

SSOlympiaBowJugglerEndBattleText:
	text_far _SSOlympiaBowJugglerEndBattleText
	text_end

SSOlympiaBowJugglerAfterBattleText:
	text_far _SSOlympiaBowJugglerAfterBattleText
	text_end
