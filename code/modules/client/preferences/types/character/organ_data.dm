// Organ data preference for character creation
// Stores an assoc list mapping organ tags to their prosthetic/modified status.
// Values can be: null (normal), "cyborg", "amputated", FBP_ASSISTED, FBP_MECHANICAL, or FBP_DIGITAL.

/datum/preference/organ_data
	savefile_key = "organ_data"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	can_randomize = FALSE

/datum/preference/organ_data/create_default_value()
	return list()

/datum/preference/organ_data/pref_deserialize(input, datum/preferences/preferences)
	if(!islist(input))
		return list()
	// Return the list directly (same reference) so in-place mutations update the cache.
	return input

/datum/preference/organ_data/pref_serialize(input)
	if(!islist(input))
		return list()
	return check_list_copy(input)

/datum/preference/organ_data/is_valid(value)
	return islist(value)

/datum/preference/organ_data/apply_to_human(mob/living/carbon/human/target, value)
	return // Organ application is handled by copy_to_mob in 03_body.dm

/datum/preference/organ_data/apply_to_living(mob/living/target, value)
	return

/datum/preference/organ_data/apply_to_silicon(mob/living/silicon/target, value)
	return

/datum/preference/organ_data/apply_to_animal(mob/living/simple_mob/target, value)
	return
