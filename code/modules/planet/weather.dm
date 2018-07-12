/datum/weather_holder
	var/datum/planet/our_planet = null
	var/datum/weather/current_weather = null
	var/temperature = T20C
	var/wind_dir = 0
	var/wind_speed = 0
	var/list/allowed_weather_types = list()
	var/list/roundstart_weather_chances = list()
	var/next_weather_shift = null

	// Holds the weather icon, using vis_contents. Documentation says an /atom/movable is required for placing inside another atom's vis_contents.
	var/atom/movable/weather_visuals/visuals = null

/datum/weather_holder/New(var/source)
	..()
	our_planet = source
	for(var/A in allowed_weather_types)
		var/datum/weather/W = allowed_weather_types[A]
		if(istype(W))
			W.holder = src
	visuals = new()

/datum/weather_holder/proc/change_weather(var/new_weather)
	var/old_light_modifier = null
	if(current_weather)
		old_light_modifier = current_weather.light_modifier // We store the old one, so we can determine if recalculating the sun is needed.
	current_weather = allowed_weather_types[new_weather]
	next_weather_shift = world.time + rand(current_weather.timer_low_bound, current_weather.timer_high_bound) MINUTES

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
	visuals.icon_state = current_weather.icon_state

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
	var/flight_failure_modifier = 0 // Some types of weather make flying harder, and therefore make crashes more likely.
	var/transition_chances = list() // Assoc list
	var/datum/weather_holder/holder = null
	var/timer_low_bound = 5			// How long this weather must run before it tries to change, in minutes
	var/timer_high_bound = 10		// How long this weather can run before it tries to change, in minutes

	var/effect_message = null		// Should be a string, this is what is shown to a mob caught in the weather
	var/last_message = 0			// Keeps track of when the weather last tells EVERY player it's hitting them
	var/message_delay = 10 SECONDS	// Delay in between weather hit messages
	var/show_message = FALSE		// Is set to TRUE and plays the messsage every [message_delay]

/datum/weather/proc/process_effects()
	show_message = FALSE	// Need to reset the show_message var, just in case
	if(effect_message)	// Only bother with the code below if we actually need to display something
		if(world.time >= last_message + message_delay)
			last_message = world.time	// Reset the timer
			show_message = TRUE			// Tell the rest of the process that we need to make a message
	return

// All this does is hold the weather icon.
/atom/movable/weather_visuals
	icon = 'icons/effects/weather.dmi'
	mouse_opacity = 0
	plane = PLANE_PLANETLIGHTING
