ApexMart5F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart5FTrainerHeaders
	ld de, ApexMart5F_ScriptPointers
	ld a, [wApexMartCurScript]
	call ExecuteCurMapScriptInTable
	ld [wApexMartCurScript], a
	ret

ApexMart5F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_APEXMART5F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_APEXMART5F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_APEXMART5F_END_BATTLE
	dw_const ApexMart5FScientistPostBattle,       SCRIPT_APEXMART5F_POST_BATTLE

ApexMart5FTrainerHeaders:
	def_trainers
	db -1 ; no sight trainers; the scientist is engaged manually on talk

ApexMart5FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMart5FResetScripts
	ld hl, wScientistsDefeated
	set 4, [hl] ; Emporium scientist 4 defeated
ApexMart5FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart5F_TextPointers:
	def_text_pointers
	dw_const ApexMart5FScientistText, TEXT_APEXMART5F_SCIENTIST

ApexMart5FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 4, a
	jr nz, .afterBeat
	ld c, 4 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_APEXMART5F_POST_BATTLE
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
