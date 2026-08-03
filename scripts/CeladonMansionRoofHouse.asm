CeladonMansionRoofHouse_Script:
	jp EnableAutoTextBoxDrawing

CeladonMansionRoofHouse_TextPointers:
	def_text_pointers
	dw_const CeladonMansionRoofHouseHikerText,         TEXT_CELADONMANSION_ROOF_HOUSE_HIKER
	dw_const CeladonMansionRoofHousePorygonPokeballText, TEXT_CELADONMANSION_ROOF_HOUSE_PORYGON_POKEBALL

CeladonMansionRoofHouseHikerText:
	text_far _CeladonMansionRoofHouseHikerText
	text_end

CeladonMansionRoofHousePorygonPokeballText:
	text_asm
	lb bc, PORYGON, 25
	call GivePokemon
	jr nc, .party_full
	ld a, TOGGLE_CELADON_MANSION_PORYGON_GIFT
	ld [wToggleableObjectIndex], a
	predef HideObject
.party_full
	jp TextScriptEnd
