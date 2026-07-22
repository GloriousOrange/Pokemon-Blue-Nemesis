ApexMart3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart3F_ScriptPointers
	ld a, [wApexMartCurScript]
	jp CallFunctionInTable

ApexMart3F_ScriptPointers:
	def_script_pointers
	dw_const ApexMart3FDefaultScript,       SCRIPT_APEXMART3F_DEFAULT
	dw_const ApexMart3FScientistPostBattle, SCRIPT_APEXMART3F_POSTBATTLE

ApexMart3FDefaultScript:
	ret

ApexMart3FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, ApexMart3FResetScripts
	ld hl, wScientistsDefeated
	set 2, [hl] ; Emporium scientist 2 defeated (needed to face the roof scientist)
ApexMart3FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart3F_TextPointers:
	def_text_pointers
	dw_const ApexMart3FScientistText, TEXT_APEXMART3F_SCIENTIST

; Unique challenge/win text comes from the shared scientist engine (index 2,
; engine/events/lab_scientists.asm). No stone here -- the roof scientist hands
; over all six MUTAGENSTONEs.
ApexMart3FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 2, a
	jr nz, .afterBeat
	ld c, 2 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, 16 ; ScientistData party #16
	ld [wTrainerNo], a
	ld a, SCRIPT_APEXMART3F_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text "Pried apart."
	line "The ROOF waits."
	prompt
