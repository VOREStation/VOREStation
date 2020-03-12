// A shuttle full of junk docks, and cargo is tasked with sifting through it all to find valuables, or just dispose of it.

/datum/gm_action/waste_disposal
	name = "waste disposal"
	departments = list(DEPARTMENT_CARGO)
	chaotic = 0

/datum/gm_action/waste_disposal/get_weight()
	return metric.count_people_in_department(DEPARTMENT_CARGO) * 50