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

_SSOlympiaBowRocket1BattleText::
	text "Another"
	line "do-gooder, huh?"
	cont "Let's see what"
	cont "you've got."
	done

_SSOlympiaBowRocket1EndBattleText::
	text "Not bad. Still"
	line "won't save you"
	cont "from what's up"
	cont "top."
	prompt

_SSOlympiaBowRocket1AfterBattleText::
	text "...Whatever. Move"
	line "along."
	done

_SSOlympiaBowRocket2BattleText::
	text "Halt! Nobody sets"
	line "foot on the S.S."
	cont "OLYMPIA without"
	cont "the boss's"
	cont "say-so!"
	done

_SSOlympiaBowRocket2EndBattleText::
	text "Ugh! I'm just a"
	line "grunt, I don't"
	cont "get paid enough"
	cont "for this!"
	prompt

_SSOlympiaBowRocket2AfterBattleText::
	text "Just get out of"
	line "my sight."
	done

