/mob
	var/hive_lang_range = 0

/mob/proc/adjust_hive_range()
	set name = "Adjust Language Range"
	set desc = "Changes the range you will transmit your hive language to!"
	set category = "IC"

	var/option = tgui_alert(src, "What range?", "Adjust language range", list("Global","This Z level","Local", "Subtle"))

	switch(option)
		if("Global")
			hive_lang_range = 0
		if("This Z level")
			hive_lang_range = -1
		if("Local")
			hive_lang_range = world.view
		if("Subtle")
			hive_lang_range = 1

/datum/language/shadekin/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	log_say("(HIVE) [message]", speaker)

	speaker.verbs |= /mob/proc/adjust_hive_range

	if(!speaker_mask) speaker_mask = speaker.name
	message = "[get_spoken_verb(message)], \"[format_message(message, get_spoken_verb(message))]\""

	if(speaker.hive_lang_range == -1)
		var/turf/t = get_turf(speaker)
		for(var/mob/player in player_list)
			var/turf/b = get_turf(player)
			if (t.z == b.z)
				player.hear_broadcast(src, speaker, speaker_mask, message)
	else if(speaker.hive_lang_range)
		var/turf/t = get_turf(speaker)
		for(var/mob/player in player_list)
			var/turf/b = get_turf(player)
			if(get_dist(t,b) <= speaker.hive_lang_range)
				player.hear_broadcast(src, speaker, speaker_mask, message)
	else
		for(var/mob/player in player_list)
			player.hear_broadcast(src, speaker, speaker_mask, message)
