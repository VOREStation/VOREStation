#define WEATHER_CLEAR				"clear"
#define WEATHER_OVERCAST			"overcast"
#define WEATHER_LIGHT_SNOW			"light snow"
#define WEATHER_SNOW				"snow"
#define WEATHER_BLIZZARD			"blizzard"
#define WEATHER_RAIN				"rain"
#define WEATHER_STORM				"storm"
#define WEATHER_HAIL				"hail"
#define WEATHER_WINDY				"windy"
#define WEATHER_HOT					"hot"

/datum/weather_holder
	var/datum/planet/our_planet = null
	var/datum/weather/current_weather = null
	var/temperature = T20C
	var/wind_dir = 0
	var/wind_speed = 0
	var/list/allowed_weather_types = list()
	var/list/roundstart_weather_chances = list()
	var/next_weather_shift = null
	var/planetary_wall_type = null // Which walls to look for when updating temperature.

/datum/weather_holder/New(var/source)
	..()
	our_planet = source
	for(var/A in allowed_weather_types)
		var/datum/weather/W = allowed_weather_types[A]
		if(istype(W))
			W.holder = src

/datum/weather_holder/proc/change_weather(var/new_weather)
	var/old_light_modifier = null
	if(current_weather)
		old_light_modifier = current_weather.light_modifier // We store the old one, so we can determine if recalculating the sun is needed.
	current_weather = allowed_weather_types[new_weather]
	next_weather_shift = world.time + rand(20, 30) MINUTES

	update_icon_effects()
	update_temperature()
	if(old_light_modifier && current_weather.light_modifier != old_light_modifier) // Updating the sun should be done sparingly.
		our_planet.update_sun()
	message_admins("[our_planet.name]'s weather is now [new_weather], with a temperature of [temperature]&deg;K ([temperature - T0C]&deg;C | [temperature * 1.8 - 459.67]&deg;F).")

/datum/weather_holder/proc/process()
	if(world.time >= next_weather_shift)
		var/new_weather
		if(!current_weather)
			new_weather = pickweight(roundstart_weather_chances)
		else
			new_weather = pickweight(current_weather.transition_chances)
		change_weather(new_weather)
	else
		current_weather.process_effects()

/datum/weather_holder/proc/update_icon_effects()
	if(current_weather)
		for(var/turf/simulated/floor/T in outdoor_turfs)
			if(T.z in our_planet.expected_z_levels)
				T.overlays -= T.weather_overlay
				T.weather_overlay = image(icon = current_weather.icon, icon_state = current_weather.icon_state, layer = LIGHTING_LAYER - 1)
				T.overlays += T.weather_overlay

/datum/weather_holder/proc/update_temperature()
	temperature = Interpolate(current_weather.temp_low, current_weather.temp_high, weight = our_planet.sun_position)

	for(var/turf/unsimulated/wall/planetary/wall in planetary_walls)
		if(ispath(wall.type, planetary_wall_type))
			wall.temperature = temperature
			for(var/dir in cardinal)
				var/turf/simulated/T = get_step(wall, dir)
				if(istype(T))
					if(T.zone)
						T.zone.rebuild()


/datum/weather_holder/proc/get_weather_datum(desired_type)
	return allowed_weather_types[desired_type]

/datum/weather_holder/sif
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/sif/clear(),
		WEATHER_OVERCAST	= new /datum/weather/sif/overcast(),
		WEATHER_LIGHT_SNOW	= new /datum/weather/sif/light_snow(),
		WEATHER_SNOW		= new /datum/weather/sif/snow(),
		WEATHER_BLIZZARD	= new /datum/weather/sif/blizzard(),
		WEATHER_RAIN		= new /datum/weather/sif/rain(),
		WEATHER_STORM		= new /datum/weather/sif/storm(),
		WEATHER_HAIL		= new /datum/weather/sif/hail()
		)
	planetary_wall_type = /turf/unsimulated/wall/planetary/sif
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 30,
		WEATHER_OVERCAST	= 30,
		WEATHER_LIGHT_SNOW	= 20,
		WEATHER_SNOW		= 5,
		WEATHER_BLIZZARD	= 5,
		WEATHER_RAIN		= 5,
		WEATHER_STORM		= 2.5,
		WEATHER_HAIL		= 2.5
		)

/datum/weather
	var/name = "weather base"
	var/icon = 'icons/effects/weather.dmi'
	var/icon_state = null // Icon to apply to turf undergoing weather.
	var/temp_high = T20C
	var/temp_low = T0C
	var/light_modifier = 1.0 // Lower numbers means more darkness.
	var/transition_chances = list() // Assoc list
	var/datum/weather_holder/holder = null

/datum/weather/proc/process_effects()
	return

/datum/weather/sif
	name = "sif base"
	temp_high = 243.15 // -20c
	temp_low = 233.15  // -30c

/datum/weather/sif/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 60,
		WEATHER_OVERCAST = 40
		)

/datum/weather/sif/overcast
	name = "overcast"
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 25,
		WEATHER_OVERCAST = 50,
		WEATHER_LIGHT_SNOW = 10,
		WEATHER_SNOW = 5,
		WEATHER_RAIN = 5,
		WEATHER_HAIL = 5
		)

/datum/weather/sif/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 238.15 // -25c
	temp_low = 228.15  // -35c
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_OVERCAST = 20,
		WEATHER_LIGHT_SNOW = 50,
		WEATHER_SNOW = 25,
		WEATHER_HAIL = 5
		)

/datum/weather/sif/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 233.15 // -30c
	temp_low = 223.15  // -40c
	light_modifier = 0.5
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 20,
		WEATHER_SNOW = 50,
		WEATHER_BLIZZARD = 20,
		WEATHER_HAIL = 5,
		WEATHER_OVERCAST = 5
		)

/datum/weather/sif/snow/process_effects()
	for(var/turf/simulated/floor/outdoors/snow/S in outdoor_turfs)
		for(var/dir_checked in cardinal)
			var/turf/simulated/floor/T = get_step(S, dir_checked)
			if(istype(T))
				if(istype(T, /turf/simulated/floor/outdoors) && prob(33))
					T.chill()

/datum/weather/sif/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 223.15 // -40c
	temp_low = 203.15  // -60c
	light_modifier = 0.3
	transition_chances = list(
		WEATHER_SNOW = 45,
		WEATHER_BLIZZARD = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)

/datum/weather/sif/blizzard/process_effects()
	for(var/turf/simulated/floor/outdoors/snow/S in outdoor_turfs)
		for(var/dir_checked in cardinal)
			var/turf/simulated/floor/T = get_step(S, dir_checked)
			if(istype(T))
				if(istype(T, /turf/simulated/floor/outdoors) && prob(50))
					T.chill()

/datum/weather/sif/rain
	name = "rain"
	icon_state = "rain"
	light_modifier = 0.5
	transition_chances = list(
		WEATHER_OVERCAST = 25,
		WEATHER_LIGHT_SNOW = 10,
		WEATHER_RAIN = 50,
		WEATHER_STORM = 10,
		WEATHER_HAIL = 5
		)

/datum/weather/sif/rain/process_effects()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				return // They're indoors, so no need to rain on them.

			L.adjust_fire_stacks(-5)
			to_chat(L, "<span class='warning'>Rain falls on you.</span>")

/datum/weather/sif/storm
	name = "storm"
	icon_state = "storm"
	temp_high = 233.15 // -30c
	temp_low = 213.15  // -50c
	light_modifier = 0.3
	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)

/datum/weather/sif/rain/process_effects()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				return // They're indoors, so no need to rain on them.

			L.adjust_fire_stacks(-10)
			to_chat(L, "<span class='warning'>Rain falls on you, drenching you in water.</span>")

/datum/weather/sif/hail
	name = "hail"
	icon_state = "hail"
	temp_high = 233.15 // -30c
	temp_low = 213.15  // -50c
	light_modifier = 0.3
	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 10,
		WEATHER_HAIL = 40,
		WEATHER_OVERCAST = 5
		)

/datum/weather/sif/hail/process_effects()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				return // They're indoors, so no need to pelt them with ice.

			var/target_zone = pick(BP_ALL)
			var/amount_blocked = L.run_armor_check(target_zone, "melee")

			if(amount_blocked >= 100)
				return // No need to apply damage.

			L.apply_damage(rand(5, 10), BRUTE, target_zone, amount_blocked, used_weapon = "hail")
			to_chat(L, "<span class='warning'>The hail raining down on you [L.can_feel_pain() ? "hurts" : "damages you"]!</span>")
