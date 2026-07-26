; Prints the currently-loaded mon's (wLoadedMon, set by LoadMonData) OWN
; stored type fields, instead of re-deriving type from its species' base
; stats like PrintMonType below does. Needed for mons whose type has been
; patched away from their species default at runtime (e.g. RestoreStarterAsGhost's
; GHOST secondary type) -- battle already reads type this way (LoadBattleMonFromParty
; bulk-copies the party struct, type fields included), but the status screen
; previously called PrintMonType, which ignored the patch and always showed
; the species' vanilla type.
; hl = dest addr
PrintLoadedMonType::
	call GetPredefRegisters
	push hl
	ld a, [wLoadedMonType1]
	call PrintType
	ld a, [wLoadedMonType1]
	ld b, a
	ld a, [wLoadedMonType2]
	cp b
	pop hl
	jr z, EraseType2Text
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	jr PrintType

; [wCurSpecies] = pokemon ID
; hl = dest addr
PrintMonType:
	call GetPredefRegisters
	push hl
	call GetMonHeader
	pop hl
	push hl
	ld a, [wMonHType1]
	call PrintType
	ld a, [wMonHType1]
	ld b, a
	ld a, [wMonHType2]
	cp b
	pop hl
	jr z, EraseType2Text
	ld bc, SCREEN_WIDTH * 2
	add hl, bc

; a = type
; hl = dest addr
PrintType:
	push hl
	jr PrintType_

; erase "TYPE2/" if the mon only has 1 type
EraseType2Text:
	ld a, ' '
	ld bc, $13
	add hl, bc
	ld bc, $6
	jp FillMemory

PrintMoveType:
	call GetPredefRegisters
	push hl
	ld a, [wPlayerMoveType]
; fall through

PrintType_:
	add a
	ld hl, TypeNames
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	jp PlaceString

INCLUDE "data/types/names.asm"
