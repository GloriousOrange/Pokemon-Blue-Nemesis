	db DEX_NINEFROST ; pokedex id

; NINETALES' own spread, unmodified. Josh specified "Base 100 Spc / 100 Speed"
; for NINEFROST -- both already match NINETALES exactly, which reads as
; confirmation this is meant to be a straight recolor (Josh: "Recolors are
; fine"), same pattern as PINSIRITE. HP/Atk/Def carried over rather than
; invented. Confirm or adjust.
	db  73,  76,  75, 100, 100
	;   hp  atk  def  spd  spc

	db FIRE, ICE ; type
	db 75 ; catch rate (NINETALES' own; not caught in the wild, but kept for consistency)
	db 178 ; base exp (NINETALES' own)

	INCBIN "gfx/pokemon/front/ninefrost.pic", 0, 1 ; sprite dimensions
	dw NinefrostPicFront, NinefrostPicBack

	db EMBER, TAIL_WHIP, QUICK_ATTACK, ROAR ; level 1 learnset (NINETALES' own)
	db GROWTH_MEDIUM_FAST ; growth rate (NINETALES' own)

	; tm/hm learnset: NINETALES' own list plus ICE_BEAM/BLIZZARD for its added Ice type
	tmhm TOXIC, BODY_SLAM, TAKE_DOWN, DOUBLE_EDGE, HYPER_BEAM,  \
	     RAGE, DIG, MIMIC, DOUBLE_TEAM, REFLECT,  \
	     FIRE_BLAST, SWIFT, SKULL_BASH, REST, SUBSTITUTE,  \
	     ICE_BEAM, BLIZZARD
	; end

	db 0 ; padding
