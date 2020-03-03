/datum/gm_action/solar_storm
	name = "solar storm"
	var/rad_interval = 1 SECOND
	var/base_solar_gen_rate
	length = 3 MINUTES
	var/duration	// Duration for the storm
	var/start_time = 0

	reusable = TRUE

/datum/gm_action/solar_storm/set_up()
	start_time = world.time
	duration = length
	duration += rand(-1 * 1 MINUTE, 1 MINUTE)

/datum/gm_action/solar_storm/announce()
	command_announcement.Announce("A solar storm has been detected approaching \the [station_name()]. Please halt all EVA activites immediately and return to the interior of the station.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')
	adjust_solar_output(1.5)

/datum/gm_action/solar_storm/proc/adjust_solar_output(var/mult = 1)
	if(isnull(base_solar_gen_rate)) base_solar_gen_rate = GLOB.solar_gen_rate
	GLOB.solar_gen_rate = mult * base_solar_gen_rate

/datum/gm_action/solar_storm/start()
	..()
	length = duration
	command_announcement.Announce("The solar storm has reached the station. Please refain from EVA and remain inside the station until it has passed.", "Anomaly Alert")
	adjust_solar_output(5)

	var/start_time = world.time

	spawn()
		while(world.time <= start_time + duration)
			sleep(rad_interval)
			radiate()

/datum/gm_action/solar_storm/get_weight()
	return 20 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 10) + (metric.count_all_space_mobs() * 30)

/datum/gm_action/solar_storm/proc/radiate()
	// Note: Too complicated to be worth trying to use the radiation system for this.  Its only in space anyway, so we make an exception in this case.
	for(var/mob/living/L in player_list)
		var/turf/T = get_turf(L)
		if(!T)
			continue

		if(!istype(T.loc,/area/space) && !istype(T,/turf/space))	//Make sure you're in a space area or on a space turf
			continue

		//Todo: Apply some burn damage from the heat of the sun. Until then, enjoy some moderate radiation.
		L.rad_act(rand(15, 30))

/datum/gm_action/solar_storm/end()
	command_announcement.Announce("The solar storm has passed the station. It is now safe to resume EVA activities. Please report to medbay if you experience any unusual symptoms. ", "Anomaly Alert")
	adjust_solar_output()
	length = initial(length)
