	object_const_def

ArchipelagoCave1F_Object:
	db $19 ; border block (cave wall/floor)

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
