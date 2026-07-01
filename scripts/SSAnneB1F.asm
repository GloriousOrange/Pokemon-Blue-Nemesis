SSAnneB1F_Script:
	jp EnableAutoTextBoxDrawing

SSAnneB1F_TextPointers:
	def_text_pointers
	dw_const SSAnneB1FDetectiveText, TEXT_SSANNEB1F_DETECTIVE

SSAnneB1FDetectiveText:
	text_far _SSAnneB1FDetectiveText
	text_end
