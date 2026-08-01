	db DEX_JYNX ; pokedex id

	db  65,  50,  35,  95, 115
	;   hp  atk  def  spd  spc

	db ICE, PSYCHIC_TYPE ; type
	db 90 ; catch rate
	db 137 ; base exp

	INCBIN "gfx/pokemon/front/jynx.pic", 0, 1 ; sprite dimensions
	dw JynxPicFront, JynxPicBack

	db PSY_CHOP, POUND, LOVELY_KISS, NO_MOVE ; level 1 learnset (Psy Chop added for starter STAB)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, MEGA_KICK, TOXIC, BODY_SLAM, TAKE_DOWN,  \
	     DOUBLE_EDGE, BUBBLEBEAM, WATER_GUN, ICE_BEAM, BLIZZARD,  \
	     HYPER_BEAM, SUBMISSION, COUNTER, SEISMIC_TOSS, RAGE,  \
	     PSYCHIC_M, TELEPORT, MIMIC, DOUBLE_TEAM, REFLECT,  \
	     METRONOME, SKULL_BASH, REST, PSYWAVE, SUBSTITUTE,  \
	     ROCK_THROW
	; end

	db 0 ; padding
