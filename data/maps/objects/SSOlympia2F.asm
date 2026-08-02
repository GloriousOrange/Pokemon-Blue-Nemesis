	object_const_def
	const_export SSOLYMPIA2F_WAITER
	const_export SSOLYMPIA2F_SABRINA
	const_export SSOLYMPIA2F_BLAINE

SSOlympia2F_Object:
	db $c ; border block

	def_warp_events
	warp_event  9, 11, SS_OLYMPIA_2F_ROOMS, 1
	warp_event 13, 11, SS_OLYMPIA_2F_ROOMS, 3
	warp_event 17, 11, SS_OLYMPIA_2F_ROOMS, 5
	warp_event 21, 11, SS_OLYMPIA_2F_ROOMS, 7
	warp_event 25, 11, SS_OLYMPIA_2F_ROOMS, 9
	warp_event 29, 11, SS_OLYMPIA_2F_ROOMS, 11
	warp_event  2,  4, SS_OLYMPIA_1F, 9
	warp_event  2, 12, SS_OLYMPIA_3F, 2
	warp_event 36,  4, SS_OLYMPIA_CAPTAINS_ROOM, 1

	def_bg_events

	def_object_events
	object_event  3,  7, SPRITE_WAITER, WALK, UP_DOWN, TEXT_SSOLYMPIA2F_WAITER
	object_event 12,  5, SPRITE_GIRL, STAY, DOWN, TEXT_SSOLYMPIA2F_SABRINA, OPP_SABRINA, 3
	object_event 24,  5, SPRITE_MIDDLE_AGED_MAN, STAY, DOWN, TEXT_SSOLYMPIA2F_BLAINE, OPP_BLAINE, 3

	def_warps_to SS_OLYMPIA_2F
