	db DEX_MANKEY ; pokedex id

	db  40,  80,  35, 105,  35
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 190 ; catch rate
	db 74 ; base exp

	INCBIN "gfx/pokemon/front/mankey.pic", 0, 1 ; sprite dimensions
	dw MankeyPicFront, MankeyPicBack

	db PALM_STRIKE, SCRATCH, LEER, NO_MOVE ; level 1 learnset (Palm Strike added for starter STAB)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, MEGA_KICK, TOXIC, BODY_SLAM, TAKE_DOWN,  \
	     DOUBLE_EDGE, PAY_DAY, SUBMISSION, COUNTER, SEISMIC_TOSS,  \
	     RAGE, THUNDERBOLT, THUNDER, DIG, MIMIC,  \
	     DOUBLE_TEAM, METRONOME, SWIFT, SKULL_BASH, REST,  \
	     ROCK_SLIDE, SUBSTITUTE, STRENGTH, ROCK_THROW
	; end

	db 0 ; padding
