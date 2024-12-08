#include "space_rocks_pois.dm"
#include "space_rocks_stuff.dm"

/turf/simulated/mineral/vacuum/sdmine/make_ore(var/rare_ore)
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

/area/sdmine
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/vacuum
/area/sdmine/unexplored
	name = "asteroid field"
	icon_state = "unexplored"
/area/sdmine/explored
	name = "asteroid field"
	icon_state = "explored"


/obj/effect/overmap/visitable/sector/virgo3b/generate_skybox(zlevel)
	var/static/image/smallone = image(icon = 'icons/skybox/virgo3b.dmi', icon_state = "small")

	if(zlevel == Z_LEVEL_SPACE_ROCKS)
		return smallone
