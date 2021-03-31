var/datum/planet/virgo3b_better/planet_virgo3b_better = null

/datum/time/virgo3b_better
	seconds_in_day = 6 HOURS

/datum/planet/virgo3b_better
	name = "Virgo-3BB"
	desc = "A surprising discovery! Aparently there were moons around Virgo-3B! Moreover, one of them seems to be a perfect habitable paradise, with vegetation, greenery, and \
			generally everything one could want out of the planet. So the station was simply plucked off the original spot and put on the moon's moon with minor alterations."
	current_time = new /datum/time/virgo3b_better()
//	expected_z_levels = list(1) // This is defined elsewhere.
	planetary_wall_type = /turf/unsimulated/wall/planetary/virgo3b_better

/datum/planet/virgo3b_better/New()
	..()
	planet_virgo3b_better = src
	weather_holder = new /datum/weather_holder/virgo3b_better(src)

/datum/planet/virgo3b_better/update_sun()
	..()
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	sun_position = distance_from_noon / noon
	sun_position = abs(sun_position - 1)

	var/new_brightness = null

	var/new_color = null

	switch(sun_position)
		if(0 to 0.10) // Night
			new_brightness = 0.8
			new_color = "#DDBB22"

		if(0.10 to 0.15) // Twilight
			new_brightness = 1.5
			new_color = "#EEDD55"

		if(0.15 to 0.20) // Sunrise/set
			new_brightness = 4
			new_color = "#FFFFBB"

		if(0.20 to 1.00) // Noon
			new_brightness = 7
			new_color = "#FFFFFF"

	var/weather_light_modifier = 1
	if(weather_holder && weather_holder.current_weather)
		weather_light_modifier = weather_holder.current_weather.light_modifier

	new_brightness = new_brightness * weather_light_modifier

	if(weather_holder && weather_holder.current_weather && weather_holder.current_weather.light_color)
		new_color = weather_holder.current_weather.light_color

	spawn(1)
		update_sun_deferred(2, new_brightness, new_color)


/datum/weather_holder/virgo3b_better
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/virgo3b_better/clear(),
		WEATHER_OVERCAST	= new /datum/weather/virgo3b_better/overcast(),
		WEATHER_LIGHT_SNOW	= new /datum/weather/virgo3b_better/light_snow(),
		WEATHER_SNOW		= new /datum/weather/virgo3b_better/snow(),
		WEATHER_BLIZZARD	= new /datum/weather/virgo3b_better/blizzard(),
		WEATHER_RAIN		= new /datum/weather/virgo3b_better/rain(),
		WEATHER_STORM		= new /datum/weather/virgo3b_better/storm(),
		WEATHER_HAIL		= new /datum/weather/virgo3b_better/hail(),
		WEATHER_BLOOD_MOON	= new /datum/weather/virgo3b_better/blood_moon(),
		WEATHER_EMBERFALL	= new /datum/weather/virgo3b_better/emberfall(),
		WEATHER_ASH_STORM	= new /datum/weather/virgo3b_better/ash_storm(),
		WEATHER_FALLOUT		= new /datum/weather/virgo3b_better/fallout(),
		WEATHER_PARTY		= new /datum/weather/virgo3b_better/party()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 30,
		WEATHER_OVERCAST	= 5
		)

/datum/weather/virgo3b_better
	name = "virgo3bb base"
	temp_high = 295.15 // -20c
	temp_low = 291.15  // -30c

/datum/weather/virgo3b_better/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 60,
		WEATHER_OVERCAST = 20
		)
	transition_messages = list(
		"The sky clears up.",
		"The sky is visible.",
		"The weather is calm."
		)
	sky_visible = TRUE
	observed_message = "The sky is clear."

/datum/weather/virgo3b_better/overcast
	name = "overcast"
	transition_chances = list(
		WEATHER_CLEAR = 25,
		WEATHER_OVERCAST = 50,
		WEATHER_RAIN = 10
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)

/datum/weather/virgo3b_better/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 235.15
	temp_low = 	225.15
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_OVERCAST = 20,
		WEATHER_LIGHT_SNOW = 50,
		WEATHER_SNOW = 25,
		WEATHER_HAIL = 5
		)
	observed_message = "It is snowing lightly."
	transition_messages = list(
		"Small snowflakes begin to fall from above.",
		"It begins to snow lightly.",
		)

/datum/weather/virgo3b_better/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 230.15
	temp_low = 220.15
	wind_high = 2
	wind_low = 0
	light_modifier = 0.5
	flight_failure_modifier = 5
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 20,
		WEATHER_SNOW = 50,
		WEATHER_BLIZZARD = 20,
		WEATHER_HAIL = 5,
		WEATHER_OVERCAST = 5
		)
	observed_message = "It is snowing."
	transition_messages = list(
		"It's starting to snow.",
		"The air feels much colder as snowflakes fall from above."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_snow
	indoor_sounds_type = /datum/looping_sound/weather/inside_snow

/datum/weather/virgo3b_better/snow/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(33))
						T.chill()

/datum/weather/virgo3b_better/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 215.15
	temp_low = 200.15
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_SNOW = 45,
		WEATHER_BLIZZARD = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)
	observed_message = "A blizzard blows snow everywhere."
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/datum/weather/virgo3b_better/blizzard/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(50))
						T.chill()

/datum/weather/virgo3b_better/rain
	name = "rain"
	icon_state = "rain"
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"

	transition_chances = list(
		WEATHER_OVERCAST = 25,
		WEATHER_CLEAR = 25
		)
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/rain
	indoor_sounds_type = /datum/looping_sound/weather/rain/indoors

/datum/weather/virgo3b_better/rain/process_effects()
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

/datum/weather/virgo3b_better/storm
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
	observed_message = "An intense storm pours down over the region."
	transition_messages = list(
		"You feel intense winds hit you as the weather takes a turn for the worst.",
		"Loud thunder is heard in the distance.",
		"A bright flash heralds the approach of a storm."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/rain
	indoor_sounds_type = /datum/looping_sound/weather/rain/indoors


	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)

/datum/weather/virgo3b_better/storm/process_effects()
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
/datum/weather/virgo3b_better/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)

/datum/weather/virgo3b_better/hail
	name = "hail"
	icon_state = "hail"
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = "<span class='warning'>The hail smacks into you!</span>"

	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)
	observed_message = "Ice is falling from the sky."
	transition_messages = list(
		"Ice begins to fall from the sky.",
		"It begins to hail.",
		"An intense chill is felt, and chunks of ice start to fall from the sky, towards you."
	)

/datum/weather/virgo3b_better/hail/process_effects()
	..()
	for(var/humie in human_mob_list)
		var/mob/living/carbon/human/H = humie
		if(H.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(H)
			if(!T.outdoors)
				continue // They're indoors, so no need to pelt them with ice.

			// If they have an open umbrella, it'll guard from hail
			var/obj/item/weapon/melee/umbrella/U
			if(istype(H.get_active_hand(), /obj/item/weapon/melee/umbrella))
				U = H.get_active_hand()
			else if(istype(H.get_inactive_hand(), /obj/item/weapon/melee/umbrella))
				U = H.get_inactive_hand()
			if(U && U.open)
				if(show_message)
					to_chat(H, "<span class='notice'>Hail patters onto your umbrella.</span>")
				continue

			var/target_zone = pick(BP_ALL)
			var/amount_blocked = H.run_armor_check(target_zone, "melee")
			var/amount_soaked = H.get_armor_soak(target_zone, "melee")

			var/damage = rand(1,3)

			if(amount_blocked >= 30)
				continue // No need to apply damage. Hardhats are 30. They should probably protect you from hail on your head.
				//Voidsuits are likewise 40, and riot, 80. Clothes are all less than 30.

			if(amount_soaked >= damage)
				continue // No need to apply damage.

			H.apply_damage(damage, BRUTE, target_zone, amount_blocked, amount_soaked, used_weapon = "hail")
			if(show_message)
				to_chat(H, effect_message)

/datum/weather/virgo3b_better/blood_moon
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
/datum/weather/virgo3b_better/emberfall
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
/datum/weather/virgo3b_better/ash_storm
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

/datum/weather/virgo3b_better/ash_storm/process_effects()
	..()
	for(var/thing in living_mob_list)
		var/mob/living/L = thing
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to burn them with ash.

			L.inflict_heat_damage(rand(1, 3))


// Totally radical.
/datum/weather/virgo3b_better/fallout
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

/datum/weather/virgo3b_better/fallout/process_effects()
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
/datum/weather/virgo3b_better/fallout/proc/irradiate_nearby_turf(mob/living/L)
	if(!istype(L))
		return
	var/list/turfs = RANGE_TURFS(world.view, L)
	var/turf/T = pick(turfs) // We get one try per tick.
	if(!istype(T))
		return
	if(T.outdoors)
		SSradiation.radiate(T, rand(fallout_rad_low, fallout_rad_high))

/datum/weather/virgo3b_better/party
	name = "party"
	icon = 'icons/effects/weather_vr.dmi'
	icon_state = "party"
	light_color = "#FFFFFF"
	light_modifier = 2
	flight_failure_modifier = 70
	transition_chances = list(
		WEATHER_CLEAR = 100
		)
	transition_messages = list(
		"IT'S PARTY TIME!",
		"LET'S GO! PARTY TIME!",
		"EVERYONE, IT'S TIME TO PARTY!"
		)
	sky_visible = TRUE
	observed_message = "THE PARTY IS ON!"
