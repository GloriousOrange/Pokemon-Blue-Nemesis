	object_const_def
	const_export BATTLEISLANDHOUSE_NURSE

BattleIslandHouse_Object:
	db $0 ; border block

; Interior layout is a copy of PewterPokecenter.blk (POKECENTER tileset) --
; the vanilla PC console tile only exists in this tileset (confirmed
; identical across all 4 real Pokecenters), which HOUSE doesn't have. Its PC
; is a HIDDEN EVENT (data/events/hidden_events.asm), not a per-map bg_event
; -- every Pokecenter wires it that way, so this does too.
	def_warp_events
	warp_event  3,  7, LAST_MAP, 1
	warp_event  4,  7, LAST_MAP, 1

	def_bg_events

	def_object_events
	object_event  3,  1, SPRITE_GIRL, STAY, DOWN, TEXT_BATTLEISLANDHOUSE_NURSE ; MEGAN (heal point), at the counter like the Nurse in every Pokecenter

	def_warps_to BATTLE_ISLAND_HOUSE
