	map_header BattleIsland, BATTLE_ISLAND, OVERWORLD, EAST
	; Still only warp/Fly-reachable from the west/north/south (Cinnabar lab
	; secret warp room) -- that design is unchanged. The EAST connection chains
	; into the living-dex archipelago (Origin Isle onward); since the whole
	; chain is a dead end with no link back to the rest of Kanto, this doesn't
	; reopen the old surf-off-the-edge access issue the "no connections" comment
	; used to guard against.
	connection east, OriginIsle, ORIGIN_ISLE, 0
	end_map_header
