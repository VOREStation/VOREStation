//
//TICKET MANAGER
//

/datum/tickets/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TicketsPanel", "Tickets")
		ui.open()

/datum/tickets/tgui_state(mob/user)
	return GLOB.tgui_mentor_state

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
		if(check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)) || (check_rights_for(user.client, R_MENTOR) && T.level < 1))
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
				"actions" = T.FullMonty(null, check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD))),
				"log" = T._interactions,
			)

	for(var/datum/ticket/T as anything in GLOB.tickets.active_tickets)
		if(check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)) || (check_rights_for(user.client, R_MENTOR) && T.level < 1))
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
		if(check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)) || (check_rights_for(user.client, R_MENTOR) && T.level < 1))
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
		if(check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)) || (check_rights_for(user.client, R_MENTOR) && T.level < 1))
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
	data["is_admin"] = check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD))
	data["selected_ticket"] = selected_ticket

	return data

/datum/tickets/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return
	switch(action)
		if("legacy")
			var/choice = tgui_input_list(ui.user, "Which tickets do you want to list?", "Tickets", list("Active", "Closed", "Resolved"))
			TicketListLegacy(ui.user, choice)
			. = TRUE
		if("new_ticket")
			var/list/ckeys = list()
			for(var/client/C in GLOB.clients)
				ckeys += C.key

			var/ckey = lowertext(tgui_input_list(ui.user, "Please select the ckey of the user.", "Select CKEY", ckeys))
			if(!ckey)
				return

			var/client/player
			for(var/client/C in GLOB.clients)
				if(C.ckey == ckey)
					player = C

			if(!player)
				to_chat(ui.user, span_warning("Ckey ([ckey]) not online."))
				return

			var/ticket_text = tgui_input_text(ui.user, "What should the initial text be?", "New Ticket")
			if(!ticket_text)
				to_chat(ui.user, span_warning("Ticket message cannot be empty."))
				return

			var/level = tgui_alert(ui.user, "Is this ticket Admin-Level or Mentor-Level?", "Ticket Level", list("Admin", "Mentor"))
			if(!level)
				return

			feedback_add_details("admin_verb","Admincreatedticket") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			if(player.current_ticket)
				var/input = tgui_alert(ui.user, "The player already has a ticket open. Is this for the same issue?","Duplicate?",list("Yes","No"))
				if(!input)
					return
				if(input == "Yes")
					if(player.current_ticket)
						player.current_ticket.MessageNoRecipient(ticket_text)
						to_chat(ui.user, span_adminnotice("PM to-" + span_bold("Admins") + ": [ticket_text]"))
						return
					else
						to_chat(ui.user, span_warning("Ticket not found, creating new one..."))
				else
					player.current_ticket.AddInteraction("[key_name_admin(ui.user)] opened a new ticket.")
					player.current_ticket.Close()

			// Create a new ticket and handle it. You created it afterall!
			var/datum/ticket/T = new /datum/ticket(ticket_text, player, TRUE, level)
			if(level == "Admin")
				T.level = 1
			else
				T.level = 0
			T.HandleIssue()
			switch(T.level)
				if (0)
					ui.user.client.cmd_mentor_pm(player, ticket_text, T)
				if (1)
					ui.user.client.cmd_admin_pm(player, ticket_text, T)
			. = TRUE
		if("pick_ticket")
			var/datum/ticket/T = ID2Ticket(params["ticket_id"])
			ui.user.client.selected_ticket = T
			. = TRUE
		if("retitle_ticket")
			ui.user.client.selected_ticket.Retitle()
			. = TRUE
		if("reopen_ticket")
			ui.user.client.selected_ticket.Reopen()
			. = TRUE
		if("undock_ticket")
			ui.user.client.selected_ticket.tgui_interact(ui.user)
			ui.user.client.selected_ticket = null
			. = TRUE
		if("send_msg")
			if(!params["msg"])
				return

			switch(ui.user.client.selected_ticket.level)
				if (0)
					ui.user.client.cmd_mentor_pm(ui.user.client.selected_ticket.initiator, sanitize(params["msg"]), ui.user.client.selected_ticket)
				if (1)
					ui.user.client.cmd_admin_pm(ui.user.client.selected_ticket.initiator, sanitize(params["msg"]), ui.user.client.selected_ticket)
			. = TRUE

/datum/tickets/tgui_fallback(payload, user)
	if(..())
		return

	var/choice = tgui_input_list(user, "Which tickets do you want to list?", "Tickets", list("Active", "Closed", "Resolved"))

	TicketListLegacy(user, choice)

//
//TICKET DATUM
//

/datum/ticket/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Ticket", "Ticket #[id] - [LinkedReplyName("\ref[src]")]")
		ui.open()

/datum/ticket/tgui_state(mob/user)
	return GLOB.tgui_mentor_state

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

	data["actions"] = FullMonty(ref_src, check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)))

	data["log"] = _interactions

	return data

/datum/ticket/tgui_act(action, params, datum/tgui/ui)
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
			TicketPanelLegacy(ui.user)
			. = TRUE
		if("send_msg")
			if(!params["msg"] || !params["ticket_ref"])
				return

			var/datum/ticket/T = locate(params["ticket_ref"])

			switch(level)
				if (0)
					ui.user.client.cmd_mentor_pm(T.initiator, sanitize(params["msg"]), T)
				if (1)
					ui.user.client.cmd_admin_pm(T.initiator, sanitize(params["msg"]), T)

			. = TRUE

/datum/ticket/tgui_fallback(payload, user)
	if(..())
		return

	TicketPanelLegacy(user)

/datum/ticket/proc/TicketPanelLegacy(mob/user)
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
		dat += span_bold("Actions:") + " [FullMonty(ref_src, check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)))]<br>"
	else
		dat += span_bold("DISCONNECTED") + "[GLOB.TAB][ClosureLinks(ref_src)]<br>"
	dat += "<br><b>Log:</b><br><br>"
	for(var/I in _interactions)
		dat += "[I]<br>"
	dat += "</html>"
	user << browse(dat.Join(), "window=ahelp[id];size=620x480")

/datum/tickets/proc/TicketListLegacy(mob/user, state)
	var/list/dat = list("<html><head><title>[state] Tickets</title></head>")
	var/tickets_found = 0

	if(state == "Active")
		for(var/datum/ticket/T as anything in GLOB.tickets.active_tickets)
			if(!check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)) && T.level > 0)
				continue
			dat += "[T.level == 0 ? "Mentorhelp" : "Adminhelp"] - [T.TicketHref("#[T.id] - [T.initiator_ckey]:  [T.name]")]"
			tickets_found++
	else if(state == "Closed")
		for(var/datum/ticket/T as anything in GLOB.tickets.closed_tickets)
			if(!check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)) && T.level > 0)
				continue
			dat += "[T.level == 0 ? "Mentorhelp" : "Adminhelp"] - [T.TicketHref("#[T.id] - [T.initiator_ckey]:  [T.name]")]"
			tickets_found++
	else if(state == "Resolved")
		for(var/datum/ticket/T as anything in GLOB.tickets.resolved_tickets)
			if(!check_rights_for(user.client, (R_ADMIN|R_SERVER|R_MOD)) && T.level > 0)
				continue
			dat += "[T.level == 0 ? "Mentorhelp" : "Adminhelp"] - [T.TicketHref("#[T.id] - [T.initiator_ckey]:  [T.name]")]"
			tickets_found++

	if(tickets_found == 0)
		dat += "No [state] tickets found."
	dat += "</html>"
	user << browse(dat.Join(), "window=ahelp-list;size=250x350")
