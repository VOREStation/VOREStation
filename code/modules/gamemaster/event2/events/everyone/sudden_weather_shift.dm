/datum/event2/meta/sudden_weather_shift
	name = "sudden weather shift"
	departments = list(DEPARTMENT_EVERYONE)
	reusable = TRUE
	event_type = /datum/event2/event/sudden_weather_shift

/datum/event2/meta/sudden_weather_shift/get_weight()
	// The proc name is a bit misleading, it only counts players outside, not all mobs.
	return (metric.count_all_outdoor_mobs() * 20) / (times_ran + 1)

/datum/event2/event/sudden_weather_shift
	start_delay_lower_bound = 30 SECONDS
	start_delay_upper_bound = 1 MINUTE
	var/datum/planet/chosen_planet = null

/datum/event2/event/sudden_weather_shift/set_up()
	if(!LAZYLEN(SSplanets.planets))
		log_debug("Weather shift event was ran when no planets exist. Aborting.")
		abort()
		return

	chosen_planet = pick(SSplanets.planets)

/datum/event2/event/sudden_weather_shift/announce()
	if(!chosen_planet)
		return
	command_announcement.Announce("Local weather patterns on [chosen_planet.name] suggest that a \
	sudden atmospheric fluctuation has occurred. All groundside personnel should be wary of \
	rapidly deteriorating conditions.", "Weather Alert")

/datum/event2/event/sudden_weather_shift/start()
	// Using the roundstart weather list is handy, because it avoids the chance of choosing a bus-only weather.
	// It also makes this event generic and suitable for other planets besides the main one, with no additional code needed.
	// Only flaw is that roundstart weathers are -usually- safe ones, but we can fix that by tweaking a copy of it.
	var/list/weather_choices = chosen_planet.weather_holder.roundstart_weather_chances.Copy()
	var/list/new_weather_weights = list()

	// A lazy way of inverting the odds is to use some division.
	for(var/weather in weather_choices)
		new_weather_weights[weather] = 100 / weather_choices[weather]

	// Now choose a new weather.
	var/new_weather = pickweight(new_weather_weights)
	log_debug("Sudden weather shift event is now changing [chosen_planet.name]'s weather to [new_weather].")
	chosen_planet.weather_holder.change_weather(new_weather)
