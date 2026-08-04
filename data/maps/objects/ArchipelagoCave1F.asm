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
; zero landmarks anywhere, including at the warps themselves. Fixed by
; dropping a $3C "stairs icon" block at each warp -- and the warp cells
; below sit ON the icon's own lower half (cell x=5, not the plain-floor
; cell x=4 next to it), not adjacent to it.
;
; This matters mechanically, not just visually: engine/overworld/doors.asm's
; IsPlayerStandingOnDoorTile reads the tile at a FIXED screen position
; documented in its own comment as "lower left background tile under
; player's sprite" -- i.e. always the bottom-left 8x8 tile of whichever 2x2
; cell the player is standing on, regardless of approach direction. $3C's
; icon cell has tile $08/$09 on top and $18/$19 on the bottom -- $18 is in
; BOTH Cavern_Coll (walkable) and .CavernWarpTileIDs (recognized instantly,
; no ExtraWarpCheck/held-direction fallback needed). Landing the warp
; exactly there is what makes it trigger reliably; sitting on the plain
; floor cell next to it (tile $05, in neither list) is why the original
; placement compiled fine and looked right but silently never fired --
; confirmed by direct testing that Mt Moon's own real interior stairs sit
; on the SAME kind of plain-floor cell and rely on a fallback path
; (ExtraWarpCheck's IsPlayerFacingEdgeOfMap) that never actually applies to
; a mid-map stairway; landing directly on a recognized tile sidesteps that
; fallback's real mechanism entirely rather than depending on it.
	def_warp_events
	warp_event 5, 1, MIASMA_ISLE, 1 ; entrance back to the surface (MiasmaIsle's cave-mouth warp); ON the stairs icon, block(2,0)
	warp_event 5, 7, ARCHIPELAGO_CAVE_2F, 1 ; stairs down; ON the stairs icon, block(2,3)

	def_bg_events

	def_object_events

	def_warps_to ARCHIPELAGO_CAVE_1F
