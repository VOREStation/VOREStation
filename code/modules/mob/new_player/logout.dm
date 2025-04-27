/mob/new_player/Logout()
	ready = 0

	QDEL_NULL(lobby_window)

	var/client/exiting_client = GLOB.directory[persistent_ckey]
	if(exiting_client)
		winset(exiting_client, "lobby_browser", "is-disabled=true;is-visible=false")

	..()

	//if(created_for)
		//del_mannequin(created_for) No need to delete this, honestly. It saves up hardly any memory in the long run and fucks the GC in the short run.

	if(!spawning)//Here so that if they are spawning and log out, the other procs can play out and they will have a mob to come back to.
		key = null//We null their key before deleting the mob, so they are properly kicked out.
		qdel(src)
	return
