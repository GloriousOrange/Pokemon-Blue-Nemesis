	object_const_def
	const_export DIGLETTSCAVE_MEGAN

DiglettsCave_Object:
	db $19 ; border block

	def_warp_events
	warp_event  5,  5, DIGLETTS_CAVE_ROUTE_2, 3
	warp_event 37, 31, DIGLETTS_CAVE_ROUTE_11, 3

	def_bg_events

	def_object_events
	object_event 20, 17, SPRITE_GIRL, STAY, DOWN, TEXT_DIGLETTSCAVE_MEGAN ; girlfriend Megan (collision-verified)

	def_warps_to DIGLETTS_CAVE
