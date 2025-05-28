/turf/simulated/mineral/virgo2/make_ore(var/rare_ore)					// Override V2 ore generation
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			ORE_MARBLE = 7,
			ORE_URANIUM = 10,
			ORE_PLATINUM = 10,
			ORE_HEMATITE = 10,
			ORE_CARBON = 10,
			ORE_DIAMOND = 4,
			ORE_GOLD = 15,
			ORE_SILVER = 15,
			ORE_LEAD = 5,
			ORE_VERDANTIUM = 2,
			ORE_RUTILE = 10))
	else
		mineral_name = pickweight(list(
			ORE_MARBLE = 5,
			ORE_URANIUM = 7,
			ORE_PLATINUM = 7,
			ORE_HEMATITE = 28,
			ORE_CARBON = 28,
			ORE_DIAMOND = 2,
			ORE_GOLD = 7,
			ORE_SILVER = 7,
			ORE_LEAD = 4,
			ORE_VERDANTIUM = 1,
			ORE_RUTILE = 10))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()
