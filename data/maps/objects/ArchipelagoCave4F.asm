	object_const_def
	const_export ARCHIPELAGOCAVE4F_GHOST_ROCKET
	const_export ARCHIPELAGOCAVE4F_ESCAPE_ROPE

ArchipelagoCave4F_Object:
; Solid rock, NOT the water block. A water border would be crossable while
; SURFing -- the player would ride straight off the map edge into the
; tile-streaming padding and corrupt the screen, the same failure
; ArchipelagoCave1F's border comment describes. Rock reads as the grotto
; wall closing in, which suits the room anyway.
	db $3 ; border block (solid rock)

; The landing spot, and the way back up. A destination warp is mandatory --
; warp_event's 4th argument indexes the target map's warp list, so the fall
; from 3F has to have something to arrive on. Wired as a pair the way Seafoam
; wires its holes, which also means the player can never be stranded here.
; Kept clear of every object_event: standing an NPC on a warp cell froze the
; game on the Pokemon Tower stairs.
	def_warp_events
	warp_event 5, 6, ARCHIPELAGO_CAVE_3F, 2

	def_bg_events

	def_object_events
	object_event 5, 4, SPRITE_ROCKET, STAY, DOWN, TEXT_ARCHIPELAGOCAVE4F_GHOST_ROCKET, OPP_GHOST_ROCKET, 1
	object_event 6, 6, SPRITE_POKE_BALL, STAY, NONE, TEXT_ARCHIPELAGOCAVE4F_ESCAPE_ROPE, ESCAPE_ROPE

	def_warps_to ARCHIPELAGO_CAVE_4F
