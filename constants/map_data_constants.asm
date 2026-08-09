; width of east/west connections
; height of north/south connections
DEF MAP_BORDER EQU 3

; connection directions
	const_def
	const EAST_F
	const WEST_F
	const SOUTH_F
	const NORTH_F

; wCurMapConnections
	const_def
	shift_const EAST   ; 1
	shift_const WEST   ; 2
	shift_const SOUTH  ; 4
	shift_const NORTH  ; 8

; wWarpEntries
DEF MAX_WARP_EVENTS EQU 32

; wNumSigns
DEF MAX_BG_EVENTS EQU 16

; wMapSpriteData
DEF MAX_OBJECT_EVENTS EQU 16

; The real per-map limit is one LOWER than the array size above. Sprite slot 0
; of wSpriteStateData1/2 belongs to the player, so map objects only get slots
; 1-15; a 16th object wraps around and overwrites the player's own slot. This
; is the bound def_warps_to enforces. Kept as a literal because
; NUM_SPRITESTATEDATA_STRUCTS is defined in the include after this one --
; map_object_constants.asm asserts the two agree.
DEF MAX_MAP_OBJECT_EVENTS EQU 15

; flower and water tile animations
	const_def
	const TILEANIM_NONE          ; 0
	const TILEANIM_WATER         ; 1
	const TILEANIM_WATER_FLOWER  ; 2
