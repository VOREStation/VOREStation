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

/datum/preference/toggle/tgui_fancy
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_fancy"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/tgui_lock
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_lock"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/tgui_input_mode
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_input_mode"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/tgui_large_buttons
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_large_buttons"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/tgui_swapped_buttons
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_swapped_buttons"
	default_value = FALSE
	savefile_identifier = PREFERENCE_PLAYER

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
	maximum = 20
	step = 1

/datum/preference/numeric/tgui_say_height/create_default_value()
	return 1

/datum/preference/numeric/tgui_say_height/apply_to_client(client/client, value)
	client.tgui_say?.load()


/datum/preference/numeric/tgui_say_width
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tgui_say_width"
	savefile_identifier = PREFERENCE_PLAYER

	minimum = 360
	maximum = 800
	step = 20

/datum/preference/numeric/tgui_say_width/create_default_value()
	return 360

/datum/preference/numeric/tgui_say_width/apply_to_client(client/client, value)
	client.tgui_say?.load()

/datum/preference/text/preset_colors
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_PLAYER
	savefile_key = "preset_colors"
	maximum_value_length = 160

/datum/preference/text/preset_colors/apply_to_client(client/client, value)
	return
