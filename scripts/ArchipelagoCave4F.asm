ArchipelagoCave4F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ArchipelagoCave4F_ScriptPointers
	ld a, [wApexMartCurScript] ; shared transient endgame script state
	jp CallFunctionInTable

ArchipelagoCave4F_ScriptPointers:
	def_script_pointers
	dw_const ArchipelagoCave4FDefaultScript,  SCRIPT_ARCHIPELAGOCAVE4F_DEFAULT
	dw_const ArchipelagoCave4FRocketPostBattle, SCRIPT_ARCHIPELAGOCAVE4F_POSTBATTLE

ArchipelagoCave4FDefaultScript:
	ret

ArchipelagoCave4FRocketPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ArchipelagoCave4FResetScripts
	SetEvent EVENT_BEAT_GHOST_ROCKET
ArchipelagoCave4FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ArchipelagoCave4F_TextPointers:
	def_text_pointers
	dw_const ArchipelagoCave4FGhostRocketText, TEXT_ARCHIPELAGOCAVE4F_GHOST_ROCKET
	; item balls use the shared pick-up text; an object's text ID is its
	; object index, so this has to stay second
	dw_const PickUpItemText,                   TEXT_ARCHIPELAGOCAVE4F_ESCAPE_ROPE

ArchipelagoCave4FGhostRocketText:
	text_asm
	CheckEvent EVENT_BEAT_GHOST_ROCKET
	jr nz, .beaten
	ld hl, .ChallengeText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .DefeatText
	ld de, .VictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_GHOST_ROCKET
	ld [wCurOpponent], a
	ld a, 1
	ld [wTrainerNo], a
	ld a, SCRIPT_ARCHIPELAGOCAVE4F_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.beaten
	ld hl, .AfterText
	call PrintText
.done
	jp TextScriptEnd

.ChallengeText:
	text "...you fell too."

	para "I stopped counting"
	line "the days. Nobody"
	cont "comes down here."

	para "My team went cold"
	line "a long time ago."
	cont "They still fight."
	prompt

.DefeatText:
	text ""
	line "...still cold."
	prompt

.VictoryText:
	text ""
	line "Stay. It's quiet"
	cont "here."
	prompt

.AfterText:
	text "He does not look"
	line "up again."
	prompt
