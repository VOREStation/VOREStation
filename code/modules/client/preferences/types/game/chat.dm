/datum/preference/toggle/chat_tags
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_SHOWICONS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_typing_indicator
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SHOW_TYPING"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_typing_indicator/apply_to_client(client/client, value)
	if(!value)
		client.stop_thinking()

/datum/preference/toggle/show_typing_indicator_subtle
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "SHOW_TYPING_SUBTLE"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_ooc
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_OOC"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_looc
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_LOOC"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_dsay
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_DEAD"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/check_mention
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "CHAT_MENTION"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/vore_health_bars
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "VORE_HEALTH_BARS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/show_lore_news
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "NEWS_POPUP"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/player_tips
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "RECEIVE_TIPS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/pain_frequency
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "PAIN_FREQUENCY"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER
