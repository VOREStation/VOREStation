// Species preference for character creation
// Handles the player's selected species, validated against GLOB.playable_species.

/datum/preference/choiced/species
	savefile_key = "species"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	can_randomize = FALSE
	priority = PREFERENCE_PRIORITY_SPECIES

/datum/preference/choiced/species/init_possible_values()
	// GLOB.playable_species is populated at world init and contains all joinable species names.
	return GLOB.playable_species

/datum/preference/choiced/species/create_default_value()
	return SPECIES_HUMAN

/datum/preference/choiced/species/pref_deserialize(input, datum/preferences/preferences)
	if(!input || !istext(input) || !(input in GLOB.playable_species))
		return SPECIES_HUMAN
	return input

/datum/preference/choiced/species/is_valid(value)
	if(!istext(value))
		return FALSE
	return value in GLOB.playable_species

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/target, value)
	return // Species application is handled by copy_to via character.set_species()

/datum/preference/choiced/species/apply_to_living(mob/living/target, value)
	return

/datum/preference/choiced/species/apply_to_silicon(mob/living/silicon/target, value)
	return

/datum/preference/choiced/species/apply_to_animal(mob/living/simple_mob/target, value)
	return
