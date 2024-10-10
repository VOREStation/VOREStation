// Toggles
/datum/preference/toggle/bday_announce
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "bday_announce"
	default_value = FALSE
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/toggle/bday_announce/apply_to_human(mob/living/carbon/human/target, value)
	return


// Numerics
/datum/preference/numeric/age
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "age"
	savefile_identifier = PREFERENCE_CHARACTER

	step = 1
	minimum = 18
	maximum = 250

/datum/preference/numeric/age/apply_to_human(mob/living/carbon/human/target, value)
	target.age = value
	return

/datum/preference/numeric/age/create_default_value()
	return 18

/datum/preference/numeric/age/create_random_value(datum/preferences/preferences, datum/species/current_species)
	return rand(current_species.min_age, current_species.max_age)

/datum/preference/numeric/bday_month
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "bday_month"
	savefile_identifier = PREFERENCE_CHARACTER

	step = 1
	minimum = 0
	maximum = 12

/datum/preference/numeric/bday_month/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/bday_month/create_default_value()
	return 0

/datum/preference/numeric/bday_day
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "bday_day"
	savefile_identifier = PREFERENCE_CHARACTER

	step = 1
	minimum = 0
	maximum = 31

/datum/preference/numeric/bday_day/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/numeric/bday_day/create_default_value()
	return 0

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
