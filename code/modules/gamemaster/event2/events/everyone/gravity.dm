/datum/event2/meta/gravity
	name = "gravity failure"
	departments = list(DEPARTMENT_EVERYONE)
	chaos = 20
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/gravity

/datum/event2/meta/gravity/get_weight()
	return (20 + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5)) / (times_ran + 1)




/datum/event2/event/gravity
	length_lower_bound = 4 MINUTES
	length_upper_bound = 8 MINUTES

/datum/event2/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in mass-distributions systems. \
	Artificial gravity has been disabled whilst the system reinitializes. \
	Please stand by while the gravity system reinitializes.", "Gravity Failure")

/datum/event2/event/gravity/start()
	for(var/area/A in world)
		if(A.z in get_location_z_levels(space_only = TRUE))
			A.gravitychange(FALSE)

/datum/event2/event/gravity/end()
	for(var/area/A in world)
		if(A.z in get_location_z_levels(space_only = TRUE))
			A.gravitychange(TRUE)

	command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored")
