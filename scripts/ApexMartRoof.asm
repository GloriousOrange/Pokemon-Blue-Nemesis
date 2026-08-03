ApexMartRoof_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMartRoofTrainerHeaders
	ld de, ApexMartRoof_ScriptPointers
	ld a, [wApexMartCurScript]
	call ExecuteCurMapScriptInTable
	ld [wApexMartCurScript], a
	ret

ApexMartRoof_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_APEXMARTROOF_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_APEXMARTROOF_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_APEXMARTROOF_END_BATTLE
	dw_const ApexMartRoofScientistPostBattle,       SCRIPT_APEXMARTROOF_POSTBATTLE

ApexMartRoofTrainerHeaders:
	def_trainers
	db -1 ; no sight trainers; the scientist is engaged manually on talk

; On defeat: mark the sixth scientist, hand over all six MUTAGENSTONES, and
; reveal OAK (EVENT_USED_MUTAGEN_MACHINE -> he appears at the water in the cave).
ApexMartRoofScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMartRoofResetScripts
	ld hl, wScientistsDefeated
	set 5, [hl]
	SetEvent EVENT_USED_MUTAGEN_MACHINE
	ld a, TEXT_APEXMARTROOF_STONES
	ldh [hTextID], a
	call DisplayTextID
ApexMartRoofResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMartRoof_TextPointers:
	def_text_pointers
	dw_const ApexMartRoofScientistText, TEXT_APEXMARTROOF_SCIENTIST ; object_event 1
	dw_const ApexMartRoofStonesText,    TEXT_APEXMARTROOF_STONES     ; internal (win handoff)

; The sixth (roof) scientist. You must beat the five below first. Beating him
; hands over the six MUTAGENSTONES and reveals where OAK is.
ApexMartRoofScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 5, a
	jr nz, .afterBeat
	and %00011111 ; the five floor scientists (bits 0-4)
	cp %00011111
	jr z, .fight
	ld hl, .NeedFloorsText
	call PrintText
	jp TextScriptEnd
.fight
	ld c, 5 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_APEXMARTROOF_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd
.afterBeat
	ld hl, .OakRevealText
	call PrintText
	jp TextScriptEnd

.NeedFloorsText:
	text "Beat all five of"
	line "us below me"
	cont "first."
	prompt

.OakRevealText:
	text "PROF. OAK is deep"
	line "in the CAVE, down"
	cont "by the water..."

	para "training his"
	line "slaves in the"
	cont "dark."

	para "Go see what he's"
	line "become."
	prompt

; The win handoff: six MUTAGENSTONES + the reveal.
ApexMartRoofStonesText:
	text_asm
	ld hl, .Text
	call PrintText
	lb bc, LEVEL_STONE, 6
	call GiveItem
	jp TextScriptEnd

.Text:
	text "Take our six"
	line "MUTAGENSTONES."

	para "Feed one to a"
	line "#MON from your"
	cont "BAG -- straight to"
	cont "level 100."

	para "Now... OAK waits"
	line "in the CAVE, by"
	cont "the water."
	prompt
