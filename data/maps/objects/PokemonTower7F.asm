	object_const_def
	const_export POKEMONTOWER7F_CHANNELER1
	const_export POKEMONTOWER7F_CHANNELER2
	const_export POKEMONTOWER7F_CHANNELER3
	const_export POKEMONTOWER7F_MR_FUJI

PokemonTower7F_Object:
	db $1 ; border block

	def_warp_events
	warp_event  9, 16, POKEMON_TOWER_6F, 2

	def_bg_events

	def_object_events
; Channelers on every path (formerly Rockets) -- mediums keeping vigil over
; Fuji's floor. Parties reuse the existing L33-38 Saffron Gym Channeler sets,
; which fit the tower's post-Silph position in this mod's progression.
	object_event  9, 11, SPRITE_CHANNELER, STAY, RIGHT, TEXT_POKEMONTOWER7F_CHANNELER1, OPP_CHANNELER, 22
	object_event 12,  9, SPRITE_CHANNELER, STAY, LEFT, TEXT_POKEMONTOWER7F_CHANNELER2, OPP_CHANNELER, 23
	object_event  9,  7, SPRITE_CHANNELER, STAY, RIGHT, TEXT_POKEMONTOWER7F_CHANNELER3, OPP_CHANNELER, 24
	object_event 10,  3, SPRITE_MR_FUJI, STAY, DOWN, TEXT_POKEMONTOWER7F_MR_FUJI

	def_warps_to POKEMON_TOWER_7F
