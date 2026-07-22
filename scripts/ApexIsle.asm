ApexIsle_Script:
	jp EnableAutoTextBoxDrawing

ApexIsle_TextPointers:
	def_text_pointers
	dw_const ApexIsleSignText, TEXT_APEXISLE_SIGN

ApexIsleSignText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd
.Text:
	text "OAK'S EMPORIUM"

	para "By appointment to"
	line "the PROFESSOR"
	cont "himself."
	prompt
