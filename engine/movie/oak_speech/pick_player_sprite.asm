; Nemesis: lets the player pick their overworld look before naming
; themselves. Left/Right cycles through PlayerSpriteChoices (wrapping), A or
; B confirms. The chosen SPRITE_* id is stored in wPlayerChosenSprite, which
; GetWalkingPlayerSpriteGraphics (engine/events/player_path.asm) consults for
; the Hero/Traitor look. farcall'd from OakSpeech (oak_speech.asm), before
; .askPlayerName -- ResetPlayerSpriteData must already have run by then so
; the live sprite-state struct exists, though this screen only draws a
; static background-tile preview, not a live OAM sprite.
PickPlayerSprite::
	call ClearScreen

	hlcoord 2, 2
	ld de, PickSpriteTitleText
	call PlaceString

	hlcoord 1, 15
	ld de, PickSpriteHintText
	call PlaceString

	xor a
	ld [wCurrentMenuItem], a ; candidate index, 0-based (scratch; safe here, nothing else uses it yet)

.redraw
	call DrawSpritePreview

.inputLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	ld b, a
	and PAD_A | PAD_B
	jr nz, .confirm
	ld a, b
	and PAD_RIGHT
	jr nz, .pressedRight
	ld a, b
	and PAD_LEFT
	jr z, .inputLoop
; pressed Left
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .decIndex
	ld a, NUM_PLAYER_SPRITE_CHOICES
.decIndex
	dec a
	jr .storeIndex
.pressedRight
	ld a, [wCurrentMenuItem]
	inc a
	cp NUM_PLAYER_SPRITE_CHOICES
	jr c, .storeIndex
	xor a
.storeIndex
	ld [wCurrentMenuItem], a
	ld a, SFX_TINK
	call PlaySound
	jr .redraw

.confirm
	ld a, [wCurrentMenuItem]
	ld hl, PlayerSpriteChoices
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [wPlayerChosenSprite], a
	ret

; redraws the preview tile block + name for [wCurrentMenuItem]
DrawSpritePreview:
	hlcoord 4, 5
	lb bc, 6, 16 ; covers the sprite block (rows 5-8) and the name text (row 10)
	call ClearScreenArea

	ld a, [wCurrentMenuItem]
	push af
	ld hl, PlayerSpriteChoices
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl] ; a = SPRITE_* id
	call GetChosenSpriteGraphics ; clobbers hl; -> de = graphics ptr, a = bank
	ld b, a
	ld hl, vChars2 tile $60
	ld c, 4 ; one 16x16 frame (down, standing) = 4 tiles
	call CopyVideoData

	hlcoord 8, 6
	ld a, $60
	ld [hli], a
	ld a, $61
	ld [hl], a
	hlcoord 8, 7
	ld a, $62
	ld [hli], a
	ld a, $63
	ld [hl], a

	pop af ; a = candidate index again
	call GetPlayerSpriteChoiceNamePtr ; -> hl = name string ptr
	ld d, h
	ld e, l
	hlcoord 4, 10
	call PlaceString
	ret

; a = 0-based index; returns hl = pointer to that entry in PlayerSpriteChoiceNames
GetPlayerSpriteChoiceNamePtr:
	ld hl, PlayerSpriteChoiceNames
	and a
	ret z
	ld b, a
.skipLoop
	ld a, [hli]
	cp '@'
	jr nz, .skipLoop
	dec b
	jr nz, .skipLoop
	ret

PickSpriteTitleText:
	db "CHOOSE YOUR LOOK@"

PickSpriteHintText:
	db   "LEFT/RIGHT: CHOOSE"
	next "A OR B: CONFIRM@"

INCLUDE "data/player/sprite_choices.asm"
