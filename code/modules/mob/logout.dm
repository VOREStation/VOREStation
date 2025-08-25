/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	SStgui.on_logout(src) // Cleanup any TGUIs the user has open
	GLOB.player_list -= src
	disconnect_time = world.realtime	//VOREStation Addition: logging when we disappear.
	update_client_z(null)
	log_access("Mob Logout: [key_name(src)]")
	unset_machine()

	var/datum/admins/is_admin = GLOB.admin_datums[src.ckey]
	if(is_admin && is_admin.check_for_rights(R_HOLDER))
		message_admins("Staff logout: [key_name(src)]") // Staff logout notice displays no matter what

	set_listening(NON_LISTENING_ATOM) //maybe remove this, even if it will cause a teensy bit more lag
	..()

	return TRUE
