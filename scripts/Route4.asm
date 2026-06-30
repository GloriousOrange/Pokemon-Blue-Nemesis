Route4_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route4TrainerHeaders
	ld de, Route4_ScriptPointers
	ld a, [wRoute4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute4CurScript], a
	ret

Route4_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_ROUTE4_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_ROUTE4_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_ROUTE4_END_BATTLE
	dw_const Route4MeganDefeatedScript,             SCRIPT_ROUTE4_GIRLFRIEND_DEFEATED

Route4_TextPointers:
	def_text_pointers
	dw_const Route4CooltrainerF1Text, TEXT_ROUTE4_COOLTRAINER_F1
	dw_const Route4CooltrainerF2Text, TEXT_ROUTE4_COOLTRAINER_F2
	dw_const PickUpItemText,          TEXT_ROUTE4_TM_WHIRLWIND
	dw_const Route4MeganText,         TEXT_ROUTE4_MEGAN
	dw_const PokeCenterSignText,      TEXT_ROUTE4_POKECENTER_SIGN
	dw_const Route4MtMoonSignText,    TEXT_ROUTE4_MT_MOON_SIGN
	dw_const Route4SignText,          TEXT_ROUTE4_SIGN

Route4TrainerHeaders:
	def_trainers 2
Route4TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_4_TRAINER_0, 3, Route4CooltrainerF2BattleText, Route4CooltrainerF2EndBattleText, Route4CooltrainerF2AfterBattleText
	db -1 ; end

Route4CooltrainerF1Text:
	text_far _Route4CooltrainerF1Text
	text_end

Route4CooltrainerF2Text:
	text_asm
	ld hl, Route4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route4CooltrainerF2BattleText:
	text_far _Route4CooltrainerF2BattleText
	text_end

Route4CooltrainerF2EndBattleText:
	text_far _Route4CooltrainerF2EndBattleText
	text_end

Route4CooltrainerF2AfterBattleText:
	text_far _Route4CooltrainerF2AfterBattleText
	text_end

Route4MtMoonSignText:
	text_far _Route4MtMoonSignText
	text_end

Route4SignText:
	text_far _Route4SignText
	text_end

; --- Megan (girlfriend): talk -> battle her -> unlock CALL MEGAN in the Start menu, just outside Mt. Moon ---
Route4MeganDefeatedScript:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset ; battle aborted/lost-load, unlock nothing
	ld hl, wPostGameMisc
	set BIT_GOT_GIRLFRIEND, [hl] ; love text is the end-battle text; this adds CALL MEGAN to the Start menu
.reset
	xor a ; SCRIPT_ROUTE4_DEFAULT
	ld [wJoyIgnore], a
	ld [wRoute4CurScript], a
	ld [wCurMapScript], a
	ret

Route4MeganText:
	text_asm
	ld hl, wPostGameMisc
	bit BIT_GOT_GIRLFRIEND, [hl]
	jr nz, .gotHer
	ld hl, Route4MeganChallengeText
	call PrintText
	ld a, OPP_LASS
	ld [wCurOpponent], a
	ld a, 19 ; LassData party #19 = Megan (max L8)
	ld [wTrainerNo], a
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, Route4MeganLoveText ; shown when you WIN
	ld de, Route4MeganBattleVictoryText
	call SaveEndBattleTextPointers
	ld a, SCRIPT_ROUTE4_GIRLFRIEND_DEFEATED
	ld [wRoute4CurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd
.gotHer
	ld hl, Route4MeganAfterText
	call PrintText
	jp TextScriptEnd

Route4MeganChallengeText:
	text_far _Route4MeganChallengeText
	text_end
Route4MeganBattleDefeatedText:
	text_far _Route4MeganBattleDefeatedText
	text_end
Route4MeganBattleVictoryText:
	text_far _Route4MeganBattleVictoryText
	text_end
Route4MeganLoveText:
	text_far _Route4MeganLoveText
	text_end
Route4MeganAfterText:
	text_far _Route4MeganAfterText
	text_end
