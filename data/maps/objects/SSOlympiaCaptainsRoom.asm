	object_const_def
	const_export SSOLYMPIACAPTAINSROOM_ROCKET1

SSOlympiaCaptainsRoom_Object:
	db $c ; border block

	def_warp_events
	warp_event  0,  7, SS_OLYMPIA_2F, 9

	def_bg_events
	bg_event  4,  1, TEXT_SSOLYMPIACAPTAINSROOM_TRASH
	bg_event  1,  2, TEXT_SSOLYMPIACAPTAINSROOM_LOGBOOK

	def_object_events
	object_event  4,  2, SPRITE_ROCKET, STAY, UP, TEXT_SSOLYMPIACAPTAINSROOM_ROCKET1, OPP_ROCKET, 53

	def_warps_to SS_OLYMPIA_CAPTAINS_ROOM
