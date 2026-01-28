/datum/trait/vibration_sense
	name = "Vibration Sense"
	desc = "Allows you to sense subtle vibrations nearby, even if the source cannot be seen."
	cost = 2
	var_changes = list("has_vibration_sense" = TRUE)
	category = TRAIT_TYPE_POSITIVE

	// Traitgenes edit begin - Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your ears ring, and hear everything..."
	// Traitgenes edit end

/datum/trait/vibration_sense/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	. = ..()
	H.motiontracker_subscribe()
	add_verb(H,/mob/living/carbon/human/proc/sonar_ping)

/datum/trait/vibration_sense/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	. = ..()
	H.motiontracker_unsubscribe()
	remove_verb(H,/mob/living/carbon/human/proc/sonar_ping)
