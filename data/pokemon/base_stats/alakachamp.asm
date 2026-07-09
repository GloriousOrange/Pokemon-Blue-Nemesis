	db DEX_ALAKACHAMP ; pokedex id

	db  90, 130,  80,  85,  65
	;   hp  atk  def  spd  spc

	db FIGHTING, PSYCHIC_TYPE ; type
	db 45 ; catch rate
	db 193 ; base exp

	INCBIN "gfx/pokemon/front/machamp.pic", 0, 1 ; sprite dimensions (reuses Machamp art)
	dw AlakachampPicFront, AlakachampPicBack

	db COUNTER, PSYCHIC_M, MIND_FEVER, DOUBLE_TEAM ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset (Machamp's set plus PSYCHIC)
	tmhm MEGA_PUNCH, MEGA_KICK, TOXIC, BODY_SLAM, TAKE_DOWN,  \
	     DOUBLE_EDGE, HYPER_BEAM, SUBMISSION, COUNTER, SEISMIC_TOSS,  \
	     RAGE, EARTHQUAKE, FISSURE, DIG, MIMIC,  \
	     DOUBLE_TEAM, METRONOME, FIRE_BLAST, SKULL_BASH, REST,  \
	     ROCK_SLIDE, SUBSTITUTE, STRENGTH, ROCK_THROW, PSYCHIC_M
	; end

	db 0 ; padding
