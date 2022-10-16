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
	icon_state = "spring"

	icon_edge = 'icons/seasonal/turf_edge.dmi'

	initial_flooring = /decl/flooring/grass/seasonal_grass
//	initial_flooring = null

	var/static/list/overlays_cache = list()

/turf/simulated/floor/outdoors/grass/seasonal/Initialize()

	if(!season)
		do_season()

	switch(season)
		if("spring")
			desc = "Lush green grass, flourishing! Little flowers peek out from between the blades here and there!"
			grass_chance = 30
		if("summer")
			desc = "Bright green grass, a little dry in the summer heat!"
		if("autumn")
			desc = "Golden grass, it's a little crunchy as it prepares for winter!"
			grass_chance = 10
		if("winter")
			desc = "Dry, seemingly dead grass! It's too cold for the grass..."
			grass_chance = 0

	return ..()

/turf/simulated/floor/outdoors/grass/seasonal/update_icon(update_neighbors)
	. = ..()

	if(prob(33))
		var/cache_key = "[season]-overlay[rand(1,6)]"
		if(!overlays_cache[cache_key])
			var/image/I = image(icon = src.icon, icon_state = cache_key, layer = ABOVE_TURF_LAYER) // Icon should be abstracted out
			I.plane = TURF_PLANE
			overlays_cache[cache_key] = I
		add_overlay(overlays_cache[cache_key])
