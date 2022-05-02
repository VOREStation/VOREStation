/datum/event/spontaneous_appendicitis/start()
	for(var/mob/living/human/H in shuffle(living_mob_list))
		if(H.client && H.appendicitis())
			break
