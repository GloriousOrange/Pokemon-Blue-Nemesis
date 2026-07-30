_Start::
	cp BOOTUP_A_CGB
	jr z, .cgb
	xor a
	jr .ok
.cgb
	ld a, TRUE ; vanilla hardcoded this to FALSE: it had no CGB palette support
.ok
	ld [wOnCGB], a
	jp Init
