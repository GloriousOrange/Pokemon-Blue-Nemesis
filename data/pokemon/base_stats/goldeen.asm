	db DEX_GOLDEEN ; pokedex id

	db  45,  67,  60,  75,  50
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 225 ; catch rate
	db 111 ; base exp

	INCBIN "gfx/pokemon/front/goldeen.pic", 0, 1 ; sprite dimensions
	dw GoldeenPicFront, GoldeenPicBack

	db BUBBLE, PECK, TAIL_WHIP, NO_MOVE ; level 1 learnset (Bubble added for starter STAB)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC, HORN_DRILL, TAKE_DOWN, DOUBLE_EDGE, BUBBLEBEAM,  \
	     WATER_GUN, ICE_BEAM, BLIZZARD, RAGE, MIMIC,  \
	     DOUBLE_TEAM, SWIFT, SKULL_BASH, REST, SUBSTITUTE,  \
	     SURF
	; end

	db 0 ; padding
