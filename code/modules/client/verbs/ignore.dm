/client/verb/ignore(key_to_ignore as text)
	set name = "Ignore"
	set category = "OOC.Chat Settings"
	set desc = "Makes OOC and Deadchat messages from a specific player not appear to you."

	if(!key_to_ignore)
		return
	key_to_ignore = ckey(sanitize(key_to_ignore))

	var/list/ignored_players = prefs?.read_preference(/datum/preference/ignored_players)
	if(!ignored_players)
		return
	if(key_to_ignore in ignored_players)
		to_chat(usr, span_warning("[key_to_ignore] is already being ignored."))
		return
	if(key_to_ignore == usr.ckey)
		to_chat(usr, span_notice("You can't ignore yourself."))
		return

	ignored_players |= key_to_ignore
	prefs.write_preference_by_type(/datum/preference/ignored_players, ignored_players)
	to_chat(usr, span_notice("Now ignoring <b>[key_to_ignore]</b>."))

/client/verb/unignore()
	set name = "Unignore"
	set category = "OOC.Chat Settings"
	set desc = "Reverts your ignoring of a specific player."

	var/list/ignored_players = prefs?.read_preference(/datum/preference/ignored_players)
	if(!LAZYLEN(ignored_players))
		to_chat(usr, span_warning("You aren't ignoring any players."))
		return

	var/key_to_unignore = tgui_input_list(usr, "Ignored players", "Unignore", ignored_players)
	if(!key_to_unignore)
		return
	key_to_unignore = ckey(sanitize(key_to_unignore))
	if(!(key_to_unignore in ignored_players))
		to_chat(usr, span_warning("[key_to_unignore] isn't being ignored."))
		return
	ignored_players -= key_to_unignore
	prefs.write_preference_by_type(/datum/preference/ignored_players, ignored_players)
	to_chat(usr, span_notice("Reverted ignore on <b>[key_to_unignore]</b>."))

/mob/proc/is_key_ignored(var/key_to_check)
	if(client)
		return client.is_key_ignored(key_to_check)
	return 0

/client/proc/is_key_ignored(var/key_to_check)
	key_to_check = ckey(key_to_check)
	var/list/ignored_players = prefs?.read_preference(/datum/preference/ignored_players)
	if(key_to_check in ignored_players)
		if(GLOB.directory[key_to_check] in GLOB.admins) // This is here so this is only evaluated if someone is actually being blocked.
			return 0
		return 1
	return 0
