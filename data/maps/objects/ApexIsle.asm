	object_const_def

ApexIsle_Object:
	db $43 ; border block (water)

	def_warp_events
	warp_event  8,  3, APEX_MART_1F, 1 ; OAK's EMPORIUM entrance mat (north grass); the ferry lands the player just below at (8,5)

	def_bg_events
	bg_event 10,  5, TEXT_APEXISLE_SIGN

	def_object_events

	def_warps_to APEX_ISLE
