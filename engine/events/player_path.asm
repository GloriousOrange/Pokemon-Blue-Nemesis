; Player allegiance / branching-path helpers (Pokemon Nemesis).
;
; Path state lives in wPostGameMisc: BIT_ROCKET_LOYALTY (joined Team Rocket at
; Nugget Bridge = Loyalist, clear = Hero) and BIT_PLAYER_TRAITOR (went rogue at
; the Nocturn beat = Traitor, which overrides allegiance). Hero is the default
; from game start (see LoadWalkingPlayerSpriteGraphics: Scientist by default,
; Rocket grunt when loyal).

; Returns the current path in a: 0 = Hero, 1 = Loyalist, 2 = Traitor.
; Traitor takes precedence over the Loyalist/Hero split.
GetPlayerPath::
	ld a, [wPostGameMisc]
	bit BIT_PLAYER_TRAITOR, a
	jr nz, .traitor
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	xor a ; Hero
	ret
.loyalist
	ld a, 1
	ret
.traitor
	ld a, 2
	ret

; The go-rogue beat, to be `callfar`'d from the Nocturn-obtain script once that
; content exists. Presents the "report to your boss vs block the number and go
; rogue" choice: YES keeps you on your current path (Hero -> Oak, Loyalist ->
; Giovanni); NO blocks the number and sets BIT_PLAYER_TRAITOR (Traitor path,
; reachable from either prior path). Not yet wired to a caller.
NocturnGoRogueChoice::
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld hl, NocturnReportOakText
	jr z, .gotPrompt
	ld hl, NocturnReportGiovanniText
.gotPrompt
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES (report in, stay on your path)
	jr nz, .goRogue
	ld hl, NocturnReportedText
	jp PrintText
.goRogue
	ld hl, wPostGameMisc
	set BIT_PLAYER_TRAITOR, [hl]
	ld hl, NocturnGoRogueText
	jp PrintText

NocturnReportOakText:
	text "NOCTURN is yours."
	para "Call PROF.OAK and"
	line "report the weapon"
	cont "is secured?"
	done

NocturnReportGiovanniText:
	text "NOCTURN is yours."
	para "Call GIOVANNI and"
	line "report the weapon"
	cont "is secured?"
	done

NocturnReportedText:
	text "You report in."
	para "Your orders stand."
	line "For now, you serve"
	cont "another's will."
	done

NocturnGoRogueText:
	text "You block the"
	line "number."
	para "No OAK. No"
	line "GIOVANNI. NOCTURN"
	cont "answers to you"
	cont "alone now."
	done
