/mob/observer/dead/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	message = sanitize(message)

	if(!message)
		return

	log_ghostsay(message, src)

	if (client)
		if(message)
			client.handle_spam_prevention(MUTE_DEADCHAT)
			if(client.prefs.muted & MUTE_DEADCHAT)
				to_chat(src, span_filter_notice("[span_red("You cannot talk in deadchat (muted).")]"))
				return

	. = say_dead(message)


/mob/observer/dead/me_verb(message as text)
	if(!message)
		return

	log_ghostemote(message, src)

	if(client)
		if(message)
			client.handle_spam_prevention(MUTE_DEADCHAT)
			if(client.prefs.muted & MUTE_DEADCHAT)
				to_chat(src, span_filter_notice("[span_red("You cannot emote in deadchat (muted).")]"))
				return

	. = emote_dead(message)

/mob/observer/dead/handle_track(message, verb = "says", mob/speaker = null, speaker_name, hard_to_hear)
	return "[speaker_name] ([ghost_follow_link(speaker, src)])"

/mob/observer/dead/handle_speaker_name(mob/speaker = null, vname, hard_to_hear)
	var/speaker_name = ..()
	//Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
	if(speaker && (speaker_name != speaker.real_name) && !isAI(speaker))
		speaker_name = "[speaker.real_name] ([speaker_name])"
	return speaker_name
