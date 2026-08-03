ApexMartElevator_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	push hl
	call nz, ApexMartElevatorStoreWarpEntriesScript
	pop hl
	bit BIT_CUR_MAP_USED_ELEVATOR, [hl]
	res BIT_CUR_MAP_USED_ELEVATOR, [hl]
	call nz, ApexMartElevatorShakeScript
	xor a
	ld [wAutoTextBoxDrawingControl], a
	inc a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

ApexMartElevatorStoreWarpEntriesScript:
	ld hl, wWarpEntries
	ld a, [wWarpedFromWhichWarp]
	ld b, a
	ld a, [wWarpedFromWhichMap]
	ld c, a
	call .StoreWarpEntry
	; fallthrough
.StoreWarpEntry:
	inc hl
	inc hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ret

ApexMartElevatorCopyWarpMapsScript:
	ld hl, ApexMartElevatorFloors
	call LoadItemList
	ld hl, ApexMartElevatorWarpMaps
	ld de, wElevatorWarpMaps
	ld bc, ApexMartElevatorWarpMaps.End - ApexMartElevatorWarpMaps
	jp CopyData

ApexMartElevatorFloors:
	db 5 ; #
	db FLOOR_1F
	db FLOOR_2F
	db FLOOR_3F
	db FLOOR_4F
	db FLOOR_5F
	db -1 ; end

; These specify where the player goes after getting out of the elevator.
ApexMartElevatorWarpMaps:
	; warp number, map id
	db 5, APEX_MART_1F
	db 2, APEX_MART_2F
	db 2, APEX_MART_3F
	db 2, APEX_MART_4F
	db 2, APEX_MART_5F
.End:

ApexMartElevatorShakeScript:
	farjp ShakeElevator

ApexMartElevator_TextPointers:
	def_text_pointers
	dw_const ApexMartElevatorText, TEXT_APEXMARTELEVATOR

ApexMartElevatorText:
	text_asm
	call ApexMartElevatorCopyWarpMapsScript
	ld hl, ApexMartElevatorWarpMaps
	predef DisplayElevatorFloorMenu
	jp TextScriptEnd
