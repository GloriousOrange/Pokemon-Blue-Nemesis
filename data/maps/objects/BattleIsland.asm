	object_const_def
	const_export BATTLEISLAND_GATEKEEPER

BattleIsland_Object:
	db $43 ; border block (water)

	def_warp_events
	warp_event  9,  3, BATTLE_ISLAND_HOUSE, 1

	def_bg_events
	bg_event  9,  2, TEXT_BATTLEISLAND_SIGN

	def_object_events
	object_event  5,  4, SPRITE_COOLTRAINER_M, STAY, DOWN, TEXT_BATTLEISLAND_GATEKEEPER

	def_warps_to BATTLE_ISLAND
