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
	jp z, ApexMart4FResetScripts
	ld hl, wScientistsDefeated
	set 3, [hl] ; Emporium scientist 3 defeated
	ld a, TEXT_APEXMART4F_SCIENTIST_STONE
	ldh [hTextID], a
	call DisplayTextID
ApexMart4FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart4F_TextPointers:
	def_text_pointers
	dw_const ApexMart4FScientistText,      TEXT_APEXMART4F_SCIENTIST
	dw_const ApexMart4FScientistStoneText, TEXT_APEXMART4F_SCIENTIST_STONE

; Reuses the shared burned-lab scientist engine (engine/events/lab_scientists.asm):
; unique challenge/win text by index, a MUTAGENSTONE on the win, and the
; wScientistsDefeated bit that (all six set) powers the roof machine.
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
	text "Beat all six of"
	line "us and the ROOF"
	cont "machine wakes up."
	prompt

ApexMart4FScientistStoneText:
	text_asm
	farcall LabScientistGiveStone
	jp TextScriptEnd
