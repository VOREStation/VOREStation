/proc/log_nsay(text,inside)
	if (config.log_say)
		diary << "\[[time_stamp()]]NSAY (NIF:[inside]): [text][log_end]"

/proc/log_nme(text,inside)
	if (config.log_emote)
		diary << "\[[time_stamp()]]NME (NIF:[inside]): [text][log_end]"

/proc/log_subtle(text)
	if (config.log_emote)
		diary << "\[[time_stamp()]]SUBTLE: [text][log_end]"
