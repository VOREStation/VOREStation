//VOREStation Edit - Most of this file has been changed to use the Eris-style PA announcements.
//You'll need to compare externally, or use your best judgement when merging.
GLOBAL_DATUM_INIT(priority_announcement, /datum/announcement/priority, new(do_log = 0))
GLOBAL_DATUM_INIT(command_announcement, /datum/announcement/priority/command, new(do_log = 0, do_newscast = 1))

/datum/announcement
	var/title = "Attention"
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	var/channel_name = "Station Announcements"
	var/announcement_type = "Announcement"

/datum/announcement/New(do_log = 0, new_sound = null, do_newscast = 0)
	sound = new_sound
	log = do_log
	newscast = do_newscast

/datum/announcement/priority/New(do_log = 1, new_sound, do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"

/datum/announcement/priority/command/New(do_log = 1, new_sound, do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "[command_name()] Update"
	announcement_type = "[command_name()] Update"

/datum/announcement/priority/security/New(do_log = 1, new_sound, do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/announcement/proc/Announce(message as text, new_title = "", new_sound = null, do_newscast = newscast, msg_sanitized = 0, zlevel)
	if(!message)
		return

	var/message_title = new_title ? new_title : title
	var/message_sound = new_sound ? new_sound : sound
	if(istext(message_sound)) // Get the announcer voice line if it's a key
		message_sound = announcer_library_get_voiceline(message_sound)

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
		message_title = sanitizeSafe(message_title)

	var/list/zlevels
	if(zlevel)
		zlevels = using_map.get_map_levels(zlevel, TRUE)

	Message(message, message_title, zlevels)
	if(do_newscast)
		NewsCast(message, message_title)
	Sound(message_sound, zlevels)
	Log(message, message_title)

/datum/announcement/proc/Message(message as text, message_title as text, list/zlevels)
	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && !isdeaf(M))
			to_chat(M, "<h2 class='alert'>[title]</h2>")
			to_chat(M, span_alert("[message]"))
			if (announcer)
				to_chat(M, span_alert(" -[html_encode(announcer)]"))

// You'll need to update these to_world usages if you want to make these z-level specific ~Aro
/datum/announcement/minor/Message(message as text, message_title as text)
	to_chat(world, span_bold("[message]"))

/datum/announcement/priority/Message(message as text, message_title as text)
	to_chat(world, "<h1 class='alert'>[message_title]</h1>")
	to_chat(world, span_alert("[message]"))
	if(announcer)
		to_chat(world, span_alert(" -[html_encode(announcer)]"))
	to_chat(world, span_alert("<br>"))

/datum/announcement/priority/command/Message(message as text, message_title as text, list/zlevels)
	var/command
	command += "<h1 class='alert'>[command_name()] Update</h1>"
	if (message_title)
		command += "<br><h2 class='alert'>[message_title]</h2>"

	command += "<br>[span_alert(message)]<br>"
	command += "<br>"
	for(var/mob/M in GLOB.player_list)
		if(zlevels && !(get_z(M) in zlevels))
			continue
		if(!isnewplayer(M) && !isdeaf(M))
			to_chat(M, command)

/datum/announcement/priority/Message(message as text, message_title as text, list/zlevels)
	GLOB.global_announcer.autosay(span_alert("[message_title]:") + " [message]", announcer ? announcer : ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)

/datum/announcement/priority/command/Message(message as text, message_title as text, list/zlevels)
	GLOB.global_announcer.autosay(span_alert("[command_name()] - [message_title]:") + " [message]", ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)

/datum/announcement/priority/security/Message(message as text, message_title as text, list/zlevels)
	GLOB.global_announcer.autosay(span_alert("[message_title]:") + " [message]", ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)

/datum/announcement/proc/NewsCast(message as text, message_title as text)
	if(!newscast)
		return

	var/datum/news_announcement/news = new
	news.channel_name = channel_name
	news.author = announcer
	news.message = message
	news.message_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

/datum/announcement/proc/PlaySound(message_sound, list/zlevels)
	var/preamble_sound = announcer_message_preamble()
	if(preamble_sound) // Downstreams might disable this
		for(var/mob/M in GLOB.player_list)
			if(zlevels && !(M.z in zlevels))
				continue
			if(!isnewplayer(M) && !isdeaf(M))
				SEND_SOUND(M, preamble_sound)

	if(!message_sound)
		return
	addtimer(CALLBACK(src, PROC_REF(internal_postfire_play_sound), message_sound, zlevels), announcer_message_preamble_delay())

/datum/announcement/proc/internal_postfire_play_sound(message_sound, list/zlevels)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	for(var/mob/M in GLOB.player_list)
		if(zlevels && !(M.z in zlevels))
			continue
		if(!isnewplayer(M) && !isdeaf(M))
			SEND_SOUND(M, message_sound)

/datum/announcement/proc/Sound(message_sound, list/zlevels)
	PlaySound(message_sound, zlevels)

/datum/announcement/proc/Log(message as text, message_title as text)
	if(log)
		log_game("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)

/proc/GetNameAndAssignmentFromId(obj/item/card/id/I)
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	return I.assignment ? "[I.registered_name] ([I.assignment])" : I.registered_name

/proc/level_seven_announcement()
	GLOB.command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard \the [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = ANNOUNCER_MSG_BIOHAZARD_SEVEN)

/proc/ion_storm_announcement()
	GLOB.command_announcement.Announce("It has come to our attention that \the [station_name()] passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert")

/proc/AnnounceArrival(mob/living/carbon/human/character, rank, join_message, channel = "Common", zlevel)
	if (SSticker.current_state == GAME_STATE_PLAYING)
		if(character.client?.prefs?.read_preference(/datum/preference/toggle/living/radio_announce) == FALSE)
			var/datum/job/announce_job = SSjob.get_job(character.mind?.assigned_role)
			if(!announce_job || announce_job.title == JOB_ALT_VISITOR)
				return
		var/list/zlevels = zlevel ? using_map.get_map_levels(zlevel, TRUE, om_range = DEFAULT_OVERMAP_RANGE) : null
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		AnnounceArrivalSimple(character.real_name, rank, join_message, channel, zlevels)

/proc/AnnounceArrivalSimple(name, rank = "visitor", join_message = "will arrive at the station shortly", channel = "Common", list/zlevels)
	GLOB.global_announcer.autosay("[name], [rank], [join_message].", "Arrivals Announcement Computer", channel, zlevels)
