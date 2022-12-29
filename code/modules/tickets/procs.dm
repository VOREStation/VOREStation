//
// CLIENT PROCS
//

/client/verb/mentorhelp(msg as text)
	set category = "Admin"
	set name = "Mentorhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Mentor-PM: You cannot send adminhelps (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(!msg)
		return

	//remove out adminhelp verb temporarily to prevent spamming of admins.
	src.verbs -= /client/verb/mentorhelp
	spawn(600)
		src.verbs += /client/verb/mentorhelp	// 1 minute cool-down for mentorhelps

	feedback_add_details("admin_verb","Mentorhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		if(tgui_alert(usr, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No")) != "No")
			if(current_ticket)
				log_admin("Mentorhelp: [key_name(src)]: [msg]")
				current_ticket.MessageNoRecipient(msg)
				to_chat(usr, "<span class='adminnotice'><span class='mentor'>Mentor-PM to-<b>Mentors</b>: [msg]</span></span>")
				return
			else
				to_chat(usr, "<span class='warning'>Ticket not found, creating new one...</span>")
		else
			current_ticket.AddInteraction("[usr.ckey] opened a new ticket.")
			current_ticket.Resolve()

	new /datum/ticket(msg, src, FALSE, 1)

//admin proc
/client/proc/cmd_mentor_ticket_panel()
	set name = "Mentor Ticket List"
	set category = "Admin"

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
	msg = "<span class='mentor_channel'><span class='prefix'>Mentor:</span> <span class=\"message\">[msg]</span></span>"

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

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(!msg)
		return

	//remove out adminhelp verb temporarily to prevent spamming of admins.
	src.verbs -= /client/verb/adminhelp
	spawn(1200)
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps

	feedback_add_details("admin_verb","Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		if(tgui_alert(usr, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No")) != "No")
			if(current_ticket)
				current_ticket.MessageNoRecipient(msg)
				to_chat(usr, "<span class='adminnotice'>PM to-<b>Admins</b>: [msg]</span>")
				return
			else
				to_chat(usr, "<span class='warning'>Ticket not found, creating new one...</span>")
		else
			current_ticket.AddInteraction("[key_name_admin(usr)] opened a new ticket.")
			current_ticket.Close()

	new /datum/ticket(msg, src, FALSE, 0)

//admin proc
/client/proc/cmd_admin_ticket_panel()
	set name = "Show Ticket List"
	set category = "Admin"

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
	if(!config.chat_webhook_url)
		return

	var/list/adm = get_admin_counts()
	var/list/afkmins = adm["afk"]
	var/list/allmins = adm["total"]

	spawn(0) //Unreliable world.Exports()
		var/query_string = "type=adminhelp"
		query_string += "&key=[url_encode(config.chat_webhook_key)]"
		query_string += "&from=[url_encode(key_name(initiator))]"
		query_string += "&msg=[url_encode(html_decode(name))]"
		query_string += "&admin_number=[allmins.len]"
		query_string += "&admin_number_afk=[afkmins.len]"
		world.Export("[config.chat_webhook_url]?[query_string]")

/client/verb/adminspice()
	set category = "Admin"
	set name = "Request Spice"
	set desc = "Request admins to spice round up for you"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(usr, "<span class='danger'>Error: You cannot request spice (muted from adminhelps).</span>")
		return

	if(tgui_alert(usr, "Are you sure you want to request the admins spice things up for you? You accept the consequences if you do.","Spicy!",list("Yes","No")) != "No")
		message_admins("[ADMIN_FULLMONTY(usr)] has requested the round be spiced up a little.")
		to_chat(usr, "<span class='notice'>You have requested some more spice in your round.</span>")
	else
		to_chat(usr, "<span class='notice'>Spice request cancelled.</span>")
		return

	//if they requested spice, then remove spice verb temporarily to prevent spamming
	usr.verbs -= /client/verb/adminspice
	spawn(10 MINUTES)
		if(usr)		// In case we left in the 10 minute cooldown
			usr.verbs += /client/verb/adminspice	// 10 minute cool-down for spice request
