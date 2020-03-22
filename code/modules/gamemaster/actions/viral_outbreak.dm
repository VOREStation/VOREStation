/datum/gm_action/viral_outbreak
	name = "viral outbreak"
	departments = list(DEPARTMENT_MEDICAL, DEPARTMENT_EVERYONE)
	chaotic = 30
	severity = 1
	var/list/candidates = list()

/datum/gm_action/viral_outbreak/set_up()
	candidates.Cut()	// Incase we somehow get run twice.
	severity = rand(2, 4)
	for(var/mob/living/carbon/human/G in player_list)
		if(G.client && G.stat != DEAD)
			candidates += G
	if(!candidates.len)	return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

/datum/gm_action/viral_outbreak/announce()
	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard \the [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

/datum/gm_action/viral_outbreak/start()
	..()
	while(severity > 0 && candidates.len)
		if(prob(33))
			infect_mob_random_lesser(candidates[1])
		else
			infect_mob_random_greater(candidates[1])

		candidates.Remove(candidates[1])
		severity--

/datum/gm_action/viral_outbreak/get_weight()
	var/medical = metric.count_people_in_department(DEPARTMENT_MEDICAL)
	var/security = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/everyone = metric.count_people_in_department(DEPARTMENT_EVERYONE)

	var/assigned_staff = medical + round(security / 2)

	if(!medical)	// No docs, no staff.
		assigned_staff = 0

	if(assigned_staff < round(everyone / 6) - assigned_staff)	// A doc or half an officer per roughly six people. Any less, and assigned staff is halved.
		assigned_staff /= 2

	return (assigned_staff * 10)
