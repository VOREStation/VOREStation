/turf/simulated/mineral/vacuum/gb_mine/make_ore(var/rare_ore)
	if(mineral)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			ORE_MARBLE = 3,
			ORE_URANIUM = 10,
			ORE_PLATINUM = 10,
			ORE_HEMATITE = 20,
			ORE_CARBON = 20,
			ORE_DIAMOND = 1,
			ORE_GOLD = 8,
			ORE_SILVER = 8,
			ORE_PHORON = 18,
			ORE_LEAD = 2,
			ORE_VERDANTIUM = 1))
	else
		mineral_name = pickweight(list(
			ORE_MARBLE = 2,
			ORE_URANIUM = 5,
			ORE_PLATINUM = 5,
			ORE_HEMATITE = 35,
			ORE_CARBON = 35,
			ORE_GOLD = 3,
			ORE_SILVER = 3,
			ORE_PHORON = 25,
			ORE_LEAD = 1))

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/datum/random_map/noise/ore/gb_mining
	descriptor = "groundbase underground ore distribution map"
	deep_val = 0.7
	rare_val = 0.5

/datum/random_map/noise/ore/mining/check_map_sanity()
	return 1 //Totally random, but probably beneficial.
