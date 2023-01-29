/datum/preferences
	var/extra_languages = 0

/datum/category_item/player_setup_item/general/language
	name = "Language"
	sort_order = 2
	var/static/list/forbidden_prefixes = list(";", ":", ".", "!", "*", "^", "-")

/datum/category_item/player_setup_item/general/language/load_character(var/savefile/S)
	S["language"]			>> pref.alternate_languages
	S["extra_languages"]	>> pref.extra_languages
	if(islist(pref.alternate_languages))			// Because aparently it may not be?
		testing("LANGSANI: Loaded from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] savefile: [english_list(pref.alternate_languages || list())]")
	S["language_prefixes"]	>> pref.language_prefixes
	S["language_custom_keys"]	>> pref.language_custom_keys

/datum/category_item/player_setup_item/general/language/save_character(var/savefile/S)
	S["language"]			<< pref.alternate_languages
	S["extra_languages"]	<< pref.extra_languages
	if(islist(pref.alternate_languages))			// Because aparently it may not be?
		testing("LANGSANI: Loaded from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] savefile: [english_list(pref.alternate_languages || list())]")
	S["language_prefixes"]	<< pref.language_prefixes
	S["language_custom_keys"]	<< pref.language_custom_keys

/datum/category_item/player_setup_item/general/language/sanitize_character()
	if(!islist(pref.alternate_languages))
		testing("LANGSANI: Sanitizing languages on [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because their character has no languages list")
		pref.alternate_languages = list()
	if(pref.species)
		var/datum/species/S = GLOB.all_species[pref.species]
		if(!istype(S))
			testing("LANGSANI: Failed sani on [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because their species ([pref.species]) isn't in the global list")
			return

<<<<<<< HEAD
		if(pref.alternate_languages.len > (S.num_alternate_languages + pref.extra_languages))
			testing("LANGSANI: Truncated [pref.client]'s character [pref.real_name || "-name not yet loaded-"] language list because it was too long (len: [pref.alternate_languages.len], allowed: [S.num_alternate_languages])")
			pref.alternate_languages.len = (S.num_alternate_languages + pref.extra_languages) // Truncate to allowed length
=======
		if(pref.alternate_languages.len > S.num_alternate_languages)
			pref.alternate_languages.len = S.num_alternate_languages // Truncate to allowed length
>>>>>>> 009e1d1aa03... Merge pull request #8825 from MistakeNot4892/drakes

		// Sanitize illegal languages
		for(var/language in pref.alternate_languages)
			var/datum/language/L = GLOB.all_languages[language]
			if(!istype(L) || (L.flags & RESTRICTED) || (!(language in S.secondary_langs) && pref.client && !is_lang_whitelisted(pref.client, L)))
				testing("LANGSANI: Removed [L?.name || "lang not found"] from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because it failed allowed checks")
				pref.alternate_languages -= language

	if(isnull(pref.language_prefixes) || !pref.language_prefixes.len)
		pref.language_prefixes = config.language_prefixes.Copy()
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

/datum/category_item/player_setup_item/general/language/content()
	. += "<b>Languages</b><br>"
	var/datum/species/S = GLOB.all_species[pref.species]
	if(pref.alternate_languages.len > (S.num_alternate_languages + pref.extra_languages))
		testing("LANGSANI: Truncated [pref.client]'s character [pref.real_name || "-name not yet loaded-"] language list because it was too long (len: [pref.alternate_languages.len], allowed: [S.num_alternate_languages])")
		pref.alternate_languages.len = (S.num_alternate_languages + pref.extra_languages) // Truncate to allowed length
	if(S.language)
		. += "- [S.language] - <a href='?src=\ref[src];set_custom_key=[S.language]'>Set Custom Key</a><br>"
	if(S.default_language && S.default_language != S.language)
		. += "- [S.default_language] - <a href='?src=\ref[src];set_custom_key=[S.default_language]'>Set Custom Key</a><br>"
	if(S.num_alternate_languages + pref.extra_languages)
		if(pref.alternate_languages.len)
			for(var/i = 1 to pref.alternate_languages.len)
				var/lang = pref.alternate_languages[i]
				. += "- [lang] - <a href='?src=\ref[src];remove_language=[i]'>remove</a> - <a href='?src=\ref[src];set_custom_key=[lang]'>Set Custom Key</a><br>"

		if(pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
			. += "- <a href='?src=\ref[src];add_language=1'>add</a> ([(S.num_alternate_languages + pref.extra_languages) - pref.alternate_languages.len] remaining)<br>"
	else
		. += "- [pref.species] cannot choose secondary languages.<br>"

	. += "<b>Language Keys</b><br>"
	. += " [jointext(pref.language_prefixes, " ")] <a href='?src=\ref[src];change_prefix=1'>Change</a> <a href='?src=\ref[src];reset_prefix=1'>Reset</a><br>"

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
		pref.language_prefixes = config.language_prefixes.Copy()
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

	return ..()
