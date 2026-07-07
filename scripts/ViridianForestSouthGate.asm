ViridianForestSouthGate_Script:
	jp EnableAutoTextBoxDrawing

ViridianForestSouthGate_TextPointers:
	def_text_pointers
	dw_const ViridianForestSouthGateMeganText,      TEXT_VIRIDIANFORESTSOUTHGATE_GIRL
	dw_const ViridianForestSouthGateLittleGirlText, TEXT_VIRIDIANFORESTSOUTHGATE_LITTLE_GIRL

ViridianForestSouthGateMeganText:
	text_asm
	ld a, 28 ; Megan location index
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd

ViridianForestSouthGateLittleGirlText:
	text_far _ViridianForestSouthGateLittleGirlText
	text_end
