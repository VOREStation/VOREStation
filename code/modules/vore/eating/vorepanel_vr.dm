//
// Vore management panel for players
//

#define STATION_PREF_NAME "Virgo"
#define VORE_BELLY_TAB 0
#define SOULCATCHER_TAB 1
#define PREFERENCE_TAB 2

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
	var/icon_overflow = FALSE
	var/max_icon_content = 21 //Contents above this disable icon mode. 21 for nice 3 rows to fill the default panel window.
	var/active_tab = 0 // our current tab
	var/active_vore_tab = 0 // our vore sub tab
	var/message_option = 0 // our examine subtab
	var/message_subtab // our examine subtab
	var/selected_message

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
	. += get_asset_datum(/datum/asset/spritesheet/vore_fixed) //Either this isn't working or my cache is corrupted and won't show them.

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
		if(istype(M,/mob/living/simple_mob)) //not generating unique icons for every simplemob(number)
			var/mob/living/simple_mob/S = M
			key = "[S.icon_living]"
		else
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

	// General Data
	data["unsaved_changes"] = unsaved_changes
	data["active_tab"] = active_tab

	// Inisde Data
	data["inside"] = get_inside_data(host)

	data["host_mobtype"] = null
	data["show_pictures"] = null
	data["icon_overflow"] = null
	data["our_bellies"] = null
	data["selected"] = null
	data["soulcatcher"] = null
	data["abilities"] = null
	data["prefs"] = null

	if(active_tab == VORE_BELLY_TAB)
		data["active_vore_tab"] = active_vore_tab
		data["host_mobtype"] = get_host_mobtype(host)

		// Content Data
		data["show_pictures"] = show_pictures
		data["icon_overflow"] = icon_overflow

		// List of all our bellies
		data["our_bellies"] = get_vorebellies(host)

		// Selected belly data. TODO, split this into sub data per tab, we don't need all of this at once, ever!
		data["selected"] = get_selected_data(host)

	if(active_tab == SOULCATCHER_TAB)
		// Soulcatcher and abilities
		data["our_bellies"] = get_vorebellies(host, FALSE)
		data["soulcatcher"] = get_soulcatcher_data(host)
		data["abilities"] = get_ability_data(host)

	if(active_tab == PREFERENCE_TAB)
		// Preference data, we only ever need that when we go to the pref page!
		data["prefs"] = get_preference_data(host)

	return data

/datum/vore_look/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("change_tab")
			var/new_tab = params["tab"]
			if(isnum(new_tab))
				active_tab = new_tab
			return TRUE

		if("change_vore_tab")
			var/new_tab = params["tab"]
			if(isnum(new_tab))
				active_vore_tab = new_tab
			return TRUE

		if("change_message_option")
			var/new_tab = params["tab"]
			if(isnum(new_tab))
				message_option = new_tab
				message_subtab = null
				selected_message = null
			return TRUE

		if("change_message_type")
			var/new_tab = params["tab"]
			if(istext(new_tab))
				message_subtab = new_tab
				selected_message = null
			return TRUE

		if("set_current_message")
			var/new_tab = params["tab"]
			if(istext(new_tab))
				selected_message = new_tab
			return TRUE

		if("show_pictures")
			show_pictures = !show_pictures
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
			// Lets check for unsavable bellies...
			var/list/unsavable_bellies = list()
			for(var/obj/belly/B in host.vore_organs)
				if(B.prevent_saving)
					unsavable_bellies += B.name
			if(LAZYLEN(unsavable_bellies))
				var/choice = tgui_alert(ui.user, "Warning: One or more of your vore organs are unsavable. Saving now will save every vore belly except \[[jointext(unsavable_bellies, ", ")]\]. Are you sure you want to save?", "WARNING!", list("No, abort!", "Yes, save."))
				if(choice != "Yes, save.")
					return TRUE
			if(!host.save_vore_prefs())
				tgui_alert_async(ui.user, "ERROR: " + STATION_PREF_NAME + "-specific preferences failed to save!","Error")
			else
				to_chat(ui.user, span_notice(STATION_PREF_NAME + "-specific preferences saved!"))
				unsaved_changes = FALSE
			return TRUE
		if("reloadprefs")
			var/alert = tgui_alert(ui.user, "Are you sure you want to reload character slot preferences? This will remove your current vore organs and eject their contents.","Confirmation",list("Reload","Cancel"))
			if(alert != "Reload")
				return FALSE
			if(!host.apply_vore_prefs())
				tgui_alert_async(ui.user, "ERROR: " + STATION_PREF_NAME + "-specific preferences failed to apply!","Error")
			else
				to_chat(ui.user,span_notice(STATION_PREF_NAME + "-specific preferences applied from active slot!"))
				unsaved_changes = FALSE
			return TRUE
		if("loadprefsfromslot")
			var/alert = tgui_alert(ui.user, "Are you sure you want to load another character slot's preferences? This will remove your current vore organs and eject their contents. This will not be immediately saved to your character slot, and you will need to save manually to overwrite your current bellies and preferences.","Confirmation",list("Load","Cancel"))
			if(alert != "Load")
				return FALSE
			if(!host.load_vore_prefs_from_slot())
				tgui_alert_async(ui.user, "ERROR: Vore-specific preferences failed to apply!","Error")
			else
				to_chat(ui.user,span_notice("Vore-specific preferences applied from active slot!"))
				unsaved_changes = TRUE
			return TRUE
		//"Belly HTML Export Earlyport"
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
		if("toggle_latejoin_vore")
			host.latejoin_vore = !host.latejoin_vore
			if(host.client.prefs_vr)
				host.client.prefs_vr.latejoin_vore = host.latejoin_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_latejoin_prey")
			host.latejoin_prey = !host.latejoin_prey
			if(host.client.prefs_vr)
				host.client.prefs_vr.latejoin_prey = host.latejoin_prey
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
		if("toggle_strippref")
			host.strip_pref = !host.strip_pref
			if(host.client.prefs_vr)
				host.client.prefs_vr.strip_pref = host.strip_pref
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
			if (isbelly(host.loc))
				var/obj/belly/B = host.loc
				B.vore_fx(host, TRUE)
			else
				host.clear_fullscreen("belly")
			if(!host.hud_used.hud_shown)
				host.toggle_hud_vis()
			unsaved_changes = TRUE
			return TRUE
		if("toggle_noisy")
			host.noisy = !host.noisy
			unsaved_changes = TRUE
			return TRUE
		// liquid belly code
		if("liq_set_attribute")
			return liq_set_attr(ui.user, params)
		if("toggle_liq_rec")
			host.receive_reagents = !host.receive_reagents
			if(host.client.prefs_vr)
				host.client.prefs_vr.receive_reagents = host.receive_reagents
			unsaved_changes = TRUE
			return TRUE
		if("toggle_liq_giv")
			host.give_reagents = !host.give_reagents
			if(host.client.prefs_vr)
				host.client.prefs_vr.give_reagents = host.give_reagents
			unsaved_changes = TRUE
			return TRUE
		if("toggle_liq_apply")
			host.apply_reagents = !host.apply_reagents
			if(host.client.prefs_vr)
				host.client.prefs_vr.apply_reagents = host.apply_reagents
			unsaved_changes = TRUE
			return TRUE
		if("toggle_autotransferable")
			host.autotransferable = !host.autotransferable
			if(host.client.prefs_vr)
				host.client.prefs_vr.autotransferable = host.autotransferable
			unsaved_changes = TRUE
			return TRUE
		//Belch code
		if("toggle_noisy_full")
			host.noisy_full = !host.noisy_full
			unsaved_changes = TRUE
			return TRUE
		if("toggle_drop_vore")
			host.drop_vore = !host.drop_vore
			if(host.client.prefs_vr)
				host.client.prefs_vr.drop_vore = host.drop_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_slip_vore")
			host.slip_vore = !host.slip_vore
			if(host.client.prefs_vr)
				host.client.prefs_vr.slip_vore = host.slip_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_stumble_vore")
			host.stumble_vore = !host.stumble_vore
			if(host.client.prefs_vr)
				host.client.prefs_vr.stumble_vore = host.stumble_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_throw_vore")
			host.throw_vore = !host.throw_vore
			if(host.client.prefs_vr)
				host.client.prefs_vr.throw_vore = host.throw_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_phase_vore")
			host.phase_vore = !host.phase_vore
			if(host.client.prefs_vr)
				host.client.prefs_vr.phase_vore = host.phase_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_food_vore")
			host.food_vore = !host.food_vore
			if(host.client.prefs_vr)
				host.client.prefs_vr.food_vore = host.food_vore
			unsaved_changes = TRUE
			return TRUE
		if("toggle_consume_liquid_belly")
			host.consume_liquid_belly = !host.consume_liquid_belly
			if(host.client.prefs_vr)
				host.client.prefs_vr.consume_liquid_belly = host.consume_liquid_belly
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
		//vore sprites color
		if("set_belly_rub")
			host.belly_rub_target = tgui_input_list(ui.user, "Which belly would you prefer to be rubbed?","Select Target", host.vore_organs)
			if(!(host.belly_rub_target))
				host.belly_rub_target = null
			if(host.client.prefs_vr)
				host.client.prefs_vr.belly_rub_target = host.belly_rub_target
			unsaved_changes = TRUE
			return TRUE
		if("toggle_no_latejoin_vore_warning")
			host.no_latejoin_vore_warning = !host.no_latejoin_vore_warning
			if(host.client.prefs_vr)
				host.client.prefs_vr.no_latejoin_vore_warning = host.no_latejoin_vore_warning
			if(host.no_latejoin_vore_warning_persists)
				unsaved_changes = TRUE
			return TRUE
		if("toggle_no_latejoin_prey_warning")
			host.no_latejoin_prey_warning = !host.no_latejoin_prey_warning
			if(host.client.prefs_vr)
				host.client.prefs_vr.no_latejoin_prey_warning = host.no_latejoin_prey_warning
			if(host.no_latejoin_prey_warning_persists)
				unsaved_changes = TRUE
			return TRUE
		if("adjust_no_latejoin_vore_warning_time")
			host.no_latejoin_vore_warning_time = text2num(params["new_pred_time"])
			if(host.client.prefs_vr)
				host.client.prefs_vr.no_latejoin_vore_warning_time = host.no_latejoin_vore_warning_time
			if(host.no_latejoin_vore_warning_persists)
				unsaved_changes = TRUE
			return TRUE
		if("adjust_no_latejoin_prey_warning_time")
			host.no_latejoin_prey_warning_time = text2num(params["new_prey_time"])
			if(host.client.prefs_vr)
				host.client.prefs_vr.no_latejoin_prey_warning_time = host.no_latejoin_prey_warning_time
			if(host.no_latejoin_prey_warning_persists)
				unsaved_changes = TRUE
			return TRUE
		if("toggle_no_latejoin_vore_warning_persists")
			host.no_latejoin_vore_warning_persists = !host.no_latejoin_vore_warning_persists
			if(host.client.prefs_vr)
				host.client.prefs_vr.no_latejoin_vore_warning_persists = host.no_latejoin_vore_warning_persists
			unsaved_changes = TRUE
			return TRUE
		if("toggle_no_latejoin_prey_warning_persists")
			host.no_latejoin_prey_warning_persists = !host.no_latejoin_prey_warning_persists
			if(host.client.prefs_vr)
				host.client.prefs_vr.no_latejoin_prey_warning_persists = host.no_latejoin_prey_warning_persists
			unsaved_changes = TRUE
			return TRUE
		//Soulcatcher prefs
		if("toggle_soulcatcher_allow_capture")
			host.soulcatcher_pref_flags ^= SOULCATCHER_ALLOW_CAPTURE
			if(host.client.prefs_vr)
				host.client.prefs_vr.soulcatcher_pref_flags = host.soulcatcher_pref_flags
			unsaved_changes = TRUE
			return TRUE
		if("toggle_soulcatcher_allow_transfer")
			host.soulcatcher_pref_flags ^= SOULCATCHER_ALLOW_TRANSFER
			if(host.client.prefs_vr)
				host.client.prefs_vr.soulcatcher_pref_flags = host.soulcatcher_pref_flags
			unsaved_changes = TRUE
			return TRUE
		if("toggle_soulcatcher_allow_takeover")
			host.soulcatcher_pref_flags ^= SOULCATCHER_ALLOW_TAKEOVER
			if(host.client.prefs_vr)
				host.client.prefs_vr.soulcatcher_pref_flags = host.soulcatcher_pref_flags
			unsaved_changes = TRUE
			return TRUE
		if("toggle_soulcatcher_allow_deletion")
			var/current_number = global_flag_check(host.soulcatcher_pref_flags, SOULCATCHER_ALLOW_DELETION) + global_flag_check(host.soulcatcher_pref_flags, SOULCATCHER_ALLOW_DELETION_INSTANT)
			switch(current_number)
				if(0)
					host.soulcatcher_pref_flags ^= SOULCATCHER_ALLOW_DELETION
				if(1)
					host.soulcatcher_pref_flags ^= SOULCATCHER_ALLOW_DELETION_INSTANT
				if(2)
					host.soulcatcher_pref_flags &= ~(SOULCATCHER_ALLOW_DELETION)
					host.soulcatcher_pref_flags &= ~(SOULCATCHER_ALLOW_DELETION_INSTANT)
			if(host.client.prefs_vr)
				host.client.prefs_vr.soulcatcher_pref_flags = host.soulcatcher_pref_flags
			unsaved_changes = TRUE
			return TRUE
		if("adjust_own_size")
			var/new_size = text2num(params["new_mob_size"])
			new_size = clamp(new_size, RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
			if(istype(host, /mob/living))
				var/mob/living/H = host
				if(H.nutrition >= VORE_RESIZE_COST)
					H.adjust_nutrition(-VORE_RESIZE_COST)
					H.resize(new_size, uncapped = host.has_large_resize_bounds(), ignore_prefs = TRUE)
			return TRUE
		//Soulcatcher functions
		if("soulcatcher_release_all")
			host.soulgem.release_mobs()
			return TRUE
		if("soulcatcher_erase_all")
			host.soulgem.erase_mobs()
			return TRUE
		if("soulcatcher_release")
			host.soulgem.release_selected()
			return TRUE
		if("soulcatcher_transfer")
			host.soulgem.transfer_selected()
			return TRUE
		if("soulcatcher_delete")
			host.soulgem.delete_selected()
			return TRUE
		if("soulcatcher_transfer_control")
			host.soulgem.take_control_selected()
			return TRUE
		if("soulcatcher_release_control")
			host.soulgem.take_control_owner()
			return TRUE
		if("soulcatcher_select")
			host.soulgem.selected_soul = locate(params["selected_soul"])
			return TRUE
		//Soulcatcher settings
		if("soulcatcher_toggle")
			host.soulgem.toggle_setting(SOULGEM_ACTIVE)
			unsaved_changes = TRUE
			return TRUE
		if("soulcatcher_sfx")
			var/obj/belly = locate(params["selected_belly"])
			if(istype(belly))
				host.soulgem.update_linked_belly(belly)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_self_catching")
			host.soulgem.toggle_setting(NIF_SC_CATCHING_ME)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_prey_catching")
			host.soulgem.toggle_setting(NIF_SC_CATCHING_OTHERS)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_drain_catching")
			host.soulgem.toggle_setting(SOULGEM_CATCHING_DRAIN)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_ghost_catching")
			host.soulgem.toggle_setting(SOULGEM_CATCHING_GHOSTS)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_ext_hearing")
			host.soulgem.toggle_setting(NIF_SC_ALLOW_EARS)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_ext_vision")
			host.soulgem.toggle_setting(NIF_SC_ALLOW_EYES)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_mind_backup")
			host.soulgem.toggle_setting(NIF_SC_BACKUPS)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_sr_projecting")
			host.soulgem.toggle_setting(NIF_SC_PROJECTING)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_vore_sfx")
			host.soulgem.toggle_setting(SOULGEM_SHOW_VORE_SFX)
			unsaved_changes = TRUE
			return TRUE
		if("toggle_sr_vision")
			host.soulgem.toggle_setting(SOULGEM_SEE_SR_SOULS)
			unsaved_changes = TRUE
			return TRUE
		if("soulcatcher_rename")
			var/new_name = tgui_input_text(host, "Adjust the name of your soulcatcher. Limit 60 chars.", \
				"New Name", html_decode(host.soulgem.name), 60, prevent_enter = TRUE)
			if(new_name)
				unsaved_changes = TRUE
				host.soulgem.rename(new_name)
			return TRUE
		if("soulcatcher_interior_design")
			var/new_flavor = tgui_input_text(host, "Type what the prey sees after being 'caught'. This will be \
				printed after an intro set in the capture message to the prey. If you already \
				have prey, this will be printed to them after the transit message. Limit [MAX_MESSAGE_LEN * 2] chars.", \
				"VR Environment", html_decode(host.soulgem.inside_flavor), MAX_MESSAGE_LEN * 2, TRUE, prevent_enter = TRUE)
			if(new_flavor)
				unsaved_changes = TRUE
				host.soulgem.adjust_interior(new_flavor)
			return TRUE
		if("soulcatcher_capture_message")
			var/message = tgui_input_text(host, "Type what the prey sees while being 'caught'. This will be \
				printed before the iterior design to the prey. Limit [BELLIES_MESSAGE_MAX] chars.", \
				"VR Capture", html_decode(host.soulgem.capture_message), BELLIES_MESSAGE_MAX, TRUE, prevent_enter = TRUE)
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, "capture")
			return TRUE
		if("soulcatcher_transit_message")
			var/message = tgui_input_text(host, "Type what the prey sees when you change the interior with them already captured. \
				Limit [BELLIES_MESSAGE_MAX] chars.", "VR Transit", html_decode(host.soulgem.transit_message), BELLIES_MESSAGE_MAX, TRUE, prevent_enter = TRUE)
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, "transit")
			return TRUE
		if("soulcatcher_release_message")
			var/message = tgui_input_text(host, "Type what the prey sees when they are released. \
				Limit [BELLIES_MESSAGE_MAX] chars.", "VR Release", html_decode(host.soulgem.release_message), BELLIES_MESSAGE_MAX, TRUE, prevent_enter = TRUE)
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, "release")
			return TRUE
		if("soulcatcher_transfer_message")
			var/message = tgui_input_text(host, "Type what the prey sees when they are transfered. \
				Limit [BELLIES_MESSAGE_MAX] chars.", "VR Transfer", html_decode(host.soulgem.transfer_message), BELLIES_MESSAGE_MAX, TRUE, prevent_enter = TRUE)
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, "transfer")
			return TRUE
		if("soulcatcher_delete_message")
			var/message = tgui_input_text(host, "Type what the prey sees when they are deleted. \
				Limit [BELLIES_MESSAGE_MAX] chars.", "VR Transfer", html_decode(host.soulgem.delete_message), BELLIES_MESSAGE_MAX, TRUE, prevent_enter = TRUE)
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, "delete")
			return TRUE

/datum/vore_look/proc/pick_from_inside(mob/user, params)
	var/atom/movable/target = locate(params["pick"])
	var/obj/belly/OB = locate(params["belly"])

	if(!(target in OB))
		return TRUE // Aren't here anymore, need to update menu

	var/intent = "Examine"
	// Only allow indirect belly viewers to examine
	if(user in OB)
		if(isliving(target))
			intent = tgui_alert(user, "What do you want to do to them?","Query",list("Examine","Help Out","Devour"))

		else if(istype(target, /obj/item))
			intent = tgui_alert(user, "What do you want to do to that?","Query",list("Examine","Use Hand"))
	//End of indirect vorefx changes

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
					// Send the transfer message to indirect targets as well. Slightly different message because why not.
					to_chat(host.vore_selected.get_belly_surrounding(target.contents),span_warning("You're squished along with [target] from [host]'s [lowertext(host.vore_selected)] to their [lowertext(choice.name)]!"))
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
	// Add Reforming
	if(isobserver(target) || istype(target,/obj/item/mmi))
		available_options += "Reform"

	if(isliving(target))
		var/mob/living/datarget = target
		if(datarget.client)
			available_options += "Process"
		available_options += "Health"
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
			// Send the transfer message to indirect targets as well. Slightly different message because why not.
			to_chat(host.vore_selected.get_belly_surrounding(target.contents),span_warning("You're squished along with [target] from [host]'s [lowertext(host.vore_selected)] to their [lowertext(choice.name)]!"))
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

		// Add Reforming
		if("Reform")
			if(host.stat)
				to_chat(user,span_warning("You can't do that in your state!"))
				return TRUE

			if(isobserver(target))
				var/mob/observer/T = target
				if(!ismob(T.body_backup) || GLOB.prevent_respawns.Find(T.mind.name) || ispAI(T.body_backup))
					to_chat(user,span_warning("They don't seem to be reformable!"))
					return TRUE

				var/accepted = tgui_alert(T, "[host] is trying to reform your body! Would you like to get reformed inside [host]'s [lowertext(host.vore_selected.name)]?", "Reforming Attempt", list("Yes", "No"))
				if(accepted != "Yes")
					to_chat(user,span_warning("[T] refused to be reformed!"))
					return TRUE
				if(!isbelly(T.loc))
					to_chat(user,span_warning("[T] is no longer inside to be reformed!"))
					to_chat(T,span_warning("You can't be reformed outside of a belly!"))
					return TRUE

				if(isliving(T.body_backup))
					var/mob/living/body_backup = T.body_backup
					if(ishuman(body_backup))
						var/mob/living/carbon/human/H = body_backup
						body_backup.adjustBruteLoss(-6)
						body_backup.adjustFireLoss(-6)
						body_backup.setOxyLoss(0)
						if(H.isSynthetic())
							H.adjustToxLoss(-H.getToxLoss())
						else
							H.adjustToxLoss(-6)
						body_backup.adjustCloneLoss(-6)
						body_backup.updatehealth()
						// Now we do the check to see if we should revive...
						var/should_proceed_with_revive = TRUE
						var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[O_BRAIN]
						should_proceed_with_revive &&= !H.should_have_organ(O_BRAIN) || (brain && (!istype(brain) || brain.defib_timer > 0))
						if(!H.isSynthetic())
							should_proceed_with_revive &&= !(HUSK in H.mutations) && H.can_defib
						if(should_proceed_with_revive)
							for(var/organ_tag in H.species.has_organ)
								var/obj/item/organ/O = H.species.has_organ[organ_tag]
								var/vital = initial(O.vital) //check for vital organs
								if(vital)
									O = H.internal_organs_by_name[organ_tag]
									if(!O || O.damage > O.max_damage)
										should_proceed_with_revive = FALSE
										break
						if(should_proceed_with_revive)
							dead_mob_list.Remove(H)
							if((H in living_mob_list) || (H in dead_mob_list))
								WARNING("Mob [H] was reformed but already in the living or dead list still!")
							living_mob_list += H

							H.timeofdeath = 0
							H.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
							H.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
							H.reload_fullscreen()
					else
						body_backup.revive()
					body_backup.forceMove(T.loc)
					body_backup.enabled = TRUE
					body_backup.ajourn = 0
					body_backup.key = T.key
					body_backup.teleop = null
					T.body_backup = null
					host.vore_selected.release_specific_contents(T, TRUE)
					if(istype(body_backup, /mob/living/simple_mob))
						var/mob/living/simple_mob/sm = body_backup
						if(sm.icon_rest && sm.resting)
							sm.icon_state = sm.icon_rest
						else
							sm.icon_state = sm.icon_living
					T.update_icon()
					announce_ghost_joinleave(T.mind, 0, "They now occupy their body again.")
			else if(istype(target,/obj/item/mmi)) // A good bit of repeated code, sure, but... cleanest way to do this.
				var/obj/item/mmi/MMI = target
				if(!ismob(MMI.body_backup) || !MMI.brainmob.mind || GLOB.prevent_respawns.Find(MMI.brainmob.mind.name))
					to_chat(user,span_warning("They don't seem to be reformable!"))
					return TRUE
				var/accepted = tgui_alert(MMI.brainmob, "[host] is trying to reform your body! Would you like to get reformed inside [host]'s [lowertext(host.vore_selected.name)]?", "Reforming Attempt", list("Yes", "No"))
				if(accepted != "Yes")
					to_chat(user,span_warning("[MMI] refused to be reformed!"))
					return TRUE

				if(isliving(MMI.body_backup))
					var/mob/living/body_backup = MMI.body_backup
					body_backup.enabled = TRUE
					body_backup.forceMove(MMI.loc)
					body_backup.ajourn = 0
					body_backup.teleop = null
					//And now installing the MMI into the body...
					if(isrobot(body_backup)) //Just do the reverse of getting the MMI pulled out in /obj/belly/proc/digestion_death
						var/mob/living/silicon/robot/R = body_backup
						R.revive()
						MMI.brainmob.mind.transfer_to(R)
						MMI.loc = R
						R.mmi = MMI
						R.mmi.brainmob.add_language(LANGUAGE_ROBOT_TALK)
					else //reference /datum/surgery_step/robotics/install_mmi/end_step
						var/obj/item/organ/internal/mmi_holder/holder
						if(istype(MMI, /obj/item/mmi/digital/posibrain))
							var/obj/item/organ/internal/mmi_holder/posibrain/holdertmp = new(body_backup, 1)
							holder = holdertmp
						else if(istype(MMI, /obj/item/mmi/digital/robot))
							var/obj/item/organ/internal/mmi_holder/robot/holdertmp = new(body_backup, 1)
							holder = holdertmp
						else
							holder = new(body_backup, 1)
						body_backup.internal_organs_by_name[O_BRAIN] = holder
						MMI.loc = holder
						holder.stored_mmi = MMI
						holder.update_from_mmi()

						if(MMI.brainmob && MMI.brainmob.mind)
							MMI.brainmob.mind.transfer_to(body_backup)
							body_backup.languages = MMI.brainmob.languages
						//You've hopefully already named yourself, so... not implementing that bit.
						var/mob/living/carbon/human/H = body_backup
						body_backup.adjustBruteLoss(-6, TRUE)
						body_backup.adjustFireLoss(-6, TRUE)
						body_backup.setOxyLoss(0)
						H.adjustToxLoss(-H.getToxLoss())
						body_backup.adjustCloneLoss(-6)
						body_backup.updatehealth()
						// Now we do the check to see if we should revive...
						var/should_proceed_with_revive = TRUE
						var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[O_BRAIN]
						should_proceed_with_revive &&= !H.should_have_organ(O_BRAIN) || (brain && brain.defib_timer > 0 )
						if(should_proceed_with_revive)
							for(var/organ_tag in H.species.has_organ)
								var/obj/item/organ/O = H.species.has_organ[organ_tag]
								var/vital = initial(O.vital) //check for vital organs
								if(vital)
									O = H.internal_organs_by_name[organ_tag]
									if(!O || O.damage > O.max_damage)
										should_proceed_with_revive = FALSE
										break
						if(should_proceed_with_revive)
							dead_mob_list.Remove(H)
							if((H in living_mob_list) || (H in dead_mob_list))
								WARNING("Mob [H] was defibbed but already in the living or dead list still!")
							living_mob_list += H

							H.timeofdeath = 0
							H.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
							H.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
							H.reload_fullscreen()
					MMI.body_backup = null
			return TRUE
		if("Health")
			var/mob/living/ourtarget = target
			to_chat(user, span_notice("Current health reading for \The [ourtarget]: [ourtarget.health] / [ourtarget.getMaxHealth()] "))
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
			var/new_egg_name = sanitize(params["val"], BELLIES_NAME_MAX)
			host.vore_selected.egg_name = new_egg_name
			. = TRUE
		if("b_egg_size")
			var/new_egg_size = text2num(params["val"])
			if(isnum(new_egg_size))
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
			var/belly_choice = params["Val"]
			if(!(belly_choice in list("Sleeper", "Vorebelly", "Both")))
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
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.release_sound]","Select Sound", GLOB.fancy_release_sounds)
			else
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.release_sound]","Select Sound", GLOB.classic_release_sounds)

			if(!choice)
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
			var/choice
			if(host.vore_selected.fancy_vore)
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.vore_sound]","Select Sound", GLOB.fancy_vore_sounds)
			else
				choice = tgui_input_list(user,"Currently set to [host.vore_selected.vore_sound]","Select Sound", GLOB.classic_vore_sounds)

			if(!choice)
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
			var/sound_volume_input = tgui_input_number(user, "Set belly sound volume percentage.", "Sound Volume", null, 100, 0)
			if(!isnull(sound_volume_input)) //These have to be 'null' because both cancel and 0 are valid, separate options
				host.vore_selected.sound_volume = sanitize_integer(sound_volume_input, 0, 100, initial(host.vore_selected.sound_volume))
			. = TRUE
		if("b_noise_freq")
			var/list/preset_noise_freqs = list("high" = MAX_VOICE_FREQ, "middle-high" = 56250, "middle" = 42500, "middle-low"= 28750, "low" = MIN_VOICE_FREQ, "custom" = 1, "random" = 0)
			var/choice = tgui_input_list(user, "What would you like to set your noise frequency to? ([MIN_VOICE_FREQ] - [MAX_VOICE_FREQ])", "Noise Frequency", preset_noise_freqs)
			if(!choice)
				return
			choice = preset_noise_freqs[choice]
			if(choice == 0)
				host.vore_selected.noise_freq = 42500
				return TOPIC_REFRESH
			else if(choice == 1)
				choice = tgui_input_number(user, "Choose your organ's noise frequency, ranging from [MIN_VOICE_FREQ] to [MAX_VOICE_FREQ]", "Custom Noise Frequency", null, MAX_VOICE_FREQ, MIN_VOICE_FREQ, round_value = TRUE)
			if(choice > MAX_VOICE_FREQ)
				choice = MAX_VOICE_FREQ
			else if(choice < MIN_VOICE_FREQ)
				choice = MIN_VOICE_FREQ
			host.vore_selected.noise_freq = choice
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
			new_damage = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_burn) // sanity check following tgui input
			host.vore_selected.digest_burn = new_damage
			host.vore_selected.items_preserved.Cut()
			. = TRUE
		if("b_brute_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			new_damage = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_brute)
			host.vore_selected.digest_brute = new_damage
			host.vore_selected.items_preserved.Cut()
			. = TRUE
		if("b_oxy_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			new_damage = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_oxy)
			host.vore_selected.digest_oxy = new_damage
			. = TRUE
		if("b_tox_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			new_damage = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_tox)
			host.vore_selected.digest_tox = new_damage
			. = TRUE
		if("b_clone_dmg")
			var/new_damage = text2num(params["val"])
			if(!isnum(new_damage))
				return FALSE
			new_damage = CLAMP(new_damage, 0, host.vore_selected.get_unused_digestion_damage() + host.vore_selected.digest_clone)
			host.vore_selected.digest_clone = new_damage
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
		if("b_belchchance")
			var/belch_chance_input = tgui_input_number(user, "Set chance for belch emote on prey resist (as %)", "Resist Belch Chance", host.vore_selected.belchchance , 100, 0)
			if(!isnull(belch_chance_input))
				host.vore_selected.belchchance = sanitize_integer(belch_chance_input, 0, 100, initial(host.vore_selected.belchchance))
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
		if("b_autotransferchance")
			var/autotransferchance_input = tgui_input_number(user, "Set belly auto-transfer chance (as %). You must also set the location for this to have any effect.", "Auto-Transfer Chance", host.vore_selected.autotransferchance, 100)
			if(!isnull(autotransferchance_input))
				host.vore_selected.autotransferchance = sanitize_integer(autotransferchance_input, 0, 100, initial(host.vore_selected.autotransferchance))
			. = TRUE
		if("b_autotransferwait")
			var/autotransferwait_input = tgui_input_number(user, "Set minimum number of seconds for auto-transfer wait delay.", "Auto-Transfer Time", host.vore_selected.autotransferwait, 1800, 1)
			if(!isnull(autotransferwait_input))
				host.vore_selected.autotransferwait = sanitize_integer(autotransferwait_input*10, 10, 18000, initial(host.vore_selected.autotransferwait))
			. = TRUE
		if("b_autotransferlocation")
			var/obj/belly/choice = tgui_input_list(user, "Where do you want your [lowertext(host.vore_selected.name)] auto-transfer to?","Select Belly", (host.vore_organs + "None - Remove" - host.vore_selected))
			if(!choice) //They cancelled, no changes
				return FALSE
			else if(choice == "None - Remove")
				host.vore_selected.autotransferlocation = null
			else
				host.vore_selected.autotransferlocation = choice.name
			. = TRUE
		if("b_autotransferextralocation")
			var/obj/belly/choice = tgui_input_list(user, "What extra places do you want your [lowertext(host.vore_selected.name)] auto-transfer to?","Select Belly", (host.vore_organs - host.vore_selected - host.vore_selected.autotransferlocation))
			if(!choice) //They cancelled, no changes
				return FALSE
			else if(choice.name in host.vore_selected.autotransferextralocation)
				host.vore_selected.autotransferextralocation -= choice.name
			else
				host.vore_selected.autotransferextralocation += choice.name
			. = TRUE
		if("b_autotransferchance_secondary")
			var/autotransferchance_secondary_input = tgui_input_number(user, "Set secondary belly auto-transfer chance (as %). You must also set the location for this to have any effect.", "Secondary Auto-Transfer Chance")
			if(!isnull(autotransferchance_secondary_input))
				host.vore_selected.autotransferchance_secondary = sanitize_integer(autotransferchance_secondary_input, 0, 100, initial(host.vore_selected.autotransferchance_secondary))
			. = TRUE
		if("b_autotransferlocation_secondary")
			var/obj/belly/choice = tgui_input_list(user, "Where do you want your secondary [lowertext(host.vore_selected.name)] auto-transfer to?","Select Belly", (host.vore_organs + "None - Remove" - host.vore_selected))
			if(!choice) //They cancelled, no changes
				return FALSE
			else if(choice == "None - Remove")
				host.vore_selected.autotransferlocation_secondary = null
			else
				host.vore_selected.autotransferlocation_secondary = choice.name
			. = TRUE
		if("b_autotransferextralocation_secondary")
			var/obj/belly/choice = tgui_input_list(user, "What extra places do you want your [lowertext(host.vore_selected.name)] auto-transfer to?","Select Belly", (host.vore_organs - host.vore_selected - host.vore_selected.autotransferlocation_secondary))
			if(!choice) //They cancelled, no changes
				return FALSE
			else if(choice.name in host.vore_selected.autotransferextralocation_secondary)
				host.vore_selected.autotransferextralocation_secondary -= choice.name
			else
				host.vore_selected.autotransferextralocation_secondary += choice.name
			. = TRUE
		if("b_autotransfer_whitelist")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Whitelist", "Whitelist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_whitelist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
		if("b_autotransfer_blacklist")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Blacklist", "Blacklist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_blacklist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
		if("b_autotransfer_secondary_whitelist")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Whitelist", "Whitelist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_secondary_whitelist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
		if("b_autotransfer_secondary_blacklist")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Blacklist", "Blacklist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_secondary_blacklist ^= host.vore_selected.autotransfer_flags_list[toggle_addon]
			. = TRUE
			. = TRUE
		if("b_autotransfer_whitelist_items")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list_items.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Whitelist", "Whitelist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_whitelist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_blacklist_items")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list_items.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Blacklist", "Blacklist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_blacklist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_secondary_whitelist_items")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list_items.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Whitelist", "Whitelist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_secondary_whitelist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_secondary_blacklist_items")
			var/list/menu_list = host.vore_selected.autotransfer_flags_list_items.Copy()
			var/toggle_addon = tgui_input_list(user, "Toggle Blacklist", "Blacklist Choice", menu_list)
			if(!toggle_addon)
				return FALSE
			host.vore_selected.autotransfer_secondary_blacklist_items ^= host.vore_selected.autotransfer_flags_list_items[toggle_addon]
			. = TRUE
		if("b_autotransfer_min_amount")
			var/autotransfer_min_amount_input = tgui_input_number(user, "Set the minimum amount of items your belly can belly auto-transfer at once. Set to 0 for no limit.", "Auto-Transfer Min Amount", host.vore_selected.autotransfer_min_amount, 100)
			if(!isnull(autotransfer_min_amount_input))
				host.vore_selected.autotransfer_min_amount = sanitize_integer(autotransfer_min_amount_input, 0, 100, initial(host.vore_selected.autotransfer_min_amount))
			. = TRUE
		if("b_autotransfer_max_amount")
			var/autotransfer_max_amount_input = tgui_input_number(user, "Set the maximum amount of items your belly can belly auto-transfer at once. Set to 0 for no limit.", "Auto-Transfer Max Amount", host.vore_selected.autotransfer_max_amount, 100)
			if(!isnull(autotransfer_max_amount_input))
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
			var/newcolor = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.belly_fullscreen_color)
			if(newcolor)
				host.vore_selected.belly_fullscreen_color = newcolor
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_color2")
			var/newcolor2 = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.belly_fullscreen_color2)
			if(newcolor2)
				host.vore_selected.belly_fullscreen_color2 = newcolor2
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_color3")
			var/newcolor3 = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.belly_fullscreen_color3)
			if(newcolor3)
				host.vore_selected.belly_fullscreen_color3 = newcolor3
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_color4")
			var/newcolor4 = tgui_color_picker(user, "Choose a color.", "", host.vore_selected.belly_fullscreen_color4)
			if(newcolor4)
				host.vore_selected.belly_fullscreen_color4 = newcolor4
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_fullscreen_alpha")
			var/newalpha = tgui_input_number(user, "Set alpha transparency between 0-255", "Vore Alpha",host.vore_selected.belly_fullscreen_alpha,255,0,0,1)
			if(newalpha)
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
		if("b_vorespawn_blacklist")
			host.vore_selected.vorespawn_blacklist = !host.vore_selected.vorespawn_blacklist
			. = TRUE
		if("b_vorespawn_whitelist")
			var/new_vorespawn_whitelist = sanitize(params["val"],MAX_MESSAGE_LEN,0,0,0)
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
		if("b_count_liquid_for_sprites")
			host.vore_selected.count_liquid_for_sprite = !host.vore_selected.count_liquid_for_sprite
			host.handle_belly_update()
			. = TRUE
		if("b_liquid_multiplier")
			var/liquid_multiplier_input = tgui_input_number(user, "Set the impact amount of liquid reagents will have on your vore sprite. 1 means a belly with 100 reagents of fluid will count as 1 normal sized prey-thing's worth, 0.5 means liquid counts half as much, 2 means liquid counts double. (Range from 0.1 - 10)", "Liquid Multiplier", host.vore_selected.liquid_multiplier, 10, 0.1, round_value=FALSE)
			if(!isnull(liquid_multiplier_input))
				host.vore_selected.liquid_multiplier = CLAMP(liquid_multiplier_input, 0.1, 10)
				host.handle_belly_update()
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

// liquid belly procs
/datum/vore_look/proc/liq_set_attr(mob/user, params)
	if(!host.vore_selected)
		tgui_alert(user, "No belly selected to modify.")
		return FALSE

	var/attr = params["liq_attribute"]
	switch(attr)
		if("b_show_liq")
			if(!host.vore_selected.show_liquids)
				host.vore_selected.show_liquids = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has liquid options."))
			else
				host.vore_selected.show_liquids = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has liquid options."))
			. = TRUE
		if("b_liq_reagent_gen")
			if(!host.vore_selected.reagentbellymode) //liquid container adjustments and interactions.
				host.vore_selected.reagentbellymode = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has interactions which can produce liquids."))
			else //Doesnt produce liquids
				host.vore_selected.reagentbellymode = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] wont produce liquids, liquids already in your [lowertext(host.vore_selected.name)] must be emptied out or removed with purge."))
			. = TRUE
		if("b_liq_reagent_type")
			var/list/menu_list = host.vore_selected.reagent_choices.Copy() //Useful if we want to make certain races, synths, borgs, and other things result in additional reagents to produce - Jack
			var/new_reagent = tgui_input_list(user, "Current reagent: [host.vore_selected.reagent_chosen]", "Choose Reagent", menu_list)
			if(!new_reagent)
				return FALSE

			host.vore_selected.reagent_chosen = new_reagent
			host.vore_selected.ReagentSwitch() // For changing variables when a new reagent is chosen
			. = TRUE
		if("b_liq_reagent_name")
			var/new_name = html_encode(tgui_input_text(user,"New name for liquid shown when transfering and dumping on floor (The actual liquid's name is still the same):","New Name",host.vore_selected.reagent_name))

			if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
				tgui_alert(user, "Entered name length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.reagent_name = new_name
			. = TRUE
		if("b_liq_reagent_transfer_verb")
			var/new_verb = html_encode(tgui_input_text(user,"New verb when liquid is transfered from this belly:","New Verb", host.vore_selected.reagent_transfer_verb))

			if(length(new_verb) > BELLIES_NAME_MAX || length(new_verb) < BELLIES_NAME_MIN)
				tgui_alert(user, "Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
				return FALSE

			host.vore_selected.reagent_transfer_verb = new_verb
			. = TRUE
		if("b_liq_reagent_nutri_rate")
			host.vore_selected.gen_time_display = tgui_input_list(user, "Choose the time it takes to fill the belly from empty state using nutrition.", "Set Liquid Production Time.",list("10 minutes","30 minutes","1 hour","3 hours","6 hours","12 hours","24 hours"))
			switch(host.vore_selected.gen_time_display)
				if("10 minutes")
					host.vore_selected.gen_time = 0
				if("30 minutes")
					host.vore_selected.gen_time = 2
				if("1 hour")
					host.vore_selected.gen_time = 5
				if("3 hours")
					host.vore_selected.gen_time = 17
				if("6 hours")
					host.vore_selected.gen_time = 35
				if("12 hours")
					host.vore_selected.gen_time = 71
				if("24 hours")
					host.vore_selected.gen_time = 143
				if(null)
					return FALSE
			. = TRUE
		if("b_liq_reagent_capacity")
			var/new_custom_vol = tgui_input_number(user, "Choose the amount of liquid the belly can contain at most. Ranges from 10 to 300.", "Set Custom Belly Capacity.", host.vore_selected.custom_max_volume, 300, 10)
			if(new_custom_vol == null)
				return FALSE
			var/new_new_custom_vol = CLAMP(new_custom_vol, 10, 300)
			host.vore_selected.custom_max_volume = new_new_custom_vol
			. = TRUE
		if("b_liq_sloshing")
			if(!host.vore_selected.vorefootsteps_sounds)
				host.vore_selected.vorefootsteps_sounds = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] can now make sounds when you walk around depending on how full you are."))
			else
				host.vore_selected.vorefootsteps_sounds = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] wont make any liquid sounds no matter how full it is."))
			. = TRUE
		if("b_liq_reagent_addons")
			var/list/menu_list = host.vore_selected.reagent_mode_flag_list.Copy()
			var/reagent_toggle_addon = tgui_input_list(user, "Toggle your addons", "Toggle Addon", menu_list)
			if(!reagent_toggle_addon)
				return FALSE
			host.vore_selected.reagent_mode_flags ^= host.vore_selected.reagent_mode_flag_list[reagent_toggle_addon]
			. = TRUE
		if("b_liquid_overlay")
			if(!host.vore_selected.liquid_overlay)
				host.vore_selected.liquid_overlay = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has liquid overlay enabled."))
			else
				host.vore_selected.liquid_overlay = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has liquid overlay enabled."))
			. = TRUE
		if("b_max_liquid_level")
			var/new_max_liquid_level = tgui_input_number(user, "Set custom maximum liquid level. 0-100%", "Set Custom Max Level.", host.vore_selected.max_liquid_level, 100)
			if(new_max_liquid_level == null)
				return FALSE
			var/new_new_max_liquid_level = CLAMP(new_max_liquid_level, 0, 100)
			host.vore_selected.max_liquid_level = new_new_max_liquid_level
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_reagentcolor")
			var/newcolor = tgui_color_picker(user, "Choose custom color for liquid overlay. Cancel for normal reagent color.", "", host.vore_selected.custom_reagentcolor)
			if(newcolor)
				host.vore_selected.custom_reagentcolor = newcolor
			else
				host.vore_selected.custom_reagentcolor = null
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_reagentalpha")
			var/newalpha = tgui_input_number(user, "Set alpha transparency between 0-255. Leave blank to use capacity based alpha.", "Custom Liquid Alpha",255,255,0,0,1)
			if(newalpha != null)
				host.vore_selected.custom_reagentalpha = newalpha
			else
				host.vore_selected.custom_reagentalpha = null
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_reagent_touches")
			if(!host.vore_selected.reagent_touches)
				host.vore_selected.reagent_touches = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] will now apply reagents to creatures when digesting."))
			else
				host.vore_selected.reagent_touches = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] will no longer apply reagents to creatures when digesting."))
			. = TRUE
		if("b_mush_overlay")
			if(!host.vore_selected.mush_overlay)
				host.vore_selected.mush_overlay = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has fullness overlay enabled."))
			else
				host.vore_selected.mush_overlay = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has fullness overlay enabled."))
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_mush_color")
			var/newcolor = tgui_color_picker(user, "Choose custom color for mush overlay.", "", host.vore_selected.mush_color)
			if(newcolor)
				host.vore_selected.mush_color = newcolor
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_mush_alpha")
			var/newalpha = tgui_input_number(user, "Set alpha transparency between 0-255", "Mush Alpha",255,255)
			if(newalpha != null)
				host.vore_selected.mush_alpha = newalpha
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_max_mush")
			var/new_max_mush = tgui_input_number(user, "Choose the amount of nutrition required for full mush overlay. Ranges from 0 to 6000. Default 500.", "Set Fullness Overlay Scaling.", host.vore_selected.max_mush, 6000)
			if(new_max_mush == null)
				return FALSE
			var/new_new_max_mush = CLAMP(new_max_mush, 0, 6000)
			host.vore_selected.max_mush = new_new_max_mush
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_min_mush")
			var/new_min_mush = tgui_input_number(user, "Set custom minimum mush level. 0-100%", "Set Custom Minimum.", host.vore_selected.min_mush, 100)
			if(new_min_mush == null)
				return FALSE
			var/new_new_min_mush = CLAMP(new_min_mush, 0, 100)
			host.vore_selected.min_mush = new_new_min_mush
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_item_mush_val")
			var/new_item_mush_val = tgui_input_number(user, "Set how much solid belly contents affect mush level. 0-1000 fullness per item.", "Set Item Mush Value.", host.vore_selected.item_mush_val, 1000)
			if(new_item_mush_val == null)
				return FALSE
			var/new_new_item_mush_val = CLAMP(new_item_mush_val, 0, 1000)
			host.vore_selected.item_mush_val = new_new_item_mush_val
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_metabolism_overlay")
			if(!host.vore_selected.metabolism_overlay)
				host.vore_selected.metabolism_overlay = 1
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] now has ingested metabolism overlay enabled."))
			else
				host.vore_selected.metabolism_overlay = 0
				to_chat(user,span_warning("Your [lowertext(host.vore_selected.name)] no longer has ingested metabolism overlay enabled."))
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_metabolism_mush_ratio")
			var/new_metabolism_mush_ratio = tgui_input_number(user, "How much should ingested reagents affect fullness overlay compared to nutrition? Nutrition units per reagent unit. Default 15.", "Set Metabolism Mush Ratio.", host.vore_selected.metabolism_mush_ratio, 500)
			if(new_metabolism_mush_ratio == null)
				return FALSE
			var/new_new_metabolism_mush_ratio = CLAMP(new_metabolism_mush_ratio, 0, 500)
			host.vore_selected.metabolism_mush_ratio = new_new_metabolism_mush_ratio
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_max_ingested")
			var/new_max_ingested = tgui_input_number(user, "Choose the amount of reagents within ingested metabolism required for full mush overlay when not using mush overlay option. Ranges from 0 to 6000. Default 500.", "Set Metabolism Overlay Scaling.", host.vore_selected.max_ingested, 6000)
			if(new_max_ingested == null)
				return FALSE
			var/new_new_max_ingested = CLAMP(new_max_ingested, 0, 6000)
			host.vore_selected.max_ingested = new_new_max_ingested
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_ingested_color")
			var/newcolor = tgui_color_picker(user, "Choose custom color for ingested metabolism overlay. Cancel for reagent-based dynamic blend.", "", host.vore_selected.custom_ingested_color)
			if(newcolor)
				host.vore_selected.custom_ingested_color = newcolor
			else
				host.vore_selected.custom_ingested_color = null
			host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_custom_ingested_alpha")
			var/newalpha = tgui_input_number(user, "Set alpha transparency between 0-255 when not using mush overlay option.", "Custom Ingested Alpha",255,255)
			if(newalpha != null)
				host.vore_selected.custom_ingested_alpha = newalpha
				host.vore_selected.update_internal_overlay()
			. = TRUE
		if("b_liq_purge")
			var/alert = tgui_alert(user, "Are you sure you want to delete the liquids in your [lowertext(host.vore_selected.name)]?","Confirmation",list("Delete","Cancel"))
			if(alert != "Delete")
				return FALSE
			else
				host.vore_selected.reagents.clear_reagents()
			. = TRUE
	if(.)
		unsaved_changes = TRUE

#undef STATION_PREF_NAME
#undef VORE_BELLY_TAB
#undef SOULCATCHER_TAB
#undef PREFERENCE_TAB
