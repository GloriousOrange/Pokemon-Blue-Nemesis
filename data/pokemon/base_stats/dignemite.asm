	db DEX_DIGNEMITE ; pokedex id

; Josh, 2026-08-02: "Make it's stats like Dugtrio's, but raise HP and Defense."
; Dugtrio's own spread is 45/80/50/120/70. HP +25 (45->70), Defense +40
; (50->90) -- Attack/Speed/Special left exactly as Dugtrio's. The bump amounts
; are my judgment call within Josh's instruction; adjust freely.
	db  70,  80,  90, 120,  70
	;   hp  atk  def  spd  spc

	db GROUND, ELECTRIC ; type
	db 50 ; catch rate (DUGTRIO's own; not caught in the wild, but kept for consistency)
	db 153 ; base exp (DUGTRIO's own)

	INCBIN "gfx/pokemon/front/dignemite.pic", 0, 1 ; sprite dimensions
	dw DignemitePicFront, DignemitePicBack

	db MUD_SLAP, SCRATCH, NO_MOVE, NO_MOVE ; level 1 learnset (DIGLETT's own -- the sprite it's enlarged from)
	db GROWTH_MEDIUM_FAST ; growth rate (DUGTRIO's own)

	; tm/hm learnset: DUGTRIO's own list plus THUNDERBOLT for its added Electric type
	tmhm TOXIC, BODY_SLAM, TAKE_DOWN, DOUBLE_EDGE, HYPER_BEAM,  \
	     RAGE, EARTHQUAKE, FISSURE, DIG, MIMIC,  \
	     DOUBLE_TEAM, REST, ROCK_SLIDE, SUBSTITUTE,  \
	     THUNDERBOLT
	; end

	db 0 ; padding
