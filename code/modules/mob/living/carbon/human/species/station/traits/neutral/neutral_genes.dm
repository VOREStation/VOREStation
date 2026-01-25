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
	added_component_path = /datum/component/nervousness_disability

/datum/trait/neutral/disability_tourettes
	name = "Tourettes Syndrome"
	desc = "You suffer from occasional motor and vocal tics, which are exacerbated during times of stress."
	cost = 0 // Originally was -2
	custom_only = FALSE

	is_genetrait = FALSE
	hidden = TRUE

	activation_message="You twitch."
	primitive_expression_messages=list("twitches and chitters.")
	added_component_path = /datum/component/tourettes_disability
