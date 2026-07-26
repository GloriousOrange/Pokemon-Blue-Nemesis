	object_const_def
	const_export ROUTE1_YOUNGSTER1
	const_export ROUTE1_YOUNGSTER2
	const_export ROUTE1_MEGAN

Route1_Object:
	db $b ; border block

	def_warp_events

	def_bg_events
	bg_event  9, 27, TEXT_ROUTE1_SIGN

	def_object_events
	object_event  5, 24, SPRITE_YOUNGSTER, WALK, UP_DOWN, TEXT_ROUTE1_YOUNGSTER1
	object_event 15, 13, SPRITE_YOUNGSTER, WALK, LEFT_RIGHT, TEXT_ROUTE1_YOUNGSTER2
	object_event 11, 33, SPRITE_GIRL, STAY, LEFT, TEXT_ROUTE1_MEGAN, OPP_MEGAN, 1 ; Megan: sees you crossing the first patch of grass out of Pallet

	def_warps_to ROUTE_1

	; unused
	warp_to 2, 7, 4
