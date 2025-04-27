GLOBAL_DATUM(character_directory, /datum/character_directory)

/client/verb/show_character_directory()
	set name = "Character Directory"
	set category = "OOC.Game"
	set desc = "Shows a listing of all active characters, along with their associated OOC notes, flavor text, and more."

	// This is primarily to stop malicious users from trying to lag the server by spamming this verb
	if(!usr.checkMoveCooldown())
		to_chat(usr, span_warning("Don't spam character directory refresh."))
		return
	usr.setMoveCooldown(10)

	if(!GLOB.character_directory)
		GLOB.character_directory = new
	GLOB.character_directory.tgui_interact(mob)


// This is a global singleton. Keep in mind that all operations should occur on usr, not src.
/datum/character_directory
/datum/character_directory/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/character_directory/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterDirectory", "Character Directory")
		ui.open()

/datum/character_directory/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	if (user?.mind)
		data["personalVisibility"] = user.mind.show_in_directory
		data["personalTag"] = user.mind.directory_tag || "Unset"
		data["personalErpTag"] = user.mind.directory_erptag || "Unset"
		data["personalEventTag"] = GLOB.vantag_choices_list[user.mind.vantag_preference]
		data["personalGenderTag"] = user.mind.directory_gendertag || "Unset"
		data["personalSexualityTag"] = user.mind.directory_sexualitytag || "Unset"
	else if (user?.client?.prefs)
		data["personalVisibility"] = user.client.prefs.show_in_directory
		data["personalTag"] = user.client.prefs.directory_tag || "Unset"
		data["personalErpTag"] = user.client.prefs.directory_erptag || "Unset"
		data["personalEventTag"] = GLOB.vantag_choices_list[user.client.prefs.vantag_preference]
		data["personalGenderTag"] = user.client.prefs.directory_gendertag || "Unset"
		data["personalSexualityTag"] = user.client.prefs.directory_sexualitytag || "Unset"

	return data

/datum/character_directory/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/directory_mobs = list()
	for(var/client/C in GLOB.clients)
		// Allow opt-out.
		if(C?.mob?.mind ? !C.mob.mind.show_in_directory : !C?.prefs?.show_in_directory)
			continue

		// These are the three vars we're trying to find
		// The approach differs based on the mob the client is controlling
		var/name = null
		var/species = null
		var/ooc_notes = null
		var/ooc_notes_favs = null
		var/ooc_notes_likes = null
		var/ooc_notes_maybes = null
		var/ooc_notes_dislikes = null
		var/ooc_notes_style = null
		var/gendertag = null
		var/sexualitytag = null
		var/eventtag = GLOB.vantag_choices_list[VANTAG_NONE]
		var/flavor_text = null
		var/tag
		var/erptag
		var/character_ad
		if (C.mob?.mind) //could use ternary for all three but this is more efficient
			tag = C.mob.mind.directory_tag || "Unset"
			erptag = C.mob.mind.directory_erptag || "Unset"
			character_ad = C.mob.mind.directory_ad
			gendertag = C.mob.mind.directory_gendertag || "Unset"
			sexualitytag = C.mob.mind.directory_sexualitytag || "Unset"
			eventtag = GLOB.vantag_choices_list[C.mob.mind.vantag_preference]
		else
			tag = C.prefs.directory_tag || "Unset"
			erptag = C.prefs.directory_erptag || "Unset"
			character_ad = C.prefs.directory_ad
			gendertag = C.prefs.directory_gendertag || "Unset"
			sexualitytag = C.prefs.directory_sexualitytag || "Unset"
			eventtag = GLOB.vantag_choices_list[C.prefs.vantag_preference]

		if(ishuman(C.mob))
			var/mob/living/carbon/human/H = C.mob
			var/strangername = H.real_name
			if(GLOB.data_core && GLOB.data_core.general)
				if(!find_general_record("name", H.real_name))
					if(!find_record("name", H.real_name, GLOB.data_core.hidden_general))
						strangername = "unknown"
			name = strangername
			species = "[H.custom_species ? H.custom_species : H.species.name]"
			ooc_notes = H.ooc_notes
			if(H.ooc_notes_style && (H.ooc_notes_favs || H.ooc_notes_likes || H.ooc_notes_maybes || H.ooc_notes_dislikes))
				ooc_notes = H.ooc_notes + "\n\n"
				ooc_notes_favs = H.ooc_notes_favs
				ooc_notes_likes = H.ooc_notes_likes
				ooc_notes_maybes = H.ooc_notes_maybes
				ooc_notes_dislikes = H.ooc_notes_dislikes
				ooc_notes_style = H.ooc_notes_style
			else
				if(H.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[H.ooc_notes_favs]"
				if(H.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[H.ooc_notes_likes]"
				if(H.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[H.ooc_notes_maybes]"
				if(H.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[H.ooc_notes_dislikes]"
			if(LAZYLEN(H.flavor_texts))
				flavor_text = H.flavor_texts["general"]

		if(isAI(C.mob))
			var/mob/living/silicon/ai/A = C.mob
			name = A.name
			species = "Artificial Intelligence"
			ooc_notes = A.ooc_notes
			if(A.ooc_notes_style && (A.ooc_notes_favs || A.ooc_notes_likes || A.ooc_notes_maybes || A.ooc_notes_dislikes))
				ooc_notes = A.ooc_notes + "\n\n"
				ooc_notes_favs = A.ooc_notes_favs
				ooc_notes_likes = A.ooc_notes_likes
				ooc_notes_maybes = A.ooc_notes_maybes
				ooc_notes_dislikes = A.ooc_notes_dislikes
				ooc_notes_style = A.ooc_notes_style
			else
				if(A.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[A.ooc_notes_favs]"
				if(A.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[A.ooc_notes_likes]"
				if(A.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[A.ooc_notes_maybes]"
				if(A.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[A.ooc_notes_dislikes]"

			flavor_text = null // No flavor text for AIs :c

		if(isrobot(C.mob))
			var/mob/living/silicon/robot/R = C.mob
			if(R.scrambledcodes || (R.module && R.module.hide_on_manifest))
				continue
			name = R.name
			species = "[R.modtype] [R.braintype]"
			ooc_notes = R.ooc_notes
			if(R.ooc_notes_style && (R.ooc_notes_favs || R.ooc_notes_likes || R.ooc_notes_maybes || R.ooc_notes_dislikes))
				ooc_notes = R.ooc_notes + "\n\n"
				ooc_notes_favs = R.ooc_notes_favs
				ooc_notes_likes = R.ooc_notes_likes
				ooc_notes_maybes = R.ooc_notes_maybes
				ooc_notes_dislikes = R.ooc_notes_dislikes
				ooc_notes_style = R.ooc_notes_style
			else
				if(R.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[R.ooc_notes_favs]"
				if(R.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[R.ooc_notes_likes]"
				if(R.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[R.ooc_notes_maybes]"
				if(R.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[R.ooc_notes_dislikes]"

			flavor_text = R.flavor_text

		if(ispAI(C.mob))
			var/mob/living/silicon/pai/P = C.mob
			name = P.name
			species = "pAI"
			ooc_notes = P.ooc_notes
			if(P.ooc_notes_style && (P.ooc_notes_favs || P.ooc_notes_likes || P.ooc_notes_maybes || P.ooc_notes_dislikes))
				ooc_notes = P.ooc_notes + "\n\n"
				ooc_notes_favs = P.ooc_notes_favs
				ooc_notes_likes = P.ooc_notes_likes
				ooc_notes_maybes = P.ooc_notes_maybes
				ooc_notes_dislikes = P.ooc_notes_dislikes
				ooc_notes_style = P.ooc_notes_style
			else
				if(P.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[P.ooc_notes_favs]"
				if(P.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[P.ooc_notes_likes]"
				if(P.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[P.ooc_notes_maybes]"
				if(P.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[P.ooc_notes_dislikes]"
			flavor_text = P.flavor_text

		if(isanimal(C.mob))
			var/mob/living/simple_mob/S = C.mob
			name = S.name
			species = S.character_directory_species()
			ooc_notes = S.ooc_notes
			if(S.ooc_notes_style && (S.ooc_notes_favs || S.ooc_notes_likes || S.ooc_notes_maybes || S.ooc_notes_dislikes))
				ooc_notes = S.ooc_notes + "\n\n"
				ooc_notes_favs = S.ooc_notes_favs
				ooc_notes_likes = S.ooc_notes_likes
				ooc_notes_maybes = S.ooc_notes_maybes
				ooc_notes_dislikes = S.ooc_notes_dislikes
				ooc_notes_style = S.ooc_notes_style
			else
				if(S.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[S.ooc_notes_favs]"
				if(S.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[S.ooc_notes_likes]"
				if(S.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[S.ooc_notes_maybes]"
				if(S.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[S.ooc_notes_dislikes]"
			flavor_text = S.desc

		// It's okay if we fail to find OOC notes and flavor text
		// But if we can't find the name, they must be using a non-compatible mob type currently.
		if(!name)
			continue

		directory_mobs.Add(list(list(
			"name" = name,
			"species" = species,
			"ooc_notes_favs" = ooc_notes_favs,
			"ooc_notes_likes" = ooc_notes_likes,
			"ooc_notes_maybes" = ooc_notes_maybes,
			"ooc_notes_dislikes" = ooc_notes_dislikes,
			"ooc_notes_style" = ooc_notes_style,
			"gendertag" = gendertag,
			"sexualitytag" = sexualitytag,
			"eventtag" = eventtag,
			"ooc_notes" = ooc_notes,
			"tag" = tag,
			"erptag" = erptag,
			"character_ad" = character_ad,
			"flavor_text" = flavor_text,
		)))

	data["directory"] = directory_mobs

	return data


/datum/character_directory/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	if(action == "refresh")
		// This is primarily to stop malicious users from trying to lag the server by spamming this verb
		if(!ui.user.checkMoveCooldown())
			to_chat(ui.user, span_warning("Don't spam character directory refresh."))
			return
		ui.user.setMoveCooldown(10)
		update_tgui_static_data(ui.user, ui)
		return TRUE
	else
		return check_for_mind_or_prefs(ui.user, action, params["overwrite_prefs"])

/datum/character_directory/proc/check_for_mind_or_prefs(mob/user, action, overwrite_prefs)
	if (!user.client)
		return
	var/can_set_prefs = overwrite_prefs && !!user.client.prefs
	var/can_set_mind = !!user.mind
	if (!can_set_prefs && !can_set_mind)
		if (!overwrite_prefs && !!user.client.prefs)
			to_chat(user, span_warning("You cannot change these settings if you don't have a mind to save them to. Enable overwriting prefs and switch to a slot you're fine with overwriting."))
		return
	switch(action)
		if ("setTag")
			var/list/new_tag = tgui_input_list(user, "Pick a new Vore tag for the character directory", "Character Tag", GLOB.char_directory_tags)
			if(!new_tag)
				return
			return set_for_mind_or_prefs(user, action, new_tag, can_set_prefs, can_set_mind)
		if ("setErpTag")
			var/list/new_erptag = tgui_input_list(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags)
			if(!new_erptag)
				return
			return set_for_mind_or_prefs(user, action, new_erptag, can_set_prefs, can_set_mind)
		if ("setVisible")
			var/visible = TRUE
			if (can_set_mind)
				visible = user.mind.show_in_directory
			else if (can_set_prefs)
				visible = user.client.prefs.show_in_directory
			to_chat(user, span_notice("You are now [!visible ? "shown" : "not shown"] in the directory."))
			return set_for_mind_or_prefs(user, action, !visible, can_set_prefs, can_set_mind)
		if ("editAd")
			var/current_ad = (can_set_mind ? user.mind.directory_ad : null) || (can_set_prefs ? user.client.prefs.directory_ad : null)
			var/new_ad = sanitize(tgui_input_text(user, "Change your character ad", "Character Ad", current_ad, multiline = TRUE, prevent_enter = TRUE), extra = 0)
			if(isnull(new_ad))
				return
			return set_for_mind_or_prefs(user, action, new_ad, can_set_prefs, can_set_mind)
		if("setGenderTag")
			var/list/new_gendertag = tgui_input_list(usr, "Pick a new Gender tag for the character directory. This is YOUR gender, not what you prefer.", "Character Gender Tag", GLOB.char_directory_gendertags)
			if(!new_gendertag)
				return
			return set_for_mind_or_prefs(user, action, new_gendertag, can_set_prefs, can_set_mind)
		if("setSexualityTag")
			var/list/new_sexualitytag = tgui_input_list(usr, "Pick a new Sexuality/Orientation tag for the character directory", "Character Sexuality/Orientation Tag", GLOB.char_directory_sexualitytags)
			if(!new_sexualitytag)
				return
			return set_for_mind_or_prefs(user, action, new_sexualitytag, can_set_prefs, can_set_mind)
		if("setEventTag")
			var/list/names_list = list()
			for(var/C in GLOB.vantag_choices_list)
				names_list[GLOB.vantag_choices_list[C]] = C
			var/list/new_eventtag = tgui_input_list(usr, "Pick your preference for event involvement", "Event Preference Tag", usr?.client?.prefs?.vantag_preference, names_list)
			if(!new_eventtag)
				return
			return set_for_mind_or_prefs(user, action, names_list[new_eventtag], can_set_prefs, can_set_mind)

/datum/character_directory/proc/set_for_mind_or_prefs(mob/user, action, new_value, can_set_prefs, can_set_mind)
	can_set_prefs &&= !!user.client.prefs
	can_set_mind &&= !!user.mind
	if (!can_set_prefs && !can_set_mind)
		to_chat(user, span_warning("You seem to have lost either your mind, or your current preferences, while changing the values.[action == "editAd" ? " Here is your ad that you wrote. [new_value]" : null]"))
		return
	switch(action)
		if ("setTag")
			if (can_set_prefs)
				user.client.prefs.directory_tag = new_value
			if (can_set_mind)
				user.mind.directory_tag = new_value
			return TRUE
		if ("setErpTag")
			if (can_set_prefs)
				user.client.prefs.directory_erptag = new_value
			if (can_set_mind)
				user.mind.directory_erptag = new_value
			return TRUE
		if ("setVisible")
			if (can_set_prefs)
				user.client.prefs.show_in_directory = new_value
			if (can_set_mind)
				user.mind.show_in_directory = new_value
			return TRUE
		if ("editAd")
			if (can_set_prefs)
				user.client.prefs.directory_ad = new_value
			if (can_set_mind)
				user.mind.directory_ad = new_value
			return TRUE
		if ("setEventTag")
			if (can_set_prefs)
				user.client.prefs.vantag_preference = new_value
			if (can_set_mind)
				user.mind.vantag_preference = new_value
		if ("setGenderTag")
			if (can_set_prefs)
				user.client.prefs.directory_gendertag = new_value
			if (can_set_mind)
				user.mind.directory_gendertag = new_value
		if ("setSexualityTag")
			if (can_set_prefs)
				user.client.prefs.directory_sexualitytag = new_value
			if (can_set_mind)
				user.mind.directory_sexualitytag = new_value
