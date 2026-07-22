ApexMart4F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart4F_ScriptPointers
	ld a, [wApexMartCurScript]
	jp CallFunctionInTable

ApexMart4F_ScriptPointers:
	def_script_pointers
	dw_const ApexMart4FDefaultScript,       SCRIPT_APEXMART4F_DEFAULT
	dw_const ApexMart4FScientistPostBattle, SCRIPT_APEXMART4F_POSTBATTLE

ApexMart4FDefaultScript:
	ret

ApexMart4FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, ApexMart4FResetScripts
	ld hl, wScientistsDefeated
	set 3, [hl] ; Emporium scientist 3 defeated (needed to face the roof scientist)
ApexMart4FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart4F_TextPointers:
	def_text_pointers
	dw_const ApexMart4FScientistText, TEXT_APEXMART4F_SCIENTIST

; Unique challenge/win text comes from the shared scientist engine (index 3,
; engine/events/lab_scientists.asm). No stone here -- the roof scientist hands
; over all six MUTAGENSTONEs.
ApexMart4FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 3, a
	jr nz, .afterBeat
	ld c, 3 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, 17 ; ScientistData party #17
	ld [wTrainerNo], a
	ld a, SCRIPT_APEXMART4F_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text "As I foresaw."
	line "Go up. He knows."
	prompt
