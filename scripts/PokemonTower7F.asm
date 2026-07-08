PokemonTower7F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower7TrainerHeaders
	ld de, PokemonTower7F_ScriptPointers
	ld a, [wPokemonTower7FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower7FCurScript], a
	ret

PokemonTower7FSetDefaultScript:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonTower7FCurScript], a ; SCRIPT_POKEMONTOWER7F_DEFAULT
	ld [wCurMapScript], a ; SCRIPT_POKEMONTOWER7F_DEFAULT
	ret

; The Channelers (formerly Rockets) use the standard end-battle flow and stay
; on the floor keeping their vigil after defeat -- the old Rocket walk-away
; exit (scripted MoveSprite + HideObject) is gone, which also removes a
; whole class of stuck-scripted-movement freeze risk.
PokemonTower7F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONTOWER7F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER7F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONTOWER7F_END_BATTLE
	dw_const PokemonTower7FWarpToMrFujiHouseScript, SCRIPT_POKEMONTOWER7F_WARP_TO_MR_FUJI_HOUSE

PokemonTower7FWarpToMrFujiHouseScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TOGGLE_POKEMON_TOWER_7F_MR_FUJI
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, MR_FUJIS_HOUSE
	ldh [hWarpDestinationMap], a
	ld a, $1
	ld [wDestinationWarpID], a
	ld a, LAVENDER_TOWN
	ld [wLastMap], a
	ld hl, wStatusFlags3
	set BIT_WARP_FROM_CUR_SCRIPT, [hl]
	ld a, SCRIPT_POKEMONTOWER7F_DEFAULT
	ld [wPokemonTower7FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower7F_TextPointers:
	def_text_pointers
	dw_const PokemonTower7FChanneler1Text, TEXT_POKEMONTOWER7F_CHANNELER1
	dw_const PokemonTower7FChanneler2Text, TEXT_POKEMONTOWER7F_CHANNELER2
	dw_const PokemonTower7FChanneler3Text, TEXT_POKEMONTOWER7F_CHANNELER3
	dw_const PokemonTower7FMrFujiText,  TEXT_POKEMONTOWER7F_MR_FUJI

PokemonTower7TrainerHeaders:
	def_trainers
PokemonTower7TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_7_TRAINER_0, 3, PokemonTower7FChanneler1BattleText, PokemonTower7FChanneler1EndBattleText, PokemonTower7FChanneler1AfterBattleText
PokemonTower7TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_7_TRAINER_1, 3, PokemonTower7FChanneler2BattleText, PokemonTower7FChanneler2EndBattleText, PokemonTower7FChanneler2AfterBattleText
PokemonTower7TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_7_TRAINER_2, 3, PokemonTower7FChanneler3BattleText, PokemonTower7FChanneler3EndBattleText, PokemonTower7FChanneler3AfterBattleText
	db -1 ; end

PokemonTower7FChanneler1Text:
	text_asm
	ld hl, PokemonTower7TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower7FChanneler2Text:
	text_asm
	ld hl, PokemonTower7TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower7FChanneler3Text:
	text_asm
	ld hl, PokemonTower7TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower7FMrFujiText:
	text_asm
	ld hl, .RescueText
	call PrintText
	SetEvent EVENT_RESCUED_MR_FUJI
	SetEvent EVENT_RESCUED_MR_FUJI_2
	ld a, TOGGLE_MR_FUJIS_HOUSE_MR_FUJI
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, TOGGLE_SAFFRON_CITY_E
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_SAFFRON_CITY_F
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, SCRIPT_POKEMONTOWER7F_WARP_TO_MR_FUJI_HOUSE
	ld [wPokemonTower7FCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

.RescueText:
	text_far _PokemonTower7FMrFujiRescueText
	text_end

PokemonTower7FChanneler1BattleText:
	text_far _PokemonTower7FChanneler1BattleText
	text_end

PokemonTower7FChanneler1EndBattleText:
	text_far _PokemonTower7FChanneler1EndBattleText
	text_end

PokemonTower7FChanneler1AfterBattleText:
	text_far _PokemonTower7FChanneler1AfterBattleText
	text_end

PokemonTower7FChanneler2BattleText:
	text_far _PokemonTower7FChanneler2BattleText
	text_end

PokemonTower7FChanneler2EndBattleText:
	text_far _PokemonTower7FChanneler2EndBattleText
	text_end

PokemonTower7FChanneler2AfterBattleText:
	text_far _PokemonTower7FChanneler2AfterBattleText
	text_end

PokemonTower7FChanneler3BattleText:
	text_far _PokemonTower7FChanneler3BattleText
	text_end

PokemonTower7FChanneler3EndBattleText:
	text_far _PokemonTower7FChanneler3EndBattleText
	text_end

PokemonTower7FChanneler3AfterBattleText:
	text_far _PokemonTower7FChanneler3AfterBattleText
	text_end
