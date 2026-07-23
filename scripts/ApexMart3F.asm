ApexMart3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart3FTrainerHeaders
	ld de, ApexMart3F_ScriptPointers
	ld a, [wApexMartCurScript]
	call ExecuteCurMapScriptInTable
	ld [wApexMartCurScript], a
	ret

ApexMart3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_APEXMART3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_APEXMART3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_APEXMART3F_END_BATTLE
	dw_const ApexMart3FScientistPostBattle,       SCRIPT_APEXMART3F_POST_BATTLE

ApexMart3FTrainerHeaders:
	def_trainers
	db -1 ; no sight trainers; the scientist is engaged manually on talk

ApexMart3FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMart3FResetScripts
	ld hl, wScientistsDefeated
	set 2, [hl] ; Emporium scientist 2 defeated
ApexMart3FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart3F_TextPointers:
	def_text_pointers
	dw_const ApexMart3FScientistText, TEXT_APEXMART3F_SCIENTIST

ApexMart3FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 2, a
	jr nz, .afterBeat
	ld c, 2 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_APEXMART3F_POST_BATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text "Pried apart."
	line "The ROOF waits."
	prompt
