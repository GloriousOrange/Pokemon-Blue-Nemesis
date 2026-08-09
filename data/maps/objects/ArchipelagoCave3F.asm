	object_const_def
	const_export ARCHIPELAGOCAVE3F_OAK
	const_export ARCHIPELAGOCAVE3F_MUTAGEN_VIAL

ArchipelagoCave3F_Object:
; see ArchipelagoCave1F.asm's comment -- was $19 (walkable, same as the
; floor), letting the player walk past the map's real edge into the
; tile-streaming padding and corrupt the screen. $3 is genuinely solid.
	db $3 ; border block (solid rock)

; see ArchipelagoCave1F.asm's comment -- the warp cell sits ON a $3C
; stairs-icon's recognized/walkable lower-left tile ($18), not on the
; plain floor cell next to it (which never reliably triggers the warp).
	def_warp_events
	warp_event 5, 1, ARCHIPELAGO_CAVE_2F, 2 ; stairs up; ON the stairs icon, block(2,0)

	def_bg_events

	def_object_events
	object_event 10, 9, SPRITE_OAK, STAY, DOWN, TEXT_ARCHIPELAGOCAVE3F_OAK, OPP_PROF_OAK, 4 ; hidden until the roof scientist is beaten (TOGGLE_ARCHIPELAGO_CAVE_3F_OAK); stands at the water's edge
; On the lake islet (block col 5, row 6), which is tile $20 -- landable from
; the water but sealed off from the $05 floor by the CAVERN $20/$05 pair
; collision, so this can only be reached by SURFing out to it.
	object_event 10, 12, SPRITE_POKE_BALL, STAY, NONE, TEXT_ARCHIPELAGOCAVE3F_MUTAGEN_VIAL, MUTAGEN_VIAL

	def_warps_to ARCHIPELAGO_CAVE_3F
