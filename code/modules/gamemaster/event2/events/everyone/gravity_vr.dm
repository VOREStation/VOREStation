/datum/event2/meta/gravity
	name = "gravity failure"
	departments = list(DEPARTMENT_EVERYONE)
	chaos = 20
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/gravity

/datum/event2/meta/gravity/get_weight()
	return (20 + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 20)) / (times_ran + 1)




/datum/event2/event/gravity
	length_lower_bound = 5 MINUTES
	length_upper_bound = 20 MINUTES
	var/list/generators = list()

/datum/event2/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled. Please wait for the system to reinitialize, or contact your engineering department.", "Gravity Failure")

/datum/event2/event/gravity/start()
	gravity_is_on = 0

	for(var/obj/machinery/gravity_generator/main/GG in machines)
		if((GG.z in get_location_z_levels()) && GG.on)
			generators += GG
			GG.breaker = FALSE
			GG.set_power()
			GG.charge_count = 10

/datum/event2/event/gravity/end()
	gravity_is_on = 1

	var/did_anything = FALSE
	for(var/obj/machinery/gravity_generator/main/GG in generators)
		if(!GG.on)
			GG.breaker = TRUE
			GG.set_power()
			GG.charge_count = 90
			did_anything = TRUE

	if(did_anything)
		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored")
