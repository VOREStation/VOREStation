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
			"carbon" = 5,
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
			"carbon" = 5,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25,
			"lead" = 1))

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/datum/random_map/noise/ore/spacerocks
	descriptor = "asteroid field ore distribution map"
	deep_val = 0.2
	rare_val = 0.1

/datum/random_map/noise/ore/spacerocks/check_map_sanity()
	return 1 //Totally random, but probably beneficial.

/area/sdmine/
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

/////LANDING LANDMARKS
/obj/effect/shuttle_landmark/premade/spacerocks/center
	name = "asteroid field center"
	landmark_tag = "sr-c"

/obj/effect/shuttle_landmark/premade/spacerocks/north
	name = "asteroid field north"
	landmark_tag = "sr-n"

/obj/effect/shuttle_landmark/premade/spacerocks/south
	name = "asteroid field south"
	landmark_tag = "sr-s"

/obj/tether_away_spawner/asteroidbaddies
	name = "Asteroid Mob Spawner"
	faction = "space_rock"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 40
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/bats = 10, 
		/mob/living/simple_mob/vore/alienanimals/space_jellyfish = 15, 
		/mob/living/simple_mob/vore/alienanimals/startreader = 15,
		/mob/living/simple_mob/vore/alienanimals/space_ghost = 6,
		/mob/living/simple_mob/vore/oregrub = 1,
		/mob/living/simple_mob/animal/space/carp = 3,
		/mob/living/simple_mob/animal/space/carp/large = 1,
		/mob/living/simple_mob/animal/space/carp/large/huge = 1
	)
