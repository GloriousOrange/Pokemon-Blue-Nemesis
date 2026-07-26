; Boolean checks
DEF FALSE EQU 0
DEF TRUE  EQU 1

; flag operations
	const_def
	const FLAG_RESET ; 0
	const FLAG_SET   ; 1
	const FLAG_TEST  ; 2

; input
DEF NO_INPUT EQU 0

; SGB command MLT_REQ can be used to detect SGB hardware
DEF JOYP_SGB_MLT_REQ EQU %00000011

; Megan follower companion (engine/events/megan_follower.asm), consumed by
; the UpdateNPCSprite patch (engine/overworld/movement.asm) and the
; CollisionCheckOnLand patch (home/overworld.asm) -- needs to be visible
; from all three separately-compiled units, so it lives here rather than
; in megan_follower.asm itself.
DEF FOLLOWER_STEP_NONE  EQU 0
DEF FOLLOWER_STEP_DOWN  EQU 1
DEF FOLLOWER_STEP_UP    EQU 2
DEF FOLLOWER_STEP_LEFT  EQU 3
DEF FOLLOWER_STEP_RIGHT EQU 4

DEF FOLLOWER_SWAP_THRESHOLD EQU 16 ; consecutive blocked attempts before swap-through
