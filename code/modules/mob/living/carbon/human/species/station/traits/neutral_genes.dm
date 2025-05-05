//VOREStation Note: TRAITGENETICS - Originally, these were in negative_genes.dm
//However, given their more RP centric nature, they have been moved to neutral_traits.
//If desire is wanted to move them back to negative traits, change the 'neutral' to 'negative'
/datum/trait/neutral/disability_censored
	name = "Censored"
	desc = "You are unable to speak profanity. To an excessive degree..."
	cost = 0 // TRAITGENETICS - Originally was -1
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	disability=CENSORED
	activation_message="You feel less rude..."
	primitive_expression_messages=list("BEEPS!")

/datum/trait/neutral/disability_nervousness
	name = "Nervousness"
	desc = "You are generally nervous natured, often stuttering words."
	cost = 0 // TRAITGENETICS - Originally was -1
	custom_only = FALSE

	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel nervous."
	primitive_expression_messages=list("nervously chitters.")
/datum/trait/neutral/disability_nervousness/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	H.LoadComponent(/datum/component/nervousness_disability)
/datum/trait/neutral/disability_nervousness/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	var/datum/component/nervousness_disability/D = H.GetComponent(/datum/component/nervousness_disability)
	if(D)
		qdel(D)
