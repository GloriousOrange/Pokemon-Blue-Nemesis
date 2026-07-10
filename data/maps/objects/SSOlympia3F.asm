	object_const_def
	const_export SSOLYMPIA3F_SAILOR
	const_export SSOLYMPIA3F_ROCKET1

SSOlympia3F_Object:
	db $c ; border block

	def_warp_events
	warp_event  0,  3, SS_OLYMPIA_BOW, 1
	warp_event 19,  3, SS_OLYMPIA_2F, 8

	def_bg_events

	def_object_events
	object_event  9,  3, SPRITE_SAILOR, WALK, LEFT_RIGHT, TEXT_SSOLYMPIA3F_SAILOR
	object_event 14,  3, SPRITE_ROCKET, STAY, LEFT, TEXT_SSOLYMPIA3F_ROCKET1, OPP_ROCKET, 47

	def_warps_to SS_OLYMPIA_3F
