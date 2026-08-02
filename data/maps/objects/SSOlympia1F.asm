	object_const_def
	const_export SSOLYMPIA1F_WAITER
	const_export SSOLYMPIA1F_SAILOR
	const_export SSOLYMPIA1F_BROCK
	const_export SSOLYMPIA1F_MISTY

SSOlympia1F_Object:
	db $c ; border block

	def_warp_events
	warp_event 26,  0, VERMILION_DOCK, 2
	warp_event 27,  0, VERMILION_DOCK, 2
	warp_event 31,  8, SS_OLYMPIA_1F_ROOMS, 1
	warp_event 23,  8, SS_OLYMPIA_1F_ROOMS, 2
	warp_event 19,  8, SS_OLYMPIA_1F_ROOMS, 3
	warp_event 15,  8, SS_OLYMPIA_1F_ROOMS, 4
	warp_event 11,  8, SS_OLYMPIA_1F_ROOMS, 5
	warp_event  7,  8, SS_OLYMPIA_1F_ROOMS, 6
	warp_event  2,  6, SS_OLYMPIA_2F, 7
	warp_event 37, 15, SS_OLYMPIA_B1F, 6
	warp_event  3, 16, SS_OLYMPIA_KITCHEN, 1

	def_bg_events

	def_object_events
	object_event 12,  6, SPRITE_WAITER, WALK, LEFT_RIGHT, TEXT_SSOLYMPIA1F_WAITER
	object_event 27,  5, SPRITE_SAILOR, STAY, NONE, TEXT_SSOLYMPIA1F_SAILOR
	object_event 18,  5, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_SSOLYMPIA1F_BROCK, OPP_BROCK, 3
	object_event  9,  6, SPRITE_BRUNETTE_GIRL, STAY, DOWN, TEXT_SSOLYMPIA1F_MISTY, OPP_MISTY, 3

	def_warps_to SS_OLYMPIA_1F
