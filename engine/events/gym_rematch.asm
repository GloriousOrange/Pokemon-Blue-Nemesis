; Shared post-game gym-leader rematch logic (Phase 5 backbone).
; After the Champion is beaten (wPostGameMisc bit BIT_POST_GAME_STARTED), the 7
; standard gym leaders (Brock..Blaine; Giovanni is the arena boss instead) offer
; a rematch with their L65-70 teams. Re-beating all 7 grants the LAB KEY.

; Caller has already set wCurOpponent + wTrainerNo to the leader's rematch party,
; and will set its map CurScript to the rematch-defeated state right after this.
GymLeaderRematchInit::
	ld hl, GymRematchChallengeText
	call PrintText
	ld a, 1
	ld [wGymLeaderNo], a
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, GymRematchWinText
	ld de, GymRematchLoseText
	jp SaveEndBattleTextPointers

; Called from a leader's rematch-defeated script AFTER it has set that leader's
; bit in wGymRematchFlags. When all 7 standard leaders are re-beaten, hand over
; the LAB KEY (this completes exactly once).
PostGameCheckAllGymsRebeaten::
	ld a, [wGymRematchFlags]
	cp %01111111 ; all 7 standard leaders re-beaten?
	ret nz
	ld hl, wPostGameMisc
	set BIT_OAK_ISLAND_UNLOCKED, [hl] ; opens the Pallet ferry to Oak's island
	lb bc, LAB_KEY, 1
	call GiveItem
	ld hl, GymRematchLabKeyText
	jp PrintText

GymRematchChallengeText:
	text "So you're back"
	line "for more!"

	para "Let's see how"
	line "much stronger"
	cont "you've grown!"
	prompt

GymRematchWinText:
	text "Incredible! You"
	line "really have"
	cont "surpassed me!"
	prompt

GymRematchLoseText:
	text "Hah! Come back"
	line "when you're"
	cont "tougher!"
	prompt

GymRematchLabKeyText:
	text "You've bested"
	line "every leader"
	cont "again!"

	para "Take the LAB KEY."
	line "The truth waits"
	cont "on CINNABAR..."
	prompt
