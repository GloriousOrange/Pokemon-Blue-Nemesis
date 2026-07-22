ApexMart1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart1F_ScriptPointers
	ld a, [wApexMartCurScript]
	jp CallFunctionInTable

ApexMart1F_ScriptPointers:
	def_script_pointers
	dw_const ApexMart1FDefaultScript,       SCRIPT_APEXMART1F_DEFAULT
	dw_const ApexMart1FScientistPostBattle, SCRIPT_APEXMART1F_POSTBATTLE

ApexMart1FDefaultScript:
	ret

ApexMart1FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMart1FResetScripts
	ld hl, wScientistsDefeated
	set 0, [hl] ; Emporium scientist 0 defeated
	ld a, TEXT_APEXMART1F_SCIENTIST_STONE
	ldh [hTextID], a
	call DisplayTextID
ApexMart1FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart1F_TextPointers:
	def_text_pointers
	dw_const ApexMart1FScientistText,      TEXT_APEXMART1F_SCIENTIST
	dw_const ApexMart1FScientistStoneText, TEXT_APEXMART1F_SCIENTIST_STONE

; Reuses the shared burned-lab scientist engine (engine/events/lab_scientists.asm):
; unique challenge/win text by index, a MUTAGENSTONE on the win, and the
; wScientistsDefeated bit that (all six set) powers the roof machine.
ApexMart1FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 0, a
	jr nz, .afterBeat
	ld c, 0 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, 14 ; ScientistData party #14
	ld [wTrainerNo], a
	ld a, SCRIPT_APEXMART1F_POSTBATTLE
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

ApexMart1FScientistStoneText:
	text_asm
	farcall LabScientistGiveStone
	jp TextScriptEnd
