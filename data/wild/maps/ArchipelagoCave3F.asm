ArchipelagoCave3FWildMons:
	def_grass_wildmons 10 ; encounter rate
	db 50, GASTLY
	db 50, HAUNTER
	db 52, GEODUDE
	db 52, ONIX
	db 54, SANDSHREW
	db 55, DIGLETT
	db 56, CUBONE
	db 57, GRAVELER
	db 58, DRAGONAIR
	db 60, MEW
	end_grass_wildmons

; The underground lake's own encounter table -- dragons, the way Josh asked
; for it (2026-08-04). Dratini/Dragonair build the curve, Horsea/Seadra and
; Gyarados round it out as fellow serpentine lake-monsters, Dragonite tops
; it out as the rare catch.
	def_water_wildmons 20 ; encounter rate
	db 30, DRATINI
	db 35, DRATINI
	db 40, DRATINI
	db 45, DRAGONAIR
	db 48, DRAGONAIR
	db 50, HORSEA
	db 52, SEADRA
	db 55, DRAGONAIR
	db 58, GYARADOS
	db 60, DRAGONITE
	end_water_wildmons
