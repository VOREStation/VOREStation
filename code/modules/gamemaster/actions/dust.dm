/datum/gm_action/dust
	name = "dust"
	departments = list(DEPARTMENT_ENGINEERING)
	chaotic = 10
	reusable = TRUE

/datum/gm_action/dust/announce()
	command_announcement.Announce("Debris resulting from activity on another nearby asteroid is approaching your colony.", "Dust Alert")

/datum/gm_action/dust/get_weight()
	var/engineers = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	var/weight = 30 + (engineers * 25)
	return weight

/datum/gm_action/dust/start()
	..()
	dust_swarm("norm")
