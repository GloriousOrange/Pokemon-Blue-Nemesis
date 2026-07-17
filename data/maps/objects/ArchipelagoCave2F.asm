	object_const_def

ArchipelagoCave2F_Object:
	db $19 ; border block (cave wall/floor)

	def_warp_events
	warp_event 4, 1, ARCHIPELAGO_CAVE_1F, 2 ; stairs up
	warp_event 4, 7, ARCHIPELAGO_CAVE_3F, 1 ; stairs down to the grotto

	def_bg_events
	bg_event  7, 3, TEXT_ARCHIPELAGOCAVE2F_SIGN

	def_object_events

	def_warps_to ARCHIPELAGO_CAVE_2F
