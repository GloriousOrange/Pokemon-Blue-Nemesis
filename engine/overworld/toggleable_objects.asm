MarkTownVisitedAndLoadToggleableObjects::
	ld a, [wCurMap]
	cp FIRST_ROUTE_MAP
	jr nc, .notInTown
	ld c, a
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
.notInTown
; Scan the whole table rather than seeking to this map's block. A toggleable
; object's global index -- the bit it owns in the saved wToggleableObjectFlags
; array -- is just its position in ToggleableObjectStates, so scanning lets a
; map's entries sit anywhere instead of having to be contiguous. That matters
; because inserting an entry mid-table shifts the index of every entry after it
; and silently invalidates existing saves; appending at the end shifts nothing.
; The old code derived the index by dividing the map pointer's offset by 3,
; which only worked while each map owned one contiguous run.
	ld hl, ToggleableObjectStates
	ld de, wToggleableObjectList
	ld a, [wCurMap]
	ld b, a
	ld c, 0                    ; global index of the entry under hl
.writeToggleableObjectsListLoop
	ld a, [hli]
	cp -1
	jr z, .done     ; end of table
	cp b
	jr z, .thisMap
	inc hl                     ; skip sprite ID
	inc hl                     ; skip initial state
	inc c
	jr .writeToggleableObjectsListLoop
.thisMap
	ld a, [hli]
	ld [de], a                 ; write (map-local) sprite ID
	inc de
	ld a, c
	ld [de], a                 ; write (global) toggleable object index
	inc de
	inc hl                     ; skip initial state
	inc c
	jr .writeToggleableObjectsListLoop
.done
	ld a, -1
	ld [de], a                 ; write sentinel
	ret

InitializeToggleableObjectsFlags:
	ld hl, wToggleableObjectFlags
	ld bc, wToggleableObjectFlagsEnd - wToggleableObjectFlags
	xor a
	call FillMemory ; clear toggleable objects flags
	ld hl, ToggleableObjectStates
	xor a
	ld [wToggleableObjectCounter], a
.toggleableObjectsLoop
	ld a, [hli]
	cp -1 ; end of list
	ret z
	push hl
	inc hl
	ld a, [hl]
	cp OFF
	jr nz, .skip
	ld hl, wToggleableObjectFlags
	ld a, [wToggleableObjectCounter]
	ld c, a
	ld b, FLAG_SET
	call ToggleableObjectFlagAction ; set flag if object is toggled off
.skip
	ld hl, wToggleableObjectCounter
	inc [hl]
	pop hl
	inc hl
	inc hl
	jr .toggleableObjectsLoop

; tests if current object is toggled off/has been hidden
IsObjectHidden:
	ldh a, [hCurrentSpriteOffset]
	swap a
	ld b, a
	ld hl, wToggleableObjectList
.loop
	ld a, [hli]
	cp -1
	jr z, .notHidden ; not toggleable -> not hidden
	cp b
	ld a, [hli]
	jr nz, .loop
	ld c, a
	ld b, FLAG_TEST
	ld hl, wToggleableObjectFlags
	call ToggleableObjectFlagAction
	ld a, c
	and a
	jr nz, .hidden
.notHidden
	xor a
.hidden
	ldh [hIsToggleableObjectOff], a
	ret

; adds toggleable object (items, leg. pokemon, etc.) to the map
; [wToggleableObjectIndex]: index of the toggleable object to be added (global index)
ShowObject:
ShowObject2:
	ld hl, wToggleableObjectFlags
	ld a, [wToggleableObjectIndex]
	ld c, a
	ld b, FLAG_RESET
	call ToggleableObjectFlagAction   ; reset "removed" flag
	jp UpdateSprites

; removes toggleable object (items, leg. pokemon, etc.) from the map
; [wToggleableObjectIndex]: index of the toggleable object to be removed (global index)
HideObject:
	ld hl, wToggleableObjectFlags
	ld a, [wToggleableObjectIndex]
	ld c, a
	ld b, FLAG_SET
	call ToggleableObjectFlagAction   ; set "removed" flag
	jp UpdateSprites

ToggleableObjectFlagAction:
; identical to FlagAction

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp FLAG_TEST
	jr z, .read

; set
	ld a, [hl]
	ld b, a
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld a, [hl]
	ld b, a
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld a, [hl]
	ld b, a
	ld a, d
	and b

.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret
