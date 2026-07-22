	object_const_def
	const_export APEXMART5F_SCIENTIST

ApexMart5F_Object:
	db $f ; border block

	def_warp_events
	warp_event 12,  1, APEX_MART_ROOF, 1
	warp_event 16,  1, APEX_MART_4F, 2
	warp_event  1,  1, APEX_MART_ELEVATOR, 1

	def_bg_events

	def_object_events
	object_event  5,  3, SPRITE_SCIENTIST, STAY, DOWN, TEXT_APEXMART5F_SCIENTIST ; behind the counter, like a clerk

	def_warps_to APEX_MART_5F
