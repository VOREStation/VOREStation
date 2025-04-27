/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5
/datum/category_item/player_setup_item/general/background/load_character(list/save_data)
	pref.med_record			= save_data["med_record"]
	pref.sec_record			= save_data["sec_record"]
	pref.gen_record			= save_data["gen_record"]
	pref.home_system		= save_data["home_system"]
	pref.birthplace			= save_data["birthplace"]
	pref.citizenship		= save_data["citizenship"]
	pref.faction			= save_data["faction"]
	pref.religion			= save_data["religion"]
	pref.economic_status	= save_data["economic_status"]

/datum/category_item/player_setup_item/general/background/save_character(list/save_data)
	save_data["med_record"]			= pref.med_record
	save_data["sec_record"]			= pref.sec_record
	save_data["gen_record"]			= pref.gen_record
	save_data["home_system"]		= pref.home_system
	save_data["birthplace"]			= pref.birthplace
	save_data["citizenship"]		= pref.citizenship
	save_data["faction"]			= pref.faction
	save_data["religion"]			= pref.religion
	save_data["economic_status"]	= pref.economic_status

/datum/category_item/player_setup_item/general/background/sanitize_character()
	if(!pref.home_system) pref.home_system = "Unset"
	if(!pref.birthplace)  pref.birthplace =  "Unset"
	if(!pref.citizenship) pref.citizenship = "None"
	if(!pref.faction)     pref.faction =     "None"
	if(!pref.religion)    pref.religion =    "None"

	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_CLASS, initial(pref.economic_status))

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/background/copy_to_mob(var/mob/living/carbon/human/character)
	character.med_record		= pref.med_record
	character.sec_record		= pref.sec_record
	character.gen_record		= pref.gen_record
	character.home_system		= pref.home_system
	character.birthplace		= pref.birthplace
	character.citizenship		= pref.citizenship
	character.personal_faction	= pref.faction
	character.religion			= pref.religion

/datum/category_item/player_setup_item/general/background/tgui_data(mob/user)
	var/list/data = ..()

	data["economic_status"] = pref.economic_status
	data["home_system"] = pref.home_system
	data["birthplace"] = pref.birthplace
	data["citizenship"] = pref.citizenship
	data["faction"] = pref.faction
	data["religion"] = pref.religion
	data["ooc_note_style"] = pref.read_preference(/datum/preference/toggle/living/ooc_notes_style)

	if(jobban_isbanned(user, "Records"))
		data["records_banned"] = TRUE
	else
		data["records_banned"] = FALSE

		data["med_record"] = TextPreview(pref.med_record,40)
		data["gen_record"] = TextPreview(pref.gen_record,40)
		data["sec_record"] = TextPreview(pref.sec_record,40)

	return data

/datum/category_item/player_setup_item/general/background/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("econ_status")
			var/new_class = tgui_input_list(user, "Choose your economic status. This will affect the amount of money you will start with.", "Character Preference", ECONOMIC_CLASS, pref.economic_status)
			if(new_class)
				pref.economic_status = new_class
				return TOPIC_REFRESH

		if("home_system")
			var/choice = tgui_input_list(user, "Please choose your home planet and/or system. This should be your current primary residence. Select \"Other\" to specify manually.", "Character Preference", home_system_choices + list("Unset","Other"), pref.home_system)
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a home system.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.home_system = raw_choice
			else
				pref.home_system = choice
			return TOPIC_REFRESH

		if("birthplace")
			var/choice = tgui_input_list(user, "Please choose the planet and/or system or other appropriate location that you were born/created. Select \"Other\" to specify manually.", "Character Preference", home_system_choices + list("Unset","Other"), pref.birthplace)
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a birthplace.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.birthplace = raw_choice
			else
				pref.birthplace = choice
			return TOPIC_REFRESH

		if("citizenship")
			var/choice = tgui_input_list(user, "Please select the faction or political entity with which you currently hold citizenship. Select \"Other\" to specify manually.", "Character Preference", citizenship_choices + list("None","Other"), pref.citizenship)
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter your current citizenship.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.citizenship = raw_choice
			else
				pref.citizenship = choice
			return TOPIC_REFRESH

		if("faction")
			var/choice = tgui_input_list(user, "Please choose the faction you primarily work for, if you are not under the direct employ of NanoTrasen. Select \"Other\" to specify manually.", "Character Preference", faction_choices + list("None","Other"), pref.faction)
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a faction.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.faction = raw_choice
			else
				pref.faction = choice
			return TOPIC_REFRESH

		if("religion")
			var/choice = tgui_input_list(user, "Please choose a religion. Select \"Other\" to specify manually.", "Character Preference", religion_choices + list("None","Other"), pref.religion)
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a religon.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
				if(raw_choice)
					pref.religion = sanitize(raw_choice)
			else
				pref.religion = choice
			return TOPIC_REFRESH

		if("set_medical_records")
			var/new_medical = strip_html_simple(tgui_input_text(user,"Enter medical information here.","Character Preference", html_decode(pref.med_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
			if(new_medical && !jobban_isbanned(user, JOB_RECORDS))
				pref.med_record = new_medical
			return TOPIC_REFRESH

		if("set_general_records")
			var/new_general = strip_html_simple(tgui_input_text(user,"Enter employment information here.","Character Preference", html_decode(pref.gen_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
			if(new_general && !jobban_isbanned(user, JOB_RECORDS))
				pref.gen_record = new_general
			return TOPIC_REFRESH

		if("set_security_records")
			var/sec_medical = strip_html_simple(tgui_input_text(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
			if(sec_medical && !jobban_isbanned(user, JOB_RECORDS))
				pref.sec_record = sec_medical
			return TOPIC_REFRESH

		if("reset_medrecord")
			var/resetmed_choice = tgui_alert(user, "Wipe your Medical Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No"))
			if(resetmed_choice == "Yes")
				pref.med_record = null
			return TOPIC_REFRESH

		if("reset_emprecord")
			var/resetemp_choice = tgui_alert(user, "Wipe your Employment Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No"))
			if(resetemp_choice == "Yes")
				pref.gen_record = null
			return TOPIC_REFRESH

		if("reset_secrecord")
			var/resetsec_choice = tgui_alert(user, "Wipe your Security Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No"))
			if(resetsec_choice == "Yes")
				pref.sec_record = null
			return TOPIC_REFRESH
