	object_const_def
	const_export BATTLEISLANDHOUSE_NURSE

BattleIslandHouse_Object:
	db $a ; border block

; Interior layout is a copy of BluesHouse.blk (HOUSE tileset), so all
; positions below match its proven geometry: door mats at (2,7)/(3,7),
; table at (2..5, 2..3), bookshelves along the top wall.
	def_warp_events
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1

	def_bg_events
	bg_event  6,  1, TEXT_BATTLEISLANDHOUSE_PC ; on the top-wall shelf, read facing up from (6,2)

	def_object_events
	object_event  2,  3, SPRITE_GIRL, STAY, RIGHT, TEXT_BATTLEISLANDHOUSE_NURSE ; MEGAN (heal point), seated at the table like Daisy in BluesHouse

	def_warps_to BATTLE_ISLAND_HOUSE
