DiglettsCave_Script:
	jp EnableAutoTextBoxDrawing

DiglettsCave_TextPointers:
	def_text_pointers

	dw_const DiglettsCaveMeganText, TEXT_DIGLETTSCAVE_MEGAN

DiglettsCaveMeganText:
	text_asm
	ld a, 27 ; Megan location index
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd
