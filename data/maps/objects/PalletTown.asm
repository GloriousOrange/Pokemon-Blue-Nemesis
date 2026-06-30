	object_const_def
	const_export PALLETTOWN_OAK
	const_export PALLETTOWN_GIRL
	const_export PALLETTOWN_FISHER
	const_export PALLETTOWN_BIRD1 ; speed-test: Zapdos keeper
	const_export PALLETTOWN_BIRD2 ; speed-test: Articuno keeper
	const_export PALLETTOWN_BIRD3 ; speed-test: Moltres keeper
	const_export PALLETTOWN_MACHINE ; speed-test: level-up machine operator

PalletTown_Object:
	db $b ; border block

	def_warp_events
	warp_event  5,  5, REDS_HOUSE_1F, 1
	warp_event 13,  5, BLUES_HOUSE, 1
	warp_event 12, 11, OAKS_LAB, 2

	def_bg_events
	bg_event 13, 13, TEXT_PALLETTOWN_OAKSLAB_SIGN
	bg_event  7,  9, TEXT_PALLETTOWN_SIGN
	bg_event  3,  5, TEXT_PALLETTOWN_PLAYERSHOUSE_SIGN
	bg_event 11,  5, TEXT_PALLETTOWN_RIVALSHOUSE_SIGN

	def_object_events
	object_event  8,  5, SPRITE_OAK, STAY, NONE, TEXT_PALLETTOWN_OAK
	object_event  3,  8, SPRITE_GIRL, WALK, ANY_DIR, TEXT_PALLETTOWN_GIRL
	object_event 11, 14, SPRITE_FISHER, WALK, ANY_DIR, TEXT_PALLETTOWN_FISHER
	object_event  4, 10, SPRITE_ROCKER, STAY, DOWN, TEXT_PALLETTOWN_BIRD1 ; Zapdos keeper (verify walkable)
	object_event  6, 10, SPRITE_HIKER, STAY, DOWN, TEXT_PALLETTOWN_BIRD2 ; Articuno keeper (verify walkable)
	object_event  8, 10, SPRITE_SUPER_NERD, STAY, DOWN, TEXT_PALLETTOWN_BIRD3 ; Moltres keeper (verify walkable)
	object_event 10, 10, SPRITE_SCIENTIST, STAY, DOWN, TEXT_PALLETTOWN_MACHINE ; level-machine (verify walkable)

	def_warps_to PALLET_TOWN
