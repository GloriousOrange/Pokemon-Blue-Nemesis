	object_const_def

ApexIsle_Object:
	db $43 ; border block (water)

	def_warp_events
	warp_event  8,  5, APEX_MART_1F, 1 ; OAK's EMPORIUM door (the $3a door block at map block 4,2); the ferry lands the player just below at (8,7)

	def_bg_events
	bg_event 12,  5, TEXT_APEXISLE_SIGN

	def_object_events

	def_warps_to APEX_ISLE
