	object_const_def

MiasmaIsle_Object:
	db $43 ; border block (water)

	def_warp_events
	warp_event 5, 2, ARCHIPELAGO_CAVE_1F, 1 ; cave mouth (visible $06 block in the .blk), on dry grass, well clear of the interior lake at rows8-11

	def_bg_events

	def_object_events

	def_warps_to MIASMA_ISLE
