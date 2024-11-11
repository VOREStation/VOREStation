/datum/preference/choiced/ui_style
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "UI_style"
	savefile_identifier = PREFERENCE_PLAYER
	should_generate_icons = TRUE

/datum/preference/choiced/ui_style/init_possible_values()
	return assoc_to_keys(all_ui_styles)

/datum/preference/choiced/ui_style/icon_for(value)
	var/icon/icon_file = all_ui_styles[value]

	var/icon/icon = icon(icon_file, "r_hand_inactive")
	icon.Crop(1, 1, ICON_SIZE_X * 2, ICON_SIZE_Y)
	icon.Blend(icon(icon_file, "l_hand_inactive"), ICON_OVERLAY, ICON_SIZE_X)

	return icon

/datum/preference/choiced/ui_style/create_default_value()
	return all_ui_styles[1]

/datum/preference/choiced/ui_style/apply_to_client_updated(client/client, value)
	client.mob?.update_ui_style(UI_style_new = value)

/datum/preference/numeric/ui_style_alpha
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "UI_style_alpha"
	savefile_identifier = PREFERENCE_PLAYER

	minimum = 50
	maximum = 255
	step = 1

/datum/preference/numeric/ui_style_alpha/create_default_value()
	return 255

/datum/preference/numeric/ui_style_alpha/apply_to_client_updated(client/client, value)
	client.mob?.update_ui_style(UI_style_alpha_new = value)

/datum/preference/color/ui_style_color
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "UI_style_color"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/color/ui_style_color/create_default_value()
	return COLOR_WHITE

/datum/preference/color/ui_style_color/apply_to_client_updated(client/client, value)
	client.mob?.update_ui_style(UI_style_color_new = value)
