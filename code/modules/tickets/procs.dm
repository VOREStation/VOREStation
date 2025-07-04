//
// CLIENT PROCS
//

/client/verb/mentorhelp(msg as text)
	set category = "Admin"
	set name = "Mentorhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_danger("Error: Mentor-PM: You cannot send adminhelps (Muted)."))
		return
	if(handle_spam_prevention(MUTE_ADMINHELP))
		return

	if(!msg)
		return

	//remove out adminhelp verb temporarily to prevent spamming of admins.
	remove_verb(src,/client/verb/mentorhelp)
	spawn(600)
		add_verb(src,/client/verb/mentorhelp	) // 1 minute cool-down for mentorhelps

	feedback_add_details("admin_verb","Mentorhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		var/input = tgui_alert(src, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
		if(!input)
			return
		if(input == "Yes")
			if(current_ticket)
				log_admin("Mentorhelp: [key_name(src)]: [msg]")
				current_ticket.MessageNoRecipient(msg)
				to_chat(src, span_adminnotice(span_mentor("Mentor-PM to-" + span_bold("Mentors") + ": [msg]")))
				return
			else
				to_chat(src, span_warning("Ticket not found, creating new one..."))
		else
			current_ticket.AddInteraction("[usr.ckey] opened a new ticket.")
			current_ticket.Resolve()

	new /datum/ticket(msg, src, FALSE, 0)

//admin proc
ADMIN_VERB(cmd_mentor_ticket_panel, (R_ADMIN|R_SERVER|R_MOD|R_MENTOR), "Mentor Ticket List", "Opens the list of mentor tickets", "Admin.Misc")
	var/browse_to

	switch(tgui_input_list(user, "Display which ticket list?", "List Choice", list("Active Tickets", "Resolved Tickets")))
		if("Active Tickets")
			browse_to = AHELP_ACTIVE
		if("Resolved Tickets")
			browse_to = AHELP_RESOLVED
		else
			return

	GLOB.tickets.BrowseTickets(browse_to)

/proc/message_mentors(var/msg)
	msg = span_mentor_channel(span_prefix("Mentor: ") + span_message("[msg]"))

	for(var/client/C in GLOB.admins)
		to_chat(C, msg)

//
// CLIENT PROCS
//

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

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_danger("Error: Admin-PM: You cannot send adminhelps (Muted)."))
		return
	if(handle_spam_prevention(MUTE_ADMINHELP))
		return

	if(!msg)
		return

	//remove out adminhelp verb temporarily to prevent spamming of admins.
	remove_verb(src,/client/verb/adminhelp)
	spawn(1200)
		add_verb(src,/client/verb/adminhelp	) // 2 minute cool-down for adminhelp

	feedback_add_details("admin_verb","Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		var/input = tgui_alert(src, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
		if(!input)
			return
		if(input == "Yes")
			if(current_ticket)
				current_ticket.MessageNoRecipient(msg)
				to_chat(src, span_adminnotice("PM to-" + span_bold("Admins") + ": [msg]"))
				return
			else
				to_chat(src, span_warning("Ticket not found, creating new one..."))
		else if(current_ticket)
			current_ticket.AddInteraction("[key_name_admin(usr)] opened a new ticket.")
			current_ticket.Close()

	new /datum/ticket(msg, src, FALSE, 1)

//admin proc
/client/proc/cmd_admin_ticket_panel()
	set name = "Show Ticket List"
	set category = "Admin.Misc"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT, TRUE))
		return

	var/browse_to

	switch(tgui_input_list(usr, "Display which ticket list?", "List Choice", list("Active Tickets", "Closed Tickets", "Resolved Tickets")))
		if("Active Tickets")
			browse_to = AHELP_ACTIVE
		if("Closed Tickets")
			browse_to = AHELP_CLOSED
		if("Resolved Tickets")
			browse_to = AHELP_RESOLVED
		else
			return

	GLOB.tickets.BrowseTickets(browse_to)

//// VOREstation Additions Below

/datum/ticket/proc/send2adminchat()
	if(!CONFIG_GET(string/chat_webhook_url))
		return

	var/list/adm = get_admin_counts()
	var/list/afkmins = adm["afk"]
	var/list/allmins = adm["total"]

	spawn(0) //Unreliable world.Exports()
		var/query_string = "type=adminhelp"
		query_string += "&key=[url_encode(CONFIG_GET(string/chat_webhook_key))]"
		query_string += "&from=[url_encode(key_name(initiator))]"
		query_string += "&msg=[url_encode(html_decode(name))]"
		query_string += "&admin_number=[allmins.len]"
		query_string += "&admin_number_afk=[afkmins.len]"
		world.Export("[CONFIG_GET(string/chat_webhook_url)]?[query_string]")

/client/verb/adminspice()
	set category = "Admin"
	set name = "Request Spice"
	set desc = "Request admins to spice round up for you"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(usr, span_danger("Error: You cannot request spice (muted from adminhelps)."))
		return

	if(tgui_alert(usr, "Are you sure you want to request the admins spice things up for you? You accept the consequences if you do.","Spicy!",list("Yes","No")) == "Yes")
		message_admins("[ADMIN_FULLMONTY(usr)] has requested the round be spiced up a little.")
		to_chat(usr, span_notice("You have requested some more spice in your round."))
	else
		to_chat(usr, span_notice("Spice request cancelled."))
		return

	//if they requested spice, then remove spice verb temporarily to prevent spamming
	remove_verb(usr,/client/verb/adminspice)
	spawn(10 MINUTES)
		if(usr)		// In case we left in the 10 minute cooldown
			add_verb(usr,/client/verb/adminspice	) // 10 minute cool-down for spice request

//
// MENTOR PROCS
//

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
		if(src.holder)
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

/client/proc/cmd_mentor_pm(whom, msg, datum/ticket/T)
	set category = "Admin"
	set name = "Mentor-PM"
	set hidden = 1

	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_mentor_warning("Error: Mentor-PM: You are unable to use mentor PM-s (muted)."))
		return

	//Not a mentor and no open ticket
	if(!src.holder && !current_ticket)
		to_chat(src, span_mentor_warning("You can no longer reply to this ticket, please open another one by using the Mentorhelp verb if need be."))
		to_chat(src, span_mentor_notice("Message: [msg]"))
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
			to_chat(src, span_mentor_warning("Error: Mentor-PM: You are unable to use mentor PM-s (muted)."))
			return

		if(!recipient)
			if(src.holder)
				to_chat(src, span_mentor_warning("Error:Mentor-PM: Client not found."))
				to_chat(src, msg)
			else
				log_admin("Mentorhelp: [key_name(src)]: [msg]")
				current_ticket.MessageNoRecipient(msg)
			return

	//Has mentor powers but the recipient no longer has an open ticket
	if(src.holder && !recipient.current_ticket)
		to_chat(src, span_mentor_warning("You can no longer reply to this ticket."))
		to_chat(src, span_mentor_notice("Message: [msg]"))
		return

	if (src.handle_spam_prevention(MUTE_ADMINHELP))
		return

	msg = trim(sanitize(copytext(msg,1,MAX_MESSAGE_LEN)))
	if(!msg)
		return

	var/interaction_message = span_mentor_notice("Mentor-PM from-<b>[src]</b> to-<b>[recipient]</b>: [msg]")

	if (recipient.current_ticket && !recipient.holder && recipient.current_ticket.level == 0)
		recipient.current_ticket.AddInteraction(interaction_message)
	if (src.current_ticket && !src.holder && src.current_ticket.level == 0)
		src.current_ticket.AddInteraction(interaction_message)

	// It's a little fucky if they're both mentors, but while admins may need to adminhelp I don't really see any reason a mentor would have to mentorhelp since you can literally just ask any other mentors online
	if (recipient.holder && src.holder)
		if (recipient.current_ticket && recipient != src && recipient.current_ticket.level == 0)
			recipient.current_ticket.AddInteraction(interaction_message)
		if (src.current_ticket && src.current_ticket.level == 0)
			src.current_ticket.AddInteraction(interaction_message)

	to_chat(recipient, span_mentor(span_italics("Mentor-PM from-<b><a href='byond://?mentorhelp_msg=\ref[src]'>[src]</a></b>: [msg]")))
	to_chat(src, span_mentor(span_italics("Mentor-PM to-<b>[recipient]</b>: [msg]")))

	log_admin("[key_name(src)]->[key_name(recipient)]: [msg]")

	if(recipient.prefs?.read_preference(/datum/preference/toggle/play_mentorhelp_ping))
		recipient << 'sound/effects/mentorhelp.mp3'

	for(var/client/C in GLOB.admins)
		if (C != recipient && C != src)
			to_chat(C, interaction_message)
