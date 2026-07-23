	object_const_def
	const_export BATTLEISLAND_GATEKEEPER
	const_export BATTLEISLAND_SCIENTIST0
	const_export BATTLEISLAND_SCIENTIST1
	const_export BATTLEISLAND_SCIENTIST2
	const_export BATTLEISLAND_SCIENTIST3
	const_export BATTLEISLAND_SCIENTIST4
	const_export BATTLEISLAND_SCIENTIST5
	const_export BATTLEISLAND_OAK

BattleIsland_Object:
	db $43 ; border block (water)

	def_warp_events
	warp_event  9,  3, BATTLE_ISLAND_HOUSE, 1 ; door of the north-edge house (drawn in the .blk: roof $38 $39 / body $3C $3D, same blocks as the Pallet houses)
	warp_event  8,  6, BATTLE_ISLAND_GATE, 1 ; arrival point when teleporting in from the Cinnabar lab gate (plain grass = won't auto-retrigger; leave via Fly)

	def_bg_events
	bg_event  7,  3, TEXT_BATTLEISLAND_SIGN ; signpost block ($08) beside the house door

	def_object_events
	object_event  5,  4, SPRITE_COOLTRAINER_M, STAY, DOWN, TEXT_BATTLEISLAND_GATEKEEPER
	object_event  3,  6, SPRITE_GAMBLER, STAY, DOWN, TEXT_BATTLEISLAND_SCIENTIST0
	object_event  5,  8, SPRITE_GAMBLER, STAY, DOWN, TEXT_BATTLEISLAND_SCIENTIST1
	object_event 11,  8, SPRITE_GAMBLER, STAY, DOWN, TEXT_BATTLEISLAND_SCIENTIST2
	object_event 13,  6, SPRITE_GAMBLER, STAY, DOWN, TEXT_BATTLEISLAND_SCIENTIST3
	object_event  4, 10, SPRITE_GAMBLER, STAY, DOWN, TEXT_BATTLEISLAND_SCIENTIST4
	object_event 12, 10, SPRITE_GAMBLER, STAY, DOWN, TEXT_BATTLEISLAND_SCIENTIST5
	object_event  9, 14, SPRITE_GAMBLER, STAY, UP, TEXT_BATTLEISLAND_OAK ; PROF. OAK, south end of the island (SPRITE_GAMBLER placeholder -- OAK's sprite isn't in this map's set)

	def_warps_to BATTLE_ISLAND
