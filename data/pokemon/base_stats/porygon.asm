	db DEX_PORYGON ; pokedex id

	db  90,  60,  70,  40, 110
	;   hp  atk  def  spd  spc  ; HP 90, Spc 110 (Oak's buffed Porygon)

	db NORMAL, NORMAL ; type
	db 90 ; catch rate
	db 130 ; base exp

	INCBIN "gfx/pokemon/front/porygon.pic", 0, 1 ; sprite dimensions
	dw PorygonPicFront, PorygonPicBack

	db TACKLE, MIMIC, SHARPEN, CONVERSION ; level 1 learnset (Tackle restored: as a
	; starter it otherwise had no attack of its own until Psybeam at L23)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC, TAKE_DOWN, DOUBLE_EDGE, ICE_BEAM, BLIZZARD,  \
	     HYPER_BEAM, RAGE, THUNDERBOLT, THUNDER, PSYCHIC_M,  \
	     TELEPORT, MIMIC, DOUBLE_TEAM, REFLECT, SWIFT,  \
	     SKULL_BASH, REST, THUNDER_WAVE, PSYWAVE, TRI_ATTACK,  \
	     SUBSTITUTE, FLASH
	; end

	db 0 ; padding
