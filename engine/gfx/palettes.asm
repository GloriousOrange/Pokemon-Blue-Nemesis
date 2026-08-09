_RunPaletteCommand:
	call GetPredefRegisters
	ld a, b
	cp SET_PAL_DEFAULT
	jr nz, .not_default
	ld a, [wDefaultPaletteCommand]
.not_default
	cp SET_PAL_PARTY_MENU_HP_BARS
	jp z, UpdatePartyMenuBlkPacket
	ld l, a
	ld h, 0
	add hl, hl
	ld de, SetPalFunctions
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, SendSGBPackets
	push de
	jp hl

SetPal_BattleBlack:
	ld hl, PalPacket_Black
	ld de, BlkPacket_Battle
	ret

; uses PalPacket_Empty to build a packet based on mon IDs and health color
SetPal_Battle:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wPlayerBattleStatus3]
	ld hl, wBattleMonSpecies
	call DeterminePaletteID
	ld b, a
	ld a, [wBattleMonType2]
	cp GHOST
	jr nz, .not_player_ghost
	ld b, PAL_GHOSTMON
.not_player_ghost:
	ld a, [wEnemyBattleStatus3]
	ld hl, wEnemyMonSpecies2
	call DeterminePaletteID
	ld c, a
	ld a, [wEnemyMonType2]
	cp GHOST
	jr nz, .not_enemy_ghost
	ld c, PAL_GHOSTMON
.not_enemy_ghost:
	ld hl, wPalPacket + 1
	ld a, [wPlayerHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, [wEnemyHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a
	inc hl
	ld a, c
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_Battle
	ld a, SET_PAL_BATTLE
	ld [wDefaultPaletteCommand], a
	ret

SetPal_TownMap:
	ld hl, PalPacket_TownMap
	ld de, BlkPacket_WholeScreen
	ret

; uses PalPacket_Empty to build a packet based the mon ID
SetPal_StatusScreen:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurPartySpecies]
	cp NUM_POKEMON_INDEXES + 1
	jr c, .pokemon
	ld a, $1 ; not pokemon
.pokemon
	call DeterminePaletteIDOutOfBattle
	push af
	ld a, [wCurPartySpecies]
	call CheckIsGhostPartyMon
	pop af
	jr nc, .not_ghost_status
	ld a, PAL_GHOSTMON
.not_ghost_status:
	push af
	ld hl, wPalPacket + 1
	ld a, [wStatusScreenHPBarColor]
	add PAL_GREENBAR
	ld [hli], a
	inc hl
	pop af
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_StatusScreen
	ret

SetPal_PartyMenu:
	ld hl, PalPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ret

SetPal_Pokedex:
	ld hl, PalPacket_Pokedex
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurPartySpecies]
	call DeterminePaletteIDOutOfBattle
	push af
	ld a, [wCurPartySpecies]
	call CheckIsGhostPartyMon
	pop af
	jr nc, .not_ghost_dex
	ld a, PAL_GHOSTMON
.not_ghost_dex:
	ld hl, wPalPacket + 3
	ld [hl], a
	ld hl, wPalPacket
	ld de, BlkPacket_Pokedex
	ret

SetPal_Slots:
	ld hl, PalPacket_Slots
	ld de, BlkPacket_Slots
	ret

SetPal_TitleScreen:
	ld hl, PalPacket_Titlescreen
	ld de, BlkPacket_Titlescreen
	ret

; used mostly for menus and the Oak intro
SetPal_Generic:
	ld hl, PalPacket_Generic
	ld de, BlkPacket_WholeScreen
	ret

SetPal_NidorinoIntro:
	ld hl, PalPacket_NidorinoIntro
	ld de, BlkPacket_NidorinoIntro
	ret

SetPal_GameFreakIntro:
	ld hl, PalPacket_GameFreakIntro
	ld de, BlkPacket_GameFreakIntro
	ld a, SET_PAL_GENERIC
	ld [wDefaultPaletteCommand], a
	ret

; uses PalPacket_Empty to build a packet based on the current map
SetPal_Overworld:
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	ld a, [wCurMap]
	cp ARCHIPELAGO_CAVE_4F ; the grotto gets its own cold violet, one floor below
	jr z, .archipelagoGrotto
	cp ARCHIPELAGO_CAVE_3F ; its underground lake needs a real blue -- PAL_CAVE is
	jr z, .archipelagoLake ; shared by every other CAVERN map and stays untouched
	ld a, [wCurMapTileset]
	cp CEMETERY
	jr z, .PokemonTowerOrAgatha
	cp CAVERN
	jr z, .caveOrBruno
	ld a, [wCurMap]
	cp FIRST_INDOOR_MAP
	jr c, .townOrRoute
	cp CERULEAN_CAVE_2F
	jr c, .normalDungeonOrBuilding
	cp CERULEAN_CAVE_1F + 1
	jr c, .caveOrBruno
	cp LORELEIS_ROOM
	jr z, .Lorelei
	cp BRUNOS_ROOM
	jr z, .caveOrBruno
.normalDungeonOrBuilding
	ld a, [wLastMap] ; town or route that current dungeon or building is located
.townOrRoute
	cp NUM_CITY_MAPS
	jr c, .town
	ld a, PAL_ROUTE - 1
.town
	inc a ; a town's palette ID is its map ID + 1
	ld hl, wPalPacket + 1
	ld [hld], a
	ld de, BlkPacket_WholeScreen
	ld a, SET_PAL_OVERWORLD
	ld [wDefaultPaletteCommand], a
	ret
.PokemonTowerOrAgatha
	ld a, PAL_GRAYMON - 1
	jr .town
.caveOrBruno
	ld a, PAL_CAVE - 1
	jr .town
.Lorelei
	xor a
	jr .town
.archipelagoLake
	ld a, PAL_ARCHIPELAGO_CAVE_LAKE - 1
	jr .town
.archipelagoGrotto
	ld a, PAL_ARCHIPELAGO_GROTTO - 1
	jr .town

; used when a Pokemon is the only thing on the screen
; such as evolution, trading and the Hall of Fame
SetPal_PokemonWholeScreen:
	push bc
	ld hl, PalPacket_Empty
	ld de, wPalPacket
	ld bc, $10
	call CopyData
	pop bc
	ld a, c
	and a
	ld a, PAL_BLACK
	jr nz, .next
	ld a, [wWholeScreenPaletteMonSpecies]
	call DeterminePaletteIDOutOfBattle
	push af
	ld a, [wWholeScreenPaletteMonSpecies]
	call CheckIsGhostPartyMon
	pop af
	jr nc, .not_ghost_wholescreen
	ld a, PAL_GHOSTMON
.not_ghost_wholescreen:
.next
	ld [wPalPacket + 1], a
	ld hl, wPalPacket
	ld de, BlkPacket_WholeScreen
	ret

SetPal_TrainerCard:
	ld hl, BlkPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ld bc, $40
	call CopyData
	ld de, BadgeBlkDataLengths
	ld hl, wTrainerCardBlkPacket + 2
	ld a, [wObtainedBadges]
	ld c, NUM_BADGES
.badgeLoop
	srl a
	push af
	jr c, .haveBadge
; The player doesn't have the badge, so zero the badge's blk data.
	push bc
	ld a, [de]
	ld c, a
	xor a
.zeroBadgeDataLoop
	ld [hli], a
	dec c
	jr nz, .zeroBadgeDataLoop
	pop bc
	jr .nextBadge
.haveBadge
; The player does have the badge, so skip past the badge's blk data.
	ld a, [de]
.skipBadgeDataLoop
	inc hl
	dec a
	jr nz, .skipBadgeDataLoop
.nextBadge
	pop af
	inc de
	dec c
	jr nz, .badgeLoop
	ld hl, PalPacket_TrainerCard
	ld de, wTrainerCardBlkPacket
	ret

SetPalFunctions:
; entries correspond to SET_PAL_* constants
	dw SetPal_BattleBlack
	dw SetPal_Battle
	dw SetPal_TownMap
	dw SetPal_StatusScreen
	dw SetPal_Pokedex
	dw SetPal_Slots
	dw SetPal_TitleScreen
	dw SetPal_NidorinoIntro
	dw SetPal_Generic
	dw SetPal_Overworld
	dw SetPal_PartyMenu
	dw SetPal_PokemonWholeScreen
	dw SetPal_GameFreakIntro
	dw SetPal_TrainerCard

; The length of the blk data of each badge on the Trainer Card.
; The Rainbow Badge has 3 entries because of its many colors.
BadgeBlkDataLengths:
	db 6     ; Boulder Badge
	db 6     ; Cascade Badge
	db 6     ; Thunder Badge
	db 6 * 3 ; Rainbow Badge
	db 6     ; Soul Badge
	db 6     ; Marsh Badge
	db 6     ; Volcano Badge
	db 6     ; Earth Badge

DeterminePaletteID:
	bit TRANSFORMED, a ; a is battle status 3
	ld a, PAL_GRAYMON  ; if the mon has used Transform, use Ditto's palette
	ret nz
	ld a, [hl]
DeterminePaletteIDOutOfBattle:
	ld [wPokedexNum], a
	and a ; is the mon index 0?
	jr z, .skipDexNumConversion
	push bc
	predef IndexToPokedex
	pop bc
	ld a, [wPokedexNum]
.skipDexNumConversion
	ld e, a
	ld d, 0
	ld hl, MonsterPalettes ; not just for Pokemon, Trainers use it too
	add hl, de
	ld a, [hl]
	ret

InitPartyMenuBlkPacket:
	ld hl, BlkPacket_PartyMenu
	ld de, wPartyMenuBlkPacket
	ld bc, $30
	jp CopyData

UpdatePartyMenuBlkPacket:
; Update the blk packet with the palette of the HP bar that is
; specified in [wWhichPartyMenuHPBar].
	ld hl, wPartyMenuHPBarColors
	ld a, [wWhichPartyMenuHPBar]
	ld e, a
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	and a
	ld e, (1 << 2) | 1 ; green
	jr z, .next
	dec a
	ld e, (2 << 2) | 2 ; yellow
	jr z, .next
	ld e, (3 << 2) | 3 ; red
.next
	push de
	ld hl, wPartyMenuBlkPacket + 8 + 1
	ld bc, 6
	ld a, [wWhichPartyMenuHPBar]
	call AddNTimes
	pop de
	ld [hl], e
	ret

SendSGBPacket:
;check number of packets
	ld a, [hl]
	and $07
	ret z
; store number of packets in B
	ld b, a
.loop2
; save B for later use
	push bc
; disable ReadJoypad to prevent it from interfering with sending the packet
	ld a, 1
	ldh [hDisableJoypadPolling], a
; send RESET signal (P14=LOW, P15=LOW)
	xor a ; JOYP_SGB_START
	ldh [rJOYP], a
; set P14=HIGH, P15=HIGH
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
;load length of packets (16 bytes)
	ld b, 16
.nextByte
;set bit counter (8 bits per byte)
	ld e, 8
; get next byte in the packet
	ld a, [hli]
	ld d, a
.nextBit0
	bit 0, d
; if 0th bit is not zero set P14=HIGH, P15=LOW (send bit 1)
	ld a, JOYP_SGB_ONE
	jr nz, .next0
; else (if 0th bit is zero) set P14=LOW, P15=HIGH (send bit 0)
	ld a, JOYP_SGB_ZERO
.next0
	ldh [rJOYP], a
; must set P14=HIGH,P15=HIGH between each "pulse"
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
; rotation will put next bit in 0th position (so  we can always use command
; "bit 0, d" to fetch the bit that has to be sent)
	rr d
; decrease bit counter so we know when we have sent all 8 bits of current byte
	dec e
	jr nz, .nextBit0
	dec b
	jr nz, .nextByte
; send bit 0 as a "stop bit" (end of parameter data)
	ld a, JOYP_SGB_ZERO
	ldh [rJOYP], a
; set P14=HIGH,P15=HIGH
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
	xor a
	ldh [hDisableJoypadPolling], a
; wait for about 70000 cycles
	call Wait7000
; restore (previously pushed) number of packets
	pop bc
	dec b
; return if there are no more packets
	ret z
; else send 16 more bytes
	jr .loop2

LoadSGB:
	xor a
	ld [wOnSGB], a
	call CheckSGB
	ret nc
	ld a, 1
	ld [wOnSGB], a
	ld a, [wOnCGB]
	and a
	jr z, .notCGB
	ret
.notCGB
	di
	call PrepareSuperNintendoVRAMTransfer
	ei
	ld a, 1
	ld [wCopyingSGBTileData], a
	ld de, ChrTrnPacket
	ld hl, SGBBorderGraphics
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PctTrnPacket
	ld hl, BorderPalettes
	call CopyGfxToSuperNintendoVRAM
	xor a
	ld [wCopyingSGBTileData], a
	ld de, PalTrnPacket
	ld hl, SuperPalettes
	call CopyGfxToSuperNintendoVRAM
	call ClearVram
	ld hl, MaskEnCancelPacket
	jp SendSGBPacket

PrepareSuperNintendoVRAMTransfer:
	ld hl, .packetPointers
	ld c, 9
.loop
	push bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call SendSGBPacket
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .loop
	ret

.packetPointers
; Only the first packet is needed.
	dw MaskEnFreezePacket
	dw DataSndPacket1
	dw DataSndPacket2
	dw DataSndPacket3
	dw DataSndPacket4
	dw DataSndPacket5
	dw DataSndPacket6
	dw DataSndPacket7
	dw DataSndPacket8

CheckSGB:
; Returns whether the game is running on an SGB in carry.
	ld hl, MltReq2Packet
	di
	call SendSGBPacket
	ld a, 1
	ldh [hDisableJoypadPolling], a
	ei
	call Wait7000
	ldh a, [rJOYP]
	and JOYP_SGB_MLT_REQ
	cp JOYP_SGB_MLT_REQ
	jr nz, .isSGB
	ld a, JOYP_SGB_ZERO
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	call Wait7000
	call Wait7000
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
	call Wait7000
	call Wait7000
	ld a, JOYP_SGB_ONE
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	call Wait7000
	vc_hook Unknown_network_reset
	call Wait7000
	ld a, JOYP_SGB_FINISH
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	call Wait7000
	call Wait7000
	ldh a, [rJOYP]
	and JOYP_SGB_MLT_REQ
	cp JOYP_SGB_MLT_REQ
	jr nz, .isSGB
	call SendMltReq1Packet
	and a
	ret
.isSGB
	call SendMltReq1Packet
	scf
	ret

SendMltReq1Packet:
	ld hl, MltReq1Packet
	call SendSGBPacket
	jp Wait7000

CopyGfxToSuperNintendoVRAM:
	di
	push de
	call DisableLCD
	ld a, $e4
	ldh [rBGP], a
	ld de, vChars1
	ld a, [wCopyingSGBTileData]
	and a
	jr z, .notCopyingTileData
	call CopySGBBorderTiles
	jr .next
.notCopyingTileData
	ld bc, 256 tiles
	call CopyData
.next
	ld hl, vBGMap0
	ld de, TILEMAP_WIDTH - SCREEN_WIDTH
	ld a, $80
	ld c, (256 + SCREEN_WIDTH - 1) / SCREEN_WIDTH ; enough rows to fit 256 tiles
.loop
	ld b, SCREEN_WIDTH
.innerLoop
	ld [hli], a
	inc a
	dec b
	jr nz, .innerLoop
	add hl, de
	dec c
	jr nz, .loop
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	pop hl
	call SendSGBPacket
	xor a
	ldh [rBGP], a
	ei
	ret

Wait7000:
; Each loop takes 9 cycles so this routine actually waits 63000 cycles.
	ld de, 7000
.loop
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .loop
	ret

SendSGBPackets:
	ld a, [wOnCGB]
	and a
	jr z, .notCGB
	push de
	call InitCGBPalettes
	pop hl
	call ApplyCGBAttributes
	ret
.notCGB
	push de
	call SendSGBPacket
	pop hl
	jp SendSGBPacket

InitCGBPalettes:
; hl = a PAL_SET packet. Remembers which four SuperPalettes rows it selects,
; then loads them as real Game Boy Color palettes.
;
; The vanilla version of this routine was a stub that wrote 32 stray bytes and
; was unreachable anyway (RunPaletteCommand used to return early unless
; [wOnSGB]), which is why the SGB palettes never showed up on a CGB.
	push hl
	inc hl ; skip the command byte
	ld de, wCGBPalIndices
	ld c, 4
.copyIndices
	ld a, [hli]
	inc hl ; PAL_SET stores each palette index as a word
	ld [de], a
	inc de
	dec c
	jr nz, .copyIndices
	pop hl
	; fallthrough

ApplyCGBPalettes::
; Ask for the whole set to be rebuilt from wCGBPalIndices, mapped through the
; shade values shadowed from rBGP/rOBP*.
;
; With the screen on, none of it happens here. Palette RAM is unwritable during
; LCD mode 3, so writing it from whatever code happened to change a palette
; dropped colors at random -- which is what left menu text unreadable every other
; time it was opened. The colors are worked out into wCGBPalBuffer instead, and
; VBlank copies them across a palette per frame. With the screen off there is
; nothing to wait for, so the whole set goes out on the spot.
	xor a
	ld [wCGBPalSync], a
	ld [wCGBPalNextToPrepare], a
	call PrepareNextCGBPalette
	ldh a, [rLCDC]
	and LCDC_ON
	ret nz
.allAtOnce
	call BlitQueuedCGBPalette
	call PrepareNextCGBPalette
	ld a, [wCGBPalSync]
	and a
	jr nz, .allAtOnce
	ret

BlitQueuedCGBPalette::
; Copies the eight bytes in the buffer into the palette the queue named, then
; empties the buffer. This runs at the top of VBlank, where eight byte writes
; always fit. Working a palette out in place instead cost over a scanline, and
; on screens whose tilemap transfers run to the end of VBlank there was never
; room for it -- so the queue stalled and a palette change never appeared at all.
	ld a, [wCGBPalSync]
	and a
	ret z
	dec a
	cp 5
	jr nc, .objectPalette
	add a
	add a
	add a
	or $80 ; color 0 of that palette, auto-incrementing
	ldh [rBGPI], a
	ld c, LOW(rBGPD)
	jr .copy
.objectPalette
	sub 5
	add a
	add a
	add a
	or $80
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
.copy
	ld hl, wCGBPalBuffer
	REPT 2 * 4
	ld a, [hli]
	ldh [c], a
	ENDR
	xor a
	ld [wCGBPalSync], a
	ret

PrepareNextCGBPalette::
; Works out the next palette's eight bytes into the buffer. This only touches
; WRAM, so it is safe to run past the end of VBlank -- which is why it is done
; after the tilemap transfers rather than ahead of them.
	ld a, [wCGBPalSync]
	and a
	ret nz ; the buffer still holds one that has not been written yet
	ld a, [wCGBPalNextToPrepare]
	cp NUM_CGB_PALETTES
	ret nc ; the whole set has been through
	ld e, a
	inc a
	ld [wCGBPalNextToPrepare], a
	ld a, e
	inc a
	ld [wCGBPalSync], a

	ld a, e
	cp 4
	jr z, .waterPalette
	jr nc, .objectPalette
; background palette e, from its own row
	ld hl, wCGBPalIndices
	ld d, 0
	add hl, de
	ld a, [wCGBShadowBGP]
	ld b, a
	ld a, [hl] ; row index
	jp WriteCGBPalette

.waterPalette
; Background palette 4, which the attribute map hands to water tiles only.
	ld a, [wCGBShadowBGP]
	ld b, a
	ld a, [wCGBPalIndices] ; the map's own row, deepened
	jp WriteCGBWaterPalette

.objectPalette
; Sprites get their own palette rather than the screen's. Sharing the screen's
; row is what an SGB does, but there the whole picture is tinted the same way;
; here it made an NPC's body take the map's accent colour -- on a route, sprite
; bodies came out white with grass-green shading and vanished into the grass,
; leaving only their black outlines readable. Both object palettes are prepared
; because OAM entries with no palette bits set land on object palette 0.
	ld a, e
	cp 5
	ld a, [wCGBShadowOBP0]
	jr z, .gotShades
	ld a, [wCGBShadowOBP1]
.gotShades
	ld b, a
	call GetSpritePaletteRow
	jp WriteCGBPaletteAt

GetSpritePaletteRow:
; -> hl = the four colors sprites are drawn in
	ld a, [wColorScheme]
	cp COLOR_SCHEME_NEON
	ld hl, NeonPalette
	ret z
	ld hl, SpritePalette
	ret

WriteCGBPalette:
; a = SuperPalettes row index
; b = DMG shade mapping (two bits per color, low bits first)
; c = LOW(rBGPD) or LOW(rOBPD)
; Writes four BGR555 colors to the palette port at c.
	ld e, a
	ld a, [wColorScheme]
	cp COLOR_SCHEME_NEON
	ld hl, NeonPalette
	jr z, WriteCGBPaletteAt ; neon is one flat ramp shared by every palette
	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl ; each row is 4 colors * 2 bytes
	ld de, SuperPalettes
	add hl, de
WriteCGBPaletteAt:
; hl = four BGR555 colors, b = shade mapping. Fills wCGBPalBuffer.
	ld de, wCGBPalBuffer
	ld c, 4 ; four colors per palette
.colorLoop
	ld a, b
	and %11 ; which shade this color index maps to
	srl b
	srl b
	add a ; two bytes per color
	push hl
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	pop hl
	dec c
	jr nz, .colorLoop
	ret

WriteCGBWaterPalette:
; As WriteCGBPalette, but whatever the row puts in shade 2 comes out deep blue.
; That slot is shared by water, tree shading and the flowers on the path, so
; deepening it in the row itself turned the flowers vivid and the trees navy;
; deepening it here affects only the tiles the attribute map sends to this
; palette. Fades still work, because the shade mapping is still what picks the
; colors -- water goes dark with everything else.
	ld e, a
	ld a, [wColorScheme]
	cp COLOR_SCHEME_NEON
	ld hl, NeonPalette
	jr z, WriteCGBPaletteAt ; neon is one flat ramp, already blue in shade 2
	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, SuperPalettes
	add hl, de
	ld de, wCGBPalBuffer
	ld c, 4
.colorLoop
	ld a, b
	and %11
	srl b
	srl b
	cp 2
	jr z, .deepWater
	add a
	push hl
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	pop hl
	jr .nextColor
.deepWater
	ld a, LOW(DEEP_WATER)
	ld [de], a
	inc de
	ld a, HIGH(DEEP_WATER)
	ld [de], a
	inc de
.nextColor
	dec c
	jr nz, .colorLoop
	ret


; The background palette water gets to itself, and the color it puts wherever the
; map's row would have used shade 2. Palettes 0-3 are the ones the SGB packets
; assign to screen regions, so 4 is free for tile-driven use.
DEF WATER_PAL EQU 4
; four background palettes, water's own, and the two object palettes
DEF NUM_CGB_PALETTES EQU 7
DEF DEEP_WATER EQU palred 03 + palgreen 10 + palblue 28

; People, not scenery: a warm neutral ramp so a sprite reads the same against
; grass, sand, cave floor or a shop tile. Shade 0 is the large flat areas
; (clothing), shade 1 the shading the DMG drew in light grey, shade 3 the
; outline, kept at the same near-black the background rows use.
SpritePalette:
	RGB 31,28,24, 25,18,14, 15,11,11, 03,02,02

; The uniform ramp the neon color scheme paints everything in: what the DMG
; would draw as white becomes red, and the three darker shades become bright
; green, deep blue and black.
NeonPalette:
	RGB 31,02,06, 02,31,10, 01,05,22, 00,00,00

ApplyCGBAttributes:
; hl = an ATTR_BLK packet. Paints its regions into the background attribute map
; so each area of the screen picks up the palette the SGB code assigned it.
	ld a, [wOnCGB]
	and a
	ret z

; ROM packets are constant, so re-applying an unchanged one would only cost a
; blank frame (e.g. every time a battle HP bar changes color). Packets built in
; WRAM can change without the pointer changing, so those are always applied.
	ld a, h
	cp $c0 ; is the packet built in WRAM rather than stored in ROM?
	jr nc, .apply
	ld a, [wCGBLastBlkPacket]
	cp l
	jr nz, .apply
	ld a, [wCGBLastBlkPacket + 1]
	cp h
	ret z
.apply
	ld a, l
	ld [wCGBLastBlkPacket], a
	ld a, h
	ld [wCGBLastBlkPacket + 1], a

; VRAM is only safely writable with the LCD off. Every caller is changing what
; is on screen anyway, and the fill takes a fraction of a frame.
	ldh a, [rLCDC]
	ld d, a
	and LCDC_ON
	jr z, .lcdAlreadyOff
	push hl
	push de
	call DisableLCD
	pop de
	pop hl
.lcdAlreadyOff
	push de ; saved rLCDC

	ld a, 1
	ldh [rVBK], a ; the attribute map is in VRAM bank 1

	inc hl ; skip the command byte
	ld a, [hli]
	and a
	jr z, .done
	ld b, a ; number of data sets
.setLoop
	push bc
	ld a, [hli]
	ld b, a ; control: which regions this set affects
	ld a, [hli]
	ld c, a ; palette numbers, two bits per region
	bit 2, b ; does it repaint everything outside the block?
	jr z, .noOutside
	swap a
	and %11
	push hl
	push bc
	call FillCGBAttrMap
	pop bc
	pop hl
.noOutside
	ld a, b
	and %011 ; does it paint the block itself or its border?
	jr z, .skipRect
	ld a, c
	and %11
	push af ; the block's palette
	ld a, [hli]
	ld b, a ; x1
	ld a, [hli]
	ld c, a ; y1
	ld a, [hli]
	ld d, a ; x2
	ld a, [hli]
	ld e, a ; y2
	pop af
	push hl
	call FillCGBAttrRect
	pop hl
	jr .nextSet
.skipRect
	ld de, 4 ; step over the unused coordinates
	add hl, de
.nextSet
	pop bc
	dec b
	jr nz, .setLoop
.done
	call MarkWaterAttributes ; the region fills above flatten it, so redo it here
	xor a
	ldh [rVBK], a
	pop af ; restore rLCDC as it was, LCD on or off
	ldh [rLCDC], a
	ret

MarkWaterAttributes::
; Hand every water tile on the map background palette 4, so water can be deep
; blue while the tree shading and path flowers that share its color slot in the
; palette rows stay pale.
;
; Only tilesets that animate their water use tile $14 for it -- indoors that
; tile is something else entirely, so no cell is marked as water there. The
; clearing half of the pass still has to run on those maps: skipping it outright
; left the previous map's shoreline marked, which is why Pallet Town's water
; showed up as a blue patch on the floor of Oak's Lab.
;
; Must be called with the LCD off: it walks the whole 32x32 map, switching VRAM
; banks per tile, which is far too slow for a VBlank. Scrolling is kept up to
; date by MarkRedrawnAttributes instead.
	ld a, [wOnCGB]
	and a
	ret z ; on a DMG rVBK does nothing, so this would write over the tiles
; b = 1 when this tileset's $14 really is water, 0 when we only clear
	ldh a, [hTileAnimations]
	and a
	ld b, 0
	jr z, .gotWaterFlag
	inc b
.gotWaterFlag
	ld hl, vBGMap0
	ld de, TILEMAP_AREA
.loop
	xor a
	ldh [rVBK], a
	ld a, [hl] ; the tile itself lives in bank 0
	ld c, 0 ; default attribute: this cell is not water
	bit 0, b ; `bit` leaves a alone, so the tile survives for the compare
	jr z, .writeAttr
	cp $14 ; the water tile
	jr nz, .writeAttr
	ld c, WATER_PAL
.writeAttr
; every cell is written, not just the water: the previous map's shoreline would
; otherwise leave palette 4 behind on cells that are dry land here
	ld a, 1
	ldh [rVBK], a
	ld a, c
	ld [hl], a
	inc hl
	dec de
	ld a, d
	or e
	jr nz, .loop
; Leave the tile bank selected. Callers carry straight on writing tiles (the
; overworld's map-load path enables the LCD and loads sprite graphics next), and
; returning with bank 1 still latched sent those writes into the attribute map
; instead -- garbled strips that a text box redrew away and the next map redraw
; brought back.
	xor a
	ldh [rVBK], a
	ret

MarkRedrawnAttributes::
; d = the row/column mode RedrawRowOrColumn just handled. Mirrors the tiles it
; wrote into the attribute map, so water scrolling in from off screen arrives
; with its own palette. Runs in VBlank, but only on the frames where a new row
; or column actually appeared -- a few percent of them, since one covers two
; tiles of walking.
	ld a, [wOnCGB]
	and a
	ret z
	ldh a, [hTileAnimations]
	and a
	ret z
	ld b, d ; before de becomes the destination pointer
	ld a, 1
	ldh [rVBK], a
	ld hl, wRedrawRowOrColumnSrcTiles
	ldh a, [hRedrawRowOrColumnDest]
	ld e, a
	ldh a, [hRedrawRowOrColumnDest + 1]
	ld d, a
	dec b
	jr nz, .row
.column
	ld c, SCREEN_HEIGHT
.columnLoop
	call .writeAttr
	inc de
	call .writeAttr
	ld a, TILEMAP_WIDTH - 1
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
; wrap from the bottom of the map back to the top, as the tile pass does
	ld a, d
	and HIGH(TILEMAP_AREA - 1)
	or HIGH(vBGMap0)
	ld d, a
	dec c
	jr nz, .columnLoop
	jr .finish
.row
	push de
	call .rowHalf ; upper half
	pop de
	ld a, TILEMAP_WIDTH
	add e
	ld e, a
	call .rowHalf ; lower half
.finish
	xor a
	ldh [rVBK], a
	ret

.rowHalf
	ld c, SCREEN_WIDTH / 2
.rowLoop
	call .writeAttr
	inc de
	call .writeAttr
; wrap from the right edge back to the left, as the tile pass does
	ld a, e
	inc a
	and %11111
	ld b, a
	ld a, e
	and %11100000
	or b
	ld e, a
	dec c
	jr nz, .rowLoop
	ret

.writeAttr
; hl = next source tile, de = where it went. Leaves de alone.
	ld a, [hli]
	cp $14
	ld a, 0 ; `ld` leaves the comparison's flags alone
	jr nz, .plain
	ld a, WATER_PAL
.plain
	ld [de], a
	ret

FillCGBAttrMap:
; a = palette number. Fills both background attribute maps, so the palette
; survives the overworld scrolling tiles in from off screen, and applies to the
; window layer (vBGMap1) as well as the background.
	ld d, a
	ld hl, vBGMap0
	ld bc, 2 * TILEMAP_AREA
.loop
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

FillCGBAttrRect:
; a = palette number, b = x1, c = y1, d = x2, e = y2 (inclusive, screen tiles).
; Painted into both attribute maps for the same reason as FillCGBAttrMap.
	push bc
	push de
	push af
	ld hl, vBGMap0
	call .fillOneMap
	pop af
	pop de
	pop bc
	push bc
	push de
	push af
	ld hl, vBGMap1
	call .fillOneMap
	pop af
	pop de
	pop bc
	ret

.fillOneMap
; hl = attribute map base, a = palette, b/c/d/e = x1/y1/x2/y2
	push af
; rows = y2 - y1 + 1
	ld a, e
	sub c
	inc a
	ld e, a
; columns = x2 - x1 + 1
	ld a, d
	sub b
	inc a
	ld d, a
; step down to row y1
	ld a, c
	and a
	jr z, .gotRow
.rowOffset
	push de
	ld de, TILEMAP_WIDTH
	add hl, de
	pop de
	dec a
	jr nz, .rowOffset
.gotRow
; then across to column x1
	ld c, b
	ld b, 0
	add hl, bc
	pop af
.rowLoop
	push hl
	ld c, d ; columns
.colLoop
	ld [hli], a
	dec c
	jr nz, .colLoop
	pop hl
	ld bc, TILEMAP_WIDTH
	add hl, bc
	dec e
	jr nz, .rowLoop
	ret

CopySGBBorderTiles:
; SGB tile data is stored in a 4BPP planar format.
; Each tile is 32 bytes. The first 16 bytes contain bit planes 1 and 2, while
; the second 16 bytes contain bit planes 3 and 4.
; This function converts 2BPP planar data into this format by mapping
; 2BPP colors 0-3 to 4BPP colors 0-3. 4BPP colors 4-15 are not used.
	ld b, 128
.tileLoop
; Copy bit planes 1 and 2 of the tile data.
	ld c, TILE_SIZE
.copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyLoop

; Zero bit planes 3 and 4.
	ld c, 16
	xor a
.zeroLoop
	ld [de], a
	inc de
	dec c
	jr nz, .zeroLoop

	dec b
	jr nz, .tileLoop
	ret

CheckIsGhostPartyMon:
; In:  a = internal species to search for
; Out: carry set if any party mon with this species has TYPE2=GHOST
;      carry clear otherwise
; Clobbers: b, c, hl
	ld b, a
	ld a, [wPartyCount]
	and a
	ret z
	ld c, a
	ld hl, wPartyMons
.loop:
	ld a, [hl]
	cp b
	jr nz, .skip
	push hl
	ld a, l
	add MON_TYPE2
	ld l, a
	jr nc, .nc_type
	inc h
.nc_type:
	ld a, [hl]
	pop hl
	cp GHOST
	jr z, .found
.skip:
	ld a, l
	add PARTYMON_STRUCT_LENGTH
	ld l, a
	jr nc, .nc_next
	inc h
.nc_next:
	dec c
	jr nz, .loop
	or a
	ret
.found:
	scf
	ret

INCLUDE "data/sgb/sgb_packets.asm"

INCLUDE "data/pokemon/palettes.asm"

INCLUDE "data/sgb/sgb_palettes.asm"

INCLUDE "data/sgb/sgb_border.asm"
