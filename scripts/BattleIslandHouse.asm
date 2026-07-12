BattleIslandHouse_Script:
	jp EnableAutoTextBoxDrawing

BattleIslandHouse_TextPointers:
	def_text_pointers
	dw_const BattleIslandHouseNurseText, TEXT_BATTLEISLANDHOUSE_NURSE

; The Battle Island house healer is MEGAN (endgame heal point). Uses the shared
; girlfriend interaction (engine/overworld/megan.asm) -- heal-only here, since
; MeganGiftTable index 29 is a no-gift slot.
BattleIslandHouseNurseText:
	text_asm
	ld a, 29 ; Megan location index -- Battle Island (heal-only)
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd

; The PC is a shared hidden event (data/events/hidden_events.asm ->
; OpenPokemonCenterPC -> PokemonCenterPCText), not a map-local text ID --
; see every real Pokecenter for the same pattern.
