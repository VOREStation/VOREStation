// Comms blackout is, just like grid check, mostly the same as always, yet engineering has an option to get it back sooner.

/datum/gm_action/comms_blackout
	name = "communications blackout"
	departments = list(ROLE_ENGINEERING, ROLE_EVERYONE)
	chaotic = 35

/datum/gm_action/comms_blackout/get_weight()
	return 50 + (metric.count_people_in_department(ROLE_ENGINEERING) * 40)