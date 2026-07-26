	db DEX_VOLTORB ; pokedex id

	db  40,  30,  50, 120,  55
	;   hp  atk  def  spd  spc

	db ELECTRIC, ELECTRIC ; type
	db 190 ; catch rate
	db 103 ; base exp

	INCBIN "gfx/pokemon/front/voltorb.pic", 0, 1 ; sprite dimensions
	dw VoltorbPicFront, VoltorbPicBack

	db SPARK, TACKLE, SCREECH, NO_MOVE ; level 1 learnset (Spark added for starter STAB)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC, TAKE_DOWN, RAGE, THUNDERBOLT, THUNDER,  \
	     TELEPORT, MIMIC, DOUBLE_TEAM, REFLECT, SELFDESTRUCT,  \
	     SWIFT, REST, THUNDER_WAVE, EXPLOSION, SUBSTITUTE,  \
	     FLASH
	; end

	db 0 ; padding
