	object_const_def
	const_export ARCHIPELAGOCAVE3F_OAK

ArchipelagoCave3F_Object:
	db $19 ; border block (cave wall/floor)

	def_warp_events
	warp_event 4, 1, ARCHIPELAGO_CAVE_2F, 2 ; stairs up

	def_bg_events

	def_object_events
	object_event 10, 9, SPRITE_OAK, STAY, DOWN, TEXT_ARCHIPELAGOCAVE3F_OAK ; hidden until the roof machine is used; stands at the water's edge

	def_warps_to ARCHIPELAGO_CAVE_3F
