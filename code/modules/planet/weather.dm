/datum/weather_holder
	var/datum/planet/our_planet = null // Reference to the planet datum that holds this datum.
	var/datum/weather/current_weather = null // The current weather that is affecting the planet.
	var/temperature = T20C // The temperature to set planetary walls to.
	var/wind_dir = 0 // Not implemented.
	var/wind_speed = 0 // Not implemented.
	var/list/allowed_weather_types = list() // Assoc list of weather identifiers, containing the actual weather datum.
	var/list/roundstart_weather_chances = list() // Assoc list of weather identifiers and their odds of being picked to happen at roundstart.
	var/next_weather_shift = null // world.time when the weather subsystem will advance the forecast.
	var/list/forecast = list() // A list of what the weather will be in the future. This allows it to be pre-determined and planned around.

	// Holds the weather icon, using vis_contents. Documentation says an /atom/movable is required for placing inside another atom's vis_contents.
	var/atom/movable/weather_visuals/visuals = null
	var/atom/movable/weather_visuals/special/special_visuals = null

/datum/weather_holder/New(var/source)
	..()
	our_planet = source
	for(var/A in allowed_weather_types)
		var/datum/weather/W = allowed_weather_types[A]
		if(istype(W))
			W.holder = src
	visuals = new()
	special_visuals = new()

/datum/weather_holder/proc/change_weather(var/new_weather)
	var/old_light_modifier = null
	var/old_weather = null
	if(current_weather)
		old_light_modifier = current_weather.light_modifier // We store the old one, so we can determine if recalculating the sun is needed.
		old_weather = current_weather
	current_weather = allowed_weather_types[new_weather]
	next_weather_shift = world.time + rand(current_weather.timer_low_bound, current_weather.timer_high_bound) MINUTES
	if(new_weather != old_weather)
		show_transition_message()

	update_icon_effects()
	update_temperature()
	if(old_light_modifier && current_weather.light_modifier != old_light_modifier) // Updating the sun should be done sparingly.
		our_planet.update_sun()
	log_debug("[our_planet.name]'s weather is now [new_weather], with a temperature of [temperature]&deg;K ([temperature - T0C]&deg;C | [temperature * 1.8 - 459.67]&deg;F).")

/datum/weather_holder/proc/process()
	if(world.time >= next_weather_shift)
		if(!current_weather) // Roundstart (hopefully).
			initialize_weather()
		else
			advance_forecast()
	else
		current_weather.process_effects()



// Should only have to be called once.
/datum/weather_holder/proc/initialize_weather()
	if(!current_weather)
		change_weather(get_next_weather())
		build_forecast()

// Used to determine what the weather will be soon, in a semi-random fashion.
// The forecast is made by calling this repeatively, from the bottom (highest index) of the forecast list.
/datum/weather_holder/proc/get_next_weather(var/datum/weather/W)
	if(!current_weather) // At roundstart, choose a suitable initial weather.
		return pickweight(roundstart_weather_chances)
	return pickweight(W.transition_chances)

/datum/weather_holder/proc/advance_forecast()
	var/new_weather = forecast[1]
	forecast.Cut(1, 2) // Remove what we just took out, shortening the list.
	change_weather(new_weather)
	build_forecast() // To fill the forecast to the desired length.

// Creates a list of future weather shifts, that the planet will undergo at some point in the future.
// Determining it ahead of time allows for attentive players to plan further ahead, if they can see the forecast.
/datum/weather_holder/proc/build_forecast()
	var/desired_length = 3
	if(forecast.len >= desired_length)
		return

	while(forecast.len < desired_length)
		if(!forecast.len) // If the forecast is empty, the current_weather is used as a base instead.
			forecast += get_next_weather(current_weather)
		else
			var/position = forecast[forecast.len] // Go to the bottom of the list.
			var/datum/weather/W = allowed_weather_types[position] // Get the actual datum and not a string.
			var/new_weather = get_next_weather(W) // Get a suitable weather pattern to shift to from this one.
			forecast += new_weather
	log_debug("[our_planet.name]'s weather forecast is now '[english_list(forecast, and_text = " then ", final_comma_text = ", ")]'.")

// Wipes the forecast and regenerates it. Used for when the weather is forcefully changed, such as with admin verbs.
/datum/weather_holder/proc/rebuild_forecast()
	forecast.Cut()
	build_forecast()



/datum/weather_holder/proc/update_icon_effects()
	visuals.icon_state = current_weather.icon_state

/datum/weather_holder/proc/update_temperature()
	temperature = Interpolate(current_weather.temp_low, current_weather.temp_high, weight = our_planet.sun_position)
	our_planet.needs_work |= PLANET_PROCESS_TEMP

/datum/weather_holder/proc/get_weather_datum(desired_type)
	return allowed_weather_types[desired_type]


/datum/weather_holder/proc/show_transition_message()
	if(!current_weather.transition_messages.len)
		return

	var/message = pick(current_weather.transition_messages) // So everyone gets the same message.
	for(var/mob/M in player_list) // Don't need to care about clientless mobs.
		if(M.z in our_planet.expected_z_levels)
			var/turf/T = get_turf(M)
			if(!T.outdoors)
				continue
			to_chat(M, message)

/datum/weather
	var/name = "weather base"
	var/icon = 'icons/effects/weather.dmi'
	var/icon_state = null // Icon to apply to turf undergoing weather.
	var/temp_high = T20C // Temperature to apply when at noon.
	var/temp_low = T0C // Temperature to apply when at midnight.
	var/light_modifier = 1.0 // Lower numbers means more darkness.
	var/light_color = null // If set, changes how the day/night light looks.
	var/flight_failure_modifier = 0 // Some types of weather make flying harder, and therefore make crashes more likely. (This is not implemented)
	var/transition_chances = list() // Assoc list of weather identifiers and the odds to shift to a specific type of weather. Can contain its own identifier to prolong it.
	var/datum/weather_holder/holder = null // Reference to the datum that manages the planet's weather.
	var/timer_low_bound = 5			// How long this weather must run before it tries to change, in minutes
	var/timer_high_bound = 10		// How long this weather can run before it tries to change, in minutes
	var/sky_visible = FALSE			// If the sky can be clearly seen while this is occuring, used for flavor text when looking up.

	var/effect_message = null		// Should be a string, this is what is shown to a mob caught in the weather
	var/last_message = 0			// Keeps track of when the weather last tells EVERY player it's hitting them
	var/message_delay = 10 SECONDS	// Delay in between weather hit messages
	var/show_message = FALSE		// Is set to TRUE and plays the messsage every [message_delay]

	var/list/transition_messages = list()// List of messages shown to all outdoor mobs when this weather is transitioned to, for flavor. Not shown if already this weather.
	var/observed_message = null // What is shown to a player 'examining' the weather.

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

// This is for special effects for specific types of weather, such as lightning flashes in a storm.
// It's a seperate object to allow the use of flick().
/atom/movable/weather_visuals/special
	plane = PLANE_LIGHTING_ABOVE