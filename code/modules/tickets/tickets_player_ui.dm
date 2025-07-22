//
//PLAYERSIDE TICKET UI
//

/datum/ticket_chat
	var/datum/ticket/T

/datum/ticket_chat/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TicketChat", "Ticket #[T.id] - [T.LinkedReplyName("\ref[T]")]")
		ui.open()
		user.clear_alert("open ticket")

/datum/ticket_chat/tgui_close(mob/user)
	. = ..()
	if(user.client.current_ticket)
		user.throw_alert("open ticket", /obj/screen/alert/open_ticket)

/datum/ticket_chat/tgui_state(mob/user)
	return GLOB.tgui_ticket_state

/datum/ticket_chat/tgui_data(mob/user)
	var/list/data = list()

	data["id"] = T.id

	data["level"] = T.level
	data["handler"] = T.handler

	data["log"] = T._interactions

	return data

/datum/ticket_chat/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return
	switch(action)
		if("send_msg")
			if(!params["msg"])
				return

			var/sane_message = sanitize(params["msg"])
			switch(T.level)
				if (0)
					if(T.initiator == ui.user.client)
						var/client/handler = T.handler_ref?.resolve()
						if(handler)
							ui.user.client.cmd_mentor_pm(handler, sane_message, T)
							return TRUE
						T.AddInteraction("[T.initiator_key_name]: [sane_message]")
						return TRUE
					ui.user.client.cmd_mentor_pm(T.initiator, sane_message, T)
					return TRUE
				if (1)
					if(T.initiator == ui.user.client)
						var/client/handler = T.handler_ref?.resolve()
						if(handler)
							ui.user.client.cmd_admin_pm(handler, sane_message, T)
							return TRUE
						T.AddInteraction("[key_name_admin(ui.user)]: [sane_message]")
						return TRUE
					ui.user.client.cmd_admin_pm(T.initiator, sane_message, T)
					return TRUE

			. = TRUE
