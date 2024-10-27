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
	var/before = client.tgui_panel.oldchat
	if(value)
		client.tgui_panel.oldchat = FALSE
	else
		client.tgui_panel.oldchat = TRUE

	// If something actually changed, reload chat
	if(before != client.tgui_panel.oldchat)
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

/datum/preference/toggle/tgui_say_emotes
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_say_emotes"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/tgui_say_emotes/apply_to_client(client/client, value)
	client.tgui_say?.load()

/datum/preference/numeric/tgui_say_height
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_say_height"
	savefile_identifier = PREFERENCE_PLAYER

	minimum = 1
	maximum = 5
	step = 1

/datum/preference/numeric/tgui_say_height/create_default_value()
	return 1

/datum/preference/numeric/tgui_say_height/apply_to_client(client/client, value)
	client.tgui_say?.load()
