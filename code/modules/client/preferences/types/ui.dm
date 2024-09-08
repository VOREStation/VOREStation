/datum/preference/toggle/browser_style
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "BROWSER_STYLED"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/vchat_enable
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "VCHAT_ENABLE"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/vchat_enable/apply_to_client(client/client, value)
	if(value)
		client.tgui_panel.oldchat = FALSE
	else
		client.tgui_panel.oldchat = TRUE

	client.nuke_chat()

/datum/preference/toggle/tgui_say
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "TGUI_SAY"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/tgui_say_light
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "TGUI_SAY_LIGHT_MODE"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/tgui_say_light/apply_to_client(client/client, value)
	client.tgui_say?.load()
