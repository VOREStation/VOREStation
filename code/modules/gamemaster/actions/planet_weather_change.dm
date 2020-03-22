/datum/gm_action/planet_weather_shift
	name = "sudden weather shift"
	enabled = TRUE
	departments = list(DEPARTMENT_EVERYONE)
	reusable = TRUE
	var/datum/planet/target_planet

	var/list/banned_weathers = list(
		//VOREStation Edit - Virgo 3B Weather,
		/datum/weather/virgo3b/ash_storm,
		/datum/weather/virgo3b/emberfall,
		/datum/weather/virgo3b/blood_moon,
		/datum/weather/virgo3b/fallout)
		//VOREStation Edit End
	var/list/possible_weathers = list()

/datum/gm_action/planet_weather_shift/set_up()
	if(!target_planet || isnull(target_planet))
		target_planet = pick(SSplanets.planets)
	possible_weathers |= target_planet.weather_holder.allowed_weather_types
	possible_weathers -= banned_weathers
	return

/datum/gm_action/planet_weather_shift/get_weight()
	return max(0, -15 + (metric.count_all_outdoor_mobs() * 20))

/datum/gm_action/planet_weather_shift/start()
	..()
	var/new_weather = pick(possible_weathers)
	target_planet.weather_holder.change_weather(new_weather)

/datum/gm_action/planet_weather_shift/announce()
	spawn(rand(3 SECONDS, 2 MINUTES))
		command_announcement.Announce("Local weather patterns on [target_planet.name] suggest that a sudden atmospheric fluctuation has occurred. All groundside personnel should be wary of rapidly deteriorating conditions.", "Weather Alert")
	return
