// Handles the subjugation of slimes by force.
// Mostly a way for things to talk to the AI indirectly.

/mob/living/simple_mob/slime/xenobio/proc/adjust_discipline(amount, silent)
	if(amount > 0)
		to_chat(src, span("warning", "You've been disciplined!"))
	if(has_AI())
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		AI.adjust_discipline(amount, silent)


/mob/living/simple_mob/slime/xenobio/proc/is_justified_to_discipline()
	if(victim) // Punish if eating someone that isn't a monkey.
		if(ishuman(victim))
			var/mob/living/human/H = victim
			if(istype(H.species, /datum/species/monkey))
				return FALSE
		return TRUE

	else if(has_AI()) // Now for thoughtcrimes.
		var/datum/ai_holder/simple_mob/xenobio_slime/AI = ai_holder
		return AI.is_justified_to_discipline() // Will return true if targeting a non-monkey.
	return FALSE
