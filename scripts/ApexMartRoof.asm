ApexMartRoof_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ApexMartRoof_ScriptPointers
	ld a, [wApexMartCurScript]
	jp CallFunctionInTable

ApexMartRoof_ScriptPointers:
	def_script_pointers
	dw_const ApexMartRoofDefaultScript,       SCRIPT_APEXMARTROOF_DEFAULT
	dw_const ApexMartRoofScientistPostBattle, SCRIPT_APEXMARTROOF_POSTBATTLE

ApexMartRoofDefaultScript:
	ret

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
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, 19 ; ScientistData party #19
	ld [wTrainerNo], a
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
