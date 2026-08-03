_SilphCo7FSilphWorkerM1HaveThisPokemonText::
	text "Oh! Hi! You're"
	line "not a ROCKET! You"
	cont "came to save us?"
	cont "Why, thank you!"

	para "I want you to"
	line "have this #MON"
	cont "for saving us."
	prompt

_SilphCo7FSilphWorkerM1LoyalistHaveThisPokemonText::
	text "I don't want to"
	line "die!"

	para "Take my favorite"
	line "Slave, it's all"
	cont "yours!"
	prompt

_SilphCo7FSilphWorkerM1LaprasDescriptionText::
	text "It's LAPRAS. It's"
	line "very intelligent."

	para "We kept it in our"
	line "lab, but it will"
	cont "be much better"
	cont "off with you!"

	para "I think you will"
	line "be a good trainer"
	cont "for LAPRAS!"

	para "It's a good"
	line "swimmer. It'll"
	cont "give you a lift!"
	done

_SilphCo7FSilphWorkerM1LoyalistLaprasDescriptionText::
	text "Just leave!"
	done

_SilphCo7FSilphWorkerM1IsOurPresidentOkText::
	text "TEAM ROCKET's"
	line "BOSS went to the"
	cont "boardroom! Is our"
	cont "PRESIDENT OK?"
	done

_SilphCo7FSilphWorkerM1SavedText::
	text "Saved at last!"
	line "Thank you!"
	done

_SilphCo7FSilphWorkerM2AfterTheMasterBallText::
	text "TEAM ROCKET was"
	line "after the MASTER"
	cont "BALL which will"
	cont "catch any #MON!"
	done

_SilphCo7FSilphWorkerM2CancelledMasterBallText::
	text "We canceled the"
	line "MASTER BALL"
	cont "project because"
	cont "of TEAM ROCKET."
	done

_SilphCo7FSilphWorkerM3ItWouldBeBadText::
	text "It would be bad"
	line "if TEAM ROCKET"
	cont "took over SILPH"
	cont "or our #MON!"
	done

_SilphCo7FSilphWorkerM3YouChasedOffTeamRocketText::
	text "Wow! You chased"
	line "off TEAM ROCKET"
	cont "all by yourself?"
	done

_SilphCo7FSilphWorkerM4ItsReallyDangerousHereText::
	text "You! It's really"
	line "dangerous here!"
	cont "You came to save"
	cont "me? You can't!"
	done

_SilphCo7FSilphWorkerM4SafeAtLastText::
	text "Safe at last!"
	line "Oh thank you!"
	done

_SilphCo7FRocket1BattleText::
	text "Oh ho! I smell a"
	line "little rat!"
	done

_SilphCo7FRocket1LoyalistBattleText::
	text "Oh, it's just"
	line "you."

	para "Thought I smelled"
	line "a rat for a"
	cont "second there."
	done

_SilphCo7FRocket1EndBattleText::
	text "Lights"
	line "out!"
	prompt

_SilphCo7FRocket1AfterBattleText::
	text "You won't find my"
	line "BOSS by just"
	cont "scurrying around!"
	done

_SilphCo7FScientistBattleText::
	text "Heheh!"

	para "You mistook me for"
	line "a SILPH worker?"
	done

_SilphCo7FScientistEndBattleText::
	text "I'm"
	line "done!"
	prompt

_SilphCo7FScientistAfterBattleText::
	text "Despite your age,"
	line "you are a skilled"
	cont "trainer!"
	done

_SilphCo7FRocket2BattleText::
	text "I am one of the 4"
	line "ROCKET BROTHERS!"
	done

_SilphCo7FRocket2LoyalistBattleText::
	text "I am one of the 4"
	line "ROCKET BROTHERS!"

	para "Hah, didn't"
	line "recognize you for"
	cont "a second."
	done

_SilphCo7FRocket2EndBattleText::
	text "Aack!"
	line "Brothers, I lost!"
	prompt

_SilphCo7FRocket2AfterBattleText::
	text "Doesn't matter."
	line "My brothers will"
	cont "repay the favor!"
	done

_SilphCo7FRocket3BattleText::
	text "A child intruder?"
	line "That must be you!"
	done

_SilphCo7FRocket3LoyalistBattleText::
	text "Ha, thought you"
	line "were some kid"
	cont "sneaking around."

	para "Go on, you're"
	line "clear."
	done

_SilphCo7FRocket3EndBattleText::
	text "Fine!"
	line "I lost!"
	prompt

_SilphCo7FRocket3AfterBattleText::
	text "Go on home"
	line "before my BOSS"
	cont "gets ticked off!"
	done

_SilphCo7FRivalText::
	text "<RIVAL>: You are"
	line "slow, <PLAYER>."
	done

_SilphCo7FRivalDefeatedText::
	text "You"
	line "killed my best"
	cont "slave."

	para "I'll take its"
	line "ashes to"
	cont "LAVENDER."
	prompt

_SilphCo7FRivalVictoryText::
	text "<RIVAL>: You came"
	line "all this way to"
	cont "lose?"

	para "Go home,"
	line "<PLAYER>."
	prompt

; Path-conditional rival lines (see scripts/SilphCo7F.asm). Pre-battle:
_SilphCo7FRivalHeroPreText::
	text "<RIVAL>: OAK sent"
	line "you here too?"

	para "Doesn't he trust"
	line "me?"
	done

_SilphCo7FRivalLoyalistPreText::
	text "<RIVAL>: You"
	line "joined TEAM"
	cont "ROCKET?"

	para "Why?? <PLAYER>,"
	line "why??"
	done

; After you beat him:
_SilphCo7FRivalHeroWinText::
	text "<RIVAL>: Fine."

	para "The reward is all"
	line "yours then."

	para "Take out BOSS"
	line "ROCKET."
	done

_SilphCo7FRivalLoyalistWinText::
	text "<RIVAL>: Fine."
	line "Go on then."

	para "I'll tell OAK all"
	line "about your"
	cont "new...family."
	done

_SilphCo7FRivalStarterDeathText::
	text "..."

	para "Wait."
	line "What's wrong?"

	para "Hey! Come on!"
	line "Get up!"

	para "..."
	line "No..."
	cont "Don't do this."

	para "..."
	done

_SilphCo7FFlavorRocketText::
	text "Cute clipboard."

	para "Won't stop a"
	line "TEAM ROCKET"
	cont "takeover."
	done

_SilphCo7FFlavorScientistText::
	text "I've locked every"
	line "cage twice."

	para "You're not"
	line "getting past me."
	done

; Loyalist path: SILPH staff standing where the ROCKETs stand on the hero path.

_SilphCo7FDefender1BattleText::
	text "You're the one"
	line "they let in the"
	cont "front door."
	done

_SilphCo7FDefender1EndBattleText::
	text "We should have"
	line "locked it."
	prompt

_SilphCo7FDefender1AfterBattleText::
	text "Everyone above me"
	line "is unarmed."
	cont "Remember that."
	done


_SilphCo7FDefender2BattleText::
	text "My family is on"
	line "the eighth floor."
	cont "Turn around."
	done

_SilphCo7FDefender2EndBattleText::
	text "Please..."
	prompt

_SilphCo7FDefender2AfterBattleText::
	text "If you go up"
	line "there, don't let"
	cont "them see you."
	done


_SilphCo7FDefender3BattleText::
	text "I've seen what"
	line "your lot do to"
	cont "#MON."
	done

_SilphCo7FDefender3EndBattleText::
	text "And now to me."
	prompt

_SilphCo7FDefender3AfterBattleText::
	text "We fed them. We"
	line "named them. You"
	cont "just take them."
	done

_SilphCo7FScientistLoyalistBattleText::
	text "I'm a researcher,"
	line "not a target."

	para "Back out of my"
	line "lab."
	done
