// Implements a verb to make your character look upward, mostly intended for the surface.

/mob/living/verb/look_up()
	set name = "Look Up"
	set category = "IC"
	set desc = "Look above you, and hope there's no ceiling spiders."

	to_chat(usr, "You look upwards...")

	var/turf/T = get_turf(usr)
	if(!T) // In null space.
		to_chat(usr, span("warning", "You appear to be in a place without any sort of concept of direction. You have bigger problems to worry about."))
		return

	if(!T.is_outdoors()) // They're inside.
		to_chat(usr, "You see nothing interesting.")
		return

	else // They're outside and hopefully on a planet.
		var/datum/planet/P = SSplanets.z_to_planet[T.z]
		if(!P)
			to_chat(usr, span("warning", "You appear to be outside, but not on a planet... Something is wrong."))
			return

		var/datum/weather_holder/WH = P.weather_holder

		// Describe the current weather.
		if(WH.current_weather.observed_message)
			to_chat(usr, WH.current_weather.observed_message)

		// Describe the current weather.
		if(WH.imminent_weather)
			var/datum/weather/coming_weather = WH.allowed_weather_types[WH.imminent_weather]
			to_chat(usr, coming_weather.imminent_transition_message)

		// If we can see the sky, we'll see things like sun position, phase of the moon, etc.
		if(!WH.current_weather.sky_visible)
			to_chat(usr, "You can't see the sky clearly due to the [WH.current_weather.name].")
		else
			// Sun-related output.
			if(P.sun_name)
				var/afternoon = P.current_time.seconds_stored > (P.current_time.seconds_in_day / 2)

				var/sun_message = null
				switch(P.sun_position)
					if(0 to 0.4) // Night
						sun_message = "It is night time, [P.sun_name] is not visible."
					if(0.4 to 0.5) // Twilight
						sun_message = "The sky is in twilight, however [P.sun_name] is not visible."
					if(0.5 to 0.7) // Sunrise/set.
						sun_message = "[P.sun_name] is slowly [!afternoon ? "rising from" : "setting on"] the horizon."
					if(0.7 to 0.9) // Morning/evening
						sun_message = "[P.sun_name]'s position implies it is currently [!afternoon ? "early" : "late"] in the day."
					if(0.9 to 1.0) // Noon
						sun_message = "It's high noon. [P.sun_name] hangs directly above you."

				to_chat(usr, sun_message)

			// Now for the moon.
			if(P.moon_name)
				if(P.moon_phase == MOON_PHASE_NEW_MOON)
					to_chat(usr, "[P.moon_name] is not visible. It must be a new moon.")
				else
					to_chat(usr, "[P.moon_name] appears to currently be a [P.moon_phase].")

