/mob/new_player/Login()
	// Happens sometimes
	if(QDELETED(src))
		var/mob/new_player/replacement = new /mob/new_player()
		replacement.key = key
		return

	update_Login_details()    //handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	sight |= SEE_TURFS

	GLOB.player_list |= src
	GLOB.new_player_list += src

	created_for = ckey
	client.persistent_client.set_mob(src)

	addtimer(CALLBACK(src, PROC_REF(do_after_login)), 4 SECONDS, TIMER_DELETE_ME)
	initialize_lobby_screen()

/mob/new_player/proc/do_after_login()
	PRIVATE_PROC(TRUE)
	if(client)
		var/motd = global.config.motd
		if(motd)
			to_chat(src, examine_block("<div class=\"motd\">[motd]</div>"))

		if(has_respawned)
			to_chat(src, CONFIG_GET(string/respawn_message))

		if((read_preference(/datum/preference/text/lastchangelog) != GLOB.changelog_hash)) //bolds the changelog button on the interface so we know there are updates.
			to_chat(src, span_info("You have unread updates in the changelog."))
			if(CONFIG_GET(flag/aggressive_changelog))
				client.changes()

		if(GLOB.custom_event_msg && GLOB.custom_event_msg != "")
			to_chat(src, "<h1 class='alert'>Custom Event</h1>")
			to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
			to_chat(src, span_alert("[GLOB.custom_event_msg]") + "\n")

		has_respawned = FALSE
		handle_privacy_poll()
		client.playtitlemusic()
		version_warnings()
		add_verb(src, /mob/proc/insidePanel)

/mob/new_player/proc/version_warnings()
	var/problems // string to store message to present to player as a problem

	// TODO: Move this to a config file at some point maybe? What would the structure of that look like?
	switch(client.byond_build)
		// http://www.byond.com/forum/post/2711510
		// http://www.byond.com/forum/post/2711506
		// http://www.byond.com/forum/post/2711626
		// http://www.byond.com/forum/post/2711748
		if(1562 to 1563)
			problems = "frequent known crashes related to animations"

		// Don't have a thread, just a lot of player reports.
		if(1564 to 1565) // Fixed in 1566 which isn't released as of this commit
			if(world.byond_build == 1564)
				problems = "random network disconnects on this version of BYOND server"
			else if(world.byond_build < 1564)
				problems = "crashes related to animations on this version of BYOND server"
			else
				problems = "potential network disconnects. If you experience some, try another version"

		if(1566 to 1568)
			if(world.byond_build == 1569)
				problems = "frequent crashes, usually when transitioning between z-levels"

		if(1652 to 1654)
			problems = "various webview graphics issues and client hanging (1652 to 1654 are all affected). 516.1651 is known to be safe from these issues if a newer version than 1654 is not available."

	if(problems)
		// To get attention
		var/message = "Your BYOND client version ([client.byond_version].[client.byond_build]) has known issues: [problems]. See the chat window for other version options."
		tgui_alert_async(src, message, "BYOND Client Version Warning")

		// So we can be more wordy and give links.
		to_chat(src, span_userdanger("Your client version has known issues.") + " Please consider using a different version: <a href='https://www.byond.com/download/build/'>https://www.byond.com/download/build/</a>.")
		if(CONFIG_GET(number/suggested_byond_version))
			var/chat_message = "We suggest using version [CONFIG_GET(number/suggested_byond_version)]."
			if(CONFIG_GET(number/suggested_byond_build))
				chat_message += "[CONFIG_GET(number/suggested_byond_build)]."
			chat_message += " If you find this version doesn't work for you, let us know."
			to_chat(src, chat_message)
		to_chat(src, "Tip: You can always use the '.zip' versions of BYOND and keep multiple versions in folders wherever you want, rather than uninstalling/reinstalling. Just make sure BYOND is *really* closed (check your system tray for the icon) before starting a different version.")
