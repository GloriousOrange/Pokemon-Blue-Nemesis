	db DEX_DITTO ; pokedex id
	db 250,  55,  55, 140,  55
	;   hp  atk  def  spd  spc  ; Ditto buffed: HP 250, Atk/Def 150, Spd 140 (capped at ELECTRODE), Spc 200

	db NORMAL, NORMAL ; type
	db 35 ; catch rate
	db 61 ; base exp

	INCBIN "gfx/pokemon/front/ditto.pic", 0, 1 ; sprite dimensions
	dw DittoPicFront, DittoPicBack

	db TRANSFORM, TACKLE, NO_MOVE, NO_MOVE ; level 1 learnset (Tackle so a Ditto
	; starter can fight without Transform; its level-up learnset is empty)
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
