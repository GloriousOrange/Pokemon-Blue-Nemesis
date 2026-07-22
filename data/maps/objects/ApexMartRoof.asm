	object_const_def
	const_export APEXMARTROOF_SCIENTIST

ApexMartRoof_Object:
	db $42 ; border block

	def_warp_events
	warp_event 15,  2, APEX_MART_5F, 1

	def_bg_events

	def_object_events
	object_event 10,  4, SPRITE_SCIENTIST, STAY, DOWN, TEXT_APEXMARTROOF_SCIENTIST, OPP_SCIENTIST, 19

	def_warps_to APEX_MART_ROOF
