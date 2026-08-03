; Shared post-game "burned lab" scientist battles (Phase 5).
; 6 scientists are scattered across the re-locked Pokemon Mansion floors (see
; ScientistData party #14-19 in data/trainers/parties.asm). Each is a one-time
; battle; beating one hands over a LEVEL_STONE and marks that scientist's bit
; in wScientistsDefeated. All 6 beaten unlocks the level-100 machine (see
; BIT_LEVEL_MACHINE_READY in item_effects.asm's ItemUseLevelStoneFromBag).

; Caller has already set wCurOpponent + wTrainerNo to the scientist's party,
; and will set its map CurScript to the win-handling state right after this.
LabScientistBattleInit::
; c = scientist index (0-5, == its wScientistsDefeated bit); selects this
; scientist's unique pre-battle challenge text and post-battle win text.
; (c survives farcall -- the macro only uses b + hl.)
	push bc            ; save the index across PrintText
	ld b, 0
	ld hl, LabScientistChallengeTexts
	add hl, bc
	add hl, bc         ; + 2*index (2-byte pointers)
	ld a, [hli]
	ld h, [hl]
	ld l, a            ; hl = this scientist's challenge text
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	pop bc             ; restore index
	ld b, 0
	ld hl, LabScientistWinTexts
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a            ; hl = this scientist's win text
	ld de, LabScientistLoseText ; lose text stays shared
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

; Per-scientist text, indexed by scientist number 0-5 (== wScientistsDefeated
; bit): 0 Porygon(1F) 1 Electrode(2F) 2 Magneton(2F) 3 Alakazam(3F)
; 4 Gengar(B1F) 5 Ditto(B1F). Win text is shown as end-battle text, so the
; game prefixes it with "SCIENTIST: " -- keep each win's FIRST line short.
LabScientistChallengeTexts:
	dw LabScientist0ChallengeText
	dw LabScientist1ChallengeText
	dw LabScientist2ChallengeText
	dw LabScientist3ChallengeText
	dw LabScientist4ChallengeText
	dw LabScientist5ChallengeText

LabScientistWinTexts:
	dw LabScientist0WinText
	dw LabScientist1WinText
	dw LabScientist2WinText
	dw LabScientist3WinText
	dw LabScientist4WinText
	dw LabScientist5WinText

; --- 0: Porygon (1F) -- digital / data ---
LabScientist0ChallengeText:
	text "Your #MON is"
	line "analog. Soft."
	cont "Mortal."

	para "We compiled"
	line "something cleaner."
	cont "Hold still while"
	cont "I overwrite you."
	prompt
LabScientist0WinText:
	text "Odd."

	para "Your data holds"
	line "patterns ours"
	cont "never could."

	para "OAK must see this."
	prompt

; --- 1: Electrode (2F) -- stored energy / discharge ---
LabScientist1ChallengeText:
	text "A #MON is just"
	line "stored energy"
	cont "waiting to escape."

	para "Let's see how much"
	line "of yours I can"
	cont "let out at once."
	prompt
LabScientist1WinText:
	text "Held."

	para "You took a full"
	line "discharge and"
	cont "stayed standing."

	para "The readouts said"
	line "you couldn't."
	prompt

; --- 2: Magneton (2F) -- assembly / machine ---
LabScientist2ChallengeText:
	text "Life is only parts"
	line "assembled by"
	cont "accident."

	para "Stand still. I'll"
	line "correct how yours"
	cont "was put together."
	prompt
LabScientist2WinText:
	text "Bent."

	para "You pulled my poles"
	line "apart like they"
	cont "were nothing."

	para "What ARE your"
	line "#MON made of?"
	prompt

; --- 3: Alakazam (3F) -- foreseen outcomes ---
LabScientist3ChallengeText:
	text "I have already"
	line "read this battle"
	cont "to its end."

	para "You lose in every"
	line "future but the"
	cont "ones I refuse to"
	cont "picture."
	prompt
LabScientist3WinText:
	text "...Ah."

	para "One of the futures"
	line "I refused to"
	cont "picture."

	para "I will not forget"
	line "you. I cannot."
	prompt

; --- 4: Gengar (B1F) -- death / lingering ---
LabScientist4ChallengeText:
	text "We ended things"
	line "here, just to see"
	cont "what lingered."

	para "Plenty lingered."
	line "Go say hello on"
	cont "your way down."
	prompt
LabScientist4WinText:
	text "Cold."

	para "You battle like"
	line "something that's"
	cont "died once already."

	para "You'll fit in"
	line "down here."
	prompt

; --- 5: Ditto (B1F) -- imitation / Mew blueprint ---
LabScientist5ChallengeText:
	text "MEW could become"
	line "anything alive."

	para "So can this. So"
	line "can I, given your"
	cont "#MON to copy."
	prompt
LabScientist5WinText:
	text "Clean."

	para "I'll wear this win"
	line "of yours until it"
	cont "stops fitting."

	para "Take the stone."
	line "We're done."
	prompt

LabScientistLoseText:
	text "Not yet perfect,"
	line "I'm afraid."

	para "Come back when"
	line "there's more of"
	cont "it to measure."
	prompt

LabScientistReceivedStoneText:
	text "You received a"
	line "MUTAGENSTONE!"
	prompt

LabScientistStoneNoRoomText:
	text "You have no room"
	line "for a MUTAGENSTONE!"
	prompt
