/datum/gm_action/security_drill
	name = "security drills"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)

/datum/gm_action/security_drill/announce()
	spawn(rand(1 MINUTE, 2 MINUTES))
		command_announcement.Announce("[pick("A NanoTrasen security director", "A Vir-Gov correspondant", "Local Sif authoritiy")] has advised the enactment of [pick("a rampant wildlife", "a fire", "a hostile boarding", "a nonstandard", "a bomb", "an emergent intelligence")] drill with the personnel onboard \the [station_name()].", "Security Advisement")

/datum/gm_action/security_drill/get_weight()
	return max(-20, 10 + gm.staleness - (gm.danger * 2)) + (metric.count_people_in_department(DEPARTMENT_SECURITY) * 5) + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 1.5)
