// Define a place to save in character setup
/datum/preferences
	var/persistence_settings = PERSIST_DEFAULT	// Control what if anything is persisted for this character between rounds.

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/general/persistence
	name = "Persistence"
	sort_order = 10

/datum/category_item/player_setup_item/general/persistence/load_character(list/save_data)
	pref.persistence_settings = save_data["persistence_settings"]
	sanitize_character() // Don't let new characters start off with nulls

/datum/category_item/player_setup_item/general/persistence/save_character(list/save_data)
	save_data["persistence_settings"] = pref.persistence_settings

/datum/category_item/player_setup_item/general/persistence/sanitize_character()
	pref.persistence_settings		= sanitize_integer(pref.persistence_settings, 0, (1<<(PERSIST_COUNT+1)-1), initial(pref.persistence_settings))

/datum/category_item/player_setup_item/general/persistence/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["persistence_settings"] = pref.persistence_settings

	return data

/datum/category_item/player_setup_item/general/persistence/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_persist")
			var/bit = text2num(params["bit"])
			if(pref.persistence_settings & bit)
				pref.persistence_settings &= ~bit
			else
				pref.persistence_settings |= bit
			return TOPIC_REFRESH
