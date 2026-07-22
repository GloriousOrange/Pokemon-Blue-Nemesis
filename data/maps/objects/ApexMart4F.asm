	object_const_def
	const_export APEXMART4F_SCIENTIST

ApexMart4F_Object:
	db $f ; border block

	def_warp_events
	warp_event 12,  1, APEX_MART_3F, 1
	warp_event 16,  1, APEX_MART_5F, 2
	warp_event  1,  1, APEX_MART_ELEVATOR, 1

	def_bg_events

	def_object_events
	object_event  5,  7, SPRITE_SCIENTIST, STAY, DOWN, TEXT_APEXMART4F_SCIENTIST, OPP_SCIENTIST, 17

	def_warps_to APEX_MART_4F
