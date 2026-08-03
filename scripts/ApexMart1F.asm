ApexMart1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart1FTrainerHeaders
	ld de, ApexMart1F_ScriptPointers
	ld a, [wApexMartCurScript]
	call ExecuteCurMapScriptInTable
	ld [wApexMartCurScript], a
	ret

ApexMart1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_APEXMART1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_APEXMART1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_APEXMART1F_END_BATTLE
	dw_const ApexMart1FScientistPostBattle,       SCRIPT_APEXMART1F_POST_BATTLE

ApexMart1FTrainerHeaders:
	def_trainers
	db -1 ; no sight trainers; the scientist is engaged manually on talk

ApexMart1FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMart1FResetScripts
	ld hl, wScientistsDefeated
	set 0, [hl] ; Emporium scientist 0 defeated
ApexMart1FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart1F_TextPointers:
	def_text_pointers
	dw_const ApexMart1FScientistText, TEXT_APEXMART1F_SCIENTIST

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
	ld a, SCRIPT_APEXMART1F_POST_BATTLE
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
