UpdateCinnabarGymGateTileBlocks::
	farjp UpdateCinnabarGymGateTileBlocks_

CheckForHiddenEventOrBookshelfOrCardKeyDoor::
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hJoyHeld]
	bit B_PAD_A, a
	jr z, .nothingFound
; A button is pressed
	ld a, BANK(CheckForHiddenEvent)
	ld [rROMB], a
	ldh [hLoadedROMBank], a
	call CheckForHiddenEvent
	ldh a, [hDidntFindAnyHiddenEvent]
	and a
	jr nz, .hiddenEventNotFound
	ld a, [wHiddenEventFunctionRomBank]
	ld [rROMB], a
	ldh [hLoadedROMBank], a
	ld de, .returnAddress
	push de
	jp hl
.returnAddress
; CheckForHiddenEvent already zeroed hItemAlreadyFound, so the A press counts as
; handled -- unless the hidden event declined it (see HiddenObjectDeclineAPress)
; by storing $ff back.  Don't clobber that.
	jr .restoreBank
.hiddenEventNotFound
	farcall PrintBookshelfText
	ldh a, [hInteractedWithBookshelf]
	and a
	jr z, .done
.nothingFound
	ld a, $ff
.done
	ldh [hItemAlreadyFound], a
.restoreBank
	pop af
	ld [rROMB], a
	ldh [hLoadedROMBank], a
	ret
