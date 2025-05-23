/client/var/datum/mentor_help/current_mentorhelp

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(mhelp_tickets, /datum/mentor_help_tickets, new)

/datum/mentor_help_tickets
	var/list/active_tickets = list()
	var/list/resolved_tickets = list()

	var/obj/effect/statclick/mticket_list/astatclick = new(null, null, AHELP_ACTIVE)
	var/obj/effect/statclick/mticket_list/rstatclick = new(null, null, AHELP_RESOLVED)

/datum/mentor_help_tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(rstatclick)
	return ..()

//private
/datum/mentor_help_tickets/proc/ListInsert(datum/mentor_help/new_ticket)
	var/list/mticket_list
	switch(new_ticket.state)
		if(AHELP_ACTIVE)
			mticket_list = active_tickets
		if(AHELP_RESOLVED)
			mticket_list = resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = mticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/mentor_help/MH = mticket_list[I]
			if(MH.id > new_ticket.id)
				mticket_list.Insert(I, new_ticket)
				return
	mticket_list += new_ticket

//opens the ticket listings, only two states here
/datum/mentor_help_tickets/proc/BrowseTickets(state)
	var/list/l2b
	var/title
	switch(state)
		if(AHELP_ACTIVE)
			l2b = active_tickets
			title = "Active Tickets"
		if(AHELP_RESOLVED)
			l2b = resolved_tickets
			title = "Resolved Tickets"
	if(!l2b)
		return
	var/list/dat = list("<html><head><title>[title]</title></head>")
	dat += "<A href='byond://?_src_=mentorholder;[HrefToken()];mhelp_tickets=[state]'>Refresh</A><br><br>"
	for(var/datum/mentor_help/MH as anything in l2b)
		dat += span_adminnotice(span_adminhelp("Ticket #[MH.id]") + " <A href='byond://?_src_=mentorholder;mhelp=\ref[MH];[HrefToken()];mhelp_action=ticket'>[MH.initiator_ckey]: [MH.name]</A>") + "<br>"
	dat += "</html>"
	usr << browse(dat.Join(), "window=mhelp_list[state];size=600x480")

//Tickets statpanel
/datum/mentor_help_tickets/proc/stat_entry()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/L = list()
	var/num_disconnected = 0
	L[++L.len] = list("== Mentor Tickets ==", "", null, null)
	L[++L.len] = list("Active Tickets:", "[astatclick.update("[active_tickets.len]")]", null, REF(astatclick))
	astatclick.update("[active_tickets.len]")
	for(var/datum/mentor_help/MH as anything in active_tickets)
		if(MH.initiator)
			L[++L.len] = list("#[MH.id]. [MH.initiator_ckey]:", "[MH.statclick.update()]", REF(MH))
		else
			++num_disconnected
	if(num_disconnected)
		L[++L.len] = list("Disconnected:", "[astatclick.update("[num_disconnected]")]", null, REF(astatclick))
	L[++L.len] = list("Resolved Tickets:", "[rstatclick.update("[resolved_tickets.len]")]", null, REF(rstatclick))
	return L

//Reassociate still open ticket if one exists
/datum/mentor_help_tickets/proc/ClientLogin(client/C)
	C.current_mentorhelp = CKey2ActiveTicket(C.ckey)
	if(C.current_mentorhelp)
		C.current_mentorhelp.AddInteraction("Client reconnected.")
		C.current_mentorhelp.initiator = C

//Dissasociate ticket
/datum/mentor_help_tickets/proc/ClientLogout(client/C)
	if(C.current_mentorhelp)
		C.current_mentorhelp.AddInteraction("Client disconnected.")
		C.current_mentorhelp.initiator = null
		C.current_mentorhelp = null

//Get a ticket given a ckey
/datum/mentor_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/datum/admin_help/MH as anything in active_tickets)
		if(MH.initiator_ckey == ckey)
			return MH

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/mticket_list
	var/current_state

INITIALIZE_IMMEDIATE(/obj/effect/statclick/mticket_list)
/obj/effect/statclick/mticket_list/Initialize(mapload, name, state)
	. = ..()
	current_state = state

/obj/effect/statclick/mticket_list/Click()
	GLOB.mhelp_tickets.BrowseTickets(current_state)

//
//TICKET DATUM
//

/datum/mentor_help
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

//call this on its own to create a ticket, don't manually assign current_mentorhelp
//msg is the title of the ticket: usually the ahelp text
/datum/mentor_help/New(msg, client/C)
	//clean the input msg
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = msg

	initiator = C
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
	to_chat(C, span_mentor(span_italics("Mentor-PM to-" + span_bold("Mentors") + ": [name]")))

	GLOB.mhelp_tickets.active_tickets += src

/datum/mentor_help/Destroy()
	RemoveActive()
	GLOB.mhelp_tickets.resolved_tickets -= src
	return ..()

/datum/mentor_help/proc/AddInteraction(formatted_message)
	_interactions += "[gameTimestamp()]: [formatted_message]"

//private
/datum/mentor_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	. = " (<A href='byond://?_src_=mentorholder;mhelp=[ref_src];[HrefToken()];mhelp_action=resolve'>RSLVE</A>)"

//private
/datum/mentor_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A href='byond://?_src_=mentorholder;mhelp=[ref_src];[HrefToken()];mhelp_action=reply'>[initiator_ckey]</A>"

//private
/datum/mentor_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "\ref[src]"
	return "<A href='byond://?_src_=mentorholder;mhelp=[ref_src];[HrefToken()];mhelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all people with mentor powers will see this
/datum/mentor_help/proc/MessageNoRecipient(msg)
	var/ref_src = "\ref[src]"
	var/chat_msg = span_notice("(<A href='byond://?_src_=mentorholder;mhelp=[ref_src];[HrefToken()];mhelp_action=escalate'>ESCALATE</A>) Ticket [TicketHref("#[id]", ref_src)]" + span_bold(": [LinkedReplyName(ref_src)]:") + " [msg]")
	AddInteraction(span_red("[LinkedReplyName(ref_src)]: [msg]"))
	for (var/client/C in GLOB.mentors)
		if (C.prefs?.read_preference(/datum/preference/toggle/play_mentorhelp_ping))
			C << 'sound/effects/mentorhelp.mp3'
	for (var/client/C in GLOB.admins)
		if (C.prefs?.read_preference(/datum/preference/toggle/play_mentorhelp_ping))
			C << 'sound/effects/mentorhelp.mp3'
	message_mentors(chat_msg)

//Reopen a closed ticket
/datum/mentor_help/proc/Reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, span_warning("This ticket is already open."))
		return

	if(GLOB.mhelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, span_warning("This user already has an active ticket, cannot reopen this one."))
		return

	statclick = new(null, src)
	GLOB.mhelp_tickets.active_tickets += src
	GLOB.mhelp_tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_RESOLVED)
			feedback_dec("mhelp_resolve")
	state = AHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_mentorhelp = src

	AddInteraction(span_purple("Reopened by [usr.ckey]"))
	if(initiator)
		to_chat(initiator, span_filter_adminlog("[span_purple("Ticket [TicketHref("#[id]")] was reopened by [usr.ckey].")]"))
	var/msg = span_adminhelp("Ticket [TicketHref("#[id]")] reopened by [usr.ckey].")
	message_mentors(msg)
	log_admin(msg)
	feedback_inc("mhelp_reopen")
	TicketPanel()	//can only be done from here, so refresh it

//private
/datum/mentor_help/proc/RemoveActive()
	if(state != AHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.mhelp_tickets.active_tickets -= src
	if(initiator && initiator.current_mentorhelp == src)
		initiator.current_mentorhelp = null

//Mark open ticket as resolved/legitimate, returns mentorhelp verb
/datum/mentor_help/proc/Resolve(silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.mhelp_tickets.ListInsert(src)

	AddInteraction(span_filter_adminlog("[span_green("Resolved by [usr.ckey].")]"))
	if(initiator)
		to_chat(initiator, span_filter_adminlog("[span_green("Ticket [TicketHref("#[id]")] was marked resolved by [usr.ckey].")]"))
	if(!silent)
		feedback_inc("mhelp_resolve")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [usr.ckey]"
		message_mentors(msg)
		log_admin(msg)

//Show the ticket panel
/datum/mentor_help/proc/TicketPanel()
	tgui_interact(usr.client.mob)

/datum/mentor_help/proc/TicketPanelLegacy()
	var/list/dat = list("<html><head><title>Ticket #[id]</title></head>")
	var/ref_src = "\ref[src]"
	dat += "<h4>Mentor Help Ticket #[id]: [LinkedReplyName(ref_src)]</h4>"
	dat += span_bold("State: ")
	switch(state)
		if(AHELP_ACTIVE)
			dat += span_bold(span_red("OPEN"))
		if(AHELP_RESOLVED)
			dat += span_bold(span_green("RESOLVED"))
		else
			dat += "UNKNOWN"
	dat += "[GLOB.TAB][TicketHref("Refresh", ref_src)]"
	if(state != AHELP_ACTIVE)
		dat += "[GLOB.TAB][TicketHref("Reopen", ref_src, "reopen")]"
	dat += "<br><br>Opened at: [gameTimestamp(wtime = opened_at)] (Approx [(world.time - opened_at) / 600] minutes ago)"
	if(closed_at)
		dat += "<br>Closed at: [gameTimestamp(wtime = closed_at)] (Approx [(world.time - closed_at) / 600] minutes ago)"
	dat += "<br><br>"
	if(initiator)
		dat += span_bold("Actions:") + " [Context(ref_src)]<br>"
	else
		dat += span_bold("DISCONNECTED") + "[GLOB.TAB][ClosureLinks(ref_src)]<br>"
	dat += "<br>" + span_bold("Log:") + "<br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"
	dat += "</html>"
	usr << browse(dat.Join(), "window=mhelp[id];size=620x480")

/datum/mentor_help/tgui_fallback(payload)
	if(..())
		return

	TicketPanelLegacy()

/datum/mentor_help/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MentorTicketPanel", "Ticket #[id] - [LinkedReplyName("\ref[src]")]")
		ui.open()

/datum/mentor_help/tgui_state(mob/user)
	return GLOB.tgui_mentor_state

/datum/mentor_help/tgui_data(mob/user)
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
		else
			data["state"] = "unknown"

	data["opened_at"] = (world.time - opened_at)
	data["closed_at"] = (world.time - closed_at)
	data["opened_at_date"] = gameTimestamp(wtime = opened_at)
	data["closed_at_date"] = gameTimestamp(wtime = closed_at)

	data["actions"] = Context(ref_src)

	data["log"] = _interactions

	return data

/datum/mentor_help/tgui_act(action, params)
	if(..())
		return
	switch(action)
		if("escalate")
			Escalate()
			. = TRUE
		if("reopen")
			Reopen()
			. = TRUE
		if("legacy")
			TicketPanelLegacy()
			. = TRUE

//Kick ticket to admins
/datum/mentor_help/proc/Escalate()
	if(tgui_alert(usr, "Really escalate this ticket to admins? No mentors will ever be able to interact with it again if you do.","Escalate",list("Yes","No")) != "Yes")
		return
	if (src.initiator == null) // You can't escalate a mentorhelp of someone who's logged out because it won't create the adminhelp properly
		to_chat(usr, span_mentor_pm_warning("Error: client not found, unable to escalate."))
		return
	var/datum/admin_help/AH = new /datum/admin_help(src.name, src.initiator, FALSE)
	message_mentors("[usr.ckey] escalated Ticket [TicketHref("#[id]")]")
	log_admin("[key_name(usr)] escalated mentorhelp [src.name]")
	to_chat(src.initiator, span_mentor("[usr.ckey] escalated your mentorhelp to admins."))
	AH._interactions = src._interactions
	GLOB.mhelp_tickets.active_tickets -= src
	GLOB.mhelp_tickets.resolved_tickets -= src
	qdel(src)

/datum/mentor_help/proc/Context(ref_src)
	if(!ref_src)
		ref_src = "\ref[src]"
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)
	if(state != AHELP_RESOLVED)
		. += " (<A href='byond://?_src_=mentorholder;[HrefToken()];mhelp=[ref_src];mhelp_action=escalate'>ESCALATE</A>)"

//Forwarded action from admin/Topic OR mentor/Topic depending on which rank the caller has
/datum/mentor_help/proc/Action(action)
	switch(action)
		if("ticket")
			TicketPanel()
		if("reply")
			usr.client.cmd_mhelp_reply(initiator)
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()
		if("escalate")
			Escalate()

//
// TICKET STATCLICK
//

/obj/effect/statclick/mhelp
	var/datum/mentor_help/mhelp_datum

INITIALIZE_IMMEDIATE(/obj/effect/statclick/mhelp)
/obj/effect/statclick/mhelp/Initialize(mapload, datum/mentor_help/MH)
	mhelp_datum = MH
	. = ..()

/obj/effect/statclick/mhelp/update()
	return ..(mhelp_datum.name)

/obj/effect/statclick/mhelp/Click()
	mhelp_datum.TicketPanel()

/obj/effect/statclick/mhelp/Destroy()
	mhelp_datum = null
	return ..()

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

	// Making sure there's actually a mentor or admin who can respond.
	var/list/admins = get_admin_counts()
	var/list/activeAdmins = admins["present"]
	var/list/mentors = GLOB.mentors
	if(!mentors.len && !activeAdmins.len)
		var/choice = tgui_alert(usr, "There are no active admins or mentors online. Would you like to make an ahelp instead, so that staff is notified of your issue? \
		Alternatively, you may go to the discord yourself and repeat your question in #cadet-academy. Please note, if choosing the later, do not include current-round information.",
		"Send to discord?", list("Admin-help!", "Still mentorhelp!", "Cancel"))
		if(choice == "Admin-help!")
			usr.client.adminhelp(msg)
			remove_verb(src, /client/verb/mentorhelp)
			spawn(1200)
				add_verb(src, /client/verb/mentorhelp) // 2 minute cd to prevent abusing this to spam admins.
			return
		else if(!choice || choice == "Cancel")
			return



	//remove out adminhelp verb temporarily to prevent spamming of admins.
	remove_verb(src, /client/verb/mentorhelp)
	spawn(600)
		add_verb(src, /client/verb/mentorhelp)	// 1 minute cool-down for mentorhelps

	feedback_add_details("admin_verb","Mentorhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_mentorhelp)
		var/input = tgui_alert(usr, "You already have a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
		if(!input)
			return
		if(input == "Yes")
			if(current_mentorhelp)
				log_admin("Mentorhelp: [key_name(src)]: [msg]")
				current_mentorhelp.MessageNoRecipient(msg)
				to_chat(usr, span_mentor_pm_notice("Mentor-PM to-" + span_bold("Mentors") + ": [msg]"))
				return
			else
				to_chat(usr, span_warning("Ticket not found, creating new one..."))
		else
			current_mentorhelp.AddInteraction("[usr.ckey] opened a new ticket.")
			current_mentorhelp.Resolve()

	new /datum/mentor_help(msg, src, FALSE)

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

	GLOB.mhelp_tickets.BrowseTickets(browse_to)

/proc/message_mentors(var/msg)
	msg = span_mentor_channel(span_prefix("Mentor: " + span_message(msg)))

	for(var/client/C in GLOB.mentors)
		to_chat(C, msg)
	for(var/client/C in GLOB.admins)
		to_chat(C, msg)
