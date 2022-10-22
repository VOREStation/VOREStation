// Rewrites the client's whitelists to disk
/proc/write_whitelist(var/key, var/list/whitelist)
	var/filename = "data/player_saves/[copytext(ckey(key),1,2)]/[ckey(key)]/whitelist.json"
	log_admin("Writing whitelists to disk for [key] at `[filename]`")
	try
		// Byond doesn't have a mechanism for in-place modification of a file, so we have to make a new one and then overwrite the old one.
		// If this is interrupted, the .tmp file exists and can be loaded at the start of the next round.
		// The in-game list represents the set of valid entries within the whitelist file, so we may as well remove invalid lines in the process.
		text2file(json_encode(whitelist), filename + ".tmp")
		if(fexists(filename) && !fdel(filename))
			error("Exception when overwriting whitelist file [filename]")
		if(fcopy(filename + ".tmp", filename))
			if(!fdel(filename + ".tmp"))
				error("Exception when deleting tmp whitelist file [filename].tmp")
	catch(var/exception/E)
		error("Exception when writing to whitelist file [filename]: [E]")


// Add the selected path to the player's whitelists, if it's valid.
/client/proc/add_whitelist(var/path)
	if(istext(path))
		path = text2path(path)
	if(!ispath(path))
		return
	// If they're already whitelisted, do nothing (Also loads the whitelist)
	if(is_whitelisted(path))
		return

	log_and_message_admins("[usr ? usr : "SYSTEM"] giving [path] whitelist to [src]", usr)
	src.whitelists[path] = TRUE
	write_whitelist(src.ckey, src.whitelists)

// Remove the selected path from the player's whitelists.
/client/proc/remove_whitelist(var/path)
	if(istext(path))
		path = text2path(path)
	if(!ispath(path))
		return
	// If they're not whitelisted, do nothing (Also loads the whitelist)
	if(!is_whitelisted(path))
		return

	log_and_message_admins("[usr ? usr : "SYSTEM"] removing [path] whitelist from [src]", usr)
	src.whitelists -= path
	write_whitelist(src.ckey, src.whitelists)


/client/proc/admin_add_whitelist()
	set name = "Whitelist Add Player"
	set category = "Admin"
	set desc = "Give a whitelist to a target player"
	admin_modify_whitelist(TRUE)


/client/proc/admin_del_whitelist()
	set name = "Whitelist Remove Player"
	set category = "Admin"
	set desc = "Remove a whitelist from the target player"
	admin_modify_whitelist(FALSE)


/client/proc/admin_modify_whitelist(var/set_value)
	if(!check_rights(R_ADMIN|R_DEBUG))
		return

	// Get the person to whitelist.
	var/key = input(src, "Please enter the CKEY of the player whose whitelist you wish to modify:", "Whitelist ckey", "") as text|null
	if(!key || !length(key))
		return

	key = ckey(key)
	if(!fexists("data/player_saves/[copytext(key,1,2)]/[key]/preferences.sav"))
		to_chat(src, "That player doesn't seem to exist...")
		return

	// Get the whitelist thing to modify.
	var/entry = input(src, "Please enter the path of the whitelist you wish to modify:", "Whitelist target", "") as text|null
	if(!entry || !ispath(text2path(entry)))
		return

	// If they're logged in, modify it directly.
	var/client/C = ckey2client(key)
	if(istype(C))
		set_value ? C.add_whitelist(entry) : C.remove_whitelist(entry)
		return

	log_and_message_admins("[src] [set_value ? "giving [entry] whitelist to" : "removing [entry] whitelist from"] [key]", src)

	// Else, we have to find and modify the whitelist file ourselves.
	var/list/whitelists = load_whitelist(key)

	// They're already whitelisted.
	if(whitelists[entry] == set_value)
		return

	whitelists[entry] = set_value
	write_whitelist(key, whitelists)


/client/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_ADD_WHITELIST, "Add whitelist")
	VV_DROPDOWN_OPTION(VV_HK_DEL_WHITELIST, "Remove whitelist")


/client/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION(VV_HK_ADD_WHITELIST)
		if(!check_rights(R_ADMIN|R_DEBUG))
			return
		var/entry = input(usr, "Please enter the path of the whitelist you wish to add:", "Whitelist target", "") as text|null
		if(!entry || !ispath(text2path(entry)))
			return
		var/client/C = locate(href_list["target"])
		if(istype(C))
			C.add_whitelist(entry)
	IF_VV_OPTION(VV_HK_DEL_WHITELIST)
		if(!check_rights(R_ADMIN|R_DEBUG))
			return
		var/entry = input(usr, "Please enter the path of the whitelist you wish to remove:", "Whitelist target", "") as text|null
		if(!entry || !ispath(text2path(entry)))
			return
		var/client/C = locate(href_list["target"])
		if(istype(C))
			C.remove_whitelist(entry)
