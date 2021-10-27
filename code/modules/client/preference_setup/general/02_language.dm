/datum/category_item/player_setup_item/general/language
	name = "Language"
	sort_order = 2
	var/static/list/forbidden_prefixes = list(";", ":", ".", "!", "*", "^", "-")

/datum/category_item/player_setup_item/general/language/load_character(var/savefile/S)
	S["language"]			>> pref.alternate_languages
	testing("LANGSANI: Loaded from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] savefile: [english_list(pref.alternate_languages || list())]")
	S["language_prefixes"]	>> pref.language_prefixes

/datum/category_item/player_setup_item/general/language/save_character(var/savefile/S)
	S["language"]			<< pref.alternate_languages
	testing("LANGSANI: Saved to [pref.client]'s character [pref.real_name || "-name not yet loaded-"] savefile: [english_list(pref.alternate_languages || list())]")
	S["language_prefixes"]	<< pref.language_prefixes

/datum/category_item/player_setup_item/general/language/sanitize_character()
	if(!islist(pref.alternate_languages))
		testing("LANGSANI: Sanitizing languages on [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because their character has no languages list")
		pref.alternate_languages = list()
	if(pref.species)
		var/datum/species/S = GLOB.all_species[pref.species]
		if(!istype(S))
			testing("LANGSANI: Failed sani on [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because their species ([pref.species]) isn't in the global list")
			return
			
		if(pref.alternate_languages.len > S.num_alternate_languages)
			testing("LANGSANI: Truncated [pref.client]'s character [pref.real_name || "-name not yet loaded-"] language list because it was too long (len: [pref.alternate_languages.len], allowed: [S.num_alternate_languages])")
			pref.alternate_languages.len = S.num_alternate_languages // Truncate to allowed length

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

/datum/category_item/player_setup_item/general/language/content()
	. += "<b>Languages</b><br>"
	var/datum/species/S = GLOB.all_species[pref.species]
	if(S.language)
		. += "- [S.language]<br>"
	if(S.default_language && S.default_language != S.language)
		. += "- [S.default_language]<br>"
	if(S.num_alternate_languages)
		if(pref.alternate_languages.len)
			for(var/i = 1 to pref.alternate_languages.len)
				var/lang = pref.alternate_languages[i]
				. += "- [lang] - <a href='?src=\ref[src];remove_language=[i]'>remove</a><br>"

		if(pref.alternate_languages.len < S.num_alternate_languages)
			. += "- <a href='?src=\ref[src];add_language=1'>add</a> ([S.num_alternate_languages - pref.alternate_languages.len] remaining)<br>"
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
		if(pref.alternate_languages.len >= S.num_alternate_languages)
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
				if(new_lang && pref.alternate_languages.len < S.num_alternate_languages)
					pref.alternate_languages |= new_lang
					return TOPIC_REFRESH

	else if(href_list["change_prefix"])
		var/char
		var/keys[0]
		do
			char = input(usr, "Enter a single special character.\nYou may re-select the same characters.\nThe following characters are already in use by radio: ; : .\nThe following characters are already in use by special say commands: ! * ^", "Enter Character - [3 - keys.len] remaining") as null|text
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

	return ..()
