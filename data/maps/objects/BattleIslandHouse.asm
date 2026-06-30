	object_const_def
	const_export BATTLEISLANDHOUSE_NURSE

BattleIslandHouse_Object:
	db $a ; border block

	def_warp_events
	warp_event  3,  7, LAST_MAP, 1
	warp_event  4,  7, LAST_MAP, 1

	def_bg_events
	bg_event  6,  1, TEXT_BATTLEISLANDHOUSE_PC

	def_object_events
	object_event  4,  3, SPRITE_NURSE, STAY, DOWN, TEXT_BATTLEISLANDHOUSE_NURSE

	def_warps_to BATTLE_ISLAND_HOUSE
