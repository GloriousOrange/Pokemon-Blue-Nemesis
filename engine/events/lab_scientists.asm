; Shared post-game "burned lab" scientist battles (Phase 5).
; 6 scientists are scattered across the re-locked Pokemon Mansion floors (see
; ScientistData party #14-19 in data/trainers/parties.asm). Each is a one-time
; battle; beating one hands over a LEVEL_STONE and marks that scientist's bit
; in wScientistsDefeated. All 6 beaten unlocks the level-100 machine (see
; BIT_LEVEL_MACHINE_READY in item_effects.asm's ItemUseLevelStoneFromBag).

; Caller has already set wCurOpponent + wTrainerNo to the scientist's party,
; and will set its map CurScript to the win-handling state right after this.
LabScientistBattleInit::
	ld hl, LabScientistChallengeText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, LabScientistWinText
	ld de, LabScientistLoseText
	jp SaveEndBattleTextPointers

; Called from a scientist's post-battle script after a win, once the caller
; has already `set <bit>, [wScientistsDefeated]`. Gives a LEVEL_STONE and
; prints the appropriate follow-up text.
LabScientistGiveStone::
	lb bc, LEVEL_STONE, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, LabScientistReceivedStoneText
	jp PrintText
.BagFull
	ld hl, LabScientistStoneNoRoomText
	jp PrintText

LabScientistChallengeText:
	text "You'll need to"
	line "beat me to prove"
	cont "you're worthy of"
	cont "our research!"
	prompt

LabScientistWinText:
	text "Incredible power!"
	line "Our data was"
	cont "right about you."
	prompt

LabScientistLoseText:
	text "Hmph. Come back"
	line "when you're"
	cont "stronger."
	prompt

LabScientistReceivedStoneText:
	text "You received a"
	line "LEVEL STONE!"
	prompt

LabScientistStoneNoRoomText:
	text "You have no room"
	line "for a LEVEL STONE!"
	prompt
