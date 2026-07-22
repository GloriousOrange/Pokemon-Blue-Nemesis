ApexMart5F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart5F_ScriptPointers
	ld a, [wApexMartCurScript]
	jp CallFunctionInTable

ApexMart5F_ScriptPointers:
	def_script_pointers
	dw_const ApexMart5FDefaultScript,       SCRIPT_APEXMART5F_DEFAULT
	dw_const ApexMart5FScientistPostBattle, SCRIPT_APEXMART5F_POSTBATTLE

ApexMart5FDefaultScript:
	ret

ApexMart5FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jr z, ApexMart5FResetScripts
	ld hl, wScientistsDefeated
	set 4, [hl] ; Emporium scientist 4 defeated (needed to face the roof scientist)
ApexMart5FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart5F_TextPointers:
	def_text_pointers
	dw_const ApexMart5FScientistText, TEXT_APEXMART5F_SCIENTIST

; Unique challenge/win text comes from the shared scientist engine (index 4,
; engine/events/lab_scientists.asm). No stone here -- the roof scientist hands
; over all six MUTAGENSTONEs.
ApexMart5FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 4, a
	jr nz, .afterBeat
	ld c, 4 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, 18 ; ScientistData party #18
	ld [wTrainerNo], a
	ld a, SCRIPT_APEXMART5F_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text "Cold now."
	line "One floor left."
	prompt
