/datum/preference/toggle/bday_announce
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "bday_announce"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/toggle/bday_announce/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/last_bday_note
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "last_bday_note"
	savefile_identifier = PREFERENCE_CHARACTER

	step = 1
	minimum = 0
	maximum = 9999

/datum/preference/numeric/last_bday_note/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/last_bday_note/create_default_value()
	return 0

/datum/preference/numeric/last_bday_note/is_accessible(datum/preferences/preferences)
	..()
	return FALSE
