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

	data["db_version"] = "0.2"
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

			belly_data["primary_autotransfer_messages_owner"] = list()
			for(var/msg in B.primary_autotransfer_messages_owner)
				belly_data["primary_autotransfer_messages_owner"] += msg

			belly_data["primary_autotransfer_messages_prey"] = list()
			for(var/msg in B.primary_autotransfer_messages_prey)
				belly_data["primary_autotransfer_messages_prey"] += msg

			belly_data["secondary_autotransfer_messages_owner"] = list()
			for(var/msg in B.secondary_autotransfer_messages_owner)
				belly_data["secondary_autotransfer_messages_owner"] += msg

			belly_data["secondary_autotransfer_messages_prey"] = list()
			for(var/msg in B.secondary_autotransfer_messages_prey)
				belly_data["secondary_autotransfer_messages_prey"] += msg

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
			belly_data["is_feedable"] = B.is_feedable
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
			belly_data["vorespawn_blacklist"] = B.vorespawn_blacklist
			belly_data["vorespawn_whitelist"] = B.vorespawn_whitelist
			belly_data["vorespawn_absorbed"] = B.vorespawn_absorbed
			belly_data["egg_type"] = B.egg_type
			belly_data["egg_name"] = B.egg_name
			belly_data["egg_size"] = B.egg_size
			belly_data["selective_preference"] = B.selective_preference
			belly_data["recycling"] = B.recycling
			belly_data["storing_nutrition"] = B.storing_nutrition
			belly_data["entrance_logs"] = B.entrance_logs
			belly_data["item_digest_logs"] = B.item_digest_logs
			belly_data["eating_privacy_local"] = B.eating_privacy_local
			belly_data["private_struggle"] = B.private_struggle

			// Sounds
			belly_data["is_wet"] = B.is_wet
			belly_data["wet_loop"] = B.wet_loop
			belly_data["fancy_vore"] = B.fancy_vore
			belly_data["vore_sound"] = B.vore_sound
			belly_data["release_sound"] = B.release_sound
			belly_data["sound_volume"] = B.sound_volume
			belly_data["noise_freq"] = B.noise_freq

			// Visuals
			belly_data["affects_vore_sprites"] = B.affects_vore_sprites
			var/list/sprite_flags = list()
			for(var/flag_name in B.vore_sprite_flag_list)
				if(B.vore_sprite_flags & B.vore_sprite_flag_list[flag_name])
					sprite_flags.Add(flag_name)
			belly_data["vore_sprite_flags"] = sprite_flags
			belly_data["count_absorbed_prey_for_sprite"] = B.count_absorbed_prey_for_sprite
			belly_data["absorbed_multiplier"] = B.absorbed_multiplier
			belly_data["count_liquid_for_sprite"] = B.count_liquid_for_sprite
			belly_data["liquid_multiplier"] = B.liquid_multiplier
			belly_data["count_items_for_sprite"] = B.count_items_for_sprite
			belly_data["item_multiplier"] = B.item_multiplier
			belly_data["health_impacts_size"] = B.health_impacts_size
			belly_data["resist_triggers_animation"] = B.resist_triggers_animation
			belly_data["size_factor_for_sprite"] = B.size_factor_for_sprite
			belly_data["belly_sprite_to_affect"] = B.belly_sprite_to_affect
			belly_data["undergarment_chosen"] = B.undergarment_chosen
			belly_data["undergarment_if_none"] = B.undergarment_if_none
			belly_data["undergarment_color"] = B.undergarment_color
			//belly_data["tail_to_change_to"] = B.tail_to_change_to
			//belly_data["tail_colouration"] = B.tail_colouration
			//belly_data["tail_extra_overlay"] = B.tail_extra_overlay
			//belly_data["tail_extra_overlay2"] = B.tail_extra_overlay2

			// Visuals (Belly Fullscreens Preview and Coloring)
			belly_data["belly_fullscreen_color"] = B.belly_fullscreen_color
			belly_data["belly_fullscreen_color2"] = B.belly_fullscreen_color2
			belly_data["belly_fullscreen_color3"] = B.belly_fullscreen_color3
			belly_data["belly_fullscreen_color4"] = B.belly_fullscreen_color4
			belly_data["belly_fullscreen_alpha"] = B.belly_fullscreen_alpha
			belly_data["colorization_enabled"] = B.colorization_enabled

			// Visuals (Vore FX)
			belly_data["disable_hud"] = B.disable_hud
			belly_data["belly_fullscreen"] = B.belly_fullscreen

			// Interactions
			belly_data["escapable"] = B.escapable

			belly_data["escapechance"] = B.escapechance
			belly_data["escapechance_absorbed"] = B.escapechance_absorbed
			belly_data["escapetime"] = B.escapetime/10

			belly_data["belchchance"] = B.belchchance

			belly_data["transferchance"] = B.transferchance
			belly_data["transferlocation"] = B.transferlocation

			belly_data["transferchance_secondary"] = B.transferchance_secondary
			belly_data["transferlocation_secondary"] = B.transferlocation_secondary

			belly_data["absorbchance"] = B.absorbchance
			belly_data["digestchance"] = B.digestchance

			// Interactions (Auto-Transfer)
			belly_data["autotransferchance"] = B.autotransferchance
			belly_data["autotransferwait"] = B.autotransferwait/10
			belly_data["autotransferlocation"] = B.autotransferlocation
			belly_data["autotransferextralocation"] = B.autotransferextralocation
			belly_data["autotransfer_enabled"] = B.autotransfer_enabled
			belly_data["autotransferchance_secondary"] = B.autotransferchance_secondary
			belly_data["autotransferlocation_secondary"] = B.autotransferlocation_secondary
			belly_data["autotransferextralocation_secondary"] = B.autotransferextralocation_secondary
			belly_data["autotransfer_min_amount"] = B.autotransfer_min_amount
			belly_data["autotransfer_max_amount"] = B.autotransfer_max_amount
			var/list/at_whitelist = list()
			for(var/flag_name in B.autotransfer_flags_list)
				if(B.autotransfer_whitelist & B.autotransfer_flags_list[flag_name])
					at_whitelist.Add(flag_name)
			belly_data["autotransfer_whitelist"] = at_whitelist
			var/list/at_blacklist = list()
			for(var/flag_name in B.autotransfer_flags_list)
				if(B.autotransfer_blacklist & B.autotransfer_flags_list[flag_name])
					at_blacklist.Add(flag_name)
			belly_data["autotransfer_blacklist"] = at_blacklist
			var/list/at_whitelist_items = list()
			for(var/flag_name in B.autotransfer_flags_list_items)
				if(B.autotransfer_whitelist_items & B.autotransfer_flags_list_items[flag_name])
					at_whitelist_items.Add(flag_name)
			belly_data["autotransfer_whitelist_items"] = at_whitelist_items
			var/list/at_blacklist_items = list()
			for(var/flag_name in B.autotransfer_flags_list_items)
				if(B.autotransfer_blacklist_items & B.autotransfer_flags_list_items[flag_name])
					at_blacklist_items.Add(flag_name)
			belly_data["autotransfer_blacklist_items"] = at_blacklist_items
			var/list/at_secondary_whitelist = list()
			for(var/flag_name in B.autotransfer_flags_list)
				if(B.autotransfer_secondary_whitelist & B.autotransfer_flags_list[flag_name])
					at_secondary_whitelist.Add(flag_name)
			belly_data["autotransfer_secondary_whitelist"] = at_secondary_whitelist
			var/list/at_secondary_blacklist = list()
			for(var/flag_name in B.autotransfer_flags_list)
				if(B.autotransfer_secondary_blacklist & B.autotransfer_flags_list[flag_name])
					at_secondary_blacklist.Add(flag_name)
			belly_data["autotransfer_secondary_blacklist"] = at_secondary_blacklist
			var/list/at_secondary_whitelist_items = list()
			for(var/flag_name in B.autotransfer_flags_list_items)
				if(B.autotransfer_secondary_whitelist_items & B.autotransfer_flags_list_items[flag_name])
					at_secondary_whitelist_items.Add(flag_name)
			belly_data["autotransfer_secondary_whitelist_items"] = at_secondary_whitelist_items
			var/list/at_secondary_blacklist_items = list()
			for(var/flag_name in B.autotransfer_flags_list_items)
				if(B.autotransfer_secondary_blacklist_items & B.autotransfer_flags_list_items[flag_name])
					at_secondary_blacklist_items.Add(flag_name)
			belly_data["autotransfer_secondary_blacklist_items"] = at_secondary_blacklist_items

			// Liquid Options
			belly_data["show_liquids"] = B.show_liquids
			belly_data["reagentbellymode"] = B.reagentbellymode
			belly_data["reagent_chosen"] = B.reagent_chosen
			belly_data["reagent_name"] = B.reagent_name
			belly_data["reagent_transfer_verb"] = B.reagent_transfer_verb
			belly_data["gen_time_display"] = B.gen_time_display
			belly_data["custom_max_volume"] = B.custom_max_volume
			belly_data["vorefootsteps_sounds"] = B.vorefootsteps_sounds
			belly_data["liquid_overlay"] = B.liquid_overlay
			belly_data["max_liquid_level"] = B.max_liquid_level
			belly_data["reagent_toches"] = B.reagent_touches
			belly_data["mush_overlay"] = B.mush_overlay
			belly_data["mush_color"] = B.mush_color
			belly_data["mush_alpha"] = B.mush_alpha
			belly_data["max_mush"] = B.max_mush
			belly_data["min_mush"] = B.min_mush
			belly_data["item_mush_val"] = B.item_mush_val
			belly_data["custom_reagentcolor"] = B.custom_reagentcolor
			belly_data["custom_reagentalpha"] = B.custom_reagentalpha
			belly_data["metabolism_overlay"] = B.metabolism_overlay
			belly_data["metabolism_mush_ratio"] = B.metabolism_mush_ratio
			belly_data["max_ingested"] = B.max_ingested
			belly_data["custom_ingested_color"] = B.custom_ingested_color
			belly_data["custom_ingested_alpha"] = B.custom_ingested_alpha

			var/list/reagent_flags = list()
			for(var/flag_name in B.reagent_mode_flag_list)
				if(B.reagent_mode_flags & B.reagent_mode_flag_list[flag_name])
					reagent_flags.Add(flag_name)
			belly_data["reagent_mode_flag_list"] = reagent_flags

			data["bellies"] += list(belly_data)

			// Liquid Messages
			belly_data["show_fullness_messages"] = B.show_fullness_messages
			belly_data["liquid_fullness1_messages"] = B.liquid_fullness1_messages
			belly_data["liquid_fullness2_messages"] = B.liquid_fullness2_messages
			belly_data["liquid_fullness3_messages"] = B.liquid_fullness3_messages
			belly_data["liquid_fullness4_messages"] = B.liquid_fullness4_messages
			belly_data["liquid_fullness5_messages"] = B.liquid_fullness5_messages

			belly_data["fullness1_messages"] = list()
			for(var/msg in B.fullness1_messages)
				belly_data["fullness1_messages"] += msg

			belly_data["fullness2_messages"] = list()
			for(var/msg in B.fullness2_messages)
				belly_data["fullness2_messages"] += msg

			belly_data["fullness3_messages"] = list()
			for(var/msg in B.fullness3_messages)
				belly_data["fullness3_messages"] += msg

			belly_data["fullness4_messages"] = list()
			for(var/msg in B.fullness4_messages)
				belly_data["fullness4_messages"] += msg

			belly_data["fullness5_messages"] = list()
			for(var/msg in B.fullness5_messages)
				belly_data["fullness5_messages"] += msg

	// Soulcatcher export
	if(user.soulgem)
		var/obj/soulgem/gem = user.soulgem
		var/list/soulcatcher_data = list()
		soulcatcher_data["name"] = gem.name
		soulcatcher_data["setting_flags"] = gem.setting_flags
		soulcatcher_data["inside_flavor"] = gem.inside_flavor
		soulcatcher_data["capture_message"] = gem.capture_message
		soulcatcher_data["transit_message"] = gem.transit_message
		soulcatcher_data["release_message"] = gem.release_message
		soulcatcher_data["transfer_message"] = gem.transfer_message
		soulcatcher_data["delete_message"] = gem.delete_message
		soulcatcher_data["linked_belly"] = gem.linked_belly

		data["soulcatcher"] = soulcatcher_data

	return data
