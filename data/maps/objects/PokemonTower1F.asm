	object_const_def
	const_export POKEMONTOWER1F_RECEPTIONIST
	const_export POKEMONTOWER1F_MIDDLE_AGED_WOMAN
	const_export POKEMONTOWER1F_BALDING_GUY
	const_export POKEMONTOWER1F_GIRL
	const_export POKEMONTOWER1F_CHANNELER
	const_export POKEMONTOWER1F_SCIENTIST_GUARD
	const_export POKEMONTOWER1F_ROCKET_GUARD

PokemonTower1F_Object:
	db $1 ; border block

	def_warp_events
	warp_event 10, 17, LAST_MAP, 2
	warp_event 11, 17, LAST_MAP, 2
	warp_event 18,  9, POKEMON_TOWER_2F, 2

	def_bg_events

	def_object_events
	object_event 15, 13, SPRITE_LINK_RECEPTIONIST, STAY, UP, TEXT_POKEMONTOWER1F_RECEPTIONIST
	object_event  6,  8, SPRITE_MIDDLE_AGED_WOMAN, STAY, NONE, TEXT_POKEMONTOWER1F_MIDDLE_AGED_WOMAN
	object_event  8, 12, SPRITE_BALDING_GUY, STAY, NONE, TEXT_POKEMONTOWER1F_BALDING_GUY
	object_event 13,  7, SPRITE_GIRL, STAY, NONE, TEXT_POKEMONTOWER1F_GIRL
	object_event 17,  7, SPRITE_CHANNELER, STAY, LEFT, TEXT_POKEMONTOWER1F_CHANNELER
; Opposing-faction guard blocking the stairs at (18,9) -- only one of these
; two is ever shown at a time (see PokemonTower1F_Script). Loyalist path:
; Scientist blocks; Hero path: Rocket blocks. Both hide once
; EVENT_GIOVANNI_SENT_TO_TOWER is set.
	object_event 18,  9, SPRITE_SCIENTIST, STAY, DOWN, TEXT_POKEMONTOWER1F_SCIENTIST_GUARD
	object_event 18,  9, SPRITE_ROCKET, STAY, DOWN, TEXT_POKEMONTOWER1F_ROCKET_GUARD

	def_warps_to POKEMON_TOWER_1F
