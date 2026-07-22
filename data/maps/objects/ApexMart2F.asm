	object_const_def
	const_export APEXMART2F_SCIENTIST

ApexMart2F_Object:
	db $f ; border block

	def_warp_events
	warp_event 12,  1, APEX_MART_1F, 5
	warp_event 16,  1, APEX_MART_3F, 2
	warp_event  1,  1, APEX_MART_ELEVATOR, 1

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_SCIENTIST, STAY, DOWN, TEXT_APEXMART2F_SCIENTIST

	def_warps_to APEX_MART_2F
