CeruleanCave1F_Script:
	jp EnableAutoTextBoxDrawing

CeruleanCave1F_TextPointers:
	def_text_pointers
	dw_const PickUpItemText, TEXT_CERULEANCAVE1F_FULL_RESTORE
	dw_const PickUpItemText, TEXT_CERULEANCAVE1F_MAX_ELIXER
	dw_const PickUpItemText, TEXT_CERULEANCAVE1F_NUGGET
	dw_const CeruleanCave1FMeganText, TEXT_CERULEANCAVE1F_MEGAN

CeruleanCave1FMeganText:
	text_asm
	ld a, 26 ; Megan location index
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd
