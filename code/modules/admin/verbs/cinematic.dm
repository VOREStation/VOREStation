/client/proc/cinematic(var/cinematic as anything in list("explosion",null))
	set name = "Cinematic"
	set category = "Fun"
	set desc = "Shows a cinematic."	// Intended for testing but I thought it might be nice for events on the rare occasion Feel free to comment it out if it's not wanted.

	if(!check_rights(R_FUN))
		return

	if(tgui_alert(usr, "Are you sure you want to run [cinematic]?","Confirmation",list("Yes","No")) != "Yes") return
	if(!ticker)	return
	switch(cinematic)
		if("explosion")
			var/input = tgui_alert(usr, "The game will be over. Are you really sure?", "Confirmation", list("Continue","Cancel"))
			if(!input || input == "Cancel")
				return
			var/parameter = tgui_input_number(src,"station_missed = ?","Enter Parameter",0,1,0)
			var/override
			switch(parameter)
				if(1)
					override = tgui_input_list(src,"mode = ?","Enter Parameter", list("mercenary","no override"))
				if(0)
					override = tgui_input_list(src,"mode = ?","Enter Parameter", list("blob","mercenary","AI malfunction","no override"))
			ticker.station_explosion_cinematic(parameter,override)

	log_admin("[key_name(src)] launched cinematic \"[cinematic]\"")
	message_admins("[key_name_admin(src)] launched cinematic \"[cinematic]\"", 1)

	return
