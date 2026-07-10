SECTION "bank1", ROMX

INCLUDE "data/sprites/facings.asm"
INCLUDE "engine/events/black_out.asm"
INCLUDE "data/pokemon/mew.asm"
INCLUDE "engine/battle/safari_zone.asm"
INCLUDE "engine/movie/title.asm"
INCLUDE "engine/pokemon/load_mon_data.asm"
INCLUDE "data/items/prices.asm"
INCLUDE "data/items/names.asm"
INCLUDE "data/text/unused_names.asm"
INCLUDE "engine/gfx/sprite_oam.asm"
INCLUDE "engine/gfx/oam_dma.asm"
INCLUDE "engine/link/print_waiting_text.asm"
INCLUDE "engine/overworld/sprite_collisions.asm"
INCLUDE "engine/debug/debug_menu.asm"
INCLUDE "engine/events/pick_up_item.asm"
INCLUDE "engine/overworld/movement.asm"
INCLUDE "engine/link/cable_club.asm"
INCLUDE "engine/menus/main_menu.asm"
INCLUDE "engine/movie/oak_speech/oak_speech.asm"
INCLUDE "engine/overworld/special_warps.asm"
INCLUDE "engine/debug/debug_party.asm"
INCLUDE "engine/menus/naming_screen.asm"
INCLUDE "engine/movie/oak_speech/oak_speech2.asm"
INCLUDE "engine/items/subtract_paid_money.asm"
INCLUDE "engine/menus/swap_items.asm"
INCLUDE "engine/events/pokemart.asm"
INCLUDE "engine/pokemon/learn_move.asm"
INCLUDE "engine/events/pokecenter.asm"
INCLUDE "engine/events/set_blackout_map.asm"
INCLUDE "engine/menus/display_text_id_init.asm"
INCLUDE "engine/menus/draw_start_menu.asm"
INCLUDE "engine/link/cable_club_npc.asm"
INCLUDE "engine/menus/text_box.asm"
INCLUDE "engine/battle/move_effects/drain_hp.asm"
INCLUDE "engine/menus/players_pc.asm"
INCLUDE "engine/pokemon/remove_mon.asm"
INCLUDE "engine/events/display_pokedex.asm"


SECTION "bank3", ROMX

INCLUDE "engine/joypad.asm"
INCLUDE "data/maps/songs.asm"
INCLUDE "engine/overworld/clear_variables.asm"
INCLUDE "engine/overworld/tyranis_encounter.asm"
INCLUDE "engine/overworld/player_state.asm"
INCLUDE "engine/events/poison.asm"
INCLUDE "engine/overworld/tilesets.asm"
INCLUDE "engine/overworld/daycare_exp.asm"
INCLUDE "data/maps/toggleable_objects.asm"
INCLUDE "engine/overworld/field_move_messages.asm"
INCLUDE "engine/items/inventory.asm"
INCLUDE "engine/overworld/wild_mons.asm"
INCLUDE "engine/items/item_effects.asm"
INCLUDE "engine/menus/draw_badges.asm"
INCLUDE "engine/overworld/update_map.asm"
INCLUDE "engine/overworld/cut.asm"
INCLUDE "engine/overworld/toggleable_objects.asm"
INCLUDE "engine/overworld/push_boulder.asm"
INCLUDE "engine/overworld/player_hm_effects.asm"
INCLUDE "engine/pokemon/add_mon.asm"
INCLUDE "engine/flag_action.asm"
INCLUDE "engine/events/heal_party.asm"
INCLUDE "engine/math/bcd.asm"
INCLUDE "engine/movie/oak_speech/init_player_data.asm"
INCLUDE "engine/items/get_bag_item_quantity.asm"
INCLUDE "engine/overworld/pathfinding.asm"
INCLUDE "engine/gfx/hp_bar.asm"
INCLUDE "engine/events/hidden_events/bookshelves.asm"
INCLUDE "engine/events/hidden_events/indigo_plateau_statues.asm"
INCLUDE "engine/events/hidden_events/book_or_sculpture.asm"
INCLUDE "engine/events/hidden_events/elevator.asm"
INCLUDE "engine/events/hidden_events/town_map.asm"
INCLUDE "engine/events/hidden_events/pokemon_stuff.asm"


SECTION "Font Graphics", ROMX

INCLUDE "gfx/font.asm"


SECTION "Battle Engine 1", ROMX

INCLUDE "engine/overworld/is_player_just_outside_map.asm"
INCLUDE "engine/pokemon/status_screen.asm"
INCLUDE "engine/menus/party_menu.asm"
INCLUDE "gfx/player.asm"
INCLUDE "engine/overworld/turn_sprite.asm"
INCLUDE "engine/menus/start_sub_menus.asm"
INCLUDE "engine/items/tms.asm"
INCLUDE "engine/battle/end_of_battle.asm"
INCLUDE "engine/battle/wild_encounters.asm"
INCLUDE "engine/battle/move_effects/recoil.asm"
INCLUDE "engine/battle/move_effects/conversion.asm"
INCLUDE "engine/battle/move_effects/haze.asm"
INCLUDE "engine/battle/get_trainer_name.asm"
INCLUDE "engine/math/random.asm"


SECTION "Battle Engine 2", ROMX

INCLUDE "engine/gfx/load_pokedex_tiles.asm"
INCLUDE "engine/overworld/map_sprites.asm"
INCLUDE "engine/overworld/emotion_bubbles.asm"
INCLUDE "engine/events/evolve_trade.asm"
INCLUDE "engine/battle/move_effects/substitute.asm"
INCLUDE "engine/menus/pc.asm"


SECTION "Play Time", ROMX

INCLUDE "engine/play_time.asm"


SECTION "Doors and Ledges", ROMX

INCLUDE "engine/overworld/auto_movement.asm"
INCLUDE "engine/overworld/doors.asm"
INCLUDE "engine/overworld/ledges.asm"


SECTION "Pokémon Names", ROMX

INCLUDE "data/pokemon/names.asm"
INCLUDE "engine/movie/oak_speech/clear_save.asm"
INCLUDE "engine/events/elevator.asm"


SECTION "Hidden Events 1", ROMX

INCLUDE "engine/menus/oaks_pc.asm"
INCLUDE "engine/events/hidden_events/new_bike.asm"
INCLUDE "engine/events/hidden_events/oaks_lab_posters.asm"
INCLUDE "engine/events/hidden_events/safari_game.asm"
INCLUDE "engine/events/hidden_events/cinnabar_gym_quiz.asm"
INCLUDE "engine/events/hidden_events/magazines.asm"
INCLUDE "engine/events/hidden_events/bills_house_pc.asm"
INCLUDE "engine/events/hidden_events/oaks_lab_email.asm"


SECTION "Bill's PC", ROMX

INCLUDE "engine/pokemon/bills_pc.asm"


SECTION "Battle Engine 3", ROMX

INCLUDE "engine/battle/print_type.asm"
INCLUDE "engine/battle/save_trainer_name.asm"
INCLUDE "engine/battle/move_effects/focus_energy.asm"


SECTION "Battle Engine 4", ROMX

INCLUDE "engine/battle/move_effects/leech_seed.asm"


SECTION "Battle Engine 5", ROMX

INCLUDE "engine/battle/display_effectiveness.asm"
INCLUDE "gfx/trainer_card.asm"
INCLUDE "engine/items/tmhm.asm"
INCLUDE "engine/battle/scale_sprites.asm"
INCLUDE "engine/battle/move_effects/pay_day.asm"
INCLUDE "engine/slots/game_corner_slots2.asm"


SECTION "Battle Engine 6", ROMX

INCLUDE "engine/battle/move_effects/mist.asm"
INCLUDE "engine/battle/move_effects/one_hit_ko.asm"


SECTION "Slot Machines", ROMX

INCLUDE "engine/movie/title2.asm"
INCLUDE "engine/battle/link_battle_versus_text.asm"
INCLUDE "engine/slots/slot_machine.asm"
INCLUDE "engine/events/pewter_guys.asm"
INCLUDE "engine/math/multiply_divide.asm"
INCLUDE "engine/slots/game_corner_slots.asm"


SECTION "Battle Engine 7", ROMX

INCLUDE "data/moves/moves.asm"
INCLUDE "data/pokemon/base_stats.asm"
INCLUDE "data/pokemon/cries.asm"
INCLUDE "engine/battle/unused_stats_functions.asm"
INCLUDE "engine/battle/scroll_draw_trainer_pic.asm"
INCLUDE "engine/battle/trainer_ai.asm"
INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"
INCLUDE "engine/pokemon/evos_moves.asm"
INCLUDE "engine/battle/move_effects/heal.asm"
INCLUDE "engine/battle/move_effects/transform.asm"
INCLUDE "engine/battle/move_effects/reflect_light_screen.asm"


SECTION "Trade Animation GFX", ROMX

; moved out of Battle Engine 7 to make room for the post-game trainer parties;
; accessed only via BANK(TradingAnimationGraphics) so it can float to any bank
INCLUDE "gfx/trade.asm"


SECTION "GymRematch", ROMX
INCLUDE "engine/events/gym_rematch.asm"

SECTION "LabScientists", ROMX
INCLUDE "engine/events/lab_scientists.asm"

SECTION "PlayerPath", ROMX
; branching-path helpers (GetPlayerPath) + the Nocturn go-rogue choice
; (NocturnGoRogueChoice), reached via callfar once the Nocturn-obtain script exists
INCLUDE "engine/events/player_path.asm"

SECTION "Megan", ROMX
; girlfriend interaction shared by every Megan NPC; reached only via farcall MeganTalk
INCLUDE "engine/overworld/megan.asm"

SECTION "Item Descriptions", ROMX
; bag INFO option; reached only via farcall PrintItemDescription
INCLUDE "engine/items/item_descriptions.asm"


SECTION "Battle Core", ROMX

INCLUDE "engine/battle/core.asm"
INCLUDE "engine/battle/effects.asm"


SECTION "bank10", ROMX

INCLUDE "engine/menus/pokedex.asm"
INCLUDE "engine/movie/trade.asm"
INCLUDE "engine/movie/intro.asm"
INCLUDE "engine/movie/trade2.asm"


SECTION "Pokédex Rating", ROMX

INCLUDE "engine/events/pokedex_rating.asm"


SECTION "Hidden Events Core", ROMX

INCLUDE "engine/overworld/hidden_events.asm"


SECTION "Screen Effects", ROMX

INCLUDE "engine/gfx/screen_effects.asm"


; Floating (unpinned in layout.link, like "Pics 6") so the linker packs it
; wherever there's room -- moved out of "Predefs" (bank $13, shared with
; "Trainer Pics"/"Maps 9") to make room for MathusPic (General Mathus's
; trainer front sprite, gfx/trainers/mathus.png) in that bank's very tight
; budget. Only ever reached via GivePokemon's `farjp _GivePokemon`
; (home/give.asm), which resolves the target bank automatically, so this is
; safe to relocate freely.
SECTION "GivePokemon", ROMX

INCLUDE "engine/events/give_pokemon.asm"


SECTION "Predefs", ROMX

INCLUDE "engine/predefs.asm"


SECTION "Battle Engine 8", ROMX

INCLUDE "engine/battle/init_battle_variables.asm"
INCLUDE "engine/battle/move_effects/paralyze.asm"


SECTION "Hidden Events 2", ROMX

INCLUDE "engine/events/card_key.asm"
INCLUDE "engine/events/prize_menu.asm"
INCLUDE "engine/events/hidden_events/school_notebooks.asm"
INCLUDE "engine/events/hidden_events/fighting_dojo.asm"
INCLUDE "engine/events/hidden_events/indigo_plateau_hq.asm"


SECTION "Battle Engine 9", ROMX

INCLUDE "engine/battle/experience.asm"


SECTION "Diploma", ROMX

INCLUDE "engine/events/diploma.asm"


SECTION "Trainer Sight", ROMX

INCLUDE "engine/overworld/trainer_sight.asm"


SECTION "Battle Engine 10", ROMX

INCLUDE "engine/battle/common_text.asm"
INCLUDE "engine/pokemon/experience.asm"
INCLUDE "engine/events/oaks_aide.asm"


SECTION "Saffron Guards", ROMX

INCLUDE "engine/events/saffron_guards.asm"


SECTION "Starter Dex", ROMX

INCLUDE "engine/events/starter_dex.asm"


SECTION "Hidden Events 3", ROMX

INCLUDE "engine/pokemon/set_types.asm"
INCLUDE "engine/events/hidden_events/reds_room.asm"
INCLUDE "engine/events/hidden_events/route_15_binoculars.asm"
INCLUDE "engine/events/hidden_events/museum_fossils.asm"
INCLUDE "engine/events/hidden_events/school_blackboard.asm"
INCLUDE "engine/events/hidden_events/vermilion_gym_trash.asm"


SECTION "Cinnabar Lab Fossils", ROMX

INCLUDE "engine/events/cinnabar_lab.asm"


SECTION "Hidden Events 4", ROMX

INCLUDE "engine/events/hidden_events/gym_statues.asm"
INCLUDE "engine/events/hidden_events/bench_guys.asm"
INCLUDE "engine/events/hidden_events/blues_room.asm"
INCLUDE "engine/events/hidden_events/pokecenter_pc.asm"


SECTION "Battle Engine 11", ROMX

INCLUDE "engine/battle/decrement_pp.asm"
INCLUDE "gfx/version.asm"


SECTION "bank1C", ROMX

INCLUDE "engine/movie/splash.asm"
INCLUDE "engine/movie/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/items/town_map.asm"
INCLUDE "engine/gfx/mon_icons.asm"
INCLUDE "engine/events/in_game_trades.asm"
INCLUDE "engine/gfx/palettes.asm"
INCLUDE "engine/menus/save.asm"


SECTION "Itemfinder 1", ROMX

INCLUDE "engine/movie/credits.asm"
INCLUDE "engine/pokemon/status_ailments.asm"
INCLUDE "engine/items/itemfinder.asm"


SECTION "Vending Machine", ROMX

INCLUDE "engine/events/vending_machine.asm"


SECTION "Itemfinder 2", ROMX

INCLUDE "engine/menus/league_pc.asm"
INCLUDE "engine/events/hidden_items.asm"


SECTION "bank1E", ROMX

INCLUDE "engine/battle/animations.asm"
INCLUDE "engine/overworld/cut2.asm"
INCLUDE "engine/overworld/dust_smoke.asm"
INCLUDE "gfx/fishing.asm"
INCLUDE "data/moves/animations.asm"
INCLUDE "data/battle_anims/subanimations.asm"
INCLUDE "data/battle_anims/frame_blocks.asm"
INCLUDE "engine/movie/evolution.asm"
INCLUDE "engine/overworld/elevator.asm"

SECTION "TM Prices", ROMX ; relocated out of bank1E (which filled up); GetMachinePrice is called via BANK(), so any bank works
INCLUDE "engine/items/tm_prices.asm"

SECTION "Starter Ashes", ROMX

INCLUDE "engine/events/starter_ashes.asm"

SECTION "Map Header Banks", ROMX ; relocated out of bank3 (which filled up with the archipelago's new maps); referenced via BANK(), so any bank works, same technique as "TM Prices" above

INCLUDE "data/maps/map_header_banks.asm"
