/client/var/datum/admin_help/current_ticket	//the current ticket the (usually) not-admin client is dealing with

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(ahelp_tickets, /datum/admin_help_tickets, new)

/datum/admin_help_tickets
	var/list/active_tickets = list()
	var/list/closed_tickets = list()
	var/list/resolved_tickets = list()

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, AHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, AHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, AHELP_RESOLVED)

/datum/admin_help_tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(closed_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

//private
/datum/admin_help_tickets/proc/ListInsert(datum/admin_help/new_ticket)
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
			var/datum/admin_help/AH = ticket_list[I]
			if(AH.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

//opens the ticket listings for one of the 3 states
/datum/admin_help_tickets/proc/BrowseTickets(state)
	if(!check_rights(R_ADMIN|R_SERVER)) //Prevents non-staff from opening the list of ahelp tickets
		return
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
	for(var/datum/admin_help/AH as anything in l2b)
		dat += span_adminnotice(span_adminhelp("Ticket #[AH.id]") + ": <A href='byond://?_src_=holder;ahelp=\ref[AH];[HrefToken()];ahelp_action=ticket'>[AH.initiator_key_name]: [AH.name]</A>") + "<br>"
	dat += "</html>"
	usr << browse(dat.Join(), "window=ahelp_list[state];size=600x480")

//Tickets statpanel
/datum/admin_help_tickets/proc/stat_entry()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/L = list()
	var/num_disconnected = 0
	L[++L.len] = list("== Admin Tickets ==", "", null, null)
	L[++L.len] = list("Active Tickets:", "[astatclick.update("[active_tickets.len]")]", null, REF(astatclick))
	astatclick.update("[active_tickets.len]")
	for(var/datum/admin_help/AH as anything in active_tickets)
		if(AH.initiator)
			L[++L.len] = list("#[AH.id]. [AH.initiator_key_name]:", "[AH.statclick.update()]", REF(AH))
		else
			++num_disconnected
	if(num_disconnected)
		L[++L.len] = list("Disconnected:", "[astatclick.update("[num_disconnected]")]", null, REF(astatclick))
	L[++L.len] = list("Closed Tickets:", "[cstatclick.update("[closed_tickets.len]")]", null, REF(cstatclick))
	L[++L.len] = list("Resolved Tickets:", "[rstatclick.update("[resolved_tickets.len]")]", null, REF(rstatclick))
	return L

//Reassociate still open ticket if one exists
/datum/admin_help_tickets/proc/ClientLogin(client/C)
	C.current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.AddInteraction("Client reconnected.")
		C.current_ticket.initiator = C

//Dissasociate ticket
/datum/admin_help_tickets/proc/ClientLogout(client/C)
	if(C.current_ticket)
		C.current_ticket.AddInteraction("Client disconnected.")
		C.current_ticket.initiator = null
		C.current_ticket = null

//Get a ticket given a ckey
/datum/admin_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/datum/admin_help/AH as anything in active_tickets)
		if(AH.initiator_ckey == ckey)
			return AH

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_state

/obj/effect/statclick/ticket_list/New(loc, name, state)
	current_state = state
	..()

/obj/effect/statclick/ticket_list/Click()
	GLOB.ahelp_tickets.BrowseTickets(current_state)

//called by admin topic
/obj/effect/statclick/ticket_list/proc/Action()
	Click()
//
//TICKET DATUM
//

/datum/admin_help
	var/id
	var/name
	var/state = AHELP_ACTIVE

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who ahelped/was bwoinked
	var/initiator_ckey
	var/initiator_key_name

	var/list/_interactions	//use AddInteraction() or, preferably, admin_ticket_log()

	var/obj/effect/statclick/ahelp/statclick

	var/static/ticket_counter = 0

//call this on its own to create a ticket, don't manually assign current_ticket
//msg is the title of the ticket: usually the ahelp text
//is_bwoink is TRUE if this ticket was started by an admin PM
/datum/admin_help/New(msg, client/C, is_bwoink)
	//clean the input msg
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = msg

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
		send2adminchat() //VOREStation Add
		//show it to the person adminhelping too
		to_chat(C, span_admin_pm_notice("PM to-" + span_bold("Admins") + ": [name]"))

		//send it to irc if nobody is on and tell us how many were on
		var/admin_number_present = send2irc_adminless_only(initiator_ckey, name)
		log_admin("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(C, span_admin_pm_notice("No active admins are online, your adminhelp was sent to the admin discord."))		//VOREStation Edit

		// Also send it to discord since that's the hip cool thing now.
		SSwebhooks.send(
			WEBHOOK_AHELP_SENT,
			list(
				"name" = "Ticket ([id]) (Game ID: [game_id]) ticket opened.",
				"body" = "[key_name(initiator)] has opened a ticket. \n[msg]",
				"color" = COLOR_WEBHOOK_POOR
			)
		)

	GLOB.ahelp_tickets.active_tickets += src

/datum/admin_help/Destroy()
	RemoveActive()
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	return ..()

/datum/admin_help/proc/AddInteraction(formatted_message)
	_interactions += "[gameTimestamp()]: [formatted_message]"

//private
/datum/admin_help/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	if(initiator && initiator.mob)
		. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	else
		. = "Initiator disconnected."
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/admin_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	. = " (<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken(TRUE)];ahelp_action=reject'>REJT</A>)"
	. += " (<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken(TRUE)];ahelp_action=icissue'>IC</A>)"
	. += " (<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken(TRUE)];ahelp_action=close'>CLOSE</A>)"
	. += " (<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken(TRUE)];ahelp_action=resolve'>RSLVE</A>)"
	. += " (<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken(TRUE)];ahelp_action=handleissue'>HANDLE</A>)"

//private
/datum/admin_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken()];ahelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/admin_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A href='byond://?_src_=holder;ahelp=[ref_src];[HrefToken()];ahelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all admins will see this
//won't bug irc
/datum/admin_help/proc/MessageNoRecipient(msg)
	var/ref_src = "\ref[src]"
	var/chat_msg = span_admin_pm_notice(span_adminhelp("Ticket [TicketHref("#[id]", ref_src)]") + span_bold(": [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:") + msg)

	AddInteraction(span_red("[LinkedReplyName(ref_src)]: [msg]"))
	//send this msg to all admins

	for(var/client/X in GLOB.admins)
		if(!check_rights_for(X, R_ADMIN))
			continue
		if(X.prefs?.read_preference(/datum/preference/toggle/holder/play_adminhelp_ping))
			X << 'sound/effects/adminhelp.ogg'
		window_flash(X)
		to_chat(X, chat_msg)

//Reopen a closed ticket
/datum/admin_help/proc/Reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, span_warning("This ticket is already open."))
		return

	if(GLOB.ahelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, span_warning("This user already has an active ticket, cannot reopen this one."))
		return

	statclick = new(null, src)
	GLOB.ahelp_tickets.active_tickets += src
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_CLOSED)
			feedback_dec("ahelp_close")
		if(AHELP_RESOLVED)
			feedback_dec("ahelp_resolve")
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
	feedback_inc("ahelp_reopen")
	TicketPanel()	//can only be done from here, so refresh it

	SSwebhooks.send(
		WEBHOOK_AHELP_SENT,
		list(
			"name" = "Ticket ([id]) (Game ID: [game_id]) reopened.",
			"body" = "Reopened by [key_name(usr)]."
		)
	)

//private
/datum/admin_help/proc/RemoveActive()
	if(state != AHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.ahelp_tickets.active_tickets -= src
	if(initiator && initiator.current_ticket == src)
		initiator.current_ticket = null

//Mark open ticket as closed/meme
/datum/admin_help/proc/Close(silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_CLOSED
	GLOB.ahelp_tickets.ListInsert(src)
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
				"name" = "Ticket ([id]) (Game ID: [game_id]) closed.",
				"body" = "Closed by [key_name(usr)].",
				"color" = COLOR_WEBHOOK_BAD
			)
		)

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/admin_help/proc/Resolve(silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.ahelp_tickets.ListInsert(src)

	AddInteraction(span_filter_adminlog(span_green("Resolved by [key_name_admin(usr)].")))
	if(initiator)
		to_chat(initiator, span_filter_adminlog("[span_green("Ticket [TicketHref("#[id]")] was marked resolved by [key_name(usr,FALSE,FALSE)].")]"))
	if(!silent)
		feedback_inc("ahelp_resolve")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin(msg)
		SSwebhooks.send(
			WEBHOOK_AHELP_SENT,
			list(
				"name" = "Ticket ([id]) (Game ID: [game_id]) resolved.",
				"body" = "Marked as Resolved by [key_name(usr)].",
				"color" = COLOR_WEBHOOK_GOOD
			)
		)

//Close and return ahelp verb, use if ticket is incoherent
/datum/admin_help/proc/Reject(key_name = key_name_admin(usr))
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
			"name" = "Ticket ([id]) (Game ID: [game_id]) rejected.",
			"body" = "Rejected by [key_name(usr)].",
			"color" = COLOR_WEBHOOK_BAD
		)
	)

//Resolve ticket with IC Issue message
/datum/admin_help/proc/ICIssue(key_name = key_name_admin(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "[span_red(span_huge(span_bold("- AdminHelp marked as IC issue! -")))]<br>"
	msg += "[span_red(span_bold("This is something that can be solved ICly, and does not currently require staff intervention."))]<br>"
	msg += "[span_red("Your AdminHelp may also be unanswerable due to ongoing events.")]"

	if(initiator)
		to_chat(initiator,span_filter_pm(msg))

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
/datum/admin_help/proc/HandleIssue()
	if(state != AHELP_ACTIVE)
		return

	var/msg = span_red("Your AdminHelp is being handled by [key_name(usr,FALSE,FALSE)] please be patient.")

	if(initiator)
		to_chat(initiator, msg)

	feedback_inc("ahelp_handling")
	msg = "Ticket [TicketHref("#[id]")] being handled by [key_name(usr,FALSE,FALSE)]"
	message_admins(msg)
	log_admin(msg)
	AddInteraction("[key_name_admin(usr)] is now handling this ticket.")
	var/query_string = "type=admintake"
	query_string += "&key=[url_encode(CONFIG_GET(string/chat_webhook_key))]"
	query_string += "&admin=[url_encode(key_name(usr))]"
	query_string += "&user=[url_encode(key_name(initiator))]"
	world.Export("[CONFIG_GET(string/chat_webhook_url)]?[query_string]")




//Show the ticket panel
/datum/admin_help/proc/TicketPanel()
	tgui_interact(usr.client.mob)

/datum/admin_help/proc/TicketPanelLegacy()
	var/list/dat = list("<html><head><title>Ticket #[id]</title></head>")
	var/ref_src = "\ref[src]"
	dat += "<h4>Admin Help Ticket #[id]: [LinkedReplyName(ref_src)]</h4>"
	dat += span_bold("State: ")
	switch(state)
		if(AHELP_ACTIVE)
			dat += span_red(span_bold("OPEN"))
		if(AHELP_RESOLVED)
			dat += span_green(span_bold("RESOLVED"))
		if(AHELP_CLOSED)
			dat += span_bold("CLOSED")
		else
			dat += span_bold("UNKNOWN")
	dat += "[GLOB.TAB][TicketHref("Refresh", ref_src)][GLOB.TAB][TicketHref("Re-Title", ref_src, "retitle")]"
	if(state != AHELP_ACTIVE)
		dat += "[GLOB.TAB][TicketHref("Reopen", ref_src, "reopen")]"
	dat += "<br><br>Opened at: [gameTimestamp(wtime = opened_at)] (Approx [(world.time - opened_at) / 600] minutes ago)"
	if(closed_at)
		dat += "<br>Closed at: [gameTimestamp(wtime = closed_at)] (Approx [(world.time - closed_at) / 600] minutes ago)"
	dat += "<br><br>"
	if(initiator)
		dat += span_bold("Actions:") + " [FullMonty(ref_src)]<br>"
	else
		dat += span_bold("DISCONNECTED") + "[GLOB.TAB][ClosureLinks(ref_src)]<br>"
	dat += "<br>" + span_bold("Log:") + "<br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"
	dat += "</html>"
	usr << browse(dat.Join(), "window=ahelp[id];size=620x480")

/datum/admin_help/proc/Retitle()
	var/new_title = tgui_input_text(usr, "Enter a title for the ticket", "Rename Ticket", name)
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin(msg)
	TicketPanel()	//we have to be here to do this

/datum/admin_help/tgui_fallback(payload)
	if(..())
		return

	TicketPanelLegacy()

/datum/admin_help/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AdminTicketPanel", "Ticket #[id] - [LinkedReplyName("\ref[src]")]")
		ui.open()

/datum/admin_help/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/admin_help/tgui_data(mob/user)
	var/list/data = list()

	data["id"] = id

	var/ref_src = "\ref[src]"
	data["title"] = name
	data["name"] = LinkedReplyName(ref_src)

	switch(state)
		if(AHELP_ACTIVE)
			data["state"] = "open"
		if(AHELP_RESOLVED)
			data["state"] = "resolved"
		if(AHELP_CLOSED)
			data["state"] = "closed"
		else
			data["state"] = "unknown"

	data["opened_at"] = (world.time - opened_at)
	data["closed_at"] = (world.time - closed_at)
	data["opened_at_date"] = gameTimestamp(wtime = opened_at)
	data["closed_at_date"] = gameTimestamp(wtime = closed_at)

	data["actions"] = FullMonty(ref_src)

	data["log"] = _interactions

	return data

/datum/admin_help/tgui_act(action, params)
	if(..())
		return
	switch(action)
		if("retitle")
			Retitle()
			. = TRUE
		if("reopen")
			Reopen()
			. = TRUE
		if("legacy")
			TicketPanelLegacy()
			. = TRUE

//Forwarded action from admin/Topic
/datum/admin_help/proc/Action(action)
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

//
// TICKET STATCLICK
//

/obj/effect/statclick/ahelp
	var/datum/admin_help/ahelp_datum

/obj/effect/statclick/ahelp/New(loc, datum/admin_help/AH)
	ahelp_datum = AH
	..(loc)

/obj/effect/statclick/ahelp/update()
	return ..(ahelp_datum.name)

/obj/effect/statclick/ahelp/Click()
	ahelp_datum.TicketPanel()

/obj/effect/statclick/ahelp/Destroy()
	ahelp_datum = null
	return ..()

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
	remove_verb(src, /client/verb/adminhelp)
	spawn(1200)
		add_verb(src, /client/verb/adminhelp)	// 2 minute cool-down for adminhelps

	feedback_add_details("admin_verb","Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		var/input = tgui_alert(usr, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
		if(!input)
			return
		if(input == "Yes")
			if(current_ticket)
				current_ticket.MessageNoRecipient(msg)
				to_chat(usr, span_admin_pm_notice("PM to-" + span_bold("Admins") + ": [msg]"))
				return
			else
				to_chat(usr, span_warning("Ticket not found, creating new one..."))
		else
			current_ticket.AddInteraction("[key_name_admin(usr)] opened a new ticket.")
			current_ticket.Close()

	new /datum/admin_help(msg, src, FALSE)

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

	GLOB.ahelp_tickets.BrowseTickets(browse_to)

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
		var/datum/admin_help/AH = GLOB.ahelp_tickets.CKey2ActiveTicket(what)
		if(AH)
			AH.AddInteraction(message)
			return AH

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
