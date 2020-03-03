/datum/gm_action/wormholes
	name = "space-time anomalies"
	chaotic = 70
	length = 12 MINUTES
	departments = list(DEPARTMENT_EVERYONE)
	severity = 1

/datum/gm_action/wormholes/set_up()	// 1 out of 5 will be full-duration wormholes, meaning up to a minute long.
	severity = pickweight(list(
		3 = 5,
		2 = 7,
		1 = 13
		))

/datum/gm_action/wormholes/start()
	..()
	wormhole_event(length / 2, (severity / 3))

/datum/gm_action/wormholes/get_weight()
	return 10 + max(0, -30 + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5) + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) + 10) + (metric.count_people_in_department(DEPARTMENT_MEDICAL) * 20))

/datum/gm_action/wormholes/end()
	command_announcement.Announce("There are no more space-time anomalies detected on the station.", "Anomaly Alert")
