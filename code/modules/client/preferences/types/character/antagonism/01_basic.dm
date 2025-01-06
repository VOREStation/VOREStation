/datum/preference/choiced/uplinklocation
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "uplinklocation"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/uplinklocation/init_possible_values()
	return GLOB.uplink_locations

// No application
/datum/preference/choiced/uplinklocation/apply_to_living(mob/living/target, value)
	return
/datum/preference/choiced/uplinklocation/apply_to_animal(mob/living/simple_mob/target, value)
	return
/datum/preference/choiced/uplinklocation/apply_to_human(mob/living/carbon/human/target, value)
	return
/datum/preference/choiced/uplinklocation/apply_to_silicon(mob/living/silicon/target, value)
	return
