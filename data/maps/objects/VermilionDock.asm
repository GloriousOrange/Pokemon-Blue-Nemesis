	object_const_def
	const_export VERMILIONDOCK_OLYMPIA_GUARD

VermilionDock_Object:
	db $f ; border block

	def_warp_events
; Back to vanilla's two warps. The S.S. Olympia used to have its own berth warp
; at (14,3), which is why nobody could ever board her: (14,3) is a WALL in
; ship_port's collision, so the tile could never be stepped on. Both ships now
; share this one gangway and VermilionDockSetBerthScript repoints it.
;
; The gangway must also stay LAST -- VermilionDockSSAnneLeavesScript retires it
; with `dec [wNumberOfWarps]`, which only ever drops the final warp.
	warp_event 14,  0, LAST_MAP, 6
	warp_event 14,  2, SS_ANNE_1F, 2

	def_bg_events

	def_object_events
; (14,1) is the single-tile corridor between the dock entrance and the gangway,
; so standing here he genuinely blocks boarding. Shown only once the Champion is
; beaten and only while the party is the wrong size -- see
; VermilionDockCheckOlympiaGuard.
	object_event 14,  1, SPRITE_GENTLEMAN, STAY, DOWN, TEXT_VERMILIONDOCK_OLYMPIA_GUARD

	def_warps_to VERMILION_DOCK
