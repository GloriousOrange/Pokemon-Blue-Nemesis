CheckTyranisEncounter::
	CheckEvent EVENT_TYRANIS_ENCOUNTERED
	ret nz
	CheckEvent EVENT_BEAT_ZAPDOS
	ret z
	CheckEvent EVENT_BEAT_ARTICUNO
	ret z
	CheckEvent EVENT_BEAT_MOLTRES
	ret z
	ld a, [wLastMap]
	cp VIRIDIAN_POKECENTER
	jr z, .triggerEncounter
	cp PEWTER_POKECENTER
	jr z, .triggerEncounter
	cp CERULEAN_POKECENTER
	jr z, .triggerEncounter
	cp MT_MOON_POKECENTER
	jr z, .triggerEncounter
	cp ROCK_TUNNEL_POKECENTER
	jr z, .triggerEncounter
	cp VERMILION_POKECENTER
	jr z, .triggerEncounter
	cp CELADON_POKECENTER
	jr z, .triggerEncounter
	cp LAVENDER_POKECENTER
	jr z, .triggerEncounter
	cp FUCHSIA_POKECENTER
	jr z, .triggerEncounter
	cp CINNABAR_POKECENTER
	jr z, .triggerEncounter
	cp SAFFRON_POKECENTER
	ret nz
.triggerEncounter
	SetEvent EVENT_TYRANIS_ENCOUNTERED
	ld a, TYRANIS
	ld [wCurOpponent], a
	ld a, 50
	ld [wCurEnemyLevel], a
	ret
