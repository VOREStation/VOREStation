// This holds information about a specific 'planetside' area, such as its time, weather, etc.  This will most likely be used to model Sif,
// but away missions may also have use for this.

/datum/planet
	var/name = "a rock"
	var/desc = "Someone neglected to write a nice description for this poor rock."

	var/datum/time/current_time = new() // Holds the current time for sun positioning.  Note that we assume day and night is the same length because simplicity.
	var/sun_process_interval = 1 HOUR
	var/sun_last_process = null // world.time

	var/datum/weather_holder/weather_holder
	var/datum/sun_holder/sun_holder

	var/sun_position = 0 // 0 means midnight, 1 means noon.
	var/list/sun = list("brightness","color")
	var/list/expected_z_levels = list()

	var/turf/unsimulated/wall/planetary/planetary_wall_type = /turf/unsimulated/wall/planetary

	var/list/turf/simulated/floor/planet_floors = list()
	var/list/turf/unsimulated/wall/planetary/planet_walls = list()

	var/needs_work = 0 // Bitflags to signal to the planet controller these need (properly deferrable) work. Flags defined in controller.

	var/sun_name = "the sun" // For flavor.

	var/moon_name = null // Purely for flavor. Null means no moon exists.
	var/moon_phase = null // Set if above is defined.

/datum/planet/New()
	..()
	weather_holder = new(src)
	sun_holder = new(src)
	current_time = current_time.make_random_time()
	if(moon_name)
		moon_phase = pick(list(
			MOON_PHASE_NEW_MOON,
			MOON_PHASE_WAXING_CRESCENT,
			MOON_PHASE_FIRST_QUARTER,
			MOON_PHASE_WAXING_GIBBOUS,
			MOON_PHASE_FULL_MOON,
			MOON_PHASE_WANING_GIBBOUS,
			MOON_PHASE_LAST_QUARTER,
			MOON_PHASE_WANING_CRESCENT
			))
	update_sun()

/datum/planet/process(last_fire)
	if(current_time)
		var/difference = world.time - last_fire
		current_time = current_time.add_seconds((difference / 10) * PLANET_TIME_MODIFIER)
	update_weather() // We update this first, because some weather types decease the brightness of the sun.
	if(sun_last_process <= world.time - sun_process_interval)
		update_sun()

// This changes the position of the sun on the planet.
/datum/planet/proc/update_sun()
	sun_last_process = world.time

/datum/planet/proc/update_weather()
	if(weather_holder)
		weather_holder.process()

/datum/planet/proc/update_sun_deferred(var/new_brightness, var/new_color)
	if(new_brightness < 0 || new_brightness > 1)
		CRASH("Planetary sun brightness was outside of sane bounds. Expected 0.00 to 1.00, got [new_brightness].")
	sun["brightness"] = new_brightness
	sun["color"] = new_color
	needs_work |= PLANET_PROCESS_SUN
