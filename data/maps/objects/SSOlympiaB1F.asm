	object_const_def
	const_export SSOLYMPIAB1F_DETECTIVE
	const_export SSOLYMPIAB1F_AGATHA
	const_export SSOLYMPIAB1F_LANCE
	const_export SSOLYMPIAB1F_HIKER
	const_export SSOLYMPIAB1F_BURGLAR

SSOlympiaB1F_Object:
	db $c ; border block

	def_warp_events
	warp_event 23,  3, SS_OLYMPIA_B1F_ROOMS, 9
	warp_event 19,  3, SS_OLYMPIA_B1F_ROOMS, 7
	warp_event 15,  3, SS_OLYMPIA_B1F_ROOMS, 5
	warp_event 11,  3, SS_OLYMPIA_B1F_ROOMS, 3
	warp_event  7,  3, SS_OLYMPIA_B1F_ROOMS, 1
	warp_event 27,  5, SS_OLYMPIA_1F, 10

	def_bg_events

	def_object_events
	object_event  5,  4, SPRITE_GENTLEMAN, STAY, DOWN, TEXT_SSOLYMPIAB1F_DETECTIVE
	object_event 10,  3, SPRITE_AGATHA, STAY, DOWN, TEXT_SSOLYMPIAB1F_AGATHA, OPP_AGATHA, 2
	object_event 20,  4, SPRITE_LANCE, STAY, DOWN, TEXT_SSOLYMPIAB1F_LANCE, OPP_LANCE, 2
	object_event  2,  4, SPRITE_HIKER, STAY, DOWN, TEXT_SSOLYMPIAB1F_HIKER, OPP_HIKER, 17
	object_event 25,  5, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_SSOLYMPIAB1F_BURGLAR, OPP_BURGLAR, 11

	def_warps_to SS_OLYMPIA_B1F
