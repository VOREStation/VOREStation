/mob/new_player/Logout()
	ready = 0

	GLOB.new_player_list -= src
	disable_lobby_browser()

	..()

	//if(created_for)
		//del_mannequin(created_for) No need to delete this, honestly. It saves up hardly any memory in the long run and fucks the GC in the short run.

	if(!spawning)//Here so that if they are spawning and log out, the other procs can play out and they will have a mob to come back to.
		key = null//We null their key before deleting the mob, so they are properly kicked out.
		QDEL_NULL(mind)
		qdel(src)
	return

/mob/new_player/proc/disable_lobby_browser()
	if(lobby_window)
		lobby_window.unsubscribe(src)
		lobby_window.close()
		lobby_window = null
	var/client/exiting_client = persistent_client.client
	if(exiting_client)
		winset(exiting_client, "lobby_browser", "is-disabled=true;is-visible=false")
