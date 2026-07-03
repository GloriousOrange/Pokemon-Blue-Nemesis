	object_const_def

BattleIslandGate_Object:
	db $17 ; border block

	def_warp_events
	warp_event  2,  1, BATTLE_ISLAND, 2       ; top door: teleport to Battle Island (arrive at BI warp 2)
	warp_event  3,  1, BATTLE_ISLAND, 2
	warp_event  2,  7, POKEMON_MANSION_B1F, 2 ; bottom stairs: back up to the Mansion B1F staircase (warp 2)
	warp_event  3,  7, POKEMON_MANSION_B1F, 2

	def_bg_events

	def_object_events

	def_warps_to BATTLE_ISLAND_GATE
