/datum/event/spontaneous_appendicitis/vorestation/start()
	for(var/mob/living/carbon/human/H in shuffle(living_mob_list))
		var/area/A = get_area(H)
		if(!A)
			continue
		if(!(A.z in using_map.station_levels))
			continue
		if(A.flag_check(AREA_FORBID_EVENTS))
			continue
		if(isbelly(H.loc))
			continue
		if(H.client && H.appendicitis())
			break
