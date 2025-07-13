/client/var/datum/ticket/current_ticket	//the current ticket the (usually) not-admin client is dealing with
/client/var/datum/ticket/selected_ticket //the current ticket being viewed in the Tickets Panel (usually) admin/mentor client

/proc/get_ahelp_channel()
	var/datum/tgs_api/v5/api = TGS_READ_GLOBAL(tgs)
	if(istype(api) && CONFIG_GET(string/ahelp_channel_tag))
		for(var/datum/tgs_chat_channel/channel in api.chat_channels)
			if(channel.custom_tag == CONFIG_GET(string/ahelp_channel_tag))
				return list(channel)
	return 0

/proc/ahelp_discord_message(var/message)
	if(!message)
		return
	if(CONFIG_GET(flag/discord_ahelps_disabled))
		return
	var/datum/tgs_chat_channel/ahelp_channel = get_ahelp_channel()
	if(ahelp_channel)
		world.TgsChatBroadcast(message,ahelp_channel)
	else
		world.TgsTargetedChatBroadcast(message,TRUE)

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
	dat += "<A href='byond://?_src_=holder;[HrefToken()];ahelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/datum/ticket/T as anything in l2b)
		dat += span_adminnotice(span_adminhelp("Ticket #[T.id]") + ": <A href='byond://?_src_=holder;ahelp=\ref[T];[HrefToken()];ahelp_action=ticket'>[T.initiator_key_name]: [T.name]</A>") + "<br>"
	dat += "</html>"
	usr << browse(dat.Join(), "window=ahelp_list[state];size=600x480")

//Tickets statpanel
/datum/tickets/proc/stat_entry(client/target)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/L = list()
	var/num_adm_tickets_disconnected = 0
	var/num_men_tickets_disconnected = 0

	var/list/admin_tickets = list()
	var/list/mentor_tickets = list()

	for(var/datum/ticket/T as anything in active_tickets)
		switch (T.level)
			if(1)
				admin_tickets += T
			if(0)
				mentor_tickets += T

	var/closed_admin_tickets = 0
	var/closed_mentor_tickets = 0

	for(var/datum/ticket/T as anything in closed_tickets)
		switch (T.level)
			if(1)
				closed_admin_tickets++
			if(0)
				closed_mentor_tickets++

	var/resolved_admin_tickets = 0
	var/resolved_mentor_tickets = 0

	for(var/datum/ticket/T as anything in resolved_tickets)
		switch (T.level)
			if(1)
				resolved_admin_tickets++
			if(0)
				resolved_mentor_tickets++

	if(check_rights_for(target, R_ADMIN|R_SERVER|R_MOD))
		L[++L.len] = list("== Admin Tickets ==", "", null, null)
		L[++L.len] = list("Active Tickets:", "[astatclick.update("[admin_tickets.len]")]", null, REF(astatclick))
		for(var/datum/ticket/T as anything in admin_tickets)
			if(T.initiator)
				L[++L.len] = list("ADM #[T.id]. [T.initiator_key_name]:", T.name, null, REF(T.statclick))
			else
				num_adm_tickets_disconnected++
		if(num_adm_tickets_disconnected)
			L[++L.len] = list("Disconnected:", "[astatclick.update("[num_adm_tickets_disconnected]")]", null, REF(astatclick))
		L[++L.len] = list("Closed Tickets:", "[cstatclick.update("[closed_admin_tickets]")]", null, REF(cstatclick))
		L[++L.len] = list("Resolved Tickets:", "[rstatclick.update("[resolved_admin_tickets]")]", null, REF(rstatclick))

	L[++L.len] = list("== Mentor Tickets ==", "", null, null)
	L[++L.len] = list("Active Tickets:", "[astatclick.update("[mentor_tickets.len]")]", null, REF(astatclick))
	for(var/datum/ticket/T as anything in mentor_tickets)
		if(T.initiator)
			L[++L.len] = list("MEN #[T.id]. [T.initiator_key_name]:", T.name, null, REF(T.statclick))
		else
			num_men_tickets_disconnected++
	if(num_men_tickets_disconnected)
		L[++L.len] = list("Disconnected:", "[astatclick.update("[num_men_tickets_disconnected]")]", null, REF(astatclick))
	L[++L.len] = list("Closed Tickets:", "[cstatclick.update("[closed_mentor_tickets]")]", null, REF(cstatclick))
	L[++L.len] = list("Resolved Tickets:", "[rstatclick.update("[resolved_mentor_tickets]")]", null, REF(rstatclick))

	return L

//Reassociate still open ticket if one exists
/datum/tickets/proc/ClientLogin(client/C)
	C.current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.AddInteraction("Client reconnected.")
		C.current_ticket.initiator = C
		// C.current_ticket.initiator.mob.throw_alert("open ticket", /obj/screen/alert/open_ticket) // Uncomment this line to enable player-side ticket ui

//Dissasociate ticket
/datum/tickets/proc/ClientLogout(client/C)
	if(C.current_ticket)
		var/datum/ticket/T = C.current_ticket
		T.AddInteraction("Client disconnected.")
		// T.initiator.mob.clear_alert("open ticket") // Uncomment this line to enable player-side ticket ui
		T.initiator = null
		T = null

//Get a ticket given a ckey
/datum/tickets/proc/CKey2ActiveTicket(ckey)
	for(var/datum/ticket/T as anything in active_tickets)
		if(T.initiator_ckey == ckey)
			return T

//Get a ticket by ticket id
/datum/tickets/proc/ID2Ticket(id)
	if(!check_rights((R_ADMIN|R_SERVER|R_MOD|R_MENTOR), TRUE))
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

INITIALIZE_IMMEDIATE(/obj/effect/statclick/ticket_list)
/obj/effect/statclick/ticket_list/Initialize(mapload, name, state)
	current_state = state
	. = ..()

/obj/effect/statclick/ticket_list/Click()
	GLOB.tickets.BrowseTickets(current_state)

//
//TICKET DATUM
//

/datum/ticket
	var/id
	var/name
	var/level = 0 // 0 = Mentor, 1 = Admin
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
	to_chat(C, span_mentor(span_italics("Mentor-PM to-" + span_bold("Mentors") + ": [name]"))
	GLOB.ahelp_tickets.active_tickets += src */

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
/datum/ticket/New(raw_msg, client/C, is_bwoink, ticket_level)
	//clean the input msg
	var/msg = sanitize(copytext(raw_msg,1,MAX_MESSAGE_LEN))
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
		AddInteraction(span_blue("[key_name_admin(usr)] PM'd [LinkedReplyName()]"))
		message_admins(span_blue("Ticket [TicketHref("#[id]")] created"))
	else
		MessageNoRecipient(parsed_message)
		//show it to the person adminhelping too
		switch(level)
			if(0)
				to_chat(C, span_mentor_notice("PM to-" + span_bold("Mentors") + ": [name]"))

			if(1)
				to_chat(C, span_adminnotice("PM to-" + span_bold("Admins") + ": [name]"))

		//send it to irc if nobody is on and tell us how many were on
		var/admin_number_present = send2irc_adminless_only(initiator_ckey, name)
		log_admin("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(C, span_notice("No active admins are online, your adminhelp was sent to the admin discord."))
	send2adminchat()

	var/list/adm = get_admin_counts()
	var/list/activemins = adm["present"]
	var activeMins = activemins.len
	if(is_bwoink)
		ahelp_discord_message("[level == 0 ? "MENTORHELP" : "ADMINHELP"]: FROM: [key_name_admin(usr)] TO [initiator_ckey]/[initiator_key_name] - MSG: \n ```[raw_msg]``` \n Heard by [activeMins] NON-AFK staff members.")
	else
		ahelp_discord_message("[level == 0 ? "MENTORHELP" : "ADMINHELP"]: FROM: [initiator_ckey]/[initiator_key_name] - MSG: \n ```[raw_msg]``` \n Heard by [activeMins] NON-AFK staff members.")

		// Also send it to discord since that's the hip cool thing now.
		SSwebhooks.send(
			WEBHOOK_AHELP_SENT,
			list(
				"name" = "Ticket ([id]) (Round ID: [GLOB.round_id ? GLOB.round_id : "No database"]) ticket opened.",
				"body" = "[key_name(initiator)] has opened a ticket. \n[msg]",
				"color" = COLOR_WEBHOOK_POOR
			)
		)

	GLOB.tickets.active_tickets += src

	// Open a new chat with the user
	//var/datum/ticket_chat/TC = new()
	//TC.T = src
	//TC.tgui_interact(C.mob)

	// C.mob.throw_alert("open ticket", /obj/screen/alert/open_ticket) // Uncomment this line to enable player-side ticket ui

/datum/ticket/Destroy()
	RemoveActive()
	GLOB.tickets.closed_tickets -= src
	GLOB.tickets.resolved_tickets -= src
	return ..()

/datum/ticket/proc/AddInteraction(formatted_message)
	var/curinteraction = "[gameTimestamp()]: [formatted_message]"
	if(CONFIG_GET(flag/discord_ahelps_all))
		ahelp_discord_message("ADMINHELP: TICKETID: [id] [strip_html_properly(curinteraction)]")
	_interactions += curinteraction

/datum/ticket/proc/TicketPanel()
	tgui_interact(usr.client.mob)

//private
/datum/ticket/proc/FullMonty(ref_src, admin_commands = FALSE)
	if(!ref_src)
		ref_src = "\ref[src]"
	if(initiator && initiator.mob)
		if(admin_commands)
			. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	else
		. = "Initiator disconnected."
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/ticket/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"

	if(level == 1)
		. = " (<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=reject'>REJT</A>)"
		. += " (<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=icissue'>IC</A>)"
		. += " (<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=close'>CLOSE</A>)"
		. += " (<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=resolve'>RSLVE</A>)"
		. += " (<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=handleissue'>HANDLE</A>)"
	else
		. = " (<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=resolve'>RSLVE</A>)"
		. += " (<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=escalate'>ESCALATE</A>)"

//private
/datum/ticket/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=reply'>[initiator_key_name]</A>"

//private
/datum/ticket/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A href='byond://?_src_=holder;ticket=[ref_src];[HrefToken(TRUE)];ticket_action=[action]'>[msg]</A>"

/*
	var/chat_msg = span_notice("(<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken()];ahelp_action=escalate'>ESCALATE</A>) Ticket [TicketHref("#[id]", ref_src)]" + span_bold(": [LinkedReplyName(ref_src)]:") + " [msg]")
	 */

//message from the initiator without a target, all admins will see this
//won't bug irc
/datum/ticket/proc/MessageNoRecipient(msg)
	var/ref_src = "\ref[src]"

	AddInteraction(span_red("[LinkedReplyName(ref_src)]: [msg]"))
	//send this msg to all admins

	switch(level)
		if(0)
			for (var/client/C in GLOB.admins)
				var/chat_msg = span_mentor_channel(span_admin_pm_notice(span_adminhelp("Ticket [TicketHref("#[id]", ref_src)]") + span_bold(" (Mentor): [LinkedReplyName(ref_src)] [FullMonty(ref_src, check_rights_for(C, (R_ADMIN|R_SERVER|R_MOD)))]:") + msg))
				if (C.prefs?.read_preference(/datum/preference/toggle/play_mentorhelp_ping))
					C << 'sound/effects/mentorhelp.mp3'
				to_chat(C, chat_msg)
		if(1)
			for(var/client/X in GLOB.admins)
				var/chat_msg = span_admin_pm_notice(span_adminhelp("Ticket [TicketHref("#[id]", ref_src)] (Admin)") + span_bold(": [LinkedReplyName(ref_src)] [FullMonty(ref_src, check_rights_for(X, (R_ADMIN|R_SERVER|R_MOD)))]:") + msg)
				if(!check_rights_for(X, R_HOLDER))
					continue
				if(X.prefs?.read_preference(/datum/preference/toggle/holder/play_adminhelp_ping))
					X << 'sound/effects/adminhelp.ogg'
				window_flash(X)
				to_chat(X, chat_msg)

/*
//Reopen a closed ticket
/datum/mentor_help/proc/Reopen()
	switch(state)
		if(AHELP_RESOLVED)
			feedback_dec("ahelp_resolve")
	AddInteraction(span_purple("Reopened by [usr.ckey]"))
	if(initiator)
		to_chat(initiator, span_filter_adminlog(span_purple("Ticket [TicketHref("#[id]")] was reopened by [usr.ckey].")))
	var/msg = span_adminhelp("Ticket [TicketHref("#[id]")] reopened by [usr.ckey].")
	message_mentors(msg)
	log_admin(msg)
	*/

//Reopen a closed ticket
/datum/ticket/proc/Reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, span_warning("This ticket is already open."))
		return

	if(GLOB.tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, span_warning("This user already has an active ticket, cannot reopen this one."))
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

	AddInteraction(span_purple("Reopened by [key_name_admin(usr)]"))
	if(initiator)
		to_chat(initiator, span_filter_adminlog("[span_purple("Ticket [TicketHref("#[id]")] was reopened by [key_name(usr,FALSE,FALSE)].")]"))
	var/msg = span_adminhelp("Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].")
	message_admins(msg)
	log_admin(msg)
	feedback_inc("ticket_reopen")
	//TicketPanel()	//can only be done from here, so refresh it

	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Round ID: [GLOB.round_id ? GLOB.round_id : "No database"]) reopened.",
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
	AddInteraction(span_filter_adminlog(span_red("Closed by [key_name_admin(usr)].")))
	if(initiator)
		to_chat(initiator, span_filter_adminlog("[span_red("Ticket [TicketHref("#[id]")] was closed by [key_name(usr,FALSE,FALSE)].")]"))
	if(!silent)
		feedback_inc("ahelp_close")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name_admin(usr)]."
		message_admins(msg)
		log_admin(msg)
		SSwebhooks.send(
			WEBHOOK_AHELP_SENT,
			list(
				"name" = "Ticket ([id]) (Round ID: [GLOB.round_id ? GLOB.round_id : "No database"]) closed.",
				"body" = "Closed by [key_name(usr)].",
				"color" = COLOR_WEBHOOK_BAD
			)
		)
	// initiator?.mob?.clear_alert("open ticket") // Uncomment this line to enable player-side ticket ui

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/ticket/proc/Resolve(silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.tickets.ListInsert(src)

	AddInteraction(span_filter_adminlog(span_green("Resolved by [key_name_admin(usr)].")))
	if(initiator)
		to_chat(initiator, span_filter_adminlog("[span_green("Ticket [TicketHref("#[id]")] was marked resolved by [key_name(usr,FALSE,FALSE)].")]"))
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
					"name" = "Ticket ([id]) (Round ID: [GLOB.round_id ? GLOB.round_id : "No database"]) resolved.",
					"body" = "Marked as Resolved by [key_name(usr)].",
					"color" = COLOR_WEBHOOK_GOOD
				)
			)
	// initiator?.mob?.clear_alert("open ticket") // Uncomment this line to enable player-side ticket ui

//Close and return ahelp verb, use if ticket is incoherent
/datum/ticket/proc/Reject(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	if(initiator)
		if(initiator.prefs?.read_preference(/datum/preference/toggle/holder/play_adminhelp_ping))
			initiator << 'sound/effects/adminhelp.ogg'

		to_chat(initiator, span_filter_pm("[span_red(span_huge(span_bold("- AdminHelp Rejected! -")))]<br>\
							[span_red(span_bold("Your admin help was rejected."))]<br>\
							Please try to be calm, clear, and descriptive in admin helps, do not assume the admin has seen any related events, and clearly state the names of anybody you are reporting."))

	feedback_inc("ahelp_reject")
	var/msg = "Ticket [TicketHref("#[id]")] rejected by [key_name_admin(usr)]"
	message_admins(msg)
	log_admin(msg)
	AddInteraction("Rejected by [key_name_admin(usr)].")
	Close(silent = TRUE)
	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Round ID: [GLOB.round_id ? GLOB.round_id : "No database"]) rejected.",
			"body" = "Rejected by [key_name(usr)].",
			"color" = COLOR_WEBHOOK_BAD
		)
	)

//Resolve ticket with IC Issue message
/datum/ticket/proc/ICIssue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "[span_red(span_huge(span_bold("- AdminHelp marked as IC issue! -")))]<br>"
	msg += "[span_red(span_bold("This is something that can be solved ICly, and does not currently require staff intervention."))]<br>"
	msg += "[span_red("Your AdminHelp may also be unanswerable due to ongoing events.")]"

	if(initiator)
		to_chat(initiator, span_filter_pm(msg))

	feedback_inc("ahelp_icissue")
	msg = "Ticket [TicketHref("#[id]")] marked as IC by [key_name_admin(usr)]"
	message_admins(msg)
	log_admin(msg)
	AddInteraction("Marked as IC issue by [key_name_admin(usr)]")
	Resolve(silent = TRUE)
	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Round ID: [GLOB.round_id ? GLOB.round_id : "No database"]) marked as IC issue.",
			"body" = "Marked as IC Issue by [key_name(usr)].",
			"color" = COLOR_WEBHOOK_BAD
		)
	)

//Resolve ticket with IC Issue message
/datum/ticket/proc/HandleIssue()
	if(state != AHELP_ACTIVE)
		return

	if(handler == key_name(usr, FALSE, TRUE))
		to_chat(usr, span_red("You are already handling this ticket."))
		return

	var/msg
	switch(level)
		if(0)
			msg = span_green("Your MentorHelp is being handled by [key_name(usr,FALSE,FALSE)] please be patient.")
		if(1)
			msg = span_red("Your AdminHelp is being handled by [key_name(usr,FALSE,FALSE)] please be patient.")

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
			"name" = "Ticket ([id]) (Round ID: [GLOB.round_id ? GLOB.round_id : "No database"]) being handled.",
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
	//TicketPanel()	//we have to be here to do this

//Kick ticket to next level
/datum/ticket/proc/Escalate()
	if(tgui_alert(usr, "Really escalate this ticket to admins? No mentors will ever be able to interact with it again if you do.","Escalate",list("Yes","No")) != "Yes")
		return
	if (src.initiator == null) // You can't escalate a mentorhelp of someone who's logged out because it won't create the adminhelp properly
		to_chat(usr, span_mentor_warning("Error: client not found, unable to escalate."))
		return

	level = level + 1

	AddInteraction("[key_name_admin(usr)] escalated Ticket.")
	message_mentors("[usr.ckey] escalated Ticket [TicketHref("#[id]")]")
	log_admin("[key_name(usr)] escalated ticket [src.name]")
	to_chat(src.initiator, span_mentor("[usr.ckey] escalated your ticket to admins."))

//Forwarded action from admin/Topic
/datum/ticket/proc/Action(action)
	//testing("Ticket action: [action]")

	// Actions everyone can do
	switch(level)
		if(0)
			if(!check_rights_for(usr.client, (R_ADMIN|R_SERVER|R_MOD|R_MENTOR)))
				return
		if(1)
			if(!check_rights_for(usr.client, (R_ADMIN|R_SERVER|R_MOD)))
				return

	perform_action(action)

/datum/ticket/proc/perform_action(action)
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			switch(level)
				if(0)
					usr.client.cmd_mhelp_reply(initiator)
				if(1)
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

INITIALIZE_IMMEDIATE(/obj/effect/statclick/ticket)
/obj/effect/statclick/ticket/Initialize(mapload, datum/ticket/T)
	ticket_datum = T
	. = ..()

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
		if(requiredflags != 0 && !check_rights_for(X, requiredflags))
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
							var/textentry = "(<A href='byond://?_src_=holder;[HrefToken()];adminmoreinfo=\ref[found]'>?</A>|<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservefollow=\ref[found]'>F</A> "
							msg += "[original_word]" + span_small((is_antag ? span_red(textentry) : span_black(textentry)))
							continue
		msg += "[original_word] "
	if(irc)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg
