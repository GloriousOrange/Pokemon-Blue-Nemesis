TrainerDataPointers:
	table_width 2
	dw YoungsterData
	dw BugCatcherData
	dw LassData
	dw SailorData
	dw JrTrainerMData
	dw JrTrainerFData
	dw PokemaniacData
	dw SuperNerdData
	dw HikerData
	dw BikerData
	dw BurglarData
	dw EngineerData
	dw UnusedJugglerData
	dw FisherData
	dw SwimmerData
	dw CueBallData
	dw GamblerData
	dw BeautyData
	dw PsychicData
	dw RockerData
	dw JugglerData
	dw TamerData
	dw BirdKeeperData
	dw BlackbeltData
	dw Rival1Data
	dw ProfOakData
	dw ChiefData
	dw ScientistData
	dw GiovanniData
	dw RocketData
	dw CooltrainerMData
	dw CooltrainerFData
	dw BrunoData
	dw BrockData
	dw MistyData
	dw LtSurgeData
	dw ErikaData
	dw KogaData
	dw BlaineData
	dw SabrinaData
	dw GentlemanData
	dw Rival2Data
	dw Rival3Data
	dw LoreleiData
	dw ChannelerData
	dw AgathaData
	dw LanceData
	dw GeneralMathusData
	dw MeganData
	dw GhostRocketData
	assert_table_length NUM_TRAINERS

; if first byte != $FF, then
	; first byte is level (of all pokemon on this team)
	; all the next bytes are pokemon species
	; null-terminated
; if first byte == $FF, then
	; first byte is $FF (obviously)
	; every next two bytes are a level and species
	; null-terminated

YoungsterData:
; Route 3
	db 11, RATTATA, EKANS, 0
	db 14, SPEAROW, 0
; Mt. Moon 1F
	db 10, RATTATA, RATTATA, ZUBAT, 0
; Route 24
	db 14, RATTATA, EKANS, ZUBAT, 0
; Route 25
	db 15, RATTATA, SPEAROW, 0
	db 17, SLOWPOKE, 0
	db 14, EKANS, SANDSHREW, 0
; SS Anne 1F Rooms
	db 21, NIDORAN_M, 0
; Route 11
	db 21, EKANS, 0
	db 19, SANDSHREW, ZUBAT, 0
	db 17, RATTATA, RATTATA, RATICATE, 0
	db 18, NIDORAN_M, NIDORINO, 0
; Unused
	db 17, SPEAROW, RATTATA, RATTATA, SPEAROW, 0

	db 100, RATICATE, FEAROW, PRIMEAPE, 0 ; ARENA #22 (youngster)
	db 100, RATICATE, 0 ; 15 -- S.S. Olympia (Youngster)

BugCatcherData:
; Viridian Forest
	db 6, WEEDLE, CATERPIE, 0
	db 7, WEEDLE, KAKUNA, WEEDLE, 0
	db $ff, 9, WEEDLE, 10, PINSIR, 0
; Route 3
	db 10, CATERPIE, WEEDLE, CATERPIE, 0
	db 9, WEEDLE, KAKUNA, CATERPIE, METAPOD, 0
	db 11, CATERPIE, METAPOD, 0
; Mt. Moon 1F
	db 11, WEEDLE, KAKUNA, 0
	db 10, CATERPIE, METAPOD, CATERPIE, 0
; Route 24
	db 14, CATERPIE, WEEDLE, 0
; Route 6
	db 16, WEEDLE, CATERPIE, WEEDLE, 0
	db 20, BUTTERFREE, 0
; Unused
	db 18, METAPOD, CATERPIE, VENONAT, 0
; Route 9
	db 19, BEEDRILL, BEEDRILL, 0
	db 20, CATERPIE, WEEDLE, VENONAT, 0

	db 100, PINSIR, SCYTHER, BEEDRILL, 0 ; ARENA #1 (bug catcher)

; Toby -- Elite Four Bug Catcher (took Bruno's slot). Custom movesets for
; Parasect/Butterfree/Pinsir are applied in ReadTrainer (.MaybeToby).
	db $FF, 55, PARASECT, 55, BUTTERFREE, 56, BEEDRILL, 57, SCYTHER, 58, PINSIR, 0 ; #16 TOBY
	db 100, PINSIR, 0 ; 17 -- S.S. Olympia (TOBY)
	db 100, BEEDRILL, 0 ; 18 -- S.S. Olympia (Bug Catcher)

LassData:
; Route 3
	db 9, PIDGEY, PIDGEY, 0
	db 10, RATTATA, NIDORAN_M, 0
	db 14, JIGGLYPUFF, 0
; Route 4
	db 31, PARAS, PARAS, PARASECT, 0
; Mt. Moon 1F
	db 11, ODDISH, BELLSPROUT, 0
	db 14, CLEFAIRY, 0
; Route 24
	db 16, PIDGEY, NIDORAN_F, 0
	db 14, PIDGEY, NIDORAN_F, 0
; Route 25
	db 15, NIDORAN_M, NIDORAN_F, 0
	db 13, ODDISH, PIDGEY, ODDISH, 0
; SS Anne 1F Rooms
	db 18, PIDGEY, NIDORAN_F, 0
; SS Anne 2F Rooms
	db 18, RATTATA, PIKACHU, 0
; Route 8
	db 23, NIDORAN_F, NIDORINA, 0
	db 24, MEOWTH, MEOWTH, MEOWTH, 0
	db 19, PIDGEY, RATTATA, NIDORAN_M, MEOWTH, PIKACHU, 0
	db 22, CLEFAIRY, CLEFAIRY, 0
; Celadon Gym
	db 23, BELLSPROUT, WEEPINBELL, 0
	db 23, ODDISH, GLOOM, 0
	db $ff, 8, LICKITUNG, 7, SLOWPOKE, 6, JIGGLYPUFF, 0 ; #19 unused (was an earlier planned 2nd Megan encounter)
	db 100, CLEFABLE, 0 ; 20 -- S.S. Olympia (Lass)

SailorData:
; SS Anne Stern
	db 18, MACHOP, SHELLDER, 0
	db 17, MACHOP, TENTACOOL, 0
; SS Anne B1F Rooms
	db 21, SHELLDER, 0
	db 17, HORSEA, SHELLDER, TENTACOOL, 0
	db 18, TENTACOOL, STARYU, 0
	db 17, HORSEA, HORSEA, HORSEA, 0
	db 20, MACHOP, 0
; Vermilion Gym
	db 21, PIKACHU, PIKACHU, 0
	db 100, POLIWRATH, 0 ; 9 -- S.S. Olympia (Sailor)

JrTrainerMData:
; Pewter Gym
	db 11, DIGLETT, SANDSHREW, 0
; Route 24/Route 25
	db 14, RATTATA, EKANS, 0
; Route 24
	db 18, MANKEY, 0
; Route 6
	db 20, SQUIRTLE, 0
	db 16, SPEAROW, RATICATE, 0
; Unused
	db 18, DIGLETT, DIGLETT, SANDSHREW, 0
; Route 9
	db 21, GROWLITHE, CHARMANDER, 0
	db 19, RATTATA, DIGLETT, EKANS, SANDSHREW, 0
; Route 12
	db 29, NIDORAN_M, NIDORINO, 0

	db 100, NIDOKING, BLASTOISE, PIDGEOT, 0 ; ARENA #19 (jr trainer m)
	db 100, NIDOKING, 0 ; 11 -- S.S. Olympia (Jr.Trainer M)

JrTrainerFData:
; Cerulean Gym
	db 19, GOLDEEN, 0
; Route 6
	db 16, RATTATA, PIKACHU, 0
	db 16, PIDGEY, PIDGEY, PIDGEY, 0
; Unused
	db 22, BULBASAUR, 0
; Route 9
	db 18, ODDISH, BELLSPROUT, ODDISH, BELLSPROUT, 0
	db 23, MEOWTH, 0
; Route 10
	db 20, PIKACHU, CLEFAIRY, 0
	db 21, PIDGEY, PIDGEOTTO, 0
; Rock Tunnel B1F
	db 21, JIGGLYPUFF, PIDGEY, MEOWTH, 0
	db 22, ODDISH, BULBASAUR, 0
; Celadon Gym
	db 24, BULBASAUR, IVYSAUR, 0
; Route 13
	db 24, PIDGEY, MEOWTH, RATTATA, PIKACHU, MEOWTH, 0
	db 30, POLIWAG, POLIWAG, 0
	db 27, PIDGEY, MEOWTH, PIDGEY, PIDGEOTTO, 0
	db 28, GOLDEEN, POLIWAG, HORSEA, 0
; Route 20
	db 31, GOLDEEN, SEAKING, 0
; Rock Tunnel 1F
	db 22, BELLSPROUT, CLEFAIRY, 0
	db 20, MEOWTH, ODDISH, PIDGEY, 0
	db 19, PIDGEY, RATTATA, RATTATA, BELLSPROUT, 0
; Route 15
	db 28, GLOOM, ODDISH, ODDISH, 0
	db 29, PIKACHU, RAICHU, 0
	db 33, CLEFAIRY, 0
	db 29, BELLSPROUT, ODDISH, TANGELA, 0
; Route 20
	db 30, TENTACOOL, HORSEA, SEEL, 0

	db 100, NIDOQUEEN, EXEGGUTOR, PARASECT, 0 ; ARENA #13 (jr trainer f)
	db 100, WIGGLYTUFF, 0 ; 26 -- S.S. Olympia (Jr.Trainer F)

PokemaniacData:
; Route 10
	db 30, RHYHORN, LICKITUNG, 0
	db 20, CUBONE, SLOWPOKE, 0
; Rock Tunnel B1F
	db 20, SLOWPOKE, SLOWPOKE, SLOWPOKE, 0
	db 22, CHARMANDER, CUBONE, 0
	db 25, SLOWPOKE, 0
; Victory Road 2F
	db 40, CHARMELEON, LAPRAS, LICKITUNG, 0
; Rock Tunnel 1F
	db 23, CUBONE, SLOWPOKE, 0
; Victory Road 2F
	db $ff, 50, MOLTRES, 42, MAGMAR, 44, ARCANINE, 38, FLAREON, 0
; Mt Moon 1F -- the mutant rumour. A lone DITTO on purpose: it transforms into
; whatever you lead with, which is the joke, and it keeps an early fight from
; being a wall for any of the 78 starters.
	db 12, DITTO, 0

	db 100, VICTREEBEL, PERSIAN, SLOWBRO, 0 ; ARENA #6 (pokemaniac)
	db 100, RHYDON, 0 ; 10 -- S.S. Olympia (Pokemaniac)

SuperNerdData:
; Mt. Moon 1F
	db 11, MAGNEMITE, VOLTORB, 0
; Mt. Moon B2F
	db 12, GRIMER, VOLTORB, KOFFING, 0
; Route 8
	db 20, VOLTORB, KOFFING, VOLTORB, EKANS, 0 ; "Snake?" gag -- has an Ekans
	db 22, GRIMER, MUK, GRIMER, 0
	db 26, KOFFING, 0
; Unused
	db 22, KOFFING, MAGNEMITE, WEEZING, 0
	db 20, MAGNEMITE, MAGNEMITE, KOFFING, MAGNEMITE, 0
	db 24, MAGNEMITE, VOLTORB, 0
; Cinnabar Gym
	db 36, VULPIX, VULPIX, NINETALES, 0
	db 34, PONYTA, CHARMANDER, VULPIX, GROWLITHE, 0
	db 41, RAPIDASH, 0
	db 37, GROWLITHE, VULPIX, 0

	db 100, DITTO, KANGASKHAN, LICKITUNG, 0 ; ARENA #23 (super nerd)
	db 100, MAGNETON, 0 ; 14 -- S.S. Olympia (Super Nerd)

HikerData:
; Mt. Moon 1F
	db 10, GEODUDE, GEODUDE, ONIX, 0
; Route 25
	db 15, MACHOP, GEODUDE, 0
	db 13, GEODUDE, GEODUDE, MACHOP, GEODUDE, 0
	db 17, ONIX, 0
; Route 9
	db 21, GEODUDE, ONIX, 0
	db 20, GEODUDE, MACHOP, GEODUDE, 0
; Route 10
	db 21, GEODUDE, ONIX, 0
	db 19, ONIX, GRAVELER, 0
; Rock Tunnel B1F
	db 21, GEODUDE, GEODUDE, GRAVELER, 0
	db 25, GEODUDE, 0
; Route 9/Rock Tunnel B1F
	db 20, MACHOP, ONIX, 0
; Rock Tunnel 1F
	db 19, GEODUDE, MACHOP, GEODUDE, GEODUDE, 0
	db 20, ONIX, ONIX, GEODUDE, 0
	db 21, GEODUDE, GRAVELER, 0
; Seafoam Islands B4F
	db $ff, 50, ARTICUNO, 42, JYNX, 44, LAPRAS, 38, DEWGONG, 0

	db 100, ONIX, RHYDON, GOLEM, 0 ; ARENA #2 (hiker)
	db 100, ONIX, 0 ; 17 -- S.S. Olympia (Hiker)

BikerData:
; Route 13
	db 28, KOFFING, KOFFING, KOFFING, 0
; Route 14
	db 29, KOFFING, GRIMER, 0
; Route 15
	db 25, KOFFING, KOFFING, WEEZING, KOFFING, GRIMER, 0
	db 28, KOFFING, GRIMER, WEEZING, 0
; Route 16
	db 29, GRIMER, KOFFING, 0
	db 33, WEEZING, 0
	db 26, GRIMER, GRIMER, GRIMER, GRIMER, 0
; Route 17
	; From https://www.smogon.com/smog/issue27/glitch:
	; 0E:5FC2 is offset of the ending 0 for this first Biker on Route 17.
	; BaseStats + (BASE_DATA_SIZE) * (000 - 1) = $5FC2;
	; that's the formula from GetMonHeader for the base stats of mon #000.
	; (BaseStats = $43DE and BANK(BaseStats) = $0E.)
	; Finally, PokedexOrder lists 0 as the dex ID for every MissingNo.
	; The result is that this data gets interpreted as the base stats
	; for MissingNo: 0, 33, MUK, 0, 29, VOLTORB, VOLTORB, 0, ..., 28, GRIMER, GRIMER.
	db 28, WEEZING, KOFFING, WEEZING, 0
	db 33, MUK, 0
	db 29, VOLTORB, VOLTORB, 0
	db 29, WEEZING, MUK, 0
	db 25, KOFFING, WEEZING, KOFFING, KOFFING, WEEZING, 0
; Route 14
	db 26, KOFFING, KOFFING, GRIMER, KOFFING, 0
	db 28, GRIMER, GRIMER, KOFFING, 0
	db 29, KOFFING, MUK, 0

	db 100, MUK, WEEZING, ARBOK, 0 ; ARENA #5 (biker)
	db 100, MUK, 0 ; 17 -- S.S. Olympia (Biker)

BurglarData:
; Unused
	db 29, GROWLITHE, VULPIX, 0
	db 33, GROWLITHE, 0
	db 28, VULPIX, CHARMANDER, PONYTA, 0
; Cinnabar Gym
	db 36, GROWLITHE, VULPIX, NINETALES, 0
	db 41, PONYTA, 0
	db 37, VULPIX, GROWLITHE, 0
; Mansion 2F
	db 34, CHARMANDER, CHARMELEON, 0
; Mansion 3F
	db 38, NINETALES, 0
; Mansion B1F
	db 34, GROWLITHE, PONYTA, 0

	db 100, RAPIDASH, RATICATE, HYPNO, 0 ; ARENA #9 (burglar)
	db 100, ARCANINE, 0 ; 11 -- S.S. Olympia (Burglar)

EngineerData:
; Unused
	db 21, VOLTORB, MAGNEMITE, 0
; Route 11
	db 21, MAGNEMITE, 0
	db 18, MAGNEMITE, MAGNEMITE, MAGNETON, 0

	db 100, ELECTRODE, MAGNETON, RAICHU, 0 ; ARENA #12 (engineer)
	db 100, ELECTRODE, 0 ; 5 -- S.S. Olympia (Engineer)

UnusedJugglerData:
; none

FisherData:
; SS Anne 2F Rooms
	db 17, GOLDEEN, TENTACOOL, GOLDEEN, 0
; SS Anne B1F Rooms
	db 17, TENTACOOL, STARYU, SHELLDER, 0
; Route 12
	db 22, GOLDEEN, POLIWAG, GOLDEEN, 0
	db 24, TENTACOOL, GOLDEEN, 0
	db 27, GOLDEEN, 0
	db 21, POLIWAG, SHELLDER, GOLDEEN, HORSEA, 0
; Route 21
	db 28, SEAKING, GOLDEEN, SEAKING, SEAKING, 0
	db 31, SHELLDER, CLOYSTER, 0
	db 27, MAGIKARP, MAGIKARP, MAGIKARP, MAGIKARP, MAGIKARP, MAGIKARP, 0
	db 33, SEAKING, GOLDEEN, 0
; Route 12
	db 24, MAGIKARP, MAGIKARP, 0

	db 100, SEADRA, GYARADOS, OMASTAR, 0 ; ARENA #8 (fisher)
	db 100, GYARADOS, 0 ; 13 -- S.S. Olympia (Fisher)

SwimmerData:
; Cerulean Gym
	db 16, HORSEA, SHELLDER, 0
; Route 19
	db 30, TENTACOOL, SHELLDER, 0
	db 29, GOLDEEN, HORSEA, STARYU, 0
	db 30, POLIWAG, POLIWHIRL, 0
	db 27, HORSEA, TENTACOOL, TENTACOOL, GOLDEEN, 0
	db 29, GOLDEEN, SHELLDER, SEAKING, 0
	db 30, HORSEA, HORSEA, 0
	db 27, TENTACOOL, TENTACOOL, STARYU, HORSEA, TENTACRUEL, 0
; Route 20
	db 31, SHELLDER, CLOYSTER, 0
	db 35, STARYU, 0
	db 28, HORSEA, HORSEA, SEADRA, HORSEA, 0
; Route 21
	db 33, SEADRA, TENTACRUEL, 0
	db 37, STARMIE, 0
	db 33, STARYU, WARTORTLE, 0
	db 32, POLIWHIRL, TENTACOOL, SEADRA, 0

	db 100, CLOYSTER, SEAKING, GOLDUCK, 0 ; ARENA #24 (swimmer)
	db 100, TENTACRUEL, 0 ; 17 -- S.S. Olympia (Swimmer)

CueBallData:
; Route 16
	db 28, MACHOP, MANKEY, MACHOP, 0
	db 29, MANKEY, MACHOP, 0
	db 33, MACHOP, 0
; Route 17
	db 29, MANKEY, PRIMEAPE, 0
	db 29, MACHOP, MACHOKE, 0
	db 33, MACHOKE, 0
	db 26, MANKEY, MANKEY, MACHOKE, MACHOP, 0
	db 29, PRIMEAPE, MACHOKE, 0
; Route 21
	db 31, TENTACOOL, TENTACOOL, TENTACRUEL, 0
	db 100, PRIMEAPE, 0 ; 10 -- S.S. Olympia (Cue Ball)

GamblerData:
; Route 11
	db 18, POLIWAG, HORSEA, 0
	db 18, BELLSPROUT, ODDISH, 0
	db 18, VOLTORB, MAGNEMITE, 0
	db 18, GROWLITHE, VULPIX, 0
; Route 8
	db 22, POLIWAG, POLIWAG, POLIWHIRL, 0
; Unused
	db 22, ONIX, GEODUDE, GRAVELER, 0
; Route 8
	db 24, GROWLITHE, VULPIX, 0

	db 100, CHANSEY, PINSIR, ALAKAZAM, 0 ; ARENA #17 (gambler)
	db 100, GOLDUCK, 0 ; 9 -- S.S. Olympia (Gambler)

BeautyData:
; Celadon Gym
	db 21, ODDISH, BELLSPROUT, ODDISH, BELLSPROUT, 0
	db 24, BELLSPROUT, BELLSPROUT, 0
	db 26, EXEGGCUTE, 0
; Route 13
	db 27, RATTATA, PIKACHU, RATTATA, 0
	db 29, CLEFAIRY, MEOWTH, 0
; Route 20
	db 35, SEAKING, 0
	db 30, SHELLDER, SHELLDER, CLOYSTER, 0
	db 31, POLIWAG, SEAKING, 0
; Route 15
	db 29, PIDGEOTTO, WIGGLYTUFF, 0
	db 29, BULBASAUR, IVYSAUR, 0
; Unused
	db 33, WEEPINBELL, BELLSPROUT, WEEPINBELL, 0
; Route 19
	db 27, POLIWAG, GOLDEEN, SEAKING, GOLDEEN, POLIWAG, 0
	db 30, GOLDEEN, SEAKING, 0
	db 29, STARYU, STARYU, STARYU, 0
; Route 20
	db 30, SEADRA, HORSEA, SEADRA, 0

	db 100, LAPRAS, JYNX, WIGGLYTUFF, 0 ; ARENA #10 (beauty)
	db 100, VILEPLUME, 0 ; 17 -- S.S. Olympia (Beauty)

PsychicData:
; Saffron Gym
	db 31, KADABRA, SLOWPOKE, MR_MIME, KADABRA, 0
	db 34, MR_MIME, KADABRA, 0
	db 33, SLOWPOKE, SLOWPOKE, SLOWBRO, 0
	db 38, SLOWBRO, 0

	db 100, ALAKAZAM, HYPNO, MR_MIME, 0 ; ARENA #20 (psychic)
	db 100, HYPNO, 0 ; 6 -- S.S. Olympia (Psychic)

RockerData:
; Vermilion Gym
	db 20, VOLTORB, MAGNEMITE, VOLTORB, 0
; Route 12
	db 29, VOLTORB, ELECTRODE, 0
	db 100, JYNX, SANDSLASH, PIDGEOT, 0 ; ARENA #26 (rocker)
; Silph Co. 5F loyalist path -- stands in for the ROCKER (JUGGLER #1), same team
	db 29, KADABRA, MR_MIME, 0                         ; #129
	db 100, JOLTEON, 0 ; 5 -- S.S. Olympia (Rocker)

JugglerData:
; Silph Co. 5F
	db 29, KADABRA, MR_MIME, 0
; Victory Road 2F
	db 41, DROWZEE, HYPNO, KADABRA, KADABRA, 0
; Fuchsia Gym
	db 31, DROWZEE, DROWZEE, KADABRA, DROWZEE, 0
	db 34, DROWZEE, HYPNO, 0
; Victory Road 2F
	db 48, MR_MIME, 0
; Unused
	db 33, HYPNO, 0
; Fuchsia Gym
	db 38, HYPNO, 0
	db 34, DROWZEE, KADABRA, 0
; Power Plant
	db $ff, 50, ZAPDOS, 42, RAICHU, 44, ELECTABUZZ, 38, JOLTEON, 0

	db 100, MACHAMP, TENTACRUEL, MR_MIME, 0 ; ARENA #7 (juggler)

; Ex-Tamers reclassed as Jugglers (Norman is now the game's only Tamer).
; Fuchsia Gym (rosters unchanged from their Tamer days)
	db 34, SANDSLASH, ARBOK, 0                ; #11 (Fuchsia, was Tamer 1)
	db 33, ARBOK, SANDSLASH, ARBOK, 0         ; #12 (Fuchsia, was Tamer 2)
; Victory Road 2F (roster unchanged)
	db 44, PERSIAN, GOLDUCK, 0                ; #13 (Victory Road, was Tamer 5)
; Viridian Gym reskin -- Normal-type rosters (was Tamer 3 / 4)
	db 43, TAUROS, KANGASKHAN, 0             ; #14 (Viridian ex-Rocker1)
	db 44, EEVEE, PERSIAN, 0                 ; #15 (Viridian ex-Rocker2)
	db 100, MR_MIME, 0 ; 16 -- S.S. Olympia (Juggler)

TamerData:
; Norman -- Viridian Gym leader (the game's only remaining Tamer).
; Movesets deferred (per-mon levels via $FF format, auto level-up moves).
	db $FF, 46, TAUROS, 53, SNORLAX, 47, CHANSEY, 50, KANGASKHAN, 48, EEVEE, 51, PERSIAN, 0 ; #1 NORMAN

	db 100, TAUROS, GYARADOS, CHARIZARD, 0 ; ARENA #2 (tamer, was #25 ref)
; NORMAN, the Beast Tamer who runs Viridian Gym (Normal type, the Harmony
; badge). A named leader aboard, not background scenery -- OPP_TAMER stopped
; being a generic class when he took the gym.
	db 100, TAUROS, 0 ; 3 -- S.S. Olympia (NORMAN)

BirdKeeperData:
; Route 13
	db 29, PIDGEY, PIDGEOTTO, 0
	db 25, SPEAROW, PIDGEY, PIDGEY, SPEAROW, SPEAROW, 0
	db 26, PIDGEY, PIDGEOTTO, SPEAROW, FEAROW, 0
; Route 14
	db 33, FARFETCHD, 0
	db 29, SPEAROW, FEAROW, 0
; Route 15
	db 26, PIDGEOTTO, FARFETCHD, DODUO, PIDGEY, 0
	db 28, DODRIO, DODUO, DODUO, 0
; Route 18
	db 29, SPEAROW, FEAROW, 0
	db 34, DODRIO, 0
	db 26, SPEAROW, SPEAROW, FEAROW, SPEAROW, 0
; Route 20
	db 30, FEAROW, FEAROW, PIDGEOTTO, 0
; Unused
	db 39, PIDGEOTTO, PIDGEOTTO, PIDGEY, PIDGEOTTO, 0
	db 42, FARFETCHD, FEAROW, 0
; Route 14
	db 28, PIDGEY, DODUO, PIDGEOTTO, 0
	db 26, PIDGEY, SPEAROW, PIDGEY, FEAROW, 0
	db 29, PIDGEOTTO, FEAROW, 0
	db 28, SPEAROW, DODUO, FEAROW, 0

	db 100, ZAPDOS, MOLTRES, ARTICUNO, 0 ; ARENA #21 (bird keeper)
	db 100, PIDGEOT, 0 ; 19 -- S.S. Olympia (Bird Keeper)

BlackbeltData:
; Fighting Dojo
	db 37, HITMONLEE, HITMONCHAN, 0
	db 31, MANKEY, MANKEY, PRIMEAPE, 0
	db 32, MACHOP, MACHOKE, 0
	db 36, PRIMEAPE, 0
	db 31, MACHOP, MANKEY, PRIMEAPE, 0
; Viridian Gym (Normal-type reskin)
	db 43, WIGGLYTUFF, CLEFABLE, 0            ; #6 (Viridian HIKER1)
	db 45, SNORLAX, 0                         ; #7 (Viridian HIKER2)
	db 42, MEOWTH, PERSIAN, RATICATE, 0       ; #8 (Viridian HIKER3)
; Victory Road 2F
	db 43, MACHOKE, MACHOP, MACHOKE, 0

	db 100, HITMONLEE, HITMONCHAN, MACHAMP, 0 ; ARENA #14 (blackbelt)
	db 100, HITMONLEE, 0 ; 11 -- S.S. Olympia (Blackbelt)

Rival1Data:
	db 5, SQUIRTLE, 0
	db 5, BULBASAUR, 0
	db 5, CHARMANDER, 0
; Route 22
	db $FF, 9, PIDGEY, 8, SQUIRTLE, 0
	db $FF, 9, PIDGEY, 8, BULBASAUR, 0
	db $FF, 9, PIDGEY, 8, CHARMANDER, 0
; Cerulean City
	db $FF, 18, PIDGEOTTO, 15, ABRA, 15, RATTATA, 17, SQUIRTLE, 0
	db $FF, 18, PIDGEOTTO, 15, ABRA, 15, RATTATA, 17, BULBASAUR, 0
	db $FF, 18, PIDGEOTTO, 15, ABRA, 15, RATTATA, 17, CHARMANDER, 0
; Custom Oak's Lab rival teams (teams 10-43) generated by scripts/gen_tables.py
	db 5, PIKACHU, 0      ; team 10
	db 5, GROWLITHE, 0    ; team 11
	db 5, MANKEY, 0       ; team 12
	db 5, MACHOP, 0       ; team 13
	db 5, HITMONLEE, 0    ; team 14
	db 5, SANDSHREW, 0    ; team 15
	db 5, ABRA, 0         ; team 16
	db 5, DROWZEE, 0      ; team 17
	db 5, HITMONCHAN, 0   ; team 18
	db 5, PSYDUCK, 0      ; team 19
	db 5, PRIMEAPE, 0     ; team 20
	db 5, PONYTA, 0       ; team 21
	db 5, ODDISH, 0       ; team 22
	db 5, VOLTORB, 0      ; team 23
	db 5, POLIWAG, 0      ; team 24
	db 5, MAGNEMITE, 0    ; team 25
	db 5, CATERPIE, 0     ; team 26
	db 5, ELECTABUZZ, 0   ; team 27
	db 5, STARYU, 0       ; team 28
	db 5, JOLTEON, 0      ; team 29
	db 5, DIGLETT, 0      ; team 30
	db 5, WEEDLE, 0       ; team 31
	db 5, GEODUDE, 0      ; team 32
	db 5, MAGMAR, 0       ; team 33
	db 5, BELLSPROUT, 0   ; team 34
	db 5, JYNX, 0         ; team 35
	db 5, EXEGGCUTE, 0    ; team 36
	db 5, VENONAT, 0      ; team 37
	db 5, CUBONE, 0       ; team 38
	db 5, SEEL, 0         ; team 39
	db 5, HORSEA, 0       ; team 40
	db 5, DRATINI, 0      ; team 41
	db 5, SCYTHER, 0      ; team 42
	db 5, PINSIR, 0       ; team 43

ProfOakData:
; Unused
	db $FF, 66, TAUROS, 67, EXEGGUTOR, 68, ARCANINE, 69, BLASTOISE, 70, GYARADOS, 0
	db $FF, 66, TAUROS, 67, EXEGGUTOR, 68, ARCANINE, 69, VENUSAUR, 70, GYARADOS, 0
	db $FF, 66, TAUROS, 67, EXEGGUTOR, 68, ARCANINE, 69, CHARIZARD, 70, GYARADOS, 0
	db $FF, 99, MEW, 99, DITTO, 99, PORYGON, 99, LAPRAS, 99, TAUROS, 99, MEWTWO, 0 ; #4 burned-lab boss (post-game Oak) -- MEWTWO restored, moved to last slot; real freeze cause found & fixed (division-by-zero on a crit vs a high-Def/Special mon, engine/battle/core.asm), wasn't Mewtwo/Alakazam specific
	db 40, NIDOKING, ALAKAZAM, ARCANINE, BLASTOISE, 0 ; #5 Silph Co. 11F, ROCKET loyalist path
	db 100, MEWTWO, 0 ; 6 -- S.S. Olympia (OAK)

ChiefData:
; none

ScientistData:
; Unused
	db 34, KOFFING, VOLTORB, 0
; Silph Co. 2F
	db 26, GRIMER, WEEZING, KOFFING, WEEZING, 0
	db 28, MAGNEMITE, VOLTORB, MAGNETON, 0
; Silph Co. 3F/Mansion 1F
	db 29, ELECTRODE, WEEZING, 0
; Silph Co. 4F
	db 33, ELECTRODE, 0
; Silph Co. 5F
	db 26, MAGNETON, KOFFING, WEEZING, MAGNEMITE, 0
; Silph Co. 6F
	db 25, VOLTORB, KOFFING, MAGNETON, MAGNEMITE, KOFFING, 0
; Silph Co. 7F
	db 29, ELECTRODE, MUK, 0
; Silph Co. 8F
	db 29, GRIMER, ELECTRODE, 0
; Silph Co. 9F
	db 28, VOLTORB, KOFFING, MAGNETON, 0
; Silph Co. 10F
	db 29, MAGNEMITE, KOFFING, 0
; Mansion 3F
	db 33, MAGNEMITE, MAGNETON, VOLTORB, 0
; Mansion B1F
	db 34, MAGNEMITE, ELECTRODE, 0
; Burned-lab scientists (post-game), one L100 mon each
	db 100, PORYGON, 0   ; #14 lab scientist 1
	db 100, ELECTRODE, 0 ; #15 lab scientist 2
	db 100, MAGNETON, 0  ; #16 lab scientist 3
	db 100, ALAKAZAM, 0  ; #17 lab scientist 4
	db 100, GENGAR, 0    ; #18 lab scientist 5
	db 100, DITTO, 0     ; #19 lab scientist 6

	db 100, PORYGON, ELECTRODE, DITTO, 0 ; ARENA #3 (scientist)
; Silph Co. 11F Loyalist path (replaces the Giovanni fight)
	db $FF, 38, PORYGON, 39, TAUROS, 37, FEAROW, 0 ; #21
; --- Silph Co. loyalist path: SILPH staff defending the building. Each team is
; --- copied verbatim from the ROCKET whose tile this trainer shares, so both
; --- paths fight the same 28 battles at the same difficulty.
	db 29, CUBONE, ZUBAT, 0                            ; #22 Silph 2F  (copy of ROCKET #23)
	db 25, GOLBAT, ZUBAT, ZUBAT, RATICATE, ZUBAT, 0    ; #23 Silph 2F  (copy of ROCKET #24)
	db 28, RATICATE, HYPNO, RATICATE, 0                ; #24 Silph 3F  (copy of ROCKET #25)
	db 29, MACHOP, DROWZEE, 0                          ; #25 Silph 4F  (copy of ROCKET #26)
	db 28, EKANS, ZUBAT, CUBONE, 0                     ; #26 Silph 4F  (copy of ROCKET #27)
	db 33, ARBOK, 0                                    ; #27 Silph 5F  (copy of ROCKET #28)
	db 33, HYPNO, 0                                    ; #28 Silph 5F  (copy of ROCKET #29)
	db 29, MACHOP, MACHOKE, 0                          ; #29 Silph 6F  (copy of ROCKET #30)
	db 28, ZUBAT, ZUBAT, GOLBAT, 0                     ; #30 Silph 6F  (copy of ROCKET #31)
	db 26, RATICATE, ARBOK, KOFFING, GOLBAT, 0         ; #31 Silph 7F  (copy of ROCKET #32)
	db 29, CUBONE, CUBONE, 0                           ; #32 Silph 7F  (copy of ROCKET #33)
	db 29, SANDSHREW, SANDSLASH, 0                     ; #33 Silph 7F  (copy of ROCKET #34)
	db 26, RATICATE, ZUBAT, GOLBAT, RATTATA, 0         ; #34 Silph 8F  (copy of ROCKET #35)
	db 28, WEEZING, GOLBAT, KOFFING, 0                 ; #35 Silph 8F  (copy of ROCKET #36)
	db 28, DROWZEE, GRIMER, MACHOP, 0                  ; #36 Silph 9F  (copy of ROCKET #37)
	db 28, GOLBAT, DROWZEE, HYPNO, 0                   ; #37 Silph 9F  (copy of ROCKET #38)
	db 33, MACHOKE, 0                                  ; #38 Silph 10F (copy of ROCKET #39)
	db 25, RATTATA, RATTATA, ZUBAT, RATTATA, EKANS, 0  ; #39 Silph 11F (copy of ROCKET #40)


GiovanniData:
; Rocket Hideout B4F
	db $FF, 25, ONIX, 24, RHYHORN, 29, KANGASKHAN, 0
; Silph Co. 11F
	db $FF, 37, NIDORINO, 35, KANGASKHAN, 37, RHYHORN, 41, NIDOQUEEN, 0
; Viridian Gym
	db $FF, 45, RHYHORN, 42, DUGTRIO, 44, NIDOQUEEN, 45, NIDOKING, 50, RHYDON, 0
	db $FF, 68, RHYDON, 66, DUGTRIO, 67, NIDOKING, 65, NIDOQUEEN, 69, GOLEM, 70, SANDSLASH, 0 ; #4 Viridian gym post-game rematch
	db $FF, 100, MEWTWO, 100, RHYDON, 100, NIDOKING, 100, PERSIAN, 100, SANDSLASH, 100, GOLEM, 0 ; #5 Battle Island final boss
	db 100, PERSIAN, 0 ; 6 -- S.S. Olympia (GIOVANNI)

RocketData:
; Mt. Moon B2F
	db 13, RATTATA, ZUBAT, 0
	db 11, SANDSHREW, RATTATA, ZUBAT, 0
	db 12, ZUBAT, EKANS, 0
	db 16, RATICATE, 0
; Cerulean City
	db 17, MACHOP, DROWZEE, 0
; Route 24
	db 15, EKANS, ZUBAT, 0
; Game Corner
	db 20, RATICATE, ZUBAT, 0
; Rocket Hideout B1F
	db 21, DROWZEE, MACHOP, 0
	db 21, RATICATE, RATICATE, 0
	db 20, GRIMER, KOFFING, KOFFING, 0
	db 19, RATTATA, RATICATE, RATICATE, RATTATA, 0
	db 22, GRIMER, KOFFING, 0
; Rocket Hideout B2F
	db 17, ZUBAT, KOFFING, GRIMER, ZUBAT, RATICATE, 0
; Rocket Hideout B3F
	db 20, RATTATA, RATICATE, DROWZEE, 0
	db 21, MACHOP, MACHOP, 0
; Rocket Hideout B4F
	db 23, SANDSHREW, EKANS, SANDSLASH, 0
	db 23, EKANS, SANDSHREW, ARBOK, 0
	db 21, KOFFING, ZUBAT, 0
; Pokémon Tower 7F
	db 25, ZUBAT, ZUBAT, GOLBAT, 0
	db 26, KOFFING, DROWZEE, 0
	db 23, ZUBAT, RATTATA, RATICATE, ZUBAT, 0
; Unused
	db 26, DROWZEE, KOFFING, 0
; Silph Co. 2F
	db 29, CUBONE, ZUBAT, 0
	db 25, GOLBAT, ZUBAT, ZUBAT, RATICATE, ZUBAT, 0
; Silph Co. 3F
	db 28, RATICATE, HYPNO, RATICATE, 0
; Silph Co. 4F
	db 29, MACHOP, DROWZEE, 0
	db 28, EKANS, ZUBAT, CUBONE, 0
; Silph Co. 5F
	db 33, ARBOK, 0
	db 33, HYPNO, 0
; Silph Co. 6F
	db 29, MACHOP, MACHOKE, 0
	db 28, ZUBAT, ZUBAT, GOLBAT, 0
; Silph Co. 7F
	db 26, RATICATE, ARBOK, KOFFING, GOLBAT, 0
	db 29, CUBONE, CUBONE, 0
	db 29, SANDSHREW, SANDSLASH, 0
; Silph Co. 8F
	db 26, RATICATE, ZUBAT, GOLBAT, RATTATA, 0
	db 28, WEEZING, GOLBAT, KOFFING, 0
; Silph Co. 9F
	db 28, DROWZEE, GRIMER, MACHOP, 0
	db 28, GOLBAT, DROWZEE, HYPNO, 0
; Silph Co. 10F
	db 33, MACHOKE, 0
; Silph Co. 11F
	db 25, RATTATA, RATTATA, ZUBAT, RATTATA, EKANS, 0
	db 32, CUBONE, DROWZEE, MAROWAK, 0

	db 100, MUK, GOLBAT, GENGAR, 0 ; ARENA #11 (rocket)

	db $FF, 38, MUK, 39, RATICATE, 37, ZUBAT, 0 ; 43 -- Silph Co. 11F hero-path gatekeeper (ZUBAT knows BLOOD_SUCK from its own learnset, level 32)

CooltrainerMData:
; Viridian Gym (Normal-type reskin)
	db 44, PERSIAN, SNORLAX, 0                ; #1 (Viridian COOLTRAINER_M3)
; Victory Road 3F
	db 43, EXEGGUTOR, CLOYSTER, ARCANINE, 0
	db 43, KINGLER, TENTACRUEL, BLASTOISE, 0
; Unused
	db 45, KINGLER, STARMIE, 0
; Victory Road 1F
	db 42, IVYSAUR, WARTORTLE, CHARMELEON, CHARIZARD, 0
; Unused
	db 44, IVYSAUR, WARTORTLE, CHARMELEON, 0
	db 49, NIDOKING, 0
	db 44, KINGLER, CLOYSTER, 0
; Viridian Gym (Normal-type reskin)
	db 43, RATICATE, PERSIAN, 0              ; #9 (Viridian COOLTRAINER_M1)
	db 44, TAUROS, KANGASKHAN, 0             ; #10 (Viridian COOLTRAINER_M2)

	db 100, CHARIZARD, NIDOKING, TAUROS, 0 ; ARENA #4 (cooltrainer m)
	db 100, DRAGONITE, RAICHU, VENUSAUR, 0 ; ARENA #16 (cooltrainer m)

CooltrainerFData:
; Celadon Gym
	db 24, WEEPINBELL, GLOOM, IVYSAUR, 0
; Victory Road 3F
	db 43, BELLSPROUT, WEEPINBELL, VICTREEBEL, 0
	db 43, PARASECT, DEWGONG, CHANSEY, 0
; Unused
	db 46, VILEPLUME, BUTTERFREE, 0
; Victory Road 1F
	db 44, PERSIAN, NINETALES, 0
; Unused
	db 45, IVYSAUR, VENUSAUR, 0
	db 45, NIDORINA, NIDOQUEEN, 0
	db 43, PERSIAN, NINETALES, RAICHU, 0
	db 100, NIDOQUEEN, 0 ; 9 -- S.S. Olympia (Cooltrainer F)

BrunoData:
; Now the Fighting Dojo master (moved from the Elite Four). One Onix -> Golem.
	db $FF, 53, GOLEM, 55, HITMONCHAN, 55, HITMONLEE, 56, ONIX, 58, MACHAMP, 0
	db 100, MACHAMP, 0 ; 2 -- S.S. Olympia (BRUNO)

BrockData:
	db $FF, 12, GEODUDE, 14, ONIX, 0
	db $FF, 68, GOLEM, 66, ONIX, 67, RHYDON, 65, OMASTAR, 69, KABUTOPS, 70, AERODACTYL, 0 ; #2 post-game rematch
	db 100, GOLEM, 0 ; 3 -- S.S. Olympia (BROCK)

MistyData:
	db $FF, 18, STARYU, 21, STARMIE, 0
	db $FF, 68, STARMIE, 66, GYARADOS, 67, LAPRAS, 65, BLASTOISE, 69, CLOYSTER, 70, VAPOREON, 0 ; #2 post-game rematch
	db 100, STARMIE, 0 ; 3 -- S.S. Olympia (MISTY)

LtSurgeData:
	db $FF, 21, VOLTORB, 18, PIKACHU, 24, RAICHU, 0
	db $FF, 68, RAICHU, 66, ELECTRODE, 67, MAGNETON, 65, JOLTEON, 69, ELECTABUZZ, 70, TAUROS, 0 ; #2 post-game rematch
	db 100, RAICHU, 0 ; 3 -- S.S. Olympia (LT.SURGE)

ErikaData:
	db $FF, 29, VICTREEBEL, 24, TANGELA, 29, VILEPLUME, 0
	db $FF, 68, VENUSAUR, 66, VILEPLUME, 67, VICTREEBEL, 65, EXEGGUTOR, 69, TANGELA, 70, PARASECT, 0 ; #2 post-game rematch
	db 100, VENUSAUR, 0 ; 3 -- S.S. Olympia (ERIKA)

KogaData:
	db $FF, 37, KOFFING, 39, MUK, 37, KOFFING, 43, WEEZING, 0
	db $FF, 68, MUK, 66, WEEZING, 67, VENOMOTH, 65, TENTACRUEL, 69, GENGAR, 70, ARBOK, 0 ; #2 post-game rematch
	db 100, WEEZING, 0 ; 3 -- S.S. Olympia (KOGA)

BlaineData:
	db $FF, 42, GROWLITHE, 40, PONYTA, 42, RAPIDASH, 47, ARCANINE, 0
	db $FF, 68, ARCANINE, 66, NINETALES, 67, RAPIDASH, 65, MAGMAR, 69, FLAREON, 70, CHARIZARD, 0 ; #2 post-game rematch
	db 100, CHARIZARD, 0 ; 3 -- S.S. Olympia (BLAINE)

SabrinaData:
	db $FF, 38, KADABRA, 37, MR_MIME, 38, VENOMOTH, 43, ALAKAZAM, 0
	db $FF, 68, ALAKAZAM, 66, MR_MIME, 67, EXEGGUTOR, 65, HYPNO, 69, SLOWBRO, 70, STARMIE, 0 ; #2 post-game rematch
	db 100, ALAKAZAM, 0 ; 3 -- S.S. Olympia (SABRINA)

GentlemanData:
; SS Anne 1F Rooms
	db 18, GROWLITHE, GROWLITHE, 0
	db 19, NIDORAN_M, NIDORAN_F, 0
; SS Anne 2F Rooms/Vermilion Gym
	db 23, PIKACHU, 0
; Unused
	db 48, PRIMEAPE, 0
; SS Anne 2F Rooms
	db 17, GROWLITHE, PONYTA, 0

	db 100, ARCANINE, PIKACHU, NINETALES, 0 ; ARENA #18 (gentleman)

Rival2Data:
; SS Anne 2F
	db $FF, 19, PIDGEOTTO, 16, RATICATE, 18, KADABRA, 20, WARTORTLE, 0
	db $FF, 19, PIDGEOTTO, 16, RATICATE, 18, KADABRA, 20, IVYSAUR, 0
	db $FF, 19, PIDGEOTTO, 16, RATICATE, 18, KADABRA, 20, CHARMELEON, 0
; Pokémon Tower 2F -- happens AFTER Silph Co in this mod's reversed gating,
; and right after his starter died there (see _SilphCo7FRivalDefeatedText:
; he's here with its ashes), so: no starter, rest leveled above his Silph team.
	db $FF, 41, PIDGEOTTO, 42, GROWLITHE, 41, EXEGGCUTE, 43, KADABRA, 0
	db $FF, 41, PIDGEOTTO, 42, GYARADOS, 41, GROWLITHE, 43, KADABRA, 0
	db $FF, 41, PIDGEOTTO, 42, EXEGGCUTE, 41, GYARADOS, 43, KADABRA, 0
; Silph Co. 7F
	db $FF, 37, PIDGEOT, 38, GROWLITHE, 35, EXEGGCUTE, 35, ALAKAZAM, 40, BLASTOISE, 0
	db $FF, 37, PIDGEOT, 38, GYARADOS, 35, GROWLITHE, 35, ALAKAZAM, 40, VENUSAUR, 0
	db $FF, 37, PIDGEOT, 38, EXEGGCUTE, 35, GYARADOS, 35, ALAKAZAM, 40, CHARIZARD, 0
; Route 22 (the rival's dead starter fights on as a ghost -- ReadTrainer
; patches mon 6 to GHOST/GHOST + Night Shade for sets 10-12; Mewtwo moved to
; the burned-lab ambush, set 13)
	db $FF, 47, PIDGEOT, 45, RHYHORN, 45, GROWLITHE, 47, EXEGGCUTE, 50, ALAKAZAM, 55, BLASTOISE, 0
	db $FF, 47, PIDGEOT, 45, RHYHORN, 45, GROWLITHE, 47, EXEGGCUTE, 50, ALAKAZAM, 55, VENUSAUR, 0
	db $FF, 47, PIDGEOT, 45, RHYHORN, 45, GROWLITHE, 47, EXEGGCUTE, 50, ALAKAZAM, 55, CHARIZARD, 0
; Burned-lab ambush (Pokemon Mansion 1F, first visit): Oak's Mewtwo, solo.
; ReadTrainer gives it the custom 5-move set (Psychic/Ice Beam/Swift/Amnesia/
; Recover); AIMoveChoiceModification4 makes it Recover below half HP.
	db $FF, 70, MEWTWO, 0 ; #13

Rival3Data:
	; trainer 1 — rival starter: SQUIRTLE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, SQUIRTLE, 0
	; trainer 2 — rival starter: BULBASAUR
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, BULBASAUR, 0
	; trainer 3 — rival starter: CHARMANDER
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, CHARMANDER, 0
	; trainer 4 — rival starter: PIKACHU
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, PIKACHU, 0
	; trainer 5 — rival starter: GROWLITHE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, GROWLITHE, 0
	; trainer 6 — rival starter: MANKEY
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, MANKEY, 0
	; trainer 7 — rival starter: MACHOP
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, MACHOP, 0
	; trainer 8 — rival starter: HITMONLEE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, HITMONLEE, 0
	; trainer 9 — rival starter: SANDSHREW
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, SANDSHREW, 0
	; trainer 10 — rival starter: ABRA
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, ABRA, 0
	; trainer 11 — rival starter: DROWZEE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, DROWZEE, 0
	; trainer 12 — rival starter: HITMONCHAN
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, HITMONCHAN, 0
	; trainer 13 — rival starter: PSYDUCK
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, PSYDUCK, 0
	; trainer 14 — rival starter: PRIMEAPE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, PRIMEAPE, 0
	; trainer 15 — rival starter: PONYTA
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, PONYTA, 0
	; trainer 16 — rival starter: ODDISH
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, ODDISH, 0
	; trainer 17 — rival starter: VOLTORB
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, VOLTORB, 0
	; trainer 18 — rival starter: POLIWAG
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, POLIWAG, 0
	; trainer 19 — rival starter: MAGNEMITE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, MAGNEMITE, 0
	; trainer 20 — rival starter: CATERPIE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, CATERPIE, 0
	; trainer 21 — rival starter: ELECTABUZZ
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, ELECTABUZZ, 0
	; trainer 22 — rival starter: STARYU
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, STARYU, 0
	; trainer 23 — rival starter: JOLTEON
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, JOLTEON, 0
	; trainer 24 — rival starter: DIGLETT
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, DIGLETT, 0
	; trainer 25 — rival starter: WEEDLE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, WEEDLE, 0
	; trainer 26 — rival starter: GEODUDE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, GEODUDE, 0
	; trainer 27 — rival starter: MAGMAR
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, MAGMAR, 0
	; trainer 28 — rival starter: BELLSPROUT
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, BELLSPROUT, 0
	; trainer 29 — rival starter: JYNX
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, JYNX, 0
	; trainer 30 — rival starter: EXEGGCUTE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, EXEGGCUTE, 0
	; trainer 31 — rival starter: VENONAT
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, VENONAT, 0
	; trainer 32 — rival starter: CUBONE
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, CUBONE, 0
	; trainer 33 — rival starter: SEEL
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, SEEL, 0
	; trainer 34 — rival starter: HORSEA
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, HORSEA, 0
	; trainer 35 — rival starter: DRATINI
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, DRATINI, 0
	; trainer 36 — rival starter: SCYTHER
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, SCYTHER, 0
	; trainer 37 — rival starter: PINSIR
	db $FF, 61, PIDGEOT, 59, ALAKAZAM, 61, RHYDON, 63, ARCANINE, 63, EXEGGUTOR, 65, PINSIR, 0

; The six-mon rival superboss. All L100: his dead starter's ghost, his
; path-tier bird (Tyranis/Miasma/Nocturn), and the four mutants -- Alakachamp
; (comes with Double Team/Counter/Psychic/Mind Fever from its own base-stats
; learnset; Uppercut is patched into the 5th slot in ReadTrainer), then
; Pinsirite, Ninefrost and Dignemite.
; Selected by GetPlayerPath (0/1/2 -> trainer 38/39/40).
;
; UNREFERENCED as of the Olympia vacation re-theme (2026-08-02): the deck fight
; is now the one-Pokemon trainer 41 below. Josh is relocating this fight
; elsewhere, so the three path rosters are kept ready -- do NOT delete them.
;
; mon1 is his dead starter fighting on as a true ghost. It is NOT Gengar any
; more (Josh, 2026-08-02): ReadTrainer (.OlympiaRival) overwrites mon1's species
; with wRivalStarter and forces both its types to GHOST. The species written
; below is only a fallback for a save with no starter recorded -- he could have
; started with any of the 37 species in Rival3StarterTable, and patching at
; battle-load time is what keeps this at three rosters instead of 37 per path.
;
; mons 4-6 are the three mutants, swapped in 2026-08-08 over the legendary
; birds that were standing in for them. They need no move patching: each has a
; level-up learnset that converges on its curated Mutagenstone kit by L95, so
; AddPartyMon's normal fill already hands them the intended five moves at L100.
	; trainer 38 — Hero path (Tyranis)
	db $FF, 100, GENGAR, 100, TYRANIS, 100, ALAKACHAMP, 100, PINSIRITE, 100, NINEFROST, 100, DIGNEMITE, 0
	; trainer 39 — Loyalist path (Miasma)
	db $FF, 100, GENGAR, 100, MIASMA, 100, ALAKACHAMP, 100, PINSIRITE, 100, NINEFROST, 100, DIGNEMITE, 0
	; trainer 40 — Traitor path (Nocturn)
	db $FF, 100, GENGAR, 100, NOCTURN, 100, ALAKACHAMP, 100, PINSIRITE, 100, NINEFROST, 100, DIGNEMITE, 0

; S.S. Olympia deck rival (endgame). One L100 Alakachamp, per the ship's
; one-Pokemon rule -- the same rule the player is held to aboard. Path-agnostic:
; with the birds gone there is nothing left to vary, so all three paths meet the
; same fight and this needs no GetPlayerPath branch.
	; trainer 41 — S.S. Olympia deck
	db $FF, 100, ALAKACHAMP, 0

LoreleiData:
	db $FF, 54, DEWGONG, 53, CLOYSTER, 54, SLOWBRO, 56, JYNX, 56, LAPRAS, 0
	db 100, LAPRAS, 0 ; 2 -- S.S. Olympia (LORELEI)

ChannelerData:
; Unused
	db 22, GASTLY, 0
	db 24, GASTLY, 0
	db 23, GASTLY, GASTLY, 0
	db 24, GASTLY, 0
; Pokémon Tower 3F
	db 23, GASTLY, 0
	db 24, GASTLY, 0
; Unused
	db 24, HAUNTER, 0
; Pokémon Tower 3F
	db 22, GASTLY, 0
; Pokémon Tower 4F
	db 24, GASTLY, 0
	db 23, GASTLY, GASTLY, 0
; Unused
	db 24, GASTLY, 0
; Pokémon Tower 4F
	db 22, GASTLY, 0
; Unused
	db 24, GASTLY, 0
; Pokémon Tower 5F
	db 23, HAUNTER, 0
; Unused
	db 24, GASTLY, 0
; Pokémon Tower 5F
	db 22, GASTLY, 0
	db 24, GASTLY, 0
	db 22, HAUNTER, 0
; Pokémon Tower 6F
	db 22, GASTLY, GASTLY, GASTLY, 0
	db 24, GASTLY, 0
	db 24, GASTLY, 0
; Saffron Gym
	db 34, GASTLY, HAUNTER, 0
	db 38, HAUNTER, 0
	db 33, GASTLY, GASTLY, HAUNTER, 0

	db 100, GASTLY, HAUNTER, GENGAR, 0 ; ARENA #15 (channeler)

AgathaData:
	db $FF, 56, GENGAR, 56, GOLBAT, 55, HAUNTER, 58, ARBOK, 60, GENGAR, 0
	db 100, GENGAR, 0 ; 2 -- S.S. Olympia (AGATHA)

LanceData:
	db $FF, 58, GYARADOS, 56, DRAGONAIR, 56, DRAGONAIR, 60, AERODACTYL, 62, DRAGONITE, 0
	db 100, DRAGONITE, 0 ; 2 -- S.S. Olympia (LANCE)

; Pokemon Tower 6F. A normal trainer fight; winning it hands Nocturn over via
; GivePokemon in the after-battle script (scripts/PokemonTower6F.asm), which
; also spends the player's Master Ball.
GeneralMathusData:
	db $FF, 30, NOCTURN, 0

; Route 1, meet-cute (moved off the generic Lass class so battle text says
; "MEGAN wants to fight!" instead of "LASS wants to fight!")
MeganData:
	db 1, SLOWPOKE, 0
; Optional training battles, one per gym, offered by her gym NPC before you
; challenge the leader. The party index is derived from her location index
; (see MeganGymOffer), so these must stay in gym order:
; Pewter, Cerulean, Vermilion, Celadon, Fuchsia, Saffron, Cinnabar, Viridian.
; Levels sit just under each leader's team, except Viridian, which is meant to
; outclass Norman as a final sparring partner. Slowpoke evolves at 37, so the
; last three are Slowbro.
	db 10, SLOWPOKE, 0 ; #2 Pewter    (Brock 12-14)
	db 16, SLOWPOKE, 0 ; #3 Cerulean  (Misty 18-21)
	db 20, SLOWPOKE, 0 ; #4 Vermilion (Surge 18-24)
	db 26, SLOWPOKE, 0 ; #5 Celadon   (Erika 24-29)
	db 32, SLOWPOKE, 0 ; #6 Fuchsia   (Koga 37-43)
	db 38, SLOWBRO, 0  ; #7 Saffron   (Sabrina 37-43)
	db 44, SLOWBRO, 0  ; #8 Cinnabar  (Blaine 40-47)
	db 55, SLOWBRO, 0  ; #9 Viridian  (Norman 46-53)
; The two endgame sparring stops, both optional like the gyms.
	db 70, SLOWBRO, 0  ; #10 Indigo Plateau lobby, before the Elite Four
	db 100, SLOWBRO, 0 ; #11 Battle Island
	db 100, SLOWBRO, 0 ; 12 -- S.S. Olympia (MEGAN)

GhostRocketData:
; The Archipelago Cave grotto. Six level 100 "resurrected" MON, all of them
; the mod's poison/rot line-up so the team reads as one dead crew rather than
; a grab bag. GENGAR is already GHOST in vanilla; the other five are made
; part-GHOST at send-out (see the GHOST_ROCKET hook in ReadTrainer).
; Written in the $ff per-mon-level format even though every mon is L100.
; The uniform-level format runs .LoopTrainerData, which jumps straight to
; .FinishUp and never reaches the trainer-class dispatch -- so the
; .GhostRocketCrew patch would silently never apply. Confirmed with
; tools/trainer_probe.py, which showed the crew loading un-ghosted.
	db $ff, 100, RATICATE, 100, ARBOK, 100, MUK, 100, WEEZING, 100, VICTREEBEL, 100, GENGAR, 0
