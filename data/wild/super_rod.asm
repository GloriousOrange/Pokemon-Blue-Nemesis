; super rod encounters
SuperRodData:
	; map, fishing group
	dbw PALLET_TOWN,         .Group1
	dbw VIRIDIAN_CITY,       .Group1
	dbw CERULEAN_CITY,       .Group3
	dbw VERMILION_CITY,      .Group4
	dbw CELADON_CITY,        .Group5
	dbw FUCHSIA_CITY,        .Group10
	dbw CINNABAR_ISLAND,     .Group8
	dbw ROUTE_4,             .Group3
	dbw ROUTE_6,             .Group4
	dbw ROUTE_10,            .Group5
	dbw ROUTE_11,            .Group4
	dbw ROUTE_12,            .Group7
	dbw ROUTE_13,            .Group7
	dbw ROUTE_17,            .Group7
	dbw ROUTE_18,            .Group7
	dbw ROUTE_19,            .Group8
	dbw ROUTE_20,            .Group8
	dbw ROUTE_21,            .Group8
	dbw ROUTE_22,            .Group2
	dbw ROUTE_23,            .Group9
	dbw ROUTE_24,            .Group3
	dbw ROUTE_25,            .Group3
	dbw CERULEAN_GYM,        .Group3
	dbw VERMILION_DOCK,      .Group4
	dbw SEAFOAM_ISLANDS_B3F, .Group8
	dbw SEAFOAM_ISLANDS_B4F, .Group8
	dbw SAFARI_ZONE_EAST,    .Group6
	dbw SAFARI_ZONE_NORTH,   .Group6
	dbw SAFARI_ZONE_WEST,    .Group6
	dbw SAFARI_ZONE_CENTER,  .Group6
	dbw CERULEAN_CAVE_2F,    .Group9
	dbw CERULEAN_CAVE_B1F,   .Group9
	dbw CERULEAN_CAVE_1F,    .Group9
	dbw ARCHIPELAGO_CAVE_3F, .Group11
	db -1 ; end

; fishing groups
; number of monsters, followed by level/monster pairs

.Group1:
	db 2
	db 15, TENTACOOL
	db 15, POLIWAG

.Group2:
	db 2
	db 15, GOLDEEN
	db 15, POLIWAG

.Group3:
	db 3
	db 15, PSYDUCK
	db 15, GOLDEEN
	db 15, KRABBY

.Group4:
	db 2
	db 15, KRABBY
	db 15, SHELLDER

.Group5:
	db 2
	db 23, POLIWHIRL
	db 15, SLOWPOKE

.Group6:
	db 4
	db 15, DRATINI
	db 15, KRABBY
	db 15, PSYDUCK
	db 15, SLOWPOKE

.Group7:
	db 4
	db 5, TENTACOOL
	db 15, KRABBY
	db 15, GOLDEEN
	db 15, MAGIKARP

.Group8:
	db 4
	db 15, STARYU
	db 15, HORSEA
	db 15, SHELLDER
	db 15, GOLDEEN

.Group9:
	db 4
	db 23, SLOWBRO
	db 23, SEAKING
	db 23, KINGLER
	db 23, SEADRA

.Group10:
	db 4
	db 23, SEAKING
	db 15, KRABBY
	db 15, GOLDEEN
	db 15, MAGIKARP

; The Archipelago Cave's underground lake. Drawn from the lake's own surfing
; table in data/wild/maps/ArchipelagoCave3F.asm, which Josh curated -- but
; ReadSuperRodData picks with a 2-bit random number, so a fishing group can
; only ever hold FOUR reachable entries. These are the four below the
; capstone: GYARADOS and DRAGONITE are left out rather than given a flat 25%
; each, since the lake table calls DRAGONITE "the rare catch".
.Group11:
	db 4
	db 30, DRATINI
	db 45, DRAGONAIR
	db 50, HORSEA
	db 52, SEADRA
