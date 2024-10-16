/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(datum/json_savefile/savefile)
	pref.lastchangelog			= savefile.get_entry("lastchangelog")
	pref.lastnews				= savefile.get_entry("lastnews")
	pref.lastlorenews			= savefile.get_entry("lastlorenews")
	pref.default_slot			= savefile.get_entry("default_slot")

/datum/category_item/player_setup_item/player_global/settings/save_preferences(datum/json_savefile/savefile)
	savefile.set_entry("lastchangelog",			pref.lastchangelog)
	savefile.set_entry("lastnews",				pref.lastnews)
	savefile.set_entry("lastlorenews",			pref.lastlorenews)
	savefile.set_entry("default_slot",			pref.default_slot)

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	pref.lastchangelog	= sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.lastnews		= sanitize_text(pref.lastnews, initial(pref.lastnews))
	pref.default_slot	= sanitize_integer(pref.default_slot, 1, CONFIG_GET(number/character_slots), initial(pref.default_slot))
