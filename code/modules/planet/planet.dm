// This holds information about a specific 'planetside' area, such as its time, weather, etc.  This will most likely be used to model Sif,
// but away missions may also have use for this.

var/datum/planet/sif/planet_sif = null

/datum/planet
	var/name = "a rock"
	var/desc = "Someone neglected to write a nice description for this poor rock."

	var/datum/time/current_time = new() // Holds the current time for sun positioning.  Note that we assume day and night is the same length because simplicity.
	var/sun_process_interval = 1 HOUR
	var/sun_last_process = null // world.time

	var/datum/weather_holder/current_weather = new()
	var/weather_process_interval = 20 MINUTES
	var/weather_last_process = null // world.time as well.

/datum/planet/sif
	name = "Sif"
	desc = "Sif is a terrestrial planet in the Vir system. It is somewhat earth-like, in that it has oceans, a \
	breathable atmosphere, a magnetic field, weather, and similar gravity to Earth. It is currently the capital planet of Vir. \
	Its center of government is the equatorial city and site of first settlement, New Reykjavik." // Ripped straight from the wiki.
	current_time = new /datum/time/sif() // 32 hour clocks are nice.
	current_weather = new /datum/weather_holder/sif() // Cold weather is also nice.

/datum/planet/New()
	..()
	current_time = current_time.make_random_time()
	update_sun()
	update_weather()

/datum/planet/proc/process(amount)
	if(current_time)
		current_time = current_time.add_seconds(amount)
		world << "It's currently [current_time.show_time("hh:mm")] on [name]."
	if(sun_last_process <= world.time - sun_process_interval)
		update_sun()
	if(weather_last_process <= world.time - weather_process_interval)
		update_weather()
	world << "Processed [name]."


/datum/planet/proc/update_sun()
	sun_last_process = world.time
	world << "Praise the sun!"


/datum/planet/sif/update_sun()
	..()
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60 // 32
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	var/sun_position = distance_from_noon / noon
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
			world << "Night."
			min = 0

		if(0.40 to 0.50) // Twilight
			low_brightness = 0.6
			low_color = "#66004D"

			high_brightness = 0.8
			high_color = "#CC3300"
			world << "Twilight."
			min = 0.40

		if(0.50 to 0.70) // Sunrise/set
			low_brightness = 0.8
			low_color = "#CC3300"

			high_brightness = 0.9
			high_color = "#FF9933"
			world << "Sunrise/set."
			min = 0.50

		if(0.70 to 1.00) // Noon
			low_brightness = 0.9
			low_color = "#DDDDDD"

			high_brightness = 1.0
			high_color = "#FFFFFF"
			world << "Noon."
			min = 0.70

	//var/lerp_weight = (sun_position * 4 % 1) / (0.25 / 4) // This weirdness is needed because otherwise the compiler divides by zero.
	var/lerp_weight = (abs(min - sun_position)) * 4
	world << "lerp_weight is [lerp_weight], sun_position is [sun_position]."
	var/new_brightness = Interpolate(low_brightness, high_brightness, weight = lerp_weight)

	var/list/low_color_list = hex2rgb(low_color)
	var/low_r = low_color_list[1]
	var/low_g = low_color_list[2]
	var/low_b = low_color_list[3]

	var/list/high_color_list = hex2rgb(high_color)
	var/high_r = high_color_list[1]
	var/high_g = high_color_list[2]
	var/high_b = high_color_list[3]

	var/new_r = Interpolate(low_r, high_r, weight = lerp_weight)
	var/new_g = Interpolate(low_g, high_g, weight = lerp_weight)
	var/new_b = Interpolate(low_b, high_b, weight = lerp_weight)

	var/new_color = rgb(new_r, new_g, new_b)

	world << "Changing time.  [outdoor_turfs.len] turfs need to be updated.  Expected ETA: [outdoor_turfs.len * 0.0033] seconds."
	world << "Setting outdoor tiles to set_light(2, [new_brightness], [new_color])."
	var/i = 0
	for(var/turf/simulated/floor/T in outdoor_turfs)
		T.set_light(2, new_brightness, new_color)
		i++
		if(i % 30 == 0)
			sleep(1)
	world << "Finished."



/datum/planet/proc/update_weather()
	weather_last_process = world.time
	if(current_weather)
		current_weather.update()