///var/atom/movable/lobby_image = new /atom/movable{icon = 'icons/misc/title.dmi'; icon_state = lobby_image_state; screen_loc = "1,1"; name = "Polaris"}

var/obj/effect/lobby_image = new /obj/effect/lobby_image

/obj/effect/lobby_image
	name = "VORE Station"
	desc = "How are you reading this?"
	screen_loc = "1,1"
	icon = 'icons/misc/loading.dmi'
	icon_state = "loading"

/obj/effect/lobby_image/Initialize()
	icon = using_map.lobby_icon
	var/known_icon_states = cached_icon_states(icon)
	for(var/lobby_screen in using_map.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			using_map.lobby_screens -= lobby_screen

	if(using_map.lobby_screens.len)
		icon_state = pick(using_map.lobby_screens)
	else
		icon_state = known_icon_states[1]
	. = ..()

/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		join_motd = GLOB.is_valid_url.Replace(join_motd,span_linkify("$1"))
		to_chat(src, examine_block("<div class=\"motd\">[join_motd]</div>"))

	if(has_respawned)
		to_chat(usr, CONFIG_GET(string/respawn_message))
		has_respawned = FALSE

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	client.screen += lobby_image
	my_client = client
	sight |= SEE_TURFS
	player_list |= src

	created_for = ckey

	new_player_panel()
	client.init_verbs()
	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()
			version_warnings()

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

	if(problems)
		// To get attention
		var/message = "Your BYOND client version ([client.byond_version].[client.byond_build]) has known issues: [problems]. See the chat window for other version options."
		tgui_alert_async(src, message, "BYOND Client Version Warning")

		// So we can be more wordy and give links.
		to_chat(src, span_userdanger("Your client version has known issues.") + " Please consider using a different version: <a href='https://www.byond.com/download/build/'>https://www.byond.com/download/build/</a>.")
		var/chat_message = ""
		if(CONFIG_GET(number/suggested_byond_version))
			chat_message += "We suggest using version [CONFIG_GET(number/suggested_byond_version)]."
			if(CONFIG_GET(number/suggested_byond_build))
				chat_message += "[CONFIG_GET(number/suggested_byond_build)]."
			chat_message += " If you find this version doesn't work for you, let us know."
		to_chat(src, chat_message)
		to_chat(src, "Tip: You can always use the '.zip' versions of BYOND and keep multiple versions in folders wherever you want, rather than uninstalling/reinstalling. Just make sure BYOND is *really* closed (check your system tray for the icon) before starting a different version.")
