/datum/trait/blindness
	name = "Permanently blind"
	desc = "You are blind. For whatever reason, nothing is able to change this fact, not even surgery. WARNING: YOU WILL NOT BE ABLE TO SEE ANY POSTS USING THE ME VERB, ONLY SUBTLE AND DIALOGUE ARE VIEWABLE TO YOU, YOU HAVE BEEN WARNED."
	cost = -12
	special_env = TRUE
	custom_only = FALSE
	category = TRAIT_TYPE_NEGATIVE

	// Traitgenes Replaces /datum/trait/disability_blind, made into a gene trait
	is_genetrait = TRUE
	hidden = TRUE //Making this so people can't pick it in character select. While a blind character makes senese, not being able to see posts is a massive issue that needs to be addressed some other time.

	sdisability=BLIND
	activation_message="You can't seem to see anything."
	primitive_expression_messages=list("stumbles aimlessly.")

/datum/trait/blindness/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		//no matter what you do, the blindess still comes for you // Traitgenes tweaked to be consistant with other gene traits by using var
