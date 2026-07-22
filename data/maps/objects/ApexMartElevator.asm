ApexMartElevator_Object:
	db $f ; border block

	def_warp_events
	warp_event  1,  3, APEX_MART_1F, 6
	warp_event  2,  3, APEX_MART_1F, 6

	def_bg_events
	bg_event  3,  0, TEXT_APEXMARTELEVATOR

	def_object_events

	def_warps_to APEX_MART_ELEVATOR
