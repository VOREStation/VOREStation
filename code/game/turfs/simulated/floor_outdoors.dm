/client/verb/test_outdoors_lights()
	var/amount_range = input("Range", "Light Test", 2) as num
	var/amount_brightness = input("Brightness", "Light Test", 1) as num
	var/new_color = input("Color", "Light Test", "#FFFFFF") as color

	for(var/turf/simulated/floor/outdoors/T in outdoor_turfs)
		T.set_light(amount_range, amount_brightness, new_color)
	world << "Finished."

/*
/client/verb/test_outdoor_time()
	var/new_time = input("New time, in hours", "Day/Night cycle", 1) as num
	var/datum/time/sif/time = new()
	time = time.add_hours(new_time)
	world << time.show_time("hh:mm:ss")

	var/length_of_day = time.seconds_in_day / 10 / 60 / 60 // 32
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	var/lerp_weight = distance_from_noon / noon

	var/noon_range = 5
	var/midnight_range = 3

	var/noon_brightness = 1
	var/midnight_brightness = 0.06

//	var/amount_range = Interpolate(noon_range, midnight_range, weight = lerp_weight)
	var/amount_range = 2
	var/amount_brightness = Interpolate(noon_brightness, midnight_brightness, weight = lerp_weight) ** 3

	world << "Changing time.  [outdoor_turfs.len] turfs need to be updated.  Expected ETA: [outdoor_turfs.len * 0.0033] seconds."
	world << "Setting outdoor tiles to set_light([amount_range], [amount_brightness])."
	var/i = 0
	for(var/turf/simulated/floor/outdoors/T in outdoor_turfs)
		T.set_light(amount_range, amount_brightness, "#FFFFFF")
		i++
		if(i % 30 == 0)
			sleep(1)
	world << "Finished."
*/

/client/verb/test_outdoor_timelapse()
	var/i = 32
	var/j = 0
	while(i)
		test_outdoor_time(j)
		j++
		i--
		sleep(5 SECONDS)

/client/verb/test_outdoor_snow()
	for(var/turf/simulated/floor/T in outdoor_turfs)
		T.overlays |= image(icon = 'icons/turf/outdoors.dmi', icon_state = "snowfall_med", layer = LIGHTING_LAYER - 1)


/client/verb/test_outdoor_time(new_time as num)
	//var/new_time = input("New time, in hours", "Day/Night cycle", 1) as num
	var/datum/time/sif/time = new()
	time = time.add_hours(new_time)
	world << time.show_time("hh:mm:ss")

	var/length_of_day = time.seconds_in_day / 10 / 60 / 60 // 32
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	var/sun_position = distance_from_noon / noon
	sun_position = abs(sun_position - 1)

	var/low_brightness = null
	var/high_brightness = null

	var/low_color = null
	var/high_color = null
	var/min = 0
	switch(sun_position)
		if(0 to 0.40) // Night
			low_brightness = 0.2
			low_color = "#000066"

			high_brightness = 0.5
			high_color = "#66004D"
			world << "Night."
			min = 0

		if(0.40 to 0.50) // Twilight
			low_brightness = 0.6
			low_color = "#66004D"

			high_brightness = 0.8
			high_color = "#CC3300"
			world << "Twilight."
			min = 0.40

		if(0.50 to 0.70) // Sunrise/set
			low_brightness = 0.8
			low_color = "#CC3300"

			high_brightness = 0.9
			high_color = "#FF9933"
			world << "Sunrise/set."
			min = 0.50

		if(0.70 to 1.00) // Noon
			low_brightness = 0.9
			low_color = "#DDDDDD"

			high_brightness = 1.0
			high_color = "#FFFFFF"
			world << "Noon."
			min = 0.70

	//var/lerp_weight = (sun_position * 4 % 1) / (0.25 / 4) // This weirdness is needed because otherwise the compiler divides by zero.
	var/lerp_weight = (abs(min - sun_position)) * 4
	world << "lerp_weight is [lerp_weight], sun_position is [sun_position]."
	var/new_brightness = Interpolate(low_brightness, high_brightness, weight = lerp_weight)

	var/list/low_color_list = hex2rgb(low_color)
	var/low_r = low_color_list[1]
	var/low_g = low_color_list[2]
	var/low_b = low_color_list[3]

	var/list/high_color_list = hex2rgb(high_color)
	var/high_r = high_color_list[1]
	var/high_g = high_color_list[2]
	var/high_b = high_color_list[3]

	var/new_r = Interpolate(low_r, high_r, weight = lerp_weight)
	var/new_g = Interpolate(low_g, high_g, weight = lerp_weight)
	var/new_b = Interpolate(low_b, high_b, weight = lerp_weight)

	var/new_color = rgb(new_r, new_g, new_b)

	world << "Changing time.  [outdoor_turfs.len] turfs need to be updated.  Expected ETA: [outdoor_turfs.len * 0.0033] seconds."
	world << "Setting outdoor tiles to set_light(2, [new_brightness], [new_color])."
	var/i = 0
	for(var/turf/simulated/floor/T in outdoor_turfs)
		T.set_light(2, new_brightness, new_color)
		i++
		if(i % 30 == 0)
			sleep(1)
	world << "Finished."


/turf/simulated/floor/proc/update_icon_edge()
	if(edge_blending_priority)
	//	world << "edge_blending_priority detected"
		for(var/checkdir in cardinal)
	//		world << "Checking [checkdir] dir."
			var/turf/simulated/T = get_step(src, checkdir)
	//		world << "Found [T] ([T.x], [T.y], [T.z])."
			if(istype(T) && T.edge_blending_priority && edge_blending_priority < T.edge_blending_priority && icon_state != T.icon_state)
	//			world << "edge_blending_priority of [T] was higher than [src]."
				var/cache_key = "[T.get_edge_icon_state()]-[checkdir]"
	//			world << "cache_key is [cache_key]"
				if(!turf_edge_cache[cache_key])
					turf_edge_cache[cache_key] = image(icon = 'icons/turf/outdoors_edge.dmi', icon_state = "[T.get_edge_icon_state()]-edge", dir = checkdir)
	//				world << "Made new entry to cache."
				overlays += turf_edge_cache[cache_key]
	//			world << "Applied overlay."

/turf/simulated/proc/get_edge_icon_state()
	return icon_state

/turf/simulated/floor/outdoors/update_icon()
	overlays.Cut()
	update_icon_edge()
	..()

/turf/simulated/floor/outdoors/mud
	name = "grass"
	icon_state = "mud_dark"
	edge_blending_priority = 2


/turf/simulated/floor/outdoors/rocks
	name = "rocks"
	desc = "Hard as a rock."
	icon_state = "rockwall"
	edge_blending_priority = 1

var/list/grass_types = list(
	/obj/structure/flora/ausbushes/sparsegrass,
	/obj/structure/flora/ausbushes/fullgrass
)

/turf/simulated/floor/outdoors/grass
	name = "grass"
	icon_state = "grass"
	edge_blending_priority = 3
	demote_turf = /turf/simulated/floor/outdoors
	var/grass_chance = 20

/turf/simulated/floor/outdoors/grass/sif
	name = "growth"
	icon_state = "grass_sif"
	edge_blending_priority = 3
	grass_chance = 0


/turf/simulated/floor/outdoors/grass/sif/forest
	name = "thick growth"
	icon_state = "grass_sif_dark"
	edge_blending_priority = 4

/turf/simulated/floor/outdoors/grass/New()
	if(prob(50))
		icon_state += "2"
		//edge_blending_priority++

	if(grass_chance && prob(grass_chance))
		var/grass_type = pick(grass_types)
		new grass_type(src)
	..()

/turf/simulated/floor/outdoors/grass/forest
	name = "thick grass"
	icon_state = "grass-dark"
	grass_chance = 80
	//tree_prob = 20
	edge_blending_priority = 4

/turf/simulated/floor/outdoors/snow
	name = "snow"
	icon_state = "snow"
	edge_blending_priority = 5
	movement_cost = 2
	var/list/crossed_dirs = list()

/turf/simulated/floor/outdoors/snow/Entered(atom/A)
	if(isliving(A))
		var/mdir = "[A.dir]"
		crossed_dirs[mdir] = 1
		update_icon()
	. = ..()

/turf/simulated/floor/outdoors/snow/update_icon()
	overlays.Cut()
	for(var/d in crossed_dirs)
		overlays += image(icon = 'icons/turf/outdoors.dmi', icon_state = "snow_footprints", dir = text2num(d))
