/datum/preference/text/pai_name
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_Name"
	maximum_value_length = MAX_NAME_LEN
	can_randomize = FALSE

/datum/preference/text/pai_name/create_default_value()
	return "None Set"

/datum/preference/text/pai_name/apply_pref_to(mob/living, value)
	return


/datum/preference/text/pai_description
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_Desc"
	maximum_value_length = MAX_MESSAGE_LEN * 4
	can_randomize = FALSE

/datum/preference/text/pai_description/create_default_value()
	return "None Set"

/datum/preference/text/pai_description/apply_pref_to(mob/living, value)
	return


/datum/preference/text/pai_role
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_Role"
	maximum_value_length = MAX_MESSAGE_LEN * 4
	can_randomize = FALSE

/datum/preference/text/pai_role/create_default_value()
	return "None Set"

/datum/preference/text/pai_role/apply_pref_to(mob/living, value)
	return


/datum/preference/text/pai_ad
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_Ad"
	maximum_value_length = MAX_MESSAGE_LEN * 4
	can_randomize = FALSE

/datum/preference/text/pai_ad/create_default_value()
	return "None Set"

/datum/preference/text/pai_ad/apply_pref_to(mob/living, value)
	return


/datum/preference/text/pai_comments
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_Comments"
	maximum_value_length = MAX_MESSAGE_LEN * 4
	can_randomize = FALSE

/datum/preference/text/pai_comments/create_default_value()
	return "None Set"

/datum/preference/text/pai_comments/apply_pref_to(mob/living, value)
	return


/datum/preference/color/pai_eye_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_EyeColor"
	can_randomize = TRUE

/datum/preference/color/pai_eye_color/apply_pref_to(mob/living, value)
	return


/datum/preference/text/pai_chassis
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_Chassis"
	maximum_value_length = MAX_NAME_LEN
	can_randomize = FALSE

/datum/preference/text/pai_chassis/create_default_value()
	return GLOB.possible_chassis[1]

/datum/preference/text/pai_chassis/is_valid(value)
	if(!(value in GLOB.possible_chassis))
		return FALSE
	. = ..()

/datum/preference/text/pai_chassis/apply_pref_to(mob/living, value)
	return


/datum/preference/text/pai_emotion
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "Pai_Emotion"
	maximum_value_length = MAX_NAME_LEN
	can_randomize = FALSE

/datum/preference/text/pai_emotion/create_default_value()
	return GLOB.pai_emotions[1]

/datum/preference/text/pai_emotion/is_valid(value)
	if(!(value in GLOB.pai_emotions))
		return FALSE
	. = ..()

/datum/preference/text/pai_emotion/apply_pref_to(mob/living, value)
	return
