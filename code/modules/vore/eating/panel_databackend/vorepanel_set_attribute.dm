/datum/vore_look/proc/set_attr(mob/user, params)
	if(!host.vore_selected)
		tgui_alert_async(user, "No belly selected to modify.")
		return FALSE
	var/attr = params["attribute"]
	switch(attr)
		if("b_name")
			var/new_name = html_encode(params["val"])

			var/failure_msg
			if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
				failure_msg = "Entered belly name length invalid (must be longer than [BELLIES_NAME_MIN], no more than than [BELLIES_NAME_MAX])."
			// else if(whatever) //Next test here.
			else
				for(var/obj/belly/B as anything in host.vore_organs)
					if(lowertext(new_name) == lowertext(B.name))
						failure_msg = "No duplicate belly names, please."
						break

			if(failure_msg) //Something went wrong.
				tgui_alert_async(user,failure_msg,"Error!")
				return FALSE

			host.vore_selected.name = new_name
			. = TRUE
		if("b_display_name")
			var/new_name = html_encode(params["val"])
			if(length(new_name) > BELLIES_NAME_MAX)
				return FALSE
			host.vore_selected.display_name = new_name
			. = TRUE
		if("b_message_mode")
			host.vore_selected.message_mode = !host.vore_selected.message_mode
			. = TRUE
		if("b_wetness")
			host.vore_selected.is_wet = !host.vore_selected.is_wet
			. = TRUE
		if("b_wetloop")
			host.vore_selected.wet_loop = !host.vore_selected.wet_loop
			. = TRUE
		if("b_mode")
			var/new_mode = params["val"]
			if(!(new_mode in host.vore_selected.digest_modes))
				return FALSE

			host.vore_selected.digest_mode = new_mode
			host.vore_selected.updateVRPanels()
			. = TRUE
		if("b_addons")
			var/toggle_addon = params["val"]
			if(!(toggle_addon in host.vore_selected.mode_flag_list))
				return FALSE
			host.vore_selected.mode_flags ^= host.vore_selected.mode_flag_list[toggle_addon]
			host.vore_selected.items_preserved.Cut() //Re-evaltuate all items in belly on
			host.vore_selected.slow_digestion = FALSE
			if(host.vore_selected.mode_flags & DM_FLAG_SLOWBODY)
				host.vore_selected.slow_digestion = TRUE
			if(toggle_addon == "TURBO MODE")
				STOP_PROCESSING(SSbellies, host.vore_selected)
				STOP_PROCESSING(SSobj, host.vore_selected)
				if(host.vore_selected.mode_flags & DM_FLAG_TURBOMODE)
					host.vore_selected.speedy_mob_processing = TRUE
					START_PROCESSING(SSobj, host.vore_selected)
					to_chat(user, span_warning("TURBO MODE activated! Belly processing speed tripled! This also affects timed settings, such as autotransfer and liquid generation."))
				else
					host.vore_selected.speedy_mob_processing = FALSE
					START_PROCESSING(SSbellies, host.vore_selected)
					to_chat(user, span_warning("TURBO MODE deactivated. Belly processing returned to normal speed."))
			. = TRUE
		if("b_item_mode")
			var/new_mode = params["val"]
			if(!(new_mode in host.vore_selected.item_digest_modes))
				return FALSE

			host.vore_selected.item_digest_mode = new_mode
			host.vore_selected.items_preserved.Cut() //Re-evaltuate all items in belly on belly-mode change
			. = TRUE
		if("b_contaminates") // Reverting upstream's change because why reset save files due to a different server's drama?
			host.vore_selected.contaminates = !host.vore_selected.contaminates
			. = TRUE
		if("b_contamination_flavor")
			var/new_flavor = params["val"]
			if(!(new_flavor in GLOB.contamination_flavors))
				return FALSE
			host.vore_selected.contamination_flavor = new_flavor
			. = TRUE
		if("b_contamination_color")
			var/new_color = params["val"]
			if(!(new_color in GLOB.contamination_colors))
				return FALSE
			host.vore_selected.contamination_color = new_color
			host.vore_selected.items_preserved.Cut() //To re-contaminate for new color
			. = TRUE
		if("b_egg_type")
			var/new_egg_type = params["val"]
			if(!(new_egg_type in GLOB.global_vore_egg_types))
				return FALSE
			host.vore_selected.egg_type = new_egg_type
			. = TRUE
		if("b_egg_name")
			var/new_egg_name = sanitize(params["val"], BELLIES_NAME_MAX, FALSE, TRUE, FALSE)
			if(!new_egg_name)
				host.vore_selected.egg_name = null
			else
				host.vore_selected.egg_name = new_egg_name
			. = TRUE
		if("b_egg_size")
			var/new_egg_size = text2num(params["val"])
			if(!isnum(new_egg_size))
				return FALSE
			if(new_egg_size == 0) //Disable.
				host.vore_selected.egg_size = 0
				to_chat(user,span_notice("Eggs will automatically calculate size depending on contents."))
			else
				new_egg_size = CLAMP(new_egg_size, 25, 200)
				host.vore_selected.egg_size = (new_egg_size/100)
			. = TRUE
		if("b_recycling")
			host.vore_selected.recycling = !host.vore_selected.recycling
			. = TRUE
		if("b_storing_nutrition")
			host.vore_selected.storing_nutrition = !host.vore_selected.storing_nutrition
			. = TRUE
		if(BELLY_DESCRIPTION_MESSAGE)
			var/new_desc = html_encode(params["val"])

			if(new_desc)
				new_desc = readd_quotes(new_desc)
				if(length(new_desc) > BELLIES_DESC_MAX)
					tgui_alert_async(user, "Entered belly desc too long. [BELLIES_DESC_MAX] character limit.","Error")
					return FALSE
				host.vore_selected.desc = new_desc
				. = TRUE
		if(BELLY_DESCRIPTION_MESSAGE_ABSROED)
			var/new_desc = html_encode(params["val"])

			if(new_desc)
				new_desc = readd_quotes(new_desc)
				if(length(new_desc) > BELLIES_DESC_MAX)
					tgui_alert_async(user, "Entered belly desc too long. [BELLIES_DESC_MAX] character limit.","Error")
					return FALSE
				host.vore_selected.absorbed_desc = new_desc
				. = TRUE
		if("b_msgs")
			switch(params["msgtype"])
				if(DIGEST_PREY)
					host.vore_selected.set_messages(params["val"], DIGEST_PREY, limit = BELLIES_MESSAGE_MAX)

				if(DIGEST_OWNER)
					host.vore_selected.set_messages(params["val"], DIGEST_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ABSORB_PREY)
					host.vore_selected.set_messages(params["val"], ABSORB_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ABSORB_OWNER)
					host.vore_selected.set_messages(params["val"], ABSORB_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(UNABSORBS_PREY)
					host.vore_selected.set_messages(params["val"], UNABSORBS_PREY, limit = BELLIES_MESSAGE_MAX)

				if(UNABSORBS_OWNER)
					host.vore_selected.set_messages(params["val"], UNABSORBS_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(STRUGGLE_OUTSIDE)
					host.vore_selected.set_messages(params["val"], STRUGGLE_OUTSIDE, limit = BELLIES_MESSAGE_MAX)

				if(STRUGGLE_INSIDE)
					host.vore_selected.set_messages(params["val"], STRUGGLE_INSIDE, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_STRUGGLE_OUSIDE)
					host.vore_selected.set_messages(params["val"], ABSORBED_STRUGGLE_OUSIDE, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_STRUGGLE_INSIDE)
					host.vore_selected.set_messages(params["val"], ABSORBED_STRUGGLE_INSIDE, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_ATTEMPT_PREY)
					host.vore_selected.set_messages(params["val"], ESCAPE_ATTEMPT_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_ATTEMPT_OWNER)
					host.vore_selected.set_messages(params["val"], ESCAPE_ATTEMPT_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_PREY)
					host.vore_selected.set_messages(params["val"], ESCAPE_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_OWNER)
					host.vore_selected.set_messages(params["val"], ESCAPE_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_OUTSIDE)
					host.vore_selected.set_messages(params["val"], ESCAPE_OUTSIDE, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_ITEM_PREY)
					host.vore_selected.set_messages(params["val"], ESCAPE_ITEM_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_ITEM_OWNER)
					host.vore_selected.set_messages(params["val"], ESCAPE_ITEM_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_ITEM_OUTSIDE)
					host.vore_selected.set_messages(params["val"], ESCAPE_ITEM_OUTSIDE, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_FAIL_PREY)
					host.vore_selected.set_messages(params["val"], ESCAPE_FAIL_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ESCAPE_FAIL_OWNER)
					host.vore_selected.set_messages(params["val"], ESCAPE_FAIL_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_ESCAPE_ATTEMPT_PREY)
					host.vore_selected.set_messages(params["val"], ABSORBED_ESCAPE_ATTEMPT_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_ESCAPE_ATTEMPT_OWNER)
					host.vore_selected.set_messages(params["val"], ABSORBED_ESCAPE_ATTEMPT_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_ESCAPE_PREY)
					host.vore_selected.set_messages(params["val"], ABSORBED_ESCAPE_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_ESCAPE_OWNER)
					host.vore_selected.set_messages(params["val"], ABSORBED_ESCAPE_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_ESCAPE_OUTSIDE)
					host.vore_selected.set_messages(params["val"], ABSORBED_ESCAPE_OUTSIDE, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_ESCAPE_FAIL_PREY)
					host.vore_selected.set_messages(params["val"], ABSORBED_ESCAPE_FAIL_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ABSORBED_ESCAPE_FAIL_OWNER)
					host.vore_selected.set_messages(params["val"], ABSORBED_ESCAPE_FAIL_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(PRIMARY_TRANSFER_PREY)
					host.vore_selected.set_messages(params["val"], PRIMARY_TRANSFER_PREY, limit = BELLIES_MESSAGE_MAX)

				if(PRIMARY_TRANSFER_OWNER)
					host.vore_selected.set_messages(params["val"], PRIMARY_TRANSFER_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(SECONDARY_TRANSFER_PREY)
					host.vore_selected.set_messages(params["val"], SECONDARY_TRANSFER_PREY, limit = BELLIES_MESSAGE_MAX)

				if(SECONDARY_TRANSFER_OWNER)
					host.vore_selected.set_messages(params["val"], SECONDARY_TRANSFER_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(PRIMARY_AUTO_TRANSFER_PREY)
					host.vore_selected.set_messages(params["val"], PRIMARY_AUTO_TRANSFER_PREY, limit = BELLIES_MESSAGE_MAX)

				if(PRIMARY_AUTO_TRANSFER_OWNER)
					host.vore_selected.set_messages(params["val"], PRIMARY_AUTO_TRANSFER_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(SECONDARY_AUTO_TRANSFER_PREY)
					host.vore_selected.set_messages(params["val"], SECONDARY_AUTO_TRANSFER_PREY, limit = BELLIES_MESSAGE_MAX)

				if(SECONDARY_AUTO_TRANSFER_OWNER)
					host.vore_selected.set_messages(params["val"], SECONDARY_AUTO_TRANSFER_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(DIGEST_CHANCE_PREY)
					host.vore_selected.set_messages(params["val"], DIGEST_CHANCE_PREY, limit = BELLIES_MESSAGE_MAX)

				if(DIGEST_CHANCE_OWNER)
					host.vore_selected.set_messages(params["val"], DIGEST_CHANCE_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(ABSORB_CHANCE_PREY)
					host.vore_selected.set_messages(params["val"], ABSORB_CHANCE_PREY, limit = BELLIES_MESSAGE_MAX)

				if(ABSORB_CHANCE_OWNER)
					host.vore_selected.set_messages(params["val"], ABSORB_CHANCE_OWNER, limit = BELLIES_MESSAGE_MAX)

				if(EXAMINES)
					host.vore_selected.set_messages(params["val"], EXAMINES, limit = BELLIES_EXAMINE_MAX)

				if(EXAMINES_ABSORBED)
					host.vore_selected.set_messages(params["val"], EXAMINES_ABSORBED, limit = BELLIES_EXAMINE_MAX)

				if(GENERAL_EXAMINE_NUTRI)
					sanitize_fixed_list(params["val"], GENERAL_EXAMINE_NUTRI, limit = BELLIES_EXAMINE_MAX)

				if(GENERAL_EXAMINE_WEIGHT)
					sanitize_fixed_list(params["val"], GENERAL_EXAMINE_WEIGHT, limit = BELLIES_EXAMINE_MAX)

				if(BELLY_TRASH_EATER_IN)
					host.vore_selected.set_messages(params["val"], BELLY_TRASH_EATER_IN, limit = BELLIES_MESSAGE_MAX)

				if(BELLY_TRASH_EATER_OUT)
					host.vore_selected.set_messages(params["val"], BELLY_TRASH_EATER_OUT, limit = BELLIES_MESSAGE_MAX)

				if(BELLY_MODE_DIGEST)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_DIGEST, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_HOLD)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_HOLD, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_HOLD_ABSORB)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_HOLD_ABSORB, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_ABSORB)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_ABSORB, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_HEAL)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_HEAL, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_DRAIN)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_DRAIN, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_STEAL)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_STEAL, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_EGG)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_EGG, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_SHRINK)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_SHRINK, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_GROW)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_GROW, limit = BELLIES_IDLE_MAX)

				if(BELLY_MODE_UNABSORB)
					host.vore_selected.set_messages(params["val"], BELLY_MODE_UNABSORB, limit = BELLIES_IDLE_MAX)

				if(BELLY_LIQUID_MESSAGE1)
					host.vore_selected.set_messages(params["val"], BELLY_LIQUID_MESSAGE1, limit = BELLIES_MESSAGE_MAX)

				if(BELLY_LIQUID_MESSAGE2)
					host.vore_selected.set_messages(params["val"], BELLY_LIQUID_MESSAGE2, limit = BELLIES_MESSAGE_MAX)

				if(BELLY_LIQUID_MESSAGE3)
					host.vore_selected.set_messages(params["val"], BELLY_LIQUID_MESSAGE3, limit = BELLIES_MESSAGE_MAX)

				if(BELLY_LIQUID_MESSAGE4)
					host.vore_selected.set_messages(params["val"], BELLY_LIQUID_MESSAGE4, limit = BELLIES_MESSAGE_MAX)

				if(BELLY_LIQUID_MESSAGE5)
					host.vore_selected.set_messages(params["val"], BELLY_LIQUID_MESSAGE5, limit = BELLIES_MESSAGE_MAX)

				if("reset")
					var/confirm = tgui_alert(user,"This will delete any custom messages. Are you sure?","Confirmation",list("Cancel","DELETE"))
					if(!confirm == "DELETE")
						return FALSE
					var/obj/belly/default_belly = new /obj/belly(null)
					host.vore_selected.digest_messages_prey = default_belly.digest_messages_prey.Copy()
					host.vore_selected.digest_messages_owner = default_belly.digest_messages_owner.Copy()
					host.vore_selected.absorb_messages_prey = default_belly.absorb_messages_prey.Copy()
					host.vore_selected.absorb_messages_owner = default_belly.absorb_messages_owner.Copy()
					host.vore_selected.unabsorb_messages_prey = default_belly.unabsorb_messages_prey.Copy()
					host.vore_selected.unabsorb_messages_owner = default_belly.unabsorb_messages_owner.Copy()
					host.vore_selected.struggle_messages_outside = default_belly.struggle_messages_outside.Copy()
					host.vore_selected.struggle_messages_inside = default_belly.struggle_messages_inside.Copy()
					host.vore_selected.absorbed_struggle_messages_outside = default_belly.absorbed_struggle_messages_outside.Copy()
					host.vore_selected.absorbed_struggle_messages_inside = default_belly.absorbed_struggle_messages_inside.Copy()
					host.vore_selected.escape_attempt_messages_owner = default_belly.escape_attempt_messages_owner.Copy()
					host.vore_selected.escape_attempt_messages_prey = default_belly.escape_attempt_messages_prey.Copy()
					host.vore_selected.escape_messages_owner = default_belly.escape_messages_owner.Copy()
					host.vore_selected.escape_messages_prey = default_belly.escape_messages_prey.Copy()
					host.vore_selected.escape_messages_outside = default_belly.escape_messages_outside.Copy()
					host.vore_selected.escape_item_messages_owner = default_belly.escape_item_messages_owner.Copy()
					host.vore_selected.escape_item_messages_prey = default_belly.escape_item_messages_prey.Copy()
					host.vore_selected.escape_item_messages_outside = default_belly.escape_item_messages_outside.Copy()
					host.vore_selected.escape_fail_messages_owner = default_belly.escape_fail_messages_owner.Copy()
					host.vore_selected.escape_fail_messages_prey = default_belly.escape_fail_messages_prey.Copy()
					host.vore_selected.escape_attempt_absorbed_messages_owner = default_belly.escape_attempt_absorbed_messages_owner.Copy()
					host.vore_selected.escape_attempt_absorbed_messages_prey = default_belly.escape_attempt_absorbed_messages_prey.Copy()
					host.vore_selected.escape_absorbed_messages_owner = default_belly.escape_absorbed_messages_owner.Copy()
					host.vore_selected.escape_absorbed_messages_prey = default_belly.escape_absorbed_messages_prey.Copy()
					host.vore_selected.escape_absorbed_messages_outside = default_belly.escape_absorbed_messages_outside.Copy()
					host.vore_selected.escape_fail_absorbed_messages_owner = default_belly.escape_fail_absorbed_messages_owner.Copy()
					host.vore_selected.escape_fail_absorbed_messages_prey = default_belly.escape_fail_absorbed_messages_prey.Copy()
					host.vore_selected.primary_transfer_messages_owner = default_belly.primary_transfer_messages_owner.Copy()
					host.vore_selected.primary_transfer_messages_prey = default_belly.primary_transfer_messages_prey.Copy()
					host.vore_selected.secondary_transfer_messages_owner = default_belly.secondary_transfer_messages_owner.Copy()
					host.vore_selected.secondary_transfer_messages_prey = default_belly.secondary_transfer_messages_prey.Copy()
					host.vore_selected.primary_autotransfer_messages_owner = default_belly.primary_autotransfer_messages_owner.Copy()
					host.vore_selected.primary_autotransfer_messages_prey = default_belly.primary_autotransfer_messages_prey.Copy()
					host.vore_selected.secondary_autotransfer_messages_owner = default_belly.secondary_autotransfer_messages_owner.Copy()
					host.vore_selected.secondary_autotransfer_messages_prey = default_belly.secondary_autotransfer_messages_prey.Copy()
					host.vore_selected.digest_chance_messages_owner = default_belly.digest_chance_messages_owner.Copy()
					host.vore_selected.digest_chance_messages_prey = default_belly.digest_chance_messages_prey.Copy()
					host.vore_selected.absorb_chance_messages_owner = default_belly.absorb_chance_messages_owner.Copy()
					host.vore_selected.absorb_chance_messages_prey = default_belly.absorb_chance_messages_prey.Copy()
					host.vore_selected.examine_messages = default_belly.examine_messages.Copy()
					host.vore_selected.examine_messages_absorbed = default_belly.examine_messages_absorbed.Copy()
					host.vore_selected.emote_lists = default_belly.emote_lists.Copy()
					host.vore_selected.trash_eater_in = default_belly.trash_eater_in.Copy()
					host.vore_selected.trash_eater_out = default_belly.trash_eater_out.Copy()
					host.vore_selected.liquid_fullness1_messages = default_belly.fullness1_messages.Copy()
					host.vore_selected.liquid_fullness2_messages = default_belly.fullness2_messages.Copy()
					host.vore_selected.liquid_fullness3_messages = default_belly.fullness3_messages.Copy()
					host.vore_selected.liquid_fullness4_messages = default_belly.fullness4_messages.Copy()
					host.vore_selected.liquid_fullness5_messages = default_belly.fullness5_messages.Copy()
					qdel(default_belly)
			. = TRUE
		if("b_verb")
			var/new_verb = html_encode(params["val"])

			if(length(new_verb) > BELLIES_NAME_MAX || length(new_verb) < BELLIES_NAME_MIN)
				tgui_alert_async(user, "Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.vore_verb = new_verb
			. = TRUE
		if("b_release_verb")
			var/new_release_verb = html_encode(params["val"])

			if(length(new_release_verb) > BELLIES_NAME_MAX || length(new_release_verb) < BELLIES_NAME_MIN)
				tgui_alert_async(user, "Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.release_verb = new_release_verb
			. = TRUE
		if("b_eating_privacy")
			var/privacy_choice = params["val"]
			if(!(privacy_choice in list("default", "subtle", "loud")))
				return FALSE
			host.vore_selected.eating_privacy_local = privacy_choice
			. = TRUE
		if("b_silicon_belly")
			var/belly_choice = params["val"]
			if(!(belly_choice in list("Sleeper", "Vorebelly", "Both")))
				return FALSE
			for(var/obj/belly/B in host.vore_organs)
				B.silicon_belly_overlay_preference = belly_choice
			host.update_icon()
			. = TRUE
		if("b_belly_mob_mult")
			var/new_prey_mult = tgui_input_number(user, "Choose the multiplier for mobs contributing to belly size, ranging from 0 to 5. Set to 0 to disable mobs contributing to belly size",
			"Set Prey Multiplier", host.vore_selected.belly_mob_mult, max_value = 5, min_value = 0)
			if(new_prey_mult == null)
				return FALSE
			host.vore_selected.belly_mob_mult = CLAMP(new_prey_mult, 0, 5) //Max at 5 because in no world will a borg have more than 5 bellies
			host.update_icon()
			. = TRUE
		if("b_belly_item_mult")
			var/new_item_mult = tgui_input_number(user, "Choose the multiplier for items contributing to belly size, \
			ranging from 0 to 10. (Item size affects how much they contribute as well) Set to 0 to disable size checks", "Set Item Multiplier", host.vore_selected.belly_item_mult, max_value = 10, min_value = 0)
			if(new_item_mult == null)
				return FALSE
			else
				host.vore_selected.belly_item_mult = CLAMP(new_item_mult, 0, 10) //Max at 10 because items contribute less than mobs, in general
			host.update_icon()
			. = TRUE
		if("b_belly_overall_mult")
			var/new_overall_mult = tgui_input_number(user, "Choose the overall multiplier to be applied to belly contents after specific multipliers, ranging from 0 to 5. Set to 0 to disable showing belly sprites at all.",
			"Set minimum prey amount", host.vore_selected.belly_overall_mult, max_value = 5, min_value = 0)
			if(new_overall_mult == null)
				return FALSE
			else
				host.vore_selected.belly_overall_mult = CLAMP(new_overall_mult, 0, 5) // Max at 5 because... no reason to go higher at that point
			host.update_icon()
			. = TRUE
		if("b_fancy_sound")
			host.vore_selected.fancy_vore = !host.vore_selected.fancy_vore
			host.vore_selected.vore_sound = "Gulp"
			host.vore_selected.release_sound = "Splatter"
			// defaults as to avoid potential bugs
			. = TRUE
		if("b_release")
			var/choice = params["val"]
			if(host.vore_selected.fancy_vore)
				if(!(choice in GLOB.fancy_release_sounds))
					return FALSE
			else if (!(choice in GLOB.classic_release_sounds))
				return FALSE
			host.vore_selected.release_sound = choice
			. = TRUE
		if("b_releasesoundtest")
			var/sound/releasetest
			if(host.vore_selected.fancy_vore)
				releasetest = GLOB.fancy_release_sounds[host.vore_selected.release_sound]
			else
				releasetest = GLOB.classic_release_sounds[host.vore_selected.release_sound]

			if(releasetest)
				releasetest = sound(releasetest)
				releasetest.volume = host.vore_selected.sound_volume
				releasetest.frequency = host.vore_selected.noise_freq
				SEND_SOUND(user, releasetest)
			. = TRUE
		if("b_sound")
			var/choice = params["val"]
			if(host.vore_selected.fancy_vore)
				if(!(choice in GLOB.fancy_vore_sounds))
					return FALSE
			else if (!(choice in GLOB.classic_vore_sounds))
				return FALSE
			host.vore_selected.vore_sound = choice
			. = TRUE
		if("b_soundtest")
			var/sound/voretest
			if(host.vore_selected.fancy_vore)
				voretest = GLOB.fancy_vore_sounds[host.vore_selected.vore_sound]
			else
				voretest = GLOB.classic_vore_sounds[host.vore_selected.vore_sound]
			if(voretest)
				voretest = sound(voretest)
				voretest.volume = host.vore_selected.sound_volume
				voretest.frequency = host.vore_selected.noise_freq
				SEND_SOUND(user, voretest)
			. = TRUE
		if("b_sound_volume")
			var/sound_volume_input = text2num(params["val"])
			if(!isnum(sound_volume_input))
				return FALSE
			host.vore_selected.sound_volume = sanitize_integer(sound_volume_input, 0, 100, initial(host.vore_selected.sound_volume))
			. = TRUE
		if("b_noise_freq")
			var/choice = text2num(params["val"])
			if(!isnum(choice))
				return FALSE
			if(choice == 0)
				choice = rand(MIN_VOICE_FREQ, MAX_VOICE_FREQ)
			host.vore_selected.noise_freq = CLAMP(choice, MIN_VOICE_FREQ, MAX_VOICE_FREQ)
			. = TRUE
		if("b_tastes")
			host.vore_selected.can_taste = !host.vore_selected.can_taste
			. = TRUE
		if("b_feedable")
			host.vore_selected.is_feedable = !host.vore_selected.is_feedable
			. = TRUE
		if("b_entrance_logs")
			host.vore_selected.entrance_logs = !host.vore_selected.entrance_logs
			. = TRUE
		if("b_item_digest_logs")
			host.vore_selected.item_digest_logs = !host.vore_selected.item_digest_logs
			. = TRUE
		if("b_bulge_size")
			var/new_bulge = text2num(params["val"])
			if(!isnum(new_bulge))
				return FALSE
			if(new_bulge == 0) //Disable.
				host.vore_selected.bulge_size = 0
				to_chat(user,span_notice("Your stomach will not be seen on examine."))
			else if(new_bulge)
				new_bulge = CLAMP(new_bulge, 25, 200)
				host.vore_selected.bulge_size = (new_bulge/100)
			. = TRUE
		if("b_display_absorbed_examine")
			host.vore_selected.display_absorbed_examine = !host.vore_selected.display_absorbed_examine
			. = TRUE
		if("b_display_outside_struggle")
			host.vore_selected.toggle_displayed_message_flags(MS_FLAG_STRUGGLE_OUTSIDE)
			. = TRUE
		if("b_display_absorbed_outside_struggle")
			host.vore_selected.toggle_displayed_message_flags(MS_FLAG_STRUGGLE_ABSORBED_OUTSIDE)
			. = TRUE
		if("b_grow_shrink")
			var/new_grow = text2num(params["val"])
			if (!isnum(new_grow))
				return
			host.vore_selected.shrink_grow_size = CLAMP(new_grow, 25, 200) * 0.01
			. = TRUE
		if("b_nutritionpercent")
			var/new_nutrition = text2num(params["val"])
			if(!isnum(new_nutrition))
				return FALSE
			host.vore_selected.nutrition_percent = CLAMP(new_nutrition, 0.01, 100)
			. = TRUE
		// modified these to be flexible rather than maxing at 6/6/12/6/6
		if("b_burn_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			host.vore_selected.digest_burn = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_burn) // sanity check following tgui input
			host.vore_selected.items_preserved.Cut()
			. = TRUE
		if("b_brute_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			host.vore_selected.digest_brute = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_brute)
			host.vore_selected.items_preserved.Cut()
			. = TRUE
		if("b_oxy_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			host.vore_selected.digest_oxy = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_oxy)
			. = TRUE
		if("b_tox_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			host.vore_selected.digest_tox = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_tox)
			. = TRUE
		if("b_clone_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			host.vore_selected.digest_clone = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_clone)
			. = TRUE
		if("b_bellytemperature")
			var/new_temp = text2num(params["val"])
			if(!isnum(new_temp))
				return FALSE
			new_temp = new_temp + T0C
			host.vore_selected.bellytemperature = CLAMP(new_temp, T0C, 473.15)
			. = TRUE
		if("b_temperature_damage")
			host.vore_selected.temperature_damage = !host.vore_selected.temperature_damage
			. = TRUE
		if("b_drainmode")
			var/new_drainmode = params["val"]
			if(!(new_drainmode in host.vore_selected.drainmodes))
				return FALSE
			host.vore_selected.drainmode = new_drainmode
			host.vore_selected.updateVRPanels()
		if("b_emoteactive")
			host.vore_selected.emote_active = !host.vore_selected.emote_active
			. = TRUE
		if("b_selective_mode_pref_toggle")
			var/new_mode = params["val"]
			switch(new_mode)
				if(DM_DIGEST)
					host.vore_selected.selective_preference = DM_DIGEST
				if(DM_ABSORB)
					host.vore_selected.selective_preference = DM_ABSORB
			. = TRUE
		if("b_emotetime")
			var/new_time = text2num(params["val"])
			if(!isnum(new_time))
				return FALSE
			host.vore_selected.emote_time = CLAMP(new_time, 60, 600)
			. = TRUE
		if("b_escapable")
			var/new_mode = text2num(params["val"])
			switch(new_mode)
				if(B_ESCAPABLE_NONE) //Never escapable.
					host.vore_selected.escapable = B_ESCAPABLE_NONE
					to_chat(user,span_warning("Prey will not be able to have special interactions with your [lowertext(host.vore_selected.name)]."))
				if(B_ESCAPABLE_DEFAULT) //Possibly escapable and special interactions.
					host.vore_selected.escapable = B_ESCAPABLE_DEFAULT
					to_chat(user,span_warning("Prey now have special interactions with your [lowertext(host.vore_selected.name)] depending on your settings."))
				if(B_ESCAPABLE_INTENT) //Possibly escapable and special intent based interactions.
					host.vore_selected.escapable = B_ESCAPABLE_INTENT
					to_chat(user,span_warning("Prey now have special interactions with your [lowertext(host.vore_selected.name)] depending on your settings and their intent."))
			. = TRUE
		if("b_escapechance")
			var/escape_chance_input = text2num(params["val"])
			if(!isnum(escape_chance_input))
				return FALSE
			host.vore_selected.escapechance = sanitize_integer(escape_chance_input, 0, 100, initial(host.vore_selected.escapechance))
			. = TRUE
		if("b_belchchance")
			var/belch_chance_input = text2num(params["val"])
			if(!isnum(belch_chance_input))
				return FALSE
			host.vore_selected.belchchance = sanitize_integer(belch_chance_input, 0, 100, initial(host.vore_selected.belchchance))
			. = TRUE
		if("b_escapechance_absorbed")
			var/escape_absorbed_chance_input = text2num(params["val"])
			if(!isnum(escape_absorbed_chance_input))
				return FALSE
			host.vore_selected.escapechance_absorbed = sanitize_integer(escape_absorbed_chance_input, 0, 100, initial(host.vore_selected.escapechance_absorbed))
			. = TRUE
		if("b_escapetime")
			var/escape_time_input = text2num(params["val"])
			if(!isnum(escape_time_input))
				return FALSE
			host.vore_selected.escapetime = sanitize_integer(escape_time_input*10, 10, 600, initial(host.vore_selected.escapetime))
			. = TRUE
		if("b_transferchance")
			var/transfer_chance_input = text2num(params["val"])
			if(!isnum(transfer_chance_input))
				return FALSE
			host.vore_selected.transferchance = sanitize_integer(transfer_chance_input, 0, 100, initial(host.vore_selected.transferchance))
			. = TRUE
		if("b_transferlocation")
			var/obj/belly/choice = locate(params["val"])

			if(!istype(choice))
				host.vore_selected.transferlocation = null
			else
				host.vore_selected.transferlocation = choice.name
			. = TRUE
		if("b_transferchance_secondary")
			var/transfer_secondary_chance_input = text2num(params["val"])
			if(!isnum(transfer_secondary_chance_input))
				return FALSE
			host.vore_selected.transferchance_secondary = sanitize_integer(transfer_secondary_chance_input, 0, 100, initial(host.vore_selected.transferchance_secondary))
			. = TRUE
		if("b_transferlocation_secondary")
			var/obj/belly/choice_secondary = locate(params["val"])

			if(!istype(choice_secondary))
				host.vore_selected.transferlocation_secondary = null
			else
				host.vore_selected.transferlocation_secondary = choice_secondary.name
			. = TRUE
		if("b_absorbchance")
			var/absorb_chance_input = text2num(params["val"])
			if(!isnum(absorb_chance_input))
				return FALSE
			host.vore_selected.absorbchance = sanitize_integer(absorb_chance_input, 0, 100, initial(host.vore_selected.absorbchance))
			. = TRUE
		if("b_digestchance")
			var/digest_chance_input = text2num(params["val"])
			if(!isnum(digest_chance_input))
				return FALSE
			host.vore_selected.digestchance = sanitize_integer(digest_chance_input, 0, 100, initial(host.vore_selected.digestchance))
			. = TRUE
		if("b_autotransferchance_primary")
			var/autotransferchance_input = params["val"]
			if(!isnum(autotransferchance_input))
				return FALSE
			host.vore_selected.autotransferchance = sanitize_integer(autotransferchance_input, 0, 100, initial(host.vore_selected.autotransferchance))
			. = TRUE
		if("b_autotransferwait")
			var/autotransferwait_input = params["val"]
			if(!isnum(autotransferwait_input))
				return FALSE
			host.vore_selected.autotransferwait = sanitize_integer(autotransferwait_input*10, 10, 18000, initial(host.vore_selected.autotransferwait))
			. = TRUE
		if("b_autotransferlocation_primary")
			var/obj/belly/choice = locate(params["val"])

			if(!istype(choice))
				host.vore_selected.autotransferlocation = null
			else
				host.vore_selected.autotransferlocation = choice.name
			. = TRUE
		if("b_autotransferextralocation_primary")
			var/obj/belly/choice = locate(params["val"])
			if(!istype(choice))
				return FALSE
			else if(choice.name in host.vore_selected.autotransferextralocation)
				host.vore_selected.autotransferextralocation -= choice.name
			else
				host.vore_selected.autotransferextralocation += choice.name
			. = TRUE
		if("b_autotransferchance_secondary")
			var/autotransferchance_secondary_input = params["val"]
			if(!isnum(autotransferchance_secondary_input))
				return FALSE
			host.vore_selected.autotransferchance_secondary = sanitize_integer(autotransferchance_secondary_input, 0, 100, initial(host.vore_selected.autotransferchance_secondary))
			. = TRUE
		if("b_autotransferlocation_secondary")
			var/obj/belly/choice = locate(params["val"])

			if(!choice)
				host.vore_selected.autotransferlocation_secondary = null
			else
				host.vore_selected.autotransferlocation_secondary = choice.name
			. = TRUE
		if("b_autotransferextralocation_secondary")
			var/obj/belly/choice = locate(params["val"])
			if(!istype(choice)) //They cancelled, no changes
				return FALSE
			else if(choice.name in host.vore_selected.autotransferextralocation_secondary)
				host.vore_selected.autotransferextralocation_secondary -= choice.name
			else
				host.vore_selected.autotransferextralocation_secondary += choice.name
			. = TRUE
		if("b_autotransfer_whitelist_primary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_whitelist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
		if("b_autotransfer_blacklist_primary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_blacklist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
		if("b_autotransfer_whitelist_secondary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_secondary_whitelist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
		if("b_autotransfer_blacklist_secondary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_secondary_blacklist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
			. = TRUE
		if("b_autotransfer_whitelist_items_primary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list_items[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_whitelist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_blacklist_items_primary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list_items[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_blacklist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_whitelist_items_secondary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list_items[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_secondary_whitelist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_blacklist_items_secondary")
			var/toggle_addon = params["val"]
			if(!(host.vore_selected.autotransfer_flags_list_items[toggle_addon]))
				return FALSE
			host.vore_selected.autotransfer_secondary_blacklist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_min_amount")
			var/autotransfer_min_amount_input = params["val"]
			if(!isnum(autotransfer_min_amount_input))
				return FALSE
			host.vore_selected.autotransfer_min_amount = sanitize_integer(autotransfer_min_amount_input, 0, 100, initial(host.vore_selected.autotransfer_min_amount))
			. = TRUE
		if("b_autotransfer_max_amount")
			var/autotransfer_max_amount_input = params["val"]
			if(!isnum(autotransfer_max_amount_input))
				return FALSE
			host.vore_selected.autotransfer_max_amount = sanitize_integer(autotransfer_max_amount_input, 0, 100, initial(host.vore_selected.autotransfer_max_amount))
			. = TRUE
		if("b_autotransfer_enabled")
			host.vore_selected.autotransfer_enabled = !host.vore_selected.autotransfer_enabled
			. = TRUE
		if("b_fullscreen")
			host.vore_selected.belly_fullscreen = params["val"]
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_disable_hud")
			host.vore_selected.disable_hud = !host.vore_selected.disable_hud
			. = TRUE
		if("b_colorization_enabled") //ALLOWS COLORIZATION.
			host.vore_selected.colorization_enabled = !host.vore_selected.colorization_enabled
			host.vore_selected.belly_fullscreen = "dark" //This prevents you from selecting a belly that is not meant to be colored and then turning colorization on.
			. = TRUE
		if("b_preview_belly")
			host.vore_selected.vore_preview(host) //Gives them the stomach overlay. It fades away after ~2 seconds as human/life.dm removes the overlay if not in a gut.
			. = TRUE
		if("b_clear_preview")
			host.vore_selected.clear_preview(host) //Clears the stomach overlay. This is a failsafe but shouldn't occur.
			. = TRUE
		if("b_fullscreen_color")
			var/newcolor = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor)
				host.vore_selected.belly_fullscreen_color = newcolor
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_color2")
			var/newcolor2 = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor2)
				host.vore_selected.belly_fullscreen_color2 = newcolor2
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_color3")
			var/newcolor3 = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor3)
				host.vore_selected.belly_fullscreen_color3 = newcolor3
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_color4")
			var/newcolor4 = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor4)
				host.vore_selected.belly_fullscreen_color4 = newcolor4
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_alpha")
			var/newalpha = text2num(params["val"])
			if(!isnum(newalpha))
				return FALSE
			host.vore_selected.belly_fullscreen_alpha = newalpha
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_save_digest_mode")
			host.vore_selected.save_digest_mode = !host.vore_selected.save_digest_mode
			. = TRUE
		if("b_del")
			var/alert = tgui_alert(user, "Are you sure you want to delete your [lowertext(host.vore_selected.name)]?","Confirmation",list("Cancel","Delete"))
			if(alert != "Delete")
				return FALSE

			var/failure_msg = ""

			var/dest_for //Check to see if it's the destination of another vore organ.
			for(var/obj/belly/B as anything in host.vore_organs)
				if(B.transferlocation == host.vore_selected)
					dest_for = B.name
					failure_msg += "This is the destiantion for at least '[dest_for]' belly transfers. Remove it as the destination from any bellies before deleting it. "
					break
				if(B.transferlocation_secondary == host.vore_selected)
					dest_for = B.name
					failure_msg += "This is the destiantion for at least '[dest_for]' secondary belly transfers. Remove it as the destination from any bellies before deleting it. "
					break

			if(host.vore_selected.contents.len)
				failure_msg += "You cannot delete bellies with contents! " //These end with spaces, to be nice looking. Make sure you do the same.
			if(host.vore_selected.immutable)
				failure_msg += "This belly is marked as undeletable. "
			if(host.vore_organs.len == 1)
				failure_msg += "You must have at least one belly. "

			if(failure_msg)
				tgui_alert_async(user,failure_msg,"Error!")
				return FALSE

			if(host.soulgem?.linked_belly == host.vore_selected)
				host.soulgem.linked_belly = null

			qdel(host.vore_selected)
			host.vore_selected = host.vore_organs[1]
			. = TRUE
		if("b_private_struggle")
			host.vore_selected.private_struggle = !host.vore_selected.private_struggle
			. = TRUE
		if("b_absorbedrename_enabled")
			host.vore_selected.absorbedrename_enabled = !host.vore_selected.absorbedrename_enabled
			. = TRUE
		if("b_absorbedrename_name")
			var/new_absorbedrename_name = sanitize(params["val"], MAX_MESSAGE_LEN, FALSE, TRUE, FALSE)
			if(new_absorbedrename_name)
				host.vore_selected.absorbedrename_name = new_absorbedrename_name
			. = TRUE
		if("b_vorespawn_blacklist")
			host.vore_selected.vorespawn_blacklist = !host.vore_selected.vorespawn_blacklist
			. = TRUE
		if("b_vorespawn_whitelist")
			var/new_vorespawn_whitelist = sanitize(params["val"], MAX_MESSAGE_LEN, FALSE, TRUE, FALSE)
			if(new_vorespawn_whitelist)
				host.vore_selected.vorespawn_whitelist = splittext(lowertext(new_vorespawn_whitelist),"\n")
			else
				host.vore_selected.vorespawn_whitelist = list()
			. = TRUE
		if("b_vorespawn_absorbed")
			var/current_number = params["val"]
			switch(current_number)
				if("Yes")
					host.vore_selected.vorespawn_absorbed |= VS_FLAG_ABSORB_YES
				if("Prey Choice")
					host.vore_selected.vorespawn_absorbed |= VS_FLAG_ABSORB_PREY
				if("No")
					host.vore_selected.vorespawn_absorbed &= ~(VS_FLAG_ABSORB_YES)
					host.vore_selected.vorespawn_absorbed &= ~(VS_FLAG_ABSORB_PREY)
			. = TRUE
		if("b_belly_sprite_to_affect")
			var/belly_choice = params["val"]
			if(!(belly_choice in host.vore_icon_bellies))
				return FALSE
			host.vore_selected.belly_sprite_to_affect = belly_choice
			host.handle_belly_update()
			. = TRUE
		if("b_affects_vore_sprites")
			host.vore_selected.affects_vore_sprites = !host.vore_selected.affects_vore_sprites
			host.handle_belly_update()
			. = TRUE
		if("b_count_absorbed_prey_for_sprites")
			host.vore_selected.count_absorbed_prey_for_sprite = !host.vore_selected.count_absorbed_prey_for_sprite
			host.handle_belly_update()
			. = TRUE
		if("b_absorbed_multiplier")
			var/absorbed_multiplier_input = text2num(params["val"])
			if(!isnum(absorbed_multiplier_input))
				return FALSE
			host.vore_selected.absorbed_multiplier = CLAMP(absorbed_multiplier_input, 0.1, 3)
			host.handle_belly_update()
			. = TRUE
		if("b_count_items_for_sprites")
			host.vore_selected.count_items_for_sprite = !host.vore_selected.count_items_for_sprite
			host.handle_belly_update()
			. = TRUE
		if("b_item_multiplier")
			var/item_multiplier_input = text2num(params["val"])
			if(!isnum(item_multiplier_input))
				return FALSE
			host.vore_selected.item_multiplier = CLAMP(item_multiplier_input, 0.1, 10)
			host.handle_belly_update()
			. = TRUE
		if("b_health_impacts_size")
			host.vore_selected.health_impacts_size = !host.vore_selected.health_impacts_size
			host.handle_belly_update()
			. = TRUE
		if("b_resist_animation")
			host.vore_selected.resist_triggers_animation = !host.vore_selected.resist_triggers_animation
			. = TRUE
		if("b_size_factor_sprites")
			var/size_factor_input = text2num(params["val"])
			if(!isnum(size_factor_input))
				return FALSE
			host.vore_selected.size_factor_for_sprite = CLAMP(size_factor_input, 0.1, 3)
			host.handle_belly_update()
			. = TRUE
		if("b_vore_sprite_flags")
			var/toggle_vs_flag = params["val"]
			if(!(toggle_vs_flag in host.vore_selected.vore_sprite_flag_list))
				return FALSE
			host.vore_selected.vore_sprite_flags ^= host.vore_selected.vore_sprite_flag_list[toggle_vs_flag]
			. = TRUE
		if("b_count_liquid_for_sprites")
			host.vore_selected.count_liquid_for_sprite = !host.vore_selected.count_liquid_for_sprite
			host.handle_belly_update()
			. = TRUE
		if("b_liquid_multiplier")
			var/liquid_multiplier_input = text2num(params["val"])
			if(!isnum(liquid_multiplier_input))
				return FALSE
			host.vore_selected.liquid_multiplier = CLAMP(liquid_multiplier_input, 0.1, 10)
			host.handle_belly_update()
			. = TRUE
		if("b_undergarment_choice")
			var/new_undergarment = params["val"]
			if(!(GLOB.global_underwear.categories_by_name[new_undergarment]))
				return FALSE
			host.vore_selected.undergarment_chosen = new_undergarment
			host.handle_belly_update()
			. = TRUE
		if("b_undergarment_if_none")
			var/datum/category_group/underwear/UWC = GLOB.global_underwear.categories_by_name[host.vore_selected.undergarment_chosen]
			var/selected_underwear = UWC.items_by_name[params["val"]]
			if(!selected_underwear) //They cancelled, no changes
				return FALSE

			host.vore_selected.undergarment_if_none = selected_underwear
			host.handle_belly_update()
			host.updateVRPanel()
		if("b_undergarment_color")
			var/newcolor = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor)
				host.vore_selected.undergarment_color = newcolor
				host.handle_belly_update()
			. = TRUE
		if("b_tail_to_change_to")
			var/tail_choice = params["val"]
			if(!(tail_choice in GLOB.tail_styles_list))
				return FALSE
			host.vore_selected.tail_to_change_to = tail_choice
			. = TRUE
		if("b_tail_color")
			var/newcolor = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor)
				host.vore_selected.tail_colouration = newcolor
			. = TRUE
		if("b_tail_color2")
			var/newcolor = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor)
				host.vore_selected.tail_extra_overlay = newcolor
			. = TRUE
		if("b_tail_color3")
			var/newcolor = sanitize_hexcolor(lowertext(params["val"]))
			if(newcolor)
				host.vore_selected.tail_extra_overlay2 = newcolor
			. = TRUE
		if("b_show_liq_fullness")
			if(!host.vore_selected.show_fullness_messages)
				host.vore_selected.show_fullness_messages = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has liquid examination options."))
			else
				host.vore_selected.show_fullness_messages = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has liquid examination options."))
			. = TRUE
		if("b_liq_msg_toggle1")
			host.vore_selected.liquid_fullness1_messages = !host.vore_selected.liquid_fullness1_messages
			. = TRUE
		if("b_liq_msg_toggle2")
			host.vore_selected.liquid_fullness2_messages = !host.vore_selected.liquid_fullness2_messages
			. = TRUE
		if("b_liq_msg_toggle3")
			host.vore_selected.liquid_fullness3_messages = !host.vore_selected.liquid_fullness3_messages
			. = TRUE
		if("b_liq_msg_toggle4")
			host.vore_selected.liquid_fullness4_messages = !host.vore_selected.liquid_fullness4_messages
			. = TRUE
		if("b_liq_msg_toggle5")
			host.vore_selected.liquid_fullness5_messages = !host.vore_selected.liquid_fullness5_messages
			. = TRUE

	if(.)
		unsaved_changes = TRUE
