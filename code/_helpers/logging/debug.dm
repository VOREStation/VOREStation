/proc/log_asset(text)
	WRITE_LOG(diary, "ASSET: [text]")

/proc/log_debug(text)
	if (config.log_debug)
		WRITE_LOG(debug_log, "DEBUG: [sanitize(text)]")

	for(var/client/C in GLOB.admins)
		if(C.is_preference_enabled(/datum/client_preference/debug/show_debug_logs))
			to_chat(C, "<span class='filter_debuglog'>DEBUG: [text]</span>")

/proc/log_topic(text)
	if(Debug2)
		WRITE_LOG(diary, "TOPIC: [text]")
