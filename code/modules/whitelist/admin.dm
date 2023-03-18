// Rewrites the whitelists to disk
/proc/write_whitelist()
	var/filename = "config/whitelists.json"
	log_admin("Writing whitelists to disk at `[filename]`")
	try
		// Byond doesn't have a mechanism for in-place modification of a file, so we have to make a new one and then overwrite the old one.
		// If this is interrupted, the .tmp file exists and can be loaded at the start of the next round.
		// The in-game list represents the set of valid entries within the whitelist file, so we may as well remove invalid lines in the process.
		text2file(json_encode(global.whitelists), filename + ".tmp")
		if(fexists(filename) && !fdel(filename))
			error("Exception when overwriting whitelist file [filename]")
		if(fcopy(filename + ".tmp", filename))
			if(!fdel(filename + ".tmp"))
				error("Exception when deleting tmp whitelist file [filename].tmp")
	catch(var/exception/E)
		error("Exception when writing to whitelist file [filename]: [E]")


// Add the selected path to the player's whitelists, if it's valid.
/client/proc/add_whitelist(var/w_key)
	if(istype(w_key, /datum))
		var/datum/D = w_key
		w_key = D:name
	if(!istext(w_key))
		return FALSE // Not set.
	// If they're already whitelisted, do nothing (Also loads the whitelist)
	if(is_whitelisted(w_key))
		return

	log_and_message_admins("[usr ? usr : "SYSTEM"] gave [w_key] whitelist to [src]", usr)
	if(!islist(global.whitelists[ckey(ckey)]))
		global.whitelists[ckey(ckey)] = list()
	global.whitelists[ckey(ckey)] += w_key
	write_whitelist()

// Remove the selected path from the player's whitelists.
/client/proc/remove_whitelist(var/w_key)
	if(istype(w_key, /datum))
		var/datum/D = w_key
		w_key = D:name
	if(!istext(w_key))
		return FALSE // Not set.
	// If they're not whitelisted, do nothing (Also loads the whitelist)
	if(!is_whitelisted(w_key))
		return

	log_and_message_admins("[usr ? usr : "SYSTEM"] removed [w_key] whitelist from [src]", usr)
	global.whitelists[ckey] -= w_key
	write_whitelist()


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


/client/proc/admin_modify_whitelist(var/set_value, var/key = null)
	if(!check_rights(R_ADMIN|R_DEBUG))
		return

	// Get the person to whitelist.
	if(!key)
		key = input(src, "Please enter the CKEY of the player whose whitelist you wish to modify:", "Whitelist ckey", "") as text|null
	if(!key || !length(key))
		return

	key = ckey(key)

	// Get the whitelist thing to modify.
	var/entry = input(src, "Please enter the name of the whitelist you wish to modify:", "Whitelist target", "") as null|anything in global.whitelistable
	if(!entry)
		return

	if(set_value)
		if(!islist(global.whitelists[key]))
			global.whitelists[key] = list()
		else
			to_world("is a list: [global.whitelists[ckey(ckey)]]")
		if(entry in global.whitelists[key])
			to_chat(src, SPAN_NOTICE("[key] is already whitelisted for [entry]!"))
			return
		global.whitelists[key] += entry
	else
		if(!islist(global.whitelists[key]))
			to_chat(src, SPAN_NOTICE("[key] isn't whitelisted for anything!"))
			return
		global.whitelists[key] -= entry

	log_and_message_admins("[src] [set_value ? "gave [entry] whitelist to" : "removed [entry] whitelist from"] [key]", src)

	write_whitelist()


/client/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_ADD_WHITELIST, "Add whitelist")
	VV_DROPDOWN_OPTION(VV_HK_DEL_WHITELIST, "Remove whitelist")


/client/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION(VV_HK_ADD_WHITELIST)
		if(!check_rights(R_ADMIN|R_DEBUG))
			return
		var/client/C = locate(href_list["target"])
		if(istype(C))
			usr.client.admin_modify_whitelist(TRUE, ckey(C.ckey))

	IF_VV_OPTION(VV_HK_DEL_WHITELIST)
		if(!check_rights(R_ADMIN|R_DEBUG))
			return
		var/client/C = locate(href_list["target"])
		if(istype(C))
			usr.client.admin_modify_whitelist(FALSE, ckey(C.ckey))
