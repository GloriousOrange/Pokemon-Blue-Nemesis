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
	jr z, ApexMart1FResetScripts
	ld hl, wScientistsDefeated
	set 0, [hl] ; Emporium scientist 0 defeated (needed to face the roof scientist)
ApexMart1FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart1F_TextPointers:
	def_text_pointers
	dw_const ApexMart1FScientistText, TEXT_APEXMART1F_SCIENTIST

; Unique challenge/win text from the shared scientist engine (index 0,
; engine/events/lab_scientists.asm). Engages the object's own trainer data
; (OPP_SCIENTIST + party set) -- same proven flow as the burned-lab scientists.
ApexMart1FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 0, a
	jr nz, .afterBeat
	ld c, 0 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
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
	text "Compiled. Climb."
	line "The rest run hot."
	prompt
