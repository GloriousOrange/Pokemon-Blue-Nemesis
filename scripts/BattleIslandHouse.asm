BattleIslandHouse_Script:
	jp EnableAutoTextBoxDrawing

BattleIslandHouse_TextPointers:
	def_text_pointers
	dw_const BattleIslandHouseNurseText, TEXT_BATTLEISLANDHOUSE_NURSE

; The Battle Island house healer is MEGAN (endgame heal point). Uses the shared
; girlfriend interaction (engine/overworld/megan.asm) -- heal-only here, since
; MeganGiftTable index 29 is a no-gift slot.
;
; Also registers Battle Island as the blackout/Teleport/Dig respawn point,
; same as every real Pokecenter Nurse (engine/events/pokecenter.asm calls the
; identical SetLastBlackoutMap before healing) -- without this, losing an
; arena fight would send the player to whatever Pokecenter they last used
; for a REAL heal instead of back to the island. Battle Island already has a
; Fly-warp entry (data/maps/special_warps.asm) landing at (8,5), which is
; what blackout's escape-warp path reuses as the landing spot.
BattleIslandHouseNurseText:
	text_asm
	farcall SetLastBlackoutMap
	ld a, 29 ; Megan location index -- Battle Island (heal-only)
	ld [wMeganLocIndex], a
	farcall MeganTalk
	jp TextScriptEnd

; The PC is a shared hidden event (data/events/hidden_events.asm ->
; OpenPokemonCenterPC -> PokemonCenterPCText), not a map-local text ID --
; see every real Pokecenter for the same pattern.
