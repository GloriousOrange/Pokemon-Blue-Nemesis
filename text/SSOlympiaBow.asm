_SSOlympiaBowSuperNerdText::
	text "That trainer's"
	line "been at the bow"
	cont "since we sailed."

	para "He isn't here to"
	line "relax like us."
	done

; UNREACHABLE: the bird object is parked OFF (the rival no longer flies in and
; transforms). Kept because the object and its text pointer must stay in place
; -- deleting the toggle would renumber every later global toggle index and
; break saves.
_SSOlympiaBowBirdText::
	text "The bird's eyes"
	line "follow you. It"
	cont "doesn't fly off."
	done

_SSOlympiaBowRivalAmbushText::
	text "I've been busy in"
	line "the lab, creating"
	cont "a new monstrosity!"

	para "Behold!"
	done

; SaveEndBattleTextPointers auto-prefixes "<RIVAL>: " (~8 chars) to line 1,
; so line 1's own content stays short -- see the Mathus end-battle-text gotcha.
_SSOlympiaBowRivalDefeatedText::
	text "...Futile."
	line "I should have"
	cont "known. You really"
	cont "are the world's"
	cont "greatest trainer."
	done

_SSOlympiaBowRivalVictoryText::
	text "Ha! Not even"
	line "close."
	done

_SSOlympiaBowSailorBattleText::
	text "Fancy a scrap?"
	done

_SSOlympiaBowSailorEndBattleText::
	text "You got me!"
	prompt

_SSOlympiaBowSailorAfterBattleText::
	text "Good match!"
	done

_SSOlympiaBowSwimmerBattleText::
	text "Race me? No--"
	line "let us battle!"
	done

_SSOlympiaBowSwimmerEndBattleText::
	text "Out of my depth!"
	prompt

_SSOlympiaBowSwimmerAfterBattleText::
	text "The water is warm"
	line "further south."
	done
