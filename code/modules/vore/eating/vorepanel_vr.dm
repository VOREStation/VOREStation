//
// Vore management panel for players
//

//INSERT COLORIZE-ONLY STOMACHS HERE
var/global/list/belly_colorable_only_fullscreens = list("a_synth_flesh_mono",
														"a_synth_flesh_mono_hole",
														"a_anim_belly",
														"multi_layer_test_tummy",
														"gematically_angular",
														"entrance_to_a_tumby",
														"passage_to_a_tumby",
														"destination_tumby",
														"destination_tumby_fluidless",
														"post_tumby_passage",
														"post_tumby_passage_fluidless",
														"not_quite_tumby",
														"could_it_be_a_tumby")

/mob
	var/datum/vore_look/vorePanel

/mob/proc/insidePanel()
	set name = "Vore Panel"
	set category = "IC.Vore"

	if(SSticker.current_state == GAME_STATE_INIT)
		return

	if(!isliving(src))
		init_vore()

	if(!vorePanel)
		if(!isnewplayer(src))
			log_debug("[src] ([type], \ref[src]) didn't have a vorePanel and tried to use the verb.")
		vorePanel = new(src)

	vorePanel.tgui_interact(src)

/mob/proc/updateVRPanel() //Panel popup update call from belly events.
	if(vorePanel)
		SStgui.update_uis(vorePanel)

//
// Callback Handler for the Inside form
//
/datum/vore_look
	var/mob/host // Note, we do this in case we ever want to allow people to view others vore panels
	var/unsaved_changes = FALSE
	var/show_pictures = TRUE

/datum/vore_look/New(mob/new_host)
	if(istype(new_host))
		host = new_host
	. = ..()

/datum/vore_look/Destroy()
	host = null
	. = ..()

/datum/vore_look/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/vore)
	. += get_asset_datum(/datum/asset/spritesheet/vore_colorized) //Either this isn't working or my cache is corrupted and won't show them.

/datum/vore_look/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VorePanel", "Vore Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

// This looks weird, but all tgui_host is used for is state checking
// So this allows us to use the self_state just fine.
/datum/vore_look/tgui_host(mob/user)
	return host

// Note, in order to allow others to look at others vore panels, this state would need
// to be modified.
/datum/vore_look/tgui_state(mob/user)
	return GLOB.tgui_vorepanel_state

/datum/vore_look/var/static/list/nom_icons
/datum/vore_look/proc/cached_nom_icon(atom/target)
	LAZYINITLIST(nom_icons)

	var/key = ""
	if(isobj(target))
		key = "[target.type]"
	else if(ismob(target))
		var/mob/M = target
		key = "\ref[target][M.real_name]"
	if(nom_icons[key])
		. = nom_icons[key]
	else
		. = icon2base64(getFlatIcon(target,defdir=SOUTH,no_anim=TRUE))
		nom_icons[key] = .

/datum/vore_look/tgui_static_data(mob/user)
	var/list/data = ..()

	data["vore_words"] = list(
		"%goo" = GLOB.vore_words_goo,
		"%happybelly" = GLOB.vore_words_hbellynoises,
		"%fat" = GLOB.vore_words_fat,
		"%grip" = GLOB.vore_words_grip,
		"%cozy" = GLOB.vore_words_cozyholdingwords,
		"%angry" = GLOB.vore_words_angry,
		"%acid" = GLOB.vore_words_acid,
		"%snack" = GLOB.vore_words_snackname,
		"%hot" = GLOB.vore_words_hot,
		"%snake" = GLOB.vore_words_snake,
	)

	return data

/datum/vore_look/tgui_data(mob/user)
	var/list/data = list()

	if(!host)
		return data

	data["unsaved_changes"] = unsaved_changes
	data["show_pictures"] = show_pictures

	var/atom/hostloc = host.loc
	var/list/inside = list()
	if(isbelly(hostloc))
		var/obj/belly/inside_belly = hostloc
		var/mob/living/pred = inside_belly.owner

		var/inside_desc = "No description."
		if(host.absorbed && inside_belly.absorbed_desc)
			inside_desc = inside_belly.absorbed_desc
		else if(inside_belly.desc)
			inside_desc = inside_belly.desc

		if(inside_desc != "No description.")
			inside_desc = inside_belly.belly_format_string(inside_desc, host, use_first_only = TRUE)

		inside = list(
			"absorbed" = host.absorbed,
			"belly_name" = inside_belly.name,
			"belly_mode" = inside_belly.digest_mode,
			"desc" = inside_desc,
			"pred" = pred,
			"ref" = "\ref[inside_belly]",
		)

		var/list/inside_contents = list()
		for(var/atom/movable/O in inside_belly)
			if(O == host)
				continue

			var/list/info = list(
				"name" = "[O]",
				"absorbed" = FALSE,
				"stat" = 0,
				"ref" = "\ref[O]",
				"outside" = FALSE,
			)
			if(show_pictures)
				info["icon"] = cached_nom_icon(O)
			if(isliving(O))
				var/mob/living/M = O
				info["stat"] = M.stat
				if(M.absorbed)
					info["absorbed"] = TRUE
			inside_contents.Add(list(info))
		inside["contents"] = inside_contents
	data["inside"] = inside

	var/is_cyborg = FALSE
	var/is_vore_simple_mob = FALSE
	if(isrobot(host))
		is_cyborg = TRUE
	else if(istype(host, /mob/living/simple_mob/vore))	//So far, this does nothing. But, creating this for future belly work
		is_vore_simple_mob = TRUE
	data["host_mobtype"] = list(
		"is_cyborg" = is_cyborg,
		"is_vore_simple_mob" = is_vore_simple_mob
	)

	var/list/our_bellies = list()
	for(var/obj/belly/B as anything in host.vore_organs)
		our_bellies.Add(list(list(
			"selected" = (B == host.vore_selected),
			"name" = B.name,
			"ref" = "\ref[B]",
			"digest_mode" = B.digest_mode,
			"contents" = LAZYLEN(B.contents),
		)))
	data["our_bellies"] = our_bellies

	var/list/selected_list = null
	if(host.vore_selected)
		var/obj/belly/selected = host.vore_selected
		selected_list = list(
			"belly_name" = selected.name,
			"message_mode" = selected.message_mode,
			"is_wet" = selected.is_wet,
			"wet_loop" = selected.wet_loop,
			"mode" = selected.digest_mode,
			"item_mode" = selected.item_digest_mode,
			"verb" = selected.vore_verb,
			"release_verb" = selected.release_verb,
			"desc" = selected.desc,
			"absorbed_desc" = selected.absorbed_desc,
			"fancy" = selected.fancy_vore,
			"sound" = selected.vore_sound,
			"release_sound" = selected.release_sound,
			// "messages" // TODO
			"can_taste" = selected.can_taste,
			"egg_type" = selected.egg_type,
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
			"nutrition_ex" = host.nutrition_message_visible,
			"weight_ex" = host.weight_message_visible,
			"belly_fullscreen" = selected.belly_fullscreen,
			"belly_fullscreen_color" = selected.belly_fullscreen_color,
			"belly_fullscreen_color_secondary" = selected.belly_fullscreen_color_secondary,
			"belly_fullscreen_color_trinary" = selected.belly_fullscreen_color_trinary,
			"colorization_enabled" = selected.colorization_enabled,
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
			"belly_sprite_option_shown" = LAZYLEN(host.vore_icon_bellies) >= 1 ? TRUE : FALSE,
			"tail_option_shown" = ishuman(host),
			"tail_to_change_to" = selected.tail_to_change_to,
			"tail_colouration" = selected.tail_colouration,
			"tail_extra_overlay" = selected.tail_extra_overlay,
			"tail_extra_overlay2" = selected.tail_extra_overlay2,
			"undergarment_chosen" = selected.undergarment_chosen,
			"undergarment_if_none" = selected.undergarment_if_none || "None",
			"undergarment_color" = selected.undergarment_color
		)

		var/list/addons = list()
		for(var/flag_name in selected.mode_flag_list)
			if(selected.mode_flags & selected.mode_flag_list[flag_name])
				addons.Add(flag_name)
		selected_list["addons"] = addons

		var/list/vs_flags = list()
		for(var/flag_name in selected.vore_sprite_flag_list)
			if(selected.vore_sprite_flags & selected.vore_sprite_flag_list[flag_name])
				vs_flags.Add(flag_name)
		selected_list["vore_sprite_flags"] = vs_flags


		selected_list["egg_type"] = selected.egg_type
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

		selected_list["disable_hud"] = selected.disable_hud
		selected_list["colorization_enabled"] = selected.colorization_enabled
		selected_list["belly_fullscreen_color"] = selected.belly_fullscreen_color
		selected_list["belly_fullscreen_color_secondary"] = selected.belly_fullscreen_color_secondary
		selected_list["belly_fullscreen_color_trinary"] = selected.belly_fullscreen_color_trinary

		if(selected.colorization_enabled)
			selected_list["possible_fullscreens"] = icon_states('icons/mob/screen_full_colorized_vore.dmi') //Makes any icons inside of here selectable.
		else
			selected_list["possible_fullscreens"] = icon_states('icons/mob/screen_full_vore.dmi') //Where all stomachs - colorable and not - are stored.
			//INSERT COLORIZE-ONLY STOMACHS HERE.
			//This manually removed color-only stomachs from the above list.
			//For some reason, colorized stomachs have to be added to both colorized_vore(to be selected) and full_vore (to show the preview in tgui)
			//Why? I have no flipping clue. As you can see above, vore_colorized is included in the assets but isn't working. It makes no sense.
			//I can only imagine this is a BYOND/TGUI issue with the cache. If you can figure out how to fix this and make it so you only need to
			//include things in full_colorized_vore, that would be great. For now, this is the only workaround that I could get to work.
			selected_list["possible_fullscreens"] -= belly_colorable_only_fullscreens

		var/list/selected_contents = list()
		for(var/O in selected)
			var/list/info = list(
				"name" = "[O]",
				"absorbed" = FALSE,
				"stat" = 0,
				"ref" = "\ref[O]",
				"outside" = TRUE,
			)
			if(show_pictures)
				info["icon"] = cached_nom_icon(O)
			if(isliving(O))
				var/mob/living/M = O
				info["stat"] = M.stat
				if(M.absorbed)
					info["absorbed"] = TRUE
			selected_contents.Add(list(info))
		selected_list["contents"] = selected_contents

	data["selected"] = selected_list
	data["prefs"] = list(
		"digestable" = host.digestable,
		"devourable" = host.devourable,
		"resizable" = host.resizable,
		"feeding" = host.feeding,
		"absorbable" = host.absorbable,
		"digest_leave_remains" = host.digest_leave_remains,
		"allowmobvore" = host.allowmobvore,
		"permit_healbelly" = host.permit_healbelly,
		"show_vore_fx" = host.show_vore_fx,
		"can_be_drop_prey" = host.can_be_drop_prey,
		"can_be_drop_pred" = host.can_be_drop_pred,
		"allow_inbelly_spawning" = host.allow_inbelly_spawning,
		"allow_spontaneous_tf" = host.allow_spontaneous_tf,
		"step_mechanics_active" = host.step_mechanics_pref,
		"pickup_mechanics_active" = host.pickup_pref,
		"noisy" = host.noisy,
		"allow_mind_transfer" = host.allow_mind_transfer,
		"drop_vore" = host.drop_vore,
		"slip_vore" = host.slip_vore,
		"stumble_vore" = host.stumble_vore,
		"throw_vore" = host.throw_vore,
		"food_vore" = host.food_vore,
		"digest_pain" = host.digest_pain,
		"nutrition_message_visible" = host.nutrition_message_visible,
		"nutrition_messages" = host.nutrition_messages,
		"weight_message_visible" = host.weight_message_visible,
		"weight_messages" = host.weight_messages,
		"eating_privacy_global" = host.eating_privacy_global,
		"allow_mimicry" = host.allow_mimicry,
	)

	return data

/datum/vore_look/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("show_pictures")
			show_pictures = !show_pictures
			return TRUE
		if("int_help")
			tgui_alert(ui.user, "These control how your belly responds to someone using 'resist' while inside you. The percent chance to trigger each is listed below, \
					and you can change them to whatever you see fit. Setting them to 0% will disable the possibility of that interaction. \
					These only function as long as interactions are turned on in general. Keep in mind, the 'belly mode' interactions (digest/absorb) \
					will affect all prey in that belly, if one resists and triggers digestion/absorption. If multiple trigger at the same time, \
					only the first in the order of 'Escape > Transfer > Absorb > Digest' will occur.","Interactions Help")
			return TRUE

		// Host is inside someone else, and is trying to interact with something else inside that person.
		if("pick_from_inside")
			return pick_from_inside(ui.user, params)

		// Host is trying to interact with something in host's belly.
		if("pick_from_outside")
			return pick_from_outside(ui.user, params)

		if("newbelly")
			if(host.vore_organs.len >= BELLIES_MAX)
				return FALSE

			var/new_name = html_encode(tgui_input_text(ui.user,"New belly's name:","New Belly"))

			if(!new_name)
				return FALSE

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
				tgui_alert_async(ui.user, failure_msg, "Error!")
				return TRUE

			var/obj/belly/NB = new(host)
			NB.name = new_name
			host.vore_selected = NB
			//Ensures that new stomachs that are made have the same silicon overlay pref as the first stomach.
			if(LAZYLEN(host.vore_organs))
				var/obj/belly/belly_to_check = host.vore_organs[1]
				NB.silicon_belly_overlay_preference = belly_to_check.silicon_belly_overlay_preference
			unsaved_changes = TRUE
			return TRUE
		if("importpanel")
			import_belly(host)
			return TRUE
		if("bellypick")
			host.vore_selected = locate(params["bellypick"])
			return TRUE
		if("move_belly")
			var/dir = text2num(params["dir"])
			if(LAZYLEN(host.vore_organs) <= 1)
				to_chat(ui.user, span_warning("You can't sort bellies with only one belly to sort..."))
				return TRUE

			var/current_index = host.vore_organs.Find(host.vore_selected)
			if(current_index)
				var/new_index = clamp(current_index + dir, 1, LAZYLEN(host.vore_organs))
				host.vore_organs.Swap(current_index, new_index)
				unsaved_changes = TRUE
			return TRUE

		if("set_attribute")
			return set_attr(ui.user, params)

		if("saveprefs")
			if(isnewplayer(host))
				var/choice = tgui_alert(ui.user, "Warning: Saving your vore panel while in the lobby will save it to the CURRENTLY LOADED character slot, and potentially overwrite it. Are you SURE you want to overwrite your current slot with these vore bellies?", "WARNING!", list("No, abort!", "Yes, save."))
				if(choice != "Yes, save.")
					return TRUE
			else if(host.real_name != host.client.prefs.real_name || (!ishuman(host) && !issilicon(host)))
				var/choice = tgui_alert(ui.user, "Warning: Saving your vore panel while playing what is very-likely not your normal character will overwrite whatever character you have loaded in character setup. Maybe this is your 'playing a simple mob' slot, though. Are you SURE you want to overwrite your current slot with these vore bellies?", "WARNING!", list("No, abort!", "Yes, save."))
				if(choice != "Yes, save.")
					return TRUE
			if(!host.save_vore_prefs())
				tgui_alert_async(ui.user, "ERROR: Virgo-specific preferences failed to save!","Error")
			else
				to_chat(ui.user, span_notice("Virgo-specific preferences saved!"))
				unsaved_changes = FALSE
			return TRUE
		if("reloadprefs")
			var/alert = tgui_alert(ui.user, "Are you sure you want to reload character slot preferences? This will remove your current vore organs and eject their contents.","Confirmation",list("Reload","Cancel"))
			if(alert != "Reload")
				return FALSE
			if(!host.apply_vore_prefs())
				tgui_alert_async(ui.user, "ERROR: Virgo-specific preferences failed to apply!","Error")
			else
				to_chat(ui.user,span_notice("Virgo-specific preferences applied from active slot!"))
				unsaved_changes = FALSE
			return TRUE
		if("loadprefsfromslot")
			var/alert = tgui_alert(ui.user, "Are you sure you want to load another character slot's preferences? This will remove your current vore organs and eject their contents. This will not be immediately saved to your character slot, and you will need to save manually to overwrite your current bellies and preferences.","Confirmation",list("Load","Cancel"))
			if(alert != "Load")
				return FALSE
			if(!host.load_vore_prefs_from_slot())
				tgui_alert_async(ui.user, "ERROR: Virgo-specific preferences failed to apply!","Error")
			else
				to_chat(ui.user,span_notice("Virgo-specific preferences applied from active slot!"))
				unsaved_changes = TRUE
			return TRUE
		if("exportpanel")
			if(!ui.user)
				return FALSE

			var/datum/vore_look/export_panel/exportPanel
			if(!exportPanel)
				exportPanel = new(ui.user)

			if(!exportPanel)
				to_chat(ui.user,span_notice("Export panel undefined: [exportPanel]"))
				return FALSE

			exportPanel.open_export_panel(ui.user)

			return TRUE
		if("setflavor")
			var/new_flavor = html_encode(tgui_input_text(ui.user,"What your character tastes like (400ch limit). This text will be printed to the pred after 'X tastes of...' so just put something like 'strawberries and cream':","Character Flavor",host.vore_taste))
			if(!new_flavor)
				return FALSE

			new_flavor = readd_quotes(new_flavor)
			if(length(new_flavor) > FLAVOR_MAX)
				tgui_alert_async(ui.user, "Entered flavor/taste text too long. [FLAVOR_MAX] character limit.","Error!")
				return FALSE
			host.vore_taste = new_flavor
			unsaved_changes = TRUE
			return TRUE
		if("setsmell")
			var/new_smell = html_encode(tgui_input_text(ui.user,"What your character smells like (400ch limit). This text will be printed to the pred after 'X smells of...' so just put something like 'strawberries and cream':","Character Smell",host.vore_smell))
			if(!new_smell)
				return FALSE

			new_smell = readd_quotes(new_smell)
			if(length(new_smell) > FLAVOR_MAX)
				tgui_alert_async(ui.user, "Entered perfume/smell text too long. [FLAVOR_MAX] character limit.","Error!")
				return FALSE
			host.vore_smell = new_smell
			unsaved_changes = TRUE
			return TRUE
		if("toggle_dropnom_pred")
			host.can_be_drop_pred = !host.can_be_drop_pred
			if(host.client.prefs_vr)
				host.client.prefs_vr.can_be_drop_pred = host.can_be_drop_pred
			unsaved_changes = TRUE
			return TRUE
		if("toggle_dropnom_prey")
			host.can_be_drop_prey = !host.can_be_drop_prey
			if(host.client.prefs_vr)
				host.client.prefs_vr.can_be_drop_prey = host.can_be_drop_prey
			unsaved_changes = TRUE
			return TRUE
		if("toggle_allow_inbelly_spawning")
			host.allow_inbelly_spawning = !host.allow_inbelly_spawning
			if(host.client.prefs_vr)
				host.client.prefs_vr.allow_inbelly_spawning = host.allow_inbelly_spawning
			unsaved_changes = TRUE
			return TRUE
		if("toggle_allow_spontaneous_tf")
			host.allow_spontaneous_tf = !host.allow_spontaneous_tf
			if(host.client.prefs_vr)
				host.client.prefs_vr.allow_spontaneous_tf = host.allow_spontaneous_tf
			unsaved_changes = TRUE
			return TRUE
		if("toggle_digest")
			host.digestable = !host.digestable
			if(host.client.prefs_vr)
				host.client.prefs_vr.digestable = host.digestable
			unsaved_changes = TRUE
			return TRUE
		if("toggle_global_privacy")
			host.eating_privacy_global = !host.eating_privacy_global
			if(host.client.prefs_vr)
				host.eating_privacy_global = host.eating_privacy_global
			unsaved_changes = TRUE
			return TRUE
		if("toggle_mimicry")
			host.allow_mimicry = !host.allow_mimicry
			if(host.client.prefs_vr)
				host.client.prefs_vr.allow_mimicry = host.allow_mimicry
			unsaved_changes = TRUE
			return TRUE
		if("toggle_devour")
			host.devourable = !host.devourable
			if(host.client.prefs_vr)
				host.client.prefs_vr.devourable = host.devourable
			unsaved_changes = TRUE
			return TRUE
		if("toggle_resize")
			host.resizable = !host.resizable
			if(host.client.prefs_vr)
				host.client.prefs_vr.resizable = host.resizable
			unsaved_changes = TRUE
			return TRUE
		if("toggle_feed")
			host.feeding = !host.feeding
			if(host.client.prefs_vr)
				host.client.prefs_vr.feeding = host.feeding
			unsaved_changes = TRUE
			return TRUE
		if("toggle_absorbable")
			host.absorbable = !host.absorbable
			if(host.client.prefs_vr)
				host.client.prefs_vr.absorbable = host.absorbable
			unsaved_changes = TRUE
			return TRUE
		if("toggle_leaveremains")
			host.digest_leave_remains = !host.digest_leave_remains
			if(host.client.prefs_vr)
				host.client.prefs_vr.digest_leave_remains = host.digest_leave_remains
			unsaved_changes = TRUE
			return TRUE
		if("toggle_mobvore")
			host.allowmobvore = !host.allowmobvore
			if(host.client.prefs_vr)
				host.client.prefs_vr.allowmobvore = host.allowmobvore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_steppref")
			host.step_mechanics_pref = !host.step_mechanics_pref
			if(host.client.prefs_vr)
				host.client.prefs_vr.step_mechanics_pref = host.step_mechanics_pref
			unsaved_changes = TRUE
			return TRUE
		if("toggle_pickuppref")
			host.pickup_pref = !host.pickup_pref
			if(host.client.prefs_vr)
				host.client.prefs_vr.pickup_pref = host.pickup_pref
			unsaved_changes = TRUE
			return TRUE
		if("toggle_allow_mind_transfer")
			host.allow_mind_transfer = !host.allow_mind_transfer
			if(host.client.prefs_vr)
				host.client.prefs_vr.allow_mind_transfer = host.allow_mind_transfer
			unsaved_changes = TRUE
			return TRUE
		if("toggle_healbelly")
			host.permit_healbelly = !host.permit_healbelly
			if(host.client.prefs_vr)
				host.client.prefs_vr.permit_healbelly = host.permit_healbelly
			unsaved_changes = TRUE
			return TRUE
		if("toggle_fx")
			host.show_vore_fx = !host.show_vore_fx
			if(host.client.prefs_vr)
				host.client.prefs_vr.show_vore_fx = host.show_vore_fx
			if(!host.show_vore_fx)
				host.clear_fullscreen("belly")
				host.clear_fullscreen("belly2")
				host.clear_fullscreen("belly3")
				host.clear_fullscreen("belly4")
				if(!host.hud_used.hud_shown)
					host.toggle_hud_vis()
			unsaved_changes = TRUE
			return TRUE
		if("toggle_noisy")
			host.noisy = !host.noisy
			unsaved_changes = TRUE
			return TRUE
		if("toggle_drop_vore")
			host.drop_vore = !host.drop_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_slip_vore")
			host.slip_vore = !host.slip_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_stumble_vore")
			host.stumble_vore = !host.stumble_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_throw_vore")
			host.throw_vore = !host.throw_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_food_vore")
			host.food_vore = !host.food_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_digest_pain")
			host.digest_pain = !host.digest_pain
			unsaved_changes = TRUE
			return TRUE
		if("switch_selective_mode_pref")
			host.selective_preference = tgui_input_list(ui.user, "What would you prefer happen to you with selective bellymode?","Selective Bellymode", list(DM_DEFAULT, DM_DIGEST, DM_ABSORB, DM_DRAIN))
			if(!(host.selective_preference))
				host.selective_preference = DM_DEFAULT
			if(host.client.prefs_vr)
				host.client.prefs_vr.selective_preference = host.selective_preference
			unsaved_changes = TRUE
			return TRUE
		if("toggle_nutrition_ex")
			host.nutrition_message_visible = !host.nutrition_message_visible
			unsaved_changes = TRUE
			return TRUE
		if("toggle_weight_ex")
			host.weight_message_visible = !host.weight_message_visible
			unsaved_changes = TRUE
			return TRUE
		if("set_vs_color")
			var/belly_choice = tgui_input_list(ui.user, "Which vore sprite are you going to edit the color of?", "Vore Sprite Color", host.vore_icon_bellies)
			if(belly_choice)
				var/newcolor = tgui_color_picker(ui.user, "Choose a color.", "", host.vore_sprite_color[belly_choice])
				if(newcolor)
					host.vore_sprite_color[belly_choice] = newcolor
					var/multiply = tgui_input_list(ui.user, "Set the color to be applied multiplicatively or additively? Currently in [host.vore_sprite_multiply[belly_choice] ? "Multiply" : "Add"]", "Vore Sprite Color", list("Multiply", "Add"))
					if(multiply == "Multiply")
						host.vore_sprite_multiply[belly_choice] = TRUE
					else if(multiply == "Add")
						host.vore_sprite_multiply[belly_choice] = FALSE
					host.update_icons_body()
					unsaved_changes = TRUE
			return TRUE

/datum/vore_look/proc/pick_from_inside(mob/user, params)
	var/atom/movable/target = locate(params["pick"])
	var/obj/belly/OB = locate(params["belly"])

	if(!(target in OB))
		return TRUE // Aren't here anymore, need to update menu

	var/intent = "Examine"
	if(isliving(target))
		intent = tgui_alert(user, "What do you want to do to them?","Query",list("Examine","Help Out","Devour"))

	else if(istype(target, /obj/item))
		intent = tgui_alert(user, "What do you want to do to that?","Query",list("Examine","Use Hand"))

	switch(intent)
		if("Examine") //Examine a mob inside another mob
			var/list/results = target.examine(host)
			if(!results || !results.len)
				results = list("You were unable to examine that. Tell a developer!")
			to_chat(user, jointext(results, "<br>"))
			if(isliving(target))
				var/mob/living/ourtarget = target
				ourtarget.chat_healthbar(user, TRUE)
			return TRUE

		if("Use Hand")
			if(host.stat)
				to_chat(user, span_warning("You can't do that in your state!"))
				return TRUE

			host.ClickOn(target)
			return TRUE

	if(!isliving(target))
		return

	var/mob/living/M = target
	switch(intent)
		if("Help Out") //Help the inside-mob out
			if(host.stat || host.absorbed || M.absorbed)
				to_chat(user, span_warning("You can't do that in your state!"))
				return TRUE

			to_chat(user,span_vnotice("[span_green("You begin to push [M] to freedom!")]"))
			to_chat(M,span_vnotice("[host] begins to push you to freedom!"))
			to_chat(OB.owner,span_vwarning("Someone is trying to escape from inside you!"))
			sleep(50)
			if(prob(33))
				OB.release_specific_contents(M)
				to_chat(user,span_vnotice("[span_green("You manage to help [M] to safety!")]"))
				to_chat(M, span_vnotice("[span_green("[host] pushes you free!")]"))
				to_chat(OB.owner,span_valert("[M] forces free of the confines of your body!"))
			else
				to_chat(user,span_valert("[M] slips back down inside despite your efforts."))
				to_chat(M,span_valert("Even with [host]'s help, you slip back inside again."))
				to_chat(OB.owner,span_vnotice("[span_green("Your body efficiently shoves [M] back where they belong.")]"))
			return TRUE

		if("Devour") //Eat the inside mob
			if(host.absorbed || host.stat)
				to_chat(user,span_warning("You can't do that in your state!"))
				return TRUE

			if(!host.vore_selected)
				to_chat(user,span_warning("Pick a belly on yourself first!"))
				return TRUE

			var/obj/belly/TB = host.vore_selected
			to_chat(user,span_vwarning("You begin to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!"))
			to_chat(M,span_vwarning("[host] begins to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!"))
			to_chat(OB.owner,span_vwarning("Someone inside you is eating someone else!"))

			sleep(TB.nonhuman_prey_swallow_time) //Can't do after, in a stomach, weird things abound.
			if((host in OB) && (M in OB)) //Make sure they're still here.
				to_chat(user,span_vwarning("You manage to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!"))
				to_chat(M,span_vwarning("[host] manages to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!"))
				to_chat(OB.owner,span_vwarning("Someone inside you has eaten someone else!"))
				if(M.absorbed)
					M.absorbed = FALSE
					OB.handle_absorb_langs(M, OB.owner)
				TB.nom_mob(M)

/datum/vore_look/proc/pick_from_outside(mob/user, params)
	var/intent

	//Handle the [All] choice. Ugh inelegant. Someone make this pretty.
	if(params["pickall"])
		intent = tgui_alert(user, "Eject all, Move all?","Query",list("Eject all","Cancel","Move all"))
		switch(intent)
			if("Cancel")
				return TRUE

			if("Eject all")
				if(host.stat)
					to_chat(user,span_warning("You can't do that in your state!"))
					return TRUE

				host.vore_selected.release_all_contents()
				return TRUE

			if("Move all")
				if(host.stat)
					to_chat(user,span_warning("You can't do that in your state!"))
					return TRUE

				var/obj/belly/choice = tgui_input_list(user, "Move all where?","Select Belly", host.vore_organs)
				if(!choice)
					return FALSE

				for(var/atom/movable/target in host.vore_selected)
					to_chat(target,span_vwarning("You're squished from [host]'s [lowertext(host.vore_selected)] to their [lowertext(choice.name)]!"))
					host.vore_selected.transfer_contents(target, choice, 1)
				return TRUE
		return

	var/atom/movable/target = locate(params["pick"])
	if(!(target in host.vore_selected))
		return TRUE // Not in our X anymore, update UI
	var/list/available_options = list("Examine", "Eject", "Launch", "Move", "Transfer")
	if(ishuman(target))
		available_options += "Transform"
		available_options += "Health Check"
	if(isliving(target))
		var/mob/living/datarget = target
		if(datarget.client)
			available_options += "Process"
	intent = tgui_input_list(user, "What would you like to do with [target]?", "Vore Pick", available_options)
	switch(intent)
		if("Examine")
			var/list/results = target.examine(host)
			if(!results || !results.len)
				results = list("You were unable to examine that. Tell a developer!")
			to_chat(user, jointext(results, "<br>"))
			if(isliving(target))
				var/mob/living/ourtarget = target
				ourtarget.chat_healthbar(user, TRUE)
			return TRUE

		if("Eject")
			if(host.stat)
				to_chat(user,span_warning("You can't do that in your state!"))
				return TRUE

			host.vore_selected.release_specific_contents(target)
			return TRUE

		if("Launch")
			if(host.stat)
				to_chat(user, span_warning("You can't do that in your state!"))
				return TRUE

			host.vore_selected.release_specific_contents(target)
			target.throw_at(get_edge_target_turf(host, host.dir), 3, 1, host)
			host.visible_message(span_danger("[host] launches [target]!"))
			return TRUE

		if("Move")
			if(host.stat)
				to_chat(user,span_warning("You can't do that in your state!"))
				return TRUE
			var/obj/belly/choice = tgui_input_list(user, "Move [target] where?","Select Belly", host.vore_organs)
			if(!choice || !(target in host.vore_selected))
				return TRUE
			to_chat(target,span_vwarning("You're squished from [host]'s [lowertext(host.vore_selected.name)] to their [lowertext(choice.name)]!"))
			host.vore_selected.transfer_contents(target, choice)


		if("Transfer")
			if(host.stat)
				to_chat(user,span_warning("You can't do that in your state!"))
				return TRUE

			var/mob/living/belly_owner = host

			var/list/viable_candidates = list()
			for(var/mob/living/candidate in range(1, host))
				if(istype(candidate) && !(candidate == host))
					if(candidate.vore_organs.len && candidate.feeding && !candidate.no_vore)
						viable_candidates += candidate
			if(!viable_candidates.len)
				to_chat(user, span_notice("There are no viable candidates around you!"))
				return TRUE
			belly_owner = tgui_input_list(user, "Who do you want to receive the target?", "Select Predator", viable_candidates)

			if(!belly_owner || !(belly_owner in range(1, host)))
				return TRUE

			var/obj/belly/choice = tgui_input_list(user, "Move [target] where?","Select Belly", belly_owner.vore_organs)
			if(!choice || !(target in host.vore_selected) || !belly_owner || !(belly_owner in range(1, host)))
				return TRUE

			if(belly_owner != host)
				to_chat(user, span_vnotice("Transfer offer sent. Await their response."))
				var/accepted = tgui_alert(belly_owner, "[host] is trying to transfer [target] from their [lowertext(host.vore_selected.name)] into your [lowertext(choice.name)]. Do you accept?", "Feeding Offer", list("Yes", "No"))
				if(accepted != "Yes")
					to_chat(user, span_vwarning("[belly_owner] refused the transfer!!"))
					return TRUE
				if(!belly_owner || !(belly_owner in range(1, host)))
					return TRUE
				to_chat(target,span_vwarning("You're squished from [host]'s [lowertext(host.vore_selected.name)] to [belly_owner]'s [lowertext(choice.name)]!"))
				to_chat(belly_owner,span_vwarning("[target] is squished from [host]'s [lowertext(host.vore_selected.name)] to your [lowertext(choice.name)]!"))
				host.vore_selected.transfer_contents(target, choice)
			else
				to_chat(target,span_vwarning("You're squished from [host]'s [lowertext(host.vore_selected.name)] to their [lowertext(choice.name)]!"))
				host.vore_selected.transfer_contents(target, choice)
			return TRUE

		if("Transform")
			if(host.stat)
				to_chat(user,span_warning("You can't do that in your state!"))
				return TRUE

			var/mob/living/carbon/human/H = target
			if(!istype(H))
				return

			if(!H.allow_spontaneous_tf)
				return

			var/datum/tgui_module/appearance_changer/vore/V = new(host, H)
			V.tgui_interact(user)
			return TRUE

		if("Process")
			var/mob/living/ourtarget = target
			var/list/process_options = list()

			if(ourtarget.digestable)
				process_options += "Digest"

			if(ourtarget.absorbable)
				process_options += "Absorb"

			process_options += "Knockout" //Can't think of any mechanical prefs that would restrict this. Even if they are already asleep, you may want to make it permanent.

			if(process_options.len)
				process_options += "Cancel"
			else
				to_chat(user, span_vwarning("You cannot instantly process [ourtarget]."))
				return

			var/ourchoice = tgui_input_list(user, "How would you prefer to process \the [target]? This will perform the given action instantly if the prey accepts.","Instant Process", process_options)
			if(!ourchoice)
				return
			if(!ourtarget.client)
				to_chat(user, span_vwarning("You cannot instantly process [ourtarget]."))
				return
			var/obj/belly/b = ourtarget.loc
			switch(ourchoice)
				if("Digest")
					if(ourtarget.absorbed)
						to_chat(user, span_vwarning("\The [ourtarget] is absorbed, and cannot presently be digested."))
						return
					if(tgui_alert(ourtarget, "\The [user] is attempting to instantly digest you. Is this something you are okay with happening to you?","Instant Digest", list("No", "Yes")) != "Yes")
						to_chat(user, span_vwarning("\The [ourtarget] declined your digest attempt."))
						to_chat(ourtarget, span_vwarning("You declined the digest attempt."))
						return
					if(ourtarget.loc != b)
						to_chat(user, span_vwarning("\The [ourtarget] is no longer in \the [b]."))
						return
					if(isliving(user))
						var/mob/living/l = user
						var/thismuch = ourtarget.health + 100
						if(ishuman(l))
							var/mob/living/carbon/human/h = l
							thismuch = thismuch * h.species.digestion_nutrition_modifier
						l.adjust_nutrition(thismuch)
					ourtarget.death()		// To make sure all on-death procs get properly called
					if(ourtarget)
						if(ourtarget.check_sound_preference(/datum/preference/toggle/digestion_noises))
							if(!b.fancy_vore)
								SEND_SOUND(ourtarget, sound(get_sfx("classic_death_sounds")))
							else
								SEND_SOUND(ourtarget, sound(get_sfx("fancy_death_prey")))
						ourtarget.mind?.vore_death = TRUE
						b.handle_digestion_death(ourtarget)
				if("Absorb")
					if(tgui_alert(ourtarget, "\The [user] is attempting to instantly absorb you. Is this something you are okay with happening to you?","Instant Absorb", list("No", "Yes")) != "Yes")
						to_chat(user, span_vwarning("\The [ourtarget] declined your absorb attempt."))
						to_chat(ourtarget, span_vwarning("You declined the absorb attempt."))
						return
					if(ourtarget.loc != b)
						to_chat(user, span_vwarning("\The [ourtarget] is no longer in \the [b]."))
						return
					if(isliving(user))
						var/mob/living/l = user
						l.adjust_nutrition(ourtarget.nutrition)
						var/n = 0 - ourtarget.nutrition
						ourtarget.adjust_nutrition(n)
					b.absorb_living(ourtarget)
				if("Knockout")
					if(tgui_alert(ourtarget, "\The [user] is attempting to instantly make you unconscious, you will be unable until ejected from the pred. Is this something you are okay with happening to you?","Instant Knockout", list("No", "Yes")) != "Yes")
						to_chat(user, span_vwarning("\The [ourtarget] declined your knockout attempt."))
						to_chat(ourtarget, span_vwarning("You declined the knockout attempt."))
						return
					if(ourtarget.loc != b)
						to_chat(user, span_vwarning("\The [ourtarget] is no longer in \the [b]."))
						return
					ourtarget.AdjustSleeping(500000)
					to_chat(ourtarget, span_vwarning("\The [user] has put you to sleep, you will remain unconscious until ejected from the belly."))
				if("Cancel")
					return
		if("Health Check")
			var/mob/living/carbon/human/H = target
			var/target_health = round((H.health/H.getMaxHealth())*100)
			var/condition
			var/condition_consequences
			to_chat(user, span_vwarning("\The [target] is at [target_health]% health."))
			if(H.blinded)
				condition += "blinded"
				condition_consequences += "hear emotes"
			if(H.paralysis)
				if(condition)
					condition += " and "
					condition_consequences += " or "
				condition += "paralysed"
				condition_consequences += "make emotes"
			if(H.sleeping)
				if(condition)
					condition += " and "
					condition_consequences += " or "
				condition += "sleeping"
				condition_consequences += "hear or do anything"
			if(condition)
				to_chat(user, span_vwarning("\The [target] is currently [condition], they will not be able to [condition_consequences]."))
			return


/datum/vore_look/proc/set_attr(mob/user, params)
	if(!host.vore_selected)
		tgui_alert_async(user, "No belly selected to modify.")
		return FALSE
	var/attr = params["attribute"]
	switch(attr)
		if("b_name")
			var/new_name = html_encode(tgui_input_text(user,"Belly's new name:","New Name"))

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
			var/list/menu_list = host.vore_selected.digest_modes.Copy()
			var/new_mode = tgui_input_list(user, "Choose Mode (currently [host.vore_selected.digest_mode])", "Mode Choice", menu_list)
			if(!new_mode)
				return FALSE

			host.vore_selected.digest_mode = new_mode
			host.vore_selected.updateVRPanels()
			. = TRUE
		if("b_addons")
			var/list/menu_list = host.vore_selected.mode_flag_list.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Addon", "Addon Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.mode_flags ^= host.vore_selected.mode_flag_list[toggle_addon]
			host.vore_selected.items_preserved.Cut() //Re-evaltuate all items in belly on
			. = TRUE
		if("b_item_mode")
			var/list/menu_list = host.vore_selected.item_digest_modes.Copy()

			var/new_mode = tgui_input_list(user, "Choose Mode (currently [host.vore_selected.item_digest_mode])", "Mode Choice", menu_list)
			if(!new_mode)
				return FALSE

			host.vore_selected.item_digest_mode = new_mode
			host.vore_selected.items_preserved.Cut() //Re-evaltuate all items in belly on belly-mode change
			. = TRUE
		if("b_contaminate")
			host.vore_selected.contaminates = !host.vore_selected.contaminates
			. = TRUE
		if("b_contamination_flavor")
			var/list/menu_list = contamination_flavors.Copy()
			var/new_flavor = tgui_input_list(user, "Choose Contamination Flavor Text Type (currently [host.vore_selected.contamination_flavor])", "Flavor Choice", menu_list)
			if(!new_flavor)
				return FALSE
			host.vore_selected.contamination_flavor = new_flavor
			. = TRUE
		if("b_contamination_color")
			var/list/menu_list = contamination_colors.Copy()
			var/new_color = tgui_input_list(user, "Choose Contamination Color (currently [host.vore_selected.contamination_color])", "Color Choice", menu_list)
			if(!new_color)
				return FALSE
			host.vore_selected.contamination_color = new_color
			host.vore_selected.items_preserved.Cut() //To re-contaminate for new color
			. = TRUE
		if("b_egg_type")
			var/list/menu_list = global_vore_egg_types.Copy()
			var/new_egg_type = tgui_input_list(user, "Choose Egg Type (currently [host.vore_selected.egg_type])", "Egg Choice", menu_list)
			if(!new_egg_type)
				return FALSE
			host.vore_selected.egg_type = new_egg_type
			. = TRUE
		if("b_desc")
			var/new_desc = html_encode(tgui_input_text(user,"Belly Description, '%pred' will be replaced with your name. '%prey' will be replaced with the prey's name. '%belly' will be replaced with your belly's name. ([BELLIES_DESC_MAX] char limit):","New Description",host.vore_selected.desc, multiline = TRUE, prevent_enter = TRUE))

			if(new_desc)
				new_desc = readd_quotes(new_desc)
				if(length(new_desc) > BELLIES_DESC_MAX)
					tgui_alert_async(user, "Entered belly desc too long. [BELLIES_DESC_MAX] character limit.","Error")
					return FALSE
				host.vore_selected.desc = new_desc
				. = TRUE
		if("b_absorbed_desc")
			var/new_desc = html_encode(tgui_input_text(user,"Belly Description for absorbed prey, '%pred' will be replaced with your name. '%prey' will be replaced with the prey's name. '%belly' will be replaced with your belly's name. ([BELLIES_DESC_MAX] char limit):","New Description",host.vore_selected.absorbed_desc, multiline = TRUE, prevent_enter = TRUE))

			if(new_desc)
				new_desc = readd_quotes(new_desc)
				if(length(new_desc) > BELLIES_DESC_MAX)
					tgui_alert_async(user, "Entered belly desc too long. [BELLIES_DESC_MAX] character limit.","Error")
					return FALSE
				host.vore_selected.absorbed_desc = new_desc
				. = TRUE
		if("b_msgs")
			if(user.text_warnings)
				if(tgui_alert(user,"Setting abusive or deceptive messages will result in a ban. Consider this your warning. Max [MAX_MESSAGE_LEN / 4] characters per message ([MAX_MESSAGE_LEN / 2] for examines, [MAX_MESSAGE_LEN / 4] for idle messages), max 10 messages per topic or a total of [MAX_MESSAGE_LEN * 1.5] characters.","Really, don't.",list("OK", "Disable Warnings")) == "Disable Warnings") // Should remain tgui_alert() (blocking)
					user.text_warnings = FALSE
			var/help = " Press enter twice to separate messages. '%pred' will be replaced with your name. '%prey' will be replaced with the prey's name. '%belly' will be replaced with your belly's name. '%count' will be replaced with the number of anything in your belly. '%countprey' will be replaced with the number of living prey in your belly."
			switch(params["msgtype"])
				if("dmp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they expire. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Digest Message (to prey)",host.vore_selected.get_messages("dmp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"dmp", limit = MAX_MESSAGE_LEN / 4)

				if("dmo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey expires in you. Write them in 2nd person ('you feel X'). Avoid using %pred in this type."+help,"Digest Message (to you)",host.vore_selected.get_messages("dmo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"dmo", limit = MAX_MESSAGE_LEN / 4)

				if("amp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when their absorption finishes. Write them in 2nd person ('you feel X'). Avoid using %prey in this type. %count will not work for this type, and %countprey will only count absorbed victims."+help,"Absorb Message (to prey)",host.vore_selected.get_messages("amp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"amp", limit = MAX_MESSAGE_LEN / 4)

				if("amo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey's absorption finishes. Write them in 2nd person ('you feel X'). Avoid using %pred in this type. %count will not work for this type, and %countprey will only count absorbed victims."+help,"Absorb Message (to you)",host.vore_selected.get_messages("amo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"amo", limit = MAX_MESSAGE_LEN / 4)

				if("uamp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when their unnabsorption finishes. Write them in 2nd person ('you feel X'). Avoid using %prey in this type. %count will not work for this type, and %countprey will only count absorbed victims."+help,"Unabsorb Message (to prey)",host.vore_selected.get_messages("uamp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"uamp", limit = MAX_MESSAGE_LEN / 4)

				if("uamo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey's unabsorption finishes. Write them in 2nd person ('you feel X'). Avoid using %pred in this type. %count will not work for this type, and %countprey will only count absorbed victims."+help,"Unabsorb Message (to you)",host.vore_selected.get_messages("uamo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"uamo", limit = MAX_MESSAGE_LEN / 4)

				if("smo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to those nearby when prey struggles. Write them in 3rd person ('X's Y bulges')."+help,"Struggle Message (outside)",host.vore_selected.get_messages("smo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"smo", limit = MAX_MESSAGE_LEN / 4)

				if("smi")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they struggle. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Struggle Message (inside)",host.vore_selected.get_messages("smi"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"smi", limit = MAX_MESSAGE_LEN / 4)

				if("asmo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to those nearby when absorbed prey struggles. Write them in 3rd person ('X's Y bulges'). %count will not work for this type, and %countprey will only count absorbed victims."+help,"Absorbed Struggle Message (outside)",host.vore_selected.get_messages("asmo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"asmo", limit = MAX_MESSAGE_LEN / 4)

				if("asmi")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to absorbed prey when they struggle. Write them in 2nd person ('you feel X'). Avoid using %prey in this type. %count will not work for this type, and %countprey will only count absorbed victims."+help,"Absorbed Struggle Message (inside)",host.vore_selected.get_messages("asmi"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"asmi", limit = MAX_MESSAGE_LEN / 4)

				if("escap")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they try to escape from within you. Write them in 2nd person ('you start to X')."+help,"Escape Attempt Message (to prey)",host.vore_selected.get_messages("escap"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escap", limit = MAX_MESSAGE_LEN / 4)

				if("escao")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey tries to escape from within you. Write them in 2nd person ('X ... from your Y')."+help,"Escape Attempt Message (to you)",host.vore_selected.get_messages("escao"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escao", limit = MAX_MESSAGE_LEN / 4)

				if("escp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they escape from within you. Write them in 2nd person ('you climb out of Y)."+help,"Escape Message (to prey)",host.vore_selected.get_messages("escp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escp", limit = MAX_MESSAGE_LEN / 4)

				if("esco")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey escapes from within you. Write them in 2nd person ('X ... from your Y')."+help,"Escape Message (to you)",host.vore_selected.get_messages("esco"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"esco", limit = MAX_MESSAGE_LEN / 4)

				if("escout")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to those around you when prey escapes from within you. Write them in 3rd person ('X climbs out of Z's Y')."+help,"Escape Message (outside)",host.vore_selected.get_messages("escout"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escout", limit = MAX_MESSAGE_LEN / 4)

				if("escip")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they manage to eject an item from within you. Write them in 2nd person ('you manage to O'). Use %item to refer to the ejected item in this type."+help,"Escape Item Message (to prey)",host.vore_selected.get_messages("escip"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escip", limit = MAX_MESSAGE_LEN / 4)

				if("escio")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey manages to eject an item from within you. Write them in 2nd person ('O slips from Y'). Use %item to refer to the ejected item in this type."+help,"Escape Item Message (to you)",host.vore_selected.get_messages("escio"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escio", limit = MAX_MESSAGE_LEN / 4)

				if("esciout")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to those around you when prey manages to eject an item from within you. Write them in 3rd person ('O from Y'). Use %item to refer to the ejected item in this type."+help,"Escape Item Message (outside)",host.vore_selected.get_messages("esciout"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"esciout", limit = MAX_MESSAGE_LEN / 4)

				if("escfp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they fail to escape from within you. Write them in 2nd person ('you failed to Y')."+help,"Escape Fail Message (to prey)",host.vore_selected.get_messages("escfp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escfp", limit = MAX_MESSAGE_LEN / 4)

				if("escfo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey fails to escape from within you. Write them in 2nd person ('X failed ... your Y')."+help,"Escape Fail Message (to you)",host.vore_selected.get_messages("escfo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"escfo", limit = MAX_MESSAGE_LEN / 4)

				if("aescap")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to absorbed prey when they try to escape from within you. Write them in 2nd person ('you start to X')."+help,"Absorbed Escape Attempt Message (to prey)",host.vore_selected.get_messages("aescap"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"aescap", limit = MAX_MESSAGE_LEN / 4)

				if("aescao")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when absorbed prey tries to escape from within you. Write them in 2nd person ('X ... from your Y')."+help,"Absorbed Escape Attempt Message (to you)",host.vore_selected.get_messages("aescao"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"aescao", limit = MAX_MESSAGE_LEN / 4)

				if("aescp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to absorbed prey when they escape from within you. Write them in 2nd person ('you escape from Y')."+help,"Absorbed Escape Message (to prey)",host.vore_selected.get_messages("aescp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"aescp", limit = MAX_MESSAGE_LEN / 4)

				if("aesco")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when absorbed prey escapes from within you. Write them in 2nd person ('X ... from your Y')."+help,"Absorbed Escape Message (to you)",host.vore_selected.get_messages("aesco"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"aesco", limit = MAX_MESSAGE_LEN / 4)

				if("aescout")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to those around you when absorbed prey escapes from within you. Write them in 3rd person ('X escapes from Z's Y')."+help,"Absorbed Escape Message (outside)",host.vore_selected.get_messages("aescout"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"aescout", limit = MAX_MESSAGE_LEN / 4)

				if("aescfp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to absorbed prey when they fail to escape from within you. Write them in 2nd person ('you failed to Y')."+help,"Absorbed Escape Fail Message (to prey)",host.vore_selected.get_messages("aescfp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"aescfp", limit = MAX_MESSAGE_LEN / 4)

				if("aescfo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when absorbed prey fails to escape from within you. Write them in 2nd person ('X failed ... your Y')."+help,"Absorbed Escape Fail Message (to you)",host.vore_selected.get_messages("aescfo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"aescfo", limit = MAX_MESSAGE_LEN / 4)

				if("trnspp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they are automatically transferred into your primary destination. Write them in 2nd person ('you slide into Y'). Use %dest to refer to the target location in this type."+help,"Primary Transfer Message (to prey)",host.vore_selected.get_messages("trnspp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"trnspp", limit = MAX_MESSAGE_LEN / 4)

				if("trnspo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey is automatically transferred into your primary destination. Write them in 2nd person ('X slid into your Y'). Use %dest to refer to the target location in this type."+help,"Primary Transfer Message (to you)",host.vore_selected.get_messages("trnspo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"trnspo", limit = MAX_MESSAGE_LEN / 4)

				if("trnssp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they are automatically transferred into your secondary destination. Write them in 2nd person ('you slide into Y'). Use %dest to refer to the target location in this type."+help,"Secondary Transfer Message (to prey)",host.vore_selected.get_messages("trnssp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"trnssp", limit = MAX_MESSAGE_LEN / 4)

				if("trnsso")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey is automatically transferred into your primary destination. Write them in 2nd person ('X slid into your Y'). Use %dest to refer to the target location in this type."+help,"Secondary Transfer Message (to you)",host.vore_selected.get_messages("trnsso"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"trnsso", limit = MAX_MESSAGE_LEN / 4)

				if("stmodp")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they trigger the interaction digest chance. Write them in 2nd person ('you feel X')."+help,"Stomach Mode Digest Message (to prey)",host.vore_selected.get_messages("stmodp"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"stmodp", limit = MAX_MESSAGE_LEN / 4)

				if("stmodo")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey triggers the interaction digest chance. Write them in 2nd person ('you feel X')."+help,"Stomach Mode Digest Message (to you)",host.vore_selected.get_messages("stmodo"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"stmodo", limit = MAX_MESSAGE_LEN / 4)

				if("stmoap")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey when they trigger the interaction absorb chance. Write them in 2nd person ('you feel X')."+help,"Stomach Mode Digest Message (to prey)",host.vore_selected.get_messages("stmoap"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"stmoap", limit = MAX_MESSAGE_LEN / 4)

				if("stmoao")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to you when prey triggers the interaction absorb chance. Write them in 2nd person ('you feel X')."+help,"Stomach Mode Digest Message (to you)",host.vore_selected.get_messages("stmoao"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"stmoao", limit = MAX_MESSAGE_LEN / 4)
				if("em")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to people who examine you when this belly has contents. Write them in 3rd person ('Their %belly is bulging')."+help,"Examine Message (when full)",host.vore_selected.get_messages("em"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"em", limit = MAX_MESSAGE_LEN / 2)

				if("ema")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to people who examine you when this belly has absorbed victims. Write them in 3rd person ('Their %belly is larger'). %count will not work for this type, and %countprey will only count absorbed victims."+help,"Examine Message (with absorbed victims)",host.vore_selected.get_messages("ema"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"ema", limit = MAX_MESSAGE_LEN / 2)

				if("en")
					var/list/indices = list(1,2,3,4,5,6,7,8,9,10)
					var/index = tgui_input_list(user,"Select a message to edit:","Select Message", indices)
					if(index && index <= 10)
						var/alert = tgui_alert(user, "What do you wish to do with this message?","Selection",list("Edit","Clear","Cancel"))
						switch(alert)
							if("Clear")
								host.nutrition_messages[index] = ""
							if("Edit")
								var/new_message = sanitize(tgui_input_text(user, "Input a message", "Input", host.nutrition_messages[index], multiline = TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN,0,0,0)
								if(new_message)
									host.nutrition_messages[index] = new_message

				if("ew")
					var/list/indices = list(1,2,3,4,5,6,7,8,9,10)
					var/index = tgui_input_list(user,"Select a message to edit:","Select Message", indices)
					if(index && index <= 10)
						var/alert = tgui_alert(user, "What do you wish to do with this message?","Selection",list("Edit","Clear","Cancel"))
						switch(alert)
							if("Clear")
								host.weight_messages[index] = ""
							if("Edit")
								var/new_message = sanitize(tgui_input_text(user, "Input a message", "Input", host.weight_messages[index], multiline = TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN,0,0,0)
								if(new_message)
									host.weight_messages[index] = new_message

				if("im_digest")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Digest mode. Write them in 2nd person ('%pred's %belly squishes down on you.')."+help,"Idle Message (Digest)",host.vore_selected.get_messages("im_digest"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_digest", limit = MAX_MESSAGE_LEN / 4)

				if("im_hold")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Hold mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Hold)",host.vore_selected.get_messages("im_hold"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_hold", limit = MAX_MESSAGE_LEN / 4)

				if("im_holdabsorbed")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are absorbed. Write them in 2nd person ('%pred's %belly squishes down on you.') %count will not work for this type, and %countprey will only count absorbed victims."+help,"Idle Message (Hold Absorbed)",host.vore_selected.get_messages("im_holdabsorbed"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_holdabsorbed", limit = MAX_MESSAGE_LEN / 4)

				if("im_absorb")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Absorb mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Absorb)",host.vore_selected.get_messages("im_absorb"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_absorb", limit = MAX_MESSAGE_LEN / 4)

				if("im_heal")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Heal mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Heal)",host.vore_selected.get_messages("im_heal"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_heal", limit = MAX_MESSAGE_LEN / 4)

				if("im_drain")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Drain mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Drain)",host.vore_selected.get_messages("im_drain"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_drain", limit = MAX_MESSAGE_LEN / 4)

				if("im_steal")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Size Steal mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Size Steal)",host.vore_selected.get_messages("im_steal"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_steal", limit = MAX_MESSAGE_LEN / 4)

				if("im_egg")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Encase In Egg mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Encase In Egg)",host.vore_selected.get_messages("im_egg"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_egg", limit = MAX_MESSAGE_LEN / 4)

				if("im_shrink")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Shrink mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Shrink)",host.vore_selected.get_messages("im_shrink"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_shrink", limit = MAX_MESSAGE_LEN / 4)

				if("im_grow")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Grow mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Grow)",host.vore_selected.get_messages("im_grow"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_grow", limit = MAX_MESSAGE_LEN / 4)

				if("im_unabsorb")
					var/new_message = sanitize(tgui_input_text(user,"These are sent to prey every [host.vore_selected.emote_time] seconds when you are on Unabsorb mode. Write them in 2nd person ('%pred's %belly squishes down on you.')"+help,"Idle Message (Unabsorb)",host.vore_selected.get_messages("im_unabsorb"), MAX_MESSAGE_LEN * 1.5, TRUE, prevent_enter = TRUE),MAX_MESSAGE_LEN * 1.5,0,0,0)
					if(new_message)
						host.vore_selected.set_messages(new_message,"im_unabsorb", limit = MAX_MESSAGE_LEN / 4)

				if("reset")
					var/confirm = tgui_alert(user,"This will delete any custom messages. Are you sure?","Confirmation",list("Cancel","DELETE"))
					if(confirm == "DELETE")
						host.vore_selected.digest_messages_prey = initial(host.vore_selected.digest_messages_prey)
						host.vore_selected.digest_messages_owner = initial(host.vore_selected.digest_messages_owner)
						host.vore_selected.absorb_messages_prey = initial(host.vore_selected.absorb_messages_prey)
						host.vore_selected.absorb_messages_owner = initial(host.vore_selected.absorb_messages_owner)
						host.vore_selected.unabsorb_messages_prey = initial(host.vore_selected.unabsorb_messages_prey)
						host.vore_selected.unabsorb_messages_owner = initial(host.vore_selected.unabsorb_messages_owner)
						host.vore_selected.struggle_messages_outside = initial(host.vore_selected.struggle_messages_outside)
						host.vore_selected.struggle_messages_inside = initial(host.vore_selected.struggle_messages_inside)
						host.vore_selected.absorbed_struggle_messages_outside = initial(host.vore_selected.absorbed_struggle_messages_outside)
						host.vore_selected.absorbed_struggle_messages_inside = initial(host.vore_selected.absorbed_struggle_messages_inside)
						host.vore_selected.escape_attempt_messages_owner = initial(host.vore_selected.escape_attempt_messages_owner)
						host.vore_selected.escape_attempt_messages_prey = initial(host.vore_selected.escape_attempt_messages_prey)
						host.vore_selected.escape_messages_owner = initial(host.vore_selected.escape_messages_owner)
						host.vore_selected.escape_messages_prey = initial(host.vore_selected.escape_messages_prey)
						host.vore_selected.escape_messages_outside = initial(host.vore_selected.escape_messages_outside)
						host.vore_selected.escape_item_messages_owner = initial(host.vore_selected.escape_item_messages_owner)
						host.vore_selected.escape_item_messages_prey = initial(host.vore_selected.escape_item_messages_prey)
						host.vore_selected.escape_item_messages_outside = initial(host.vore_selected.escape_item_messages_outside)
						host.vore_selected.escape_fail_messages_owner = initial(host.vore_selected.escape_fail_messages_owner)
						host.vore_selected.escape_fail_messages_prey = initial(host.vore_selected.escape_fail_messages_prey)
						host.vore_selected.escape_attempt_absorbed_messages_owner = initial(host.vore_selected.escape_attempt_absorbed_messages_owner)
						host.vore_selected.escape_attempt_absorbed_messages_prey = initial(host.vore_selected.escape_attempt_absorbed_messages_prey)
						host.vore_selected.escape_absorbed_messages_owner = initial(host.vore_selected.escape_absorbed_messages_owner)
						host.vore_selected.escape_absorbed_messages_prey = initial(host.vore_selected.escape_absorbed_messages_prey)
						host.vore_selected.escape_absorbed_messages_outside = initial(host.vore_selected.escape_absorbed_messages_outside)
						host.vore_selected.escape_fail_absorbed_messages_owner = initial(host.vore_selected.escape_fail_absorbed_messages_owner)
						host.vore_selected.escape_fail_absorbed_messages_prey = initial(host.vore_selected.escape_fail_absorbed_messages_prey)
						host.vore_selected.primary_transfer_messages_owner = initial(host.vore_selected.primary_transfer_messages_owner)
						host.vore_selected.primary_transfer_messages_prey = initial(host.vore_selected.primary_transfer_messages_prey)
						host.vore_selected.secondary_transfer_messages_owner = initial(host.vore_selected.secondary_transfer_messages_owner)
						host.vore_selected.secondary_transfer_messages_prey = initial(host.vore_selected.secondary_transfer_messages_prey)
						host.vore_selected.digest_chance_messages_owner = initial(host.vore_selected.digest_chance_messages_owner)
						host.vore_selected.digest_chance_messages_prey = initial(host.vore_selected.digest_chance_messages_prey)
						host.vore_selected.absorb_chance_messages_owner = initial(host.vore_selected.absorb_chance_messages_owner)
						host.vore_selected.absorb_chance_messages_prey = initial(host.vore_selected.absorb_chance_messages_prey)
						host.vore_selected.examine_messages = initial(host.vore_selected.examine_messages)
						host.vore_selected.examine_messages_absorbed = initial(host.vore_selected.examine_messages_absorbed)
						host.vore_selected.emote_lists = initial(host.vore_selected.emote_lists)
			. = TRUE
		if("b_verb")
			var/new_verb = html_encode(tgui_input_text(user,"New verb when eating (infinitive tense, e.g. nom or swallow):","New Verb"))

			if(length(new_verb) > BELLIES_NAME_MAX || length(new_verb) < BELLIES_NAME_MIN)
				tgui_alert_async(user, "Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.vore_verb = new_verb
			. = TRUE
		if("b_release_verb")
			var/new_release_verb = html_encode(tgui_input_text(user,"New verb when releasing from stomach (e.g. expels or coughs or drops):","New Release Verb"))

			if(length(new_release_verb) > BELLIES_NAME_MAX || length(new_release_verb) < BELLIES_NAME_MIN)
				tgui_alert_async(user, "Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.release_verb = new_release_verb
			. = TRUE
		if("b_eating_privacy")
			var/privacy_choice = tgui_input_list(user, "Choose your belly-specific preference. Default uses global preference!", "Eating message privacy", list("default", "subtle", "loud"), "default")
			if(privacy_choice == null)
				return FALSE
			host.vore_selected.eating_privacy_local = privacy_choice
			. = TRUE
		if("b_silicon_belly")
			var/belly_choice = tgui_alert(user, "Choose whether you'd like your belly overlay to show from sleepers, \
			normal vore bellies, or an average of the two. NOTE: This ONLY applies to silicons, not human mobs!", "Belly Overlay \
			Preference",
			list("Sleeper", "Vorebelly", "Both"))
			if(belly_choice == null)
				return FALSE
			for (var/belly in host.vore_organs)
				var/obj/belly/B = belly
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
			var/choice
			if(host.vore_selected.fancy_vore)
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.release_sound]","Select Sound", fancy_release_sounds)
			else
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.release_sound]","Select Sound", classic_release_sounds)

			if(!choice)
				return FALSE

			host.vore_selected.release_sound = choice
			. = TRUE
		if("b_releasesoundtest")
			var/sound/releasetest
			if(host.vore_selected.fancy_vore)
				releasetest = fancy_release_sounds[host.vore_selected.release_sound]
			else
				releasetest = classic_release_sounds[host.vore_selected.release_sound]

			if(releasetest)
				SEND_SOUND(user, releasetest)
			. = TRUE
		if("b_sound")
			var/choice
			if(host.vore_selected.fancy_vore)
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.vore_sound]","Select Sound", fancy_vore_sounds)
			else
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.vore_sound]","Select Sound", classic_vore_sounds)

			if(!choice)
				return FALSE

			host.vore_selected.vore_sound = choice
			. = TRUE
		if("b_soundtest")
			var/sound/voretest
			if(host.vore_selected.fancy_vore)
				voretest = fancy_vore_sounds[host.vore_selected.vore_sound]
			else
				voretest = classic_vore_sounds[host.vore_selected.vore_sound]
			if(voretest)
				SEND_SOUND(user, voretest)
			. = TRUE
		if("b_tastes")
			host.vore_selected.can_taste = !host.vore_selected.can_taste
			. = TRUE
		if("b_bulge_size")
			var/new_bulge = tgui_input_number(user, "Choose the required size prey must be to show up on examine, ranging from 25% to 200% Set this to 0 for no text on examine.", "Set Belly Examine Size.", max_value = 200, min_value = 0)
			if(new_bulge == null)
				return FALSE
			if(new_bulge == 0) //Disable.
				host.vore_selected.bulge_size = 0
				to_chat(user,span_notice("Your stomach will not be seen on examine."))
			else if (!ISINRANGE(new_bulge,25,200))
				host.vore_selected.bulge_size = 0.25 //Set it to the default.
				to_chat(user,span_notice("Invalid size."))
			else if(new_bulge)
				host.vore_selected.bulge_size = (new_bulge/100)
			. = TRUE
		if("b_display_absorbed_examine")
			host.vore_selected.display_absorbed_examine = !host.vore_selected.display_absorbed_examine
			. = TRUE
		if("b_grow_shrink")
			var/new_grow = tgui_input_number(user, "Choose the size that prey will be grown/shrunk to, ranging from 25% to 200%", "Set Growth Shrink Size.", host.vore_selected.shrink_grow_size, 200, 25)
			if (new_grow == null)
				return FALSE
			if (!ISINRANGE(new_grow,25,200))
				host.vore_selected.shrink_grow_size = 1 //Set it to the default
				to_chat(user,span_notice("Invalid size."))
			else if(new_grow)
				host.vore_selected.shrink_grow_size = (new_grow*0.01)
			. = TRUE
		if("b_nutritionpercent")
			var/new_nutrition = tgui_input_number(user, "Choose the nutrition gain percentage you will receive per tick from prey. Ranges from 0.01 to 100.", "Set Nutrition Gain Percentage.", host.vore_selected.nutrition_percent, 100, 0.01, round_value=FALSE)
			if(new_nutrition == null)
				return FALSE
			var/new_new_nutrition = CLAMP(new_nutrition, 0.01, 100)
			host.vore_selected.nutrition_percent = new_new_nutrition
			. = TRUE
		if("b_burn_dmg")
			var/new_damage = tgui_input_number(user, "Choose the amount of burn damage prey will take per tick. Ranges from 0 to 6.", "Set Belly Burn Damage.", host.vore_selected.digest_burn, 6, 0, round_value=FALSE)
			if(new_damage == null)
				return FALSE
			var/new_new_damage = CLAMP(new_damage, 0, 6)
			host.vore_selected.digest_burn = new_new_damage
			. = TRUE
		if("b_brute_dmg")
			var/new_damage = tgui_input_number(user, "Choose the amount of brute damage prey will take per tick. Ranges from 0 to 6", "Set Belly Brute Damage.", host.vore_selected.digest_brute, 6, 0, round_value=FALSE)
			if(new_damage == null)
				return FALSE
			var/new_new_damage = CLAMP(new_damage, 0, 6)
			host.vore_selected.digest_brute = new_new_damage
			. = TRUE
		if("b_oxy_dmg")
			var/new_damage = tgui_input_number(user, "Choose the amount of suffocation damage prey will take per tick. Ranges from 0 to 12.", "Set Belly Suffocation Damage.", host.vore_selected.digest_oxy, 12, 0, round_value=FALSE)
			if(new_damage == null)
				return FALSE
			var/new_new_damage = CLAMP(new_damage, 0, 12)
			host.vore_selected.digest_oxy = new_new_damage
			. = TRUE
		if("b_tox_dmg")
			var/new_damage = tgui_input_number(user, "Choose the amount of toxins damage prey will take per tick. Ranges from 0 to 6", "Set Belly Toxins Damage.", host.vore_selected.digest_tox, 6, 0, round_value=FALSE)
			if(new_damage == null)
				return FALSE
			var/new_new_damage = CLAMP(new_damage, 0, 6)
			host.vore_selected.digest_tox = new_new_damage
			. = TRUE
		if("b_clone_dmg")
			var/new_damage = tgui_input_number(user, "Choose the amount of brute DNA damage (clone) prey will take per tick. Ranges from 0 to 6", "Set Belly Clone Damage.", host.vore_selected.digest_clone, 6, 0, round_value=FALSE)
			if(new_damage == null)
				return FALSE
			var/new_new_damage = CLAMP(new_damage, 0, 6)
			host.vore_selected.digest_clone = new_new_damage
			. = TRUE
		if("b_drainmode")
			var/list/menu_list = host.vore_selected.drainmodes.Copy()
			var/new_drainmode = tgui_input_list(user, "Choose Mode (currently [host.vore_selected.digest_mode])", "Mode Choice", menu_list)
			if(!new_drainmode)
				return FALSE

			host.vore_selected.drainmode = new_drainmode
			host.vore_selected.updateVRPanels()
		if("b_emoteactive")
			host.vore_selected.emote_active = !host.vore_selected.emote_active
			. = TRUE
		if("b_selective_mode_pref_toggle")
			if(host.vore_selected.selective_preference == DM_DIGEST)
				host.vore_selected.selective_preference = DM_ABSORB
			else
				host.vore_selected.selective_preference = DM_DIGEST
			. = TRUE
		if("b_emotetime")
			var/new_time = tgui_input_number(user, "Choose the period it takes for idle belly emotes to be shown to prey. Measured in seconds, Minimum 1 minute, Maximum 10 minutes.", "Set Belly Emote Delay.", host.vore_selected.digest_brute, 600, 60)
			if(new_time == null)
				return FALSE
			var/new_new_time = CLAMP(new_time, 60, 600)
			host.vore_selected.emote_time = new_new_time
			. = TRUE
		if("b_escapable")
			if(host.vore_selected.escapable == 0) //Possibly escapable and special interactions.
				host.vore_selected.escapable = 1
				to_chat(user,span_warning("Prey now have special interactions with your [lowertext(host.vore_selected.name)] depending on your settings."))
			else if(host.vore_selected.escapable == 1) //Never escapable.
				host.vore_selected.escapable = 0
				to_chat(user,span_warning("Prey will not be able to have special interactions with your [lowertext(host.vore_selected.name)]."))
			else
				tgui_alert_async(user, "Something went wrong. Your stomach will now not have special interactions. Press the button enable them again and tell a dev.","Error") //If they somehow have a varable that's not 0 or 1
				host.vore_selected.escapable = 0
			. = TRUE
		if("b_escapechance")
			var/escape_chance_input = tgui_input_number(user, "Set prey escape chance on resist (as %)", "Prey Escape Chance", null, 100, 0)
			if(!isnull(escape_chance_input)) //These have to be 'null' because both cancel and 0 are valid, separate options
				host.vore_selected.escapechance = sanitize_integer(escape_chance_input, 0, 100, initial(host.vore_selected.escapechance))
			. = TRUE
		if("b_escapechance_absorbed")
			var/escape_absorbed_chance_input = tgui_input_number(user, "Set absorbed prey escape chance on resist (as %)", "Prey Absorbed Escape Chance", null, 100, 0)
			if(!isnull(escape_absorbed_chance_input)) //These have to be 'null' because both cancel and 0 are valid, separate options
				host.vore_selected.escapechance_absorbed = sanitize_integer(escape_absorbed_chance_input, 0, 100, initial(host.vore_selected.escapechance_absorbed))
			. = TRUE
		if("b_escapetime")
			var/escape_time_input = tgui_input_number(user, "Set number of seconds for prey to escape on resist (1-60)", "Prey Escape Time", null, 60, 1)
			if(!isnull(escape_time_input))
				host.vore_selected.escapetime = sanitize_integer(escape_time_input*10, 10, 600, initial(host.vore_selected.escapetime))
			. = TRUE
		if("b_transferchance")
			var/transfer_chance_input = tgui_input_number(user, "Set belly transfer chance on resist (as %). You must also set the location for this to have any effect.", "Prey Escape Time", null, 100, 0)
			if(!isnull(transfer_chance_input))
				host.vore_selected.transferchance = sanitize_integer(transfer_chance_input, 0, 100, initial(host.vore_selected.transferchance))
			. = TRUE
		if("b_transferlocation")
			var/obj/belly/choice = tgui_input_list(user, "Where do you want your [lowertext(host.vore_selected.name)] to lead if prey resists?","Select Belly", (host.vore_organs + "None - Remove" - host.vore_selected))

			if(!choice) //They cancelled, no changes
				return FALSE
			else if(choice == "None - Remove")
				host.vore_selected.transferlocation = null
			else
				host.vore_selected.transferlocation = choice.name
			. = TRUE
		if("b_transferchance_secondary")
			var/transfer_secondary_chance_input = tgui_input_number(user, "Set secondary belly transfer chance on resist (as %). You must also set the location for this to have any effect.", "Prey Escape Time", null, 100, 0)
			if(!isnull(transfer_secondary_chance_input))
				host.vore_selected.transferchance_secondary = sanitize_integer(transfer_secondary_chance_input, 0, 100, initial(host.vore_selected.transferchance_secondary))
			. = TRUE
		if("b_transferlocation_secondary")
			var/obj/belly/choice_secondary = tgui_input_list(user, "Where do you want your [lowertext(host.vore_selected.name)] to alternately lead if prey resists?","Select Belly", (host.vore_organs + "None - Remove" - host.vore_selected))

			if(!choice_secondary) //They cancelled, no changes
				return FALSE
			else if(choice_secondary == "None - Remove")
				host.vore_selected.transferlocation_secondary = null
			else
				host.vore_selected.transferlocation_secondary = choice_secondary.name
			. = TRUE
		if("b_absorbchance")
			var/absorb_chance_input = tgui_input_number(user, "Set belly absorb mode chance on resist (as %)", "Prey Absorb Chance", null, 100, 0)
			if(!isnull(absorb_chance_input))
				host.vore_selected.absorbchance = sanitize_integer(absorb_chance_input, 0, 100, initial(host.vore_selected.absorbchance))
			. = TRUE
		if("b_digestchance")
			var/digest_chance_input = tgui_input_number(user, "Set belly digest mode chance on resist (as %)", "Prey Digest Chance", null, 100, 0)
			if(!isnull(digest_chance_input))
				host.vore_selected.digestchance = sanitize_integer(digest_chance_input, 0, 100, initial(host.vore_selected.digestchance))
			. = TRUE
		if("b_fullscreen")
			host.vore_selected.belly_fullscreen = params["val"]
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
			var/newcolor = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.belly_fullscreen_color)
			if(newcolor)
				host.vore_selected.belly_fullscreen_color = newcolor
			. = TRUE
		if("b_fullscreen_color_secondary")
			var/newcolor = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.belly_fullscreen_color_secondary)
			if(newcolor)
				host.vore_selected.belly_fullscreen_color_secondary = newcolor
			. = TRUE
		if("b_fullscreen_color_trinary")
			var/newcolor = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.belly_fullscreen_color_trinary)
			if(newcolor)
				host.vore_selected.belly_fullscreen_color_trinary = newcolor
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

			qdel(host.vore_selected)
			host.vore_selected = host.vore_organs[1]
			. = TRUE
		if("b_belly_sprite_to_affect")
			var/belly_choice = tgui_input_list(user, "Which belly sprite do you want your [lowertext(host.vore_selected.name)] to affect?","Select Region", host.vore_icon_bellies)
			if(!belly_choice) //They cancelled, no changes
				return FALSE
			else
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
			var/absorbed_multiplier_input = tgui_input_number(user, "Set the impact absorbed prey's size have on your vore sprite. 1 means no scaling, 0.5 means absorbed prey count half as much, 2 means absorbed prey count double. (Range from 0.1 - 3)", "Absorbed Multiplier", host.vore_selected.absorbed_multiplier, 3, 0.1, round_value=FALSE)
			if(!isnull(absorbed_multiplier_input))
				host.vore_selected.absorbed_multiplier = CLAMP(absorbed_multiplier_input, 0.1, 3)
				host.handle_belly_update()
			. = TRUE
		if("b_count_items_for_sprites")
			host.vore_selected.count_items_for_sprite = !host.vore_selected.count_items_for_sprite
			host.handle_belly_update()
			. = TRUE
		if("b_item_multiplier")
			var/item_multiplier_input = tgui_input_number(user, "Set the impact items will have on your vore sprite. 1 means a belly with 8 normal-sized items will count as 1 normal sized prey-thing's worth, 0.5 means items count half as much, 2 means items count double. (Range from 0.1 - 10)", "Item Multiplier", host.vore_selected.item_multiplier, 10, 0.1, round_value=FALSE)
			if(!isnull(item_multiplier_input))
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
			var/size_factor_input = tgui_input_number(user, "Set the impact all belly content's collective size has on your vore sprite. 1 means no scaling, 0.5 means content counts half as much, 2 means contents count double. (Range from 0.1 - 3)", "Size Factor", host.vore_selected.size_factor_for_sprite, 3, 0.1, round_value=FALSE)
			if(!isnull(size_factor_input))
				host.vore_selected.size_factor_for_sprite = CLAMP(size_factor_input, 0.1, 3)
				host.handle_belly_update()
			. = TRUE
		if("b_vore_sprite_flags")
			var/list/menu_list = host.vore_selected.vore_sprite_flag_list.Copy()
			var/toggle_vs_flag = tgui_input_list(user, "Toggle Vore Sprite Modes", "Mode Choice", menu_list)
			if(!toggle_vs_flag)
				return FALSE
			host.vore_selected.vore_sprite_flags ^= host.vore_selected.vore_sprite_flag_list[toggle_vs_flag]
			. = TRUE
		if("b_undergarment_choice")
			var/datum/category_group/underwear/undergarment_choice = tgui_input_list(user, "Which undergarment do you want to enable when your [lowertext(host.vore_selected.name)] is filled?","Select Undergarment Class", global_underwear.categories)
			if(!undergarment_choice) //They cancelled, no changes
				return FALSE
			else
				host.vore_selected.undergarment_chosen = undergarment_choice.name
				host.handle_belly_update()
			. = TRUE
		if("b_undergarment_if_none")
			var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[host.vore_selected.undergarment_chosen]
			var/datum/category_item/underwear/selected_underwear = tgui_input_list(user, "If no undergarment is equipped, which undergarment style do you want to use?","Select Underwear Style",UWC.items,host.vore_selected.undergarment_if_none)
			if(!selected_underwear) //They cancelled, no changes
				return FALSE
			else
				host.vore_selected.undergarment_if_none = selected_underwear
				host.handle_belly_update()
				host.updateVRPanel()
		if("b_undergarment_color")
			var/newcolor = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.undergarment_color)
			if(newcolor)
				host.vore_selected.undergarment_color = newcolor
				host.handle_belly_update()
			. = TRUE
		if("b_tail_to_change_to")
			var/tail_choice = tgui_input_list(user, "Which tail sprite do you want to use when your [lowertext(host.vore_selected.name)] is filled?","Select Sprite", global.tail_styles_list)
			if(!tail_choice) //They cancelled, no changes
				return FALSE
			else
				host.vore_selected.tail_to_change_to = tail_choice
			. = TRUE
		if("b_tail_color")
			var/newcolor = tgui_color_picker(user, "Choose tail color.", "", host.vore_selected.tail_colouration)
			if(newcolor)
				host.vore_selected.tail_colouration = newcolor
			. = TRUE
		if("b_tail_color2")
			var/newcolor = tgui_color_picker(user, "Choose tail secondary color.", "", host.vore_selected.tail_extra_overlay)
			if(newcolor)
				host.vore_selected.tail_extra_overlay = newcolor
			. = TRUE
		if("b_tail_color3")
			var/newcolor = tgui_color_picker(user, "Choose tail tertiary color.", "", host.vore_selected.tail_extra_overlay2)
			if(newcolor)
				host.vore_selected.tail_extra_overlay2 = newcolor
			. = TRUE
	if(.)
		unsaved_changes = TRUE
