/datum/artifact_effect/berserk
	name = "berserk"
	effect_type = EFFECT_PSIONIC

	effect_state = "summoning"
	effect_color = "#5f0000"

/datum/artifact_effect/berserk/proc/apply_berserk(var/mob/living/L)
	if(!istype(L))
		return FALSE

	if(!L.is_sentient())
		return FALSE // Drons are presumably deaf to any psionic things.

	if(L.add_modifier(/datum/modifier/berserk, 30 SECONDS))
		to_chat(L, span_danger("An otherworldly feeling seems to enter your mind, and it ignites your mind in fury!"))
		L.adjustBrainLoss(3) // Playing with berserking alien psychic artifacts isn't good for the mind.
		to_chat(L, span_danger("The inside of your head hurts..."))
		return TRUE
	else
		if(L.has_modifier_of_type(/datum/modifier/berserk)) // Already angry.
			to_chat(L, span_warning("An otherworldly feeling seems to enter your mind again, and it fans your inner flame, extending your rage."))
		else // Exhausted or something.
			to_chat(L, "<span class='warning'>An otherworldly feeling seems to enter your mind, and you briefly feel an intense anger, but \
			it quickly passes.</span>")
		return FALSE

/datum/artifact_effect/berserk/DoEffectTouch(var/mob/toucher)
	if(toucher && isliving(toucher))
		apply_berserk(toucher)
		return TRUE

/datum/artifact_effect/berserk/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/L in range(src.effectrange,T))
			if(prob(10))
				apply_berserk(L)
		return TRUE

/datum/artifact_effect/berserk/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/L in range(src.effectrange,T))
			apply_berserk(L)
		return TRUE
