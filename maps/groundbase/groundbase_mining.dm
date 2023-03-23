/turf/simulated/mineral/vacuum/gb_mine/make_ore(var/rare_ore)
	if(mineral)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"marble" = 3,
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"carbon" = 20,
			"diamond" = 1,
			"gold" = 8,
			"silver" = 8,
			"phoron" = 18,
			"lead" = 2,
			"verdantium" = 1))
	else
		mineral_name = pickweight(list(
			"marble" = 2,
			"uranium" = 5,
			"platinum" = 5,
			"hematite" = 35,
			"carbon" = 35,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25,
			"lead" = 1))

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

/area/gb_mine/
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/vacuum
/area/gb_mine/unexplored
	name = "Virgo 3c Underground"
	icon_state = "unexplored"
/area/gb_mine/explored
	name = "Virgo 3c Underground"
	icon_state = "explored"
