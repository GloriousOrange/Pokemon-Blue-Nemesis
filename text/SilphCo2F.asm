SilphCo2FSilphWorkerFPleaseTakeThisText::
	text "Eeek!"
	line "No! Stop! Help!"

	para "Oh, you're not"
	line "with TEAM ROCKET."
	cont "I thought..."
	cont "I'm sorry. Here,"
	cont "please take this!"
	prompt

_SilphCo2FSilphWorkerFReceivedTM36Text::
	text "<PLAYER> got"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_SilphCo2FSilphWorkerFTM36ExplanationText::
	text "TM36 is"
	line "SELFDESTRUCT!"

	para "It's powerful, but"
	line "the #MON that"
	cont "uses it faints!"
	cont "Be careful."
	done

_SilphCo2FSilphWorkerFTM36NoRoomText::
	text "You don't have any"
	line "room for this."
	done

_SilphCo2FScientist1BattleText::
	text "Help! I'm a SILPH"
	line "employee."
	done

_SilphCo2FScientist1EndBattleText::
	text "How"
	line "did you know I"
	cont "was a ROCKET?"
	prompt

_SilphCo2FScientist1AfterBattleText::
	text "I work for both"
	line "SILPH and TEAM"
	cont "ROCKET!"
	done

_SilphCo2FScientist2BattleText::
	text "It's off limits"
	line "here! Go home!"
	done

_SilphCo2FScientist2EndBattleText::
	text "You're"
	line "good."
	prompt

_SilphCo2FScientist2AfterBattleText::
	text "Can you solve the"
	line "maze in here?"
	done

_SilphCo2FRocket1BattleText::
	text "No kids are"
	line "allowed in here!"
	done

_SilphCo2FRocket1LoyalistBattleText::
	text "SILPH's got"
	line "layers, and so do"
	cont "we."

	para "Show me you can"
	line "climb them."
	done

_SilphCo2FRocket1EndBattleText::
	text "Tough!"
	prompt

_SilphCo2FRocket1AfterBattleText::
	text "Diamond shaped"
	line "tiles are"
	cont "teleport blocks!"

	para "They're hi-tech"
	line "transporters!"
	done

_SilphCo2FRocket2BattleText::
	text "Hey kid! What are"
	line "you doing here?"
	done

_SilphCo2FRocket2LoyalistBattleText::
	text "Every floor we"
	line "hold is a floor"
	cont "OAK doesn't."

	para "Prove you deserve"
	line "to be here."
	done

_SilphCo2FRocket2EndBattleText::
	text "I goofed!"
	prompt

_SilphCo2FRocket2AfterBattleText::
	text "SILPH CO. will"
	line "be merged with"
	cont "TEAM ROCKET!"
	done

_SilphCo2FFlavorRocketText::
	text "This floor's"
	line "ours by lunch."

	para "Scientists don't"
	line "get severance."
	done

_SilphCo2FFlavorRocketLoyalistText::
	text "Didn't recognize"
	line "you at first."

	para "Go on, hit me"
	line "with your best"
	cont "shot."
	done

_SilphCo2FFlavorScientistText::
	text "We won't let you"
	line "steal OAK's work."

	para "Not one more"
	line "cage unlocked!"
	done

; Shared end/after-battle lines for the converted flavor Rocket/Scientist NPCs
; across the Silph floors (referenced from 2F/8F/9F scripts).
_SilphFlavorRocketEndText::
	text "Tch... you hit"
	line "harder than the"
	cont "boss lets on."
	done

_SilphFlavorRocketAfterText::
	text "Fine. This floor's"
	line "yours. For now."
	done

_SilphFlavorScientistEndText::
	text "No... OAK's work"
	line "must be protected!"
	done

_SilphFlavorScientistAfterText::
	text "Do what you want."
	line "The truth is"
	cont "already loose."
	done

; Loyalist path: SILPH staff standing where the ROCKETs stand on the hero path.

_SilphCo2FDefender1BattleText::
	text "This is a SILPH"
	line "building. You are"
	cont "trespassing."
	done

_SilphCo2FDefender1EndBattleText::
	text "I only work here!"
	prompt

_SilphCo2FDefender1AfterBattleText::
	text "Take the stairs."
	line "Take everything."
	cont "Just go."
	done


_SilphCo2FDefender2BattleText::
	text "SECURITY! There's"
	line "a ROCKET on the"
	cont "second floor!"
	done

_SilphCo2FDefender2EndBattleText::
	text "No one is coming,"
	line "are they."
	prompt

_SilphCo2FDefender2AfterBattleText::
	text "The phones are"
	line "dead. You cut the"
	cont "lines first."
	done

