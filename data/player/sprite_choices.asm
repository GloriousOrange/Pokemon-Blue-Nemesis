; Nemesis: player-selectable overworld looks, picked via PickPlayerSprite at
; the start of a new game. Every entry here is a SPRITE_* id whose graphic is
; the full 24-tile (16x96) walk-animated format -- the reduced 12-tile
; (16x48) NPCs (Gramps, Nurse, etc.) never animate and would read as a
; garbled sprite if the player actually walked around in one, so they're
; excluded. Also excluded: SPRITE_ROCKET (you only get that by joining Team
; Rocket), the non-humanoid placeholder sprites (Monster/Bird/Fairy/Seel,
; reused overworld slots for wild-Pokemon/cutscene graphics, not people), the
; unused duplicate aliases (UNUSED_SCIENTIST etc.), SPRITE_MATHUS (still
; a work in progress, not ready to be a player skin yet), and SPRITE_SWIMMER,
; whose walk cycle is a swimming stroke -- fine in water, absurd everywhere
; else, since the player spends nearly all their time on solid ground.
DEF NUM_PLAYER_SPRITE_CHOICES EQU 34

PlayerSpriteChoices::
	table_width 1
	db SPRITE_RED
	db SPRITE_BLUE
	db SPRITE_OAK
	db SPRITE_YOUNGSTER
	db SPRITE_COOLTRAINER_F
	db SPRITE_COOLTRAINER_M
	db SPRITE_LITTLE_GIRL
	db SPRITE_MIDDLE_AGED_MAN
	db SPRITE_GAMBLER
	db SPRITE_SUPER_NERD
	db SPRITE_GIRL
	db SPRITE_HIKER
	db SPRITE_BEAUTY
	db SPRITE_GENTLEMAN
	db SPRITE_DAISY
	db SPRITE_BIKER
	db SPRITE_SAILOR
	db SPRITE_COOK
	db SPRITE_MR_FUJI
	db SPRITE_GIOVANNI
	db SPRITE_CHANNELER
	db SPRITE_WAITER
	db SPRITE_SILPH_WORKER_F
	db SPRITE_MIDDLE_AGED_WOMAN
	db SPRITE_BRUNETTE_GIRL
	db SPRITE_LANCE
	db SPRITE_SCIENTIST
	db SPRITE_ROCKER
	db SPRITE_FISHER
	db SPRITE_KOGA
	db SPRITE_AGATHA
	db SPRITE_BRUNO
	db SPRITE_LORELEI
	db SPRITE_MEGAN
	assert_table_length NUM_PLAYER_SPRITE_CHOICES

; display names, same order/count as PlayerSpriteChoices above
PlayerSpriteChoiceNames::
	list_start 16
	li "RED"
	li "BLUE"
	li "PROF OAK"
	li "YOUNGSTER"
	li "COOLTRAINER F"
	li "COOLTRAINER M"
	li "LITTLE GIRL"
	li "MIDDLE-AGE MAN"
	li "GAMBLER"
	li "SUPER NERD"
	li "GIRL"
	li "HIKER"
	li "BEAUTY"
	li "GENTLEMAN"
	li "DAISY"
	li "BIKER"
	li "SAILOR"
	li "COOK"
	li "MR FUJI"
	li "GIOVANNI"
	li "CHANNELER"
	li "WAITER"
	li "SILPH WORKER"
	li "MIDDLE-AGE WOMAN"
	li "BRUNETTE GIRL"
	li "LANCE"
	li "SCIENTIST"
	li "ROCKER"
	li "FISHERMAN"
	li "KOGA"
	li "AGATHA"
	li "BRUNO"
	li "LORELEI"
	li "MEGAN"
	assert_list_length NUM_PLAYER_SPRITE_CHOICES
