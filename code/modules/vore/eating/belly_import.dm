/datum/vore_look/proc/import_belly(mob/host)
	var/panel_choice = tgui_input_list(usr, "Belly Import", "Pick an option", list("Import all bellies from VRDB","Import one belly from VRDB"))
	if(!panel_choice) return
	var/pickOne = FALSE
	if(panel_choice == "Import one belly from VRDB")
		pickOne = TRUE
	var/input_file = input(usr,"Please choose a valid VRDB file to import from.","Belly Import") as file
	var/input_data
	try
		input_data = json_decode(file2text(input_file))
	catch(var/exception/e)
		tgui_alert_async(usr, "The supplied file contains errors: [e]", "Error!")
		return FALSE

	if(!islist(input_data))
		tgui_alert_async(usr, "The supplied file was not a valid VRDB file.", "Error!")
		return FALSE

	var/list/valid_names = list()
	var/list/valid_lists = list()
	var/list/updated = list()

	for(var/list/raw_list in input_data)
		if(length(valid_names) >= BELLIES_MAX) break
		if(!islist(raw_list)) continue
		if(!istext(raw_list["name"])) continue
		if(length(raw_list["name"]) > BELLIES_NAME_MAX || length(raw_list["name"]) < BELLIES_NAME_MIN) continue
		if(raw_list["name"] in valid_names) continue
		for(var/obj/belly/B in host.vore_organs)
			if(lowertext(B.name) == lowertext(raw_list["name"]))
				updated += raw_list["name"]
				break
		if(!pickOne && length(host.vore_organs)+length(valid_names)-length(updated) >= BELLIES_MAX) continue
		valid_names += raw_list["name"]
		valid_lists += list(raw_list)

	if(length(valid_names) == 0)
		tgui_alert_async(usr, "The supplied VRDB file does not contain any valid bellies.", "Error!")
		return FALSE

	if(pickOne)
		var/picked = tgui_input_list(usr, "Belly Import", "Which belly?", valid_names)
		if(!picked) return
		for(var/B in valid_lists)
			if(lowertext(picked) == lowertext(B["name"]))
				valid_names = list(picked)
				valid_lists = list(B)
				break
		if(picked in updated)
			updated = list(picked)
		else
			updated = list()

	var/list/alert_msg = list()
	if(length(valid_names)-length(updated) > 0)
		alert_msg += "add [length(valid_names)-length(updated)] new bell[length(valid_names)-length(updated) == 1 ? "y" : "ies"]"
	if(length(updated) > 0)
		alert_msg += "update [length(updated)] existing bell[length(updated) == 1 ? "y" : "ies"]. Please make sure you have saved a copy of your existing bellies"

	var/confirm = tgui_alert(host, "WARNING: This will [jointext(alert_msg," and ")]. You can revert the import by using the Reload Prefs button under Preferences as long as you don't Save Prefs. Are you sure?","Import bellies?",list("Yes","Cancel"))
	if(confirm != "Yes") return FALSE

	for(var/list/belly_data in valid_lists)
		var/obj/belly/new_belly
		for(var/obj/belly/existing_belly in host.vore_organs)
			if(lowertext(existing_belly.name) == lowertext(belly_data["name"]))
				new_belly = existing_belly
				break
		if(!new_belly && length(host.vore_organs) < BELLIES_MAX)
			new_belly = new(host)
			new_belly.name = belly_data["name"]
		if(!new_belly) continue

		// Controls
		if(istext(belly_data["mode"]))
			var/new_mode = html_encode(belly_data["mode"])
			if(new_mode in new_belly.digest_modes)
				new_belly.digest_mode = new_mode

		if(istext(belly_data["item_mode"]))
			var/new_item_mode = html_encode(belly_data["item_mode"])
			if(new_item_mode in new_belly.item_digest_modes)
				new_belly.item_digest_mode = new_item_mode

		if(isnum(belly_data["message_mode"]))
			var/new_message_mode = belly_data["message_mode"]
			if(new_message_mode == 0)
				new_belly.message_mode = FALSE
			if(new_message_mode == 1)
				new_belly.message_mode = TRUE

		if(islist(belly_data["addons"]))
			new_belly.mode_flags = 0
			//new_belly.slow_digestion = FALSE // Not implemented on virgo
			//new_belly.speedy_mob_processing = FALSE // Not implemented on virgo
			STOP_PROCESSING(SSbellies, new_belly)
			// STOP_PROCESSING(SSobj, new_belly) // Not implemented on virgo
			START_PROCESSING(SSbellies, new_belly)
			for(var/addon in belly_data["addons"])
				new_belly.mode_flags += new_belly.mode_flag_list[addon]
				/* Not implemented on virgo
				switch(addon)
					if("Slow Body Digestion")
						new_belly.slow_digestion = TRUE
					if("TURBO MODE")
						new_belly.speedy_mob_processing = TRUE
						STOP_PROCESSING(SSbellies, new_belly)
						START_PROCESSING(SSobj, new_belly)
				*/

		// Descriptions
		if(istext(belly_data["desc"]))
			var/new_desc = html_encode(belly_data["desc"])
			if(new_desc)
				new_desc = readd_quotes(new_desc)
			if(length(new_desc) > 0 && length(new_desc) <= BELLIES_DESC_MAX)
				new_belly.desc = new_desc

		if(istext(belly_data["absorbed_desc"]))
			var/new_absorbed_desc = html_encode(belly_data["absorbed_desc"])
			if(new_absorbed_desc)
				new_absorbed_desc = readd_quotes(new_absorbed_desc)
			if(length(new_absorbed_desc) > 0 && length(new_absorbed_desc) <= BELLIES_DESC_MAX)
				new_belly.absorbed_desc = new_absorbed_desc

		if(istext(belly_data["vore_verb"]))
			var/new_vore_verb = html_encode(belly_data["vore_verb"])
			if(new_vore_verb)
				new_vore_verb = readd_quotes(new_vore_verb)
			if(length(new_vore_verb) >= BELLIES_NAME_MIN && length(new_vore_verb) <= BELLIES_NAME_MAX)
				new_belly.vore_verb = new_vore_verb

		if(istext(belly_data["release_verb"]))
			var/new_release_verb = html_encode(belly_data["release_verb"])
			if(new_release_verb)
				new_release_verb = readd_quotes(new_release_verb)
			if(length(new_release_verb) >= BELLIES_NAME_MIN && length(new_release_verb) <= BELLIES_NAME_MAX)
				new_belly.release_verb = new_release_verb

		if(islist(belly_data["digest_messages_prey"]))
			var/new_digest_messages_prey = sanitize(jointext(belly_data["digest_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_digest_messages_prey)
				new_belly.set_messages(new_digest_messages_prey,"dmp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["digest_messages_owner"]))
			var/new_digest_messages_owner = sanitize(jointext(belly_data["digest_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_digest_messages_owner)
				new_belly.set_messages(new_digest_messages_owner,"dmo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["absorb_messages_prey"]))
			var/new_absorb_messages_prey = sanitize(jointext(belly_data["absorb_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_absorb_messages_prey)
				new_belly.set_messages(new_absorb_messages_prey,"amp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["absorb_messages_owner"]))
			var/new_absorb_messages_owner = sanitize(jointext(belly_data["absorb_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_absorb_messages_owner)
				new_belly.set_messages(new_absorb_messages_owner,"amo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["unabsorb_messages_prey"]))
			var/new_unabsorb_messages_prey = sanitize(jointext(belly_data["unabsorb_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_unabsorb_messages_prey)
				new_belly.set_messages(new_unabsorb_messages_prey,"uamp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["unabsorb_messages_owner"]))
			var/new_unabsorb_messages_owner = sanitize(jointext(belly_data["unabsorb_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_unabsorb_messages_owner)
				new_belly.set_messages(new_unabsorb_messages_owner,"uamo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["struggle_messages_outside"]))
			var/new_struggle_messages_outside = sanitize(jointext(belly_data["struggle_messages_outside"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_struggle_messages_outside)
				new_belly.set_messages(new_struggle_messages_outside,"smo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["struggle_messages_inside"]))
			var/new_struggle_messages_inside = sanitize(jointext(belly_data["struggle_messages_inside"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_struggle_messages_inside)
				new_belly.set_messages(new_struggle_messages_inside,"smi", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["absorbed_struggle_messages_outside"]))
			var/new_absorbed_struggle_messages_outside = sanitize(jointext(belly_data["absorbed_struggle_messages_outside"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_absorbed_struggle_messages_outside)
				new_belly.set_messages(new_absorbed_struggle_messages_outside,"asmo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["absorbed_struggle_messages_inside"]))
			var/new_absorbed_struggle_messages_inside = sanitize(jointext(belly_data["absorbed_struggle_messages_inside"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_absorbed_struggle_messages_inside)
				new_belly.set_messages(new_absorbed_struggle_messages_inside,"asmi", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_attempt_messages_prey"]))
			var/new_escape_attempt_messages_prey = sanitize(jointext(belly_data["escape_attempt_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_attempt_messages_prey)
				new_belly.set_messages(new_escape_attempt_messages_prey,"escap", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_attempt_messages_owner"]))
			var/new_escape_attempt_messages_owner = sanitize(jointext(belly_data["escape_attempt_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_attempt_messages_owner)
				new_belly.set_messages(new_escape_attempt_messages_owner,"escao", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_messages_prey"]))
			var/new_escape_messages_prey = sanitize(jointext(belly_data["escape_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_messages_prey)
				new_belly.set_messages(new_escape_messages_prey,"escp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_messages_owner"]))
			var/new_escape_messages_owner = sanitize(jointext(belly_data["escape_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_messages_owner)
				new_belly.set_messages(new_escape_messages_owner,"esco", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_messages_outside"]))
			var/new_escape_messages_outside = sanitize(jointext(belly_data["escape_messages_outside"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_messages_outside)
				new_belly.set_messages(new_escape_messages_outside,"escout", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_item_messages_prey"]))
			var/new_escape_item_messages_prey = sanitize(jointext(belly_data["escape_item_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_item_messages_prey)
				new_belly.set_messages(new_escape_item_messages_prey,"escip", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_item_messages_owner"]))
			var/new_escape_item_messages_owner = sanitize(jointext(belly_data["escape_item_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_item_messages_owner)
				new_belly.set_messages(new_escape_item_messages_owner,"escio", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_item_messages_outside"]))
			var/new_escape_item_messages_outside = sanitize(jointext(belly_data["escape_item_messages_outside"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_item_messages_outside)
				new_belly.set_messages(new_escape_item_messages_outside,"esciout", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_fail_messages_prey"]))
			var/new_escape_fail_messages_prey = sanitize(jointext(belly_data["escape_fail_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_fail_messages_prey)
				new_belly.set_messages(new_escape_fail_messages_prey,"escfp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_fail_messages_owner"]))
			var/new_escape_fail_messages_owner = sanitize(jointext(belly_data["escape_fail_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_fail_messages_owner)
				new_belly.set_messages(new_escape_fail_messages_owner,"escfo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_attempt_absorbed_messages_prey"]))
			var/new_escape_attempt_absorbed_messages_prey = sanitize(jointext(belly_data["escape_attempt_absorbed_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_attempt_absorbed_messages_prey)
				new_belly.set_messages(new_escape_attempt_absorbed_messages_prey,"aescap", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_attempt_absorbed_messages_owner"]))
			var/new_escape_attempt_absorbed_messages_owner = sanitize(jointext(belly_data["escape_attempt_absorbed_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_attempt_absorbed_messages_owner)
				new_belly.set_messages(new_escape_attempt_absorbed_messages_owner,"aescao", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_absorbed_messages_prey"]))
			var/new_escape_absorbed_messages_prey = sanitize(jointext(belly_data["escape_absorbed_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_absorbed_messages_prey)
				new_belly.set_messages(new_escape_absorbed_messages_prey,"aescp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_absorbed_messages_owner"]))
			var/new_escape_absorbed_messages_owner = sanitize(jointext(belly_data["escape_absorbed_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_absorbed_messages_owner)
				new_belly.set_messages(new_escape_absorbed_messages_owner,"aesco", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_absorbed_messages_outside"]))
			var/new_escape_absorbed_messages_outside = sanitize(jointext(belly_data["escape_absorbed_messages_outside"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_absorbed_messages_outside)
				new_belly.set_messages(new_escape_absorbed_messages_outside,"aescout", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_fail_absorbed_messages_prey"]))
			var/new_escape_fail_absorbed_messages_prey = sanitize(jointext(belly_data["escape_fail_absorbed_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_fail_absorbed_messages_prey)
				new_belly.set_messages(new_escape_fail_absorbed_messages_prey,"aescfp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["escape_fail_absorbed_messages_owner"]))
			var/new_escape_fail_absorbed_messages_owner = sanitize(jointext(belly_data["escape_fail_absorbed_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_escape_fail_absorbed_messages_owner)
				new_belly.set_messages(new_escape_fail_absorbed_messages_owner,"aescfo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["primary_transfer_messages_prey"]))
			var/new_primary_transfer_messages_prey = sanitize(jointext(belly_data["primary_transfer_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_primary_transfer_messages_prey)
				new_belly.set_messages(new_primary_transfer_messages_prey,"trnspp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["primary_transfer_messages_owner"]))
			var/new_primary_transfer_messages_owner = sanitize(jointext(belly_data["primary_transfer_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_primary_transfer_messages_owner)
				new_belly.set_messages(new_primary_transfer_messages_owner,"trnspo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["secondary_transfer_messages_prey"]))
			var/new_secondary_transfer_messages_prey = sanitize(jointext(belly_data["secondary_transfer_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_secondary_transfer_messages_prey)
				new_belly.set_messages(new_secondary_transfer_messages_prey,"trnssp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["secondary_transfer_messages_owner"]))
			var/new_secondary_transfer_messages_owner = sanitize(jointext(belly_data["secondary_transfer_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_secondary_transfer_messages_owner)
				new_belly.set_messages(new_secondary_transfer_messages_owner,"trnsso", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["primary_autotransfer_messages_prey"]))
			var/new_primary_autotransfer_messages_prey = sanitize(jointext(belly_data["primary_autotransfer_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_primary_autotransfer_messages_prey)
				new_belly.set_messages(new_primary_autotransfer_messages_prey,"atrnspp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["primary_autotransfer_messages_owner"]))
			var/new_primary_autotransfer_messages_owner = sanitize(jointext(belly_data["primary_autotransfer_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_primary_autotransfer_messages_owner)
				new_belly.set_messages(new_primary_autotransfer_messages_owner,"atrnspo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["secondary_autotransfer_messages_prey"]))
			var/new_secondary_autotransfer_messages_prey = sanitize(jointext(belly_data["secondary_autotransfer_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_secondary_autotransfer_messages_prey)
				new_belly.set_messages(new_secondary_autotransfer_messages_prey,"atrnssp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["secondary_autotransfer_messages_owner"]))
			var/new_secondary_autotransfer_messages_owner = sanitize(jointext(belly_data["secondary_autotransfer_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_secondary_autotransfer_messages_owner)
				new_belly.set_messages(new_secondary_autotransfer_messages_owner,"atrnsso", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["digest_chance_messages_prey"]))
			var/new_digest_chance_messages_prey = sanitize(jointext(belly_data["digest_chance_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_digest_chance_messages_prey)
				new_belly.set_messages(new_digest_chance_messages_prey,"stmodp", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["digest_chance_messages_owner"]))
			var/new_digest_chance_messages_owner = sanitize(jointext(belly_data["digest_chance_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_digest_chance_messages_owner)
				new_belly.set_messages(new_digest_chance_messages_owner,"stmodo", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["absorb_chance_messages_prey"]))
			var/new_absorb_chance_messages_prey = sanitize(jointext(belly_data["absorb_chance_messages_prey"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_absorb_chance_messages_prey)
				new_belly.set_messages(new_absorb_chance_messages_prey,"stmoap", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["absorb_chance_messages_owner"]))
			var/new_absorb_chance_messages_owner = sanitize(jointext(belly_data["absorb_chance_messages_owner"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_absorb_chance_messages_owner)
				new_belly.set_messages(new_absorb_chance_messages_owner,"stmoao", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["examine_messages"]))
			var/new_examine_messages = sanitize(jointext(belly_data["examine_messages"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_examine_messages)
				new_belly.set_messages(new_examine_messages,"em", limit = MAX_MESSAGE_LEN / 2)

		if(islist(belly_data["examine_messages_absorbed"]))
			var/new_examine_messages_absorbed = sanitize(jointext(belly_data["examine_messages_absorbed"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_examine_messages_absorbed)
				new_belly.set_messages(new_examine_messages_absorbed,"ema", limit = MAX_MESSAGE_LEN / 2)

		if(islist(belly_data["emotes_digest"]))
			var/new_emotes_digest = sanitize(jointext(belly_data["emotes_digest"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_digest)
				new_belly.set_messages(new_emotes_digest,"im_digest", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_hold"]))
			var/new_emotes_hold = sanitize(jointext(belly_data["emotes_hold"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_hold)
				new_belly.set_messages(new_emotes_hold,"im_hold", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_holdabsorbed"]))
			var/new_emotes_holdabsorbed = sanitize(jointext(belly_data["emotes_holdabsorbed"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_holdabsorbed)
				new_belly.set_messages(new_emotes_holdabsorbed,"im_holdabsorbed", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_absorb"]))
			var/new_emotes_absorb = sanitize(jointext(belly_data["emotes_absorb"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_absorb)
				new_belly.set_messages(new_emotes_absorb,"im_absorb", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_heal"]))
			var/new_emotes_heal = sanitize(jointext(belly_data["emotes_heal"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_heal)
				new_belly.set_messages(new_emotes_heal,"im_heal", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_drain"]))
			var/new_emotes_drain = sanitize(jointext(belly_data["emotes_drain"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_drain)
				new_belly.set_messages(new_emotes_drain,"im_drain", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_steal"]))
			var/new_emotes_steal = sanitize(jointext(belly_data["emotes_steal"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_steal)
				new_belly.set_messages(new_emotes_steal,"im_steal", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_egg"]))
			var/new_emotes_egg = sanitize(jointext(belly_data["emotes_egg"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_egg)
				new_belly.set_messages(new_emotes_egg,"im_egg", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_shrink"]))
			var/new_emotes_shrink = sanitize(jointext(belly_data["emotes_shrink"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_shrink)
				new_belly.set_messages(new_emotes_shrink,"im_shrink", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_grow"]))
			var/new_emotes_grow = sanitize(jointext(belly_data["emotes_grow"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_grow)
				new_belly.set_messages(new_emotes_grow,"im_grow", limit = MAX_MESSAGE_LEN / 4)

		if(islist(belly_data["emotes_unabsorb"]))
			var/new_emotes_unabsorb = sanitize(jointext(belly_data["emotes_unabsorb"],"\n\n"),MAX_MESSAGE_LEN * 1.5,0,0,0)
			if(new_emotes_unabsorb)
				new_belly.set_messages(new_emotes_unabsorb,"im_unabsorb", limit = MAX_MESSAGE_LEN / 4)

		// Options
		if(isnum(belly_data["can_taste"]))
			var/new_can_taste = belly_data["can_taste"]
			if(new_can_taste == 0)
				new_belly.can_taste = FALSE
			if(new_can_taste == 1)
				new_belly.can_taste = TRUE

		/* Not implemented on virgo
		if(isnum(belly_data["is_feedable"]))
			var/new_is_feedable = belly_data["is_feedable"]
			if(new_is_feedable == 0)
				new_belly.is_feedable = FALSE
			if(new_is_feedable == 1)
				new_belly.is_feedable = TRUE
		*/

		if(isnum(belly_data["contaminates"]))
			var/new_contaminates = belly_data["contaminates"]
			if(new_contaminates == 0)
				new_belly.contaminates = FALSE
			if(new_contaminates == 1)
				new_belly.contaminates = TRUE

		if(istext(belly_data["contamination_flavor"]))
			var/new_contamination_flavor = sanitize(belly_data["contamination_flavor"],MAX_MESSAGE_LEN,0,0,0)
			if(new_contamination_flavor)
				if(new_contamination_flavor in contamination_flavors)
					new_belly.contamination_flavor = new_contamination_flavor

		if(istext(belly_data["contamination_color"]))
			var/new_contamination_color = sanitize(belly_data["contamination_color"],MAX_MESSAGE_LEN,0,0,0)
			if(new_contamination_color)
				if(new_contamination_color in contamination_colors)
					new_belly.contamination_color = new_contamination_color

		if(isnum(belly_data["nutrition_percent"]))
			var/new_nutrition_percent = belly_data["nutrition_percent"]
			new_belly.nutrition_percent = CLAMP(new_nutrition_percent,0.01,100)

		if(isnum(belly_data["bulge_size"]))
			var/new_bulge_size = belly_data["bulge_size"]
			if(new_bulge_size == 0)
				new_belly.bulge_size = 0
			else
				new_belly.bulge_size = CLAMP(new_bulge_size,0.25,2)

		if(isnum(belly_data["display_absorbed_examine"]))
			var/new_display_absorbed_examine = belly_data["display_absorbed_examine"]
			if(new_display_absorbed_examine == 0)
				new_belly.display_absorbed_examine = FALSE
			if(new_display_absorbed_examine == 1)
				new_belly.display_absorbed_examine = TRUE

		if(isnum(belly_data["save_digest_mode"]))
			var/new_save_digest_mode = belly_data["save_digest_mode"]
			if(new_save_digest_mode == 0)
				new_belly.save_digest_mode = FALSE
			if(new_save_digest_mode == 1)
				new_belly.save_digest_mode = TRUE

		if(isnum(belly_data["emote_active"]))
			var/new_emote_active = belly_data["emote_active"]
			if(new_emote_active == 0)
				new_belly.emote_active = FALSE
			if(new_emote_active == 1)
				new_belly.emote_active = TRUE

		if(isnum(belly_data["emote_time"]))
			var/new_emote_time = belly_data["emote_time"]
			new_belly.emote_time = CLAMP(new_emote_time, 60, 600)

		// new_belly.set_zero_digestion_damage() // Not implemented on virgo; needed for importing a belly to overwrite an existing belly; otherwise pre-existing values throw off the unused digestion damage.

		if(isnum(belly_data["digest_brute"]))
			var/new_digest_brute = belly_data["digest_brute"]
			new_belly.digest_brute = CLAMP(new_digest_brute, 0, 6)

		if(isnum(belly_data["digest_burn"]))
			var/new_digest_burn = belly_data["digest_burn"]
			new_belly.digest_burn = CLAMP(new_digest_burn, 0, 6)

		if(isnum(belly_data["digest_oxy"]))
			var/new_digest_oxy = belly_data["digest_oxy"]
			new_belly.digest_oxy = CLAMP(new_digest_oxy, 0, 12)

		if(isnum(belly_data["digest_tox"]))
			var/new_digest_tox = belly_data["digest_tox"]
			new_belly.digest_tox = CLAMP(new_digest_tox, 0, 6)

		if(isnum(belly_data["digest_clone"]))
			var/new_digest_clone = belly_data["digest_clone"]
			new_belly.digest_clone = CLAMP(new_digest_clone, 0, 6)

		if(isnum(belly_data["shrink_grow_size"]))
			var/new_shrink_grow_size = belly_data["shrink_grow_size"]
			new_belly.shrink_grow_size = CLAMP(new_shrink_grow_size, 0.25, 2)

		/* Not implemented on virgo
		if(isnum(belly_data["vorespawn_blacklist"]))
			var/new_vorespawn_blacklist = belly_data["vorespawn_blacklist"]
			if(new_vorespawn_blacklist == 0)
				new_belly.vorespawn_blacklist = FALSE
			if(new_vorespawn_blacklist == 1)
				new_belly.vorespawn_blacklist = TRUE

		if(islist(belly_data["vorespawn_whitelist"]))
			var/new_vorespawn_whitelist = splittext(sanitize(lowertext(jointext(belly_data["vorespawn_whitelist"],"\n")),MAX_MESSAGE_LEN,0,0,0),"\n")
			new_belly.vorespawn_whitelist = new_vorespawn_whitelist

		if(isnum(belly_data["vorespawn_absorbed"]))
			var/new_vorespawn_absorbed = 0
			var/updated_vorespawn_absorbed = belly_data["vorespawn_absorbed"]
			if(updated_vorespawn_absorbed & VS_FLAG_ABSORB_YES)
				new_vorespawn_absorbed |= VS_FLAG_ABSORB_YES
			if(updated_vorespawn_absorbed & VS_FLAG_ABSORB_PREY)
				new_vorespawn_absorbed |= VS_FLAG_ABSORB_YES
				new_vorespawn_absorbed |= VS_FLAG_ABSORB_PREY
			new_belly.vorespawn_absorbed = new_vorespawn_absorbed
		*/

		if(istext(belly_data["egg_type"]))
			var/new_egg_type = sanitize(belly_data["egg_type"],MAX_MESSAGE_LEN,0,0,0)
			if(new_egg_type)
				if(new_egg_type in global_vore_egg_types)
					new_belly.egg_type = new_egg_type

		/* Not implemented on virgo
		if(istext(belly_data["egg_name"]))
			var/new_egg_name = html_encode(belly_data["egg_name"])
			if(new_egg_name)
				new_egg_name = readd_quotes(new_egg_name)
			if(length(new_egg_name) >= BELLIES_NAME_MIN && length(new_egg_name) <= BELLIES_NAME_MAX)
				new_belly.egg_name = new_egg_name

		if(istext(belly_data["egg_size"]))
			var/new_egg_size = belly_data["egg_size"]
			if(new_egg_size == 0)
				new_belly.egg_size = 0
			else
				new_belly.egg_size = CLAMP(new_egg_size,0.25,2)

		if(isnum(belly_data["recycling"]))
			var/new_recycling = belly_data["recycling"]
			if(new_recycling == 0)
				new_belly.recycling = FALSE
			if(new_recycling == 1)
				new_belly.recycling = TRUE

		if(isnum(belly_data["storing_nutrition"]))
			var/new_storing_nutrition = belly_data["storing_nutrition"]
			if(new_storing_nutrition == 0)
				new_belly.storing_nutrition = FALSE
			if(new_storing_nutrition == 1)
				new_belly.storing_nutrition = TRUE

		if(isnum(belly_data["entrance_logs"]))
			var/new_entrance_logs = belly_data["entrance_logs"]
			if(new_entrance_logs == 0)
				new_belly.entrance_logs = FALSE
			if(new_entrance_logs == 1)
				new_belly.entrance_logs = TRUE

		if(isnum(belly_data["item_digest_logs"]))
			var/new_item_digest_logs = belly_data["item_digest_logs"]
			if(new_item_digest_logs == 0)
				new_belly.item_digest_logs = FALSE
			if(new_item_digest_logs == 1)
				new_belly.item_digest_logs = TRUE
			*/

		if(istext(belly_data["selective_preference"]))
			var/new_selective_preference = belly_data["selective_preference"]
			if(new_selective_preference == "Digest")
				new_belly.selective_preference = DM_DIGEST
			if(new_selective_preference == "Absorb")
				new_belly.selective_preference = DM_ABSORB

		/* Not implemented on virgo
		if(isnum(belly_data["private_struggle"]))
			var/new_private_struggle = belly_data["private_struggle"]
			if(new_private_struggle == 0)
				new_belly.private_struggle = FALSE
			if(new_private_struggle == 1)
				new_belly.private_struggle = TRUE
		*/

		if(istext(belly_data["eating_privacy_local"]))
			var/new_eating_privacy_local = html_encode(belly_data["eating_privacy_local"])
			if(new_eating_privacy_local && (new_eating_privacy_local in list("default","subtle","loud")))
				new_belly.eating_privacy_local = new_eating_privacy_local

		// Sounds
		if(isnum(belly_data["is_wet"]))
			var/new_is_wet = belly_data["is_wet"]
			if(new_is_wet == 0)
				new_belly.is_wet = FALSE
			if(new_is_wet == 1)
				new_belly.is_wet = TRUE

		if(isnum(belly_data["wet_loop"]))
			var/new_wet_loop = belly_data["wet_loop"]
			if(new_wet_loop == 0)
				new_belly.wet_loop = FALSE
			if(new_wet_loop == 1)
				new_belly.wet_loop = TRUE

		if(isnum(belly_data["fancy_vore"]))
			var/new_fancy_vore = belly_data["fancy_vore"]
			if(new_fancy_vore == 0)
				new_belly.fancy_vore = FALSE
			if(new_fancy_vore == 1)
				new_belly.fancy_vore = TRUE

		if(new_belly.fancy_vore)
			if(!(new_belly.vore_sound in fancy_vore_sounds))
				new_belly.vore_sound = "Gulp"
			if(!(new_belly.release_sound in fancy_vore_sounds))
				new_belly.release_sound = "Splatter"
		else
			if(!(new_belly.vore_sound in classic_vore_sounds))
				new_belly.vore_sound = "Gulp"
			if(!(new_belly.release_sound in classic_vore_sounds))
				new_belly.release_sound = "Splatter"

		if(istext(belly_data["vore_sound"]))
			var/new_vore_sound = sanitize(belly_data["vore_sound"],MAX_MESSAGE_LEN,0,0,0)
			if(new_vore_sound)
				if (new_belly.fancy_vore && (new_vore_sound in fancy_vore_sounds))
					new_belly.vore_sound = new_vore_sound
				if (!new_belly.fancy_vore && (new_vore_sound in classic_vore_sounds))
					new_belly.vore_sound = new_vore_sound

		if(istext(belly_data["release_sound"]))
			var/new_release_sound = sanitize(belly_data["release_sound"],MAX_MESSAGE_LEN,0,0,0)
			if(new_release_sound)
				if (new_belly.fancy_vore && (new_release_sound in fancy_release_sounds))
					new_belly.release_sound = new_release_sound
				if (!new_belly.fancy_vore && (new_release_sound in classic_release_sounds))
					new_belly.release_sound = new_release_sound

		/* Not implemented on virgo
		if(isnum(belly_data["sound_volume"]))
			var/new_sound_volume = belly_data["sound_volume"]
			new_belly.sound_volume = sanitize_integer(new_sound_volume, 0, 100, initial(new_belly.sound_volume))

		if(isnum(belly_data["noise_freq"]))
			var/new_noise_freq = belly_data["noise_freq"]
			new_belly.noise_freq = sanitize_integer(new_noise_freq, MIN_VOICE_FREQ, MAX_VOICE_FREQ, initial(new_belly.noise_freq))
		*/

		// Visuals
		if(isnum(belly_data["affects_vore_sprites"]))
			var/new_affects_vore_sprites = belly_data["affects_vore_sprites"]
			if(new_affects_vore_sprites == 0)
				new_belly.affects_vore_sprites = FALSE
			if(new_affects_vore_sprites == 1)
				new_belly.affects_vore_sprites = TRUE

		if(islist(belly_data["vore_sprite_flags"]))
			new_belly.vore_sprite_flags = 0
			for(var/sprite_flag in belly_data["vore_sprite_flags"])
				new_belly.vore_sprite_flags += new_belly.vore_sprite_flag_list[sprite_flag]

		if(isnum(belly_data["count_absorbed_prey_for_sprite"]))
			var/new_count_absorbed_prey_for_sprite = belly_data["count_absorbed_prey_for_sprite"]
			if(new_count_absorbed_prey_for_sprite == 0)
				new_belly.count_absorbed_prey_for_sprite = FALSE
			if(new_count_absorbed_prey_for_sprite == 1)
				new_belly.count_absorbed_prey_for_sprite = TRUE

		if(isnum(belly_data["absorbed_multiplier"]))
			var/new_absorbed_multiplier = belly_data["absorbed_multiplier"]
			new_belly.absorbed_multiplier = CLAMP(new_absorbed_multiplier, 0.1, 3)

		if(isnum(belly_data["count_liquid_for_sprite"]))
			var/new_count_liquid_for_sprite = belly_data["count_liquid_for_sprite"]
			if(new_count_liquid_for_sprite == 0)
				new_belly.count_liquid_for_sprite = FALSE
			if(new_count_liquid_for_sprite == 1)
				new_belly.count_liquid_for_sprite = TRUE

		if(isnum(belly_data["liquid_multiplier"]))
			var/new_liquid_multiplier = belly_data["liquid_multiplier"]
			new_belly.liquid_multiplier = CLAMP(new_liquid_multiplier, 0.1, 10)

		if(isnum(belly_data["count_items_for_sprite"]))
			var/new_count_items_for_sprite = belly_data["count_items_for_sprite"]
			if(new_count_items_for_sprite == 0)
				new_belly.count_items_for_sprite = FALSE
			if(new_count_items_for_sprite == 1)
				new_belly.count_items_for_sprite = TRUE

		if(isnum(belly_data["item_multiplier"]))
			var/new_item_multiplier = belly_data["item_multiplier"]
			new_belly.item_multiplier = CLAMP(new_item_multiplier, 0.1, 10)

		if(isnum(belly_data["health_impacts_size"]))
			var/new_health_impacts_size = belly_data["health_impacts_size"]
			if(new_health_impacts_size == 0)
				new_belly.health_impacts_size = FALSE
			if(new_health_impacts_size == 1)
				new_belly.health_impacts_size = TRUE

		if(isnum(belly_data["resist_triggers_animation"]))
			var/new_resist_triggers_animation = belly_data["resist_triggers_animation"]
			if(new_resist_triggers_animation == 0)
				new_belly.resist_triggers_animation = FALSE
			if(new_resist_triggers_animation == 1)
				new_belly.resist_triggers_animation = TRUE

		if(isnum(belly_data["size_factor_for_sprite"]))
			var/new_size_factor_for_sprite = belly_data["size_factor_for_sprite"]
			new_belly.size_factor_for_sprite = CLAMP(new_size_factor_for_sprite, 0.1, 3)

		if(istext(belly_data["belly_sprite_to_affect"]))
			var/new_belly_sprite_to_affect = sanitize(belly_data["belly_sprite_to_affect"],MAX_MESSAGE_LEN,0,0,0)
			if(new_belly_sprite_to_affect)
				if(ishuman(host))
					var/mob/living/carbon/human/H = host
					if (new_belly_sprite_to_affect in H.vore_icon_bellies)
						new_belly.belly_sprite_to_affect = new_belly_sprite_to_affect

		if(istext(belly_data["undergarment_chosen"]))
			var/new_undergarment_chosen = sanitize(belly_data["undergarment_chosen"],MAX_MESSAGE_LEN,0,0,0)
			if(new_undergarment_chosen)
				for(var/datum/category_group/underwear/U in global_underwear.categories)
					if(lowertext(U.name) == lowertext(new_undergarment_chosen))
						new_belly.undergarment_chosen = U.name
						break

		/* Not implemented on virgo
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[new_belly.undergarment_chosen]
		var/invalid_if_none = TRUE
		for(var/datum/category_item/underwear/U in UWC.items)
			if(lowertext(U.name) == lowertext(new_belly.undergarment_if_none))
				invalid_if_none = FALSE
				break
		if(invalid_if_none)
			new_belly.undergarment_if_none = null

		if(istext(belly_data["undergarment_if_none"]))
			var/new_undergarment_if_none = sanitize(belly_data["undergarment_if_none"],MAX_MESSAGE_LEN,0,0,0)
			if(new_undergarment_if_none)
				for(var/datum/category_item/underwear/U in UWC.items)
					if(lowertext(U.name) == lowertext(new_undergarment_if_none))
						new_belly.undergarment_if_none = U.name
						break

		if(istext(belly_data["undergarment_color"]))
			var/new_undergarment_color = sanitize_hexcolor(belly_data["undergarment_color"],new_belly.undergarment_color)
			new_belly.undergarment_color = new_undergarment_color
		*/
		/* These don't seem to actually be available yet
		if(istext(belly_data["tail_to_change_to"]))
			var/new_tail_to_change_to = sanitize(belly_data["tail_to_change_to"],MAX_MESSAGE_LEN,0,0,0)
			if(new_tail_to_change_to)
				if (new_tail_to_change_to in tail_styles_list)
					new_belly.tail_to_change_to = new_tail_to_change_to

		if(istext(belly_data["tail_colouration"]))
			var/new_tail_colouration = sanitize_hexcolor(belly_data["tail_colouration"],new_belly.tail_colouration)
			new_belly.tail_colouration = new_tail_colouration

		if(istext(belly_data["tail_extra_overlay"]))
			var/new_tail_extra_overlay = sanitize_hexcolor(belly_data["tail_extra_overlay"],new_belly.tail_extra_overlay)
			new_belly.tail_extra_overlay = new_tail_extra_overlay

		if(istext(belly_data["tail_extra_overlay2"]))
			var/new_tail_extra_overlay2 = sanitize_hexcolor(belly_data["tail_extra_overlay2"],new_belly.tail_extra_overlay2)
			new_belly.tail_extra_overlay2 = new_tail_extra_overlay2
		*/
		if(istext(belly_data["belly_fullscreen_color"]))
			var/new_belly_fullscreen_color = sanitize_hexcolor(belly_data["belly_fullscreen_color"],new_belly.belly_fullscreen_color)
			new_belly.belly_fullscreen_color = new_belly_fullscreen_color

		if(istext(belly_data["belly_fullscreen_color_secondary"]))
			var/new_belly_fullscreen_color_secondary = sanitize_hexcolor(belly_data["belly_fullscreen_color_secondary"],new_belly.belly_fullscreen_color_secondary)
			new_belly.belly_fullscreen_color_secondary = new_belly_fullscreen_color_secondary
		else if (istext(belly_data["belly_fullscreen_color2"])) // Inter server support between virgo and chomp!
			var/new_belly_fullscreen_color_secondary = sanitize_hexcolor(belly_data["belly_fullscreen_color2"],new_belly.belly_fullscreen_color_secondary)
			new_belly.belly_fullscreen_color_secondary = new_belly_fullscreen_color_secondary

		if(istext(belly_data["belly_fullscreen_color_trinary"]))// Inter server support between virgo and chomp!
			var/new_belly_fullscreen_color_trinary = sanitize_hexcolor(belly_data["belly_fullscreen_color_trinary"],new_belly.belly_fullscreen_color_trinary)
			new_belly.belly_fullscreen_color_trinary = new_belly_fullscreen_color_trinary
		else if(istext(belly_data["belly_fullscreen_color3"]))
			var/new_belly_fullscreen_color_trinary = sanitize_hexcolor(belly_data["belly_fullscreen_color3"],new_belly.belly_fullscreen_color_trinary)
			new_belly.belly_fullscreen_color_trinary = new_belly_fullscreen_color_trinary

		/* Not implemented on virgo
		if(istext(belly_data["belly_fullscreen_color4"]))
			var/new_belly_fullscreen_color4 = sanitize_hexcolor(belly_data["belly_fullscreen_color4"],new_belly.belly_fullscreen_color4)
			new_belly.belly_fullscreen_color4 = new_belly_fullscreen_color4

		if(istext(belly_data["belly_fullscreen_alpha"]))
			var/new_belly_fullscreen_alpha = sanitize_integer(belly_data["belly_fullscreen_alpha"],0,255,initial(new_belly.belly_fullscreen_alpha))
			new_belly.belly_fullscreen_alpha = new_belly_fullscreen_alpha
		*/

		if(isnum(belly_data["colorization_enabled"]))
			var/new_colorization_enabled = belly_data["colorization_enabled"]
			if(new_colorization_enabled == 0)
				new_belly.colorization_enabled = FALSE
			if(new_colorization_enabled == 1)
				new_belly.colorization_enabled = TRUE

		if(isnum(belly_data["disable_hud"]))
			var/new_disable_hud = belly_data["disable_hud"]
			if(new_disable_hud == 0)
				new_belly.disable_hud = FALSE
			if(new_disable_hud == 1)
				new_belly.disable_hud = TRUE

		var/possible_fullscreens = icon_states('icons/mob/screen_full_colorized_vore.dmi')
		if(!new_belly.colorization_enabled)
			possible_fullscreens = icon_states('icons/mob/screen_full_vore.dmi')
			possible_fullscreens -= "a_synth_flesh_mono"
			possible_fullscreens -= "a_synth_flesh_mono_hole"
			possible_fullscreens -= "a_anim_belly"
		if(!(new_belly.belly_fullscreen in possible_fullscreens))
			new_belly.belly_fullscreen = ""

		if(istext(belly_data["belly_fullscreen"]))
			var/new_belly_fullscreen = sanitize(belly_data["belly_fullscreen"],MAX_MESSAGE_LEN,0,0,0)
			if(new_belly_fullscreen)
				if(new_belly_fullscreen in possible_fullscreens)
					new_belly.belly_fullscreen = new_belly_fullscreen

		// Interactions
		if(isnum(belly_data["escapable"]))
			var/new_escapable = belly_data["escapable"]
			if(new_escapable == 0)
				new_belly.escapable = FALSE
			if(new_escapable == 1)
				new_belly.escapable = TRUE

		if(isnum(belly_data["escapechance"]))
			var/new_escapechance = belly_data["escapechance"]
			new_belly.escapechance = sanitize_integer(new_escapechance, 0, 100, initial(new_belly.escapechance))

		if(isnum(belly_data["escapechance_absorbed"]))
			var/new_escapechance_absorbed = belly_data["escapechance_absorbed"]
			new_belly.escapechance_absorbed = sanitize_integer(new_escapechance_absorbed, 0, 100, initial(new_belly.escapechance_absorbed))


		if(isnum(belly_data["escapetime"]))
			var/new_escapetime = belly_data["escapetime"]
			new_belly.escapetime = sanitize_integer(new_escapetime*10, 10, 600, initial(new_belly.escapetime))

		if(isnum(belly_data["transferchance"]))
			var/new_transferchance = belly_data["transferchance"]
			new_belly.transferchance = sanitize_integer(new_transferchance, 0, 100, initial(new_belly.transferchance))

		if(istext(belly_data["transferlocation"]))
			var/new_transferlocation = sanitize(belly_data["transferlocation"],MAX_MESSAGE_LEN,0,0,0)
			if(new_transferlocation)
				for(var/obj/belly/existing_belly in host.vore_organs)
					if(existing_belly.name == new_transferlocation)
						new_belly.transferlocation = new_transferlocation
						break
				if(new_transferlocation in valid_names)
					new_belly.transferlocation = new_transferlocation
				if(new_transferlocation == new_belly.name)
					new_belly.transferlocation = null

		if(isnum(belly_data["transferchance_secondary"]))
			var/new_transferchance_secondary = belly_data["transferchance_secondary"]
			new_belly.transferchance_secondary = sanitize_integer(new_transferchance_secondary, 0, 100, initial(new_belly.transferchance_secondary))

		if(istext(belly_data["transferlocation_secondary"]))
			var/new_transferlocation_secondary = sanitize(belly_data["transferlocation_secondary"],MAX_MESSAGE_LEN,0,0,0)
			if(new_transferlocation_secondary)
				for(var/obj/belly/existing_belly in host.vore_organs)
					if(existing_belly.name == new_transferlocation_secondary)
						new_belly.transferlocation_secondary = new_transferlocation_secondary
						break
				if(new_transferlocation_secondary in valid_names)
					new_belly.transferlocation_secondary = new_transferlocation_secondary
				if(new_transferlocation_secondary == new_belly.name)
					new_belly.transferlocation_secondary = null

		/* Not implemented on virgo
		if(islist(belly_data["autotransfer_whitelist"]))
			new_belly.autotransfer_whitelist = 0
			for(var/at_flag in belly_data["autotransfer_whitelist"])
				new_belly.autotransfer_whitelist += new_belly.autotransfer_flags_list[at_flag]

		if(islist(belly_data["autotransfer_blacklist"]))
			new_belly.autotransfer_blacklist = 0
			for(var/at_flag in belly_data["autotransfer_blacklist"])
				new_belly.autotransfer_blacklist += new_belly.autotransfer_flags_list[at_flag]

		if(islist(belly_data["autotransfer_secondary_whitelist"]))
			new_belly.autotransfer_secondary_whitelist = 0
			for(var/at_flag in belly_data["autotransfer_secondary_whitelist"])
				new_belly.autotransfer_secondary_whitelist += new_belly.autotransfer_flags_list[at_flag]

		if(islist(belly_data["autotransfer_secondary_blacklist"]))
			new_belly.autotransfer_secondary_blacklist = 0
			for(var/at_flag in belly_data["autotransfer_secondary_blacklist"])
				new_belly.autotransfer_secondary_blacklist += new_belly.autotransfer_flags_list[at_flag]
		*/

		if(isnum(belly_data["absorbchance"]))
			var/new_absorbchance = belly_data["absorbchance"]
			new_belly.absorbchance = sanitize_integer(new_absorbchance, 0, 100, initial(new_belly.absorbchance))

		if(isnum(belly_data["digestchance"]))
			var/new_digestchance = belly_data["digestchance"]
			new_belly.digestchance = sanitize_integer(new_digestchance, 0, 100, initial(new_belly.digestchance))

		/* Not implemented on virgo
		if(isnum(belly_data["autotransfer_enabled"]))
			var/new_autotransfer_enabled = belly_data["autotransfer_enabled"]
			if(new_autotransfer_enabled == 0)
				new_belly.autotransfer_enabled = FALSE
			if(new_autotransfer_enabled == 1)
				new_belly.autotransfer_enabled = TRUE
		*/

		if(isnum(belly_data["autotransferwait"]))
			var/new_autotransferwait = belly_data["autotransferwait"]
			new_belly.autotransferwait = sanitize_integer(new_autotransferwait*10, 10, 18000, initial(new_belly.autotransferwait))

		if(isnum(belly_data["autotransferchance"]))
			var/new_autotransferchance = belly_data["autotransferchance"]
			new_belly.autotransferchance = sanitize_integer(new_autotransferchance, 0, 100, initial(new_belly.autotransferchance))

		if(istext(belly_data["autotransferlocation"]))
			var/new_autotransferlocation = sanitize(belly_data["autotransferlocation"],MAX_MESSAGE_LEN,0,0,0)
			if(new_autotransferlocation)
				for(var/obj/belly/existing_belly in host.vore_organs)
					if(existing_belly.name == new_autotransferlocation)
						new_belly.autotransferlocation = new_autotransferlocation
						break
				if(new_autotransferlocation in valid_names)
					new_belly.autotransferlocation = new_autotransferlocation
				if(new_autotransferlocation == new_belly.name)
					new_belly.autotransferlocation = null

		/* Not implemented on virgo
		if(islist(belly_data["autotransferextralocation"]))
			var/new_autotransferextralocation = belly_data["autotransferextralocation"]
			if(new_autotransferextralocation)
				new_belly.autotransferextralocation = list()
				for(var/extra_belly in new_autotransferextralocation)
					if(extra_belly in valid_names)
						new_belly.autotransferextralocation += extra_belly

		if(isnum(belly_data["autotransferchance_secondary"]))
			var/new_autotransferchance_secondary = belly_data["autotransferchance_secondary"]
			new_belly.autotransferchance_secondary = sanitize_integer(new_autotransferchance_secondary, 0, 100, initial(new_belly.autotransferchance_secondary))

		if(istext(belly_data["autotransferlocation_secondary"]))
			var/new_autotransferlocation_secondary = sanitize(belly_data["autotransferlocation_secondary"],MAX_MESSAGE_LEN,0,0,0)
			if(new_autotransferlocation_secondary)
				for(var/obj/belly/existing_belly in host.vore_organs)
					if(existing_belly.name == new_autotransferlocation_secondary)
						new_belly.autotransferlocation_secondary = new_autotransferlocation_secondary
						break
				if(new_autotransferlocation_secondary in valid_names)
					new_belly.autotransferlocation_secondary = new_autotransferlocation_secondary
				if(new_autotransferlocation_secondary == new_belly.name)
					new_belly.autotransferlocation_secondary = null

		if(islist(belly_data["autotransferextralocation_secondary"]))
			var/new_autotransferextralocation_secondary = belly_data["autotransferextralocation_secondary"]
			if(new_autotransferextralocation_secondary)
				new_belly.autotransferextralocation_secondary = list()
				for(var/extra_belly in new_autotransferextralocation_secondary)
					if(extra_belly in valid_names)
						new_belly.autotransferextralocation_secondary += extra_belly


		if(isnum(belly_data["autotransfer_min_amount"]))
			var/new_autotransfer_min_amount = belly_data["autotransfer_min_amount"]
			new_belly.autotransfer_min_amount = sanitize_integer(new_autotransfer_min_amount, 0, 100, initial(new_belly.autotransfer_min_amount))

		if(isnum(belly_data["autotransfer_max_amount"]))
			var/new_autotransfer_max_amount = belly_data["autotransfer_max_amount"]
			new_belly.autotransfer_max_amount = sanitize_integer(new_autotransfer_max_amount, 0, 100, initial(new_belly.autotransfer_max_amount))

		if(isnum(belly_data["belchchance"]))
			var/new_belchchance = belly_data["belchchance"]
			new_belly.belchchance = sanitize_integer(new_belchchance, 0, 100, initial(new_belly.belchchance))

		// Liquid Options
		if(isnum(belly_data["show_liquids"]))
			var/new_show_liquids = belly_data["show_liquids"]
			if(new_show_liquids == 0)
				new_belly.show_liquids = FALSE
			if(new_show_liquids == 1)
				new_belly.show_liquids = TRUE

		if(isnum(belly_data["reagentbellymode"]))
			var/new_reagentbellymode = belly_data["reagentbellymode"]
			if(new_reagentbellymode == 0)
				new_belly.reagentbellymode = FALSE
			if(new_reagentbellymode == 1)
				new_belly.reagentbellymode = TRUE

		if(istext(belly_data["reagent_chosen"]))
			var/new_reagent_chosen = sanitize(belly_data["reagent_chosen"],MAX_MESSAGE_LEN,0,0,0)
			if(new_reagent_chosen)
				if(new_reagent_chosen in new_belly.reagent_choices)
					new_belly.reagent_chosen = new_reagent_chosen
					new_belly.ReagentSwitch()

		if(istext(belly_data["reagent_name"]))
			var/new_reagent_name = html_encode(belly_data["reagent_name"])
			if(new_reagent_name)
				new_reagent_name = readd_quotes(new_reagent_name)
			if(length(new_reagent_name) >= BELLIES_NAME_MIN && length(new_reagent_name) <= BELLIES_NAME_MAX)
				new_belly.reagent_name = new_reagent_name

		if(istext(belly_data["reagent_transfer_verb"]))
			var/new_reagent_transfer_verb = html_encode(belly_data["reagent_transfer_verb"])
			if(new_reagent_transfer_verb)
				new_reagent_transfer_verb = readd_quotes(new_reagent_transfer_verb)
			if(length(new_reagent_transfer_verb) >= BELLIES_NAME_MIN && length(new_reagent_transfer_verb) <= BELLIES_NAME_MAX)
				new_belly.reagent_transfer_verb = new_reagent_transfer_verb

		if(istext(belly_data["gen_time_display"]))
			var/new_gen_time_display = sanitize(belly_data["gen_time_display"],MAX_MESSAGE_LEN,0,0,0)
			if(new_gen_time_display)
				if(new_gen_time_display in list("10 minutes","30 minutes","1 hour","3 hours","6 hours","12 hours","24 hours"))
					new_belly.gen_time_display = new_gen_time_display
					switch(new_gen_time_display)
						if("10 minutes")
							new_belly.gen_time = 0
						if("30 minutes")
							new_belly.gen_time = 2
						if("1 hour")
							new_belly.gen_time = 5
						if("3 hours")
							new_belly.gen_time = 17
						if("6 hours")
							new_belly.gen_time = 35
						if("12 hours")
							new_belly.gen_time = 71
						if("24 hours")
							new_belly.gen_time = 143

		if(isnum(belly_data["custom_max_volume"]))
			var/new_custom_max_volume = belly_data["custom_max_volume"]
			new_belly.custom_max_volume = CLAMP(new_custom_max_volume, 10, 300)

		if(isnum(belly_data["vorefootsteps_sounds"]))
			var/new_vorefootsteps_sounds = belly_data["vorefootsteps_sounds"]
			if(new_vorefootsteps_sounds == 0)
				new_belly.vorefootsteps_sounds = FALSE
			if(new_vorefootsteps_sounds == 1)
				new_belly.vorefootsteps_sounds = TRUE

		if(islist(belly_data["reagent_mode_flag_list"]))
			new_belly.reagent_mode_flags = 0
			for(var/reagent_flag in belly_data["reagent_mode_flag_list"])
				new_belly.reagent_mode_flags += new_belly.reagent_mode_flag_list[reagent_flag]

		if(istext(belly_data["custom_reagentcolor"]))
			var/custom_reagentcolor = sanitize_hexcolor(belly_data["custom_reagentcolor"],new_belly.custom_reagentcolor)
			new_belly.custom_reagentcolor = custom_reagentcolor

		if(istext(belly_data["mush_color"]))
			var/mush_color = sanitize_hexcolor(belly_data["mush_color"],new_belly.mush_color)
			new_belly.mush_color = mush_color

		if(istext(belly_data["mush_alpha"]))
			var/new_mush_alpha = sanitize_integer(belly_data["mush_alpha"],0,255,initial(new_belly.mush_alpha))
			new_belly.mush_alpha = new_mush_alpha

		if(isnum(belly_data["max_mush"]))
			var/max_mush = belly_data["max_mush"]
			new_belly.max_mush = CLAMP(max_mush, 0, 6000)

		if(isnum(belly_data["min_mush"]))
			var/min_mush = belly_data["min_mush"]
			new_belly.min_mush = CLAMP(min_mush, 0, 100)

		if(isnum(belly_data["item_mush_val"]))
			var/item_mush_val = belly_data["item_mush_val"]
			new_belly.item_mush_val = CLAMP(item_mush_val, 0, 1000)

		if(isnum(belly_data["liquid_overlay"]))
			var/new_liquid_overlay = belly_data["liquid_overlay"]
			if(new_liquid_overlay == 0)
				new_belly.liquid_overlay = FALSE
			if(new_liquid_overlay == 1)
				new_belly.liquid_overlay = TRUE

		if(isnum(belly_data["max_liquid_level"]))
			var/max_liquid_level = belly_data["max_liquid_level"]
			new_belly.max_liquid_level = CLAMP(max_liquid_level, 0, 100)

		if(isnum(belly_data["reagent_touches"]))
			var/new_reagent_touches = belly_data["reagent_touches"]
			if(new_reagent_touches == 0)
				new_belly.reagent_touches = FALSE
			if(new_reagent_touches == 1)
				new_belly.reagent_touches = TRUE

		if(isnum(belly_data["mush_overlay"]))
			var/new_mush_overlay = belly_data["mush_overlay"]
			if(new_mush_overlay == 0)
				new_belly.mush_overlay = FALSE
			if(new_mush_overlay == 1)
				new_belly.mush_overlay = TRUE

		// Liquid Messages
		if(isnum(belly_data["show_fullness_messages"]))
			var/new_show_fullness_messages = belly_data["show_fullness_messages"]
			if(new_show_fullness_messages == 0)
				new_belly.show_fullness_messages = FALSE
			if(new_show_fullness_messages == 1)
				new_belly.show_fullness_messages = TRUE

		if(isnum(belly_data["liquid_fullness1_messages"]))
			var/new_liquid_fullness1_messages = belly_data["liquid_fullness1_messages"]
			if(new_liquid_fullness1_messages == 0)
				new_belly.liquid_fullness1_messages = FALSE
			if(new_liquid_fullness1_messages == 1)
				new_belly.liquid_fullness1_messages = TRUE

		if(isnum(belly_data["liquid_fullness2_messages"]))
			var/new_liquid_fullness2_messages = belly_data["liquid_fullness2_messages"]
			if(new_liquid_fullness2_messages == 0)
				new_belly.liquid_fullness2_messages = FALSE
			if(new_liquid_fullness2_messages == 1)
				new_belly.liquid_fullness2_messages = TRUE

		if(isnum(belly_data["liquid_fullness3_messages"]))
			var/new_liquid_fullness3_messages = belly_data["liquid_fullness3_messages"]
			if(new_liquid_fullness3_messages == 0)
				new_belly.liquid_fullness3_messages = FALSE
			if(new_liquid_fullness3_messages == 1)
				new_belly.liquid_fullness3_messages = TRUE

		if(isnum(belly_data["liquid_fullness4_messages"]))
			var/new_liquid_fullness4_messages = belly_data["liquid_fullness4_messages"]
			if(new_liquid_fullness4_messages == 0)
				new_belly.liquid_fullness4_messages = FALSE
			if(new_liquid_fullness4_messages == 1)
				new_belly.liquid_fullness4_messages = TRUE

		if(isnum(belly_data["liquid_fullness5_messages"]))
			var/new_liquid_fullness5_messages = belly_data["liquid_fullness5_messages"]
			if(new_liquid_fullness5_messages == 0)
				new_belly.liquid_fullness5_messages = FALSE
			if(new_liquid_fullness5_messages == 1)
				new_belly.liquid_fullness5_messages = TRUE

		if(islist(belly_data["fullness1_messages"]))
			var/new_fullness1_messages = sanitize(jointext(belly_data["fullness1_messages"],"\n\n"),MAX_MESSAGE_LEN,0,0,0)
			if(new_fullness1_messages)
				new_belly.set_reagent_messages(new_fullness1_messages,"full1")

		if(islist(belly_data["fullness2_messages"]))
			var/new_fullness2_messages = sanitize(jointext(belly_data["fullness2_messages"],"\n\n"),MAX_MESSAGE_LEN,0,0,0)
			if(new_fullness2_messages)
				new_belly.set_reagent_messages(new_fullness2_messages,"full2")

		if(islist(belly_data["fullness3_messages"]))
			var/new_fullness3_messages = sanitize(jointext(belly_data["fullness3_messages"],"\n\n"),MAX_MESSAGE_LEN,0,0,0)
			if(new_fullness3_messages)
				new_belly.set_reagent_messages(new_fullness3_messages,"full3")

		if(islist(belly_data["fullness4_messages"]))
			var/new_fullness4_messages = sanitize(jointext(belly_data["fullness4_messages"],"\n\n"),MAX_MESSAGE_LEN,0,0,0)
			if(new_fullness4_messages)
				new_belly.set_reagent_messages(new_fullness4_messages,"full4")

		if(islist(belly_data["fullness5_messages"]))
			var/new_fullness5_messages = sanitize(jointext(belly_data["fullness5_messages"],"\n\n"),MAX_MESSAGE_LEN,0,0,0)
			if(new_fullness5_messages)
				new_belly.set_reagent_messages(new_fullness5_messages,"full5")
		*/

		// After import updates
		new_belly.items_preserved.Cut()
		// new_belly.update_internal_overlay() // Signal not implemented!

	if(ishuman(host))
		var/mob/living/carbon/human/H = host
		H.update_fullness()
	host.updateVRPanel()
	unsaved_changes = TRUE
