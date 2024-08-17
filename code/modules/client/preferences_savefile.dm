#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	13

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd == "/" is preferences, S.cd == "/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/
/datum/preferences/proc/save_data_needs_update(list/save_data)
	if(!save_data) // empty list, either savefile isnt loaded or its a new char
		return -1
	if(!save_data["version"]) // special case: if there is no version key, such as in character slots before v12
		return -3
	if(save_data["version"] < SAVEFILE_VERSION_MIN)
		return -2
	if(save_data["version"] < SAVEFILE_VERSION_MAX)
		return save_data["version"]
	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, datum/json_savefile/S)
	// Migration from BYOND savefiles to JSON: Important milemark.
	// if(current_version < 11)

	// Migration for client preferences
	if(current_version < 13)
		migration_13_preferences(S)


/datum/preferences/proc/update_character(current_version, list/save_data)
	// Migration from BYOND savefiles to JSON: Important milemark.
	if(current_version == -3)
		// Add a version field inside each character
		save_data["version"] = SAVEFILE_VERSION_MAX

/// Migrates from byond savefile to json savefile
/datum/preferences/proc/try_savefile_type_migration()
	load_path(client.ckey, "preferences.sav") // old save file
	var/old_path = path
	load_path(client.ckey)
	if(!fexists(old_path))
		return
	var/datum/json_savefile/json_savefile = new(path)
	json_savefile.import_byond_savefile(new /savefile(old_path))
	json_savefile.save()
	return TRUE

/datum/preferences/proc/load_path(ckey, filename = "preferences.json")
	if(!ckey || !load_and_save)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/datum/preferences/proc/load_savefile()
	if(load_and_save && !path)
		CRASH("Attempted to load savefile without first loading a path!")
	savefile = new /datum/json_savefile(load_and_save ? path : null)

/datum/preferences/proc/load_preferences()
	if(!savefile)
		stack_trace("Attempted to load the preferences of [client] without a savefile; did you forget to call load_savefile?")
		load_savefile()
		if(!savefile)
			stack_trace("Failed to load the savefile for [client] after manually calling load_savefile; something is very wrong.")
			return FALSE

	var/needs_update = save_data_needs_update(savefile.get_entry())
	if(load_and_save && (needs_update <= -2)) //fatal, can't load any data
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if(fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(savefile.path, bacpath) //byond helpfully lets you use a savefile for the first arg.
		return FALSE

	apply_all_client_preferences()

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if(fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(savefile.path, bacpath) //byond helpfully lets you use a savefile for the first arg.
		update_preferences(needs_update, savefile) //needs_update = savefile_version if we need an update (positive integer)

		// Load general prefs after applying migrations
		player_setup.load_preferences(savefile)

		//save the updated version
		var/old_default_slot = default_slot
		// var/old_max_save_slots = max_save_slots

		for(var/slot in savefile.get_entry()) //but first, update all current character slots.
			if (copytext(slot, 1, 10) != "character")
				continue
			var/slotnum = text2num(copytext(slot, 10))
			if (!slotnum)
				continue
			// max_save_slots = max(max_save_slots, slotnum) //so we can still update byond member slots after they lose memeber status
			default_slot = slotnum
			if(load_character())
				save_character()
		default_slot = old_default_slot
		// max_save_slots = old_max_save_slots
		save_preferences()
	else
		// Load general prefs
		player_setup.load_preferences(savefile)

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!savefile)
		CRASH("Attempted to save the preferences of [client] without a savefile. This should have been handled by load_preferences()")
	savefile.set_entry("version", SAVEFILE_VERSION_MAX) //updates (or failing that the sanity checks) will ensure data is not invalid at load. Assume up-to-date

	player_setup.save_preferences(savefile)

	for(var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		if(preference.savefile_identifier != PREFERENCE_PLAYER)
			continue

		if(!(preference.type in recently_updated_keys))
			continue

		recently_updated_keys -= preference.type

		if(preference_type in value_cache)
			write_preference(preference, preference.pref_serialize(value_cache[preference_type]))

	savefile.save()

	return TRUE

/datum/preferences/proc/reset_slot()
	var/bacpath = "[path].resetbac"
	if(fexists(bacpath))
		fdel(bacpath) //only keep 1 version of backup
	fcopy(savefile.path, bacpath) //byond helpfully lets you use a savefile for the first arg.

	savefile.remove_entry("character[default_slot]")
	default_slot = 1

	clear_character_previews()

	// Load slot 1 character
	load_character()
	// And save them immediately, in case we load an empty slot
	save_character()
	save_preferences()
	return TRUE

/datum/preferences/proc/load_character(slot)
	SHOULD_NOT_SLEEP(TRUE)
	if(!slot)
		slot = default_slot

	slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		savefile.set_entry("default_slot", slot)

	var/list/save_data = savefile.get_entry("character[slot]") // This is allowed to be null and will give a -1 in needs_update

	var/needs_update = save_data_needs_update(save_data)
	if(needs_update == -2) //fatal, can't load any data
		return FALSE

	// Read everything into cache (pre-migrations, as migrations should have access to deserialized data)
	// Uses priority order as some values may rely on others for creating default values
	for(var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if(preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue

		value_cache -= preference.type
		read_preference(preference.type)

	// It has to be a list or load_character freaks out
	if(!save_data)
		player_setup.load_character(list())
	else
		player_setup.load_character(save_data)

	//try to fix any outdated data if necessary
	//preference updating will handle saving the updated data for us.
	if(needs_update >= 0 || needs_update == -3)
		update_character(needs_update, save_data) //needs_update == savefile_version if we need an update (positive integer

	clear_character_previews()
	return TRUE

/datum/preferences/proc/save_character()
	SHOULD_NOT_SLEEP(TRUE)
	if(!savefile)
		return FALSE

	var/tree_key = "character[default_slot]"
	if(!(tree_key in savefile.get_entry()))
		savefile.set_entry(tree_key, list())
	var/save_data = savefile.get_entry(tree_key)

	save_data["version"] = SAVEFILE_VERSION_MAX //load_character will sanitize any bad data, so assume up-to-date.
	player_setup.save_character(save_data)

	return TRUE

/datum/preferences/proc/overwrite_character(slot)
	if(!savefile)
		return FALSE
	if(!slot)
		slot = default_slot

	// This basically just changes default_slot without loading the correct data, so the next save call will overwrite
	// the slot
	slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		nif_path = nif_durability = nif_savedata = null //VOREStation Add - Don't copy NIF
		savefile.set_entry("default_slot", slot)

	return TRUE

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return TRUE

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
