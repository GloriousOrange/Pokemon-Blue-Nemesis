	object_const_def

ArchipelagoCave1F_Object:
	db $19 ; border block (cave wall/floor)

	def_warp_events
	warp_event 4, 1, MIASMA_ISLE, 1 ; entrance back to the surface (MiasmaIsle's cave-mouth warp)
	warp_event 4, 7, ARCHIPELAGO_CAVE_2F, 1 ; stairs down

	def_bg_events
	bg_event  7, 3, TEXT_ARCHIPELAGOCAVE1F_SIGN

	def_object_events

	def_warps_to ARCHIPELAGO_CAVE_1F
