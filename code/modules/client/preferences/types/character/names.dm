// Name preferences for character creation
// Handles name related validation, including per species.

/// Abstract name preference type that provides species-aware sanitization
/datum/preference/name
	abstract_type = /datum/preference/name
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_NAMES
	var/maximum_value_length = MAX_NAME_LEN
	var/default_species = SPECIES_HUMAN

/// Check if the character is a Full Body Prosthetic (allows numbers in name)
/datum/preference/name/proc/is_fbp(datum/preferences/preferences)
	if(!preferences?.organ_data)
		return FALSE
	return preferences.organ_data[BP_TORSO] == "cyborg"

/datum/preference/name/is_valid(value)
	if(!istext(value))
		return FALSE
	if(length(value) > maximum_value_length)
		return FALSE
	return TRUE

/datum/preference/name/pref_deserialize(input, datum/preferences/preferences)
	if(!istext(input))
		return create_default_value()
	var/species = default_species
	if(preferences?.species)
		species = preferences.species
	var/allow_numbers = is_fbp(preferences)
	var/sanitized = sanitize_name(input, species, allow_numbers)
	if(!sanitized)
		return create_default_value()
	return sanitized

// Note: pref_serialize intentionally does NOT re-sanitize the value.
// The base proc doesn't pass preferences, so we can't check is_fbp().
// Sanitization happens on read via pref_deserialize which DOES have access to preferences.
/datum/preference/name/pref_serialize(input)
	if(!istext(input))
		return create_default_value()
	return input

/datum/preference/name/apply_to_human(mob/living/carbon/human/target, value)
	return // Handled in copy_to_mob

/datum/preference/name/apply_to_living(mob/living/target, value)
	return

/datum/preference/name/apply_to_silicon(mob/living/silicon/target, value)
	return

/datum/preference/name/apply_to_animal(mob/living/simple_mob, value)
	return

/// Character's real name
/datum/preference/name/real_name
	savefile_key = "real_name"

/datum/preference/name/real_name/create_default_value()
	return "Character"

/datum/preference/name/real_name/create_informed_default_value(datum/preferences/preferences)
	var/gender = preferences?.identifying_gender || MALE
	var/species = preferences?.species || SPECIES_HUMAN
	return random_name(gender, species)

/datum/preference/name/real_name/create_random_value(datum/preferences/preferences, datum/species/current_species)
	var/gender = preferences?.identifying_gender || MALE
	var/species_name = current_species?.name || SPECIES_HUMAN
	return random_name(gender, species_name)

/// Character's nickname (optional)
/datum/preference/name/nickname
	savefile_key = "nickname"

/datum/preference/name/nickname/is_valid(value)
	if(isnull(value) || value == "")
		return TRUE
	return ..()

/datum/preference/name/nickname/pref_deserialize(input, datum/preferences/preferences)
	if(isnull(input) || input == "")
		return null
	return ..()

/datum/preference/name/nickname/pref_serialize(value, datum/preferences/preferences)
	if(isnull(value) || value == "")
		return null
	return ..()

/datum/preference/name/nickname/create_default_value()
	return null
