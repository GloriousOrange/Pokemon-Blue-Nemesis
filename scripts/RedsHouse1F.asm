RedsHouse1F_Script:
	jp EnableAutoTextBoxDrawing

RedsHouse1F_TextPointers:
	def_text_pointers
	dw_const RedsHouse1FMomText, TEXT_REDSHOUSE1F_MOM
	dw_const RedsHouse1FLevelMachineText, TEXT_REDSHOUSE1F_LEVEL_MACHINE
	dw_const RedsHouse1FTVText,  TEXT_REDSHOUSE1F_TV

RedsHouse1FMomText:
	text_asm
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jr nz, .heal
	ld hl, .WakeUpText
	call PrintText
	jr .done
.heal
	call RedsHouse1FMomHealScript
.done
	jp TextScriptEnd

.WakeUpText:
	text_far _RedsHouse1FMomWakeUpText
	text_end

RedsHouse1FMomHealScript:
	ld hl, RedsHouse1FMomYouShouldRestText
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, RedsHouse1FMomLookingGreatText
	jp PrintText

RedsHouse1FMomYouShouldRestText:
	text_far _RedsHouse1FMomYouShouldRestText
	text_end
RedsHouse1FMomLookingGreatText:
	text_far _RedsHouse1FMomLookingGreatText
	text_end

RedsHouse1FTVText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, .WrongSideText
	jr nz, .got_text
	ld hl, .StandByMeMovieText
.got_text
	call PrintText
	jp TextScriptEnd

.StandByMeMovieText:
	text_far _RedsHouse1FTVStandByMeMovieText
	text_end

.WrongSideText:
	text_far _RedsHouse1FTVWrongSideText
	text_end

; TEMP test machine: primes the LEVEL STONE (sets BIT_LEVEL_MACHINE_READY, cleared on
; the next map load) so you can verify the L100 upgrade legitimately, using the Poke
; Center healing-machine animation for flavor. Hands you a LEVEL STONE for convenience.
RedsHouse1FLevelMachineText:
	text_asm
	ld hl, .ChargeText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a ; 0 = YES
	jr nz, .declined
	ld a, [wPartyCount]
	and a
	jr z, .noPokemon ; AnimateHealingMachine loops over the party; guard empty party
	farcall AnimateHealingMachine
; AnimateHealingMachine leaves the map music stopped; restart it (as PokeCenter does)
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	call PlaySound
	ld hl, wPostGameMisc
	set BIT_LEVEL_MACHINE_READY, [hl]
	lb bc, LEVEL_STONE, 1
	call GiveItem
	ld hl, .ReadyText
	call PrintText
	jr .done
.noPokemon
	ld hl, .NoPokemonText
	call PrintText
	jr .done
.declined
	ld hl, .ComeAgainText
	call PrintText
.done
	jp TextScriptEnd

.ChargeText:
	text "LEVEL MACHINE:"
	line "Power up a POKéMON"
	cont "to LEVEL 100?"
	done

.ReadyText:
	text "The machine hums!"
	line "Use the LEVEL STONE"
	cont "on a POKéMON now."
	prompt

.ComeAgainText:
	text "Come back anytime!"
	prompt

.NoPokemonText:
	text "Bring a POKéMON"
	line "first!"
	prompt
