; The S.S. OLYMPIA's ten decks, terminated with -1.
;
; Her decks are scattered through the map list rather than contiguous, so
; "is the player aboard" has to be a table scan, not a range check like
; IsSilphCoMap.
;
; INCLUDEd from more than one bank on purpose -- IsOnSSOlympia (start_sub_menus,
; bank $04, gates the PHONE) and ApplyOlympiaTrainerMoveset (the floating Mutagen
; Movesets section) both need it, and a cross-bank read would cost more than the
; eleven bytes. Keeping the list in one file means adding a deck updates every
; copy; do NOT paste these ids anywhere else.
	db SS_OLYMPIA_1F, SS_OLYMPIA_2F, SS_OLYMPIA_3F, SS_OLYMPIA_B1F
	db SS_OLYMPIA_BOW, SS_OLYMPIA_KITCHEN, SS_OLYMPIA_CAPTAINS_ROOM
	db SS_OLYMPIA_1F_ROOMS, SS_OLYMPIA_2F_ROOMS, SS_OLYMPIA_B1F_ROOMS
	db -1 ; end
