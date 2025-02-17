//
//TICKET MANAGER
//

/datum/tickets/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TicketsPanel", "Tickets")
		ui.open()

/datum/tickets/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tickets/proc/get_ticket_state(state)
	var/ticket_state
	switch(state)
		if(AHELP_ACTIVE)
			ticket_state = "open"
		// TODO: Mentor tickets cannot be resolved
		if(AHELP_RESOLVED)
			ticket_state = "resolved"
		if(AHELP_CLOSED)
			ticket_state = "closed"
		else
			ticket_state = "unknown"

	return ticket_state

/datum/tickets/tgui_data(mob/user)
	var/list/data = list()
	var/list/tickets = list()

	var/selected_ticket = null

	if(user.client.selected_ticket)
		var/datum/ticket/T = user.client.selected_ticket
		selected_ticket = list(
			"id" = T.id,
			"name" = T.LinkedReplyName(),
			"state" = get_ticket_state(T.state),
			"level" = T.level,
			"handler" = T.handler,
			"opened_at" = (world.time - T.opened_at),
			"closed_at" = (world.time - T.closed_at),
			"opened_at_date" = gameTimestamp(wtime = T.opened_at),
			"closed_at_date" = gameTimestamp(wtime = T.closed_at),
			"actions" = T.FullMonty(),
			"log" = T._interactions,
		)

	for(var/datum/ticket/T as anything in GLOB.tickets.active_tickets)
		if(user.client.holder || (has_mentor_powers(user.client) && T.level > 0))
			tickets.Add(list(list(
				"id" = T.id,
				"name" = T.initiator_key_name,
				"state" = get_ticket_state(T.state),
				"level" = T.level,
				"handler" = T.handler,
				"opened_at" = (world.time - T.opened_at),
				"closed_at" = (world.time - T.closed_at),
				"opened_at_date" = gameTimestamp(wtime = T.opened_at),
				"closed_at_date" = gameTimestamp(wtime = T.closed_at),
			)))

	for(var/datum/ticket/T as anything in GLOB.tickets.closed_tickets)
		if(user.client.holder || (has_mentor_powers(user.client) && T.level > 0))
			tickets.Add(list(list(
				"id" = T.id,
				"name" = T.initiator_key_name,
				"state" = get_ticket_state(T.state),
				"level" = T.level,
				"handler" = T.handler,
				"opened_at" = (world.time - T.opened_at),
				"closed_at" = (world.time - T.closed_at),
				"opened_at_date" = gameTimestamp(wtime = T.opened_at),
				"closed_at_date" = gameTimestamp(wtime = T.closed_at),
			)))

	for(var/datum/ticket/T as anything in GLOB.tickets.resolved_tickets)
		if(user.client.holder || (has_mentor_powers(user.client) && T.level > 0))
			tickets.Add(list(list(
				"id" = T.id,
				"name" = T.initiator_key_name,
				"state" = get_ticket_state(T.state),
				"level" = T.level,
				"handler" = T.handler,
				"opened_at" = (world.time - T.opened_at),
				"closed_at" = (world.time - T.closed_at),
				"opened_at_date" = gameTimestamp(wtime = T.opened_at),
				"closed_at_date" = gameTimestamp(wtime = T.closed_at),
			)))
	data["tickets"] = tickets

	data["selected_ticket"] = selected_ticket

	return data

/datum/tickets/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return
	switch(action)
		if("legacy")
			var/choice = tgui_input_list(usr, "Which tickets do you want to list?", "Tickets", list("Active", "Closed", "Resolved"))
			TicketListLegacy(choice)
			. = TRUE
		if("new_ticket")
			var/list/ckeys = list()
			for(var/client/C in GLOB.clients)
				ckeys += C.key

			var/ckey = lowertext(tgui_input_list(usr, "Please select the ckey of the user.", "Select CKEY", ckeys))
			if(!ckey)
				return

			var/client/player
			for(var/client/C in GLOB.clients)
				if(C.ckey == ckey)
					player = C

			if(!player)
				to_chat(usr, span_warning("Ckey ([ckey]) not online."))
				return

			var/ticket_text = tgui_input_text(usr, "What should the initial text be?", "New Ticket")
			if(!ticket_text)
				to_chat(usr, span_warning("Ticket message cannot be empty."))
				return

			var/level = tgui_alert(usr, "Is this ticket Admin-Level or Mentor-Level?", "Ticket Level", list("Admin", "Mentor"))
			if(!level)
				return

			feedback_add_details("admin_verb","Admincreatedticket") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			if(player.current_ticket)
				var/input = tgui_alert(usr, "The player already has a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
				if(!input)
					return
				if(input == "Yes")
					if(player.current_ticket)
						player.current_ticket.MessageNoRecipient(ticket_text)
						to_chat(usr, span_adminnotice("PM to-" + span_bold("Admins") + ": [ticket_text]"))
						return
					else
						to_chat(usr, span_warning("Ticket not found, creating new one..."))
				else
					player.current_ticket.AddInteraction("[key_name_admin(usr)] opened a new ticket.")
					player.current_ticket.Close()

			// Create a new ticket and handle it. You created it afterall!
			var/datum/ticket/T = new /datum/ticket(ticket_text, player, TRUE, level)
			if(level == "Admin")
				T.level = 0
			else
				T.level = 1
			T.HandleIssue()
			usr.client.cmd_admin_pm(player, ticket_text, T)
			. = TRUE
		if("pick_ticket")
			var/datum/ticket/T = ID2Ticket(params["ticket_id"])
			usr.client.selected_ticket = T
			. = TRUE
		if("retitle_ticket")
			usr.client.selected_ticket.Retitle()
			. = TRUE
		if("reopen_ticket")
			usr.client.selected_ticket.Reopen()
			. = TRUE
		if("undock_ticket")
			usr.client.selected_ticket.tgui_interact(usr)
			usr.client.selected_ticket = null
			. = TRUE
		if("send_msg")
			if(!params["msg"])
				return

			usr.client.cmd_admin_pm(usr.client.selected_ticket.initiator, sanitize(params["msg"]), usr.client.selected_ticket)
			. = TRUE

/datum/tickets/tgui_fallback(payload)
	if(..())
		return

	var/choice = tgui_input_list(usr, "Which tickets do you want to list?", "Tickets", list("Active", "Closed", "Resolved"))

	TicketListLegacy(choice)

//
//TICKET DATUM
//

/datum/ticket/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Ticket", "Ticket #[id] - [LinkedReplyName("\ref[src]")]")
		ui.open()

/datum/ticket/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/ticket/tgui_data(mob/user)
	var/list/data = list()

	data["id"] = id

	var/ref_src = "\ref[src]"
	data["title"] = name
	data["name"] = LinkedReplyName(ref_src)
	data["ticket_ref"] = ref_src

	switch(state)
		if(AHELP_ACTIVE)
			data["state"] = "open"
		// TODO: Mentor tickets cannot be resolved
		if(AHELP_RESOLVED)
			data["state"] = "resolved"
		if(AHELP_CLOSED)
			data["state"] = "closed"
		else
			data["state"] = "unknown"

	data["level"] = level
	data["handler"] = handler

	data["opened_at"] = (world.time - opened_at)
	data["closed_at"] = (world.time - closed_at)
	data["opened_at_date"] = gameTimestamp(wtime = opened_at)
	data["closed_at_date"] = gameTimestamp(wtime = closed_at)

	data["actions"] = FullMonty(ref_src)

	data["log"] = _interactions

	return data

/datum/ticket/tgui_act(action, params)
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
		if("send_msg")
			if(!params["msg"] || !params["ticket_ref"])
				return

			var/datum/ticket/T = locate(params["ticket_ref"])

			usr.client.cmd_admin_pm(T.initiator, sanitize(params["msg"]), T)
			. = TRUE

/datum/ticket/tgui_fallback(payload)
	if(..())
		return

	TicketPanelLegacy()

/*
/datum/mentor_help/proc/TicketPanelLegacy()
	var/list/dat = list("<html><head><title>Ticket #[id]</title></head>")
	var/ref_src = "\ref[src]"
	dat += "<h4>Mentor Help Ticket #[id]: [LinkedReplyName(ref_src)]</h4>"
	dat += "<b>State: "
	switch(state)
		if(AHELP_ACTIVE)
			dat += span_red("OPEN")
		if(AHELP_RESOLVED)
			dat += span_green("RESOLVED")
		else
			dat += "UNKNOWN"
	dat += "</b>[GLOB.TAB][TicketHref("Refresh", ref_src)]"
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
	dat += "<br><b>Log:</b><br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"
	usr << browse(dat.Join(), "window=mhelp[id];size=620x480") */

/datum/ticket/proc/TicketPanelLegacy()
	var/list/dat = list("<html><head><title>Ticket #[id]</title></head>")
	var/ref_src = "\ref[src]"
	dat += "<h4>Ticket #[id]: [LinkedReplyName(ref_src)]</h4>"
	dat += "<b>State: "
	switch(state)
		if(AHELP_ACTIVE)
			dat += span_red("OPEN")
		if(AHELP_RESOLVED)
			dat += span_green("RESOLVED")
		if(AHELP_CLOSED)
			dat += "CLOSED"
		else
			dat += "UNKNOWN"
	dat += "</b>[GLOB.TAB][TicketHref("Refresh", ref_src)][GLOB.TAB][TicketHref("Re-Title", ref_src, "retitle")]"
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
	dat += "<br><b>Log:</b><br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"
	dat += "</html>"
	usr << browse(dat.Join(), "window=ahelp[id];size=620x480")

/datum/tickets/proc/TicketListLegacy(var/state)
	var/list/dat = list("<html><head><title>[state] Tickets</title></head>")
	var/tickets_found = 0

	if(state == "Active")
		for(var/datum/ticket/T as anything in GLOB.tickets.active_tickets)
			dat += "[T.level == 0 ? "Adminhelp" : "Mentorhelp"] - [T.TicketHref("#[T.id] - [T.initiator_ckey]:  [T.name]")]"
			tickets_found++
	else if(state == "Closed")
		for(var/datum/ticket/T as anything in GLOB.tickets.closed_tickets)
			dat += "[T.level == 0 ? "Adminhelp" : "Mentorhelp"] - [T.TicketHref("#[T.id] - [T.initiator_ckey]:  [T.name]")]"
			tickets_found++
	else if(state == "Resolved")
		for(var/datum/ticket/T as anything in GLOB.tickets.resolved_tickets)
			dat += "[T.level == 0 ? "Adminhelp" : "Mentorhelp"] - [T.TicketHref("#[T.id] - [T.initiator_ckey]:  [T.name]")]"
			tickets_found++

	if(tickets_found == 0)
		dat += "No [state] tickets found."
	dat += "</html>"
	usr << browse(dat.Join(), "window=ahelp-list;size=250x350")
