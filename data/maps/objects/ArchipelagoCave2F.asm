	object_const_def

ArchipelagoCave2F_Object:
	db $19 ; border block (cave wall/floor)

; see ArchipelagoCave1F.asm's comment -- both warp cells sit one block west
; of a $3C stairs-icon block (adjacent to, not on, the warp's floor cell).
	def_warp_events
	warp_event 4, 1, ARCHIPELAGO_CAVE_1F, 2 ; stairs up; icon at block(2,0)
	warp_event 4, 7, ARCHIPELAGO_CAVE_3F, 1 ; stairs down to the grotto; icon at block(2,3)

	def_bg_events

	def_object_events

	def_warps_to ARCHIPELAGO_CAVE_2F
