BattleIslandHouse_Script:
	jp EnableAutoTextBoxDrawing

BattleIslandHouse_TextPointers:
	def_text_pointers
	dw_const BattleIslandHouseNurseText, TEXT_BATTLEISLANDHOUSE_NURSE
	dw_const BattleIslandHousePCText,    TEXT_BATTLEISLANDHOUSE_PC

BattleIslandHouseNurseText:
	text_asm
	call BattleIslandHouseHealScript
	jp TextScriptEnd

BattleIslandHouseHealScript:
	ld hl, BattleIslandHouseNurseHealText
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, BattleIslandHouseNurseDoneText
	jp PrintText

BattleIslandHouseNurseHealText:
	text_far _BattleIslandHouseNurseHealText
	text_end

BattleIslandHouseNurseDoneText:
	text_far _BattleIslandHouseNurseDoneText
	text_end

BattleIslandHousePCText:
	script_pokecenter_pc
