/datum/gm_action/spontaneous_appendicitis
	name = "appendicitis"
	departments = list(ROLE_MEDICAL, ROLE_EVERYONE)
	chaotic = 1

/datum/gm_action/spontaneous_appendicitis/start()
	..()
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		if(H.client && !player_is_antag(H.mind) && H.appendicitis())
			break

/datum/gm_action/spontaneous_appendicitis/get_weight()
	return max(0, -5 + (metric.count_people_in_department(ROLE_MEDICAL) * 10))
