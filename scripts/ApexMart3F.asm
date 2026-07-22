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
	jp z, ApexMart3FResetScripts
	ld hl, wScientistsDefeated
	set 2, [hl] ; Emporium scientist 2 defeated
	ld a, TEXT_APEXMART3F_SCIENTIST_STONE
	ldh [hTextID], a
	call DisplayTextID
ApexMart3FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart3F_TextPointers:
	def_text_pointers
	dw_const ApexMart3FScientistText,      TEXT_APEXMART3F_SCIENTIST
	dw_const ApexMart3FScientistStoneText, TEXT_APEXMART3F_SCIENTIST_STONE

; Reuses the shared burned-lab scientist engine (engine/events/lab_scientists.asm):
; unique challenge/win text by index, a MUTAGENSTONE on the win, and the
; wScientistsDefeated bit that (all six set) powers the roof machine.
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
	text "Beat all six of"
	line "us and the ROOF"
	cont "machine wakes up."
	prompt

ApexMart3FScientistStoneText:
	text_asm
	farcall LabScientistGiveStone
	jp TextScriptEnd
