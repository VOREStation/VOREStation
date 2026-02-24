// Gender/Pronoun preferences for character creation
// Handles biological sex and identifying gender (pronouns)

/// Abstract gender preference type that provides species-aware validation
/datum/preference/choiced/gender
	abstract_type = /datum/preference/choiced/gender
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	can_randomize = FALSE
	var/default_species = SPECIES_HUMAN

/// FBP check
/datum/preference/choiced/gender/proc/is_fbp(datum/preferences/preferences)
	if(!preferences?.organ_data)
		return FALSE
	return preferences.organ_data[BP_TORSO] == "cyborg"

/// Get the list of valid bio genders for the species
/datum/preference/choiced/gender/proc/get_valid_biological_genders(datum/preferences/preferences)
	var/datum/species/S
	if(preferences?.species)
		S = GLOB.all_species[preferences.species]
	if(!S)
		S = GLOB.all_species[SPECIES_HUMAN]
	var/list/possible_genders = S.genders
	if(!is_fbp(preferences))
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders

/datum/preference/choiced/gender/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/gender/apply_to_living(mob/living/target, value)
	return

/datum/preference/choiced/gender/apply_to_silicon(mob/living/silicon/target, value)
	return

/datum/preference/choiced/gender/apply_to_animal(mob/living/simple_mob/target, value)
	return

/datum/preference/choiced/gender/biological
	savefile_key = "gender"

/datum/preference/choiced/gender/biological/init_possible_values()
	// Actual validation happens in pref_deserialize
	return list(MALE, FEMALE, PLURAL, NEUTER)

/datum/preference/choiced/gender/biological/create_default_value()
	return MALE

/datum/preference/choiced/gender/biological/pref_deserialize(input, datum/preferences/preferences)
	var/list/valid_genders = get_valid_biological_genders(preferences)
	return sanitize_inlist(input, valid_genders, pick(valid_genders))

/datum/preference/choiced/gender/identifying
	savefile_key = "id_gender"

/datum/preference/choiced/gender/identifying/init_possible_values()
	return list(MALE, FEMALE, PLURAL, NEUTER, HERM)

/datum/preference/choiced/gender/identifying/create_default_value()
	return MALE

/datum/preference/choiced/gender/identifying/pref_deserialize(input, datum/preferences/preferences)
	if(input in all_genders_define_list)
		return input
	var/bio_gender = preferences?.read_preference(/datum/preference/choiced/gender/biological)
	if(bio_gender)
		return bio_gender
	return MALE
