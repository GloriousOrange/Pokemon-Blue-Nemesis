	object_const_def
	const_export APEXMART1F_SCIENTIST

ApexMart1F_Object:
	db $f ; border block

	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event 16,  7, LAST_MAP, 1
	warp_event 17,  7, LAST_MAP, 1
	warp_event 12,  1, APEX_MART_2F, 1
	warp_event  1,  1, APEX_MART_ELEVATOR, 1

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_SCIENTIST, STAY, DOWN, TEXT_APEXMART1F_SCIENTIST, OPP_SCIENTIST, 14 ; behind the counter, like a clerk

	def_warps_to APEX_MART_1F
