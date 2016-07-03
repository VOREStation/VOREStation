/obj/machinery/bodyscanner/proc/get_occupant_data_vr(list/incoming,mob/living/carbon/human/H)
	var/humanprey = 0
	var/livingprey = 0
	var/objectprey = 0

	for(var/I in H.vore_organs)
		var/datum/belly/B = H.vore_organs[I]
		for(var/C in B.internal_contents)
			if(ishuman(C))
				humanprey++
			else if(isliving(C))
				livingprey++
			else
				objectprey++

	incoming["livingPrey"] = livingprey
	incoming["humanPrey"] = humanprey
	incoming["objectPrey"] = objectprey
	incoming["weight"] = H.weight

	return incoming
