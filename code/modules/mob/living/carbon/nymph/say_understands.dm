/mob/living/carbon/diona/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(ishuman(other) && !speaking)
		if(languages.len >= 2) // They have sucked down some blood.
			return TRUE
	return ..()
