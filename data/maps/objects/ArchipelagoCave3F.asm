	object_const_def
	const_export ARCHIPELAGOCAVE3F_OAK ; unused now (see below) -- kept only because
	; data/maps/toggleable_objects.asm's `toggle_object_state ARCHIPELAGOCAVE3F_OAK`
	; entry must stay (global toggle indices are saved; removing one renumbers
	; every later index and breaks existing saves), and that macro needs this
	; name defined even with no matching object_event.

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
; OAK used to fight here (dead design, see scripts/BattleIsland.asm -- he's an
; NPC on Battle Island's south grass now). TOGGLE_ARCHIPELAGO_CAVE_3F_OAK stays
; defined in constants/toggle_constants.asm and parked unused rather than
; removed: toggle indices are global and saved, so deleting one renumbers
; every later index and breaks existing saves.

	def_warps_to ARCHIPELAGO_CAVE_3F
