/datum/preference/toggle/human/ignore_shoes
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "ignore_shoes"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/toggle/human/ignore_shoes/apply_to_human(mob/living/carbon/human/target, value)
	return
