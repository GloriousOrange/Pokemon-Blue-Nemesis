	object_const_def
	const_export VERMILIONDOCK_OLYMPIA_GUARD

VermilionDock_Object:
	db $f ; border block

	def_warp_events
	warp_event 14,  0, LAST_MAP, 6
	warp_event 14,  2, SS_ANNE_1F, 2
	warp_event 14,  3, SS_OLYMPIA_1F, 1 ; S.S. Olympia's own dock berth, opens post-Champion (guard blocks it until then)

	def_bg_events

	def_object_events
	object_event 14,  3, SPRITE_GENTLEMAN, STAY, LEFT, TEXT_VERMILIONDOCK_OLYMPIA_GUARD

	def_warps_to VERMILION_DOCK
