// This event sends one wave of meteors unannounced.

/datum/gm_action/surprise_meteors
	name = "surprise meteors"
	departments = list(DEPARTMENT_ENGINEERING)
	chaotic = 25

/datum/gm_action/surprise_meteors/get_weight()
	var/engineers = metric.count_people_in_department(DEPARTMENT_ENGINEERING)
	var/weight = (max(engineers - 1, 0) * 25) // If only one engineer exists, no meteors for now.
	return weight

/datum/gm_action/surprise_meteors/start()
	..()
	spawn(1)
		spawn_meteors(rand(4, 8), meteors_normal, pick(cardinal))
	message_admins("Surprise meteors event has ended.")