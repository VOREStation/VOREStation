/mob/living
	var/datum/language/default_language

/mob/living/verb/set_default_language()
	set name = "Set Default Language"
	set category = "IC.Settings"

	if(!LAZYLEN(languages))
		to_chat(src, span_warning("You can't speak any languages."))
		return

	var/language = tgui_input_list(src, "Select your default language", "Available languages", languages)
	if(!language)
		return

	apply_default_language(language)

// Silicons can't neccessarily speak everything in their languages list
/mob/living/silicon/set_default_language()
	if(!LAZYLEN(speech_synthesizer_langs))
		to_chat(src, span_warning("You can't speak any languages."))
		return
	var/language = tgui_input_list(src, "Select your default language", "Available languages", speech_synthesizer_langs)
	if(!language)
		return

	apply_default_language(language)

/mob/living/proc/apply_default_language(var/language)
	if (only_species_language && language != GLOB.all_languages[species_language])
		to_chat(src, span_notice("You can only speak your species language, [species_language]."))
		return 0

	if(language == GLOB.all_languages[species_language])
		to_chat(src, span_notice("You will now speak your standard default language, [language], if you do not specify a language when speaking."))
	else if (language)

		if(language && !can_speak(language))
			to_chat(src, span_notice("You are unable to speak that language."))
			return

		to_chat(src, span_notice("You will now speak [language] if you do not specify a language when speaking."))
	else
		to_chat(src, span_notice("You will now speak whatever your standard default language is if you do not specify one when speaking."))
	default_language = language

/mob/living/verb/check_default_language()
	set name = "Check Default Language"
	set category = "IC.Game"

	if(default_language)
		to_chat(src, span_notice("You are currently speaking [default_language] by default."))
	else
		to_chat(src, span_notice("Your current default language is your species or mob type default."))
