/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		WRITE_LOG(diary, "ADMIN: [text]")

/proc/log_adminpm(text, client/source, client/dest)
	admin_log.Add(text)
	if (config.log_admin)
		WRITE_LOG(diary, "ADMINPM: [key_name(source)]->[key_name(dest)]: [html_decode(text)]")

/proc/log_adminsay(text, mob/speaker)
	if (config.log_adminchat)
		WRITE_LOG(diary, "ADMINSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_modsay(text, mob/speaker)
	if (config.log_adminchat)
		WRITE_LOG(diary, "MODSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_eventsay(text, mob/speaker)
	if (config.log_adminchat)
		WRITE_LOG(diary, "EVENTSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		WRITE_LOG(diary, "ADMINWARN: [html_decode(text)]")
