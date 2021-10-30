// Will hoepfully fix the database when it breaks
// Use case: if the server is left in the lobby for long enough,  players that join will see player_age = 0, restricting them from all age-locked jobs.
/client/proc/dbcon_fix()
	set name = "Fix Database Connection"
	set category = "Server"
	set desc = "Experimental: Will hopefully perform a one-button fix for a database connection that has timed out."

	if(!check_rights(R_ADMIN|R_DEBUG|R_FUN))
		to_chat(src, "You must be an admin to do this.")
		return FALSE

	log_admin("Attempting to fix database connection")
	if(dbcon.IsConnected())
		dbcon.Disconnect()
	else
		log_admin("Database already disconnected")
	
	establish_db_connection()
	var/errno = dbcon.ErrorMsg()
	if(errno)
		log_admin("Database connection returned error message `[errno]`. Aborting.")
		return FALSE
	if(!dbcon.IsConnected())
		log_admin("Database could not be reconnected! Aborting.")
		return FALSE
	log_admin("Database reconnected. Fixing player ages...")	

	var/num = 0
	for(var/client/C in GLOB.clients)
		C.log_client_to_db()
		errno = dbcon.ErrorMsg()
		if(errno)
			log_admin("Database connection returned error message `[errno]` after adjusting player ages for [num] players. [C] was being updated when the error struck. Aborting.")
			return FALSE
		if(C.player_age)
			num++
	
	log_admin("Successfully updated non-0 player age for [num] clients.")
	return FALSE