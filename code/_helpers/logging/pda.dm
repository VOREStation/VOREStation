/proc/log_pda(text, mob/speaker)
	if (config.log_pda)
		WRITE_LOG(diary, "PDA: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"
	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"
