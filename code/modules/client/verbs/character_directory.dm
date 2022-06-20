GLOBAL_DATUM(character_directory, /datum/character_directory)

/client/verb/show_character_directory()
	set name = "Character Directory"
	set category = "OOC"
	set desc = "Shows a listing of all active characters, along with their associated OOC notes, flavor text, and more."

	// This is primarily to stop malicious users from trying to lag the server by spamming this verb
	if(!usr.checkMoveCooldown())
		to_chat(usr, "<span class='warning'>Don't spam character directory refresh.</span>")
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
	
	data["personalVisibility"] = user?.client?.prefs?.show_in_directory
	data["personalTag"] = user?.client?.prefs?.directory_tag || "Unset"
	data["personalErpTag"] = user?.client?.prefs?.directory_erptag || "Unset"

	return data

/datum/character_directory/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/directory_mobs = list()
	for(var/client/C in GLOB.clients)
		// Allow opt-out.
		if(!C?.prefs?.show_in_directory)
			continue
		
		// These are the three vars we're trying to find
		// The approach differs based on the mob the client is controlling
		var/name = null
		var/species = null
		var/ooc_notes = null
		var/flavor_text = null
		var/tag = C.prefs.directory_tag || "Unset"
		var/erptag = C.prefs.directory_erptag || "Unset"
		var/character_ad = C.prefs.directory_ad

		if(ishuman(C.mob))
			var/mob/living/carbon/human/H = C.mob
			if(data_core && data_core.general)
				if(!find_general_record("name", H.real_name))
					if(!find_record("name", H.real_name, data_core.hidden_general))
						continue
			name = H.real_name
			species = "[H.custom_species ? H.custom_species : H.species.name]"
			ooc_notes = H.ooc_notes
			flavor_text = H.flavor_texts["general"]

		if(isAI(C.mob))
			var/mob/living/silicon/ai/A = C.mob
			name = A.name
			species = "Artificial Intelligence"
			ooc_notes = A.ooc_notes
			flavor_text = null // No flavor text for AIs :c

		if(isrobot(C.mob))
			var/mob/living/silicon/robot/R = C.mob
			if(R.scrambledcodes || (R.module && R.module.hide_on_manifest))
				continue
			name = R.name
			species = "[R.modtype] [R.braintype]"
			ooc_notes = R.ooc_notes
			flavor_text = R.flavor_text

		// It's okay if we fail to find OOC notes and flavor text
		// But if we can't find the name, they must be using a non-compatible mob type currently.
		if(!name)
			continue
		
		directory_mobs.Add(list(list(
			"name" = name,
			"species" = species,
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

	switch(action)
		if("refresh")
			// This is primarily to stop malicious users from trying to lag the server by spamming this verb
			if(!usr.checkMoveCooldown())
				to_chat(usr, "<span class='warning'>Don't spam character directory refresh.</span>")
				return
			usr.setMoveCooldown(10)
			update_tgui_static_data(usr, ui)
			return TRUE
		if("setTag")
			var/list/new_tag = tgui_input_list(usr, "Pick a new Vore tag for the character directory", "Character Tag", GLOB.char_directory_tags)
			if(!new_tag)
				return
			usr?.client?.prefs?.directory_tag = new_tag
			return TRUE
		if("setErpTag")
			var/list/new_erptag = tgui_input_list(usr, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags)
			if(!new_erptag)
				return
			usr?.client?.prefs?.directory_erptag = new_erptag
			return TRUE
		if("setVisible")
			usr?.client?.prefs?.show_in_directory = !usr?.client?.prefs?.show_in_directory
			to_chat(usr, "<span class='notice'>You are now [usr.client.prefs.show_in_directory ? "shown" : "not shown"] in the directory.</span>")
			return TRUE
		if("editAd")
			if(!usr?.client?.prefs)
				return

			var/current_ad = usr.client.prefs.directory_ad
			var/new_ad = sanitize(tgui_input_text(usr, "Change your character ad", "Character Ad", current_ad, multiline = TRUE), extra = 0)
			if(isnull(new_ad))
				return
			usr.client.prefs.directory_ad = new_ad
			return TRUE