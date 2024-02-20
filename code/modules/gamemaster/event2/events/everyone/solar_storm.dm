/datum/event2/meta/solar_storm
	name = "solar storm"
	reusable = TRUE
	event_type = /datum/event2/event/solar_storm

/datum/event2/meta/solar_storm/get_weight()
	var/population_factor = metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 10
	var/space_factor = metric.count_all_space_mobs() * 50
	return (20 + population_factor + space_factor) / (times_ran + 1)


/datum/event2/event/solar_storm
	start_delay_lower_bound = 1 MINUTE
	start_delay_upper_bound = 1 MINUTE
	length_lower_bound = 2 MINUTES
	length_upper_bound = 4 MINUTES
	var/base_solar_gen_rate = null

/datum/event2/event/solar_storm/announce()
	command_announcement.Announce("A solar storm has been detected approaching \the [station_name()]. \
	Please halt all EVA activites immediately and return to the interior of the station.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')
	adjust_solar_output(1.5)

/datum/event2/event/solar_storm/start()
	command_announcement.Announce("The solar storm has reached the station. Please refrain from EVA and remain inside the station until it has passed.", "Anomaly Alert")
	adjust_solar_output(5)

/datum/event2/event/solar_storm/event_tick()
	radiate()

/datum/event2/event/solar_storm/end()
	command_announcement.Announce("The solar storm has passed the station. It is now safe to resume EVA activities. \
	Please report to medbay if you experience any unusual symptoms.", "Anomaly Alert")
	adjust_solar_output(1)

/datum/event2/event/solar_storm/proc/adjust_solar_output(var/mult = 1)
	if(isnull(base_solar_gen_rate))
		base_solar_gen_rate = GLOB.solar_gen_rate
	GLOB.solar_gen_rate = mult * base_solar_gen_rate

/datum/event2/event/solar_storm/proc/radiate()
	// Note: Too complicated to be worth trying to use the radiation system for this.  Its only in space anyway, so we make an exception in this case.
	for(var/mob/living/L in player_list)
		var/turf/T = get_turf(L)
		if(!T)
			continue

		if(!istype(T.loc,/area/space) && !istype(T,/turf/space))	//Make sure you're in a space area or on a space turf
			continue

		//Todo: Apply some burn damage from the heat of the sun. Until then, enjoy some moderate radiation.
		L.rad_act(rand(15, 30))
