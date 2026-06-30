SilphCo1F_Script:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret z
	CheckAndSetEvent EVENT_SILPH_CO_RECEPTIONIST_AT_DESK
	ret nz
	ld a, TOGGLE_SILPH_CO_1F_RECEPTIONIST
	ld [wToggleableObjectIndex], a
	predef_jump ShowObject

SilphCo1F_TextPointers:
	def_text_pointers
	dw_const SilphCo1FLinkReceptionistText, TEXT_SILPHCO1F_LINK_RECEPTIONIST
	dw_const SilphCo1FMeganText, TEXT_SILPHCO1F_MEGAN

SilphCo1FLinkReceptionistText:
	text_far _SilphCo1FLinkReceptionistText
	text_end

SilphCo1FMeganText:
	text_asm
	ld a, 21 ; Megan location index: Silph Co.
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd
