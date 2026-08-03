	db DEX_EXEGGCUTE ; pokedex id

	db  60,  40,  80,  65,  60
	;   hp  atk  def  spd  spc

	db GRASS, PSYCHIC_TYPE ; type
	db 90 ; catch rate
	db 98 ; base exp

	INCBIN "gfx/pokemon/front/exeggcute.pic", 0, 1 ; sprite dimensions
	dw ExeggcutePicFront, ExeggcutePicBack

	db VINE_WHIP, BARRAGE, HYPNOSIS, NO_MOVE ; level 1 learnset (Vine Whip added for starter STAB)
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC, TAKE_DOWN, DOUBLE_EDGE, RAGE, PSYCHIC_M,  \
	     TELEPORT, MIMIC, DOUBLE_TEAM, REFLECT, SELFDESTRUCT,  \
	     EGG_BOMB, REST, PSYWAVE, EXPLOSION, SUBSTITUTE
	; end

	db 0 ; padding
