	db DEX_TYRANIS ; pokedex id

	db  80, 140,  80, 120,  85
	;   hp  atk  def  spd  spc

	db NORMAL, FLYING ; type
	db 3   ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/tyranis.pic", 0, 1 ; sprite dimensions (from the custom front pic)
	dw TyranisPicFront, TyranisPicBack

	db DOUBLE_DRILL, HYPER_BEAMS, BODY_SLAM, SAND_ATTACK ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	db 0 ; padding
