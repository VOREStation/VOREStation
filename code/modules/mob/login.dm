//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access_in(client)
	if(config.log_access)
		for(var/mob/M in player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (client.connection != "web") && (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					if(!config.disable_cid_warn_popup)
						tgui_alert_async(usr, "You appear to have logged in with another key this round, which is not permitted. Please contact an administrator if you believe this message to be in error.")
				if(matches)
					if(M.client)
						message_admins("[span_red("<B>Notice: </B>")][span_blue("[key_name_admin(src)] has the same [matches] as [key_name_admin(M)].")]", 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("[span_red("<B>Notice: </B>")][span_blue("[key_name_admin(src)] has the same [matches] as [key_name_admin(M)] (no longer logged in). ")]", 1)
						log_adminwarn("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()

	player_list |= src
	update_Login_details()
	world.update_status()

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = list()				//remove hud items just in case
	if(hud_used)	qdel(hud_used)		//remove the hud objects
	hud_used = new /datum/hud(src)

	if(client.prefs && client.prefs.client_fps)
		client.fps = client.prefs.client_fps
	else
		client.fps = 0 // Results in using the server FPS

	next_move = 1
	disconnect_time = null				//VOREStation Addition: clear the disconnect time
	sight |= SEE_SELF
	..()
	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE
	add_click_catcher()
	update_client_color()

	if(!plane_holder) //Lazy
		plane_holder = new(src) //Not a location, it takes it and saves it.
	if(!vis_enabled)
		vis_enabled = list()
	client.screen += plane_holder.plane_masters
	recalculate_vis()

	// AO support
	var/ao_enabled = client.is_preference_enabled(/datum/client_preference/ambient_occlusion)
	plane_holder.set_ao(VIS_OBJS, ao_enabled)
	plane_holder.set_ao(VIS_MOBS, ao_enabled)

	// Status indicators
	var/status_enabled = client.is_preference_enabled(/datum/client_preference/status_indicators)
	plane_holder.set_vis(VIS_STATUS, status_enabled)

	//set macro to normal incase it was overriden (like cyborg currently does)
	client.set_hotkeys_macro("macro", "hotkeymode")

	if(!client.tooltips)
		client.tooltips = new(client)

	var/turf/T = get_turf(src)
	if(isturf(T))
		update_client_z(T.z)

	if(cloaked && cloaked_selfimage)
		client.images += cloaked_selfimage
	SEND_SIGNAL(src, COMSIG_MOB_CLIENT_LOGIN, client)
