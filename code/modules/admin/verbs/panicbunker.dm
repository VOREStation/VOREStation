/client/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"
	
	if(!check_rights(R_ADMIN))
		return

	if (!config.sql_enabled)
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled!</span>")
		return

	config.panic_bunker = (!config.panic_bunker)

	log_and_message_admins("[key_name(usr)] has toggled the Panic Bunker, it is now [(config.panic_bunker?"on":"off")]")
	if (config.panic_bunker && (!dbcon || !dbcon.IsConnected()))
		message_admins("The Database is not connected! Panic bunker will not work until the connection is reestablished.")
	feedback_add_details("admin_verb","PANIC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/paranoia_logging()
	set category = "Server"
	set name = "New Player Warnings"

	if(!check_rights(R_ADMIN))
		return

	config.paranoia_logging = (!config.paranoia_logging)

	log_and_message_admins("[key_name(usr)] has toggled Paranoia Logging, it is now [(config.paranoia_logging?"on":"off")]")
	if (config.paranoia_logging && (!dbcon || !dbcon.IsConnected()))
		message_admins("The Database is not connected! Paranoia logging will not be able to give 'player age' (time since first connection) warnings, only Byond account warnings.")
	feedback_add_details("admin_verb","PARLOG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
