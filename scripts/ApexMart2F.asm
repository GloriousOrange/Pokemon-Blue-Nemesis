ApexMart2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart2FTrainerHeaders
	ld de, ApexMart2F_ScriptPointers
	ld a, [wApexMartCurScript]
	call ExecuteCurMapScriptInTable
	ld [wApexMartCurScript], a
	ret

ApexMart2F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_APEXMART2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_APEXMART2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_APEXMART2F_END_BATTLE
	dw_const ApexMart2FScientistPostBattle,       SCRIPT_APEXMART2F_POST_BATTLE

ApexMart2FTrainerHeaders:
	def_trainers
	db -1 ; no sight trainers; the scientist is engaged manually on talk

ApexMart2FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMart2FResetScripts
	ld hl, wScientistsDefeated
	set 1, [hl] ; Emporium scientist 1 defeated
ApexMart2FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart2F_TextPointers:
	def_text_pointers
	dw_const ApexMart2FScientistText, TEXT_APEXMART2F_SCIENTIST

ApexMart2FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 1, a
	jr nz, .afterBeat
	ld c, 1 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_APEXMART2F_POST_BATTLE
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
