ApexMart4F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMart4FTrainerHeaders
	ld de, ApexMart4F_ScriptPointers
	ld a, [wApexMartCurScript]
	call ExecuteCurMapScriptInTable
	ld [wApexMartCurScript], a
	ret

ApexMart4F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_APEXMART4F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_APEXMART4F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_APEXMART4F_END_BATTLE
	dw_const ApexMart4FScientistPostBattle,       SCRIPT_APEXMART4F_POST_BATTLE

ApexMart4FTrainerHeaders:
	def_trainers
	db -1 ; no sight trainers; the scientist is engaged manually on talk

ApexMart4FScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMart4FResetScripts
	ld hl, wScientistsDefeated
	set 3, [hl] ; Emporium scientist 3 defeated
ApexMart4FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMart4F_TextPointers:
	def_text_pointers
	dw_const ApexMart4FScientistText, TEXT_APEXMART4F_SCIENTIST

ApexMart4FScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 3, a
	jr nz, .afterBeat
	ld c, 3 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_APEXMART4F_POST_BATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	ld hl, .AfterBeatText
	call PrintText
.done
	jp TextScriptEnd

.AfterBeatText:
	text "As I foresaw."
	line "Go up. He knows."
	prompt
