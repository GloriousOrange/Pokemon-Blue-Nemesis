_PokemonMansion1FScientistBattleText::
	text "Who are you? This"
	line "wing was sealed"
	cont "shut for a reason."
	done

_PokemonMansion1FScientistEndBattleText::
	text "Ouch!"
	prompt

_PokemonMansion1FScientistAfterBattleText::
	text "A key? I don't"
	line "know what you're"
	cont "talking about."
	done

_PokemonMansion1FLabScientistAfterBeatText::
	text "Every #MON is"
	line "just a rough"
	cont "draft of MEW."

	para "We're only here"
	line "to finish the"
	cont "final copy."
	done

_PokemonMansion1FSwitchText::
	text "A secret switch!"

	para "Press it?"
	done

_PokemonMansion1FSwitchPressedText::
	text "Who wouldn't?"
	prompt

_PokemonMansion1FSwitchNotPressedText::
	text "Not quite yet!"
	done

_PokemonMansion1FRivalAmbushText::
	text "<RIVAL>: Found"
	line "you! I'm here"
	cont "for revenge."

	para "I promised OAK I"
	line "wouldn't use his"
	cont "strongest monster"
	cont "against you,"

	para "BUT I LIED!"
	done

_PokemonMansion1FRivalDefeatedText::
	text "No..."
	line "Even MEWTWO"
	cont "wasn't enough!"
	prompt

_PokemonMansion1FRivalVictoryText::
; his gloat on a loss -- shown via SaveEndBattleTextPointers while the
; battle screen is still up, so TrainerEndBattleText auto-prefixes it with
; "<RIVAL>: " (his name, ~7 chars) + ": " before the first line even starts;
; keep the first line short (see the Loyalist Scientist name-prefix gotcha).
	text "You got"
	line "what you"
	cont "deserved."

	para "An eye for"
	line "an eye."
	prompt

_PokemonMansion1FRivalAfterBattleText::
	text "<RIVAL>: This"
	line "changes nothing."

	para "Watch your back,"
	line "<PLAYER>."
	done

_PokemonMansion1FRivalRaticateGiftText::
	text "<RIVAL>: Looks"
	line "like your only"
	cont "slave is dead."

	para "You can have"
	line "this one, I'm"
	cont "not going to"
	cont "use it."
	done

_PokemonMansion1FStarterPerishedText::
	text "Your starter,"
	line "@"
	text_ram wNameBuffer
	text_start
	cont "has perished."

	para "You gather its"
	line "ashes into an"
	cont "urn."
	done
