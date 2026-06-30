	object_const_def
	const_export MTMOONB1F_MEGAN

MtMoonB1F_Object:
	db $3 ; border block

	def_warp_events
	warp_event  5,  5, MT_MOON_1F, 3
	warp_event 17, 11, MT_MOON_B2F, 1
	warp_event 25,  9, MT_MOON_1F, 4
	warp_event 25, 15, MT_MOON_1F, 5
	warp_event 21, 17, MT_MOON_B2F, 2
	warp_event 13, 27, MT_MOON_B2F, 3
	warp_event 23,  3, MT_MOON_B2F, 4
	warp_event 27,  3, LAST_MAP, 3

	def_bg_events

	def_object_events
	object_event 17, 16, SPRITE_GIRL, STAY, DOWN, TEXT_MTMOONB1F_MEGAN ; girlfriend Megan (collision-verified)

	def_warps_to MT_MOON_B1F
