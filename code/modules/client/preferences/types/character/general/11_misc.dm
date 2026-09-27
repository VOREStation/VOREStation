/datum/preference/toggle/human/ignore_shoes
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "ignore_shoes"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/toggle/human/ignore_shoes/apply_to_human(mob/living/carbon/human/target, value)
	return

// Whether mob can be printed as a snack. requires body scan. Default false.
/datum/preference/toggle/living/foodsynth_cookies
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "vore_fsynth_cookie"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/toggle/living/foodsynth_cookies/apply_to_living(mob/living/target, value)
	return
