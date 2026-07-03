	object_const_def
	const_export SILPHCO9F_NURSE
	const_export SILPHCO9F_ROCKET1
	const_export SILPHCO9F_SCIENTIST
	const_export SILPHCO9F_ROCKET2
	const_export SILPHCO9F_FLAVOR_ROCKET
	const_export SILPHCO9F_FLAVOR_SCIENTIST

SilphCo9F_Object:
	db $2e ; border block

	def_warp_events
	warp_event 14,  0, SILPH_CO_10F, 1
	warp_event 16,  0, SILPH_CO_8F, 1
	warp_event 18,  0, SILPH_CO_ELEVATOR, 1
	warp_event  9,  3, SILPH_CO_3F, 8
	warp_event 17, 15, SILPH_CO_5F, 5

	def_bg_events

	def_object_events
	object_event  3, 14, SPRITE_NURSE, STAY, DOWN, TEXT_SILPHCO9F_NURSE
	object_event  2,  4, SPRITE_ROCKET, STAY, UP, TEXT_SILPHCO9F_ROCKET1, OPP_ROCKET, 37
	object_event 21, 13, SPRITE_SCIENTIST, STAY, DOWN, TEXT_SILPHCO9F_SCIENTIST, OPP_SCIENTIST, 10
	object_event 13, 16, SPRITE_ROCKET, STAY, UP, TEXT_SILPHCO9F_ROCKET2, OPP_ROCKET, 38
	object_event  5, 14, SPRITE_ROCKET, STAY, RIGHT, TEXT_SILPHCO9F_FLAVOR_ROCKET
	object_event  6, 14, SPRITE_SCIENTIST, STAY, LEFT, TEXT_SILPHCO9F_FLAVOR_SCIENTIST

	def_warps_to SILPH_CO_9F
