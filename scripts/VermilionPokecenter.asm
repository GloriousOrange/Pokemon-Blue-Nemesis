VermilionPokecenter_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

VermilionPokecenter_TextPointers:
	def_text_pointers
	dw_const VermilionPokecenterNurseText,            TEXT_VERMILIONPOKECENTER_NURSE
	dw_const VermilionPokecenterFishingGuruText,      TEXT_VERMILIONPOKECENTER_FISHING_GURU
	dw_const VermilionPokecenterSailorText,           TEXT_VERMILIONPOKECENTER_SAILOR
	dw_const VermilionPokecenterLinkReceptionistText, TEXT_VERMILIONPOKECENTER_LINK_RECEPTIONIST
	dw_const VermilionPokecenterMeganText, TEXT_VERMILIONPOKECENTER_MEGAN

VermilionPokecenterNurseText:
	script_pokecenter_nurse

VermilionPokecenterFishingGuruText:
	text_far _VermilionPokecenterFishingGuruText
	text_end

VermilionPokecenterSailorText:
	text_far _VermilionPokecenterSailorText
	text_end

VermilionPokecenterLinkReceptionistText:
	script_cable_club_receptionist

VermilionPokecenterMeganText:
	text_asm
	ld a, 3 ; Megan location index
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd
