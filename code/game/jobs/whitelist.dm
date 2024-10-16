#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(CONFIG_GET(flag/usewhitelist))
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return 0
	return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(CONFIG_GET(flag/usealienwhitelist))
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		var/lines = splittext(text, "\n") // Now we've got a bunch of "ckey = something" strings in a list
		for(var/line in lines)
			var/list/left_and_right = splittext(line, " - ") // Split it on the dash into left and right
			if(LAZYLEN(left_and_right) != 2)
				warning("Alien whitelist entry is invalid: [line]") // If we didn't end up with a left and right, the line is bad
				continue
			var/key = left_and_right[1]
			if(key != ckey(key))
				warning("Alien whitelist entry appears to have key, not ckey: [line]") // The key contains invalid ckey characters
				continue
			var/list/our_whitelists = alien_whitelist[key] // Try to see if we have one already and add to it
			if(!our_whitelists) // Guess this is their first/only whitelist entry
				our_whitelists = list()
				alien_whitelist[key] = our_whitelists
			our_whitelists += left_and_right[2]

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

	//Search the whitelist
	var/list/our_whitelists = alien_whitelist[M.ckey]
	if("All" in our_whitelists)
		return TRUE
	if(species.name in our_whitelists)
		return TRUE

	// Go apply!
	return FALSE

/proc/is_lang_whitelisted(mob/M, var/datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !language)
		return FALSE

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return TRUE

	//Search the whitelist
	var/list/our_whitelists = alien_whitelist[M.ckey]
	if("All" in our_whitelists)
		return TRUE
	if(language.name in our_whitelists)
		return TRUE

	return FALSE

/proc/is_borg_whitelisted(mob/M, var/module)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return 1

	//You did something wrong
	if(!M || !module)
		return 0

	//Module is not even whitelisted
	if(!(module in whitelisted_module_types))
		return 1

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [module]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

/proc/whitelist_overrides(mob/M)
	if(!CONFIG_GET(flag/usealienwhitelist))
		return TRUE
	if(check_rights(R_ADMIN|R_EVENT, 0, M))
		return TRUE

	return FALSE

#undef WHITELISTFILE
