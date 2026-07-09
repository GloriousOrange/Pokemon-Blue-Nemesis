	db DEX_MIASMA ; pokedex id

	db  85, 105,  75, 110, 100
	;   hp  atk  def  spd  spc

	db POISON, FLYING ; type
	db 3   ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/miasma.pic", 0, 1 ; sprite dimensions (custom front)
	dw MiasmaPicFront, MiasmaPicBack

	db SMOKESCREEN, DRILL_PECK, NO_MOVE, NO_MOVE ; starting moves (BLIGHT_VOMIT@40, CARRION_WIND@50)
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND, WHIRLWIND, TOXIC, TAKE_DOWN, DOUBLE_EDGE,  \
	     HYPER_BEAM, RAGE, MIMIC, DOUBLE_TEAM, SWIFT,  \
	     SKY_ATTACK, REST, SUBSTITUTE, FLY
	; end

	db 0 ; padding
