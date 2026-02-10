/datum/category_item/player_setup_item/general/basic_antagonism
	name = "Basic"
	sort_order = 7

/datum/category_item/player_setup_item/general/basic_antagonism/load_character(list/save_data)
	pref.exploit_record = save_data["exploit_record"]
	pref.antag_faction  = save_data["antag_faction"]
	pref.antag_vis      = save_data["antag_vis"]

/datum/category_item/player_setup_item/general/basic_antagonism/save_character(list/save_data)
	save_data["exploit_record"] = pref.exploit_record
	save_data["antag_faction"]  = pref.antag_faction
	save_data["antag_vis"]      = pref.antag_vis

/datum/category_item/player_setup_item/general/basic_antagonism/load_preferences(datum/json_savefile/savefile)
	var/preference_mob = preference_mob()
	if(!preference_mob)// No preference mob - this happens when we're called from client/New() before it calls ..()  (via datum/preferences/New())
		spawn()
			preference_mob = preference_mob()
			if(!preference_mob)
				return
		return

/datum/category_item/player_setup_item/general/basic_antagonism/save_preferences(datum/json_savefile/savefile)
	if(!preference_mob())
		return

/datum/category_item/player_setup_item/general/basic_antagonism/sanitize_character()
	if(!pref.antag_faction) pref.antag_faction = "None"
	if(!pref.antag_vis) pref.antag_vis = "Hidden"

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/basic_antagonism/copy_to_mob(var/mob/living/carbon/human/character)
	character.exploit_record = pref.exploit_record
	character.antag_faction = pref.antag_faction
	character.antag_vis = pref.antag_vis

/datum/category_item/player_setup_item/general/basic_antagonism/tgui_data(mob/user)
	var/list/data = ..()

	data["antag_faction"] = pref.antag_faction
	data["antag_vis"] = pref.antag_vis
	data["uplink_type"] = pref.read_preference(/datum/preference/choiced/uplinklocation)
	data["record_banned"] = jobban_isbanned(user, "Records")
	if(!jobban_isbanned(user, "Records"))
		data["exploitable_record"] = TextPreview(pref.exploit_record, 40)

	data["pai_name"] = pref.read_preference(/datum/preference/text/pai_name)
	data["pai_desc"] = pref.read_preference(/datum/preference/text/pai_description)
	data["pai_role"] = pref.read_preference(/datum/preference/text/pai_role)
	data["pai_comments"] = pref.read_preference(/datum/preference/text/pai_comments)
	data["pai_eyecolor"] = pref.read_preference(/datum/preference/color/pai_eye_color)
	data["pai_chassis"] = pref.read_preference(/datum/preference/text/pai_chassis)
	data["pai_emotion"] = pref.read_preference(/datum/preference/text/pai_emotion)

	return data

/datum/category_item/player_setup_item/general/basic_antagonism/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("uplinklocation")
			var/new_uplinklocation = tgui_input_list(user, "Choose your uplink location:", "Character Preference", GLOB.uplink_locations, pref.read_preference(/datum/preference/choiced/uplinklocation))
			if(new_uplinklocation && CanUseTopic(user))
				pref.update_preference_by_type(/datum/preference/choiced/uplinklocation, new_uplinklocation)
			return TOPIC_REFRESH

		if("exploitable_record")
			var/exploitmsg = tgui_input_text(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE)
			if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
				pref.exploit_record = exploitmsg
				return TOPIC_REFRESH

		if("antagfaction")
			var/choice = tgui_input_list(user, "Please choose an antagonistic faction to work for.", "Character Preference", GLOB.antag_faction_choices + list("None","Other"), pref.antag_faction)
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = tgui_input_text(user, "Please enter a faction.", "Character Preference", null, MAX_NAME_LEN)
				if(raw_choice)
					pref.antag_faction = raw_choice
			else
				pref.antag_faction = choice
			return TOPIC_REFRESH

		if("antagvis")
			var/choice = tgui_input_list(user, "Please choose an antagonistic visibility level.", "Character Preference", GLOB.antag_visiblity_choices, pref.antag_vis)
			if(!choice || !CanUseTopic(user))
				return TOPIC_NOACTION
			else
				pref.antag_vis = choice
			return TOPIC_REFRESH

		if("pai_option")
			var/t
			switch(params["pai_option"])
				if("name")
					t = sanitizeName(tgui_input_text(user, "What you plan to call yourself. Suggestions: Any character name you would choose for a station character OR an AI.", "pAI Name", pref.read_preference(/datum/preference/text/pai_name), MAX_NAME_LEN), MAX_NAME_LEN, 1)
					if(t && CanUseTopic(user))
						pref.update_preference_by_type(/datum/preference/text/pai_name, t)
				if("desc")
					t = tgui_input_text(user, "What sort of pAI you typically play; your mannerisms, your quirks, etc. This can be as sparse or as detailed as you like.", "pAI Description", pref.read_preference(/datum/preference/text/pai_description), multiline = TRUE, prevent_enter = TRUE)
					if(!isnull(t) && CanUseTopic(user))
						pref.update_preference_by_type(/datum/preference/text/pai_description, sanitize(t))
				if("ad")
					t = tgui_input_text(user, "Enter an advertisement for your pAI", "pAI Preference", pref.read_preference(/datum/preference/text/pai_ad))
					if(!isnull(t) && CanUseTopic(user))
						pref.update_preference_by_type(/datum/preference/text/pai_ad, sanitize(t))
				if("role")
					t = tgui_input_text(user, "Do you like to partner with sneaky social ninjas? Like to help security hunt down thugs? Enjoy watching an engineer's back while he saves the station yet again? This doesn't have to be limited to just station jobs. Pretty much any general descriptor for what you'd like to be doing works here.", "Preferred Role", pref.read_preference(/datum/preference/text/pai_role))
					if(!isnull(t) && CanUseTopic(user))
						pref.update_preference_by_type(/datum/preference/text/pai_role, sanitize(t))
				if("ooc")
					t = tgui_input_text(user, "Anything you'd like to address specifically to the player reading this in an OOC manner. \"I prefer more serious RP.\", \"I'm still learning the interface!\", etc. Feel free to leave this blank if you want.", "OOC Comments", pref.read_preference(/datum/preference/text/pai_comments), multiline = TRUE, prevent_enter = TRUE)
					if(!isnull(t) && CanUseTopic(user))
						pref.update_preference_by_type(/datum/preference/text/pai_comments, sanitize(t))
				if("color")
					var/new_color = tgui_color_picker(user, "Choose your pAI's default glow colour.", "pAI Glow Color", pref.read_preference(/datum/preference/color/pai_eye_color))
					if(new_color && CanUseTopic(user))
						pref.update_preference_by_type(/datum/preference/color/pai_eye_color, new_color)
				if("chassis")
					var/new_chassis = tgui_input_list(user, "Choose your pAI's default chassis.", "pAI Chassis", SSpai.pai_chassis_sprites, SSpai.pai_chassis_sprites[1])
					if(new_chassis && CanUseTopic(user) && (new_chassis in SSpai.pai_chassis_sprites))
						pref.update_preference_by_type(/datum/preference/text/pai_chassis, new_chassis)
				if("emotion")
					var/new_emotion = tgui_input_list(user, "Choose your pAI's default emotion.", "pAI Emotion", GLOB.pai_emotions, GLOB.pai_emotions[1])
					if(new_emotion && CanUseTopic(user) && (new_emotion in GLOB.pai_emotions))
						pref.update_preference_by_type(/datum/preference/text/pai_emotion, new_emotion)
			return TOPIC_REFRESH
