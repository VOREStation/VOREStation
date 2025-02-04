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
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(!msg)
		return

	//remove out adminhelp verb temporarily to prevent spamming of admins.
	remove_verb(src,/client/verb/mentorhelp)  //CHOMPEdit
	spawn(600)
		add_verb(src,/client/verb/mentorhelp	) // 1 minute cool-down for mentorhelps //CHOMPEdit

	feedback_add_details("admin_verb","Mentorhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		var/input = tgui_alert(usr, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
		if(!input)
			return
		if(input == "Yes")
			if(current_ticket)
				log_admin("Mentorhelp: [key_name(src)]: [msg]")
				current_ticket.MessageNoRecipient(msg)
				to_chat(usr, span_adminnotice(span_mentor("Mentor-PM to-" + span_bold("Mentors") + ": [msg]")))
				return
			else
				to_chat(usr, span_warning("Ticket not found, creating new one..."))
		else
			current_ticket.AddInteraction("[usr.ckey] opened a new ticket.")
			current_ticket.Resolve()

	new /datum/ticket(msg, src, FALSE, 1)

//admin proc
/client/proc/cmd_mentor_ticket_panel()
	set name = "Mentor Ticket List"
	set category = "Admin.Misc"

	var/browse_to

	switch(tgui_input_list(usr, "Display which ticket list?", "List Choice", list("Active Tickets", "Resolved Tickets")))
		if("Active Tickets")
			browse_to = AHELP_ACTIVE
		if("Resolved Tickets")
			browse_to = AHELP_RESOLVED
		else
			return

	GLOB.tickets.BrowseTickets(browse_to)

/proc/message_mentors(var/msg)
	msg = span_mentor_channel(span_prefix("Mentor:") + span_message("[msg]"))

	for(var/client/C in GLOB.mentors)
		to_chat(C, msg)
	for(var/client/C in GLOB.admins)
		to_chat(C, msg)

//
// CLIENT PROCS
//

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_danger("Error: Admin-PM: You cannot send adminhelps (Muted)."))
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(!msg)
		return

	//remove out adminhelp verb temporarily to prevent spamming of admins.
	remove_verb(src,/client/verb/adminhelp)  //CHOMPEdit
	spawn(1200)
		add_verb(src,/client/verb/adminhelp	) // 2 minute cool-down for adminhelps //CHOMPEdit

	feedback_add_details("admin_verb","Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		var/input = tgui_alert(usr, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
		if(!input)
			return
		if(input == "Yes")
			if(current_ticket)
				current_ticket.MessageNoRecipient(msg)
				to_chat(usr, span_adminnotice("PM to-" + span_bold("Admins") + ": [msg]"))
				return
			else
				to_chat(usr, span_warning("Ticket not found, creating new one..."))
		else
			current_ticket.AddInteraction("[key_name_admin(usr)] opened a new ticket.")
			current_ticket.Close()

	new /datum/ticket(msg, src, FALSE, 0)

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
	if(!CONFIG_GET(string/chat_webhook_url)) // CHOMPEdit
		return

	var/list/adm = get_admin_counts()
	var/list/afkmins = adm["afk"]
	var/list/allmins = adm["total"]

	spawn(0) //Unreliable world.Exports()
		var/query_string = "type=adminhelp"
		query_string += "&key=[url_encode(CONFIG_GET(string/chat_webhook_key))]" // CHOMPEdit
		query_string += "&from=[url_encode(key_name(initiator))]"
		query_string += "&msg=[url_encode(html_decode(name))]"
		query_string += "&admin_number=[allmins.len]"
		query_string += "&admin_number_afk=[afkmins.len]"
		world.Export("[CONFIG_GET(string/chat_webhook_url)]?[query_string]") // CHOMPEdit

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
	remove_verb(usr,/client/verb/adminspice)  //CHOMPEdit
	spawn(10 MINUTES)
		if(usr)		// In case we left in the 10 minute cooldown
			add_verb(usr,/client/verb/adminspice	) // 10 minute cool-down for spice request //CHOMPEdit
