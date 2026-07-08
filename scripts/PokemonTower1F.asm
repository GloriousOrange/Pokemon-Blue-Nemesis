; Shows the opposing-faction guard blocking the stairs at (18,9): Loyalist
; players are blocked by a Scientist, Hero players by a Rocket. Both hide
; once EVENT_GIOVANNI_SENT_TO_TOWER is set (mission briefing: Giovanni's 11F
; NPC on the Hero path, the PHONE BOSS call on the Loyalist path) -- or as
; soon as the player simply holds both key items (SILPH SCOPE + MASTER BALL,
; only obtainable by finishing the Hideout and Silph Co), so tower access
; never depends on finding the briefing first.
PokemonTower1F_Script:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_GIOVANNI_SENT_TO_TOWER
	jr nz, .hideBothGuards
; Quest already completed: the Master Ball gets SPENT catching Nocturn, so
; the in-bag check below would fail forever after -- keep the tower open.
	CheckEvent EVENT_BEAT_GENERAL_MATHUS
	jr nz, .hideBothGuards
	ld b, SILPH_SCOPE
	call IsItemInBag
	jr z, .guardsUp
	ld b, MASTER_BALL
	call IsItemInBag
	jr nz, .hideBothGuards
.guardsUp
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
.hero
	ld a, TOGGLE_POKEMON_TOWER_1F_ROCKET_GUARD
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, TOGGLE_POKEMON_TOWER_1F_SCIENTIST_GUARD
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret
.loyalist
	ld a, TOGGLE_POKEMON_TOWER_1F_SCIENTIST_GUARD
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, TOGGLE_POKEMON_TOWER_1F_ROCKET_GUARD
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret
.hideBothGuards
	ld a, TOGGLE_POKEMON_TOWER_1F_SCIENTIST_GUARD
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_POKEMON_TOWER_1F_ROCKET_GUARD
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

PokemonTower1F_TextPointers:
	def_text_pointers
	dw_const PokemonTower1FReceptionistText,    TEXT_POKEMONTOWER1F_RECEPTIONIST
	dw_const PokemonTower1FMiddleAgedWomanText, TEXT_POKEMONTOWER1F_MIDDLE_AGED_WOMAN
	dw_const PokemonTower1FBaldingGuyText,      TEXT_POKEMONTOWER1F_BALDING_GUY
	dw_const PokemonTower1FGirlText,            TEXT_POKEMONTOWER1F_GIRL
	dw_const PokemonTower1FChannelerText,       TEXT_POKEMONTOWER1F_CHANNELER
	dw_const PokemonTower1FScientistGuardText,  TEXT_POKEMONTOWER1F_SCIENTIST_GUARD
	dw_const PokemonTower1FRocketGuardText,     TEXT_POKEMONTOWER1F_ROCKET_GUARD

PokemonTower1FReceptionistText:
	text_far _PokemonTower1FReceptionistText
	text_end

PokemonTower1FMiddleAgedWomanText:
	text_far _PokemonTower1FMiddleAgedWomanText
	text_end

PokemonTower1FBaldingGuyText:
	text_far _PokemonTower1FBaldingGuyText
	text_end

PokemonTower1FGirlText:
	text_far _PokemonTower1FGirlText
	text_end

PokemonTower1FChannelerText:
	text_far _PokemonTower1FChannelerText
	text_end

PokemonTower1FScientistGuardText:
	text_far _PokemonTower1FScientistGuardText
	text_end

PokemonTower1FRocketGuardText:
	text_far _PokemonTower1FRocketGuardText
	text_end
