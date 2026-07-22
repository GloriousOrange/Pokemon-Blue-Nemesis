	object_const_def
	const_export APEXMART3F_SCIENTIST

ApexMart3F_Object:
	db $f ; border block

	def_warp_events
	warp_event 12,  1, APEX_MART_4F, 1
	warp_event 16,  1, APEX_MART_2F, 2
	warp_event  1,  1, APEX_MART_ELEVATOR, 1

	def_bg_events

	def_object_events
	object_event 16,  5, SPRITE_SCIENTIST, STAY, DOWN, TEXT_APEXMART3F_SCIENTIST, OPP_SCIENTIST, 16

	def_warps_to APEX_MART_3F
