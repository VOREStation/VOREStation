/proc/log_nsay(text, inside, mob/speaker)
	if (config.log_say)
		diary << "\[[time_stamp()]]NSAY (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)][log_end]"

/proc/log_nme(text, inside, mob/speaker)
	if (config.log_emote)
		diary << "\[[time_stamp()]]NME (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)][log_end]"

/proc/log_subtle(text, mob/speaker)
	if (config.log_emote)
		diary << "\[[time_stamp()]]SUBTLE: [speaker.simple_info_line()]: [html_decode(text)][log_end]"
