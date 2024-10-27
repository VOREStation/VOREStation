/proc/log_nsay(text, inside, mob/speaker)
	if (CONFIG_GET(flag/log_say))
		WRITE_LOG(diary, "NSAY (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_nme(text, inside, mob/speaker)
	if (CONFIG_GET(flag/log_emote))
		WRITE_LOG(diary, "NME (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_subtle(text, mob/speaker)
	if (CONFIG_GET(flag/log_emote))
		WRITE_LOG(diary, "SUBTLE: [speaker.simple_info_line()]: [html_decode(text)]")
