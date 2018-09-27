/obj/machinery/computer/supplycomp
<<<<<<< HEAD
=======
	name = "supply ordering console"
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
>>>>>>> 6ea25d6... Merge pull request #5505 from Atermonera/optimize_supply
	name = "supply control console"
	icon_keyboard = "tech_key"
	icon_screen = "supply"
	light_color = "#b88b2e"
	req_access = list(access_cargo)
	circuit = /obj/item/weapon/circuitboard/supplycomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/can_order_contraband = 0
	var/last_viewed_group = "categories"

/obj/machinery/computer/ordercomp
	name = "supply ordering console"
	icon_screen = "request"
	circuit = /obj/item/weapon/circuitboard/ordercomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/last_viewed_group = "categories"

/obj/machinery/computer/ordercomp/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/supplycomp/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/ordercomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat
	if(temp)
		dat = temp
	else
		var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
		if (shuttle)
			dat += {"<BR><B>Supply shuttle</B><HR>
			Location: [shuttle.has_arrive_time() ? "Moving to station ([shuttle.eta_minutes()] Mins.)":shuttle.at_station() ? "Docked":"Away"]<BR>
			<HR>Supply points: [supply_controller.points]<BR>
		<BR>\n<A href='?src=\ref[src];order=categories'>Request items</A><BR><BR>
		<A href='?src=\ref[src];vieworders=1'>View approved orders</A><BR><BR>
		<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR><BR>
		\n<A href='?src=\ref[src];viewexport=1'>View export report</A><BR><BR>
		<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/ordercomp/Topic(href, href_list)
	if(..())
		return 1

	if( isturf(loc) && (in_range(src, usr) || istype(usr, /mob/living/silicon)) )
		usr.set_machine(src)

<<<<<<< HEAD
	if(href_list["order"])
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply points: [supply_controller.points]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/supply_group_name in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[supply_group_name]'>[supply_group_name]</A><BR>"
=======


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

>>>>>>> 6ea25d6... Merge pull request #5505 from Atermonera/optimize_supply
		else
			last_viewed_group = href_list["order"]
			temp = "<b>Supply points: [supply_controller.points]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [last_viewed_group]</b><BR><BR>"
			for(var/supply_name in supply_controller.supply_packs )
				var/datum/supply_packs/N = supply_controller.supply_packs[supply_name]
				if(N.hidden || N.contraband || N.group != last_viewed_group) continue								//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"		//the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_controller.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		var/timeout = world.time + 600
		var/reason = sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text)
		if(world.time > timeout)	return
		if(!reason)	return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		supply_controller.ordernum++
		var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[station_name()] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_controller.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(P.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_controller.ordernum
		O.object = P
		O.orderedby = idname
		supply_controller.requestlist += O

		temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_controller.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in supply_controller.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/attack_hand(var/mob/user as mob)
	if(!allowed(user))
		user << "<span class='warning'>Access Denied.</span>"
		return

	if(..())
		return
	user.set_machine(src)
	post_signal("supply")
	var/dat
	if (temp)
		dat = temp
	else
<<<<<<< HEAD
		var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
		if (shuttle)
			dat += "<BR><B>Supply shuttle</B><HR>"
			dat += "\nLocation: "
			if (shuttle.has_arrive_time())
				dat += "In transit ([shuttle.eta_minutes()] Mins.)<BR>"
			else
				if (shuttle.at_station())
					if (shuttle.docking_controller)
						switch(shuttle.docking_controller.get_docking_status())
							if ("docked") dat += "Docked at station<BR>"
							if ("undocked") dat += "Undocked from station<BR>"
							if ("docking") dat += "Docking with station [shuttle.can_force()? "<span class='warning'><A href='?src=\ref[src];force_send=1'>Force Launch</A></span>" : ""]<BR>"
							if ("undocking") dat += "Undocking from station [shuttle.can_force()? "<span class='warning'><A href='?src=\ref[src];force_send=1'>Force Launch</A></span>" : ""]<BR>"
					else
						dat += "Station<BR>"

					if (shuttle.can_launch())
						dat += "<A href='?src=\ref[src];send=1'>Send away</A>"
					else if (shuttle.can_cancel())
						dat += "<A href='?src=\ref[src];cancel_send=1'>Cancel launch</A>"
					else
						dat += "*Shuttle is busy*"
					dat += "<BR>\n<BR>"
				else
					dat += "Away<BR>"
					if (shuttle.can_launch())
						dat += "<A href='?src=\ref[src];send=1'>Request supply shuttle</A>"
					else if (shuttle.can_cancel())
						dat += "<A href='?src=\ref[src];cancel_send=1'>Cancel request</A>"
					else
						dat += "*Shuttle is busy*"
					dat += "<BR>\n<BR>"


		dat += {"<HR>\nSupply points: [supply_controller.points]<BR>\n<BR>
		\n<A href='?src=\ref[src];order=categories'>Order items</A><BR>\n<BR>
		\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
		\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
		\n<A href='?src=\ref[src];viewexport=1'>View export report</A><BR>\n<BR>
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}


	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return
=======
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
	data["contraband"] = can_order_contraband

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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


>>>>>>> 6ea25d6... Merge pull request #5505 from Atermonera/optimize_supply

/obj/machinery/computer/supplycomp/emag_act(var/remaining_charges, var/mob/user)
	if(!can_order_contraband)
		user << "<span class='notice'>Special supplies unlocked.</span>"
		can_order_contraband = 1
		req_access = list()
		return 1

/obj/machinery/computer/supplycomp/Topic(href, href_list)
	if(!supply_controller)
		world.log << "## ERROR: Eek. The supply_controller controller datum is missing somehow."
		return
	var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
	if (!shuttle)
		world.log << "## ERROR: Eek. The supply/shuttle datum is missing somehow."
		return
	if(..())
		return 1

	if(isturf(loc) && ( in_range(src, usr) || istype(usr, /mob/living/silicon) ) )
		usr.set_machine(src)

<<<<<<< HEAD
	//Calling the shuttle
	if(href_list["send"])
		if(shuttle.at_station())
=======
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
>>>>>>> 6ea25d6... Merge pull request #5505 from Atermonera/optimize_supply
			if (shuttle.forbidden_atoms_check())
				temp = "For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			else
				shuttle.launch(src)
				temp = "Initiating launch sequence. \[<span class='warning'><A href='?src=\ref[src];force_send=1'>Force Launch</A></span>\]<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		else
			shuttle.launch(src)
			temp = "The supply shuttle has been called and will arrive in approximately [round(supply_controller.movetime/600,1)] minutes.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			post_signal("supply")

	if (href_list["force_send"])
		shuttle.force_launch(src)

	if (href_list["cancel_send"])
		shuttle.cancel_launch(src)

	else if (href_list["order"])
		//if(!shuttle.idle()) return	//this shouldn't be necessary it seems
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply points: [supply_controller.points]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/supply_group_name in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[supply_group_name]'>[supply_group_name]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			temp = "<b>Supply points: [supply_controller.points]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [last_viewed_group]</b><BR><BR>"
			for(var/supply_name in supply_controller.supply_packs )
				var/datum/supply_packs/N = supply_controller.supply_packs[supply_name]
				if((N.contraband && !can_order_contraband) || N.group != last_viewed_group) continue								//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"		//the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_controller.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		var/timeout = world.time + 600
		var/reason = sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text)
		if(world.time > timeout)	return
		if(!reason)	return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		supply_controller.ordernum++
		var/obj/item/weapon/paper/reqform = new /obj/item/weapon/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[station_name()] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_controller.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(P.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_controller.ordernum
		O.object = P
		O.orderedby = idname
		supply_controller.requestlist += O

		temp = "Order request placed.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> | <A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];confirmorder=[O.ordernum]'>Authorize Order</A>"

	else if(href_list["confirmorder"])
		//Find the correct supply_order datum
		var/ordernum = text2num(href_list["confirmorder"])
		var/datum/supply_order/O
		var/datum/supply_packs/P
		temp = "Invalid Request"
		for(var/i=1, i<=supply_controller.requestlist.len, i++)
			var/datum/supply_order/SO = supply_controller.requestlist[i]
			if(SO.ordernum == ordernum)
				O = SO
				P = O.object
				if(supply_controller.points >= P.cost)
					supply_controller.requestlist.Cut(i,i+1)
					supply_controller.points -= P.cost
					supply_controller.shoppinglist += O
					temp = "Thanks for your order.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				else
					temp = "Not enough supply points.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				break

	else if (href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_controller.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""]<BR>"// <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
/*
	else if (href_list["cancelorder"])
		var/datum/supply_order/remove_supply = href_list["cancelorder"]
		supply_shuttle_shoppinglist -= remove_supply
		supply_shuttle_points += remove_supply.object.cost
		temp += "Canceled: [remove_supply.object.name]<BR><BR><BR>"

		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""] <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
*/
	else if (href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in supply_controller.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby] <A href='?src=\ref[src];confirmorder=[SO.ordernum]'>Approve</A> <A href='?src=\ref[src];rreq=[SO.ordernum]'>Remove</A><BR>"

		temp += "<BR><A href='?src=\ref[src];clearreq=1'>Clear list</A>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["viewexport"])
		temp = "Previous shuttle export report: <BR><BR>"
		var/cratecount = 0
		var/totalvalue = 0
		for(var/S in supply_controller.exported_crates)
			var/datum/exported_crate/EC = S
			cratecount += 1
			totalvalue += EC.value
			temp += "[EC.name] exported for [EC.value] supply points<BR>"
		temp += "<BR>Shipment of [cratecount] crates exported for [totalvalue] supply points.<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["rreq"])
		var/ordernum = text2num(href_list["rreq"])
		temp = "Invalid Request.<BR>"
		for(var/i=1, i<=supply_controller.requestlist.len, i++)
			var/datum/supply_order/SO = supply_controller.requestlist[i]
			if(SO.ordernum == ordernum)
				supply_controller.requestlist.Cut(i,i+1)
				temp = "Request removed.<BR>"
				break
		temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["clearreq"])
		supply_controller.requestlist.Cut()
		temp = "List cleared.<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["mainmenu"])
		temp = null

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
