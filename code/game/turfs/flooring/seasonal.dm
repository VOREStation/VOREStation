var/season

/proc/do_season()
	var/month = text2num(time2text(world.timeofday, "MM")) 	// get the current month

	switch(month)
		if(1 to 2)
			season = "winter"
		if(3 to 5)
			season = "spring"
		if(6 to 8)
			season = "summer"
		if(9 to 11)
			season = "autumn"
		if(12)
			season = "winter"

/turf/simulated/floor/outdoors/grass/seasonal
	name = "grass"
	icon = 'icons/seasonal/turf.dmi'
	icon_state = "s-grass"

	icon_edge = 'icons/seasonal/turf_edge.dmi'

	initial_flooring = /decl/flooring/grass/seasonal_grass
//	initial_flooring = null

	grass_types = list()
	var/static/list/overlays_cache = list()
	var/animal_chance = 0.5
	var/animal_types = list()
	var/tree_chance = 5
	var/tree_types = list()
	var/snow_chance = 10

/turf/simulated/floor/outdoors/grass/seasonal/Initialize()

	if(!season)
		do_season()
	switch(season)
		if("spring")
			tree_types = list(
				/obj/structure/flora/tree/bigtree,
				/obj/structure/flora/tree/jungle_small,
				/obj/structure/flora/tree/jungle
			)
			animal_types = list(
				/mob/living/simple_mob/vore/alienanimals/teppi = 10,
				/mob/living/simple_mob/vore/alienanimals/teppi/mutant = 1,
				/mob/living/simple_mob/vore/redpanda = 40,
				/mob/living/simple_mob/vore/redpanda/fae = 2,
				/mob/living/simple_mob/vore/sheep = 20,
				/mob/living/simple_mob/vore/rabbit/black = 20,
				/mob/living/simple_mob/vore/rabbit/white = 20,
				/mob/living/simple_mob/vore/rabbit/brown = 20,
				/mob/living/simple_mob/vore/leopardmander = 2,
				/mob/living/simple_mob/vore/horse/big = 10,
				/mob/living/simple_mob/vore/bigdragon/friendly = 1,
				/mob/living/simple_mob/vore/alienanimals/dustjumper = 20
			)
			grass_types = list(
				/obj/structure/flora/ausbushes/sparsegrass,
				/obj/structure/flora/ausbushes/fullgrass,
				/obj/structure/flora/ausbushes/brflowers,
				/obj/structure/flora/ausbushes/genericbush,
				/obj/structure/flora/ausbushes/lavendergrass,
				/obj/structure/flora/ausbushes/leafybush,
				/obj/structure/flora/ausbushes/ppflowers,
				/obj/structure/flora/ausbushes/sunnybush,
				/obj/structure/flora/ausbushes/ywflowers,
				/obj/structure/flora/mushroom
			)

			grass_chance = 30
		if("summer")
			tree_types = list(
				/obj/structure/flora/tree/bigtree,
				/obj/structure/flora/tree/jungle_small,
				/obj/structure/flora/tree/jungle
			)
			animal_types = list(
				/mob/living/simple_mob/vore/alienanimals/teppi = 10,
				/mob/living/simple_mob/vore/alienanimals/teppi/mutant = 1,
				/mob/living/simple_mob/vore/redpanda = 40,
				/mob/living/simple_mob/vore/redpanda/fae = 2,
				/mob/living/simple_mob/vore/sheep = 20,
				/mob/living/simple_mob/vore/rabbit/black = 20,
				/mob/living/simple_mob/vore/rabbit/white = 20,
				/mob/living/simple_mob/vore/rabbit/brown = 20,
				/mob/living/simple_mob/vore/leopardmander = 2,
				/mob/living/simple_mob/vore/horse/big = 10,
				/mob/living/simple_mob/vore/bigdragon/friendly = 1,
				/mob/living/simple_mob/vore/alienanimals/dustjumper = 20
			)
			grass_types = list(
				/obj/structure/flora/ausbushes/sparsegrass,
				/obj/structure/flora/ausbushes/fullgrass
			)

		if("autumn")
			tree_types = list(
				/obj/structure/flora/tree/bigtree
			)

			animal_types = list(
				/mob/living/simple_mob/vore/alienanimals/teppi = 10,
				/mob/living/simple_mob/vore/alienanimals/teppi/mutant = 1,
				/mob/living/simple_mob/vore/redpanda = 40,
				/mob/living/simple_mob/vore/redpanda/fae = 2,
				/mob/living/simple_mob/vore/sheep = 20,
				/mob/living/simple_mob/vore/rabbit/black = 20,
				/mob/living/simple_mob/vore/rabbit/white = 20,
				/mob/living/simple_mob/vore/rabbit/brown = 20,
				/mob/living/simple_mob/vore/horse/big = 10,
				/mob/living/simple_mob/vore/alienanimals/dustjumper = 20
			)
			grass_types = list(
				/obj/structure/flora/ausbushes/sparsegrass,
				/obj/structure/flora/pumpkin,
				/obj/structure/flora/ausbushes
			)

			grass_chance = 10
			animal_chance = 0.25
		if("winter")
			grass_chance = 0
			tree_types = list(
				/obj/structure/flora/tree/dead,
				/obj/structure/flora/tree/pine
			)

			animal_types = list(
				/mob/living/simple_mob/vore/rabbit/white = 40,
				/mob/living/simple_mob/vore/alienanimals/teppi = 10,
				/mob/living/simple_mob/vore/alienanimals/teppi/mutant = 1,
				/mob/living/simple_mob/vore/redpanda = 10
			)
			if(prob(snow_chance))
				chill()
				return

			grass_types = list(
				/obj/structure/flora/grass/both,
				/obj/structure/flora/grass/brown,
				/obj/structure/flora/grass/green,
				/obj/structure/flora/bush
			)

			grass_chance = 1
			animal_chance = 0.1


	if(tree_chance && prob(tree_chance) && !check_density())
		var/tree_type = pickweight(tree_types)
		new tree_type(src)


	if(animal_chance && prob(animal_chance) && !check_density())
		var/animal_type = pickweight(animal_types)
		new animal_type(src)


	. = ..()

/turf/simulated/floor/outdoors/grass/seasonal/proc/update_desc()

	switch(season)
		if("spring")
			desc = "Lush green grass, flourishing! Little flowers peek out from between the blades here and there!"
		if("summer")
			desc = "Bright green grass, a little dry in the summer heat!"
		if("autumn")
			desc = "Golden grass, it's a little crunchy as it prepares for winter!"
		if("winter")
			desc = "Dry, seemingly dead grass! It's too cold for the grass..."


/turf/simulated/floor/outdoors/grass/seasonal/update_icon(update_neighbors)
	. = ..()
	update_desc()
	switch(season)
		if("spring")
			if(prob(50))
				var/cache_key = "[season]-overlay[rand(1,19)]"
				if(!overlays_cache[cache_key])
					var/image/I = image(icon = src.icon, icon_state = cache_key, layer = ABOVE_TURF_LAYER) // Icon should be abstracted out
					I.plane = TURF_PLANE
					overlays_cache[cache_key] = I
				add_overlay(overlays_cache[cache_key])
		if("summer")
			return
		if("autumn")
			if(prob(33))
				var/cache_key = "[season]-overlay[rand(1,6)]"
				if(!overlays_cache[cache_key])
					var/image/I = image(icon = src.icon, icon_state = cache_key, layer = ABOVE_TURF_LAYER) // Icon should be abstracted out
					I.plane = TURF_PLANE
					overlays_cache[cache_key] = I
				add_overlay(overlays_cache[cache_key])

		if("winter")
			return

/turf/simulated/floor/outdoors/grass/seasonal/no_trees
	tree_chance = 0
/turf/simulated/floor/outdoors/grass/seasonal/no_mobs
	animal_chance = 0
/turf/simulated/floor/outdoors/grass/seasonal/no_trees_or_mobs
	tree_chance = 0
	animal_chance = 0
/turf/simulated/floor/outdoors/grass/seasonal/no_trees_or_mobs_or_snow
	tree_chance = 0
	animal_chance = 0
	snow_chance = 0
/turf/simulated/floor/outdoors/grass/seasonal/low_snow
	snow_chance = 1
