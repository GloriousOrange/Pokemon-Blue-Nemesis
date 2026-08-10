	db DEX_PINSIRITE ; pokedex id

; PINSIR's spread with the Defense raised to GOLEM's 130, per Josh -- the
; "physical wall-breaker" archetype needed the wall half to actually be there.
; Everything else is PINSIR unchanged, matching how DIGNEMITE took DUGTRIO's
; numbers and NINEFROST took NINETALES'.
	db  65, 125, 130,  90,  55
	;   hp  atk  def  spd  spc

	db BUG, ROCK ; type
	db 90 ; catch rate (PINSIR's own; not caught in the wild, but kept for consistency)
	db 200 ; base exp (PINSIR's own)

	INCBIN "gfx/pokemon/front/pinsirite.pic", 0, 1 ; sprite dimensions
	dw PinsiritePicFront, PinsiritePicBack

	db VICEGRIP, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset (PINSIR's own starter move)
	db GROWTH_MEDIUM_SLOW ; growth rate (PINSIR's own)

	; tm/hm learnset: PINSIR's own list plus ROCK_SLIDE for its added Rock type
	tmhm SWORDS_DANCE, TOXIC, BODY_SLAM, TAKE_DOWN, DOUBLE_EDGE,  \
	     HYPER_BEAM, SUBMISSION, SEISMIC_TOSS, RAGE, MIMIC,  \
	     DOUBLE_TEAM, REST, SUBSTITUTE, CUT, STRENGTH,  \
	     ROCK_SLIDE
	; end

	db 0 ; padding
