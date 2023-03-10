/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	for(var/client/C in GLOB.clients)
		if(!check_rights_for(src, R_ADMIN|R_MOD))
			Lines += "\t[C.holder?.fakekey || C.key]"
			continue
		var/entry = "\t[C.key]"
		if(C.holder?.fakekey)
			entry += " <i>(as [C.holder.fakekey])</i>"
		entry += " - Playing as [C.mob.real_name]"
		switch(C.mob.stat)
			if(UNCONSCIOUS)
				entry += " - <font color='darkgray'><b>Unconscious</b></font>"
			if(DEAD)
				if(isobserver(C.mob))
					var/mob/observer/dead/O = C.mob
					if(O.started_as_observer)
						entry += " - <font color='gray'>Observing</font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
				else
					entry += " - <font color='black'><b>DEAD</b></font>"

		if(C.player_age != initial(C.player_age) && isnum(C.player_age)) // database is on
			var/age = C.player_age
			switch(age)
				if(0 to 1)
					age = "<font color='#ff0000'><b>[age] days old</b></font>"
				if(1 to 10)
					age = "<font color='#ff8c00'><b>[age] days old</b></font>"
				else
					entry += " - [age] days old"

		if(is_special_character(C.mob))
			entry += " - <b><font color='red'>Antagonist</font></b>"

		if(C.is_afk())
			var/seconds = C.last_activity_seconds()
			entry += " (AFK - [round(seconds / 60)] minutes, [seconds % 60] seconds)"

		entry += " [ADMIN_QUE(C.mob)]"
		Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	msg = "<span class='filter_notice'>[jointext(msg, "<br>")]</span>"
	to_chat(src,msg)

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/msg = ""
	var/modmsg = ""
	var/devmsg = ""
	var/eventMmsg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	var/num_devs_online = 0
	var/num_event_managers_online = 0
	for(var/client/C in GLOB.admins) // VOREStation Edit - GLOB
		var/temp = ""
		var/category = R_ADMIN
		// VOREStation Edit - Apply stealthmin protection to all levels
		if(C.holder.fakekey && !check_rights_for(src, R_ADMIN|R_MOD))	// Only admins and mods can see stealthmins
			continue
		// VOREStation Edit End
		if(check_rights(R_BAN, FALSE, C)) // admins //VOREStation Edit
			num_admins_online++
		else if(check_rights(R_ADMIN, FALSE, C) && !check_rights(R_SERVER, FALSE, C)) // mods //VOREStation Edit: Game masters
			category = R_MOD
			num_mods_online++
		else if(check_rights(R_SERVER, FALSE, C)) // developers
			category = R_SERVER
			num_devs_online++
		else if(check_rights(R_STEALTH, FALSE, C)) // event managers //VOREStation Edit: Retired Staff
			category = R_EVENT
			num_event_managers_online++

		temp += "\t[C] is a [C.holder.rank]"
		if(holder)
			if(C.holder.fakekey)
				temp += " <i>(as [C.holder.fakekey])</i>"

			if(isobserver(C.mob))
				temp += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				temp += " - Lobby"
			else
				temp += " - Playing"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				temp += " (AFK - [round(seconds / 60)] minutes, [seconds % 60] seconds)"
		temp += "\n"
		switch(category)
			if(R_ADMIN)
				msg += temp
			if(R_MOD)
				modmsg += temp
			if(R_SERVER)
				devmsg += temp
			if(R_EVENT)
				eventMmsg += temp

	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg

	if(config.show_mods)
		msg += "\n<b> Current Game Masters ([num_mods_online]):</b>\n" + modmsg

	if(config.show_devs)
		msg += "\n<b> Current Developers ([num_devs_online]):</b>\n" + devmsg

	if(config.show_event_managers)
		msg += "\n<b> Current Miscellaneous ([num_event_managers_online]):</b>\n" + eventMmsg

	var/num_mentors_online = 0
	var/mmsg = ""

	for(var/client/C in GLOB.mentors)
		num_mentors_online++
		mmsg += "\t[C] is a Mentor"
		if(holder)
			if(isobserver(C.mob))
				mmsg += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				mmsg += " - Lobby"
			else
				mmsg += " - Playing"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				mmsg += " (AFK - [round(seconds / 60)] minutes, [seconds % 60] seconds)"
		mmsg += "\n"

	if(config.show_mentors)
		msg += "\n<b> Current Mentors ([num_mentors_online]):</b>\n" + mmsg

	msg += "\n<span class='info'>Adminhelps are also sent to Discord. If no admins are available in game try anyway and an admin on Discord may see it and respond.</span>"

	to_chat(src,"<span class='filter_notice'>[jointext(msg, "<br>")]</span>")
