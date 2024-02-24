#include "space_rocks_pois.dm"
#include "space_rocks_stuff.dm"

/turf/simulated/mineral/vacuum/sdmine/make_ore(var/rare_ore)
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