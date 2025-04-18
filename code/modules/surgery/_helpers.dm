/mob/living/proc/get_missing_limbs()
	return list()

/mob/living/carbon/human/get_missing_limbs()
	RETURN_TYPE(/list)
	var/list/full = BP_ALL

	for(var/zone in full)
		if(get_bodypart_name(zone))
			full -= zone
	return full
