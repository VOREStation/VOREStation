/datum/preference/toggle/bday_announce
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "bday_announce"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/toggle/bday_announce/apply_to_human(mob/living/carbon/human/target, value)
	return
