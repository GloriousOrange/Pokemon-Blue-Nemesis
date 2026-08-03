	db DEX_PINSIRITE ; pokedex id

; PLACEHOLDER stat line -- Josh gave no explicit numbers for PINSIRITE, only
; the archetype ("physical wall-breaker", the Alakachamp/MewThree mould). This
; is PINSIR's own spread, unmodified, following the pattern Josh set for
; DIGNEMITE (explicitly "like Dugtrio's stats") and NINEFROST (its approved
; Spc/Spd, 100/100, already matches NINETALES exactly) -- a straight recolor
; keeps the base species' numbers unless told otherwise. Confirm or adjust.
	db  65, 125, 100,  90,  55
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
