	object_const_def

MiasmaIsle_Object:
	db $43 ; border block (water)

	def_warp_events
	warp_event 4, 3, ARCHIPELAGO_CAVE_1F, 1 ; cave mouth doorway cell (bottom-left quadrant of the visible $06 block -- the only walkable cell in it, same relative offset as Route4's real Mt Moon 1F entrance), well clear of the interior lake at rows8-11

	def_bg_events

	def_object_events

	def_warps_to MIASMA_ISLE
