/datum/preference_middleware/bay_adapter
	key = "legacy"

/datum/preference_middleware/bay_adapter/get_ui_data(mob/user)
	var/list/data = ..()

	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return data

	var/list/legacy = list()
	if(preferences.player_setup.selected_category)
		for(var/datum/category_item/player_setup_item/item as anything in preferences.player_setup.selected_category.items)
			legacy += item.tgui_data(user)
	data["selected_category"] = list(
		"name" = preferences.player_setup.selected_category.name,
		"items" = legacy,
	)

	data["preview_loadout"] = preferences.equip_preview_mob & EQUIP_PREVIEW_LOADOUT
	data["preview_job_gear"] = preferences.equip_preview_mob & EQUIP_PREVIEW_JOB
	data["preview_animations"] = preferences.animations_toggle

	return data

/datum/preference_middleware/bay_adapter/get_ui_static_data(mob/user)
	var/list/data = ..()

	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return data

	var/list/categories_data = list()
	for(var/datum/category_group/player_setup_category/category as anything in preferences.player_setup.categories)
		UNTYPED_LIST_ADD(categories_data, category.name)
	data["categories"] = categories_data

	var/list/legacy = list()
	if(preferences.player_setup.selected_category)
		var/list/items = preferences.player_setup.selected_category.items
		for(var/datum/category_item/player_setup_item/item as anything in items)
			legacy += item.tgui_static_data(user)
	data["selected_category_static"] = legacy

	return data

/datum/preference_middleware/bay_adapter/get_constant_data()
	var/list/data = list()

	var/datum/category_collection/player_setup_collection/collection = new()

	var/list/categories = collection.categories
	for(var/datum/category_group/player_setup_category/category as anything in categories)
		for(var/datum/category_item/player_setup_item/item as anything in category.items)
			data += item.tgui_constant_data()

	return data

/datum/category_item/player_setup_item/proc/tgui_constant_data()
	return list()


/datum/preference_middleware/bay_adapter/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("cycle_background")
			preferences.bgstate = next_in_list(preferences.bgstate, preferences.bgstate_options)
			preferences.update_preview_icon()
			return TRUE
		if("toggle_preview_loadout")
			preferences.equip_preview_mob ^= EQUIP_PREVIEW_LOADOUT
			preferences.update_preview_icon()
			return TRUE
		if("toggle_preview_job_gear")
			preferences.equip_preview_mob ^= EQUIP_PREVIEW_JOB
			preferences.update_preview_icon()
			return TRUE
		if("toggle_preview_animations")
			preferences.animations_toggle = !preferences.animations_toggle
			preferences.update_preview_icon()
			return TRUE

	for(var/datum/category_group/player_setup_category/category as anything in preferences.player_setup.categories)
		for(var/datum/category_item/player_setup_item/item as anything in category.items)
			. = item.tgui_act(action, params, ui, state)
			if(.)
				if(. & TOPIC_UPDATE_PREVIEW)
					preferences.update_preview_icon()
				return
