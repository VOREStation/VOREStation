/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 3

	var/datum/paiCandidate/candidate

/datum/category_item/player_setup_item/player_global/pai/load_preferences(datum/json_savefile/savefile)
	if(!candidate)
		candidate = new()
	var/preference_mob = preference_mob()
	if(!preference_mob)// No preference mob - this happens when we're called from client/New() before it calls ..()  (via datum/preferences/New())
		spawn()
			preference_mob = preference_mob()
			if(!preference_mob)
				return
			candidate.savefile_load(preference_mob)
		return

	candidate.savefile_load(preference_mob)

/datum/category_item/player_setup_item/player_global/pai/save_preferences(datum/json_savefile/savefile)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/content(var/mob/user)
	. += span_bold("pAI:") + "<br>"
	if(!candidate)
		log_debug("[user] pAI prefs have a null candidate var.")
		return .
	. += "Name: <a href='byond://?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>"
	. += "Description: <a href='byond://?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>"
	. += "Role: <a href='byond://?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>"
	. += "OOC Comments: <a href='byond://?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>"

/datum/category_item/player_setup_item/player_global/pai/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["option"])
		var/t
		switch(href_list["option"])
			if("name")
				t = sanitizeName(tgui_input_text(user, "Enter a name for your pAI", "Global Preference", candidate.name, MAX_NAME_LEN), MAX_NAME_LEN, 1)
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				t = tgui_input_text(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description), multiline = TRUE, prevent_enter = TRUE)
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				t = tgui_input_text(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role))
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				t = tgui_input_text(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments), multiline = TRUE, prevent_enter = TRUE)
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)
		return TOPIC_REFRESH

	return ..()
