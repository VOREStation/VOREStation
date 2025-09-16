/// Changes gasmasks to their new paths.
/datum/preferences/proc/migration_19_loadout(datum/json_savefile/S)
	for(var/slot in 1 to CONFIG_GET(number/character_slots))
		var/list/prefs = S.get_entry("character[slot]", null)
		if(!islist(prefs))
			continue

		for(var/loadout_slot in prefs["gear_list"])
			to_chat(world, "loadout_slot = [loadout_slot]")
			for(var/item_to_find in prefs["gear_list"][loadout_slot])
				var/list/former_list = prefs["gear_list"][loadout_slot][item_to_find]
				var/new_item = item_to_find
				to_chat(world, "item_to_find = [item_to_find]") //returns the item we want to swap
				new_item = replacetext(new_item, "Gas Mask, Clear", "transparent gas mask")
				prefs["gear_list"][loadout_slot][item_to_find] = former_list

		for(var/loadout_slot in prefs["gear_list"]) //double check
			to_chat(world, "DB loadout_slot = [loadout_slot]")
			for(var/item_to_find in prefs["gear_list"][loadout_slot])
				to_chat(world, "DB Post replacement: [item_to_find]")


		/*
		for(var/loadout_slot in prefs["gear_list"]) //'stuff' returns what number loadout slot we are in
			for(var/item_to_find in prefs["gear_list"][loadout_slot])
				to_chat(world, "item_to_find = [item_to_find] in loadout slot [loadout_slot]")
				to_chat(world, "Pre replacement: [prefs["gear_list"][loadout_slot][item_to_find]]")*/
		/*
		prefs["gear_list"] = replacetext(prefs["gear_list"], "Gas Mask, Clear", "transparent gas mask") //Have to do this replacement before the other one.
		prefs["gear_list"] = replacetext(prefs["gear_list"], "Gas Mask", "gas mask")
		S.set_entry("character[slot]", prefs)

	S.save()*/
