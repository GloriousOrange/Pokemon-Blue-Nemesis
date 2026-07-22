ApexMart1F_Script:
	jp EnableAutoTextBoxDrawing

ApexMart1F_TextPointers:
	def_text_pointers
	dw_const ApexMart1FFerrymanText, TEXT_APEXMART1F_FERRYMAN

; Return ferry: fly-warps back to PALLET_TOWN (same mechanism as the Pallet
; ferryman outbound). Always available -- returning home is never gated.
ApexMart1FFerrymanText:
	text_asm
	ld hl, .OfferText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .declined
	ld a, SFX_HEAL_AILMENT
	call PlaySound
	ld a, PALLET_TOWN
	ld [wDestinationMap], a
	ld hl, wStatusFlags6
	set BIT_FLY_WARP, [hl]
	jp TextScriptEnd
.declined
	ld hl, .DeclinedText
	call PrintText
	jp TextScriptEnd

.OfferText:
	text "Ready to sail"
	line "back to PALLET"
	cont "TOWN?"
	prompt

.DeclinedText:
	text "Take your time"
	line "on the island."
	prompt
