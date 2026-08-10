"""Human-readable descriptions for every move effect, for the team builder.

Gen 1 has no in-game move descriptions to scrape, so these are written here
and keyed by the effect constant each move carries in data/moves/moves.asm.
That means a move added later inherits a correct description for free, and a
move whose *effect* is retargeted gets the new text automatically.

Everything below is checked against the engine, not assumed from vanilla --
Nemesis changes several of these. The probabilities come from
engine/battle/effects.asm: SIDE_EFFECT1 is 10%, SIDE_EFFECT2 is 30%, stat
side effects are 33%, and the poison and flinch families are special-cased.

MOVE_DESCRIPTIONS overrides EFFECT_DESCRIPTIONS for the handful of moves the
engine singles out by name.
"""

# --- effect -> description ---------------------------------------------------

def _stat_up(stat, stages):
    s = "1 stage" if stages == 1 else f"{stages} stages"
    return f"Raises the user's {stat} by {s}."


def _stat_down(stat, stages):
    s = "1 stage" if stages == 1 else f"{stages} stages"
    return f"Lowers the target's {stat} by {s}."


def _stat_down_side(stat):
    return f"Has a 33% chance to lower the target's {stat} by 1 stage."


EFFECT_DESCRIPTIONS = {
    "NO_ADDITIONAL_EFFECT": "Straight damage with no secondary effect.",

    # --- status, guaranteed ---
    "SLEEP_EFFECT": "Puts the target to sleep for 1-7 turns. It cannot act "
                    "until it wakes.",
    "POISON_EFFECT": "Poisons the target, costing it 1/16 of its max HP each "
                     "turn. Toxic instead doubles the damage every turn.",
    "PARALYZE_EFFECT": "Paralyzes the target: its Speed is quartered and it "
                       "loses a quarter of its turns outright.",
    "CONFUSION_EFFECT": "Confuses the target. For 2-5 turns it has a 50% "
                        "chance each turn to hit itself instead.",

    # --- status, chance on hit ---
    "POISON_SIDE_EFFECT1": "Always poisons the target -- Nemesis removed the "
                           "chance roll from this one.",
    "POISON_SIDE_EFFECT2": "Has a 40% chance to poison the target.",
    "BURN_SIDE_EFFECT1": "Has a 10% chance to burn the target, halving its "
                         "Attack and costing it HP each turn.",
    "BURN_SIDE_EFFECT2": "Has a 30% chance to burn the target, halving its "
                         "Attack and costing it HP each turn.",
    "FREEZE_SIDE_EFFECT1": "Has a 10% chance to freeze the target solid. In "
                           "Gen 1 a frozen Pokemon never thaws on its own.",
    "FREEZE_SIDE_EFFECT2": "Has a 30% chance to freeze the target solid. In "
                           "Gen 1 a frozen Pokemon never thaws on its own.",
    "PARALYZE_SIDE_EFFECT1": "Has a 10% chance to paralyze the target.",
    "PARALYZE_SIDE_EFFECT2": "Has a 30% chance to paralyze the target.",
    "CONFUSION_SIDE_EFFECT": "Has a 10% chance to confuse the target.",
    "FLINCH_SIDE_EFFECT1": "Has a 10% chance to make the target flinch, "
                           "losing its turn -- but only if the user moves "
                           "first.",
    "FLINCH_SIDE_EFFECT2": "Has a 30% chance to make the target flinch, "
                           "losing its turn -- but only if the user moves "
                           "first.",
    "TWINEEDLE_EFFECT": "Strikes twice in one turn, and the second hit has a "
                        "50% chance to poison.",

    # --- multi-hit and multi-turn ---
    "TWO_TO_FIVE_ATTACKS_EFFECT": "Hits 2-5 times in one turn: 3/8 odds each "
                                  "of 2 and 3 hits, 1/8 each of 4 and 5. "
                                  "Averages 3.",
    "ATTACK_TWICE_EFFECT": "Strikes twice in a single turn.",
    "TRAPPING_EFFECT": "Locks the target in place for 2-5 turns, damaging it "
                       "each turn. It cannot move at all while trapped -- but "
                       "neither can the user.",
    "THRASH_PETAL_DANCE_EFFECT": "Attacks for 3-4 turns without stopping, "
                                 "then leaves the user confused.",
    "CHARGE_EFFECT": "Spends the first turn charging and strikes on the "
                     "second.",
    "FLY_EFFECT": "The user vanishes for a turn, dodging almost everything, "
                  "then strikes on the second.",
    "HYPER_BEAM_EFFECT": "Devastating, but the user must spend the next turn "
                         "recharging and cannot act.",
    "BIDE_EFFECT": "The user absorbs hits for 2-3 turns, then deals back "
                   "double everything it took.",
    "RAGE_EFFECT": "The user locks into this move, and its Attack rises every "
                   "time it is hit.",

    # --- fixed and fractional damage ---
    "SPECIAL_DAMAGE_EFFECT": "Deals a fixed amount of damage that ignores "
                             "both Pokemon's stats and type matchups.",
    "SUPER_FANG_EFFECT": "Halves the target's current HP, whatever that is. "
                         "Ignores type matchups.",
    "OHKO_EFFECT": "Knocks the target out in one hit if it connects, but "
                   "fails outright against anything faster than the user.",
    "DREAM_EATER_EFFECT": "Only works on a sleeping target, and heals the "
                          "user for half the damage dealt.",
    "DRAIN_HP_EFFECT": "Heals the user for half the damage dealt.",
    "RECOIL_EFFECT": "The user takes a quarter of the damage it deals as "
                     "recoil.",
    "JUMP_KICK_EFFECT": "If it misses, the user crashes and takes 1 HP of "
                        "damage.",
    "EXPLODE_EFFECT": "Halves the target's Defense for this hit, then knocks "
                      "the user out.",

    # --- accuracy and targeting ---
    "SWIFT_EFFECT": "Never misses, no matter the target's evasion.",

    # --- healing and protection ---
    # REST shares this effect but has its own override below, so this text does
    # not need to mention it.
    "HEAL_EFFECT": "Restores half the user's max HP.",
    "SUBSTITUTE_EFFECT": "Spends a quarter of the user's max HP to put up a "
                         "decoy that soaks damage and blocks status.",
    "LIGHT_SCREEN_EFFECT": "Halves special damage taken for the rest of the "
                           "battle.",
    "REFLECT_EFFECT": "Halves physical damage taken for the rest of the "
                      "battle.",
    "MIST_EFFECT": "Blocks stat-lowering moves for the rest of the battle.",
    "HAZE_EFFECT": "Wipes every stat change on both sides back to neutral, "
                   "and clears status.",

    # --- stat stages, user ---
    "ATTACK_UP1_EFFECT": _stat_up("Attack", 1),
    "ATTACK_UP2_EFFECT": _stat_up("Attack", 2),
    "DEFENSE_UP1_EFFECT": _stat_up("Defense", 1),
    "DEFENSE_UP2_EFFECT": _stat_up("Defense", 2),
    "SPEED_UP1_EFFECT": _stat_up("Speed", 1),
    "SPEED_UP2_EFFECT": _stat_up("Speed", 2),
    "SPECIAL_UP1_EFFECT": _stat_up("Special", 1),
    "SPECIAL_UP2_EFFECT": _stat_up("Special", 2),
    "ACCURACY_UP1_EFFECT": _stat_up("accuracy", 1),
    "ACCURACY_UP2_EFFECT": _stat_up("accuracy", 2),
    "EVASION_UP1_EFFECT": _stat_up("evasion", 1),
    "EVASION_UP2_EFFECT": _stat_up("evasion", 2),

    # --- stat stages, target ---
    "ATTACK_DOWN1_EFFECT": _stat_down("Attack", 1),
    "ATTACK_DOWN2_EFFECT": _stat_down("Attack", 2),
    "DEFENSE_DOWN1_EFFECT": _stat_down("Defense", 1),
    "DEFENSE_DOWN2_EFFECT": _stat_down("Defense", 2),
    "SPEED_DOWN1_EFFECT": _stat_down("Speed", 1),
    "SPEED_DOWN2_EFFECT": _stat_down("Speed", 2),
    "SPECIAL_DOWN1_EFFECT": _stat_down("Special", 1),
    "SPECIAL_DOWN2_EFFECT": _stat_down("Special", 2),
    "ACCURACY_DOWN1_EFFECT": _stat_down("accuracy", 1),
    "ACCURACY_DOWN2_EFFECT": _stat_down("accuracy", 2),
    "EVASION_DOWN1_EFFECT": _stat_down("evasion", 1),
    "EVASION_DOWN2_EFFECT": _stat_down("evasion", 2),
    "ATTACK_DOWN_SIDE_EFFECT": _stat_down_side("Attack"),
    "DEFENSE_DOWN_SIDE_EFFECT": _stat_down_side("Defense"),
    "SPEED_DOWN_SIDE_EFFECT": _stat_down_side("Speed"),
    "SPECIAL_DOWN_SIDE_EFFECT": _stat_down_side("Special"),

    # --- odds and ends ---
    "FOCUS_ENERGY_EFFECT": "Pegs the user's critical-hit rate for the rest of "
                           "the battle. Vanilla's version quartered it "
                           "instead -- Nemesis fixes that.",
    "LEECH_SEED_EFFECT": "Drains 1/16 of the target's max HP to the user "
                         "every turn until it switches out.",
    "DISABLE_EFFECT": "Blocks one of the target's moves at random for several "
                      "turns.",
    "MIMIC_EFFECT": "Copies one of the target's moves for the rest of the "
                    "battle.",
    "MIRROR_MOVE_EFFECT": "Uses whatever the target used last. Fails if it "
                          "hasn't moved yet.",
    "METRONOME_EFFECT": "Fires off a completely random move.",
    "TRANSFORM_EFFECT": "Becomes a copy of the target: its stats, types and "
                        "moves, each at 5 PP.",
    "CONVERSION_EFFECT": "Changes the user's types to match the target's.",
    "SWITCH_AND_TELEPORT_EFFECT": "Ends a wild battle outright. Against a "
                                  "trainer it does nothing.",
    "PAY_DAY_EFFECT": "Scatters coins, collected as prize money after the "
                      "battle.",
    "SPLASH_EFFECT": "Does absolutely nothing.",

    # --- Nemesis originals (constants/move_effect_constants.asm) ---
    "CARRION_WIND_EFFECT": "Moves first, flinches the target on any hit that "
                           "lands, and badly poisons it.",
    "JACKPOT_EFFECT": "Deals damage and scatters a large sum of prize money.",
    "SUPER_INSTINCT_EFFECT": "Raises the user's accuracy and evasion by 1 "
                             "stage each.",
    "CRYSTALLIZE_EFFECT": "Raises the user's Defense by 2 stages and its "
                          "Special by 1.",
    "CHAOS_STING_EFFECT": "Has a 30% chance to inflict a random status -- "
                          "anything except sleep.",
    "HOT_OIL_EFFECT": "Deals damage and always burns the target.",
    "WEB_CANNON_EFFECT": "Deals damage, slams the target's Speed all the way "
                         "down to -6, and has a 35% chance to flinch it.",
    "STATIC_SHOCK_EFFECT": "Deals damage and always paralyzes the target.",
    "VIBRATE_EFFECT": "Raises the user's Attack and Speed by 2 stages each.",
    "TANGLE_EFFECT": "Deals damage and lowers the target's Speed by 3 stages.",
    "ICE_BOMB_EFFECT": "Deals damage with a 50% chance to freeze the target "
                       "solid.",
    "ROLL_EFFECT": "Deals damage but lowers the user's own Defense by 2 "
                   "stages.",
    "ICE_SCULPTURE_EFFECT": "Puts up a frost decoy in place of the user. "
                            "Anything that damages it may be frozen.",
    "GLITTER_WING_EFFECT": "Deals damage with roughly a 30% chance to put the "
                           "target to sleep.",
}


# --- per-move overrides ------------------------------------------------------
# Only for moves the engine singles out by name, where the shared effect text
# would be wrong.

MOVE_DESCRIPTIONS = {
    "TOXIC": "Badly poisons the target: the damage starts small and doubles "
             "every single turn it stays in.",
    "SLUDGE": "Has a 40% chance to badly poison the target -- damage that "
              "doubles every turn, not the flat kind.",
    "REST": "Fully restores the user's HP and cures its status, at the cost "
            "of two turns asleep.",
    "LEECH_LIFE": "Heals the user for the full damage dealt, not the usual "
                  "half.",
    "GIGA_DRAIN": "Heals the user for the full damage dealt, not the usual "
                  "half.",
    "BLOOD_SUCK": "Heals the user for the full damage dealt, not the usual "
                  "half.",
    "CRUSH_JAW": "Has a 50% chance to make the target flinch and lose its "
                 "turn, if the user moves first.",
    "DIRE_HIT": "Pegs the user's critical-hit rate for the rest of the "
                "battle. Vanilla's version quartered it instead -- Nemesis "
                "fixes that.",
    "MIND_FEVER": "Confuses and burns the target at once. Its single PP is "
                  "deliberate -- one casting of the curse per battle.",
    "CARRION_WIND": "Moves first, flinches the target on any hit that lands, "
                    "and badly poisons it. Its single PP is deliberate.",
    "STRUGGLE": "The last resort when every move is out of PP. The user takes "
                "half the damage it deals.",
}


def describe(name, effect):
    """Description for a move, or None if there is nothing useful to say."""
    if name in MOVE_DESCRIPTIONS:
        return MOVE_DESCRIPTIONS[name]
    return EFFECT_DESCRIPTIONS.get(effect)
