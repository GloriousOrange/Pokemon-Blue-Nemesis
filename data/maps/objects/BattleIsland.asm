	object_const_def
	const_export BATTLEISLAND_GATEKEEPER
	const_export BATTLEISLAND_STATUE1
	const_export BATTLEISLAND_STATUE2
	const_export BATTLEISLAND_BOULDER1
	const_export BATTLEISLAND_BOULDER2
	const_export BATTLEISLAND_BOULDER3
	const_export BATTLEISLAND_BOULDER4
	const_export BATTLEISLAND_BOULDER5
	const_export BATTLEISLAND_BOULDER6
	const_export BATTLEISLAND_BOULDER7
	const_export BATTLEISLAND_BOULDER8
	const_export BATTLEISLAND_BOULDER9
	const_export BATTLEISLAND_BOULDER10
	const_export BATTLEISLAND_BOULDER11

BattleIsland_Object:
	db $43 ; border block (water)

	def_warp_events
	warp_event  9,  3, BATTLE_ISLAND_HOUSE, 1 ; door of the north-edge house (drawn in the .blk: roof $38 $39 / body $3C $3D, same blocks as the Pallet houses)
	warp_event  8,  6, BATTLE_ISLAND_GATE, 1 ; arrival point when teleporting in from the Cinnabar lab gate (plain grass = won't auto-retrigger; leave via Fly)

	def_bg_events
	bg_event  7,  3, TEXT_BATTLEISLAND_SIGN ; signpost block ($08) beside the house door

	def_object_events
	object_event  5,  4, SPRITE_COOLTRAINER_M, STAY, DOWN, TEXT_BATTLEISLAND_GATEKEEPER
; Arena dressing: object sprites, not background tiles, so they're safe on
; any tileset (SPRITE_BOULDER/SPRITE_MONSTER are the same portable trick
; vanilla uses for the Seafoam push-boulders). Statues flank the gatekeeper;
; boulders form a backdrop wall (row 2, behind him) and side walls (cols 2
; and 8, rows 3-5), leaving the south side open as the approach. Movement
; byte is DOWN/NONE (not BOULDER_MOVEMENT_BYTE_2), so these never engage the
; Strength push logic -- pure scenery.
	object_event  3,  4, SPRITE_MONSTER, STAY, DOWN, TEXT_BATTLEISLAND_STATUE1
	object_event  7,  4, SPRITE_MONSTER, STAY, DOWN, TEXT_BATTLEISLAND_STATUE2
	object_event  3,  2, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER1
	object_event  4,  2, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER2
	object_event  5,  2, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER3
	object_event  6,  2, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER4
	object_event  7,  2, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER5
	object_event  2,  3, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER6
	object_event  2,  4, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER7
	object_event  2,  5, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER8
	object_event  8,  3, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER9
	object_event  8,  4, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER10
	object_event  8,  5, SPRITE_BOULDER, STAY, NONE, TEXT_BATTLEISLAND_BOULDER11

	def_warps_to BATTLE_ISLAND
