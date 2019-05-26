/datum/gm_action/spacevine
	name = "space-vine infestation"
	departments = list(ROLE_ENGINEERING)
	chaotic = 2

/datum/gm_action/spacevine/start()
	..()
	spacevine_infestation()

/datum/gm_action/spacevine/announce()
	level_seven_announcement()

/datum/gm_action/spacevine/get_weight()
	return 20 + (metric.count_people_in_department(ROLE_ENGINEERING) * 20) + (metric.count_people_in_department(ROLE_EVERYONE) * 10)
