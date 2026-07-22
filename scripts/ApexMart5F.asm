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
	jp z, ApexMart5FResetScripts
	ld hl, wScientistsDefeated
	set 4, [hl] ; Emporium scientist 4 defeated
	ld a, TEXT_APEXMART5F_SCIENTIST_STONE
	ldh [hTextID], a
	call DisplayTextID
ApexMart5FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart5F_TextPointers:
	def_text_pointers
	dw_const ApexMart5FScientistText,      TEXT_APEXMART5F_SCIENTIST
	dw_const ApexMart5FScientistStoneText, TEXT_APEXMART5F_SCIENTIST_STONE

; Reuses the shared burned-lab scientist engine (engine/events/lab_scientists.asm):
; unique challenge/win text by index, a MUTAGENSTONE on the win, and the
; wScientistsDefeated bit that (all six set) powers the roof machine.
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
	text "Beat all six of"
	line "us and the ROOF"
	cont "machine wakes up."
	prompt

ApexMart5FScientistStoneText:
	text_asm
	farcall LabScientistGiveStone
	jp TextScriptEnd
