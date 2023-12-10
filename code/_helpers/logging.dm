//print an error message to world.log

//This is an external call, "true" and "false" are how rust parses out booleans
#define WRITE_LOG(log, text) rustg_log_write(log, text, "true")
#define WRITE_LOG_NO_FORMAT(log, text) rustg_log_write(log, text, "false")

/* For logging round startup. */
/proc/start_log(log)
	WRITE_LOG(log, "START: Starting up [log_path].")
	return log

/* Close open log handles. This should be called as late as possible, and no logging should hapen after. */
/proc/shutdown_logging()
	rustg_log_close_all()

/proc/error(msg)
	to_world_log("## ERROR: [msg]")

#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	to_world_log("## WARNING: [msg]")

//print a testing-mode debug message to world.log
/proc/testing(msg)
	to_world_log("## TESTING: [msg]")

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		WRITE_LOG(diary, "ADMIN: [text]")

/proc/log_adminpm(text, client/source, client/dest)
	admin_log.Add(text)
	if (config.log_admin)
		WRITE_LOG(diary, "ADMINPM: [key_name(source)]->[key_name(dest)]: [html_decode(text)]")

/proc/log_pray(text, client/source)
	admin_log.Add(text)
	if (config.log_admin)
		WRITE_LOG(diary, "PRAY: [key_name(source)]: [text]")

/proc/log_debug(text)
	if (config.log_debug)
		WRITE_LOG(debug_log, "DEBUG: [sanitize(text)]")

	for(var/client/C in GLOB.admins)
		if(C.is_preference_enabled(/datum/client_preference/debug/show_debug_logs))
			to_chat(C,
					type = MESSAGE_TYPE_DEBUG,
					html = "<span class='filter_debuglog'>DEBUG: [text]</span>")

/proc/log_game(text)
	if (config.log_game)
		WRITE_LOG(diary, "GAME: [text]")

/proc/log_vote(text)
	if (config.log_vote)
		WRITE_LOG(diary, "VOTE: [text]")

/proc/log_access_in(client/new_client)
	if (config.log_access)
		var/message = "[key_name(new_client)] - IP:[new_client.address] - CID:[new_client.computer_id] - BYOND v[new_client.byond_version]"
		WRITE_LOG(diary, "ACCESS IN: [message]") //VOREStation Edit

/proc/log_access_out(mob/last_mob)
	if (config.log_access)
		var/message = "[key_name(last_mob)] - IP:[last_mob.lastKnownIP] - CID:Logged Out - BYOND Logged Out"
		WRITE_LOG(diary, "ACCESS OUT: [message]")

/proc/log_say(text, mob/speaker)
	if (config.log_say)
		WRITE_LOG(diary, "SAY: [speaker.simple_info_line()]: [html_decode(text)]")

	//Log the message to in-game dialogue logs, as well.
	if(speaker.client)
		speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"
		GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>SAY:</u> - <span style=\"color:#32cd32\">[text]</span>"

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

/proc/log_attack(attacker, defender, message)
	if (config.log_attack)
		WRITE_LOG(diary, "ATTACK: [attacker] against [defender]: [message]")

/proc/log_adminsay(text, mob/speaker)
	if (config.log_adminchat)
		WRITE_LOG(diary, "ADMINSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_modsay(text, mob/speaker)
	if (config.log_adminchat)
		WRITE_LOG(diary, "MODSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_eventsay(text, mob/speaker)
	if (config.log_adminchat)
		WRITE_LOG(diary, "EVENTSAY: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_ghostsay(text, mob/speaker)
	if (config.log_say)
		WRITE_LOG(diary, "DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - <span style=\"color:green\">[text]</span>"
	GLOB.round_text_log += "<font size=1><span style=\"color:#7e668c\"><b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>DEADSAY:</u> - [text]</span></font>"

/proc/log_ghostemote(text, mob/speaker)
	if (config.log_emote)
		WRITE_LOG(diary, "DEADEMOTE: [speaker.simple_info_line()]: [html_decode(text)]")

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		WRITE_LOG(diary, "ADMINWARN: [html_decode(text)]")

/proc/log_pda(text, mob/speaker)
	if (config.log_pda)
		WRITE_LOG(diary, "PDA: [speaker.simple_info_line()]: [html_decode(text)]")

	speaker.dialogue_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"
	GLOB.round_text_log += "<b>([time_stamp()])</b> (<b>[speaker]/[speaker.client]</b>) <u>MSG:</u> - <span style=\"color:[COLOR_GREEN]\">[text]</span>"

/proc/log_to_dd(text)
	to_world_log(text) //this comes before the config check because it can't possibly runtime
	if(config.log_world_output)
		WRITE_LOG(diary, "DD_OUTPUT: [text]")

/proc/log_error(text)
	to_world_log(text)
	WRITE_LOG(error_log, "RUNTIME: [text]")

/proc/log_misc(text)
	WRITE_LOG(diary, "MISC: [text]")

/proc/log_topic(text)
	if(Debug2)
		WRITE_LOG(diary, "TOPIC: [text]")

/proc/log_unit_test(text)
	to_world_log("## UNIT_TEST: [text]")

#ifdef REFERENCE_TRACKING_LOG
#define log_reftracker(msg) log_world("## REF SEARCH [msg]")
#else
#define log_reftracker(msg)
#endif

/proc/log_asset(text)
	WRITE_LOG(diary, "ASSET: [text]")

/proc/report_progress(var/progress_message)
	admin_notice("<span class='boldannounce'>[progress_message]</span>", R_DEBUG)
	to_world_log(progress_message)

//pretty print a direction bitflag, can be useful for debugging.
/proc/print_dir(var/dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

//more or less a logging utility
//Always return "Something/(Something)", even if it's an error message.
/proc/key_name(var/whom, var/include_link = FALSE, var/include_name = TRUE, var/highlight_special_characters = TRUE)
	var/mob/M
	var/client/C
	var/key

	if(!whom)
		return "INVALID/INVALID"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "INVALID/([D.type])"
	else if(istext(whom))
		return "AUTOMATED/[whom]" //Just give them the text back
	else
		return "INVALID/INVALID"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=\ref[C]'>"

		if(C && C.holder && C.holder.fakekey)
			. += "Administrator"
		else
			. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "INVALID"

	if(include_name)
		var/name = "INVALID"
		if(M)
			if(M.real_name)
				name = M.real_name
			else if(M.name)
				name = M.name

			if(include_link && is_special_character(M) && highlight_special_characters)
				name = "<font color='#FFA500'>[name]</font>" //Orange

		. += "/([name])"

	return .

/proc/key_name_admin(var/whom, var/include_name = 1)
	return key_name(whom, 1, include_name)

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
