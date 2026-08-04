ArchipelagoCave3F_Script:
; On entry, reveal OAK if the roof MUTAGEN machine has been used.
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	call nz, ArchipelagoCave3FShowOak
	call EnableAutoTextBoxDrawing
	ld hl, ArchipelagoCave3F_ScriptPointers
	ld a, [wApexMartCurScript] ; shared transient endgame script state
	jp CallFunctionInTable

ArchipelagoCave3FShowOak:
	CheckEvent EVENT_USED_MUTAGEN_MACHINE
	ret z
	ld a, TOGGLE_ARCHIPELAGO_CAVE_3F_OAK
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ret

ArchipelagoCave3F_ScriptPointers:
	def_script_pointers
	dw_const ArchipelagoCave3FDefaultScript, SCRIPT_ARCHIPELAGOCAVE3F_DEFAULT
	dw_const ArchipelagoCave3FOakPostBattle, SCRIPT_ARCHIPELAGOCAVE3F_POSTBATTLE

ArchipelagoCave3FDefaultScript:
	ret

ArchipelagoCave3FOakPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ArchipelagoCave3FResetScripts
	SetEvent EVENT_BEAT_OAK
	ld a, TEXT_ARCHIPELAGOCAVE3F_OAK_REWARD
	ldh [hTextID], a
	call DisplayTextID
ArchipelagoCave3FResetScripts:
	xor a
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	ret

ArchipelagoCave3F_TextPointers:
	def_text_pointers
	dw_const ArchipelagoCave3FOakText,       TEXT_ARCHIPELAGOCAVE3F_OAK
	dw_const ArchipelagoCave3FOakRewardText, TEXT_ARCHIPELAGOCAVE3F_OAK_REWARD

ArchipelagoCave3FOakText:
	text_asm
	CheckEvent EVENT_BEAT_OAK
	jr nz, .beaten
	ld hl, .ChallengeText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, .DefeatText
	ld de, .VictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_PROF_OAK
	ld [wCurOpponent], a
	ld a, 4 ; ProfOakData party #4 -- the L100 post-game superboss team
	ld [wTrainerNo], a
	ld a, SCRIPT_ARCHIPELAGOCAVE3F_POSTBATTLE
	ld [wApexMartCurScript], a
	ld [wCurMapScript], a
	jr .done
.beaten
	ld hl, .AfterText
	call PrintText
.done
	jp TextScriptEnd

.ChallengeText:
	text "OAK: So the pups"
	line "sniffed me out."

	para "Every #MON down"
	line "here is MINE now."
	cont "Beaten. Bred."
	cont "Obedient."

	para "Let me show you"
	line "what real power"
	cont "costs."
	prompt

.DefeatText:
	text "Impossible..."
	prompt

.VictoryText:
	text "Kneel."
	prompt

.AfterText:
	text "OAK stands in the"
	line "dark, beaten at"
	cont "last."
	prompt

ArchipelagoCave3FOakRewardText:
; The "ISLAND DEED" is verbal (EVENT_BEAT_OAK gates the Battle Island arena
; -- see scripts/BattleIsland.asm) -- it's never actually put in the bag.
	text_asm
	ld hl, .Text
	call PrintText
	lb bc, METRONOME2, 1
	call GiveItem
	jp TextScriptEnd

.Text:
	text "OAK: Take the"
	line "ISLAND DEED..."

	para "...and this."
	line "METRONOME. My"
	cont "finest work."

	para "The arena is yours"
	line "now. Finish what"
	cont "I began."
	prompt
