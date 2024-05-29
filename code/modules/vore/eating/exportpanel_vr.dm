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

	for(var/belly in host.vore_organs)
		if(isbelly(belly))
			var/obj/belly/B = belly
			var/belly_data = list()

			// General Information
			belly_data["name"] = B.name
			belly_data["desc"] = B.desc
			belly_data["absorbed_desc"] = B.absorbed_desc
			belly_data["vore_verb"] = B.vore_verb
			belly_data["release_verb"] = B.release_verb

			// Controls
			belly_data["mode"] = B.digest_mode
			var/list/addons = list()
			for(var/flag_name in B.mode_flag_list)
				if(B.mode_flags & B.mode_flag_list[flag_name])
					addons.Add(flag_name)
			belly_data["addons"] = addons
			belly_data["item_mode"] = B.item_digest_mode
			belly_data["message_mode"] = B.message_mode

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

			belly_data["escape_attempt_messages_owner"] = list()
			for(var/msg in B.escape_attempt_messages_owner)
				belly_data["escape_attempt_messages_owner"] += msg

			belly_data["escape_attempt_messages_prey"] = list()
			for(var/msg in B.escape_attempt_messages_prey)
				belly_data["escape_attempt_messages_prey"] += msg

			belly_data["escape_messages_owner"] = list()
			for(var/msg in B.escape_messages_owner)
				belly_data["escape_messages_owner"] += msg

			belly_data["escape_messages_prey"] = list()
			for(var/msg in B.escape_messages_prey)
				belly_data["escape_messages_prey"] += msg

			belly_data["escape_messages_outside"] = list()
			for(var/msg in B.escape_messages_outside)
				belly_data["escape_messages_outside"] += msg

			belly_data["escape_item_messages_owner"] = list()
			for(var/msg in B.escape_item_messages_owner)
				belly_data["escape_item_messages_owner"] += msg

			belly_data["escape_item_messages_prey"] = list()
			for(var/msg in B.escape_item_messages_prey)
				belly_data["escape_item_messages_prey"] += msg

			belly_data["escape_item_messages_outside"] = list()
			for(var/msg in B.escape_item_messages_outside)
				belly_data["escape_item_messages_outside"] += msg

			belly_data["escape_fail_messages_owner"] = list()
			for(var/msg in B.escape_fail_messages_owner)
				belly_data["escape_fail_messages_owner"] += msg

			belly_data["escape_fail_messages_prey"] = list()
			for(var/msg in B.escape_fail_messages_prey)
				belly_data["escape_fail_messages_prey"] += msg

			belly_data["escape_attempt_absorbed_messages_owner"] = list()
			for(var/msg in B.escape_attempt_absorbed_messages_owner)
				belly_data["escape_attempt_absorbed_messages_owner"] += msg

			belly_data["escape_attempt_absorbed_messages_prey"] = list()
			for(var/msg in B.escape_attempt_absorbed_messages_prey)
				belly_data["escape_attempt_absorbed_messages_prey"] += msg

			belly_data["escape_absorbed_messages_owner"] = list()
			for(var/msg in B.escape_absorbed_messages_owner)
				belly_data["escape_absorbed_messages_owner"] += msg

			belly_data["escape_absorbed_messages_prey"] = list()
			for(var/msg in B.escape_absorbed_messages_prey)
				belly_data["escape_absorbed_messages_prey"] += msg

			belly_data["escape_absorbed_messages_outside"] = list()
			for(var/msg in B.escape_absorbed_messages_outside)
				belly_data["escape_absorbed_messages_outside"] += msg

			belly_data["escape_fail_absorbed_messages_owner"] = list()
			for(var/msg in B.escape_fail_absorbed_messages_owner)
				belly_data["escape_fail_absorbed_messages_owner"] += msg

			belly_data["escape_fail_absorbed_messages_prey"] = list()
			for(var/msg in B.escape_fail_absorbed_messages_prey)
				belly_data["escape_fail_absorbed_messages_prey"] += msg

			belly_data["primary_transfer_messages_owner"] = list()
			for(var/msg in B.primary_transfer_messages_owner)
				belly_data["primary_transfer_messages_owner"] += msg

			belly_data["primary_transfer_messages_prey"] = list()
			for(var/msg in B.primary_transfer_messages_prey)
				belly_data["primary_transfer_messages_prey"] += msg

			belly_data["secondary_transfer_messages_owner"] = list()
			for(var/msg in B.secondary_transfer_messages_owner)
				belly_data["secondary_transfer_messages_owner"] += msg

			belly_data["secondary_transfer_messages_prey"] = list()
			for(var/msg in B.secondary_transfer_messages_prey)
				belly_data["secondary_transfer_messages_prey"] += msg

			belly_data["digest_chance_messages_owner"] = list()
			for(var/msg in B.digest_chance_messages_owner)
				belly_data["digest_chance_messages_owner"] += msg

			belly_data["digest_chance_messages_prey"] = list()
			for(var/msg in B.digest_chance_messages_prey)
				belly_data["digest_chance_messages_prey"] += msg

			belly_data["absorb_chance_messages_owner"] = list()
			for(var/msg in B.absorb_chance_messages_owner)
				belly_data["absorb_chance_messages_owner"] += msg

			belly_data["absorb_chance_messages_prey"] = list()
			for(var/msg in B.absorb_chance_messages_prey)
				belly_data["absorb_chance_messages_prey"] += msg

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

			//belly_data["emote_list"] = list()
			//for(var/EL in B.emote_lists)
			//	for(var/msg in B.emote_lists[EL])
			//		msg_list += msg
			//
			//	belly_data["emote_lists"] += list(EL, msg_list)

			// I will use this first before the code above gets fixed
			belly_data["emotes_digest"] = list()
			for(var/msg in B.emote_lists[DM_DIGEST])
				belly_data["emotes_digest"] += msg

			belly_data["emotes_hold"] = list()
			for(var/msg in B.emote_lists[DM_HOLD])
				belly_data["emotes_hold"] += msg

			belly_data["emotes_holdabsorbed"] = list()
			for(var/msg in B.emote_lists[DM_HOLD_ABSORBED])
				belly_data["emotes_holdabsorbed"] += msg

			belly_data["emotes_absorb"] = list()
			for(var/msg in B.emote_lists[DM_ABSORB])
				belly_data["emotes_absorb"] += msg

			belly_data["emotes_heal"] = list()
			for(var/msg in B.emote_lists[DM_HEAL])
				belly_data["emotes_heal"] += msg

			belly_data["emotes_drain"] = list()
			for(var/msg in B.emote_lists[DM_DRAIN])
				belly_data["emotes_drain"] += msg

			belly_data["emotes_steal"] = list()
			for(var/msg in B.emote_lists[DM_SIZE_STEAL])
				belly_data["emotes_steal"] += msg

			belly_data["emotes_egg"] = list()
			for(var/msg in B.emote_lists[DM_EGG])
				belly_data["emotes_egg"] += msg

			belly_data["emotes_shrink"] = list()
			for(var/msg in B.emote_lists[DM_SHRINK])
				belly_data["emotes_shrink"] += msg

			belly_data["emotes_grow"] = list()
			for(var/msg in B.emote_lists[DM_GROW])
				belly_data["emotes_grow"] += msg

			belly_data["emotes_unabsorb"] = list()
			for(var/msg in B.emote_lists[DM_UNABSORB])
				belly_data["emotes_unabsorb"] += msg

			// Options
			belly_data["digest_brute"] = B.digest_brute
			belly_data["digest_burn"] = B.digest_burn
			belly_data["digest_oxy"] = B.digest_oxy
			belly_data["digest_tox"] = B.digest_tox
			belly_data["digest_clone"] = B.digest_clone

			belly_data["can_taste"] = B.can_taste
			belly_data["contaminates"] = B.contaminates
			belly_data["contamination_flavor"] = B.contamination_flavor
			belly_data["contamination_color"] = B.contamination_color
			belly_data["nutrition_percent"] = B.nutrition_percent
			belly_data["bulge_size"] = B.bulge_size
			belly_data["display_absorbed_examine"] = B.display_absorbed_examine
			belly_data["save_digest_mode"] = B.save_digest_mode
			belly_data["emote_active"] = B.emote_active
			belly_data["emote_time"] = B.emote_time
			belly_data["shrink_grow_size"] = B.shrink_grow_size
			belly_data["egg_type"] = B.egg_type
			belly_data["selective_preference"] = B.selective_preference

			// Sounds
			belly_data["is_wet"] = B.is_wet
			belly_data["wet_loop"] = B.wet_loop
			belly_data["fancy_vore"] = B.fancy_vore
			belly_data["vore_sound"] = B.vore_sound
			belly_data["release_sound"] = B.release_sound

			// Visuals (Vore FX)
			belly_data["disable_hud"] = B.disable_hud

			// Interactions
			belly_data["escapable"] = B.escapable

			belly_data["escapechance"] = B.escapechance
			belly_data["escapechance_absorbed"] = B.escapechance_absorbed
			belly_data["escapetime"] = B.escapetime

			belly_data["transferchance"] = B.transferchance
			belly_data["transferlocation"] = B.transferlocation

			belly_data["transferchance_secondary"] = B.transferchance_secondary
			belly_data["transferlocation_secondary"] = B.transferlocation_secondary

			belly_data["absorbchance"] = B.absorbchance
			belly_data["digestchance"] = B.digestchance

			data["bellies"] += list(belly_data)

	return data
