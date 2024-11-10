/datum/preference/ignored_players
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ignored_players"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/ignored_players/is_valid(value)
	return TRUE

/datum/preference/ignored_players/pref_deserialize(input, datum/preferences/preferences)
	return SANITIZE_LIST(input)

/datum/preference/ignored_players/create_default_value()
	return list()

/datum/preference/ignored_players/is_accessible(datum/preferences/preferences)
	. = ..()
	return FALSE
