	object_const_def
	const_export SSOLYMPIABOW_SUPER_NERD
	const_export SSOLYMPIABOW_ROCKET1
	const_export SSOLYMPIABOW_ROCKET2
	const_export SSOLYMPIABOW_BIRD
	const_export SSOLYMPIABOW_RIVAL

SSOlympiaBow_Object:
	db $23 ; border block

	def_warp_events
	warp_event 13,  6, SS_OLYMPIA_3F, 1
	warp_event 13,  7, SS_OLYMPIA_3F, 1

	def_bg_events

	def_object_events
	object_event  5,  2, SPRITE_SUPER_NERD, STAY, UP, TEXT_SSOLYMPIABOW_SUPER_NERD
	object_event  4,  4, SPRITE_ROCKET, STAY, DOWN, TEXT_SSOLYMPIABOW_ROCKET1, OPP_ROCKET, 50
	object_event 10,  8, SPRITE_ROCKET, STAY, UP, TEXT_SSOLYMPIABOW_ROCKET2, OPP_ROCKET, 51
	object_event  6,  3, SPRITE_BIRD, STAY, DOWN, TEXT_SSOLYMPIABOW_RIVAL
	object_event  6,  3, SPRITE_BLUE, STAY, DOWN, TEXT_SSOLYMPIABOW_RIVAL

	def_warps_to SS_OLYMPIA_BOW
