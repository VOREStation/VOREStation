/proc/log_say(text, mob/speaker)
	if (config.log_say)
		WRITE_LOG(diary, "SAY: [speaker.simple_info_line()]: [html_decode(text)]")

	//Log the message to in-game dialogue logs, as well.
	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"

/proc/log_whisper(text, mob/speaker)
	if (config.log_whisper)
		WRITE_LOG(diary, "WHISPER: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:gray\"><i>[text]</i></span>"

/proc/log_emote(text, mob/speaker)
	if (config.log_emote)
		WRITE_LOG(diary, "EMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>EMOTE:</u> - <span style=\"color:#CCBADC\">[text]</span>"

/proc/log_nsay(text, inside, mob/speaker)
	if (config.log_say)
		WRITE_LOG(diary, "NSAY (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_nme(text, inside, mob/speaker)
	if (config.log_emote)
		WRITE_LOG(diary, "NME (NIF:[inside]): [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_subtle(text, mob/speaker)
	if (config.log_emote)
		WRITE_LOG(diary, "SUBTLE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_ghostsay(text, mob/speaker)
	if (config.log_say)
		WRITE_LOG(diary, "DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - <span style=\"color:green\">[text]</span>"
	GLOB.round_text_log += "<font size=1><span style=\"color:#7e668c\"><b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - [text]</span></font>"

/proc/log_ghostemote(text, mob/speaker)
	if (config.log_emote)
		WRITE_LOG(diary, "DEADEMOTE: [speaker.simple_info_line()]: [html_decode(text)]")
