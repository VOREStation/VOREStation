var/datum/planet/virgo4/planet_virgo4 = null

/datum/time/virgo4
	seconds_in_day = 24 HOURS

/datum/planet/virgo4
	name = "Virgo-4"
	desc = "Zorren homeworld. Mostly dry and desolate, but ocean and fresh water are present, with scattered vegitation." //rewrite me
	current_time = new /datum/time/virgo4()
//	expected_z_levels = list(1) // This is defined elsewhere.
	planetary_wall_type = /turf/unsimulated/wall/planetary/normal/virgo4

/datum/planet/virgo4/New()
	..()
	planet_virgo4 = src
	weather_holder = new /datum/weather_holder/virgo4(src)

/datum/planet/virgo4/update_sun()
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
		if(0 to 0.20) // Night
			low_brightness = 0.3
			low_color = "#000066"

			high_brightness = 0.5
			high_color = "#66004D"
			min = 0

		if(0.20 to 0.30) // Twilight
			low_brightness = 0.5
			low_color = "#66004D"

			high_brightness = 0.9
			high_color = "#CC3300"
			min = 0.40

		if(0.30 to 0.40) // Sunrise/set
			low_brightness = 0.9
			low_color = "#CC3300"

			high_brightness = 1.0
			high_color = "#FF9933"
			min = 0.50

		if(0.40 to 1.00) // Noon
			low_brightness = 1.0
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
		update_sun_deferred(new_brightness, new_color)


/datum/weather_holder/virgo4
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR			= new /datum/weather/virgo4/clear(),
		WEATHER_OVERCAST		= new /datum/weather/virgo4/overcast(),
		WEATHER_LIGHT_SNOW		= new /datum/weather/virgo4/light_snow(),
		WEATHER_SNOW			= new /datum/weather/virgo4/snow(),
		WEATHER_BLIZZARD		= new /datum/weather/virgo4/blizzard(),
		WEATHER_RAIN			= new /datum/weather/virgo4/rain(),
		WEATHER_STORM			= new /datum/weather/virgo4/storm(),
		WEATHER_HAIL			= new /datum/weather/virgo4/hail(),
		WEATHER_FOG				= new /datum/weather/virgo4/fog(),
		WEATHER_BLOOD_MOON		= new /datum/weather/virgo4/blood_moon(),
		WEATHER_EMBERFALL		= new /datum/weather/virgo4/emberfall(),
		WEATHER_ASH_STORM		= new /datum/weather/virgo4/ash_storm(),
		WEATHER_ASH_STORM_SAFE	= new /datum/weather/virgo4/ash_storm_safe(),
		WEATHER_FALLOUT			= new /datum/weather/virgo4/fallout(),
		WEATHER_FALLOUT_TEMP	= new /datum/weather/virgo4/fallout/temp(),
		WEATHER_CONFETTI		= new /datum/weather/virgo4/confetti()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 50,
		WEATHER_OVERCAST	= 10,
		WEATHER_RAIN		= 1
		)

/datum/weather/virgo4
	name = "virgo4"
	temp_high = 303.15 // 30c
	temp_low = 298.15  // 25c

/datum/weather/virgo4/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 60,
		WEATHER_OVERCAST = 20)
	transition_messages = list(
		"The sky clears up.",
		"The sky is visible.",
		"The weather is calm."
		)
	sky_visible = TRUE
	observed_message = "The sky is clear."
	imminent_transition_message = "The sky is rapidly clearing up."

/datum/weather/virgo4/overcast
	name = "overcast"
	temp_high = 293.15 // 20c
	temp_low = 	288.15 // 15c
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 25,
		WEATHER_OVERCAST = 50,
		WEATHER_RAIN = 5
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)
	imminent_transition_message = "Benign clouds are quickly gathering."

/datum/weather/virgo4/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 268.15 // -5c
	temp_low = 	263.15 // -10c
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 15,
		WEATHER_OVERCAST = 80
		)
	observed_message = "It is snowing lightly."
	transition_messages = list(
		"Small snowflakes begin to fall from above.",
		"It begins to snow lightly.",
		)
	imminent_transition_message = "It appears a light snow is about to start."

/datum/weather/virgo4/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 268.15 // -5c
	temp_low = 	263.15 // -10c
	wind_high = 2
	wind_low = 0
	light_modifier = 0.5
	flight_failure_modifier = 5
	transition_chances = list(
		WEATHER_SNOW = 10,
		WEATHER_LIGHT_SNOW = 80
		)
	observed_message = "It is snowing."
	transition_messages = list(
		"It's starting to snow.",
		"The air feels much colder as snowflakes fall from above."
	)
	imminent_transition_message = "A snowfall is starting."
	outdoor_sounds_type = /datum/looping_sound/weather/outside_snow
	indoor_sounds_type = /datum/looping_sound/weather/inside_snow

/*
/datum/weather/virgo4/snow/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S as anything in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(33))
						T.chill()
*/

/datum/weather/virgo4/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 268.15 // -5c
	temp_low = 	263.15 // -10c
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_BLIZZARD = 5,
		WEATHER_SNOW = 80
		)
	observed_message = "A blizzard blows snow everywhere."
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)
	imminent_transition_message = "Wind is howling. Blizzard is coming."
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/*
/datum/weather/virgo4/blizzard/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S as anything in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(50))
						T.chill()
*/

/datum/weather/virgo4/rain
	name = "rain"
	icon_state = "rain"
	temp_high = 288.15 // 15c
	temp_low = 	283.15 // 10c
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = span_warning("Rain falls on you.")

	transition_chances = list(
		WEATHER_OVERCAST = 25,
		WEATHER_RAIN = 50
		)
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)
	imminent_transition_message = "Light drips of water are starting to fall from the sky."
	outdoor_sounds_type = /datum/looping_sound/weather/rain
	indoor_sounds_type = /datum/looping_sound/weather/rain/indoors
	effect_flags  = HAS_PLANET_EFFECT | EFFECT_ONLY_LIVING

/datum/weather/virgo4/rain/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors, so no need to rain on them.

		// If they have an open umbrella, it'll guard from rain
		var/obj/item/melee/umbrella/U = L.get_active_hand()
		if(!istype(U) || !U.open)
			U = L.get_inactive_hand()

		if(istype(U) && U.open)
			if(show_message)
				to_chat(L, span_notice("Rain patters softly onto your umbrella."))
			return

		L.water_act(1)
		if(show_message)
			to_chat(L, effect_message)

/datum/weather/virgo4/storm
	name = "storm"
	icon_state = "storm"
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	effect_message = span_warning("Rain falls on you, drenching you in water.")

	var/next_lightning_strike = 0 // world.time when lightning will strike.
	var/min_lightning_cooldown = 5 SECONDS
	var/max_lightning_cooldown = 1 MINUTE
	observed_message = "An intense storm pours down over the region."
	transition_messages = list(
		"You feel intense winds hit you as the weather takes a turn for the worst.",
		"Loud thunder is heard in the distance.",
		"A bright flash heralds the approach of a storm."
	)
	imminent_transition_message = "You can hear distant thunder. Storm is coming."
	outdoor_sounds_type = /datum/looping_sound/weather/rain
	indoor_sounds_type = /datum/looping_sound/weather/rain/indoors


	transition_chances = list(
		WEATHER_STORM = 10,
		WEATHER_RAIN = 80
		)
	effect_flags = HAS_PLANET_EFFECT | EFFECT_ONLY_LIVING

/datum/weather/virgo4/storm/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors, so no need to rain on them.

		// If they have an open umbrella, it'll guard from rain
		var/obj/item/melee/umbrella/U = L.get_active_hand()
		if(!istype(U) || !U.open)
			U = L.get_inactive_hand()

		if(istype(U) && U.open)
			if(show_message)
				to_chat(L, span_notice("Rain showers loudly onto your umbrella!"))
			return


		L.water_act(2)
		if(show_message)
			to_chat(L, effect_message)

/datum/weather/virgo4/storm/process_effects()
	..()
	handle_lightning()

// This gets called to do lightning periodically.
// There is a seperate function to do the actual lightning strike, so that badmins can play with it.
/datum/weather/virgo4/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)

/datum/weather/virgo4/hail
	name = "hail"
	icon_state = "hail"
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = span_warning("The hail smacks into you!")

	transition_chances = list(
		WEATHER_HAIL = 10,
		WEATHER_SNOW = 40,
		WEATHER_RAIN = 40
		)
	observed_message = "Ice is falling from the sky."
	transition_messages = list(
		"Ice begins to fall from the sky.",
		"It begins to hail.",
		"An intense chill is felt, and chunks of ice start to fall from the sky, towards you."
	)
	imminent_transition_message = "Small bits of ice are falling from the sky, growing larger by the second. Hail is starting, get to cover!"
	effect_flags = HAS_PLANET_EFFECT | EFFECT_ONLY_HUMANS

/datum/weather/virgo4/hail/planet_effect(mob/living/carbon/H)
	if(H.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(H)
		if(!T.is_outdoors())
			return // They're indoors, so no need to pelt them with ice.

		// If they have an open umbrella, it'll guard from hail
		var/obj/item/melee/umbrella/U = H.get_active_hand()
		if(!istype(U) || !U.open)
			U = H.get_inactive_hand()

		if(istype(U) && U.open)
			if(show_message)
				to_chat(H, span_notice("Hail patters onto your umbrella."))
			return

		var/target_zone = pick(BP_ALL)
		var/amount_blocked = H.run_armor_check(target_zone, "melee")
		var/amount_soaked = H.get_armor_soak(target_zone, "melee")

		var/damage = rand(1,3)

		if(amount_blocked >= 30)
			return // No need to apply damage. Hardhats are 30. They should probably protect you from hail on your head.
			//Voidsuits are likewise 40, and riot, 80. Clothes are all less than 30.

		if(amount_soaked >= damage)
			return // No need to apply damage.

		H.apply_damage(damage, BRUTE, target_zone, amount_blocked, amount_soaked)
		if(show_message)
			to_chat(H, effect_message)

/datum/weather/virgo4/fog
	name = "fog"
	icon_state = "fog"
	wind_high = 1
	wind_low = 0
	light_modifier = 0.7

	temp_high = 283.15 // 10c
	temp_low = 	273.15 // 0c

	transition_chances = list(
		WEATHER_FOG = 10,
		WEATHER_OVERCAST = 15
		)
	observed_message = "A fogbank has rolled over the region."
	transition_messages = list(
		"Fog rolls in.",
		"Visibility falls as the air becomes dense.",
		"The clouds drift lower, as if to smother the forests."
	)
	imminent_transition_message = "Clouds are drifting down as the area is getting foggy."
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

/datum/weather/virgo4/blood_moon
	name = "blood moon"
	light_modifier = 0.5
	light_color = "#FF0000"
	temp_high = 293.15	// 20c
	temp_low = 283.15	// 10c
	flight_failure_modifier = 25
	transition_chances = list(
		WEATHER_BLOOD_MOON = 100
		)
	observed_message = "Everything is red. Something really ominous is going on."
	transition_messages = list(
		"The sky turns blood red!"
	)
	imminent_transition_message = "The sky is turning red. Blood Moon is starting."
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Ash and embers fall forever, such as from a volcano or something.
/datum/weather/virgo4/emberfall
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
	imminent_transition_message = "Dark smoke is filling the sky, as ash and embers start to rain down."
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Like the above but a lot more harmful.
/datum/weather/virgo4/ash_storm
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
	imminent_transition_message = "Dark smoke is filling the sky, as ash and embers fill the air and wind is picking up too. Ashstorm is coming, get to cover!"
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard
	effect_flags = HAS_PLANET_EFFECT | EFFECT_ONLY_LIVING

/datum/weather/virgo4/ash_storm/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors, so no need to burn them with ash.

		L.inflict_heat_damage(rand(1, 3))

//A non-lethal variant of the ash_storm. Stays on indefinitely.
/datum/weather/virgo4/ash_storm_safe
	name = "light ash storm"
	icon_state = "ashfall_moderate"
	light_modifier = 0.1
	light_color = "#FF0000"
	temp_high = 323.15	// 50c
	temp_low = 313.15	// 40c
	wind_high = 6
	wind_low = 3
	flight_failure_modifier = 50
	transition_chances = list(
		WEATHER_ASH_STORM_SAFE = 100
		)
	observed_message = "All that can be seen is black smoldering ash."
	transition_messages = list(
		"Smoldering clouds of scorching ash billow down around you!"
	)
	imminent_transition_message = "Dark smoke is filling the sky, as ash and embers fill the air and wind is picking up too."
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard


// Totally radical.
/datum/weather/virgo4/fallout
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
	imminent_transition_message = "Sky and clouds are growing sickly green... Radiation storm is approaching, get to cover!"
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

	// How much radiation a mob gets while on an outside tile.
	var/direct_rad_low = RAD_LEVEL_LOW
	var/direct_rad_high = RAD_LEVEL_MODERATE

	// How much radiation is bursted onto a random tile near a mob.
	var/fallout_rad_low = RAD_LEVEL_HIGH
	var/fallout_rad_high = RAD_LEVEL_VERY_HIGH
	effect_flags = HAS_PLANET_EFFECT | EFFECT_ONLY_LIVING

/datum/weather/virgo4/fallout/planet_effect(mob/living/L)
	if(L.z in holder.our_planet.expected_z_levels)
		irradiate_nearby_turf(L)
		var/turf/T = get_turf(L)
		if(!T.is_outdoors())
			return // They're indoors, so no need to irradiate them with fallout.

		L.rad_act(rand(direct_rad_low, direct_rad_high))

// This makes random tiles near people radioactive for awhile.
// Tiles far away from people are left alone, for performance.
/datum/weather/virgo4/fallout/proc/irradiate_nearby_turf(mob/living/L)
	if(!istype(L))
		return
	var/list/turfs = RANGE_TURFS(world.view, L)
	var/turf/T = pick(turfs) // We get one try per tick.
	if(!istype(T))
		return
	if(T.is_outdoors())
		SSradiation.radiate(T, rand(fallout_rad_low, fallout_rad_high))

/datum/weather/virgo4/fallout/temp
	name = "short-term fallout"
	timer_low_bound = 1
	timer_high_bound = 3
	transition_chances = list(
		WEATHER_FALLOUT = 10,
		WEATHER_RAIN = 50,
		WEATHER_FOG = 35,
		WEATHER_STORM = 20,
		WEATHER_OVERCAST = 5
		)

/datum/weather/virgo4/confetti
	name = "confetti"
	icon_state = "confetti"

	transition_chances = list(
		WEATHER_CLEAR = 50,
		WEATHER_OVERCAST = 20,
		WEATHER_CONFETTI = 5
		)
	observed_message = "Confetti is raining from the sky."
	transition_messages = list(
		"Suddenly, colorful confetti starts raining from the sky."
	)
	imminent_transition_message = "A rain is starting... A rain of confetti...?"

/turf/unsimulated/wall/planetary/normal/virgo4
	name = "deep ocean"
	alpha = 0

/obj/machinery/power/smes/buildable/offmap_spawn/empty/Initialize(mapload)
	. = ..()
	charge = 0
	RCon = TRUE
	input_level = input_level_max
	output_level = output_level_max
	input_attempt = TRUE
