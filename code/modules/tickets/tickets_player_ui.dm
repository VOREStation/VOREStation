//
//PLAYERSIDE TICKET UI
//

/datum/ticket_chat
	var/datum/ticket/T

/datum/ticket_chat/tgui_interact(mob/user, datum/tgui/ui)
	return // Remove this line to enable player-side ticket ui
	//ui = SStgui.try_update_ui(user, src, ui)
	//if(!ui)
	//	ui = new(user, src, "TicketChat", "Ticket #[T.id] - [T.LinkedReplyName("\ref[T]")]")
	//	ui.open()
	//	user.clear_alert("open ticket")

/datum/ticket_chat/tgui_close(mob/user)
	. = ..()
	return // Remove this line to enable player-side ticket ui
	//if(user.client.current_ticket)
	//	user.throw_alert("open ticket", /obj/screen/alert/open_ticket)

/datum/ticket_chat/tgui_state(mob/user)
	return GLOB.tgui_admin_state // Remove this line to enable player-side ticket ui
	//return GLOB.tgui_ticket_state

/datum/ticket_chat/tgui_data(mob/user)
	var/list/data = list()

	data["id"] = T.id

	data["level"] = T.level
	// data["handler"] = T.handler // Uncomment this line to enable player-side ticket ui

	// data["log"] = T._interactions // Uncomment this line to enable player-side ticket ui

	return data

/datum/ticket_chat/tgui_act(action, params)
	if(..())
		return
	switch(action)
		if("send_msg")
			if(!params["msg"])
				return

			usr.client.cmd_admin_pm(usr.client, sanitize(params["msg"]), T)
			. = TRUE
