/// Moves nif stuff to it's own file
/datum/preferences/proc/migration_15_nif_path(datum/json_savefile/S)
	var/datum/json_savefile/new_savefile = new /datum/json_savefile(nif_savefile_path(client_ckey))

	for(var/slot in 1 to config.character_slots)
		var/list/prefs = new_savefile.get_entry("character[slot]", null)
		if(!islist(prefs))
			continue
		prefs["nif_path"] = replacetext(prefs["nif_path"], "/device", "")
		new_savefile.set_entry("character[slot]", prefs)

	new_savefile.save()
