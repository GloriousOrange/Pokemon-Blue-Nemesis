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

ApexMartRoofScientistPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ApexMartRoofResetScripts
	ld hl, wScientistsDefeated
	set 5, [hl] ; the sixth (roof) scientist -- all six now power the machine
	ld a, TEXT_APEXMARTROOF_SCIENTIST_STONE
	ldh [hTextID], a
	call DisplayTextID
ApexMartRoofResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ApexMartRoof_TextPointers:
	def_text_pointers
	dw_const ApexMartRoofScientistText,      TEXT_APEXMARTROOF_SCIENTIST ; object_event 1
	dw_const ApexMartRoofMachineText,        TEXT_APEXMARTROOF_MACHINE    ; object_event 2
	dw_const ApexMartRoofScientistStoneText, TEXT_APEXMARTROOF_SCIENTIST_STONE ; internal (stone award)

; The sixth scientist. Once you've used the machine (EVENT_USED_MUTAGEN_MACHINE),
; he reveals where OAK is instead of the machine hint.
ApexMartRoofScientistText:
	text_asm
	ld a, [wScientistsDefeated]
	bit 5, a
	jr nz, .afterBeat
	ld c, 5 ; scientist index -> unique challenge/win text
	farcall LabScientistBattleInit
	ld a, OPP_SCIENTIST
	ld [wCurOpponent], a
	ld a, 19 ; ScientistData party #19
	ld [wTrainerNo], a
	ld a, SCRIPT_APEXMARTROOF_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.afterBeat
	CheckEvent EVENT_USED_MUTAGEN_MACHINE
	jr nz, .revealOak
	ld hl, .UseMachineText
	call PrintText
	jr .done
.revealOak
	ld hl, .OakRevealText
	call PrintText
.done
	jp TextScriptEnd

.UseMachineText:
	text "The machine's live"
	line "now. Feed it a"
	cont "MUTAGENSTONE."
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

ApexMartRoofScientistStoneText:
	text_asm
	farcall LabScientistGiveStone
	jp TextScriptEnd

; The MUTAGEN machine. Powers up once all six scientists are beaten, then arms
; the MUTAGENSTONE for use from the BAG (BIT_LEVEL_MACHINE_READY, which clears on
; map load -- so the stone must be used here, on the roof).
ApexMartRoofMachineText:
	text_asm
	ld a, [wScientistsDefeated]
	cp %00111111 ; all six scientists beaten?
	jr z, .ready
	ld hl, .DeadText
	call PrintText
	jp TextScriptEnd
.ready
	ld a, [wPartyCount]
	and a
	jp z, .doneJp ; guard: AnimateHealingMachine loops on wPartyCount
	ld hl, .OfferText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declined
	farcall AnimateHealingMachine
	call PlayDefaultMusic
	ld hl, wPostGameMisc
	set BIT_LEVEL_MACHINE_READY, [hl]
	ld hl, .ReadyText
	call PrintText
	jp TextScriptEnd
.declined
	ld hl, .DeclinedText
	call PrintText
.doneJp
	jp TextScriptEnd

.DeadText:
	text "The MUTAGEN"
	line "machine sits dark."

	para "The SCIENTISTS"
	line "hold its current."
	prompt

.OfferText:
	text "The MUTAGEN"
	line "machine wakes and"
	cont "hums."

	para "Charge it up?"
	prompt

.ReadyText:
	text "PRIMED!"

	para "Use a MUTAGENSTONE"
	line "from your BAG on a"
	cont "#MON, right here."
	prompt

.DeclinedText:
	text "It hums, waiting."
	prompt
