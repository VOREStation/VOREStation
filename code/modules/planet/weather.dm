/datum/weather_holder
	var/datum/planet/our_planet = null
	var/datum/weather/current_weather = null
	var/temperature = T20C
	var/wind_dir = 0
	var/wind_speed = 0
	var/list/allowed_weather_types = list()
	var/list/roundstart_weather_chances = list()
	var/next_weather_shift = null

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
	//message_admins("[our_planet.name]'s weather is now [new_weather], with a temperature of [temperature]&deg;K ([temperature - T0C]&deg;C | [temperature * 1.8 - 459.67]&deg;F).") //VOREStation Removal - I like weather, I just don't like hearing about it.

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
	our_planet.needs_work |= PLANET_PROCESS_WEATHER

/datum/weather_holder/proc/update_temperature()
	temperature = Interpolate(current_weather.temp_low, current_weather.temp_high, weight = our_planet.sun_position)
	our_planet.needs_work |= PLANET_PROCESS_TEMP

/datum/weather_holder/proc/get_weather_datum(desired_type)
	return allowed_weather_types[desired_type]


/datum/weather
	var/name = "weather base"
	var/icon = 'icons/effects/weather.dmi'
	var/icon_state = null // Icon to apply to turf undergoing weather.
	var/temp_high = T20C
	var/temp_low = T0C
	var/light_modifier = 1.0 // Lower numbers means more darkness.
	var/light_color = null // If set, changes how the day/night light looks.
	var/flight_falure_modifier = 0 // Some types of weather make flying harder, and therefore make crashes more likely.
	var/transition_chances = list() // Assoc list
	var/datum/weather_holder/holder = null

/datum/weather/proc/process_effects()
	return
