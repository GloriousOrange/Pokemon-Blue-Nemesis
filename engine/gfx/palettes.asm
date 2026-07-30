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
; Rebuilds the four background palettes and both object palettes from
; wCGBPalIndices, mapped through the shade values shadowed from rBGP/rOBP*.
	ld a, $80 ; color 0, auto-increment
	ldh [rBGPI], a
	ld a, [wCGBShadowBGP]
	ld b, a
	ld hl, wCGBPalIndices
	ld d, 4
.bgLoop
	ld a, [hli]
	push hl
	push bc
	push de
	ld c, LOW(rBGPD)
	call WriteCGBPalette
	pop de
	pop bc
	pop hl
	dec d
	jr nz, .bgLoop

; Sprites always use the screen's main palette (index 0), the same one the SGB
; code applies to the whole screen. Both object palettes are written because
; OAM entries with no palette bits set land on object palette 0.
	ld a, $80
	ldh [rOBPI], a
	ld a, [wCGBShadowOBP0]
	ld b, a
	ld a, [wCGBPalIndices]
	ld c, LOW(rOBPD)
	call WriteCGBPalette
	ld a, [wCGBShadowOBP1]
	ld b, a
	ld a, [wCGBPalIndices]
	ld c, LOW(rOBPD)
	jp WriteCGBPalette

WriteCGBPalette:
; a = SuperPalettes row index
; b = DMG shade mapping (two bits per color, low bits first)
; c = LOW(rBGPD) or LOW(rOBPD)
; Writes four BGR555 colors to the palette port at c.
	ld e, a
	ld a, [wColorScheme]
	cp COLOR_SCHEME_NEON
	ld hl, NeonPalette
	jr z, .gotRow ; neon is one flat ramp shared by every palette
	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl ; each row is 4 colors * 2 bytes
	ld de, SuperPalettes
	add hl, de
.gotRow
	ld d, 4 ; four colors per palette
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
	ldh [c], a
	ld a, [hl]
	ldh [c], a
	pop hl
	dec d
	jr nz, .colorLoop
	ret

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
	xor a
	ldh [rVBK], a
	pop af ; restore rLCDC as it was, LCD on or off
	ldh [rLCDC], a
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
