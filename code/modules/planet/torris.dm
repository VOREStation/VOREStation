var/datum/planet/torris/planet_torris = null

/datum/time/torris
	seconds_in_day = 3 HOURS

/datum/planet/torris
	name = "Torris"
	desc = "A large, hostile planet of mostly sprawling jungles, this planet has an atmosphere mainly comprised of human-breathable air. \
	The sprawling jungles house a variety of lifeforms that Nanotrasen encourages employees to remain well clear of. \
	The air is thick and muggy here, and storms frequently roll through thanks to the atmospheric composition."
	current_time = new /datum/time/torris()
//	expected_z_levels = list(1) // This is defined elsewhere.
	planetary_wall_type = /turf/unsimulated/wall/planetary/torris

/datum/planet/torris/New()
	..()
	planet_torris = src
	weather_holder = new /datum/weather_holder/torris(src)

/datum/planet/torris/update_sun()
	..()
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	sun_position = distance_from_noon / noon
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
			min = 0

		if(0.40 to 0.50) // Twilight
			low_brightness = 0.6
			low_color = "#66004D"

			high_brightness = 0.8
			high_color = "#CC3300"
			min = 0.40

		if(0.50 to 0.70) // Sunrise/set
			low_brightness = 0.8
			low_color = "#CC3300"

			high_brightness = 0.9
			high_color = "#FF9933"
			min = 0.50

		if(0.70 to 1.00) // Noon
			low_brightness = 0.9
			low_color = "#DDDDDD"

			high_brightness = 1.0
			high_color = "#FFFFFF"
			min = 0.70

	var/interpolate_weight = (abs(min - sun_position)) * 4
	var/weather_light_modifier = 1
	if(weather_holder && weather_holder.current_weather)
		weather_light_modifier = weather_holder.current_weather.light_modifier

	var/new_brightness = (LERP(low_brightness, high_brightness, interpolate_weight) ) * weather_light_modifier

	var/new_color = null
	if(weather_holder && weather_holder.current_weather && weather_holder.current_weather.light_color)
		new_color = weather_holder.current_weather.light_color
	else
		var/list/low_color_list = hex2rgb(low_color)
		var/low_r = low_color_list[1]
		var/low_g = low_color_list[2]
		var/low_b = low_color_list[3]

		var/list/high_color_list = hex2rgb(high_color)
		var/high_r = high_color_list[1]
		var/high_g = high_color_list[2]
		var/high_b = high_color_list[3]

		var/new_r = LERP(low_r, high_r, interpolate_weight)
		var/new_g = LERP(low_g, high_g, interpolate_weight)
		var/new_b = LERP(low_b, high_b, interpolate_weight)

		new_color = rgb(new_r, new_g, new_b)

	spawn(1)
		update_sun_deferred(2, new_brightness, new_color)


/datum/weather_holder/torris
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/torris/clear(),
		WEATHER_OVERCAST	= new /datum/weather/torris/overcast(),
		WEATHER_RAIN		= new /datum/weather/torris/rain(),
		WEATHER_STORM		= new /datum/weather/torris/storm(),
		WEATHER_BLOOD_MOON	= new /datum/weather/torris/blood_moon(),
		WEATHER_EMBERFALL	= new /datum/weather/torris/emberfall(),
		WEATHER_ASH_STORM	= new /datum/weather/torris/ash_storm(),
		WEATHER_FALLOUT		= new /datum/weather/torris/fallout()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 30,
		WEATHER_OVERCAST	= 30,
		WEATHER_RAIN		= 20,
		WEATHER_STORM		= 20
		)

/datum/weather/torris
	name = "torris base"
	temp_high = 309.15 // 36c
	temp_low = 303.15  // 30c

/datum/weather/torris/clear // Despite the name, 'clear' is not actually clear. It just means we're not in a weather effect at the moment.
	name = "clear"
	
	// Rain-heavy planet.
	transition_chances = list(
		WEATHER_CLEAR = 40,
		WEATHER_OVERCAST = 60
		)
	transition_messages = list(
		"The sky clears up somewhat.",
		"The sky is more visible than before.",
		"The weather is muggy and hot, but not active."
		)
	sky_visible = TRUE
	observed_message = "The sky is speckled with a few clouds as the sun beams downs on the ground, making the air very warm."

/datum/weather/torris/overcast
	name = "overcast"
	light_modifier = 0.8
	
	// Rain-heavy planet.
	transition_chances = list(
		WEATHER_CLEAR = 25,
		WEATHER_OVERCAST = 50,
		WEATHER_RAIN = 25
		)
	observed_message = "It is overcast, all you can see are clouds past the trees."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)

/datum/weather/torris/rain
	name = "rain"
	icon_state = "rain"
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"

	// Again, very rain-heavy planet.
	transition_chances = list(
		WEATHER_OVERCAST = 10,
		WEATHER_RAIN = 50,
		WEATHER_STORM = 50,
		)
	observed_message = "It is raining, water dripping off the trees."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)

/datum/weather/torris/rain/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			if(istype(L.get_active_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_active_hand()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella.</span>")
					continue
			else if(istype(L.get_inactive_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_inactive_hand()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella.</span>")
					continue

			L.water_act(1)
			if(show_message)
				to_chat(L, effect_message)

/datum/weather/torris/storm
	name = "storm"
	icon_state = "storm"
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	effect_message = "<span class='warning'>Rain falls on you, drenching you in water.</span>"

	var/next_lightning_strike = 0 // world.time when lightning will strike.
	var/min_lightning_cooldown = 5 SECONDS
	var/max_lightning_cooldown = 1 MINUTE
	observed_message = "An intense storm pours down over the region, lashing the trees in the wind."
	transition_messages = list(
		"You feel intense winds hit you as the weather takes a turn for the worst.",
		"Loud thunder is heard in the distance.",
		"A bright flash heralds the approach of a storm."
	)

	// Storms will have a higher chance of continuing. This is a very rain-heavy planet.
	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 50,
		WEATHER_OVERCAST = 5
		)

/datum/weather/torris/storm/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			if(istype(L.get_active_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_active_hand()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain showers loudly onto your umbrella!</span>")
					continue
			else if(istype(L.get_inactive_hand(), /obj/item/weapon/melee/umbrella))
				var/obj/item/weapon/melee/umbrella/U = L.get_inactive_hand()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain showers loudly onto your umbrella!</span>")
					continue


			L.water_act(2)
			if(show_message)
				to_chat(L, effect_message)

	handle_lightning()

// This gets called to do lightning periodically.
// There is a seperate function to do the actual lightning strike, so that badmins can play with it.
/datum/weather/torris/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)

/datum/weather/torris/blood_moon
	name = "blood moon"
	light_modifier = 0.5
	light_color = "#FF0000"
	flight_failure_modifier = 25
	transition_chances = list(
		WEATHER_BLOODMOON = 100
		)
	observed_message = "Everything is red. Something really ominous is going on."
	transition_messages = list(
		"The sky turns blood red!"
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Ash and embers fall forever, such as from a volcano or something.
/datum/weather/torris/emberfall
	name = "emberfall"
	icon_state = "ashfall_light"
	light_modifier = 0.7
	light_color = "#880000"
	temp_high = 293.15	// 20c
	temp_low = 283.15	// 10c
	flight_failure_modifier = 20
	transition_chances = list(
		WEATHER_EMBERFALL = 100
		)
	observed_message = "Soot, ash, and embers float down from above."
	transition_messages = list(
		"Gentle embers waft down around you like grotesque snow."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Like the above but a lot more harmful.
/datum/weather/torris/ash_storm
	name = "ash storm"
	icon_state = "ashfall_heavy"
	light_modifier = 0.1
	light_color = "#FF0000"
	temp_high = 323.15	// 50c
	temp_low = 313.15	// 40c
	wind_high = 6
	wind_low = 3
	flight_failure_modifier = 50
	transition_chances = list(
		WEATHER_ASH_STORM = 100
		)
	observed_message = "All that can be seen is black smoldering ash."
	transition_messages = list(
		"Smoldering clouds of scorching ash billow down around you!"
	)
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/datum/weather/torris/ash_storm/process_effects()
	..()
	for(var/thing in living_mob_list)
		var/mob/living/L = thing
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to burn them with ash.

			L.inflict_heat_damage(rand(1, 3))


// Totally radical.
/datum/weather/torris/fallout
	name = "fallout"
	icon_state = "fallout"
	light_modifier = 0.7
	light_color = "#CCFFCC"
	flight_failure_modifier = 30
	transition_chances = list(
		WEATHER_FALLOUT = 100
		)
	observed_message = "Radioactive soot and ash rains down from the heavens."
	transition_messages = list(
		"Radioactive soot and ash start to float down around you, contaminating whatever they touch."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

	// How much radiation a mob gets while on an outside tile.
	var/direct_rad_low = RAD_LEVEL_LOW
	var/direct_rad_high = RAD_LEVEL_MODERATE

	// How much radiation is bursted onto a random tile near a mob.
	var/fallout_rad_low = RAD_LEVEL_HIGH
	var/fallout_rad_high = RAD_LEVEL_VERY_HIGH

/datum/weather/torris/fallout/process_effects()
	..()
	for(var/thing in living_mob_list)
		var/mob/living/L = thing
		if(L.z in holder.our_planet.expected_z_levels)
			irradiate_nearby_turf(L)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to irradiate them with fallout.

			L.rad_act(rand(direct_rad_low, direct_rad_high))

// This makes random tiles near people radioactive for awhile.
// Tiles far away from people are left alone, for performance.
/datum/weather/torris/fallout/proc/irradiate_nearby_turf(mob/living/L)
	if(!istype(L))
		return
	var/list/turfs = RANGE_TURFS(world.view, L)
	var/turf/T = pick(turfs) // We get one try per tick.
	if(!istype(T))
		return
	if(T.outdoors)
		SSradiation.radiate(T, rand(fallout_rad_low, fallout_rad_high))

