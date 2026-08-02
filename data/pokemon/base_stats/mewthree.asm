	db DEX_MEWTHREE ; pokedex id

	db 106, 110, 130,  90, 154
	;   hp  atk  def  spd  spc
	; Mewtwo's spread with Defense and Speed swapped: the armor makes it far
	; harder to dent and much slower on its feet.

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 90 ; catch rate -- an ordinary rate, not Mewtwo's legendary 3
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/mewthree.pic", 0, 1 ; sprite dimensions
	dw MewthreePicFront, MewthreePicBack

	db CONFUSION, DISABLE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, MEGA_KICK, TOXIC, BODY_SLAM, TAKE_DOWN,  \
	     DOUBLE_EDGE, BUBBLEBEAM, WATER_GUN, ICE_BEAM, BLIZZARD,  \
	     HYPER_BEAM, PAY_DAY, SUBMISSION, COUNTER, SEISMIC_TOSS,  \
	     RAGE, SOLARBEAM, THUNDERBOLT, THUNDER, PSYCHIC_M,  \
	     TELEPORT, MIMIC, DOUBLE_TEAM, REFLECT, METRONOME,  \
	     SELFDESTRUCT, FIRE_BLAST, SKULL_BASH, REST, THUNDER_WAVE,  \
	     PSYWAVE, TRI_ATTACK, SUBSTITUTE, STRENGTH, FLASH,  \
	     ROCK_THROW
	; end

	db 0 ; padding
