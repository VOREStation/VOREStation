/client/var/list/whitelists = null


// Prints the client's whitelist entries
/client/verb/print_whitelist()
	set name = "Show Whitelist Entries"
	set desc = "Print the set of things you're whitelisted for."
	set category = "OOC.Client settings"

	to_chat(src, "You are whitelisted for:")
	to_chat(src, jointext(get_whitelists_list(), "\n"))

/client/proc/get_whitelists_list()
	. = list()
	if(src.whitelists == null)
		src.whitelists = load_whitelist(src.ckey)
	for(var/key in src.whitelists)
		try
			. += initial(initial(key:name))
		catch()
			. += key


/proc/load_whitelist(var/key)
	var/filename = "data/player_saves/[copytext(ckey(key),1,2)]/[ckey(key)]/whitelist.json"
	try
		// Check the player-specific whitelist file, if it exists.
		if(fexists(filename))
			// Load the whitelist entries from file, or empty string if empty.`
			. = list()
			for(var/T in json_decode(file2text(filename) || ""))
				T = text2path(T)
				if(!ispath(T))
					continue
				.[T] = TRUE

		// Something was removing an entry from the whitelist and interrupted mid-overwrite.
		else if(fexists(filename + ".tmp") && fcopy(filename + ".tmp", filename))
			. = load_whitelist(key)
			if(!fdel(filename + ".tmp"))
				error("Exception when deleting tmp whitelist file [filename].tmp")

		// Whitelist file doesn't exist, so they aren't whitelisted for anything. Create the file.
		else if(fexists("data/player_saves/[copytext(ckey(key),1,2)]/[ckey(key)]/preferences.sav"))
			text2file("", filename)
			. = list()

	catch(var/exception/E)
		error("Exception when loading whitelist file [filename]: [E]")


// Returns true if the specified path is in the player's whitelists, false otw.
/client/proc/is_whitelisted(var/path)
	if(istext(path))
		path = text2path(path)
	if(!ispath(path))
		return
	// If it hasn't already been loaded, load it.
	if(src.whitelists == null)
		src.whitelists = load_whitelist(src.ckey)
	return src.whitelists[path]


/proc/is_alien_whitelisted(mob/M, var/datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !species)
		return FALSE

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return TRUE

	var/client/C = (!isclient(M)) ? M.client : M
	return C.is_whitelisted(species.type)


/proc/is_lang_whitelisted(mob/M, var/datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	var/client/C = (!isclient(M)) ? M.client : M

	//You did something wrong
	if(!istype(C) || !istype(language))
		return FALSE

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return TRUE

	return C.is_whitelisted(language.type)


/proc/whitelist_overrides(mob/M)
	return !config.usealienwhitelist || check_rights(R_ADMIN|R_EVENT, 0, M)
