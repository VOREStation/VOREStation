/datum/event2/meta/dust
	name = "dust"
	departments = list(DEPARTMENT_ENGINEERING)
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/dust

/datum/event2/meta/dust/get_weight()
	return GLOB.metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 20



/datum/event2/event/dust/announce()
	if(prob(33))
		command_announcement.Announce("Dust has been detected on a collision course with \the [location_name()].")

/datum/event2/event/dust/start()
	dust_swarm("norm")
