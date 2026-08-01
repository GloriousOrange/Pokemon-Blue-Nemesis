	db DEX_ONIX ; pokedex id

	db  85,  45, 160,  70,  30
	;   hp  atk  def  spd  spc

	db ROCK, GROUND ; type
	db 90 ; catch rate
	db 108 ; base exp

	INCBIN "gfx/pokemon/front/onix.pic", 0, 1 ; sprite dimensions
	dw OnixPicFront, OnixPicBack

	db MUD_SLAP, TACKLE, SCREECH, NO_MOVE ; level 1 learnset (Mud Slap added for starter STAB)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC, BODY_SLAM, TAKE_DOWN, DOUBLE_EDGE, RAGE,  \
	     EARTHQUAKE, FISSURE, DIG, MIMIC, DOUBLE_TEAM,  \
	     SELFDESTRUCT, SKULL_BASH, REST, EXPLOSION, ROCK_SLIDE,  \
	     SUBSTITUTE, STRENGTH
	; end

	db 0 ; padding
