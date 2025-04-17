/mob/Logout()
	SStgui.on_logout(src) // Cleanup any TGUIs the user has open
	player_list -= src
	disconnect_time = world.realtime	//VOREStation Addition: logging when we disappear.
	update_client_z(null)
	log_access_out(src)
	unset_machine()
	if(GLOB.admin_datums[src.ckey])
		message_admins("Staff logout: [key_name(src)]") // Staff logout notice displays no matter what
		if (ticker && ticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
			var/admins_number = GLOB.admins.len

			if(admins_number == 0) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
				send2adminirc("[key_name(src)] logged out - no more admins online.")
	set_listening(NON_LISTENING_ATOM) //maybe remove this, even if it will cause a teensy bit more lag
	..()

	return 1
