	db DEX_NOCTURN ; pokedex id

	db  80,  85,  70, 125, 115
	;   hp  atk  def  spd  spc

	db GHOST, FLYING ; type
	db 3   ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/nocturn.pic", 0, 1 ; sprite dimensions (custom front)
	dw NocturnPicFront, NocturnPicBack

	db MIND_FEVER, PHANTOM_WING, GUST, NIGHT_SHADE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	db 0 ; padding
