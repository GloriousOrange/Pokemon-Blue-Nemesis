LavenderPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

LavenderPokecenter_TextPointers:
	def_text_pointers
	dw_const LavenderPokecenterNurseText,            TEXT_LAVENDERPOKECENTER_NURSE
	dw_const LavenderPokecenterGentlemanText,        TEXT_LAVENDERPOKECENTER_GENTLEMAN
	dw_const LavenderPokecenterLittleGirlText,       TEXT_LAVENDERPOKECENTER_LITTLE_GIRL
	dw_const LavenderPokecenterLinkReceptionistText, TEXT_LAVENDERPOKECENTER_LINK_RECEPTIONIST
	dw_const LavenderPokecenterMeganText, TEXT_LAVENDERPOKECENTER_MEGAN

LavenderPokecenterLinkReceptionistText:
	script_cable_club_receptionist

LavenderPokecenterMeganText:
	text_asm
	ld a, 4 ; Megan location index
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd

LavenderPokecenterNurseText:
	script_pokecenter_nurse

LavenderPokecenterGentlemanText:
	text_far _LavenderPokecenterGentlemanText
	text_end

LavenderPokecenterLittleGirlText:
	text_far _LavenderPokecenterLittleGirlText
	text_end
