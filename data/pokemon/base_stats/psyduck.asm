	db DEX_PSYDUCK ; pokedex id

	db  50,  52,  48,  95,  50
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 190 ; catch rate
	db 80 ; base exp

	INCBIN "gfx/pokemon/front/psyduck.pic", 0, 1 ; sprite dimensions
	dw PsyduckPicFront, PsyduckPicBack

	db CLAMP, SCRATCH, NO_MOVE, NO_MOVE ; level 1 learnset (Clamp added for starter STAB)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, MEGA_KICK, TOXIC, BODY_SLAM, TAKE_DOWN,  \
	     DOUBLE_EDGE, BUBBLEBEAM, WATER_GUN, ICE_BEAM, BLIZZARD,  \
	     PAY_DAY, SUBMISSION, COUNTER, SEISMIC_TOSS, RAGE,  \
	     DIG, MIMIC, DOUBLE_TEAM, SWIFT, SKULL_BASH,  \
	     REST, SUBSTITUTE, SURF, STRENGTH, ROCK_THROW
	; end

	db 0 ; padding
