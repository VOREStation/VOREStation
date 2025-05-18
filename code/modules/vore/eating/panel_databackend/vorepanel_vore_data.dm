#define CONTROL_TAB 0
#define DESCRIPTIONS_TAB 1
#define OPTIONS_TAB 2
#define SOUNDS_TAB 3
#define VISUALS_TAB 4
#define INTERACTIONS_TAB 5
#define CONTENTS_TAB 6
#define LIQUID_OPTIONS_TAB 7

/datum/vore_look/proc/get_vorebellies(mob/owner, full_data = TRUE)
	var/list/our_bellies = list()
	for(var/obj/belly/B as anything in owner.vore_organs)
		var/list/belly_data = list()
		belly_data += list(
			"name" = B.name,
			"ref" = "\ref[B]"
		)
		if(full_data)
			belly_data += list(
				"selected" = (B == owner.vore_selected),
				"digest_mode" = B.digest_mode,
				"contents" = LAZYLEN(B.contents),
				"prevent_saving" = B.prevent_saving
			)
		UNTYPED_LIST_ADD(our_bellies, belly_data)
	return our_bellies

/datum/vore_look/proc/get_inside_data(mob/owner)
	var/atom/hostloc = owner.loc
	//Allow VorePanel to show pred belly details even while indirectly inside
	if(isliving(owner))
		var/mob/living/H = owner
		hostloc = H.surrounding_belly()
	//End of indirect vorefx additions
	var/list/inside = list()
	if(isbelly(hostloc))
		var/obj/belly/inside_belly = hostloc
		var/mob/living/pred = inside_belly.owner

		var/inside_desc = "No description."
		if(owner.absorbed && inside_belly.absorbed_desc)
			inside_desc = inside_belly.absorbed_desc
		else if(inside_belly.desc)
			inside_desc = inside_belly.desc

		if(inside_desc != "No description.")
			inside_desc = inside_belly.belly_format_string(inside_desc, owner, use_first_only = TRUE)

		inside = list(
			"absorbed" = owner.absorbed,
			"belly_name" = inside_belly.name,
			"belly_mode" = inside_belly.digest_mode,
			"desc" = inside_desc,
			"pred" = pred,
			"ref" = "\ref[inside_belly]",
			"liq_lvl" = inside_belly.reagents.total_volume,
			"liq_reagent_type" = inside_belly.reagent_chosen,
			"liuq_name" = inside_belly.reagent_name,
		)

		var/list/inside_contents = list()
		for(var/atom/movable/O in inside_belly)
			if(O == owner)
				continue

			var/list/info = list(
				"name" = "[O]",
				"absorbed" = FALSE,
				"stat" = 0,
				"ref" = "\ref[O]",
				"outside" = FALSE,
			)
			if(show_pictures) //disables icon mode
				if(inside_belly.contents.len <= max_icon_content)
					icon_overflow = FALSE
					info["icon"] = cached_nom_icon(O)
				else
					icon_overflow = TRUE
			if(isliving(O))
				var/mob/living/M = O
				info["stat"] = M.stat
				if(M.absorbed)
					info["absorbed"] = TRUE
			UNTYPED_LIST_ADD(inside_contents, info)
		inside["contents"] = inside_contents
	return inside

/datum/vore_look/proc/get_host_mobtype(mob/owner)
	var/list/host_mobtype = list("is_cyborg" = FALSE, "is_vore_simple_mob" = FALSE)
	if(isrobot(owner))
		host_mobtype["is_cyborg"] = TRUE
	else if(istype(owner, /mob/living/simple_mob/vore))	//So far, this does nothing. But, creating this for future belly work
		host_mobtype["is_vore_simple_mob"] = TRUE
	return host_mobtype

/datum/vore_look/proc/get_selected_data(mob/owner)
	var/list/selected_list = null
	if(owner.vore_selected)
		var/obj/belly/selected = owner.vore_selected
		selected_list = list("belly_name" = selected.name)
		if(active_vore_tab == CONTROL_TAB)
			var/list/addons = list()
			for(var/flag_name in selected.mode_flag_list)
				UNTYPED_LIST_ADD(addons, list("label" = flag_name, "selection" = selected.mode_flags & selected.mode_flag_list[flag_name]))
			var/list/belly_mode_data = list(
				"mode" = selected.digest_mode,
				"item_mode" = selected.item_digest_mode,
				"addons" = addons,
				"name_length" = BELLIES_NAME_MAX,
				"mode_options" = host.vore_selected.digest_modes,
				"item_mode_options" = host.vore_selected.item_digest_modes,

			)
			selected_list["belly_mode_data"] = belly_mode_data

		if(active_vore_tab == DESCRIPTIONS_TAB)
			var/list/belly_description_data = list(
				"verb" = selected.vore_verb,
				"release_verb" = selected.release_verb,
				"desc" = selected.desc,
				"absorbed_desc" = selected.absorbed_desc,
				"mode" = selected.digest_mode,
				"message_mode" = selected.message_mode,
				"escapable" = selected.escapable,
			)
			selected_list["belly_description_data"] = belly_description_data


		selected_list += list(list(
			"is_wet" = selected.is_wet,
			"wet_loop" = selected.wet_loop,
			"fancy" = selected.fancy_vore,
			"sound" = selected.vore_sound,
			"release_sound" = selected.release_sound,
			// "messages" // TODO
			"can_taste" = selected.can_taste,
			"is_feedable" = selected.is_feedable,
			"egg_type" = selected.egg_type,
			"egg_name" = selected.egg_name,
			"egg_size" = selected.egg_size,
			"recycling" = selected.recycling,
			"storing_nutrition" = selected.storing_nutrition,
			"entrance_logs" = selected.entrance_logs,
			"nutrition_percent" = selected.nutrition_percent,
			"digest_brute" = selected.digest_brute,
			"digest_burn" = selected.digest_burn,
			"digest_oxy" = selected.digest_oxy,
			"digest_tox" = selected.digest_tox,
			"digest_clone" = selected.digest_clone,
			"bulge_size" = selected.bulge_size,
			"save_digest_mode" = selected.save_digest_mode,
			"display_absorbed_examine" = selected.display_absorbed_examine,
			"shrink_grow_size" = selected.shrink_grow_size,
			"emote_time" = selected.emote_time,
			"emote_active" = selected.emote_active,
			"selective_preference" = selected.selective_preference,
			"nutrition_ex" = owner.nutrition_message_visible,
			"weight_ex" = owner.weight_message_visible,
			"belly_fullscreen" = selected.belly_fullscreen,
			"eating_privacy_local" = selected.eating_privacy_local,
			"silicon_belly_overlay_preference"	= selected.silicon_belly_overlay_preference,
			"belly_mob_mult" = selected.belly_mob_mult,
			"belly_item_mult" = selected.belly_item_mult,
			"belly_overall_mult" = selected.belly_overall_mult,
			"drainmode" = selected.drainmode,
			"affects_voresprite" = selected.affects_vore_sprites,
			"absorbed_voresprite" = selected.count_absorbed_prey_for_sprite,
			"absorbed_multiplier" = selected.absorbed_multiplier,
			"liquid_voresprite" = selected.count_liquid_for_sprite,
			"liquid_multiplier" = selected.liquid_multiplier,
			"item_voresprite" = selected.count_items_for_sprite,
			"item_multiplier" = selected.item_multiplier,
			"health_voresprite" = selected.health_impacts_size,
			"resist_animation" = selected.resist_triggers_animation,
			"voresprite_size_factor" = selected.size_factor_for_sprite,
			"belly_sprite_to_affect" = selected.belly_sprite_to_affect,
			"belly_sprite_option_shown" = LAZYLEN(owner.vore_icon_bellies) >= 1 ? TRUE : FALSE,
			"tail_option_shown" = ishuman(owner),
			"tail_to_change_to" = selected.tail_to_change_to,
			"tail_colouration" = selected.tail_colouration,
			"tail_extra_overlay" = selected.tail_extra_overlay,
			"tail_extra_overlay2" = selected.tail_extra_overlay2,
			"undergarment_chosen" = selected.undergarment_chosen,
			"undergarment_if_none" = selected.undergarment_if_none || "None",
			"undergarment_color" = selected.undergarment_color,
			"belly_fullscreen_color" = selected.belly_fullscreen_color,
			"belly_fullscreen_color2" = selected.belly_fullscreen_color2,
			"belly_fullscreen_color3" = selected.belly_fullscreen_color3,
			"belly_fullscreen_color4" = selected.belly_fullscreen_color4,
			"belly_fullscreen_alpha" = selected.belly_fullscreen_alpha,
			"colorization_enabled" = selected.colorization_enabled,
			"custom_reagentcolor" = selected.custom_reagentcolor,
			"custom_reagentalpha" = selected.custom_reagentalpha,
			"liquid_overlay" = selected.liquid_overlay,
			"max_liquid_level" = selected.max_liquid_level,
			"reagent_touches" = selected.reagent_touches,
			"mush_overlay" = selected.mush_overlay,
			"mush_color" = selected.mush_color,
			"mush_alpha" = selected.mush_alpha,
			"max_mush" = selected.max_mush,
			"min_mush" = selected.min_mush,
			"item_mush_val" = selected.item_mush_val,
			"metabolism_overlay" = selected.metabolism_overlay,
			"metabolism_mush_ratio" = selected.metabolism_mush_ratio,
			"max_ingested" = selected.max_ingested,
			"custom_ingested_color" = selected.custom_ingested_color,
			"custom_ingested_alpha" = selected.custom_ingested_alpha,
			"vorespawn_blacklist" = selected.vorespawn_blacklist,
			"vorespawn_whitelist" = selected.vorespawn_whitelist,
			"vorespawn_absorbed" = (global_flag_check(selected.vorespawn_absorbed, VS_FLAG_ABSORB_YES) + global_flag_check(selected.vorespawn_absorbed, VS_FLAG_ABSORB_PREY)),
			"sound_volume" = selected.sound_volume,
			"noise_freq" = selected.noise_freq,
			"item_digest_logs" = selected.item_digest_logs,
			"private_struggle" = selected.private_struggle,
			//"marking_to_add" = selected.marking_to_add
		))


		var/list/vs_flags = list()
		for(var/flag_name in selected.vore_sprite_flag_list)
			if(selected.vore_sprite_flags & selected.vore_sprite_flag_list[flag_name])
				vs_flags.Add(flag_name)
		selected_list["vore_sprite_flags"] = vs_flags


		selected_list["egg_type"] = selected.egg_type
		selected_list["egg_name"] = selected.egg_name
		selected_list["egg_size"] = selected.egg_size
		selected_list["recycling"] = selected.recycling
		selected_list["storing_nutrition"] = selected.storing_nutrition
		selected_list["item_digest_logs"] = selected.item_digest_logs
		selected_list["contaminates"] = selected.contaminates
		selected_list["contaminate_flavor"] = null
		selected_list["contaminate_color"] = null
		if(selected.contaminates)
			selected_list["contaminate_flavor"] = selected.contamination_flavor
			selected_list["contaminate_color"] = selected.contamination_color

		selected_list["escapable"] = selected.escapable
		selected_list["interacts"] = list()
		if(selected.escapable)
			selected_list["interacts"]["escapechance"] = selected.escapechance
			selected_list["interacts"]["escapechance_absorbed"] = selected.escapechance_absorbed
			selected_list["interacts"]["escapetime"] = selected.escapetime
			selected_list["interacts"]["transferchance"] = selected.transferchance
			selected_list["interacts"]["transferlocation"] = selected.transferlocation
			selected_list["interacts"]["transferchance_secondary"] = selected.transferchance_secondary
			selected_list["interacts"]["transferlocation_secondary"] = selected.transferlocation_secondary
			selected_list["interacts"]["absorbchance"] = selected.absorbchance
			selected_list["interacts"]["digestchance"] = selected.digestchance
			selected_list["interacts"]["belchchance"] = selected.belchchance

		selected_list["autotransfer_enabled"] = selected.autotransfer_enabled
		selected_list["autotransfer"] = list()
		if(selected.autotransfer_enabled)
			selected_list["autotransfer"]["autotransferchance"] = selected.autotransferchance
			selected_list["autotransfer"]["autotransferwait"] = selected.autotransferwait
			selected_list["autotransfer"]["autotransferlocation"] = selected.autotransferlocation
			selected_list["autotransfer"]["autotransferextralocation"] = selected.autotransferextralocation
			selected_list["autotransfer"]["autotransferchance_secondary"] = selected.autotransferchance_secondary
			selected_list["autotransfer"]["autotransferlocation_secondary"] = selected.autotransferlocation_secondary
			selected_list["autotransfer"]["autotransferextralocation_secondary"] = selected.autotransferextralocation_secondary
			selected_list["autotransfer"]["autotransfer_min_amount"] = selected.autotransfer_min_amount
			selected_list["autotransfer"]["autotransfer_max_amount"] = selected.autotransfer_max_amount
			//auto-transfer flags
			var/list/at_whitelist = list()
			for(var/flag_name in selected.autotransfer_flags_list)
				if(selected.autotransfer_whitelist & selected.autotransfer_flags_list[flag_name])
					at_whitelist.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_whitelist"] = at_whitelist
			var/list/at_blacklist = list()
			for(var/flag_name in selected.autotransfer_flags_list)
				if(selected.autotransfer_blacklist & selected.autotransfer_flags_list[flag_name])
					at_blacklist.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_blacklist"] = at_blacklist
			var/list/at_whitelist_items = list()
			for(var/flag_name in selected.autotransfer_flags_list_items)
				if(selected.autotransfer_whitelist_items & selected.autotransfer_flags_list_items[flag_name])
					at_whitelist_items.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_whitelist_items"] = at_whitelist_items
			var/list/at_blacklist_items = list()
			for(var/flag_name in selected.autotransfer_flags_list_items)
				if(selected.autotransfer_blacklist_items & selected.autotransfer_flags_list_items[flag_name])
					at_blacklist_items.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_blacklist_items"] = at_blacklist_items
			var/list/at_secondary_whitelist = list()
			for(var/flag_name in selected.autotransfer_flags_list)
				if(selected.autotransfer_secondary_whitelist & selected.autotransfer_flags_list[flag_name])
					at_secondary_whitelist.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_secondary_whitelist"] = at_secondary_whitelist
			var/list/at_secondary_blacklist = list()
			for(var/flag_name in selected.autotransfer_flags_list)
				if(selected.autotransfer_secondary_blacklist & selected.autotransfer_flags_list[flag_name])
					at_secondary_blacklist.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_secondary_blacklist"] = at_secondary_blacklist
			var/list/at_secondary_whitelist_items = list()
			for(var/flag_name in selected.autotransfer_flags_list_items)
				if(selected.autotransfer_secondary_whitelist_items & selected.autotransfer_flags_list_items[flag_name])
					at_secondary_whitelist_items.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_secondary_whitelist_items"] = at_secondary_whitelist_items
			var/list/at_secondary_blacklist_items = list()
			for(var/flag_name in selected.autotransfer_flags_list_items)
				if(selected.autotransfer_secondary_blacklist_items & selected.autotransfer_flags_list_items[flag_name])
					at_secondary_blacklist_items.Add(flag_name)
			selected_list["autotransfer"]["autotransfer_secondary_blacklist_items"] = at_secondary_blacklist_items

		selected_list["disable_hud"] = selected.disable_hud
		selected_list["colorization_enabled"] = selected.colorization_enabled
		selected_list["belly_fullscreen_color"] = selected.belly_fullscreen_color
		selected_list["belly_fullscreen_color2"] = selected.belly_fullscreen_color2
		selected_list["belly_fullscreen_color3"] = selected.belly_fullscreen_color3
		selected_list["belly_fullscreen_color4"] = selected.belly_fullscreen_color4
		selected_list["belly_fullscreen_alpha"] = selected.belly_fullscreen_alpha

		if(selected.colorization_enabled)
			selected_list["possible_fullscreens"] = icon_states('icons/mob/screen_full_vore_list.dmi') //Makes any icons inside of here selectable.
		else
			selected_list["possible_fullscreens"] = icon_states('icons/mob/screen_full_vore.dmi') //Non colorable

		var/list/selected_contents = list()
		for(var/O in selected)
			var/list/info = list(
				"name" = "[O]",
				"absorbed" = FALSE,
				"stat" = 0,
				"ref" = "\ref[O]",
				"outside" = TRUE,
			)
			if(show_pictures) //disables icon mode
				if(selected.contents.len <= max_icon_content)
					icon_overflow = FALSE
					info["icon"] = cached_nom_icon(O)
				else
					icon_overflow = TRUE

			if(isliving(O))
				var/mob/living/M = O
				info["stat"] = M.stat
				if(M.absorbed)
					info["absorbed"] = TRUE
			selected_contents.Add(list(info))
		selected_list["contents"] = selected_contents

		// liquid belly options
		selected_list["show_liq"] = selected.show_liquids
		selected_list["liq_interacts"] = list()
		if(selected.show_liquids)
			selected_list["liq_interacts"]["liq_reagent_gen"] = selected.reagentbellymode
			selected_list["liq_interacts"]["liq_reagent_type"] = selected.reagent_chosen
			selected_list["liq_interacts"]["liq_reagent_name"] = selected.reagent_name
			selected_list["liq_interacts"]["liq_reagent_transfer_verb"] = selected.reagent_transfer_verb
			selected_list["liq_interacts"]["liq_reagent_nutri_rate"] = selected.gen_time
			selected_list["liq_interacts"]["liq_reagent_capacity"] = selected.custom_max_volume
			selected_list["liq_interacts"]["liq_sloshing"] = selected.vorefootsteps_sounds
			selected_list["liq_interacts"]["liq_reagent_addons"] = list()
			for(var/flag_name in selected.reagent_mode_flag_list)
				if(selected.reagent_mode_flags & selected.reagent_mode_flag_list[flag_name])
					var/list/selected_list_member = selected_list["liq_interacts"]["liq_reagent_addons"]
					ASSERT(islist(selected_list_member))
					selected_list_member.Add(flag_name)
			selected_list["liq_interacts"]["custom_reagentcolor"] = selected.custom_reagentcolor ? selected.custom_reagentcolor : selected.reagentcolor
			selected_list["liq_interacts"]["custom_reagentalpha"] = selected.custom_reagentalpha ? selected.custom_reagentalpha : "Default"
			selected_list["liq_interacts"]["liquid_overlay"] = selected.liquid_overlay
			selected_list["liq_interacts"]["max_liquid_level"] = selected.max_liquid_level
			selected_list["liq_interacts"]["reagent_touches"] = selected.reagent_touches
			selected_list["liq_interacts"]["mush_overlay"] = selected.mush_overlay
			selected_list["liq_interacts"]["mush_color"] = selected.mush_color
			selected_list["liq_interacts"]["mush_alpha"] = selected.mush_alpha
			selected_list["liq_interacts"]["max_mush"] = selected.max_mush
			selected_list["liq_interacts"]["min_mush"] = selected.min_mush
			selected_list["liq_interacts"]["item_mush_val"] = selected.item_mush_val
			selected_list["liq_interacts"]["metabolism_overlay"] = selected.metabolism_overlay
			selected_list["liq_interacts"]["metabolism_mush_ratio"] = selected.metabolism_mush_ratio
			selected_list["liq_interacts"]["max_ingested"] = selected.max_ingested
			selected_list["liq_interacts"]["custom_ingested_color"] = selected.custom_ingested_color ? selected.custom_ingested_color : "#3f6088"
			selected_list["liq_interacts"]["custom_ingested_alpha"] = selected.custom_ingested_alpha

		selected_list["show_liq_fullness"] = selected.show_fullness_messages
		selected_list["liq_messages"] = list()
		if(selected.show_fullness_messages)
			selected_list["liq_messages"]["liq_msg_toggle1"] = selected.liquid_fullness1_messages
			selected_list["liq_messages"]["liq_msg_toggle2"] = selected.liquid_fullness2_messages
			selected_list["liq_messages"]["liq_msg_toggle3"] = selected.liquid_fullness3_messages
			selected_list["liq_messages"]["liq_msg_toggle4"] = selected.liquid_fullness4_messages
			selected_list["liq_messages"]["liq_msg_toggle5"] = selected.liquid_fullness5_messages

			selected_list["liq_messages"]["liq_msg1"] = selected.liquid_fullness1_messages
			selected_list["liq_messages"]["liq_msg2"] = selected.liquid_fullness2_messages
			selected_list["liq_messages"]["liq_msg3"] = selected.liquid_fullness3_messages
			selected_list["liq_messages"]["liq_msg4"] = selected.liquid_fullness4_messages
			selected_list["liq_messages"]["liq_msg5"] = selected.liquid_fullness5_messages
	return selected_list

#undef CONTROL_TAB
#undef DESCRIPTIONS_TAB
#undef OPTIONS_TAB
#undef SOUNDS_TAB
#undef VISUALS_TAB
#undef INTERACTIONS_TAB
#undef CONTENTS_TAB
#undef LIQUID_OPTIONS_TAB
