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
				"name_min" = BELLIES_NAME_MIN,
				"mode_options" = host.vore_selected.digest_modes,
				"item_mode_options" = host.vore_selected.item_digest_modes,

			)
			selected_list["belly_mode_data"] = belly_mode_data

		if(active_vore_tab == DESCRIPTIONS_TAB)
			// Compile our displayed options
			var/list/displayed_options = list(
				VPANEL_DESCRIPTION_TAB,
				VPANEL_EXAMINE_TAB,
				VPANEL_TRASH_EATER_TAB
			)
			if(selected.message_mode || selected.escapable)
				displayed_options += VPANEL_STRUGGLE_TAB
				displayed_options += VPANEL_ESCAPE_TAB
				displayed_options += VPANEL_ESCAPE_ABSORBED_TAB
			if(selected.message_mode || (selected.escapable && (selected.transferlocation || selected.transferlocation_secondary)) || selected.autotransfer_enabled && (selected.autotransferlocation || selected.autotransferlocation_secondary))
				displayed_options += VPANEL_TRANSFER_TAB
			if(selected.message_mode || selected.escapable && (selected.digestchance || selected.absorbchance))
				displayed_options += VPANEL_INTERACTION_TAB
			if(selected.message_mode || selected.digest_mode == DM_DIGEST || selected.digest_mode == DM_SELECT || selected.digest_mode == DM_ABSORB || selected.digest_mode == DM_UNABSORB)
				displayed_options += VPANEL_BELLYMODE_TAB
			if(selected.message_mode || selected.emote_active)
				displayed_options += VPANEL_IDLE_TAB
			if(selected.message_mode || selected.show_fullness_messages)
				displayed_options += VPANEL_LIQUIDS_TAB

			var/list/belly_description_data = list(
				"displayed_message_types" = compile_message_data(selected),
				"verb" = selected.vore_verb,
				"release_verb" = selected.release_verb,
				"message_mode" = selected.message_mode,
				"displayed_options" = displayed_options,
				"message_option" = message_option,
				"message_subtab" = message_subtab,
				"selected_message" = selected_message,
				"show_liq_fullness" = selected.show_fullness_messages,
				"emote_time" = selected.emote_time,
				"emote_active" = selected.emote_active,
				"entrance_logs" = selected.entrance_logs,
				"item_digest_logs" = selected.item_digest_logs,
				"name_min" = BELLIES_NAME_MIN,
				"name_length" = BELLIES_NAME_MAX,
			)
			selected_list["belly_description_data"] = belly_description_data

		if(active_vore_tab == OPTIONS_TAB)
			var/list/silicon_control = list(
				"silicon_belly_overlay_preference"	= selected.silicon_belly_overlay_preference,
				"belly_sprite_option_shown" = LAZYLEN(owner.vore_icon_bellies) >= 1 ? TRUE : FALSE,
				"belly_sprite_to_affect" = selected.belly_sprite_to_affect
			)
			var/list/belly_option_data = list(
				"can_taste" = selected.can_taste,
				"is_feedable" = selected.is_feedable,
				"nutrition_percent" = selected.nutrition_percent,
				"digest_brute" = selected.digest_brute,
				"digest_burn" = selected.digest_burn,
				"digest_oxy" = selected.digest_oxy,
				"digest_tox" = selected.digest_tox,
				"digest_clone" = selected.digest_clone,
				"digest_max" = selected.digest_max,
				"digest_free" = selected.get_unused_digestion_damage(),
				"bulge_size" = selected.bulge_size,
				"shrink_grow_size" = selected.shrink_grow_size,
				"contaminates" = selected.contaminates,
				"egg_type" = selected.egg_type,
				"egg_types" = GLOB.global_vore_egg_types,
				"egg_name" = selected.egg_name,
				"egg_name_length" = BELLIES_NAME_MAX,
				"egg_size" = selected.egg_size,
				"recycling" = selected.recycling,
				"storing_nutrition" = selected.storing_nutrition,
				"selective_preference" = selected.selective_preference,
				"save_digest_mode" = selected.save_digest_mode,
				"eating_privacy_local" = selected.eating_privacy_local,
				"vorespawn_blacklist" = selected.vorespawn_blacklist,
				"vorespawn_whitelist" = selected.vorespawn_whitelist,
				"vorespawn_absorbed" = (global_flag_check(selected.vorespawn_absorbed, VS_FLAG_ABSORB_YES) + global_flag_check(selected.vorespawn_absorbed, VS_FLAG_ABSORB_PREY)),
				"private_struggle" = selected.private_struggle,
				"drainmode" = selected.drainmode,
				"drainmode_options" = selected.drainmodes,
				"mob_belly_controls" = silicon_control
			)
			if(selected.contaminates)
				belly_option_data += list(
				"contaminate_flavor" = selected.contamination_flavor,
				"contaminate_options" = GLOB.contamination_flavors,
				"contaminate_color" = selected.contamination_color,
				"contaminate_colors" = GLOB.contamination_colors
				)

			selected_list["belly_option_data"] = belly_option_data

		if(active_vore_tab == SOUNDS_TAB)
			var/list/belly_sound_data = list(
				"is_wet" = selected.is_wet,
				"wet_loop" = selected.wet_loop,
				"fancy" = selected.fancy_vore,
				"sound" = selected.vore_sound,
				"release_sound" = selected.release_sound,
				"sound_volume" = selected.sound_volume,
				"noise_freq" = selected.noise_freq,
				"min_voice_freq" = MIN_VOICE_FREQ,
				"max_voice_freq" = MAX_VOICE_FREQ,
				"vore_sound_list" = (selected.fancy_vore ? GLOB.fancy_vore_sounds : GLOB.classic_vore_sounds),
				"release_sound_list" = (selected.fancy_vore ? GLOB.fancy_release_sounds : GLOB.classic_release_sounds)
			)
			selected_list["belly_sound_data"] = belly_sound_data

		if(active_vore_tab == VISUALS_TAB)
			var/list/belly_fullscreens
			if(selected.colorization_enabled)
				belly_fullscreens = icon_states('icons/mob/screen_full_vore_list.dmi') //Makes any icons inside of here selectable.
			else
				belly_fullscreens = icon_states('icons/mob/screen_full_vore.dmi') //Non colorable

			var/list/vs_flags = list()
			for(var/flag_name in selected.vore_sprite_flag_list)
				UNTYPED_LIST_ADD(vs_flags, list("label" = flag_name, "selection" = selected.vore_sprite_flags & selected.vore_sprite_flag_list[flag_name]))

			var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[host.vore_selected.undergarment_chosen]
			var/list/undergarments
			if(UWC)
				undergarments = UWC.items

			var/list/belly_visual_data = list(
			"belly_fullscreen" = selected.belly_fullscreen,
			"colorization_enabled" = selected.colorization_enabled,
			"belly_fullscreen_color" = selected.belly_fullscreen_color,
			"belly_fullscreen_color2" = selected.belly_fullscreen_color2,
			"belly_fullscreen_color3" = selected.belly_fullscreen_color3,
			"belly_fullscreen_color4" = selected.belly_fullscreen_color4,
			"belly_fullscreen_alpha" = selected.belly_fullscreen_alpha,
			"possible_fullscreens" = belly_fullscreens,
			"disable_hud" = selected.disable_hud,
			"vore_sprite_flags" = vs_flags,
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
			"belly_sprite_options" = host.vore_icon_bellies,
			"undergarment_chosen" = selected.undergarment_chosen,
			"undergarment_if_none" = selected.undergarment_if_none || "None",
			"undergarment_options" = global_underwear.categories,
			"undergarment_options_if_none" = undergarments,
			"undergarment_color" = selected.undergarment_color,
			"tail_option_shown" = ishuman(owner),
			"tail_to_change_to" = selected.tail_to_change_to,
			"tail_sprite_options" = global.tail_styles_list
			)
			selected_list["belly_visual_data"] = belly_visual_data

		if(active_vore_tab == INTERACTIONS_TAB)
			var/list/belly_interaction_data = list(
				"escapable" = selected.escapable,
				"interacts" = compile_interact_data(selected),
				"autotransfer_enabled" = selected.autotransfer_enabled,
				"autotransfer" = compile_autotransfer_data(selected)
			)
			selected_list["belly_interaction_data"] = belly_interaction_data


		var/list/selected_contents
		var/total_content_count = 0
		for(var/O in selected)
			total_content_count++
			if(active_vore_tab == CONTENTS_TAB)
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
				LAZYADD(selected_contents, list(info))
		if(active_vore_tab == CONTENTS_TAB)
			selected_list["contents"] = selected_contents

		selected_list["content_length"] = total_content_count

		if(active_vore_tab == LIQUID_OPTIONS_TAB)
			// liquid belly options
			var/list/belly_liquid_data = list(
				"show_liq" = selected.show_liquids,
				"liq_interacts" = compile_liquid_interact_data(selected)
			)
			selected_list["belly_liquid_data"] = belly_liquid_data

	return selected_list

#undef CONTROL_TAB
#undef DESCRIPTIONS_TAB
#undef OPTIONS_TAB
#undef SOUNDS_TAB
#undef VISUALS_TAB
#undef INTERACTIONS_TAB
#undef CONTENTS_TAB
#undef LIQUID_OPTIONS_TAB
