ApexMart2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart2F_ScriptPointers
	ld a, [wApexMartCurScript]
	jp CallFunctionInTable

ApexMart2F_ScriptPointers:
	def_script_pointers
	dw_const ApexMart2FDefaultScript,       SCRIPT_APEXMART2F_DEFAULT
	dw_const ApexMart2FScientistPostBattle, SCRIPT_APEXMART2F_POSTBATTLE

ApexMart2FDefaultScript:
	ret

ApexMart2FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, ApexMart2FResetScripts
	ld hl, wScientistsDefeated
	set 1, [hl] ; Emporium scientist 1 defeated (needed to face the roof scientist)
ApexMart2FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart2F_TextPointers:
	def_text_pointers
	dw_const ApexMart2FScientistText, TEXT_APEXMART2F_SCIENTIST

; Unique challenge/win text comes from the shared scientist engine (index 1,
; engine/events/lab_scientists.asm). No stone here -- the roof scientist hands
; over all six MUTAGENSTONEs.
ApexMart2FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 1, a
	jr nz, .afterBeat
	ld c, 1 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, 15 ; ScientistData party #15
	ld [wTrainerNo], a
	ld a, SCRIPT_APEXMART2F_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text "Discharged."
	line "Keep climbing."
	prompt
