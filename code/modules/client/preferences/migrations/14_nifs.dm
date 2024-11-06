/// Moves nif stuff to it's own file
/datum/preferences/proc/migration_14_nifs(datum/json_savefile/S)
	var/datum/json_savefile/new_savefile = new /datum/json_savefile(nif_savefile_path(client_ckey))

	for(var/slot in 1 to CONFIG_GET(number/character_slots))
		var/list/prefs = S.get_entry("character[slot]", null)
		if(!islist(prefs))
			continue

		var/list/new_data = list()
		new_data["nif_path"] = prefs["nif_path"]
		new_data["nif_durability"] = prefs["nif_durability"]
		new_data["nif_savedata"] = prefs["nif_savedata"]

		new_savefile.set_entry("character[slot]", new_data)

	new_savefile.save()
