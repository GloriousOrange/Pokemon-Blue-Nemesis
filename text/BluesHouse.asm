_BluesHouseDaisyRivalAtLabText::
	text "Hello neighbor."
	line "Your brother is"
	cont "waiting for you"
	cont "in the lab."
	done

_BluesHouseDaisyOfferMapText::
	text "Grandpa asked you"
	line "to run an errand?"
	cont "Here, this will"
	cont "help you!"
	prompt

_GotMapText::
	text "<PLAYER> got a"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_BluesHouseDaisyBagFullText::
	text "You have too much"
	line "stuff with you."
	done

_BluesHouseDaisyUseMapText::
	text "I heard you and"
	line "your brother"
	cont "intend to leave."

	para "Be safe, please."
	done

_BluesHouseDaisyWalkingText::
	text "#MON are living"
	line "things! If they"
	cont "get tired, give"
	cont "them a rest!"
	done

_BluesHouseTownMapText::
	text "Sometimes I dream"
	line "of leaving this"
	cont "place."

	para "But grandfather"
	line "won't let people"
	cont "leave..."
	done
