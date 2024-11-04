/client/proc/panicbunker()
	set category = "Server.Config"
	set name = "Toggle Panic Bunker"

	if(!check_rights(R_ADMIN))
		return

	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice("The Database is not enabled!"))
		return

	CONFIG_SET(flag/panic_bunker, !CONFIG_GET(flag/panic_bunker))

	log_and_message_admins("[key_name(usr)] has toggled the Panic Bunker, it is now [(CONFIG_GET(flag/panic_bunker) ? "on":"off")].")
	if (CONFIG_GET(flag/panic_bunker) && (!dbcon || !dbcon.IsConnected()))
		message_admins("The database is not connected! Panic bunker will not work until the connection is reestablished.")
	feedback_add_details("admin_verb","PANIC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/paranoia_logging()
	set category = "Server.Config"
	set name = "New Player Warnings"

	if(!check_rights(R_ADMIN))
		return

	CONFIG_SET(flag/paranoia_logging, !CONFIG_GET(flag/paranoia_logging))

	log_and_message_admins("[key_name(usr)] has toggled Paranoia Logging, it is now [(CONFIG_GET(flag/paranoia_logging) ? "on":"off")].")
	if (CONFIG_GET(flag/paranoia_logging) && (!dbcon || !dbcon.IsConnected()))
		message_admins("The database is not connected! Paranoia logging will not be able to give 'player age' (time since first connection) warnings, only Byond account warnings.")
	feedback_add_details("admin_verb","PARLOG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/ip_reputation()
	set category = "Server.Config"
	set name = "Toggle IP Rep Checks"

	if(!check_rights(R_ADMIN))
		return

	CONFIG_SET(flag/ip_reputation, !CONFIG_GET(flag/ip_reputation))

	log_and_message_admins("[key_name(usr)] has toggled IP reputation checks, it is now [(CONFIG_GET(flag/ip_reputation) ? "on":"off")].")
	if (CONFIG_GET(flag/ip_reputation) && (!dbcon || !dbcon.IsConnected()))
		message_admins("The database is not connected! IP reputation logging will not be able to allow existing players to bypass the reputation checks (if that is enabled).")
	feedback_add_details("admin_verb","IPREP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
