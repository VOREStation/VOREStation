/datum/gm_action/atmos_leak
	name = "atmospherics leak"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_SYNTHETIC)
	var/area/target_area	// Chosen target area
	var/area/target_turf	// Chosen target turf in target_area
	var/gas_type			// Chosen gas to release
	// Exclude these types and sub-types from targeting eligibilty
	var/list/area/excluded = list(
		/area/submap,
		/area/shuttle,
		/area/crew_quarters,
		/area/holodeck,
		/area/engineering/engine_room
	)

	severity

// Decide which area will be targeted!
/datum/gm_action/atmos_leak/set_up()
	severity = pickweight(EVENT_LEVEL_MUNDANE = 8,
	EVENT_LEVEL_MODERATE = 5,
	EVENT_LEVEL_MAJOR = 3
	)

	var/gas_choices = list("carbon_dioxide", "sleeping_agent") // Annoying
	if(severity >= EVENT_LEVEL_MODERATE)
		gas_choices += "phoron" // Dangerous
	if(severity >= EVENT_LEVEL_MAJOR)
		gas_choices += "volatile_fuel" // Dangerous and no default atmos setup!
	gas_type = pick(gas_choices)

	var/list/area/grand_list_of_areas = get_station_areas(excluded)

	// Okay, now lets try and pick a target! Lets try 10 times, otherwise give up
	for(var/i in 1 to 10)
		var/area/A = pick(grand_list_of_areas)
		if(is_area_occupied(A))
			log_debug("atmos_leak event: Rejected [A] because it is occupied.")
			continue
		// A good area, great! Lets try and pick a turf
		var/list/turfs = list()
		for(var/turf/simulated/floor/F in A)
			if(turf_clear(F))
				turfs += F
		if(turfs.len == 0)
			log_debug("atmos_leak event: Rejected [A] because it has no clear turfs.")
			continue
		target_area = A
		target_turf = pick(turfs)

	// If we can't find a good target, give up
	if(!target_area)
		log_debug("atmos_leak event: Giving up after too many failures to pick target area")
		return

/datum/gm_action/atmos_leak/announce()
	if(target_area)
		command_announcement.Announce("Warning, hazardous [gas_data.name[gas_type]] gas leak detected in \the [target_area], evacuate the area.", "Hazard Alert")

/datum/gm_action/atmos_leak/start()
	if(!target_turf)
		return
	..()
	spawn(rand(0, 600))
		// Okay, time to actually put the gas in the room!
		// TODO - Would be nice to break a waste pipe perhaps?
		// TODO - Maybe having it released from a single point and thus causing airflow to blow stuff around

		// Fow now just add a bunch of it to the air
		var/datum/gas_mixture/air_contents = new
		air_contents.temperature = T20C + ((severity - 1) * rand(-50, 50))
		air_contents.gas[gas_type] = 10 * MOLES_CELLSTANDARD
		target_turf.assume_air(air_contents)
		playsound(target_turf, 'sound/effects/smoke.ogg', 50, 1)

/datum/gm_action/atmos_leak/get_weight()
	return 15 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 10 + metric.count_people_in_department(DEPARTMENT_SYNTHETIC) * 30)	// Synthetics are counted in higher value because they can wirelessly connect to alarms.
