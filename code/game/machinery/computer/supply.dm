// While it initially feels like the ordering console should be a subtype of the main console,
// their function is similar enough that the ordering console emerges as the less specialized,
// and therefore more deserving of parent-class status -- Ater

// Supply requests console
/obj/machinery/computer/supplycomp
	name = "supply ordering console"
	desc = "Request crates from here! Delivery not guaranteed."
	icon_screen = "request"
	circuit = /obj/item/weapon/circuitboard/supplycomp
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
	circuit = /obj/item/weapon/circuitboard/supplycomp/control
	authorization = SUP_SEND_SHUTTLE | SUP_ACCEPT_ORDERS

/obj/machinery/computer/supplycomp/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/supplycomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	if(!allowed(user))
		return
	user.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/computer/supplycomp/emag_act(var/remaining_charges, var/mob/user)
	if(!can_order_contraband)
		to_chat(user, "<span class='notice'>Special supplies unlocked.</span>")
		authorization |= SUP_CONTRABAND
		req_access = list()
		return 1




/obj/machinery/computer/supplycomp/ui_interact(mob/user, ui_key = "supply_records", var/datum/nanoui/ui = null, var/force_open = 1, var/key_state = null)
	var/data[0]
	var/shuttle_status[0]	// Supply shuttle status
	var/pack_list[0]		// List of supply packs within the active_category
	var/orders[0]
	var/receipts[0]

	var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
	if(shuttle)
		if(shuttle.has_arrive_time())
			shuttle_status["location"] = "In transit"
			shuttle_status["mode"] = SUP_SHUTTLE_TRANSIT
			shuttle_status["time"] = shuttle.eta_minutes()

		else
			shuttle_status["time"] = 0
			if(shuttle.at_station())
				if(shuttle.docking_controller)
					switch(shuttle.docking_controller.get_docking_status())
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
		shuttle["mode"] = SUP_SHUTTLE_ERROR

	for(var/pack_name in supply_controller.supply_pack)
		var/datum/supply_pack/P = supply_controller.supply_pack[pack_name]
		if(P.group == active_category)
			var/list/pack = list(
					"name" = P.name,
					"cost" = P.cost,
					"contraband" = P.contraband,
					"manifest" = uniquelist(P.manifest),
					"random" = P.num_contained,
					"expand" = 0,
					"ref" = "\ref[P]"
				)

			if(P in expanded_packs)
				pack["expand"] = 1

			pack_list[++pack_list.len] = pack

	// Compile user-side orders
	// Status determines which menus the entry will display in
	// Organized in field-entry list for iterative display
	// List is nested so both the list of orders, and the list of elements in each order, can be iterated over
	for(var/datum/supply_order/S in supply_controller.order_history)
		orders[++orders.len] = list(
				"ref" = "\ref[S]",
				"status" = S.status,
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
			)

	// Compile exported crates
	for(var/datum/exported_crate/E in supply_controller.exported_crates)
		receipts[++receipts.len] = list(
				"ref" = "\ref[E]",
				"contents" = E.contents,
				"error" = E.contents["error"],
				"title" = list(
						list("field" = "Name", "entry" = E.name),
						list("field" = "Value", "entry" = E.value)
					)
			)

	data["user"] = "\ref[user]"
	data["currentTab"] = menu_tab // Communicator compatibility, controls which menu is in use
	data["shuttle_auth"] = (authorization & SUP_SEND_SHUTTLE) // Whether this ui is permitted to control the supply shuttle
	data["order_auth"] = (authorization & SUP_ACCEPT_ORDERS)   // Whether this ui is permitted to accept/deny requested orders
	data["shuttle"] = shuttle_status
	data["supply_points"] = supply_controller.points
	data["categories"] = all_supply_groups
	data["active_category"] = active_category
	data["supply_packs"] = pack_list
	data["orders"] = orders
	data["receipts"] = receipts
	data["contraband"] = can_order_contraband || (authorization & SUP_CONTRABAND)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "supply_records.tmpl", "Supply Console", 475, 700, state = key_state)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every 20 Master Controller tick
		ui.set_auto_update(20) // Longer term to reduce the rate of data collection and processing




/obj/machinery/computer/supplycomp/Topic(href, href_list)
	if(!supply_controller)
		to_world_log("## ERROR: The supply_controller datum is missing.")
		return
	var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
	if (!shuttle)
		to_world_log("## ERROR: The supply shuttle datum is missing.")
		return
	if(..())
		return 1

	if(isturf(loc) && ( in_range(src, usr) || istype(usr, /mob/living/silicon) ) )
		usr.set_machine(src)

	// NEW TOPIC

	// Switch menu
	if(href_list["switch_tab"])
		menu_tab = href_list["switch_tab"]

	if(href_list["active_category"])
		active_category = href_list["active_category"]

	if(href_list["pack_ref"])
		var/datum/supply_pack/S = locate(href_list["pack_ref"])

		// Invalid ref
		if(!istype(S))
			return

		// Expand the supply pack's contents
		if(href_list["expand"])
			expanded_packs ^= S

		// Make a request for the pack
		if(href_list["request"])
			var/mob/user = locate(href_list["user"])
			if(!istype(user)) // Invalid ref
				return

			if(world.time < reqtime)
				visible_message("<span class='warning'>[src]'s monitor flashes, \"[reqtime - world.time] seconds remaining until another requisition form may be printed.\"</span>")
				return

			var/timeout = world.time + 600
			var/reason = sanitize(input(user, "Reason:","Why do you require this item?","") as null|text)
			if(world.time > timeout)
				to_chat(user, "<span class='warning'>Error. Request timed out.</span>")
				return
			if(!reason)
				return

			supply_controller.create_order(S, user, reason)

			var/idname = "*None Provided*"
			var/idrank = "*None Provided*"
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				idname = H.get_authentification_name()
				idrank = H.get_assignment()
			else if(issilicon(user))
				idname = user.real_name
				idrank = "Stationbound synthetic"

			var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
			reqform.name = "Requisition Form - [S.name]"
			reqform.info += "<h3>[station_name()] Supply Requisition Form</h3><hr>"
			reqform.info += "INDEX: #[supply_controller.ordernum]<br>"
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

	if(href_list["order_ref"])
		var/datum/supply_order/O = locate(href_list["order_ref"])

		// Invalid ref
		if(!istype(O))
			return

		var/mob/user = locate(href_list["user"])
		if(!istype(user)) // Invalid ref
			return

		if(href_list["edit"])
			var/new_val = sanitize(input(user, href_list["edit"], "Enter the new value for this field:", href_list["default"]) as null|text)
			if(!new_val)
				return

			switch(href_list["edit"])
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

		if(href_list["approve"])
			supply_controller.approve_order(O, user)

		if(href_list["deny"])
			supply_controller.deny_order(O, user)

		if(href_list["delete"])
			supply_controller.delete_order(O, user)

	if(href_list["clear_all_requests"])
		var/mob/user = locate(href_list["user"])
		if(!istype(user)) // Invalid ref
			return

		supply_controller.deny_all_pending(user)

	if(href_list["export_ref"])
		var/datum/exported_crate/E = locate(href_list["export_ref"])

		// Invalid ref
		if(!istype(E))
			return

		var/mob/user = locate(href_list["user"])
		if(!istype(user)) // Invalid ref
			return

		if(href_list["index"])
			var/list/L = E.contents[href_list["index"]]

			if(href_list["edit"])
				var/field = alert(user, "Select which field to edit", , "Name", "Quantity", "Value")

				var/new_val = sanitize(input(user, href_list["edit"], "Enter the new value for this field:", href_list["default"]) as null|text)
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

			if(href_list["delete"])
				E.contents.Cut(href_list["index"], href_list["index"] + 1)

		// Else clause means they're editing/deleting the whole export report, rather than a specific item in it
		else if(href_list["edit"])
			var/new_val = sanitize(input(user, href_list["edit"], "Enter the new value for this field:", href_list["default"]) as null|text)
			if(!new_val)
				return

			switch(href_list["edit"])
				if("Name")
					E.name = new_val

				if("Value")
					var/num = text2num(new_val)
					if(num)
						E.value = num

		else if(href_list["delete"])
			supply_controller.delete_export(E, user)

		else if(href_list["add_item"])
			supply_controller.add_export_item(E, user)



	switch(href_list["send_shuttle"])
		if("send_away")
			if (shuttle.forbidden_atoms_check())
				to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.</span>")
			else
				shuttle.launch(src)
				to_chat(usr, "<span class='notice'>Initiating launch sequence.</span>")

		if("send_to_station")
			shuttle.launch(src)
			to_chat(usr, "<span class='notice'>The supply shuttle has been called and will arrive in approximately [round(supply_controller.movetime/600,1)] minutes.</span>")

		if("cancel_shuttle")
			shuttle.cancel_launch(src)

		if("force_shuttle")
			shuttle.force_launch(src)

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)
