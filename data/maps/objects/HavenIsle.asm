	object_const_def

HavenIsle_Object:
	db $43 ; border block (water)

	def_warp_events

	def_bg_events
	bg_event 11, 3, TEXT_HAVENISLE_SIGN

	def_object_events

	def_warps_to HAVEN_ISLE
