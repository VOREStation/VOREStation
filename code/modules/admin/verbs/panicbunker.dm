ADMIN_VERB(panicbunker, R_ADMIN|R_SERVER, "Toggle Panic Bunker", "Locks the server down.", ADMIN_CATEGORY_SERVER_CONFIG)
	if (!CONFIG_GET(flag/sql_enabled))
		to_chat(user, span_adminnotice("The Database is not enabled!"))
		return

	CONFIG_SET(flag/panic_bunker, !CONFIG_GET(flag/panic_bunker))

	log_and_message_admins("has toggled the Panic Bunker, it is now [(CONFIG_GET(flag/panic_bunker) ? "on":"off")].", user)
	if (CONFIG_GET(flag/panic_bunker) && (!SSdbcore || !SSdbcore.IsConnected()))
		message_admins("The database is not connected! Panic bunker will not work until the connection is reestablished.")
	feedback_add_details("admin_verb","PANIC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(paranoia_logging, R_ADMIN|R_SERVER, "New Player Warnings", "Toggle paranoia logging.", ADMIN_CATEGORY_SERVER_CONFIG)
	CONFIG_SET(flag/paranoia_logging, !CONFIG_GET(flag/paranoia_logging))

	log_and_message_admins("has toggled Paranoia Logging, it is now [(CONFIG_GET(flag/paranoia_logging) ? "on":"off")].", user)
	if (CONFIG_GET(flag/paranoia_logging) && (!SSdbcore || !SSdbcore.IsConnected()))
		message_admins("The database is not connected! Paranoia logging will not be able to give 'player age' (time since first connection) warnings, only Byond account warnings.")
	feedback_add_details("admin_verb","PARLOG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(ip_reputation, R_ADMIN|R_SERVER, "Toggle IP Rep Checks", "Toggle ip reputation checks.", ADMIN_CATEGORY_SERVER_CONFIG)
	CONFIG_SET(flag/ip_reputation, !CONFIG_GET(flag/ip_reputation))

	log_and_message_admins("has toggled IP reputation checks, it is now [(CONFIG_GET(flag/ip_reputation) ? "on":"off")].", user)
	if (CONFIG_GET(flag/ip_reputation) && (!SSdbcore || !SSdbcore.IsConnected()))
		message_admins("The database is not connected! IP reputation logging will not be able to allow existing players to bypass the reputation checks (if that is enabled).")
	feedback_add_details("admin_verb","IPREP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
