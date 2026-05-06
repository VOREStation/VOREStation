// Character background preferences
// Handles "Background Information" pref section

/datum/preference/text/human/home_system
	savefile_key = "home_system"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/human/home_system/create_default_value()
	return "Unset"

/datum/preference/text/human/home_system/pref_deserialize(input, datum/preferences/preferences)
	if(!input || !istext(input))
		return create_default_value()
	return STRIP_HTML_SIMPLE(input, maximum_value_length)

/datum/preference/text/human/home_system/apply_to_human(mob/living/carbon/human/target, value)
	target.home_system = value

/datum/preference/text/human/birthplace
	savefile_key = "birthplace"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/human/birthplace/create_default_value()
	return "Unset"

/datum/preference/text/human/birthplace/pref_deserialize(input, datum/preferences/preferences)
	if(!input || !istext(input))
		return create_default_value()
	return STRIP_HTML_SIMPLE(input, maximum_value_length)

/datum/preference/text/human/birthplace/apply_to_human(mob/living/carbon/human/target, value)
	target.birthplace = value

/datum/preference/text/human/citizenship
	savefile_key = "citizenship"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/human/citizenship/create_default_value()
	return "None"

/datum/preference/text/human/citizenship/pref_deserialize(input, datum/preferences/preferences)
	if(!input || !istext(input))
		return create_default_value()
	return STRIP_HTML_SIMPLE(input, maximum_value_length)

/datum/preference/text/human/citizenship/apply_to_human(mob/living/carbon/human/target, value)
	target.citizenship = value

/datum/preference/text/human/faction
	savefile_key = "faction"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/human/faction/create_default_value()
	return "None"

/datum/preference/text/human/faction/pref_deserialize(input, datum/preferences/preferences)
	if(!input || !istext(input))
		return create_default_value()
	return STRIP_HTML_SIMPLE(input, maximum_value_length)

/datum/preference/text/human/faction/apply_to_human(mob/living/carbon/human/target, value)
	target.personal_faction = value

/datum/preference/text/human/religion
	savefile_key = "religion"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	maximum_value_length = MAX_NAME_LEN

/datum/preference/text/human/religion/create_default_value()
	return "None"

/datum/preference/text/human/religion/pref_deserialize(input, datum/preferences/preferences)
	if(!input || !istext(input))
		return create_default_value()
	return STRIP_HTML_SIMPLE(input, maximum_value_length)

/datum/preference/text/human/religion/apply_to_human(mob/living/carbon/human/target, value)
	target.religion = value

// Economic Status

/datum/preference/choiced/human/economic_status
	savefile_key = "economic_status"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE

/datum/preference/choiced/human/economic_status/init_possible_values()
	return ECONOMIC_CLASS

/datum/preference/choiced/human/economic_status/create_default_value()
	return "Average"

/datum/preference/choiced/human/economic_status/apply_to_human(mob/living/carbon/human/target, value)
	return // Economic status is read directly from prefs when needed, not stored on the mob.

// Bay UI Bridge

/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5

/datum/category_item/player_setup_item/general/background/load_character(list/save_data)
	return

/datum/category_item/player_setup_item/general/background/save_character(list/save_data)
	return

/datum/category_item/player_setup_item/general/background/sanitize_character()
	return

/datum/category_item/player_setup_item/general/background/copy_to_mob(mob/living/carbon/human/character)
	return

/datum/category_item/player_setup_item/general/background/tgui_data(mob/user)
	var/list/data = ..()

	data["economic_status"] = pref.read_preference(/datum/preference/choiced/human/economic_status)
	data["home_system"] = pref.read_preference(/datum/preference/text/human/home_system)
	data["birthplace"] = pref.read_preference(/datum/preference/text/human/birthplace)
	data["citizenship"] = pref.read_preference(/datum/preference/text/human/citizenship)
	data["faction"] = pref.read_preference(/datum/preference/text/human/faction)
	data["religion"] = pref.read_preference(/datum/preference/text/human/religion)
	data["ooc_note_style"] = pref.read_preference(/datum/preference/toggle/living/ooc_notes_style)

	return data

/datum/category_item/player_setup_item/general/background/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("econ_status")
			var/new_class = tgui_input_list(user, "Choose your economic status. This will affect the amount of money you will start with.", "Character Preference", ECONOMIC_CLASS, pref.read_preference(/datum/preference/choiced/human/economic_status))
			if(new_class)
				pref.write_preference_by_type(/datum/preference/choiced/human/economic_status, new_class)
				return TOPIC_REFRESH

		if("home_system")
			var/choice = tgui_input_list(user, "Please choose your home planet and/or system. This should be your current primary residence. Select \"Other\" to specify manually.", "Character Preference", GLOB.home_system_choices + list("Unset","Other"), pref.read_preference(/datum/preference/text/human/home_system))
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a home system.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.write_preference_by_type(/datum/preference/text/human/home_system, raw_choice)
			else
				pref.write_preference_by_type(/datum/preference/text/human/home_system, choice)
			return TOPIC_REFRESH

		if("birthplace")
			var/choice = tgui_input_list(user, "Please choose the planet and/or system or other appropriate location that you were born/created. Select \"Other\" to specify manually.", "Character Preference", GLOB.home_system_choices + list("Unset","Other"), pref.read_preference(/datum/preference/text/human/birthplace))
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a birthplace.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.write_preference_by_type(/datum/preference/text/human/birthplace, raw_choice)
			else
				pref.write_preference_by_type(/datum/preference/text/human/birthplace, choice)
			return TOPIC_REFRESH

		if("citizenship")
			var/choice = tgui_input_list(user, "Please select the faction or political entity with which you currently hold citizenship. Select \"Other\" to specify manually.", "Character Preference", GLOB.citizenship_choices + list("None","Other"), pref.read_preference(/datum/preference/text/human/citizenship))
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter your current citizenship.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.write_preference_by_type(/datum/preference/text/human/citizenship, raw_choice)
			else
				pref.write_preference_by_type(/datum/preference/text/human/citizenship, choice)
			return TOPIC_REFRESH

		if("faction")
			var/choice = tgui_input_list(user, "Please choose the faction you primarily work for, if you are not under the direct employ of NanoTrasen. Select \"Other\" to specify manually.", "Character Preference", GLOB.faction_choices + list("None","Other"), pref.read_preference(/datum/preference/text/human/faction))
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a faction.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.write_preference_by_type(/datum/preference/text/human/faction, raw_choice)
			else
				pref.write_preference_by_type(/datum/preference/text/human/faction, choice)
			return TOPIC_REFRESH

		if("religion")
			var/choice = tgui_input_list(user, "Please choose a religion. Select \"Other\" to specify manually.", "Character Preference", GLOB.religion_choices + list("None","Other"), pref.read_preference(/datum/preference/text/human/religion))
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a religon.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.write_preference_by_type(/datum/preference/text/human/religion, sanitize(raw_choice))
			else
				pref.write_preference_by_type(/datum/preference/text/human/religion, choice)
			return TOPIC_REFRESH
