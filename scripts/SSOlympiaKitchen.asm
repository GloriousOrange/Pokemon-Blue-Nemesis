SSOlympiaKitchen_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSOlympiaKitchenTrainerHeaders
	ld de, SSOlympiaKitchen_ScriptPointers
	ld a, [wSSOlympiaKitchenCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSOlympiaKitchenCurScript], a
	ret

SSOlympiaKitchen_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SSOLYMPIAKITCHEN_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SSOLYMPIAKITCHEN_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SSOLYMPIAKITCHEN_END_BATTLE

SSOlympiaKitchen_TextPointers:
	def_text_pointers
	dw_const SSOlympiaKitchenCook1Text, TEXT_SSOLYMPIAKITCHEN_COOK1
	dw_const SSOlympiaKitchenCook2Text, TEXT_SSOLYMPIAKITCHEN_COOK2
	dw_const SSOlympiaKitchenCook3Text, TEXT_SSOLYMPIAKITCHEN_COOK3
	dw_const SSOlympiaKitchenCook4Text, TEXT_SSOLYMPIAKITCHEN_COOK4
	dw_const SSOlympiaKitchenCook5Text, TEXT_SSOLYMPIAKITCHEN_COOK5
	dw_const SSOlympiaKitchenCook6Text, TEXT_SSOLYMPIAKITCHEN_COOK6
	dw_const SSOlympiaKitchenCook7Text, TEXT_SSOLYMPIAKITCHEN_COOK7
	dw_const SSOlympiaKitchenBeautyText, TEXT_SSOLYMPIAKITCHEN_BEAUTY

SSOlympiaKitchenTrainerHeaders:
	def_trainers 5
SSOlympiaKitchenTrainerHeader0:
	trainer EVENT_BEAT_SS_OLYMPIA_KITCHEN_TRAINER_0, 3, SSOlympiaKitchenBeautyBattleText, SSOlympiaKitchenBeautyEndBattleText, SSOlympiaKitchenBeautyAfterBattleText
	db -1 ; end

SSOlympiaKitchenCook1Text:
	text_far _SSOlympiaKitchenCook1Text
	text_end
SSOlympiaKitchenCook2Text:
	text_far _SSOlympiaKitchenCook2Text
	text_end
SSOlympiaKitchenCook3Text:
	text_far _SSOlympiaKitchenCook3Text
	text_end
SSOlympiaKitchenCook4Text:
	text_far _SSOlympiaKitchenCook4Text
	text_end
SSOlympiaKitchenCook5Text:
	text_far _SSOlympiaKitchenCook5Text
	text_end
SSOlympiaKitchenCook6Text:
	text_far _SSOlympiaKitchenCook6Text
	text_end
SSOlympiaKitchenCook7Text:
	text_far _SSOlympiaKitchenCook7Text
	text_end
SSOlympiaKitchenBeautyText:
	text_asm
	ld hl, SSOlympiaKitchenTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd


SSOlympiaKitchenBeautyBattleText:
	text_far _SSOlympiaKitchenBeautyBattleText
	text_end

SSOlympiaKitchenBeautyEndBattleText:
	text_far _SSOlympiaKitchenBeautyEndBattleText
	text_end

SSOlympiaKitchenBeautyAfterBattleText:
	text_far _SSOlympiaKitchenBeautyAfterBattleText
	text_end

