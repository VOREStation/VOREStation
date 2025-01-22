/datum/preferences
	var/extra_languages = 0
	var/preferred_language = "common" // VOREStation Edit: Allow selecting a preferred language
	var/runechat_color = COLOR_BLACK

/datum/category_item/player_setup_item/general/language
	name = "Language"
	sort_order = 2
	var/static/list/forbidden_prefixes = list(";", ":", ".", "!", "*", "^", "-")

/datum/category_item/player_setup_item/general/language/load_character(list/save_data)
	pref.alternate_languages	= check_list_copy(save_data["language"])
	pref.extra_languages		= save_data["extra_languages"]
	pref.language_prefixes		= save_data["language_prefixes"]
	pref.species				= save_data["species"]
	pref.preferred_language		= save_data["preflang"]
	pref.language_custom_keys	= check_list_copy(save_data["language_custom_keys"])
	pref.runechat_color			= save_data["runechat_color"]

/datum/category_item/player_setup_item/general/language/save_character(list/save_data)
	save_data["language"]				= check_list_copy(pref.alternate_languages)
	save_data["extra_languages"]		= pref.extra_languages
	save_data["language_prefixes"]		= pref.language_prefixes
	save_data["language_custom_keys"]	= pref.language_custom_keys
	save_data["preflang"]				= check_list_copy(pref.preferred_language)
	save_data["runechat_color"]			= pref.runechat_color

/datum/category_item/player_setup_item/general/language/sanitize_character()
	if(!islist(pref.alternate_languages))
		testing("LANGSANI: Sanitizing languages on [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because their character has no languages list")
		pref.alternate_languages = list()
	if(pref.species)
		var/datum/species/S = GLOB.all_species[pref.species]
		if(!istype(S))
			testing("LANGSANI: Failed sani on [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because their species ([pref.species]) isn't in the global list")
			return

		if(pref.alternate_languages.len > (S.num_alternate_languages + pref.extra_languages))
			testing("LANGSANI: Truncated [pref.client]'s character [pref.real_name || "-name not yet loaded-"] language list because it was too long (len: [pref.alternate_languages.len], allowed: [S.num_alternate_languages])")
			pref.alternate_languages.len = (S.num_alternate_languages + pref.extra_languages) // Truncate to allowed length

		// VOREStation Edit Start
		if((!(pref.preferred_language in pref.alternate_languages) && !(pref.preferred_language == LANGUAGE_GALCOM) && !(pref.preferred_language == S.language)) || !pref.preferred_language) // Safety handling for if our preferred language is ever somehow removed from the character's list of langauges, or they don't have one set
			pref.preferred_language = S.language // Reset to default, for safety
		// VOREStation Edit end

		// Sanitize illegal languages
		for(var/language in pref.alternate_languages)
			var/datum/language/L = GLOB.all_languages[language]
			if(!istype(L) || (L.flags & RESTRICTED) || (!(language in S.secondary_langs) && pref.client && !is_lang_whitelisted(pref.client, L)))
				testing("LANGSANI: Removed [L?.name || "lang not found"] from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because it failed allowed checks")
				pref.alternate_languages -= language

	if(isnull(pref.language_prefixes) || !pref.language_prefixes.len)
		var/list/prefixes = CONFIG_GET(str_list/language_prefixes)
		pref.language_prefixes = prefixes.Copy()
	for(var/prefix in pref.language_prefixes)
		if(prefix in forbidden_prefixes)
			pref.language_prefixes -= prefix
	if(isnull(pref.language_custom_keys))
		pref.language_custom_keys = list()
	var/datum/species/S = GLOB.all_species[pref.species]
	for(var/key in pref.language_custom_keys)
		if(!pref.language_custom_keys[key])
			pref.language_custom_keys.Remove(key)
		if(!((pref.language_custom_keys[key] == S.language) || (pref.language_custom_keys[key] == S.default_language && S.default_language != S.language) || (pref.language_custom_keys[key] in pref.alternate_languages)))
			pref.language_custom_keys.Remove(key)

	pref.runechat_color = sanitize_hexcolor(pref.runechat_color, COLOR_BLACK)

/datum/category_item/player_setup_item/general/language/content()
	. += span_bold("Languages") + "<br>"
	var/datum/species/S = GLOB.all_species[pref.species]
	if(pref.alternate_languages.len > (S.num_alternate_languages + pref.extra_languages))
		testing("LANGSANI: Truncated [pref.client]'s character [pref.real_name || "-name not yet loaded-"] language list because it was too long (len: [pref.alternate_languages.len], allowed: [S.num_alternate_languages])")
		pref.alternate_languages.len = (S.num_alternate_languages + pref.extra_languages) // Truncate to allowed length
	if(S.language)
		. += "- [S.language] - <a href='byond://?src=\ref[src];set_custom_key=[S.language]'>Set Custom Key</a><br>"
	if(S.default_language && S.default_language != S.language)
		. += "- [S.default_language] - <a href='byond://?src=\ref[src];set_custom_key=[S.default_language]'>Set Custom Key</a><br>"
	if(S.num_alternate_languages + pref.extra_languages)
		if(pref.alternate_languages.len)
			for(var/i = 1 to pref.alternate_languages.len)
				var/lang = pref.alternate_languages[i]
				. += "- [lang] - <a href='byond://?src=\ref[src];remove_language=[i]'>remove</a> - <a href='byond://?src=\ref[src];set_custom_key=[lang]'>Set Custom Key</a><br>"

		if(pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
			. += "- <a href='byond://?src=\ref[src];add_language=1'>add</a> ([(S.num_alternate_languages + pref.extra_languages) - pref.alternate_languages.len] remaining)<br>"
	else
		. += "- [pref.species] cannot choose secondary languages.<br>"

	. += span_bold("Language Keys") + "<br>"
	. += " [jointext(pref.language_prefixes, " ")] <a href='byond://?src=\ref[src];change_prefix=1'>Change</a> <a href='byond://?src=\ref[src];reset_prefix=1'>Reset</a><br>"
	. += span_bold("Preferred Language") + " <a href='byond://?src=\ref[src];pref_lang=1'>[pref.preferred_language]</a><br>" // VOREStation Add
	. += span_bold("Runechat Color") + " <a href='byond://?src=\ref[src];pref_runechat_color=1'>Change Runechat Color</a> [color_square(hex = pref.runechat_color)]"

/datum/category_item/player_setup_item/general/language/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		pref.alternate_languages.Cut(index, index+1)
		return TOPIC_REFRESH
	else if(href_list["add_language"])
		var/datum/species/S = GLOB.all_species[pref.species]
		if(pref.alternate_languages.len >= (S.num_alternate_languages + pref.extra_languages))
			tgui_alert_async(user, "You have already selected the maximum number of alternate languages for this species!")
		else
			var/list/available_languages = S.secondary_langs.Copy()
			for(var/L in GLOB.all_languages)
				var/datum/language/lang = GLOB.all_languages[L]
				if(!(lang.flags & RESTRICTED) && (is_lang_whitelisted(user, lang)))
					available_languages |= L

			// make sure we don't let them waste slots on the default languages
			available_languages -= S.language
			available_languages -= S.default_language
			available_languages -= pref.alternate_languages

			if(!available_languages.len)
				tgui_alert_async(user, "There are no additional languages available to select.")
			else
				var/new_lang = tgui_input_list(user, "Select an additional language", "Character Generation", available_languages)
				if(new_lang && pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
					var/datum/language/chosen_lang = GLOB.all_languages[new_lang]
					if(istype(chosen_lang))
						var/choice = tgui_alert(usr, "[chosen_lang.desc]",chosen_lang.name, list("Take","Cancel"))
						if(choice != "Cancel" && pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
							pref.alternate_languages |= new_lang
					return TOPIC_REFRESH

	else if(href_list["change_prefix"])
		var/char
		var/keys[0]
		do
			char = tgui_input_text(usr, "Enter a single special character.\nYou may re-select the same characters.\nThe following characters are already in use by radio: ; : .\nThe following characters are already in use by special say commands: ! * ^", "Enter Character - [3 - keys.len] remaining")
			if(char)
				if(length(char) > 1)
					tgui_alert_async(user, "Only single characters allowed.", "Error")
				else if(char in list(";", ":", "."))
					tgui_alert_async(user, "Radio character. Rejected.", "Error")
				else if(char in list("!","*","^","-"))
					tgui_alert_async(user, "Say character. Rejected.", "Error")
				else if(contains_az09(char))
					tgui_alert_async(user, "Non-special character. Rejected.", "Error")
				else
					keys.Add(char)
		while(char && keys.len < 3)

		if(keys.len == 3)
			pref.language_prefixes = keys
			return TOPIC_REFRESH
	else if(href_list["reset_prefix"])
		var/list/prefixes = CONFIG_GET(str_list/language_prefixes)
		pref.language_prefixes = prefixes.Copy()
		return TOPIC_REFRESH

	else if(href_list["set_custom_key"])
		var/lang = href_list["set_custom_key"]
		if(!(lang in GLOB.all_languages))
			return TOPIC_REFRESH

		var/oldkey = ""
		for(var/key in pref.language_custom_keys)
			if(pref.language_custom_keys[key] == lang)
				oldkey = key
				break

		var/char = tgui_input_text(user, "Input a language key for [lang]. Input a single space to reset.", "Language Custom Key", oldkey)
		if(length(char) != 1)
			return TOPIC_REFRESH
		else if(char == " ")
			for(var/key in pref.language_custom_keys)
				if(pref.language_custom_keys[key] == lang)
					pref.language_custom_keys -= key
					break
		else if(contains_az09(char))
			if(!(char in pref.language_custom_keys))
				pref.language_custom_keys += char
			pref.language_custom_keys[char] = lang
		else
			tgui_alert_async(user, "Improper language key. Rejected.", "Error")

		return TOPIC_REFRESH

	// VOREStation Add: Preferred Language
	else if(href_list["pref_lang"])
		if(pref.species) // Safety to prevent a null runtime here
			var/datum/species/S = GLOB.all_species[pref.species]
			var/list/lang_opts = list(S.language) + pref.alternate_languages + LANGUAGE_GALCOM
			var/selection = tgui_input_list(user, "Choose your preferred spoken language:", "Preferred Spoken Language", lang_opts, pref.preferred_language)
			if(!selection) // Set our preferred to default, just in case.
				tgui_alert_async(user, "Preferred Language not modified.", "Selection Canceled")
			if(selection)
				pref.preferred_language = selection
				if(selection == "common" || selection == S.language)
					tgui_alert_async(user, "You will now speak your standard default language, [S.language ? S.language : "common"], if you do not specify a language when speaking.", "Preferred Set to Default")
				else // Did they set anything else?
					tgui_alert_async(user, "You will now speak [pref.preferred_language] if you do not specify a language when speaking.", "Preferred Language Set")
			return TOPIC_REFRESH
	// VOREStation Add End

	else if(href_list["pref_runechat_color"])
		var/new_runechat_color = tgui_color_picker(user, "Choose your character's runechat colour (#000000 for random):", "Character Preference", pref.runechat_color)
		if(new_runechat_color && CanUseTopic(user))
			pref.runechat_color = new_runechat_color
			// whenever we change this, we update our mob
			var/mob/pref_mob = preference_mob()
			if(pref_mob)
				pref_mob.chat_color = new_runechat_color
				pref_mob.chat_color_darkened = new_runechat_color
				pref_mob.chat_color_name = pref_mob.name
			return TOPIC_REFRESH


	return ..()
