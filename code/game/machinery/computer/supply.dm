// While it initially feels like the ordering console should be a subtype of the main console,
// their function is similar enough that the ordering console emerges as the less specialized,
// and therefore more deserving of parent-class status -- Ater

// Supply requests console
/obj/machinery/computer/supplycomp
	name = "supply ordering console"
	desc = "Request crates from here! Delivery not guaranteed."
	icon_screen = "request"
	circuit = /obj/item/circuitboard/supplycomp
	var/authorization = 0
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/can_order_contraband = 0
	var/active_category = null
	var/menu_tab = 0
	var/list/expanded_packs = list()

// Supply control console
/obj/machinery/computer/supplycomp/control
	name = "supply control console"
	desc = "Control the cargo shuttle's functions remotely."
	icon_keyboard = "tech_key"
	icon_screen = "supply"
	light_color = "#b88b2e"
	req_access = list(access_cargo)
	circuit = /obj/item/circuitboard/supplycomp/control
	authorization = SUP_SEND_SHUTTLE | SUP_ACCEPT_ORDERS

/obj/machinery/computer/supplycomp/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/supplycomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>You don't have the required access to use this console.</span>")
		return
	user.set_machine(src)
	tgui_interact(user)
	return

/obj/machinery/computer/supplycomp/emag_act(var/remaining_charges, var/mob/user)
	if(!can_order_contraband)
		to_chat(user, "<span class='notice'>Special supplies unlocked.</span>")
		authorization |= SUP_CONTRABAND
		req_access = list()
		can_order_contraband = TRUE
		return 1


// TGUI
/obj/machinery/computer/supplycomp/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SupplyConsole", name)
		ui.open()

/obj/machinery/computer/supplycomp/tgui_data(mob/user)
	var/list/data = ..()
	var/list/shuttle_status = list()

	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if(shuttle)
		if(shuttle.has_arrive_time())
			shuttle_status["location"] = "In transit"
			shuttle_status["mode"] = SUP_SHUTTLE_TRANSIT
			shuttle_status["time"] = shuttle.eta_deciseconds() // tgui expects time for it's formatTime() in DS

		else
			shuttle_status["time"] = 0
			if(shuttle.at_station())
				if(shuttle.shuttle_docking_controller)
					switch(shuttle.shuttle_docking_controller.get_docking_status())
						if("docked")
							shuttle_status["location"] = "Docked"
							shuttle_status["mode"] = SUP_SHUTTLE_DOCKED
						if("undocked")
							shuttle_status["location"] = "Undocked"
							shuttle_status["mode"] = SUP_SHUTTLE_UNDOCKED
						if("docking")
							shuttle_status["location"] = "Docking"
							shuttle_status["mode"] = SUP_SHUTTLE_DOCKING
							shuttle_status["force"] = shuttle.can_force()
						if("undocking")
							shuttle_status["location"] = "Undocking"
							shuttle_status["mode"] = SUP_SHUTTLE_UNDOCKING
							shuttle_status["force"] = shuttle.can_force()

				else
					shuttle_status["location"] = "Station"
					shuttle_status["mode"] = SUP_SHUTTLE_DOCKED

			else
				shuttle_status["location"] = "Away"
				shuttle_status["mode"] = SUP_SHUTTLE_AWAY

			if(shuttle.can_launch())
				shuttle_status["launch"] = 1
			else if(shuttle.can_cancel())
				shuttle_status["launch"] = 2
			else
				shuttle_status["launch"] = 0

		switch(shuttle.moving_status)
			if(SHUTTLE_IDLE)
				shuttle_status["engine"] = "Idle"
			if(SHUTTLE_WARMUP)
				shuttle_status["engine"] = "Warming up"
			if(SHUTTLE_INTRANSIT)
				shuttle_status["engine"] = "Engaged"

	else
		shuttle_status["mode"] = SUP_SHUTTLE_ERROR

	// Compile user-side orders
	// Status determines which menus the entry will display in
	// Organized in field-entry list for iterative display
	// List is nested so both the list of orders, and the list of elements in each order, can be iterated over
	var/list/orders = list()
	for(var/datum/supply_order/S in SSsupply.order_history)
		orders.Add(list(list(
			"ref" = "\ref[S]",
			"status" = S.status,
			"cost" = S.cost,
			"entries" = list(
				list("field" = "Supply Pack", "entry" = S.name),
				list("field" = "Cost", "entry" = S.cost),
				list("field" = "Index", "entry" = S.index),
				list("field" = "Reason", "entry" = S.comment),
				list("field" = "Ordered by", "entry" = S.ordered_by),
				list("field" = "Ordered at", "entry" = S.ordered_at),
				list("field" = "Approved by", "entry" = S.approved_by),
				list("field" = "Approved at", "entry" = S.approved_at)
				)
			)))

	// Compile exported crates
	var/list/receipts = list()
	for(var/datum/exported_crate/E in SSsupply.exported_crates)
		receipts.Add(list(list(
			"ref" = "\ref[E]",
			"contents" = E.contents,
			"error" = E.contents["error"],
			"title" = list(
				list("field" = "Name", "entry" = E.name),
				list("field" = "Value", "entry" = E.value)
			)
		)))

	data["shuttle_auth"] = (authorization & SUP_SEND_SHUTTLE) // Whether this ui is permitted to control the supply shuttle
	data["order_auth"] = (authorization & SUP_ACCEPT_ORDERS)   // Whether this ui is permitted to accept/deny requested orders
	data["shuttle"] = shuttle_status
	data["supply_points"] = SSsupply.points
	data["orders"] = orders
	data["receipts"] = receipts
	data["contraband"] = can_order_contraband || (authorization & SUP_CONTRABAND)
	data["modal"] = tgui_modal_data(src)
	return data

/obj/machinery/computer/supplycomp/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/pack_list = list()
	for(var/pack_name in SSsupply.supply_pack)
		var/datum/supply_pack/P = SSsupply.supply_pack[pack_name]
		var/list/pack = list(
				"name" = P.name,
				"cost" = P.cost,
				"group" = P.group,
				"contraband" = P.contraband,
				"manifest" = uniqueList(P.manifest),
				"random" = P.num_contained,
				"ref" = "\ref[P]"
			)

		pack_list.Add(list(pack))
	data["supply_packs"] = pack_list
	data["categories"] = all_supply_groups
	return data

/obj/machinery/computer/supplycomp/tgui_act(action, params)
	if(..())
		return TRUE
	if(!SSsupply)
		log_runtime(EXCEPTION("## ERROR: The SSsupply datum is missing."))
		return TRUE
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if(!shuttle)
		log_runtime(EXCEPTION("## ERROR: The supply shuttle datum is missing."))
		return TRUE

	if(tgui_modal_act(src, action, params))
		return TRUE

	switch(action)
		if("view_crate")
			var/datum/supply_pack/P = locate(params["crate"])
			if(!istype(P))
				return FALSE
			var/list/payload = list(
				"name" = P.name,
				"cost" = P.cost,
				"manifest" = uniqueList(P.manifest),
				"ref" = "\ref[P]",
				"random" = P.num_contained,
			)
			tgui_modal_message(src, action, "", null, payload)
			. = TRUE
		if("request_crate_multi")
			var/datum/supply_pack/S = locate(params["ref"])

			// Invalid ref
			if(!istype(S))
				return FALSE

			if(S.contraband && !(authorization & SUP_CONTRABAND || can_order_contraband))
				return FALSE

			if(world.time < reqtime)
				visible_message("<span class='warning'>[src]'s monitor flashes, \"[reqtime - world.time] seconds remaining until another requisition form may be printed.\"</span>")
				return FALSE

			var/amount = clamp(tgui_input_number(usr, "How many crates? (0 to 20)", null, null, 20, 0), 0, 20)
			if(!amount)
				return FALSE

			var/timeout = world.time + 600
			var/reason = sanitize(tgui_input_text(usr, "Reason:","Why do you require this item?",""))
			if(world.time > timeout)
				to_chat(usr, "<span class='warning'>Error. Request timed out.</span>")
				return FALSE
			if(!reason)
				return FALSE

			for(var/i in 1 to amount)
				SSsupply.create_order(S, usr, reason)

			var/idname = "*None Provided*"
			var/idrank = "*None Provided*"
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				idname = H.get_authentification_name()
				idrank = H.get_assignment()
			else if(issilicon(usr))
				idname = usr.real_name
				idrank = "Stationbound synthetic"

			var/obj/item/paper/reqform = new /obj/item/paper(loc)
			reqform.name = "Requisition Form - [S.name]"
			reqform.info += "<h3>[station_name()] Supply Requisition Form</h3><hr>"
			reqform.info += "INDEX: #[SSsupply.ordernum]<br>"
			reqform.info += "REQUESTED BY: [idname]<br>"
			reqform.info += "RANK: [idrank]<br>"
			reqform.info += "REASON: [reason]<br>"
			reqform.info += "SUPPLY CRATE TYPE: [S.name]<br>"
			reqform.info += "ACCESS RESTRICTION: [get_access_desc(S.access)]<br>"
			reqform.info += "AMOUNT: [amount]<br>"
			reqform.info += "CONTENTS:<br>"
			reqform.info +=  S.get_html_manifest()
			reqform.info += "<hr>"
			reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

			reqform.update_icon()	//Fix for appearing blank when printed.
			reqtime = (world.time + 5) % 1e5
			. = TRUE

		if("request_crate")
			var/datum/supply_pack/S = locate(params["ref"])

			// Invalid ref
			if(!istype(S))
				return FALSE

			if(S.contraband && !(authorization & SUP_CONTRABAND || can_order_contraband))
				return FALSE

			if(world.time < reqtime)
				visible_message("<span class='warning'>[src]'s monitor flashes, \"[reqtime - world.time] seconds remaining until another requisition form may be printed.\"</span>")
				return FALSE

			var/timeout = world.time + 600
			var/reason = sanitize(tgui_input_text(usr, "Reason:","Why do you require this item?",""))
			if(world.time > timeout)
				to_chat(usr, "<span class='warning'>Error. Request timed out.</span>")
				return FALSE
			if(!reason)
				return FALSE

			SSsupply.create_order(S, usr, reason)

			var/idname = "*None Provided*"
			var/idrank = "*None Provided*"
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				idname = H.get_authentification_name()
				idrank = H.get_assignment()
			else if(issilicon(usr))
				idname = usr.real_name
				idrank = "Stationbound synthetic"

			var/obj/item/paper/reqform = new /obj/item/paper(loc)
			reqform.name = "Requisition Form - [S.name]"
			reqform.info += "<h3>[station_name()] Supply Requisition Form</h3><hr>"
			reqform.info += "INDEX: #[SSsupply.ordernum]<br>"
			reqform.info += "REQUESTED BY: [idname]<br>"
			reqform.info += "RANK: [idrank]<br>"
			reqform.info += "REASON: [reason]<br>"
			reqform.info += "SUPPLY CRATE TYPE: [S.name]<br>"
			reqform.info += "ACCESS RESTRICTION: [get_access_desc(S.access)]<br>"
			reqform.info += "CONTENTS:<br>"
			reqform.info +=  S.get_html_manifest()
			reqform.info += "<hr>"
			reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

			reqform.update_icon()	//Fix for appearing blank when printed.
			reqtime = (world.time + 5) % 1e5
			. = TRUE
		// Approving Orders
		if("edit_order_value")
			var/datum/supply_order/O = locate(params["ref"])
			if(!istype(O))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			var/new_val = sanitize(tgui_input_text(usr, params["edit"], "Enter the new value for this field:", params["default"]))
			if(!new_val)
				return FALSE

			switch(params["edit"])
				if("Supply Pack")
					O.name = new_val

				if("Cost")
					var/num = text2num(new_val)
					if(num)
						O.cost = num

				if("Index")
					var/num = text2num(new_val)
					if(num)
						O.index = num

				if("Reason")
					O.comment = new_val

				if("Ordered by")
					O.ordered_by = new_val

				if("Ordered at")
					O.ordered_at = new_val

				if("Approved by")
					O.approved_by = new_val

				if("Approved at")
					O.approved_at = new_val
			. = TRUE
		if("approve_order")
			var/datum/supply_order/O = locate(params["ref"])
			if(!istype(O))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			SSsupply.approve_order(O, usr)
			. = TRUE
		if("deny_order")
			var/datum/supply_order/O = locate(params["ref"])
			if(!istype(O))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			SSsupply.deny_order(O, usr)
			. = TRUE
		if("delete_order")
			var/datum/supply_order/O = locate(params["ref"])
			if(!istype(O))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			SSsupply.delete_order(O, usr)
			. = TRUE
		if("clear_all_requests")
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			SSsupply.deny_all_pending(usr)
			. = TRUE
		// Exports
		if("export_edit_field")
			var/datum/exported_crate/E = locate(params["ref"])
			// Invalid ref
			if(!istype(E))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			var/list/L = E.contents[params["index"]]
			var/field = tgui_alert(usr, "Select which field to edit", "Field Choice", list("Name", "Quantity", "Value"))
			if(!field)
				return FALSE

			var/new_val = sanitize(tgui_input_text(usr, field, "Enter the new value for this field:", L[lowertext(field)]))
			if(!new_val)
				return

			switch(field)
				if("Name")
					L["object"] = new_val

				if("Quantity")
					var/num = text2num(new_val)
					if(num)
						L["quantity"] = num

				if("Value")
					var/num = text2num(new_val)
					if(num)
						L["value"] = num
			. = TRUE
		if("export_delete_field")
			var/datum/exported_crate/E = locate(params["ref"])
			// Invalid ref
			if(!istype(E))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			E.contents.Cut(params["index"], params["index"] + 1)
			. = TRUE
		if("export_add_field")
			var/datum/exported_crate/E = locate(params["ref"])
			// Invalid ref
			if(!istype(E))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			SSsupply.add_export_item(E, usr)
			. = TRUE
		if("export_edit")
			var/datum/exported_crate/E = locate(params["ref"])
			// Invalid ref
			if(!istype(E))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			var/new_val = sanitize(tgui_input_text(usr, params["edit"], "Enter the new value for this field:", params["default"]))
			if(!new_val)
				return

			switch(params["edit"])
				if("Name")
					E.name = new_val

				if("Value")
					var/num = text2num(new_val)
					if(num)
						E.value = num
			. = TRUE
		if("export_delete")
			var/datum/exported_crate/E = locate(params["ref"])
			// Invalid ref
			if(!istype(E))
				return FALSE
			if(!(authorization & SUP_ACCEPT_ORDERS))
				return FALSE
			SSsupply.delete_export(E, usr)
			. = TRUE
		if("send_shuttle")
			switch(params["mode"])
				if("send_away")
					if (shuttle.forbidden_atoms_check())
						to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.</span>")
					else
						shuttle.launch(src)
						to_chat(usr, "<span class='notice'>Initiating launch sequence.</span>")

				if("send_to_station")
					shuttle.launch(src)
					to_chat(usr, "<span class='notice'>The supply shuttle has been called and will arrive in approximately [round(SSsupply.movetime/600,1)] minutes.</span>")

				if("cancel_shuttle")
					shuttle.cancel_launch(src)

				if("force_shuttle")
					shuttle.force_launch(src)
			. = TRUE

	add_fingerprint(usr)

/obj/machinery/computer/supplycomp/proc/post_signal(var/command)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)
