var/list/whitelists = list()
var/list/whitelistable = list(
	SPECIES_DIONA,
	SPECIES_PROMETHEAN,
	SPECIES_SKRELL,
	SPECIES_TAJ,
	SPECIES_TESHARI,
	SPECIES_UNATHI,
	SPECIES_VOX,
	SPECIES_ZADDAT,
	LANGUAGE_AKHANI,
	LANGUAGE_ALAI,
	LANGUAGE_SCHECHI,
	LANGUAGE_SIIK,
	LANGUAGE_SKRELLIAN,
	LANGUAGE_SKRELLIANFAR,
	LANGUAGE_SOL_COMMON,
	LANGUAGE_UNATHI,
	LANGUAGE_ZADDAT,
	"Genemods",
)


// Prints the client's whitelist entries
/client/verb/print_whitelist()
	set name = "Show Whitelist Entries"
	set desc = "Print the set of things you're whitelisted for."
	set category = "OOC"

	to_chat(src, "You are whitelisted for:")
	to_chat(src, jointext(get_whitelists_list(), "\n"))


/client/proc/get_whitelists_list()
	return (ckey in global.whitelists) ? global.whitelists[ckey] : list()


/proc/load_whitelist(var/key)
	var/filename = "config/whitelists.json"
	try
		if(fexists(filename))
			global.whitelists = json_decode(file2text(filename) || "")

	catch(var/exception/E)
		error("Exception when loading whitelist file [filename]: [E]")


// Returns true if the specified path is in the player's whitelists, false otw.
/client/proc/is_whitelisted(var/w_key)
	if(istype(w_key, /datum))
		var/datum/D = w_key
		w_key = D:name
	if(!istext(w_key))
		return FALSE // Not set.
	return key in global.whitelists[ckey]


/proc/is_alien_whitelisted(mob/M, datum/species/species)
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
	return C.is_whitelisted(species.name)


/proc/is_lang_whitelisted(mob/M, datum/language/language)
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

	return C.is_whitelisted(language)


/proc/whitelist_overrides(mob/M)
	return !config.usealienwhitelist || check_rights(R_ADMIN|R_EVENT, 0, M)
