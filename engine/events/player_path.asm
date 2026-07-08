; Player allegiance / branching-path helpers (Pokemon Nemesis).
;
; Path state lives in wPostGameMisc: BIT_ROCKET_LOYALTY (joined Team Rocket at
; Nugget Bridge = Loyalist, clear = Hero) and BIT_PLAYER_TRAITOR (went rogue at
; the Nocturn beat = Traitor, which overrides allegiance). Hero is the default
; from game start (see LoadWalkingPlayerSpriteGraphics: Scientist by default,
; Rocket grunt when loyal).

; Returns the current path in a: 0 = Hero, 1 = Loyalist, 2 = Traitor.
; Traitor takes precedence over the Loyalist/Hero split.
GetPlayerPath::
	ld a, [wPostGameMisc]
	bit BIT_PLAYER_TRAITOR, a
	jr nz, .traitor
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .loyalist
	xor a ; Hero
	ret
.loyalist
	ld a, 1
	ret
.traitor
	ld a, 2
	ret

; Returns the overworld walking sprite for the player's current path in de.
; The sprite's bank is stashed in wBuffer rather than returned in a register:
; farcall's Bankswitch clobbers af/bc on its way back to the home bank, so b
; can't carry the bank home the way non-farcalled callers usually do it.
; Hero: Scientist, Loyalist: Rocket, Traitor (overrides both): Blue (twin
; brothers). farcall'd from LoadWalkingPlayerSpriteGraphics (home/overworld.asm).
GetWalkingPlayerSpriteGraphics::
	ld a, [wPostGameMisc]
	bit BIT_PLAYER_TRAITOR, a
	jr nz, .traitor
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .rocket
	ld de, ScientistSprite
	ld a, BANK(ScientistSprite)
	jr .done
.rocket
	ld de, RocketSprite
	ld a, BANK(RocketSprite)
	jr .done
.traitor
	ld de, BlueSprite
	ld a, BANK(BlueSprite)
.done
	ld [wBuffer], a
	ret

; Silph Co faction gate. Returns NZ when the trainer currently being considered
; is an ALLY on the player's path (so it must NOT engage or battle), Z otherwise.
; Loyalist (BIT_ROCKET_LOYALTY set) -> Rockets are allies; Hero (clear) ->
; Scientists are allies. Only applies on the Silph Co floors. The trainer's class
; is read from wMapSpriteExtraData[wSpriteIndex], the same addressing EngageMapTrainer
; uses. Callable from the home-bank engagement code via `callfar`: Bankswitch's
; return path touches no flags, so the Z/NZ verdict survives the bank switch.
CheckSilphAllyTrainer::
	ld a, [wCurMap]
	call IsSilphCoMap
	jr z, .normal
	ld hl, wMapSpriteExtraData
	ld a, [wSpriteIndex]
	dec a
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl] ; trainer class
	ld b, a
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	ld a, b
	jr z, .hero
	cp OPP_ROCKET ; Loyalist: your fellow Rockets don't fight you
	jr z, .ally
	jr .normal
.hero
	cp OPP_SCIENTIST ; Hero: Oak's Scientists don't fight you
	jr z, .ally
.normal
	xor a ; Z = engage normally
	ret
.ally
	or 1 ; NZ = ally, suppress engagement
	ret

; a = map id -> NZ if it's a Silph Co floor, Z otherwise. Floors are two
; contiguous runs (1F=$B5; 2F-8F=$CF-$D5; 9F-11F=$E9-$EB), elevator excluded.
IsSilphCoMap:
	cp SILPH_CO_1F
	jr z, .yes
	cp SILPH_CO_2F
	jr c, .no
	cp SILPH_CO_8F + 1
	jr c, .yes
	cp SILPH_CO_9F
	jr c, .no
	cp SILPH_CO_11F + 1
	jr c, .yes
.no
	xor a
	ret
.yes
	or 1
	ret

; Automatic incoming-call debrief, fired immediately after Nocturn is
; captured (see PokemonTower6FMathusBattleScript, scripts/PokemonTower6F.asm
; -- farcall'd from there, not reached via the Start-menu PHONE). Loyalist ->
; Giovanni; Hero -> Oak. YES reports the weapon in and stays on the current
; path (Loyalist is rewarded with Miasma; Hero with a fresh Master Ball +
; $100,000). NO keeps Nocturn and sets BIT_PLAYER_TRAITOR (Traitor path,
; reachable from either prior path, overrides allegiance -- see
; GetWalkingPlayerSpriteGraphics/LoadPlayerBackPic).
NocturnGoRogueChoice::
	ld a, [wPostGameMisc]
	bit BIT_ROCKET_LOYALTY, a
	jr nz, .giovanni

.oak
	ld hl, OakWeaponCallText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .oakRefused
	ld hl, OakSendingItText
	call PrintText
	call HandOverNocturn
	lb bc, MASTER_BALL, 1
	call GiveItem
	ld hl, MathusOakRewardMoney + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	predef AddBCDPredef
	ld hl, OakRewardText
	call PrintText
	SetEvent EVENT_REPORTED_NOCTURN
	ret
.oakRefused
	ld hl, OakRefusalPlayerText
	call PrintText
	ld hl, wPostGameMisc
	set BIT_PLAYER_TRAITOR, [hl]
	ld hl, OakRefusalText
	call PrintText
	SetEvent EVENT_REPORTED_NOCTURN
	ret

.giovanni
	ld hl, GiovanniWeaponCallText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .giovanniRefused
	ld hl, GiovanniSendingItText
	call PrintText
; hand Nocturn over BEFORE giving Miasma -- if the party was full when
; Nocturn was caught (sent to box) this order still works, and if Nocturn is
; IN the party, removing it first frees the slot for Miasma
	call HandOverNocturn
	lb bc, MIASMA, 40
	call GivePokemon
	jr nc, .giovanniDone
	SetEvent EVENT_GOT_MIASMA
.giovanniDone
	ld hl, GiovanniRewardText
	call PrintText
	SetEvent EVENT_REPORTED_NOCTURN
	ret
.giovanniRefused
	ld hl, GiovanniRefusalPlayerText
	call PrintText
	ld hl, wPostGameMisc
	set BIT_PLAYER_TRAITOR, [hl]
	ld hl, GiovanniRefusalText
	call PrintText
	SetEvent EVENT_REPORTED_NOCTURN
	ret

; Reporting in means physically sending Nocturn to the boss: remove it from
; the party, or from the current box if it was caught with a full party.
; Only called on the report-in (YES) branches -- going rogue keeps it.
; Searching by species is safe: Nocturn is unique. Removing it can never
; empty the party: the player fought Mathus with at least one mon, so party
; size is >= 2 whenever Nocturn is in it.
HandOverNocturn:
	ld b, NOCTURN
	ld hl, wPartySpecies
	ld c, 0
.partyLoop
	ld a, [hli]
	cp $ff
	jr z, .checkBox
	cp b
	jr z, .removeFromParty
	inc c
	jr .partyLoop
.removeFromParty
	ld a, c
	ld [wWhichPokemon], a
	xor a
	ld [wRemoveMonFromBox], a
	jp RemovePokemon
.checkBox
	ld hl, wBoxSpecies
	ld c, 0
.boxLoop
	ld a, [hli]
	cp $ff
	ret z ; not found anywhere -- nothing to hand over
	cp b
	jr z, .removeFromBox
	inc c
	jr .boxLoop
.removeFromBox
	ld a, c
	ld [wWhichPokemon], a
	ld a, 1
	ld [wRemoveMonFromBox], a
	jp RemovePokemon

MathusOakRewardMoney:
	bcd3 100000

OakWeaponCallText:
	text "OAK: Have you"
	line "caught the"
	cont "weapon?"
	done

OakSendingItText:
	text "Yes, Professor."
	line "I'm sending it to"
	cont "you now."
	done

OakRewardText:
	text "OAK: Wonderful"
	line "work, my boy!"

	para "Here -- a new"
	line "MASTER BALL, and"
	cont "100,000 for your"
	cont "trouble."

	para "You've more than"
	line "earned it."
	done

OakRefusalPlayerText:
	text "It's mine now."
	line "Find someone else"
	cont "to fight your"
	cont "battles."
	done

OakRefusalText:
	text "OAK: ...I see."

	para "I hope you know"
	line "what you're"
	cont "doing."
	done

GiovanniWeaponCallText:
	text "Have you obtained"
	line "the weapon?"
	done

GiovanniSendingItText:
	text "Yes, boss. It's"
	line "all yours."
	cont "Sending it now."
	done

GiovanniRewardText:
	text "We have now"
	line "guaranteed our"
	cont "superiority."

	para "Sending you your"
	line "reward now. Check"
	cont "your storage."
	done

GiovanniRefusalPlayerText:
	text "You mean MY"
	line "weapon? Get lost!"
	done

GiovanniRefusalText:
	text "Curse you,"
	line "traitor! This"
	cont "won't be the end"
	cont "of this."
	done
