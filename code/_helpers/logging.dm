/proc/log_adminpm(text, client/source, client/dest)
	GLOB.admin_log.Add(text)
	if (CONFIG_GET(flag/log_admin))
		WRITE_LOG(GLOB.diary, "ADMINPM: [key_name(source)]->[key_name(dest)]: [html_decode(text)]")

/proc/log_debug(text)
	if (CONFIG_GET(flag/log_debug))
		WRITE_LOG(GLOB.debug_log, "DEBUG: [sanitize(text)]")

	for(var/client/C in GLOB.admins)
		if(C.prefs?.read_preference(/datum/preference/toggle/show_debug_logs))
			to_chat(C,
					type = MESSAGE_TYPE_DEBUG,
					html = span_filter_debuglogs("DEBUG: [text]"))

/proc/log_ghostsay(text, mob/speaker)
	if (CONFIG_GET(flag/log_say))
		WRITE_LOG(GLOB.diary, "DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += span_bold("([time_stamp()])") + " (" + span_bold("[speaker]/[speaker.client]") + ") " + span_underline("DEADSAY:") + " - " + span_green("[text]")
	GLOB.round_text_log += span_small(span_purple(span_bold("([time_stamp()])") + " (" + span_bold("[speaker]/[speaker.client]") + ") " + span_underline("DEADSAY:") + " - [text]"))

/proc/log_ghostemote(text, mob/speaker)
	if (CONFIG_GET(flag/log_emote))
		WRITE_LOG(GLOB.diary, "DEADEMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_unit_test(text)
	log_world("## UNIT_TEST: [text]")

/proc/report_progress(var/progress_message)
	admin_notice(span_boldannounce("[progress_message]"), R_DEBUG)
	log_world(progress_message)

// Helper procs for building detailed log lines
//
// These procs must not fail under ANY CIRCUMSTANCES!
//

/datum/proc/log_info_line()
	return "[src] ([type])"

/atom/log_info_line()
	. = ..()
	var/turf/t = get_turf(src)
	if(istype(t))
		return "[.] @ [t.log_info_line()]"
	else if(loc)
		return "[.] @ ([loc]) (0,0,0) ([loc.type])"
	else
		return "[.] @ (NULL) (0,0,0) (NULL)"

/turf/log_info_line()
	return "([src]) ([x],[y],[z]) ([type])"

/mob/log_info_line()
	return "[..()] (ckey=[ckey])"

/proc/log_info_line(var/datum/d)
	if(!d)
		return "*null*"
	if(!istype(d))
		return json_encode(d)
	return d.log_info_line()

/mob/proc/simple_info_line()
	return "[key_name(src)] ([x],[y],[z])"

/client/proc/simple_info_line()
	return "[key_name(src)] ([mob.x],[mob.y],[mob.z])"
