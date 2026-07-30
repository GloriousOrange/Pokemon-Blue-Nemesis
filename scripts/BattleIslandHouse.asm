BattleIslandHouse_Script:
	call EnableAutoTextBoxDrawing
	ld hl, BattleIslandHouseTrainerHeaders
	ld de, BattleIslandHouse_ScriptPointers
	ld a, [wMeganSparCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMeganSparCurScript], a
	ret

BattleIslandHouse_ScriptPointers:
	def_script_pointers
	dw_const BattleIslandHouseDefaultScript, SCRIPT_BATTLEISLANDHOUSE_DEFAULT
	dw_const BattleIslandHouseMeganTrained,  SCRIPT_BATTLEISLANDHOUSE_MEGAN_TRAINED

BattleIslandHouseTrainerHeaders:
	def_trainers
	db -1 ; Megan is engaged from her own text, not on sight

BattleIslandHouseDefaultScript:
	ret

; Aftermath of her Battle Island sparring match (Slowbro L100). Losing leaves the
; flag clear so she will spar again.
BattleIslandHouseMeganTrained:
	ld a, [wIsInBattle]
	cp $ff
	jr z, .reset
	ld a, MEGAN_LOC_BATTLE_ISLAND
	ld [wMeganLocIndex], a
	farcall MeganMarkTrained
.reset
	xor a
	ld [wJoyIgnore], a
	ld [wMeganSparCurScript], a
	ld [wCurMapScript], a
	ret

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
	ld a, MEGAN_LOC_BATTLE_ISLAND ; heal-only, but she will spar here too
	ld [wMeganLocIndex], a
	farcall MeganSparOffer
	jr nc, .done
	ld a, SCRIPT_BATTLEISLANDHOUSE_MEGAN_TRAINED
	ld [wMeganSparCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

; The PC is a shared hidden event (data/events/hidden_events.asm ->
; OpenPokemonCenterPC -> PokemonCenterPCText), not a map-local text ID --
; see every real Pokecenter for the same pattern.
