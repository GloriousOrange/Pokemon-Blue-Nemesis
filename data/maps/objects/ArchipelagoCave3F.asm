	object_const_def
	const_export ARCHIPELAGOCAVE3F_OAK ; unused now (see below) -- kept only because
	; data/maps/toggleable_objects.asm's `toggle_object_state ARCHIPELAGOCAVE3F_OAK`
	; entry must stay (global toggle indices are saved; removing one renumbers
	; every later index and breaks existing saves), and that macro needs this
	; name defined even with no matching object_event.

ArchipelagoCave3F_Object:
	db $19 ; border block (cave wall/floor)

; see ArchipelagoCave1F.asm's comment -- the warp cell sits one block west
; of a $3C stairs-icon block (adjacent to, not on, the warp's floor cell).
	def_warp_events
	warp_event 4, 1, ARCHIPELAGO_CAVE_2F, 2 ; stairs up; icon at block(2,0)

	def_bg_events

	def_object_events
; OAK used to fight here (dead design, see scripts/BattleIsland.asm -- he's an
; NPC on Battle Island's south grass now). TOGGLE_ARCHIPELAGO_CAVE_3F_OAK stays
; defined in constants/toggle_constants.asm and parked unused rather than
; removed: toggle indices are global and saved, so deleting one renumbers
; every later index and breaks existing saves.

	def_warps_to ARCHIPELAGO_CAVE_3F
