	object_const_def

ArchipelagoCave1F_Object:
; Was $19 -- the SAME tile as the walkable interior floor. The border block
; is what renders (and collides) beyond the map's real edges; sharing it with
; the floor meant nothing stopped the player walking past the true boundary,
; and once far enough past it (beyond the MAP_BORDER=3-block padding the
; engine reserves) the tile-streaming/scroll pointer runs off the padded
; wOverworldMap region into stale memory, showing up as screen-corrupting
; garbage while walking. $3 (all tile $3C, genuinely solid -- not in
; Cavern_Coll) is the real block Mt Moon uses for exactly this purpose.
	db $3 ; border block (solid rock)

; The whole floor was one uniform featureless block ($19 everywhere) with
; zero landmarks anywhere, including at the warps themselves -- a real player
; genuinely could not tell where the exit was. Both warp cells below now sit
; one block west of a $3C "stairs icon on the same floor tile" block (the
; same real Mt Moon pattern: the icon block is placed ADJACENT to the warp's
; walkable floor cell, not on top of it -- the icon's own tiles aren't in
; Cavern_Coll's walkable list, only the plain-floor half of that block is).
	def_warp_events
	warp_event 4, 1, MIASMA_ISLE, 1 ; entrance back to the surface (MiasmaIsle's cave-mouth warp); icon at block(2,0)
	warp_event 4, 7, ARCHIPELAGO_CAVE_2F, 1 ; stairs down; icon at block(2,3)

	def_bg_events

	def_object_events

	def_warps_to ARCHIPELAGO_CAVE_1F
