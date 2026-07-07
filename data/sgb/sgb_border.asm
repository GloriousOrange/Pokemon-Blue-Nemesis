BorderPalettes:
IF DEF(_RED)
	INCBIN "gfx/sgb/red_border.tilemap"
ENDC
IF DEF(_BLUE)
	INCBIN "gfx/sgb/blue_border.tilemap"
ENDC

	ds $100

IF DEF(_RED)
	RGB 30,29,29 ; PAL_SGB1
	RGB 25,22,25
	RGB 25,17,21
	RGB 24,14,12
ENDC
IF DEF(_BLUE)
	RGB 0,0,0 ; PAL_SGB1 -- solid black border
	RGB 0,0,0
	RGB 0,0,0
	RGB 0,0,0
ENDC

	ds $18

IF DEF(_RED)
	RGB 30,29,29 ; PAL_SGB2
	RGB 22,31,16
	RGB 27,20,6
	RGB 15,15,15
ENDC
IF DEF(_BLUE)
	RGB 0,0,0 ; PAL_SGB2 -- solid black border
	RGB 0,0,0
	RGB 0,0,0
	RGB 0,0,0
ENDC

	ds $18

IF DEF(_RED)
	RGB 30,29,29 ; PAL_SGB3
	RGB 31,31,17
	RGB 18,21,29
	RGB 15,15,15
ENDC
IF DEF(_BLUE)
	RGB 0,0,0 ; PAL_SGB3 -- solid black border
	RGB 0,0,0
	RGB 0,0,0
	RGB 0,0,0
ENDC

	ds $18

SGBBorderGraphics:
IF DEF(_RED)
	INCBIN "gfx/sgb/red_border.2bpp"
ENDC
IF DEF(_BLUE)
	INCBIN "gfx/sgb/blue_border.2bpp"
ENDC
