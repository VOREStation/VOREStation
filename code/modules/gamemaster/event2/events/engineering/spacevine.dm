/datum/event2/meta/spacevine
	name = "space-vine infestation"
	departments = list(DEPARTMENT_ENGINEERING)
	chaos = 10 // There's a really rare chance of vines getting something awful like phoron atmosphere but thats not really controllable.
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/spacevine

/datum/event2/meta/spacevine/get_weight()
	return 20 + (GLOB.metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 10) + (GLOB.metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5)



/datum/event2/event/spacevine/announce()
	level_seven_announcement()

/datum/event2/event/spacevine/start()
	spacevine_infestation()
