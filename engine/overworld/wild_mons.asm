LoadWildData::
	ld hl, WildDataPointers
	ld a, [wCurMap]

	; get wild data for current map
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a       ; hl now points to wild data for current map
	ld a, [hli]
	ld [wGrassRate], a
	and a
	jr z, .NoGrassData ; if no grass data, skip to surfing data
	push hl
	ld de, wGrassMons ; otherwise, load grass data
	ld bc, WILDDATA_LENGTH - 1
	call CopyData
	pop hl
	ld bc, WILDDATA_LENGTH - 1
	add hl, bc
.NoGrassData
	ld a, [hli]
	ld [wWaterRate], a
	and a
	jr z, .postGameMansionCheck ; no water data
	ld de, wWaterMons  ; otherwise, load surfing data
	ld bc, WILDDATA_LENGTH - 1
	call CopyData
.postGameMansionCheck
; Post-game (Champion beaten): the burned Pokemon Mansion swaps its wild
; encounters to stronger, fully-evolved forms at L50-60 + a rare Charizard.
	ld a, [wCurMap]
	cp POKEMON_MANSION_1F
	jr z, .mansionMaybeSwap
	cp POKEMON_MANSION_2F
	jr z, .mansionMaybeSwap
	cp POKEMON_MANSION_3F
	jr z, .mansionMaybeSwap
	cp POKEMON_MANSION_B1F
	ret nz
.mansionMaybeSwap
	ld a, [wPostGameMisc]
	bit BIT_POST_GAME_STARTED, a
	ret z
; wGrassRate is immediately followed by wGrassMons in WRAM, so copy the whole
; rate+mons block in one go. The table lives in another bank (main.asm), so use
; FarCopyData (a home function).
	ld hl, PokemonMansionPostGameWildMons
	ld de, wGrassRate
	ld bc, WILDDATA_LENGTH
	ld a, BANK(PokemonMansionPostGameWildMons)
	jp FarCopyData

INCLUDE "data/wild/grass_water.asm"
