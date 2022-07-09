//
// Belly Export Panel
//

/datum/vore_look/export_panel/proc/open_export_panel(mob/user)
	tgui_interact(user)

/datum/vore_look/export_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VorePanelExport", "Vore Export Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/vore_look/export_panel/tgui_fallback(payload)
	if(..())
		return TRUE

	//var/mob/living/host = usr
	//host.vorebelly_printout(TRUE)

/datum/vore_look/export_panel/tgui_act(action, params)
	if(..())
		return TRUE

/datum/vore_look/export_panel/tgui_data(mob/user)
	var/list/data = list()
	var/mob/living/host = user

	data["db_version"] = "0.1"
	data["db_repo"] = "vorestation"
	data["mob_name"] = host.real_name
	data["bellies"] = list(list())

	for(var/belly in host.vore_organs)
		if(isbelly(belly))
			var/obj/belly/B = belly
			var/belly_data = list()

			// General Information
			belly_data["name"] = B.name
			belly_data["desc"] = B.desc
			belly_data["absorbed_desc"] = B.absorbed_desc
			belly_data["vore_verb"] = B.vore_verb

			// Controls
			// belly_data["mode"] = mode
			// belly_data["addons"] = addons
			// belly_data["item_mode"] = item_mode

			// Options
			belly_data["digest_brute"] = B.digest_brute
			belly_data["digest_burn"] = B.digest_burn
			belly_data["digest_oxy"] = B.digest_oxy

			// Messages
			belly_data["struggle_messages_outside"] = list()
			for(var/msg in B.struggle_messages_outside)
				belly_data["struggle_messages_outside"] += msg

			belly_data["struggle_messages_inside"] = list()
			for(var/msg in B.struggle_messages_inside)
				belly_data["struggle_messages_inside"] += msg

			belly_data["absorbed_struggle_messages_outside"] = list()
			for(var/msg in B.absorbed_struggle_messages_outside)
				belly_data["absorbed_struggle_messages_outside"] += msg

			belly_data["absorbed_struggle_messages_inside"] = list()
			for(var/msg in B.absorbed_struggle_messages_inside)
				belly_data["absorbed_struggle_messages_inside"] += msg

			belly_data["digest_messages_owner"] = list()
			for(var/msg in B.digest_messages_owner)
				belly_data["digest_messages_owner"] += msg

			belly_data["digest_messages_prey"] = list()
			for(var/msg in B.digest_messages_prey)
				belly_data["digest_messages_prey"] += msg

			belly_data["absorb_messages_owner"] = list()
			for(var/msg in B.absorb_messages_owner)
				belly_data["absorb_messages_owner"] += msg

			belly_data["absorb_messages_prey"] = list()
			for(var/msg in B.absorb_messages_prey)
				belly_data["absorb_messages_prey"] += msg

			belly_data["unabsorb_messages_owner"] = list()
			for(var/msg in B.unabsorb_messages_owner)
				belly_data["unabsorb_messages_owner"] += msg

			belly_data["unabsorb_messages_prey"] = list()
			for(var/msg in B.unabsorb_messages_prey)
				belly_data["unabsorb_messages_prey"] += msg

			belly_data["examine_messages"] = list()
			for(var/msg in B.examine_messages)
				belly_data["examine_messages"] += msg

			belly_data["examine_messages_absorbed"] = list()
			for(var/msg in B.examine_messages_absorbed)
				belly_data["examine_messages_absorbed"] += msg

			belly_data["emote_list"] = list()
			for(var/EL in B.emote_lists)
				for(var/msg in B.emote_lists[EL])
					belly_data["emote_list"] += msg

			data["bellies"] += list(belly_data)

	return data
