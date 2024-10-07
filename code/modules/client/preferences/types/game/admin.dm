/datum/preference/toggle/show_attack_logs
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_ATTACKLOGS"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_attack_logs/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return

	return check_rights(R_MOD|R_ADMIN, FALSE, preferences.client)

/datum/preference/toggle/show_debug_logs
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_DEBUGLOGS"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_debug_logs/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return

	return check_rights(R_DEBUG|R_ADMIN, FALSE, preferences.client)

/datum/preference/toggle/show_chat_prayers
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_PRAYER"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_chat_prayers/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return

	return check_rights(R_EVENT|R_ADMIN, FALSE, preferences.client)

// General holder prefs
/datum/preference/toggle/holder
	abstract_type = /datum/preference/toggle/holder

/datum/preference/toggle/holder/is_accessible(datum/preferences/preferences)
	. = ..(preferences)
	if(!.)
		return

	return preferences.client.holder

/datum/preference/toggle/holder/play_adminhelp_ping
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SOUND_ADMINHELP"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/holder/hear_radio
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_RADIO"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/holder/show_rlooc
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_RLOOC"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/holder/show_staff_dsay
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_ADSAY"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER
