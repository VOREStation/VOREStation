/datum/species
	var/list/default_emotes = list()

/mob/living/carbon/get_available_emotes()
	. = ..()
	if(length(species?.default_emotes))
		. |= species.default_emotes
