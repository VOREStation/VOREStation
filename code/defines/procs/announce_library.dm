/proc/announcer_library_get_voiceline(msg_key)
	// Attempts to use voice lines in the currently chosen announces
	// Otherwise falls back to station default
	// Passing null to datum/announcement/PlayMessage() will only pay the preamble message
	var/play_msg_sound = null

	// Check from our current announcer
	var/found_key = TRUE
	var/list/voice_library = GLOB.announcer_library[GLOB.current_announcer_voice]
	if(islist(voice_library)) // Announcer needs to exist
		if(msg_key in voice_library)
			play_msg_sound = voice_library[msg_key]
			found_key = TRUE

	// Attempt fallback
	if(!found_key) // Don't use null, if the key was found and was INTENTIONALLY null, then the announcement line was disabled!
		var/list/voice_library = GLOB.announcer_library[ANNOUNCER_VOICE_SS13] // Default
		if(msg_key in voice_library)
			play_msg_sound = voice_library[msg_key]

	return play_msg_sound

// Replaces a bunch of directly sent sounds to clients
/proc/play_simple_announcement(target, msg_key)
	var/message_sound = announcer_library_get_voiceline(msg_key)
	if(message_sound)
		SEND_SOUND(target, message_sound)
