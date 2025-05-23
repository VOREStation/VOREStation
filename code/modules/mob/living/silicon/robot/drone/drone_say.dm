/mob/living/silicon/robot/drone/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	if(local_transmit)
		if (src.client)
			if(client.prefs.muted & MUTE_IC)
				to_chat(src, span_warning("You cannot send IC messages (muted)."))
				return 0

		message = sanitize(message)

		if (stat == DEAD)
			return say_dead(message)

		if(copytext(message,1,2) == "*")
			return emote(copytext(message,2))

		if(copytext(message,1,2) == ";")
			var/datum/language/L = GLOB.all_languages["Drone Talk"]
			if(istype(L))
				return L.broadcast(src,trim(copytext(message,2)))

		//Must be concious to speak
		if (stat)
			return 0

		var/list/listeners = hearers(5,src)
		listeners |= src

		for(var/mob/living/silicon/D in listeners)
			if(D.client && D.local_transmit)
				to_chat(D, span_say(span_bold("[src]") + "transmits, \"[message]\""))

		for (var/mob/M in player_list)
			if (isnewplayer(M))
				continue
			else if(M.stat == DEAD &&  M.client?.prefs?.read_preference(/datum/preference/toggle/ghost_ears))
				if(M.client)
					to_chat(M, span_say(span_bold("[src]") + "transmits, \"[message]\""))
		return 1
	return ..()
