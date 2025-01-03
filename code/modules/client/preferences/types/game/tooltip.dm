/datum/preference/toggle/mob_tooltips
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "MOB_TOOLTIPS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/inv_tooltips
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "INV_TOOLTIPS"
	default_value = TRUE
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/tooltip_style
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "tooltipstyle"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/choiced/tooltip_style/init_possible_values()
	return all_tooltip_styles

/datum/preference/choiced/tooltip_style/create_default_value()
	return all_tooltip_styles[1]
