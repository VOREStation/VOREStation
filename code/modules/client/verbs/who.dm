/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		for(var/client/C in GLOB.clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
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

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				entry += " (AFK - "
				entry += "[round(seconds / 60)] minutes, "
				entry += "[seconds % 60] seconds)"

			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src,msg)

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/message = get_staffwho_message(holder)
	to_chat(src, message)

// VOREStation Edit - This whole proc has various vorestation edits throughout. Practically every other line.
/proc/get_staffwho_message(datum/admins/holder)
	var/msg = ""
	var/modmsg = ""
	var/devmsg = ""
	var/eventMmsg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	var/num_devs_online = 0
	var/num_event_managers_online = 0
	
	if(holder)
		for(var/client/C in GLOB.admins)
			if(R_ADMIN & C.holder.rights && R_BAN & C.holder.rights)

				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MOD & holder.rights))		//Event Managerss can't see stealthmins
					continue

				msg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					msg += " - Lobby"
				else
					msg += " - Playing"

				if(C.is_afk())
					var/seconds = C.last_activity_seconds()
					msg += " (AFK - "
					msg += "[round(seconds / 60)] minutes, "
					msg += "[seconds % 60] seconds)"
				msg += "\n"

				num_admins_online++
			else if(R_ADMIN & C.holder.rights && !(R_SERVER & C.holder.rights))
				modmsg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MOD & holder.rights))
					continue
				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					modmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					modmsg += " - Lobby"
				else
					modmsg += " - Playing"

				if(C.is_afk())
					var/seconds = C.last_activity_seconds()
					modmsg += " (AFK - "
					modmsg += "[round(seconds / 60)] minutes, "
					modmsg += "[seconds % 60] seconds)"
				modmsg += "\n"
				num_mods_online++

			else if(R_SERVER & C.holder.rights)
				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MOD & holder.rights))
					continue
				devmsg += "\t[C] is a [C.holder.rank]"
				if(C.holder.fakekey)
					devmsg += " <i>(as [C.holder.fakekey])</i>"
				if(isobserver(C.mob))
					devmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					devmsg += " - Lobby"
				else
					devmsg += " - Playing"

				if(C.is_afk())
					var/seconds = C.last_activity_seconds()
					devmsg += "(AFK - "
					devmsg += "[round(seconds / 60)] minutes, "
					devmsg += "[seconds % 60] seconds)"
				devmsg += "\n"
				num_devs_online++

			else
				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MOD & holder.rights))
					continue
				eventMmsg += "\t[C] is a [C.holder.rank]"
				if(C.holder.fakekey)
					eventMmsg += " <i>(as [C.holder.fakekey])</i>"
				if(isobserver(C.mob))
					eventMmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					eventMmsg += " - Lobby"
				else
					eventMmsg += " - Playing"

				if(C.is_afk())
					var/seconds = C.last_activity_seconds()
					eventMmsg += " (AFK - "
					eventMmsg += "[round(seconds / 60)] minutes, "
					eventMmsg += "[seconds % 60] seconds)"
				eventMmsg += "\n"
				num_event_managers_online++

	else
		for(var/client/C in GLOB.admins)
			if(R_ADMIN & C.holder.rights && R_BAN & C.holder.rights)
				if(!C.holder.fakekey)
					msg += "\t[C] is a [C.holder.rank]\n"
					num_admins_online++
			else if(R_ADMIN & C.holder.rights && !(R_SERVER & C.holder.rights))
				if(!C.holder.fakekey)
					modmsg += "\t[C] is a [C.holder.rank]\n"
					num_mods_online++
			else if(R_SERVER & C.holder.rights)
				if(!C.holder.fakekey)
					devmsg += "\t[C] is a [C.holder.rank]\n"
					num_devs_online++
			else
				if(!C.holder.fakekey)
					eventMmsg += "\t[C] is a [C.holder.rank]\n"
					num_event_managers_online++

	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg

	if(config.show_mods)
		msg += "\n<b> Current Game Masters ([num_mods_online]):</b>\n" + modmsg

	if(config.show_devs)
		msg += "\n<b> Current Developers ([num_devs_online]):</b>\n" + devmsg

	if(config.show_event_managers)
		msg += "\n<b> Current Miscellaneous ([num_event_managers_online]):</b>\n" + eventMmsg

	msg += "\n<span class='info'>Adminhelps are also sent to Discord. If no admins are available in game try anyway and an admin on Discord may see it and respond.</span>"

	return msg

