/client
		var/datum/mentor/mentorholder = null

var/list/mentor_datums = list()

var/list/mentor_verbs_default = list(
	/client/proc/cmd_mentor_ticket_panel,
	/client/proc/cmd_mentor_say,
	/client/proc/cmd_dementor
)

/datum/mentor
	var/client/owner	= null

/datum/mentor/New(ckey)
	if(!ckey)
		error("Mentor datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return
	mentor_datums[ckey] = src

/datum/mentor/proc/associate(client/C)
	if(istype(C))
		owner = C
		owner.mentorholder = src
		owner.add_mentor_verbs()
		GLOB.mentors |= C

/datum/mentor/proc/disassociate()
	if(owner)
		GLOB.mentors -= owner
		owner.remove_mentor_verbs()
		owner.mentorholder = null
		mentor_datums[owner.ckey] = null
		qdel(src)

/client/proc/add_mentor_verbs()
	if(mentorholder)
		add_verb(src, mentor_verbs_default)

/client/proc/remove_mentor_verbs()
	if(mentorholder)
		remove_verb(src, mentor_verbs_default)

/client/proc/make_mentor()
	set category = "Admin.Secrets"
	set name = "Make Mentor"
	if(!holder)
		to_chat(src, span_admin_pm_warning("Error: Only administrators may use this command."))
		return
	var/list/client/targets[0]
	for(var/client/T in GLOB.clients)
		targets["[T.key]"] = T
	var/target = tgui_input_list(src,"Who do you want to make a mentor?","Make Mentor", sortList(targets))
	if(!target)
		return
	var/client/C = targets[target]
	if(has_mentor_powers(C) || GLOB.deadmins[C.ckey]) // If an admin is deadminned you could mentor them and that will cause fuckery if they readmin
		to_chat(src, span_admin_pm_warning("Error: They already have mentor powers."))
		return
	var/datum/mentor/M = new /datum/mentor(C.ckey)
	M.associate(C)
	to_chat(C, span_admin_pm_notice("You have been granted mentorship."))
	to_chat(src, span_admin_pm_notice("You have made [C] a mentor."))
	log_admin("[key_name(src)] made [key_name(C)] a mentor.")
	feedback_add_details("admin_verb","Make Mentor") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/unmake_mentor()
	set category = "Admin.Secrets"
	set name = "Unmake Mentor"
	if(!holder)
		to_chat(src, span_admin_pm_warning("Error: Only administrators may use this command."))
		return
	var/list/client/targets[0]
	for(var/client/T in GLOB.mentors)
		targets["[T.key]"] = T
	var/target = tgui_input_list(src,"Which mentor do you want to unmake?","Unmake Mentor", sortList(targets))
	if(!target)
		return
	var/client/C = targets[target]
	C.mentorholder.disassociate()
	to_chat(C, span_admin_pm_warning("Your mentorship has been revoked."))
	to_chat(src, span_admin_pm_notice("You have revoked [C]'s mentorship."))
	log_admin("[key_name(src)] revoked [key_name(C)]'s mentorship.")
	feedback_add_details("admin_verb","Unmake Mentor") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mentor_say(msg as text)
	set category = "Admin.Chat"
	set name ="Mentorsay"

	//check rights
	if (!has_mentor_powers(src))
		return

	msg = sanitize(msg)
	if (!msg)
		return

	log_admin("Mentorsay: [key_name(src)]: [msg]")

	for(var/client/C in GLOB.mentors)
		to_chat(C, create_text_tag("mentor", "MENTOR:", C) + " " + span_mentor_channel(span_name("[src]") + ": " + span_message("[msg]")))
	for(var/client/C in GLOB.admins)
		to_chat(C, create_text_tag("mentor", "MENTOR:", C) + " " + span_mentor_channel(span_name("[src]") + ": " + span_message("[msg]")))

/proc/mentor_commands(href, href_list, client/C)
	if(href_list["ticket"])
		var/ticket_ref = href_list["ticket"]
		var/datum/ticket/T = locate(ticket_ref)
		if (T && istype(T, /datum/ticket))
			T.Action(href_list["ticket_action"])
		else
			to_chat(C, "Ticket [ticket_ref] has been deleted!")

	if (href_list["tickets"])
		GLOB.tickets.BrowseTickets(text2num(href_list["tickets"]))


/datum/mentor/Topic(href, href_list)
	..()
	if (usr.client != src.owner || (!usr.client.mentorholder))
		log_admin("[key_name(usr)] tried to illegally use mentor functions.")
		message_admins("[usr.key] tried to illegally use mentor functions.")
		return

	mentor_commands(href, href_list, usr)

/client/proc/cmd_dementor()
	set category = "Admin.Misc"
	set name = "De-mentor"

	if(tgui_alert(usr, "Confirm self-dementor for the round? You can't re-mentor yourself without someone promoting you.","Dementor",list("Yes","No")) == "Yes")
		src.mentorholder.disassociate()

/client/proc/cmd_mhelp_reply(whom)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_admin_pm_warning("Error: Mentor-PM: You are unable to use admin PM-s (muted)."))
		return
	var/client/C
	if(istext(whom))
		C = GLOB.directory[whom]
	else if(istype(whom,/client))
		C = whom
	if(!C)
		if(has_mentor_powers(src))
			to_chat(src, span_admin_pm_warning("Error: Mentor-PM: Client not found."))
		return

	var/datum/ticket/T = C.current_ticket

	if(T)
		message_mentors(span_mentor_channel("[src] has started replying to [C]'s mentor help."))
	var/msg = tgui_input_text(src,"Message:", "Private message to [C]", multiline = TRUE)
	if (!msg)
		message_mentors(span_mentor_channel("[src] has cancelled their reply to [C]'s mentor help."))
		return
	cmd_mentor_pm(whom, msg, T)

/proc/has_mentor_powers(client/C)
	return C.holder || C.mentorholder

// This not really a great place to put it, but this verb replaces adminhelp in hotkeys so that people requesting help can select the type they need
// You can still directly adminhelp if necessary, this ONLY replaces the inbuilt hotkeys

/client/verb/requesthelp()
	set category = "Admin"
	set name = "Request help"
	set hidden = 1

	var/mhelp = tgui_alert(usr, "Select the help you need.","Request for Help",list("Adminhelp","Mentorhelp"))
	if(!mhelp)
		return

	var/msg = tgui_input_text(usr, "Input your request for help.", "Request for Help ([mhelp])", multiline = TRUE)
	if(!msg)
		return

	if (mhelp == "Mentorhelp")
		mentorhelp(msg)
		return

	adminhelp(msg)


/client/proc/cmd_mentor_pm(whom, msg, datum/ticket/T)
	set category = "Admin"
	set name = "Mentor-PM"
	set hidden = 1

	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_mentor_pm_warning("Error: Mentor-PM: You are unable to use mentor PM-s (muted)."))
		return

	//Not a mentor and no open ticket
	if(!has_mentor_powers(src) && !current_ticket)
		to_chat(src, span_mentor_pm_warning("You can no longer reply to this ticket, please open another one by using the Mentorhelp verb if need be."))
		to_chat(src, span_mentor_pm_notice("Message: [msg]"))
		return

	var/client/recipient

	if(istext(whom))
		recipient = GLOB.directory[whom]

	else if(istype(whom,/client))
		recipient = whom

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = tgui_input_text(src,"Message:", "Mentor-PM to [whom]", multiline = TRUE)

		if(!msg)
			return

		if(prefs.muted & MUTE_ADMINHELP)
			to_chat(src, span_mentor_pm_warning("Error: Mentor-PM: You are unable to use mentor PM-s (muted)."))
			return

		if(!recipient)
			if(has_mentor_powers(src))
				to_chat(src, span_mentor_pm_warning("Error:Mentor-PM: Client not found."))
				to_chat(src, msg)
			else
				log_admin("Mentorhelp: [key_name(src)]: [msg]")
				current_ticket.MessageNoRecipient(msg)
			return

	//Has mentor powers but the recipient no longer has an open ticket
	if(has_mentor_powers(src) && !recipient.current_ticket)
		to_chat(src, span_mentor_pm_warning("You can no longer reply to this ticket."))
		to_chat(src, span_mentor_pm_notice("Message: [msg]"))
		return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = trim(sanitize(copytext(msg,1,MAX_MESSAGE_LEN)))
	if(!msg)
		return

	var/interaction_message = span_mentor_pm_notice("Mentor-PM from-<b>[src]</b> to-<b>[recipient]</b>: [msg]")

	if (recipient.current_ticket && !has_mentor_powers(recipient))
		recipient.current_ticket.AddInteraction(interaction_message)
	if (src.current_ticket && !has_mentor_powers(src))
		src.current_ticket.AddInteraction(interaction_message)

	// It's a little fucky if they're both mentors, but while admins may need to adminhelp I don't really see any reason a mentor would have to mentorhelp since you can literally just ask any other mentors online
	if (has_mentor_powers(recipient) && has_mentor_powers(src))
		if (recipient.current_ticket)
			recipient.current_ticket.AddInteraction(interaction_message)
		if (src.current_ticket)
			src.current_ticket.AddInteraction(interaction_message)

	to_chat(recipient, span_mentor(span_italics("Mentor-PM from-<b><a href='byond://?mentorhelp_msg=\ref[src]'>[src]</a></b>: [msg]")))
	to_chat(src, span_mentor(span_italics("Mentor-PM to-<b>[recipient]</b>: [msg]")))

	log_admin("[key_name(src)]->[key_name(recipient)]: [msg]")

	if(recipient.prefs?.read_preference(/datum/preference/toggle/play_mentorhelp_ping))
		recipient << 'sound/effects/mentorhelp.mp3'

	for(var/client/C in GLOB.mentors)
		if (C != recipient && C != src)
			to_chat(C, interaction_message)
	for(var/client/C in GLOB.admins)
		if (C != recipient && C != src)
			to_chat(C, interaction_message)
