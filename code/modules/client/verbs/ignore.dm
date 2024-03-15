/client/verb/ignore(key_to_ignore as text)
	set name = "Ignore"
	set category = "OOC"
	set desc = "Makes OOC and Deadchat messages from a specific player not appear to you."

	if(!key_to_ignore)
		return
	key_to_ignore = ckey(sanitize(key_to_ignore))
	if(prefs && prefs.ignored_players)
		if(key_to_ignore in prefs.ignored_players)
			to_chat(usr, "<span class='warning'>[key_to_ignore] is already being ignored.</span>")
			return
		if(key_to_ignore == usr.ckey)
			to_chat(usr, "<span class='notice'>You can't ignore yourself.</span>")
			return

		prefs.ignored_players |= key_to_ignore
		SScharacter_setup.queue_preferences_save(prefs)
		to_chat(usr, "<span class='notice'>Now ignoring <b>[key_to_ignore]</b>.</span>")

/client/verb/unignore()
	set name = "Unignore"
	set category = "OOC"
	set desc = "Reverts your ignoring of a specific player."

	if(!prefs)
		to_chat(usr, "<span class='warning'>Preferences not found.</span>")
		return

	if(!prefs.ignored_players?.len)
		to_chat(usr, "<span class='warning'>You aren't ignoring any players.</span>")
		return

	var/key_to_unignore = tgui_input_list(usr, "Ignored players", "Unignore", prefs.ignored_players)
	if(!key_to_unignore)
		return
	key_to_unignore = ckey(sanitize(key_to_unignore))
	if(!(key_to_unignore in prefs.ignored_players))
		to_chat(usr, "<span class='warning'>[key_to_unignore] isn't being ignored.</span>")
		return
	prefs.ignored_players -= key_to_unignore
	SScharacter_setup.queue_preferences_save(prefs)
	to_chat(usr, "<span class='notice'>Reverted ignore on <b>[key_to_unignore]</b>.</span>")

/mob/proc/is_key_ignored(var/key_to_check)
	if(client)
		return client.is_key_ignored(key_to_check)
	return 0

/client/proc/is_key_ignored(var/key_to_check)
	key_to_check = ckey(key_to_check)
	if(key_to_check in prefs.ignored_players)
		if(GLOB.directory[key_to_check] in GLOB.admins) // This is here so this is only evaluated if someone is actually being blocked.
			return 0
		return 1
	return 0
