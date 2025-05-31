//
// Vore management panel for players
//

#define STATION_PREF_NAME "Virgo"
#define VORE_BELLY_TAB 0
#define SOULCATCHER_TAB 1
#define GENERAL_TAB 2
#define PREFERENCE_TAB 3

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
	var/sc_message_subtab // our soulcatcher message subtab
	var/aset_message_subtab
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
	data["persist_edit_mode"] = host.persistend_edit_mode

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
	data["general_pref_data"] = null

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
		// Content Data
		data["show_pictures"] = show_pictures
		data["icon_overflow"] = icon_overflow

	if(active_tab == GENERAL_TAB)
		data["general_pref_data"] = get_general_data(host)
		data["our_bellies"] = get_vorebellies(host, FALSE)

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

		if("change_sc_message_option")
			var/new_tab = params["tab"]
			if(istext(new_tab))
				sc_message_subtab = new_tab
			return TRUE

		if("change_aset_message_option")
			var/new_tab = params["tab"]
			if(istext(new_tab))
				aset_message_subtab = new_tab
			return TRUE

		if("show_pictures")
			show_pictures = !show_pictures
			return TRUE

		if("toggle_editmode_persistence")
			host.persistend_edit_mode = !host.persistend_edit_mode
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
		if(TASTE_FLAVOR)
			host.vore_taste = sanitize(params["val"], FLAVOR_MAX, FALSE, TRUE, FALSE)
			unsaved_changes = TRUE
			return TRUE
		if(SMELL_FLAVOR)
			host.vore_smell = sanitize(params["val"], FLAVOR_MAX, FALSE, TRUE, FALSE)
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
			var/belly_choice = params["attribute"]
			if(!(belly_choice in host.vore_icon_bellies))
				return FALSE
			var/newcolor = tgui_color_picker(ui.user, "Choose a color.", "", host.vore_sprite_color[belly_choice])
			if(!newcolor)
				return FALSE
			host.vore_sprite_color[belly_choice] = newcolor
			host.update_icons_body()
			unsaved_changes = TRUE
			return TRUE
		if("toggle_vs_multiply")
			var/belly_choice = params["attribute"]
			if(!(belly_choice in host.vore_icon_bellies))
				return FALSE
			if(!host.vore_sprite_multiply[belly_choice])
				host.vore_sprite_multiply[belly_choice] = TRUE
			else
				host.vore_sprite_multiply[belly_choice] = !host.vore_sprite_multiply[belly_choice]
			host.update_icons_body()
			unsaved_changes = TRUE
			return TRUE
		//vore sprites color
		if("set_belly_rub")
			var/rub_target = params["val"]
			if(rub_target == "Current Selected")
				host.belly_rub_target = null
			else
				host.belly_rub_target = rub_target
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
			var/obj/belly = locate(params["val"])
			if(!istype(belly))
				host.soulgem.update_linked_belly(null)
				return TRUE
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
			var/new_name = params["val"]
			if(!host.soulgem.rename(new_name))
				return FALSE
			unsaved_changes = TRUE
			return TRUE
		if(SC_INTERIOR_MESSAGE)
			var/new_flavor = params["val"]
			if(new_flavor)
				unsaved_changes = TRUE
				host.soulgem.adjust_interior(new_flavor)
			return TRUE
		if(SC_CAPTURE_MEESAGE)
			var/message = params["val"]
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, SC_CAPTURE_MEESAGE)
			return TRUE
		if(SC_TRANSIT_MESSAGE)
			var/message = params["val"]
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, SC_TRANSIT_MESSAGE)
			return TRUE
		if(SC_RELEASE_MESSAGE)
			var/message = params["val"]
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, SC_RELEASE_MESSAGE)
			return TRUE
		if(SC_TRANSFERE_MESSAGE)
			var/message = params["val"]
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, SC_TRANSFERE_MESSAGE)
			return TRUE
		if(SC_DELETE_MESSAGE)
			var/message = params["val"]
			if(message)
				unsaved_changes = TRUE
				host.soulgem.set_custom_message(message, SC_DELETE_MESSAGE)
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
		return FALSE

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
		intent = params["intent"]
		switch(intent)
			if("eject_all")
				if(host.stat)
					to_chat(user,span_warning("You can't do that in your state!"))
					return TRUE

				host.vore_selected.release_all_contents()
				return TRUE

			if("move_all")
				if(host.stat)
					to_chat(user,span_warning("You can't do that in your state!"))
					return TRUE

				var/obj/belly/choice = locate(params["val"])
				if(!choice)
					return FALSE

				for(var/atom/movable/target in host.vore_selected)
					to_chat(target,span_vwarning("You're squished from [host]'s [lowertext(host.vore_selected)] to their [lowertext(choice.name)]!"))
					// Send the transfer message to indirect targets as well. Slightly different message because why not.
					to_chat(host.vore_selected.get_belly_surrounding(target.contents),span_warning("You're squished along with [target] from [host]'s [lowertext(host.vore_selected)] to their [lowertext(choice.name)]!"))
					host.vore_selected.transfer_contents(target, choice, 1)
				return TRUE
		return FALSE

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
				return FALSE

			if(!H.allow_spontaneous_tf)
				return FALSE

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
				return FALSE

			var/ourchoice = tgui_input_list(user, "How would you prefer to process \the [target]? This will perform the given action instantly if the prey accepts.","Instant Process", process_options)
			if(!ourchoice)
				return FALSE
			if(!ourtarget.client)
				to_chat(user, span_vwarning("You cannot instantly process [ourtarget]."))
				return FALSE
			var/obj/belly/b = ourtarget.loc
			switch(ourchoice)
				if("Digest")
					if(ourtarget.absorbed)
						to_chat(user, span_vwarning("\The [ourtarget] is absorbed, and cannot presently be digested."))
						return FALSE
					if(tgui_alert(ourtarget, "\The [user] is attempting to instantly digest you. Is this something you are okay with happening to you?","Instant Digest", list("No", "Yes")) != "Yes")
						to_chat(user, span_vwarning("\The [ourtarget] declined your digest attempt."))
						to_chat(ourtarget, span_vwarning("You declined the digest attempt."))
						return FALSE
					if(ourtarget.loc != b)
						to_chat(user, span_vwarning("\The [ourtarget] is no longer in \the [b]."))
						return FALSE
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
						return FALSE
					if(ourtarget.loc != b)
						to_chat(user, span_vwarning("\The [ourtarget] is no longer in \the [b]."))
						return FALSE
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
						return FALSE
					if(ourtarget.loc != b)
						to_chat(user, span_vwarning("\The [ourtarget] is no longer in \the [b]."))
						return FALSE
					ourtarget.AdjustSleeping(500000)
					to_chat(ourtarget, span_vwarning("\The [user] has put you to sleep, you will remain unconscious until ejected from the belly."))
				if("Cancel")
					return FALSE
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
			return FALSE

/datum/vore_look/proc/sanitize_fixed_list(var/list/messages, type, delim = "\n\n", limit)
	if(!limit)
		CRASH("[type] set message called without limit!")
	VPPREF_MESSAGE_SANITY(type)

	if(!islist(messages) || LAZYLEN(messages) != 10)
		CRASH("[type] set message lists with invalid length!")

	for(var/i = 1, i <= messages.len, i++)
		messages[i] = sanitize(messages[i], limit, FALSE, TRUE, FALSE)

	switch(type)
		if(GENERAL_EXAMINE_NUTRI)
			host.nutrition_messages = messages
		if(GENERAL_EXAMINE_WEIGHT)
			host.weight_messages = messages

#undef STATION_PREF_NAME
#undef VORE_BELLY_TAB
#undef SOULCATCHER_TAB
#undef PREFERENCE_TAB
#undef GENERAL_TAB
