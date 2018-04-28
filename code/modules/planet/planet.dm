// This holds information about a specific 'planetside' area, such as its time, weather, etc.  This will most likely be used to model Sif,
// but away missions may also have use for this.

/datum/planet
	var/name = "a rock"
	var/desc = "Someone neglected to write a nice description for this poor rock."

	var/datum/time/current_time = new() // Holds the current time for sun positioning.  Note that we assume day and night is the same length because simplicity.
	var/sun_process_interval = 1 HOUR
	var/sun_last_process = null // world.time

	var/datum/weather_holder/weather_holder

	var/sun_position = 0 // 0 means midnight, 1 means noon.
	var/list/sun = list("range","brightness","color","lum_r","lum_g","lum_b")
	var/list/datum/lighting_corner/sunlit_corners = list()
	var/expected_z_levels = list()

	var/turf/unsimulated/wall/planetary/planetary_wall_type = /turf/unsimulated/wall/planetary

	var/list/turf/simulated/floor/planet_floors = list()
	var/list/turf/unsimulated/wall/planetary/planet_walls = list()


	var/needs_work = 0 // Bitflags to signal to the planet controller these need (properly deferrable) work. Flags defined in controller.

/datum/planet/New()
	..()
	weather_holder = new(src)
	current_time = current_time.make_random_time()
	update_sun()

/datum/planet/proc/process(amount)
	if(current_time)
		current_time = current_time.add_seconds(amount)
	update_weather() // We update this first, because some weather types decease the brightness of the sun.
	if(sun_last_process <= world.time - sun_process_interval)
		update_sun()

// This changes the position of the sun on the planet.
/datum/planet/proc/update_sun()
	sun_last_process = world.time

/datum/planet/proc/update_weather()
	if(weather_holder)
		weather_holder.process()

/datum/planet/proc/update_sun_deferred(var/new_range, var/new_brightness, var/new_color)
	sun["range"] = new_range
	sun["brightness"] = new_brightness
	sun["color"] = new_color
	needs_work |= PLANET_PROCESS_SUN

