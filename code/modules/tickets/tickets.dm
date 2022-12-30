/client/var/datum/ticket/current_ticket	//the current ticket the (usually) not-admin client is dealing with
/client/var/datum/ticket/selected_ticket //the current ticket being viewed in the Tickets Panel (usually) admin/mentor client

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(tickets, /datum/tickets, new)

/datum/tickets
	var/list/active_tickets = list()
	var/list/closed_tickets = list()
	var/list/resolved_tickets = list()

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, AHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, AHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, AHELP_RESOLVED)

/datum/tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(closed_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

//private
/datum/tickets/proc/ListInsert(datum/ticket/new_ticket)
	var/list/ticket_list
	switch(new_ticket.state)
		if(AHELP_ACTIVE)
			ticket_list = active_tickets
		if(AHELP_CLOSED)
			ticket_list = closed_tickets
		if(AHELP_RESOLVED)
			ticket_list = resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = ticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/ticket/T = ticket_list[I]
			if(T.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

/datum/tickets/proc/BrowseTickets(state)
	tgui_interact(usr)

//opens the ticket listings for one of the 3 states
/datum/tickets/proc/BrowseTicketsLegacy(state)
	var/list/l2b
	var/title
	switch(state)
		if(AHELP_ACTIVE)
			l2b = active_tickets
			title = "Active Tickets"
		if(AHELP_CLOSED)
			l2b = closed_tickets
			title = "Closed Tickets"
		if(AHELP_RESOLVED)
			l2b = resolved_tickets
			title = "Resolved Tickets"
	if(!l2b)
		return
	var/list/dat = list("<html><head><title>[title]</title></head>")
	dat += "<A HREF='?_src_=holder;[HrefToken()];ahelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/datum/ticket/T as anything in l2b)
		dat += "<span class='adminnotice'><span class='adminhelp'>Ticket #[T.id]</span>: <A HREF='?_src_=holder;ahelp=\ref[T];[HrefToken()];ahelp_action=ticket'>[T.initiator_key_name]: [T.name]</A></span><br>"

	usr << browse(dat.Join(), "window=ahelp_list[state];size=600x480")

//Tickets statpanel
/datum/tickets/proc/stat_entry()
	var/num_disconnected = 0
	stat("== Tickets ==")
	stat("Active Tickets:", astatclick.update("[active_tickets.len]"))
	for(var/datum/ticket/T as anything in active_tickets)
		if(T.initiator)
			var/type = "N/A"
			switch(T.level)
				if(0)
					type = "ADM"
				if(1)
					type = "MEN"

			if(usr.client.holder || T.level > 0)
				stat("\[[type]\] #[T.id]. [T.initiator_key_name]:", T.statclick.update())
		else
			++num_disconnected
	if(num_disconnected)
		stat("Disconnected:", astatclick.update("[num_disconnected]"))
	stat("Closed Tickets:", cstatclick.update("[closed_tickets.len]"))
	stat("Resolved Tickets:", rstatclick.update("[resolved_tickets.len]"))

//Reassociate still open ticket if one exists
/datum/tickets/proc/ClientLogin(client/C)
	C.current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.AddInteraction("Client reconnected.")
		C.current_ticket.initiator = C

//Dissasociate ticket
/datum/tickets/proc/ClientLogout(client/C)
	if(C.current_ticket)
		C.current_ticket.AddInteraction("Client disconnected.")
		C.current_ticket.initiator = null
		C.current_ticket = null

//Get a ticket given a ckey
/datum/tickets/proc/CKey2ActiveTicket(ckey)
	if(!usr.client.holder || !has_mentor_powers(usr.client))
		message_admins("[usr] has attempted to look up a ticket with CKEY [ckey] without sufficent privileges.")
		return

	for(var/datum/ticket/T as anything in active_tickets)
		if(T.initiator_ckey == ckey)
			return T

//Get a ticket by ticket id
/datum/tickets/proc/ID2Ticket(id)
	if(!usr.client.holder || !has_mentor_powers(usr.client))
		message_admins("[usr] has attempted to look up a ticket with ID [id] without sufficent privileges.")
		return

	for(var/datum/ticket/T as anything in active_tickets)
		if(T.id == id)
			return T

	for(var/datum/ticket/T as anything in resolved_tickets)
		if(T.id == id)
			return T

	for(var/datum/ticket/T as anything in closed_tickets)
		if(T.id == id)
			return T

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_state

/obj/effect/statclick/ticket_list/New(loc, name, state)
	current_state = state
	..()

/obj/effect/statclick/ticket_list/Click()
	GLOB.tickets.BrowseTickets(current_state)

//
//TICKET DATUM
//

/datum/ticket
	var/id
	var/name
	var/level = 0 // 0 = Admin, 1 = Mentor
	var/list/tags
	var/state = AHELP_ACTIVE

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who ahelped/was bwoinked
	var/handler = "/Unassigned\\" // The admin handling the ticket
	var/initiator_ckey
	var/initiator_key_name

	var/list/_interactions	//use AddInteraction() or, preferably, admin_ticket_log()

	var/obj/effect/statclick/ticket/statclick

	var/static/ticket_counter = 0

/*
//call this on its own to create a ticket, don't manually assign current_mentorhelp
//msg is the title of the ticket: usually the ahelp text
/datum/mentor_help/New(msg, client/C)

	initiator_ckey = C.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_mentorhelp)	//This is a bug
		log_debug("Ticket erroneously left open by code")
		initiator.current_mentorhelp.AddInteraction("Ticket erroneously left open by code")
		initiator.current_mentorhelp.Resolve()
	initiator.current_mentorhelp = src

	statclick = new(null, src)
	_interactions = list()

	log_admin("Mentorhelp: [key_name(C)]: [msg]")
	MessageNoRecipient(msg)
	//show it to the person adminhelping too
	to_chat(C, "<i><span class='mentor'>Mentor-PM to-<b>Mentors</b>: [name]</span></i>")

	GLOB.mhelp_tickets.active_tickets += src */

/**
 * public
 *
 * Create a new Ticket.
 * Call this on its own to create a ticket, don't manually assign current_ticket
 *
 * required msg string The title of the ticket: usually the ahelp text
 * required C client The object or datum which owns the UI.
 * required is_bwoink boolean TRUE if this ticket was started by an admin PM
 * required level integer The level of the ticket. 0 = Admin, 1 = Mentor
 */
/datum/ticket/New(msg, client/C, is_bwoink, ticket_level)
	//clean the input msg
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = msg

	level = ticket_level

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_ticket)	//This is a bug
		log_debug("Multiple ahelp current_tickets")
		initiator.current_ticket.AddInteraction("Ticket erroneously left open by code")
		initiator.current_ticket.Close()
	initiator.current_ticket = src

	var/parsed_message = keywords_lookup(msg)

	statclick = new(null, src)
	_interactions = list()

	if(is_bwoink)
		AddInteraction("<font color='blue'>[key_name_admin(usr)] PM'd [LinkedReplyName()]</font>")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
	else
		MessageNoRecipient(parsed_message)
		send2adminchat() //VOREStation Add
		//show it to the person adminhelping too
		to_chat(C, "<span class='adminnotice'>PM to-<b>Admins</b>: [name]</span>")

		//send it to irc if nobody is on and tell us how many were on
		var/admin_number_present = send2irc_adminless_only(initiator_ckey, name)
		log_admin("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(C, "<span class='notice'>No active admins are online, your adminhelp was sent to the admin discord.</span>")		//VOREStation Edit

		// Also send it to discord since that's the hip cool thing now.
		SSwebhooks.send(
			WEBHOOK_AHELP_SENT,
			list(
				"name" = "Ticket ([id]) (Game ID: [game_id]) ticket opened.",
				"body" = "[key_name(initiator)] has opened a ticket. \n[msg]",
				"color" = COLOR_WEBHOOK_POOR
			)
		)

	GLOB.tickets.active_tickets += src

/datum/ticket/Destroy()
	RemoveActive()
	GLOB.tickets.closed_tickets -= src
	GLOB.tickets.resolved_tickets -= src
	return ..()

/datum/ticket/proc/AddInteraction(formatted_message)
	_interactions += "[gameTimestamp()]: [formatted_message]"

/datum/ticket/proc/TicketPanel()
	tgui_interact(usr.client.mob)

//private
/datum/ticket/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	if(initiator && initiator.mob)
		. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	else
		. = "Initiator disconnected."
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/ticket/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"

	if(level == 0)
		. = " (<A HREF='?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=reject'>REJT</A>)"
		. += " (<A HREF='?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=icissue'>IC</A>)"
		. += " (<A HREF='?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=close'>CLOSE</A>)"
		. += " (<A HREF='?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=resolve'>RSLVE</A>)"
		. += " (<A HREF='?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=handleissue'>HANDLE</A>)"
	else
		. = " (<A HREF='?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=resolve'>RSLVE</A>)"

//private
/datum/ticket/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A HREF='?_src_=holder;ticket=[ref_src];ticket_action=reply'>[initiator_key_name]</A>"

//private
/datum/ticket/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A HREF='?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=[action]'>[msg]</A>"

/*

	var/chat_msg = "<span class='notice'>(<A HREF='?_src_=mentorholder;mhelp=[ref_src];[HrefToken(TRUE)];mhelp_action=escalate'>ESCALATE</A>) Ticket [TicketHref("#[id]", ref_src)]<b>: [LinkedReplyName(ref_src)]:</b> [msg]</span>"

	 */

//message from the initiator without a target, all admins will see this
//won't bug irc
/datum/ticket/proc/MessageNoRecipient(msg)
	var/ref_src = "\ref[src]"
	var/chat_msg = "<span class='adminnotice'><span class='adminhelp'>Ticket [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:</b> [msg]</span>"

	AddInteraction("<font color='red'>[LinkedReplyName(ref_src)]: [msg]</font>")
	//send this msg to all admins

	if(level == 1)
		for (var/client/C in GLOB.mentors)
			if (C.is_preference_enabled(/datum/client_preference/play_mentorhelp_ping))
				C << 'sound/effects/mentorhelp.mp3'
		for (var/client/C in GLOB.admins)
			if (C.is_preference_enabled(/datum/client_preference/play_mentorhelp_ping))
				C << 'sound/effects/mentorhelp.mp3'
		message_mentors(chat_msg)
	else if(level == 0)
		for(var/client/X in GLOB.admins)
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp.ogg'
			window_flash(X)
			to_chat(X, chat_msg)

/*
//Reopen a closed ticket
/datum/mentor_help/proc/Reopen()
	switch(state)
		if(AHELP_RESOLVED)
			feedback_dec("mhelp_resolve")

	AddInteraction("<font color='purple'>Reopened by [usr.ckey]</font>")
	if(initiator)
		to_chat(initiator, "<span class='filter_adminlog'><font color='purple'>Ticket [TicketHref("#[id]")] was reopened by [usr.ckey].</font></span>")
	var/msg = "<span class='adminhelp'>Ticket [TicketHref("#[id]")] reopened by [usr.ckey].</span>"
	message_mentors(msg)
	log_admin(msg)

	*/

//Reopen a closed ticket
/datum/ticket/proc/Reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, "<span class='warning'>This ticket is already open.</span>")
		return

	if(GLOB.tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, "<span class='warning'>This user already has an active ticket, cannot reopen this one.</span>")
		return

	statclick = new(null, src)
	GLOB.tickets.active_tickets += src
	GLOB.tickets.closed_tickets -= src
	GLOB.tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_CLOSED)
			feedback_dec("ticket_close")
		if(AHELP_RESOLVED)
			feedback_dec("ticket_resolve")
	state = AHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_ticket = src

	AddInteraction("<font color='purple'>Reopened by [key_name_admin(usr)]</font>")
	if(initiator)
		to_chat(initiator, "<span class='filter_adminlog'><font color='purple'>Ticket [TicketHref("#[id]")] was reopened by [key_name(usr,FALSE,FALSE)].</font></span>")
	var/msg = "<span class='adminhelp'>Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].</span>"
	message_admins(msg)
	log_admin(msg)
	feedback_inc("ticket_reopen")
	TicketPanel()	//can only be done from here, so refresh it

	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Game ID: [game_id]) reopened.",
			"body" = "Reopened by [key_name(usr)]."
		)
	)

//private
/datum/ticket/proc/RemoveActive()
	if(state != AHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.tickets.active_tickets -= src
	if(initiator && initiator.current_ticket == src)
		initiator.current_ticket = null

//Mark open ticket as closed/meme
/datum/ticket/proc/Close(silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_CLOSED
	GLOB.tickets.ListInsert(src)
	AddInteraction("<span class='filter_adminlog'><font color='red'>Closed by [key_name_admin(usr)].</font></span>")
	if(initiator)
		to_chat(initiator, "<span class='filter_adminlog'><font color='red'>Ticket [TicketHref("#[id]")] was closed by [key_name(usr,FALSE,FALSE)].</font></span>")
	if(!silent)
		feedback_inc("ahelp_close")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name_admin(usr)]."
		message_admins(msg)
		log_admin(msg)
		SSwebhooks.send(
			WEBHOOK_AHELP_SENT,
			list(
				"name" = "Ticket ([id]) (Game ID: [game_id]) closed.",
				"body" = "Closed by [key_name(usr)].",
				"color" = COLOR_WEBHOOK_BAD
			)
		)

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/ticket/proc/Resolve(silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.tickets.ListInsert(src)

	AddInteraction("<span class='filter_adminlog'><font color='green'>Resolved by [key_name_admin(usr)].</font></span>")
	if(initiator)
		to_chat(initiator, "<span class='filter_adminlog'><font color='green'>Ticket [TicketHref("#[id]")] was marked resolved by [key_name(usr,FALSE,FALSE)].</font></span>")
	if(!silent)
		feedback_inc("ticket_resolve")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name_admin(usr)]"
		if(type == 1)
			message_mentors(msg)
		else if (type == 0)
			message_admins(msg)

		log_admin(msg)
		if(type == 1)
			SSwebhooks.send(
				WEBHOOK_AHELP_SENT,
				list(
					"name" = "Ticket ([id]) (Game ID: [game_id]) resolved.",
					"body" = "Marked as Resolved by [key_name(usr)].",
					"color" = COLOR_WEBHOOK_GOOD
				)
			)

//Close and return ahelp verb, use if ticket is incoherent
/datum/ticket/proc/Reject(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	if(initiator)
		if(initiator.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
			initiator << 'sound/effects/adminhelp.ogg'

		to_chat(initiator, "<span class='filter_pm'><font color='red' size='4'><b>- AdminHelp Rejected! -</b></font><br>\
							<font color='red'><b>Your admin help was rejected.</b></font><br>\
							Please try to be calm, clear, and descriptive in admin helps, do not assume the admin has seen any related events, and clearly state the names of anybody you are reporting.</span>")

	feedback_inc("ahelp_reject")
	var/msg = "Ticket [TicketHref("#[id]")] rejected by [key_name_admin(usr)]"
	message_admins(msg)
	log_admin(msg)
	AddInteraction("Rejected by [key_name_admin(usr)].")
	Close(silent = TRUE)
	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Game ID: [game_id]) rejected.",
			"body" = "Rejected by [key_name(usr)].",
			"color" = COLOR_WEBHOOK_BAD
		)
	)

//Resolve ticket with IC Issue message
/datum/ticket/proc/ICIssue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<span class='filter_pm'><font color='red' size='4'><b>- AdminHelp marked as IC issue! -</b></font><br>"
	msg += "<font color='red'><b>This is something that can be solved ICly, and does not currently require staff intervention.</b></font><br>"
	msg += "<font color='red'>Your AdminHelp may also be unanswerable due to ongoing events.</font></span>"

	if(initiator)
		to_chat(initiator, msg)

	feedback_inc("ahelp_icissue")
	msg = "Ticket [TicketHref("#[id]")] marked as IC by [key_name_admin(usr)]"
	message_admins(msg)
	log_admin(msg)
	AddInteraction("Marked as IC issue by [key_name_admin(usr)]")
	Resolve(silent = TRUE)
	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Game ID: [game_id]) marked as IC issue.",
			"body" = "Marked as IC Issue by [key_name(usr)].",
			"color" = COLOR_WEBHOOK_BAD
		)
	)

//Resolve ticket with IC Issue message
/datum/ticket/proc/HandleIssue()
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red'>Your AdminHelp is being handled by [key_name(usr,FALSE,FALSE)] please be patient.</font>"

	if(initiator)
		to_chat(initiator, msg)

	feedback_inc("ahelp_handling")
	msg = "Ticket [TicketHref("#[id]")] being handled by [key_name(usr,FALSE,FALSE)]"
	message_admins(msg)
	log_admin(msg)
	AddInteraction("[key_name_admin(usr)] is now handling this ticket.")
	handler = key_name(usr, FALSE, TRUE)
	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Game ID: [game_id]) being handled.",
			"body" = "[key_name(usr)] is now handling the ticket."
		)
	)

/datum/ticket/proc/Retitle()
	var/new_title = tgui_input_text(usr, "Enter a title for the ticket", "Rename Ticket", name)
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin(msg)
	TicketPanel()	//we have to be here to do this

//Kick ticket to next level
/datum/ticket/proc/Escalate()
	if(tgui_alert(usr, "Really escalate this ticket to admins? No mentors will ever be able to interact with it again if you do.","Escalate",list("Yes","No")) != "Yes")
		return
	if (src.initiator == null) // You can't escalate a mentorhelp of someone who's logged out because it won't create the adminhelp properly
		to_chat(usr, "<span class='pm warning'>Error: client not found, unable to escalate.</span>")
		return

	level = level - 1

	message_mentors("[usr.ckey] escalated Ticket [TicketHref("#[id]")]")
	log_admin("[key_name(usr)] escalated ticket [src.name]")
	to_chat(src.initiator, "<span class='mentor'>[usr.ckey] escalated your ticket to admins.</span>")

/datum/ticket/proc/Context(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)
	if(state != AHELP_RESOLVED)
		. += " (<A HREF='?_src_=mentorholder;mhelp=[ref_src];mhelp_action=escalate'>ESCALATE</A>)"

//Forwarded action from admin/Topic
/datum/ticket/proc/Action(action)
	testing("Ahelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("handleissue")
			HandleIssue()
		if("reopen")
			Reopen()
		if("escalate")
			Escalate()

//
// TICKET STATCLICK
//

/obj/effect/statclick/ticket
	var/datum/ticket/ticket_datum

/obj/effect/statclick/ticket/New(loc, datum/ticket/T)
	ticket_datum = T
	..(loc)

/obj/effect/statclick/ticket/update()
	return ..(ticket_datum.name)

/obj/effect/statclick/ticket/Click()
	ticket_datum.TicketPanel()

/obj/effect/statclick/ticket/Destroy()
	ticket_datum = null
	return ..()

//
// LOGGING
//

//Use this proc when an admin takes action that may be related to an open ticket on what
//what can be a client, ckey, or mob
/proc/admin_ticket_log(what, message)
	var/client/C
	var/mob/Mob = what
	if(istype(Mob))
		C = Mob.client
	else
		C = what
	if(istype(C) && C.current_ticket)
		C.current_ticket.AddInteraction(message)
		return C.current_ticket
	if(istext(what))	//ckey
		var/datum/ticket/T = GLOB.tickets.CKey2ActiveTicket(what)
		if(T)
			T.AddInteraction(message)
			return T

//
// HELPER PROCS
//

/proc/get_admin_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != 0 && !check_rights(rights_required = requiredflags, show_msg = FALSE, C = X))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2irc_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts()
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2irc(source,final)

/proc/ircadminwho()
	var/list/message = list("Admins: ")
	var/list/admin_keys = list()
	for(var/client/C as anything in GLOB.admins)
		admin_keys += "[C][C.holder.fakekey ? "(Stealth)" : ""][C.is_afk() ? "(AFK)" : ""]"

	for(var/admin in admin_keys)
		if(LAZYLEN(admin_keys) > 1)
			message += ", [admin]"
		else
			message += "[admin]"

	return jointext(message, "")

/proc/keywords_lookup(msg,irc)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							var/is_antag = 0
							if(found.mind && found.mind.special_role)
								is_antag = 1
							founds += "Name: [found.name]([found.real_name]) Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
							msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>?</A>|<A HREF='?_src_=holder;adminplayerobservefollow=\ref[found]'>F</A>)</font> "
							continue
		msg += "[original_word] "
	if(irc)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg
