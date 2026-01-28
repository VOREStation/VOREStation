/datum/trait/dominate_predator
	name = "Dominate Predator"
	desc = "Allows you to attempt to take control of a predator while inside of their belly."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your mind feels more powerful."

/datum/trait/dominate_predator/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/proc/dominate_predator)

// Traitgenes made into a genetrait
/datum/trait/dominate_predator/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/proc/dominate_predator in S.inherent_verbs))
		remove_verb(H,/mob/proc/dominate_predator)

/datum/trait/dominate_prey
	name = "Dominate Prey"
	desc = "Connect to and dominate the brain of your prey."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your mind feels more powerful."

/datum/trait/dominate_prey/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/dominate_prey)

// Traitgenes made into a genetrait
/datum/trait/dominate_prey/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/living/proc/dominate_prey in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/dominate_prey)

/datum/trait/submit_to_prey
	name = "Submit To Prey"
	desc = "Allow prey's mind to control your own body."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your mind feels more fluid."

/datum/trait/submit_to_prey/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/lend_prey_control)

// Traitgenes made into a genetrait
/datum/trait/submit_to_prey/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/living/proc/lend_prey_control in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/lend_prey_control)
