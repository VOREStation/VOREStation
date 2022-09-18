
/datum/species/proc/get_wing_hair(var/mob/living/carbon/human/H) //I have no idea what this is even used for other than teshari, but putting it in just in case.
	return wing_hair //Since the tail has it.
/datum/species/proc/get_wing(var/mob/living/carbon/human/H)
		return wing
/datum/species/proc/get_wing_animation(var/mob/living/carbon/human/H)
	return wing_animation

/datum/species/proc/get_perfect_belly_air_type(var/mob/living/carbon/human/H)
	if(ideal_air_type)
		return ideal_air_type						//Whatever we want
	else
		return /datum/gas_mixture/belly_air 		//Default