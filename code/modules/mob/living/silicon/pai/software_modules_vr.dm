/datum/pai_software/translator
	name = "Universal Translator"
	ram_cost = 35
	id = "translator"

	toggle(mob/living/silicon/pai/user)
		// 	Sol Common, Tradeband, Terminus and Gutter are added with New() and are therefore the current default, always active languages
		user.translator_on = !user.translator_on
		if(user.translator_on)
			user.add_language(LANGUAGE_BIRDSONG)
			user.add_language(LANGUAGE_SAGARU)
			user.add_language(LANGUAGE_CANILUNZT)
			user.add_language(LANGUAGE_ECUREUILIAN)
			user.add_language(LANGUAGE_DAEMON)
			user.add_language(LANGUAGE_ENOCHIAN)
			user.add_language(LANGUAGE_UNATHI)
			user.add_language(LANGUAGE_SIIK)
			user.add_language(LANGUAGE_AKHANI)
			user.add_language(LANGUAGE_SKRELLIAN)
			user.add_language(LANGUAGE_SCHECHI)
		else
			user.remove_language(LANGUAGE_BIRDSONG)
			user.remove_language(LANGUAGE_SAGARU)
			user.remove_language(LANGUAGE_CANILUNZT)
			user.remove_language(LANGUAGE_ECUREUILIAN)
			user.remove_language(LANGUAGE_DAEMON)
			user.remove_language(LANGUAGE_ENOCHIAN)
			user.remove_language(LANGUAGE_UNATHI)
			user.remove_language(LANGUAGE_SIIK)
			user.remove_language(LANGUAGE_AKHANI)
			user.remove_language(LANGUAGE_SKRELLIAN)
			user.remove_language(LANGUAGE_SCHECHI)

	is_active(mob/living/silicon/pai/user)
		return user.translator_on
