_SSOlympiaBowSuperNerdText::
	text "Someone's waiting"
	line "at the bow, they"
	cont "say. For what, I"

	para "couldn't tell you."
	line "Finish your rounds"
	cont "and go look."
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
	text ""
	line "...Futile."
	cont "I should have"
	cont "known. You really"
	cont "are the world's"
	cont "greatest trainer."
	done

_SSOlympiaBowRivalVictoryText::
	text ""
	line "Ha! Not even"
	cont "close."
	done

_SSOlympiaBowSailorBattleText::
	text "Fancy a scrap?"
	done

_SSOlympiaBowSailorEndBattleText::
	text ""
	line "You got me!"
	prompt

_SSOlympiaBowSailorAfterBattleText::
	text "Good match!"
	done

_SSOlympiaBowSwimmerBattleText::
	text "Race me? No--"
	line "let us battle!"
	done

_SSOlympiaBowSwimmerEndBattleText::
	text ""
	line "Out of my depth!"
	prompt

_SSOlympiaBowSwimmerAfterBattleText::
	text "The water is warm"
	line "further south."
	done

_SSOlympiaBowRockerBattleText::
	text "Care for a match?"
	done

_SSOlympiaBowRockerEndBattleText::
	text ""
	line "You got me!"
	prompt

_SSOlympiaBowRockerAfterBattleText::
	text "Good match!"
	done

_SSOlympiaBowJugglerBattleText::
	text "One quick battle?"
	done

_SSOlympiaBowJugglerEndBattleText::
	text "Oh, beaten!"
	prompt

_SSOlympiaBowJugglerAfterBattleText::
	text "Well played!"
	done
