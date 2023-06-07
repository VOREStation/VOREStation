/proc/log_game(text)
	if (config.log_game)
		WRITE_LOG(diary, "GAME: [text]")

/proc/log_ooc(text, client/user)
	if (config.log_ooc)
		WRITE_LOG(diary, "OOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>OOC:</u> - <span style=\"color:blue\"><b>[text]</b></span>"

/proc/log_aooc(text, client/user)
	if (config.log_ooc)
		WRITE_LOG(diary, "AOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>AOOC:</u> - <span style=\"color:red\"><b>[text]</b></span>"

/proc/log_looc(text, client/user)
	if (config.log_ooc)
		WRITE_LOG(diary, "LOOC: [user.simple_info_line()]: [html_decode(text)]")

	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[user]</b>) <u>LOOC:</u> - <span style=\"color:orange\"><b>[text]</b></span>"

/proc/log_vote(text)
	if (config.log_vote)
		WRITE_LOG(diary, "VOTE: [text]")
