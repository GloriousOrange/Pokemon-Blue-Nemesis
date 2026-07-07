PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries, PrizeMenuMon1Cost
	dw PrizeMenuMon2Entries, PrizeMenuMon2Cost
	dw PrizeMenuTMsEntries,  PrizeMenuTMsCost

NoThanksText:
	db "NO THANKS@"

PrizeMenuMon1Entries:
	db ABRA
	db CLEFAIRY
IF DEF(_RED)
	db NIDORINA
ENDC
IF DEF(_BLUE)
	db NIDORINO
ENDC
	db "@"

PrizeMenuMon1Cost:
IF DEF(_RED)
	bcd2 180
	bcd2 500
ENDC
IF DEF(_BLUE)
	bcd2 120
	bcd2 750
ENDC
	bcd2 1200
	db "@"

PrizeMenuMon2Entries:
IF DEF(_RED)
	db DRATINI
	db SCYTHER
ENDC
IF DEF(_BLUE)
	db PINSIR
	db DRATINI
ENDC
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
IF DEF(_RED)
	bcd2 2800
	bcd2 5500
	bcd2 9999
ENDC
IF DEF(_BLUE)
	bcd2 2500
	bcd2 4600
	bcd2 6500
ENDC
	db "@"

PrizeMenuTMsEntries:
	db TM_DRAGON_RAGE
	db TM_HYPER_BEAM
	db TM_SUBSTITUTE
	db "@"

PrizeMenuTMsCost:
	bcd2 3300
	bcd2 5500
	bcd2 7700
	db "@"

; Rocket-loyalist exclusive prize list (BIT_ROCKET_LOYALTY), replaces the
; above for loyalists -- see engine/events/prize_menu.asm's GetPrizeMenuId.
; Priced so clearing the whole Rocket Hideout (11 trainers x 25 coins = 275)
; buys 3-4 prizes depending on choice; the rest needs slots.
RocketPrizeDifferentMenuPtrs:
	dw RocketPrizeMenuMon1Entries, RocketPrizeMenuMon1Cost
	dw RocketPrizeMenuMon2Entries, RocketPrizeMenuMon2Cost
	dw RocketPrizeMenuTMsEntries,  RocketPrizeMenuTMsCost

RocketPrizeMenuMon1Entries:
	db EKANS
	db GRIMER
	db KOFFING
	db "@"

RocketPrizeMenuMon1Cost:
	bcd2 40
	bcd2 55
	bcd2 70
	db "@"

RocketPrizeMenuMon2Entries:
	db MEOWTH
	db DODUO
	db SCYTHER
	db "@"

RocketPrizeMenuMon2Cost:
	bcd2 110
	bcd2 300
	bcd2 500
	db "@"

RocketPrizeMenuTMsEntries:
	db TM_TOXIC
	db TM_SWORDS_DANCE
	db TM_DOUBLE_TEAM
	db "@"

RocketPrizeMenuTMsCost:
	bcd2 180
	bcd2 350
	bcd2 550
	db "@"
