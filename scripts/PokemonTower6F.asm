PokemonTower6F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower6TrainerHeaders
	ld de, PokemonTower6F_ScriptPointers
	ld a, [wPokemonTower6FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower6FCurScript], a
	ret

PokemonTower6FSetDefaultScript:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonTower6FCurScript], a ; SCRIPT_POKEMONTOWER6F_DEFAULT
	ld [wCurMapScript], a ; SCRIPT_POKEMONTOWER6F_DEFAULT
	ret

PokemonTower6F_ScriptPointers:
	def_script_pointers
	dw_const PokemonTower6FDefaultScript,           SCRIPT_POKEMONTOWER6F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER6F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONTOWER6F_END_BATTLE
	dw_const PokemonTower6FMathusBattleScript,      SCRIPT_POKEMONTOWER6F_MATHUS_BATTLE

; Formerly the vanilla Marowak-ghost trigger. Now General Mathus, a real
; trainer (not a disguise), commanding a single Nocturn. Same invisible
; coordinate-poll trigger tile as vanilla -- no map object/overworld sprite
; needed for Mathus (data/maps/objects/PokemonTower6F.asm has no bg_events).
PokemonTower6FDefaultScript:
	CheckEvent EVENT_BEAT_GENERAL_MATHUS
	jp nz, CheckFightingMapTrainers
	ld hl, PokemonTower6FMathusCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_POKEMONTOWER6F_MATHUS_INTRO
	ldh [hTextID], a
	call DisplayTextID
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PokemonTower6FMathusFledText
	ld de, PokemonTower6FMathusFledText
	call SaveEndBattleTextPointers
; Start a trainer battle directly, without EngageMapTrainer/a map object --
; same technique gym-leader rematches use (e.g. scripts/PewterGym.asm's
; OPP_BROCK rematch branch): the overworld loop starts a new battle purely
; off wCurOpponent being nonzero (home/overworld.asm), and the trainer/wild
; split is just wCurOpponent's value vs OPP_ID_OFFSET plus wTrainerNo holding
; the party-set index (home/trainers.asm InitBattleEnemyParameters).
	ld a, OPP_GENERALMATHUS
	ld [wCurOpponent], a
	ld a, 1
	ld [wTrainerNo], a
	ld a, SCRIPT_POKEMONTOWER6F_MATHUS_BATTLE
	ld [wPokemonTower6FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower6FMathusCoords:
	dbmapcoord 10, 16
	db -1 ; end

; The battle now ends as a NORMAL trainer victory (the earlier mid-battle
; forced-capture machinery corrupted post-battle overworld state -- see the
; note at HandleEnemyMonFainted in engine/battle/core.asm). Winning IS
; catching: this after-battle script spends the Master Ball and hands over
; Nocturn through the standard GivePokemon flow, then runs the debrief call.
PokemonTower6FMathusBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonTower6FSetDefaultScript
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wStatusFlags3]
	bit BIT_TALKED_TO_TRAINER, a
	ret nz
	call UpdateSprites
; Do NOT leave the d-pad in wJoyIgnore here: the captured-flow text_asm below
; runs real menus (nickname Yes/No + naming screen via GivePokemon, the
; go-rogue Yes/No) and an ignored d-pad locks their cursors while A still
; works -- exactly the "could only pick YES / could only name it AAAA" bug.
; The open text boxes already stop the player from walking.
	xor a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_GENERAL_MATHUS
; Everything that prints or prompts (ball spend, GivePokemon, farewell,
; go-rogue debrief) lives inside the MATHUS_CAPTURED text_asm handler so it
; all runs in DisplayTextID context. Printing from the bare map-script loop
; skips DisplayTextID's shared text/sprite VRAM setup+restore and corrupts
; the overworld (vanished player sprite, garbage animated sprite, stuck
; walk) -- every proven gift/prompt flow in this codebase (Lapras, Nugget
; Bridge choice, Silph 11F after-battle) is text_asm-hosted for this reason.
	ld a, TEXT_POKEMONTOWER6F_MATHUS_CAPTURED
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONTOWER6F_DEFAULT
	ld [wPokemonTower6FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower6F_TextPointers:
	def_text_pointers
	dw_const PokemonTower6FChanneler1Text,      TEXT_POKEMONTOWER6F_CHANNELER1
	dw_const PokemonTower6FChanneler2Text,      TEXT_POKEMONTOWER6F_CHANNELER2
	dw_const PokemonTower6FChanneler3Text,      TEXT_POKEMONTOWER6F_CHANNELER3
	dw_const PickUpItemText,                    TEXT_POKEMONTOWER6F_RARE_CANDY
	dw_const PickUpItemText,                    TEXT_POKEMONTOWER6F_X_ACCURACY
	dw_const PokemonTower6FMathusIntroText,     TEXT_POKEMONTOWER6F_MATHUS_INTRO
	dw_const PokemonTower6FMathusCapturedText,  TEXT_POKEMONTOWER6F_MATHUS_CAPTURED

PokemonTower6TrainerHeaders:
	def_trainers
PokemonTower6TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_6_TRAINER_0, 3, PokemonTower6FChanneler1BattleText, PokemonTower6FChanneler1EndBattleText, PokemonTower6FChanneler1AfterBattleText
PokemonTower6TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_6_TRAINER_1, 3, PokemonTower6FChanneler2BattleText, PokemonTower6FChanneler2EndBattleText, PokemonTower6FChanneler2AfterBattleText
PokemonTower6TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_6_TRAINER_2, 2, PokemonTower6FChanneler3BattleText, PokemonTower6FChanneler3EndBattleText, PokemonTower6FChanneler3AfterBattleText
	db -1 ; end

PokemonTower6FChanneler1Text:
	text_asm
	ld hl, PokemonTower6TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6FChanneler2Text:
	text_asm
	ld hl, PokemonTower6TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6FChanneler3Text:
	text_asm
	ld hl, PokemonTower6TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6FChanneler1BattleText:
	text_far _PokemonTower6FChanneler1BattleText
	text_end

PokemonTower6FChanneler1EndBattleText:
	text_far _PokemonTower6FChanneler1EndBattleText
	text_end

PokemonTower6FChanneler1AfterBattleText:
	text_far _PokemonTower6FChanneler1AfterBattleText
	text_end

PokemonTower6FChanneler2BattleText:
	text_far _PokemonTower6FChanneler2BattleText
	text_end

PokemonTower6FChanneler2EndBattleText:
	text_far _PokemonTower6FChanneler2EndBattleText
	text_end

PokemonTower6FChanneler2AfterBattleText:
	text_far _PokemonTower6FChanneler2AfterBattleText
	text_end

PokemonTower6FChanneler3BattleText:
	text_far _PokemonTower6FChanneler3BattleText
	text_end

PokemonTower6FChanneler3EndBattleText:
	text_far _PokemonTower6FChanneler3EndBattleText
	text_end

PokemonTower6FChanneler3AfterBattleText:
	text_far _PokemonTower6FChanneler3AfterBattleText
	text_end

PokemonTower6FMathusIntroText:
	text_far _PokemonTower6FMathusIntroText
	text_end

; The full post-victory sequence, hosted in text_asm (see the note in
; PokemonTower6FMathusBattleScript): spend the Master Ball, hand over
; Nocturn, Mathus's farewell, then the automatic go-rogue debrief call.
PokemonTower6FMathusCapturedText:
	text_asm
; Spend one Master Ball if the player has one (the story assumes they do by
; this point, but never soft-lock on a missing item).
	ld b, MASTER_BALL
	call IsItemInBag
	jr z, .no_ball
	ld a, MASTER_BALL
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
.no_ball
	ld hl, .ClaimedText
	call PrintText
	lb bc, NOCTURN, 30
	call GivePokemon
	jr nc, .gave_nocturn
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	call EnableAutoTextBoxDrawing
.gave_nocturn
	SetEvent EVENT_GOT_NOCTURN
	ld hl, .FarewellText
	call PrintText
	farcall NocturnGoRogueChoice ; automatic incoming-call debrief
	jp TextScriptEnd

.ClaimedText:
	text "The DEVICE lies"
	line "still."

	para "<PLAYER> threw"
	line "the MASTER BALL!"
	prompt

.FarewellText:
	text_far _PokemonTower6FMathusCapturedText
	text_end

PokemonTower6FMathusFledText:
	text_far _PokemonTower6FMathusFledText
	text_end
