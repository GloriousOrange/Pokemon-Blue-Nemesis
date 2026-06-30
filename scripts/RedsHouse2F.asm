RedsHouse2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2F_ScriptPointers
	ld a, [wRedsHouse2FCurScript]
	jp CallFunctionInTable

RedsHouse2F_ScriptPointers:
	def_script_pointers
	dw_const RedsHouse2FDefaultScript, SCRIPT_REDSHOUSE2F_DEFAULT
	dw_const RedsHouse2FNoopScript,    SCRIPT_REDSHOUSE2F_NOOP

RedsHouse2FDefaultScript:
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
; --- one-time challenge options (wUnusedPlayerDataByte = $ff until answered) ---
	ld a, [wUnusedPlayerDataByte]
	cp $ff
	jr nz, .challengeDone
	xor a
	ld [wUnusedPlayerDataByte], a ; mark answered; default both challenges off
	ld hl, .ChallengeDoubleXpText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .askNoItems
	ld hl, wUnusedPlayerDataByte
	set BIT_CHALLENGE_DOUBLE_XP, [hl]
.askNoItems
	ld hl, .ChallengeNoItemsText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .challengeDone
	ld hl, wUnusedPlayerDataByte
	set BIT_CHALLENGE_NO_ITEMS, [hl]
.challengeDone
	ld a, SCRIPT_REDSHOUSE2F_NOOP
	ld [wRedsHouse2FCurScript], a
	ret

.ChallengeDoubleXpText:
	text "CHALLENGE: earn"
	line "DOUBLE EXP from"
	cont "TRAINER battles?"
	prompt

.ChallengeNoItemsText:
	text "CHALLENGE: forbid"
	line "ITEMS during"
	cont "battle?"
	prompt

RedsHouse2FNoopScript:
	ret

RedsHouse2F_TextPointers:
	def_text_pointers

	text_end ; unused
