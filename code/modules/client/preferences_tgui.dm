/datum/preferences/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PreferencesMenu", "Preferences")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/preferences/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/preferences/tgui_status(mob/user, datum/tgui_state/state)
	return user.client == client ? STATUS_INTERACTIVE : STATUS_CLOSE

/datum/preferences/ui_assets(mob/user)
	var/list/assets = list(
		// get_asset_datum(/datum/asset/spritesheet/preferences),
		get_asset_datum(/datum/asset/json/preferences),
	)

	for (var/datum/preference_middleware/preference_middleware as anything in middleware)
		assets += preference_middleware.get_ui_assets()

	return assets

/datum/preferences/tgui_data(mob/user)
	var/list/data = list()

	if(tainted_character_profiles)
		data["character_profiles"] = create_character_profiles()
		tainted_character_profiles = FALSE

	data["character_preferences"] = compile_character_preferences(user)

	data["active_slot"] = default_slot

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		data += preference_middleware.get_ui_data(user)

	return data

/datum/preferences/tgui_static_data(mob/user)
	var/list/data = list()

	data["character_profiles"] = create_character_profiles()

	// data["character_preview_view"] = character_preview_view.assigned_map
	// data["overflow_role"] = SSjob.GetJobType(SSjob.overflow_role).title
	data["window"] = current_window

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		data += preference_middleware.get_ui_static_data(user)

	return data

/datum/preferences/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_preference")
			var/requested_preference_key = params["preference"]
			var/value = params["value"]

			for(var/datum/preference_middleware/preference_middleware as anything in middleware)
				if(preference_middleware.pre_set_preference(ui.user, requested_preference_key, value))
					return TRUE

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if(isnull(requested_preference))
				return FALSE

			// SAFETY: `update_preference` performs validation checks
			if(!update_preference(requested_preference, value))
				return FALSE

			// if(istype(requested_preference, /datum/preference/name)) // TODO: do this
			// 	tainted_character_profiles = TRUE

			return TRUE

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		var/delegation = preference_middleware.action_delegations[action]
		if(!isnull(delegation))
			return call(preference_middleware, delegation)(params, ui.user)

	return FALSE

/datum/preferences/tgui_close(mob/user)
	save_character()
	save_preferences()

/datum/preferences/proc/create_character_profiles()
	var/list/profiles = list()

	for(var/index in 1 to CONFIG_GET(number/character_slots))
		// TODO: It won't be updated in the savefile yet, so just read the name directly
		// if(index == default_slot)
		// 	profiles += read_preference(/datum/preference/name/real_name)
		// 	continue

		var/tree_key = "character[index]"
		var/save_data = savefile.get_entry(tree_key)
		var/name = save_data?["real_name"]

		if(isnull(name))
			profiles += null
			continue

		profiles += name

	return profiles

/datum/preferences/proc/compile_character_preferences(mob/user)
	var/list/preferences = list()

	for(var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if(!preference.is_accessible(src))
			continue

		var/value = read_preference(preference.type)
		var/data = preference.compile_ui_data(user, value)

		LAZYINITLIST(preferences[preference.category])
		preferences[preference.category][preference.savefile_key] = data

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		var/list/append_character_preferences = preference_middleware.get_character_preferences(user)
		if(isnull(append_character_preferences))
			continue

		for(var/category in append_character_preferences)
			if(category in preferences)
				preferences[category] += append_character_preferences[category]
			else
				preferences[category] = append_character_preferences[category]

	return preferences
