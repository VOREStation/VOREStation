// Communicator peripheral devices
// Internal devices that attack() can be relayed to
// Additional UI menus for added functionality
/obj/item/weapon/commcard
	name = "generic commcard"
	desc = "A peripheral plug-in for personal communicators."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = ITEMSIZE_TINY

	var/list/internal_devices = list() // Devices that can be toggled on to trigger on attack()
	var/list/active_devices = list()   // Devices that will be triggered on attack()
	var/list/ui_templates = list()     // List of ui templates the commcard can access
	var/list/internal_data = list()	   // Data that shouldn't be updated every time nanoUI updates, or needs to persist between updates


/obj/item/weapon/commcard/proc/get_device_status()
	var/list/L = list()
	var/i = 1
	for(var/obj/I in internal_devices)
		if(I in active_devices)
			L[++L.len] = list("name" = "\proper[I.name]", "active" = 1, "index" = i++)
		else
			L[++L.len] = list("name" = I.name, "active" = 0, "index" = i++)
	return L


// cartridge.get_data() returns a list of tuples:
// The field element is the tag used to access the information by the template
// The value element is the actual data, and can take any form necessary for the template
/obj/item/weapon/commcard/proc/get_data()
	return list()

// Handles cartridge-specific functions
// The helper.link() MUST HAVE 'cartridge_topic' passed into the href in order for cartridge functions to be processed.
// Doesn't matter what the value of it is for now, it's just a flag to say, "Hey, there's cartridge data to change!"
/obj/item/weapon/commcard/Topic(href, href_list)

	// Signalers
	if(href_list["signaler_target"])

		var/obj/item/device/assembly/signaler/S = locate(href_list["signaler_target"]) // Should locate the correct signaler

		if(!istype(S)) // Ref is no longer valid
			return

		if(S.loc != src) // No longer within the cartridge
			return

		switch(href_list["signaler_action"])
			if("Pulse")
				S.activate()

			if("Edit")
				var/mob/user = locate(href_list["user"])
				if(!istype(user)) // Ref no longer valid
					return

				var/newVal = input(user, "Input a new [href_list["signaler_value"]].", href_list["signaler_value"], (href_list["signaler_value"] == "Code" ? S.code : S.frequency)) as num|null
				if(newVal)
					switch(href_list["signaler_value"])
						if("Code")
							S.code = newVal

						if("Frequency")
							S.frequency = newVal

	// Refresh list of powernet sensors
	if(href_list["powernet_refresh"])
		internal_data["grid_sensors"] = find_powernet_sensors()

	// Load apc's on targeted powernet
	if(href_list["powernet_target"])
		internal_data["powernet_target"] = href_list["powernet_target"]

	// GPS units
	if(href_list["gps_target"])
		var/obj/item/device/gps/G = locate(href_list["gps_target"])

		if(!istype(G)) // Ref is no longer valid
			return

		if(G.loc != src) // No longer within the cartridge
			return

		switch(href_list["gps_action"])
			if("Power")
				G.tracking = text2num(href_list["value"])

			if("Long_Range")
				G.local_mode = text2num(href_list["value"])

			if("Hide_Signal")
				G.hide_signal = text2num(href_list["value"])

			if("Tag")
				var/mob/user = locate(href_list["user"])
				if(!istype(user)) // Ref no longer valid
					return

				var/newTag = input(user, "Please enter desired tag.", G.tag) as text|null

				if(newTag)
					G.tag = newTag

		if(href_list["active_category"])
			internal_data["supply_category"] = href_list["active_category"]

	// Supply topic
	// Copied from /obj/machinery/computer/supplycomp/Topic()
	// code\game\machinery\computer\supply.dm, line 188
	// Unfortunately, in order to support complete functionality, the whole thing is necessary
	if(href_list["pack_ref"])
		var/datum/supply_pack/S = locate(href_list["pack_ref"])

		// Invalid ref
		if(!istype(S))
			return

		// Expand the supply pack's contents
		if(href_list["expand"])
			internal_data["supply_pack_expanded"] ^= S

		// Make a request for the pack
		if(href_list["request"])
			var/mob/user = locate(href_list["user"])
			if(!istype(user)) // Invalid ref
				return

			if(world.time < internal_data["supply_reqtime"])
				visible_message("<span class='warning'>[src] flashes, \"[internal_data["supply_reqtime"] - world.time] seconds remaining until another requisition form may be printed.\"</span>")
				return

			var/timeout = world.time + 600
			var/reason = sanitize(input(user, "Reason:","Why do you require this item?","") as null|text)
			if(world.time > timeout)
				to_chat(user, "<span class='warning'>Error. Request timed out.</span>")
				return
			if(!reason)
				return

			supply_controller.create_order(S, user, reason)
			internal_data["supply_reqtime"] = (world.time + 5) % 1e5

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

	if(supply_controller && supply_controller.shuttle)
		switch(href_list["send_shuttle"])
			if("send_away")
				if(supply_controller.shuttle.forbidden_atoms_check())
					to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.</span>")
				else
					supply_controller.shuttle.launch(src)
					to_chat(usr, "<span class='notice'>Initiating launch sequence.</span>")

			if("send_to_station")
				supply_controller.shuttle.launch(src)
				to_chat(usr, "<span class='notice'>The supply shuttle has been called and will arrive in approximately [round(supply_controller.movetime/600,1)] minutes.</span>")

			if("cancel_shuttle")
				supply_controller.shuttle.cancel_launch(src)

			if("force_shuttle")
				supply_controller.shuttle.force_launch(src)

	// Status display
	switch(href_list["stat_display"])
		if("message")
			post_status("message", internal_data["stat_display_line1"], internal_data["stat_display_line2"])
			internal_data["stat_display_special"] = "message"
		if("alert")
			post_status("alert", href_list["alert"])
			internal_data["stat_display_special"] = href_list["alert"]
		if("setmsg")
			internal_data["stat_display_line[href_list["line"]]"] = reject_bad_text(sanitize(input("Line 1", "Enter Message Text", internal_data["stat_display_line[href_list["line"]]"]) as text|null, 40), 40)
		else
			post_status(href_list["stat_display"])
			internal_data["stat_display_special"] = href_list["stat_display"]

	// Merc shuttle blast door controls
	switch(href_list["all_blast_doors"])
		if("open")
			for(var/obj/machinery/door/blast/B in internal_data["shuttle_doors"])
				B.open()
		if("close")
			for(var/obj/machinery/door/blast/B in internal_data["shuttle_doors"])
				B.close()

	if(href_list["scan_blast_doors"])
		internal_data["shuttle_doors"] = find_blast_doors()

	if(href_list["toggle_blast_door"])
		var/obj/machinery/door/blast/B = locate(href_list["toggle_blast_door"])
		if(!B)
			return
		spawn(0)
			if(B.density)
				B.open()
			else
				B.close()


// Updates status displays with a new message
// Copied from /obj/item/weapon/cartridge/proc/post_status(),
// code/game/objects/items/devices/PDA/cart.dm, line 251
/obj/item/weapon/commcard/proc/post_status(var/command, var/data1, var/data2)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
	if(!frequency)
		return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			internal_data["stat_display_active1"] = data1 // Update the internally stored message, we won't get receive_signal if we're the sender
			internal_data["stat_display_active2"] = data2
			if(loc)
				var/obj/item/PDA = loc
				var/mob/user = PDA.fingerprintslast
				log_admin("STATUS: [user] set status screen with [src]. Message: [data1] [data2]")
				message_admins("STATUS: [user] set status screen with [src]. Message: [data1] [data2]")

		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)

// Receives updates by external devices to the status displays
/obj/item/weapon/commcard/receive_signal(var/datum/signal/signal, var/receive_method, var/receive_param)
	internal_data["stat_display_special"] = signal.data["command"]
	switch(signal.data["command"])
		if("message")
			internal_data["stat_display_active1"] = signal.data["msg1"]
			internal_data["stat_display_active2"] = signal.data["msg2"]
		if("alert")
			internal_data["stat_display_special"] = signal.data["picture_state"]


///////////////////////////
// SUBTYPES
///////////////////////////


// Engineering Cartridge:
// Devices
//  *- Halogen Counter
// Templates
//  *- Power Monitor
/obj/item/weapon/commcard/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	ui_templates = list(list("name" = "Power Monitor", "template" = "comm_power_monitor.tmpl"))

/obj/item/weapon/commcard/engineering/New()
	..()
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/engineering/Initialize()
	internal_data["grid_sensors"] = find_powernet_sensors()
	internal_data["powernet_target"] = ""

/obj/item/weapon/commcard/engineering/get_data()
	return list(
			list("field" = "powernet_monitoring", "value" = get_powernet_monitoring_list()),
			list("field" = "powernet_target", "value" = get_powernet_target(internal_data["powernet_target"]))
		)

// Atmospherics Cartridge:
// Devices
//  *- Gas scanner
/obj/item/weapon/commcard/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"

/obj/item/weapon/commcard/atmos/New()
	..()
	internal_devices |= new /obj/item/device/analyzer(src)


// Medical Cartridge:
// Devices
//  *- Halogen Counter
//  *- Health Analyzer
// Templates
//  *- Medical Records
/obj/item/weapon/commcard/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	ui_templates = list(list("name" = "Medical Records", "template" = "med_records.tmpl"))

/obj/item/weapon/commcard/medical/New()
	..()
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/medical/get_data()
	return list(list("field" = "med_records", "value" = get_med_records()))


// Chemistry Cartridge:
// Devices
//  *- Halogen Counter
//  *- Health Analyzer
//  *- Reagent Scanner
// Templates
//  *- Medical Records
/obj/item/weapon/commcard/medical/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"

/obj/item/weapon/commcard/medical/chemistry/New()
	..()
	internal_devices |= new /obj/item/device/reagent_scanner(src)


// Detective Cartridge:
// Devices
//  *- Halogen Counter
//  *- Health Analyzer
// Templates
//  *- Medical Records
//  *- Security Records
/obj/item/weapon/commcard/medical/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-s"
	ui_templates = list(
			list("name" = "Medical Records", "template" = "med_records.tmpl"),
			list("name" = "Security Records", "template" = "sec_records.tmpl")
		)

/obj/item/weapon/commcard/medical/detective/get_data()
	var/list/data = ..()
	data[++data.len] = list("field" = "sec_records", "value" = get_sec_records())
	return data


// Internal Affairs Cartridge:
// Templates
//  *- Security Records
//  *- Employment Records
/obj/item/weapon/commcard/int_aff
	name = "\improper P.R.O.V.E. cartridge"
	icon_state = "cart-s"
	ui_templates = list(
			list("name" = "Employment Records", "template" = "emp_records.tmpl"),
			list("name" = "Security Records", "template" = "sec_records.tmpl")
		)

/obj/item/weapon/commcard/int_aff/get_data()
	return list(
			list("field" = "emp_records", "value" = get_emp_records()),
			list("field" = "sec_records", "value" = get_sec_records())
		)


// Security Cartridge:
// Templates
//  *- Security Records
//  *- Security Bot Access
/obj/item/weapon/commcard/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	ui_templates = list(
			list("name" = "Security Records", "template" = "sec_records.tmpl"),
			list("name" = "Security Bot Control", "template" = "sec_bot_access.tmpl")
		)

/obj/item/weapon/commcard/security/get_data()
	return list(
			list("field" = "sec_records", "value" = get_sec_records()),
			list("field" = "sec_bot_access", "value" = get_sec_bot_access())
		)


// Janitor Cartridge:
// Templates
//  *- Janitorial Locator Magicbox
/obj/item/weapon/commcard/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	ui_templates = list(
			list("name" = "Janitorial Supply Locator", "template" = "janitorialLocator.tmpl")
		)

/obj/item/weapon/commcard/janitor/get_data()
	return list(
			list("field" = "janidata", "value" = get_janitorial_locations())
		)


// Signal Cartridge:
// Devices
//  *- Signaler
// Templates
//  *- Signaler Access
/obj/item/weapon/commcard/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."
	ui_templates = list(
			list("name" = "Integrated Signaler Control", "template" = "signaler_access.tmpl")
		)

/obj/item/weapon/commcard/signal/New()
	..()
	internal_devices |= new /obj/item/device/assembly/signaler(src)

/obj/item/weapon/commcard/signal/get_data()
	return list(
			list("field" = "signaler_access", "value" = get_int_signalers())
		)


// Science Cartridge:
// Devices
//  *- Signaler
//  *- Reagent Scanner
//  *- Gas Scanner
// Templates
//  *- Signaler Access
/obj/item/weapon/commcard/signal/science
	name = "\improper Signal Ace 2 cartridge"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	// UI templates inherited

/obj/item/weapon/commcard/signal/science/New()
	..()
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/analyzer(src)


// Supply Cartridge:
// Templates
//  *- Supply Records
/obj/item/weapon/commcard/supply
	name = "\improper Space Parts & Space Vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	ui_templates = list(
			list("name" = "Supply Records", "template" = "supply_records.tmpl")
		)

/obj/item/weapon/commcard/supply/New()
	..()
	internal_data["supply_category"] = null
	internal_data["supply_controls"] = FALSE // Cannot control the supply shuttle, cannot accept orders
	internal_data["supply_pack_expanded"] = list()
	internal_data["supply_reqtime"] = -1

/obj/item/weapon/commcard/supply/get_data()
	// Supply records data
	var/list/shuttle_status = get_supply_shuttle_status()
	var/list/orders = get_supply_orders()
	var/list/receipts = get_supply_receipts()
	var/list/misc_supply_data = get_misc_supply_data() // Packaging this stuff externally so it's less hardcoded into the specific cartridge
	var/list/pack_list = list() // List of supply packs within the currently selected category

	if(internal_data["supply_category"])
		pack_list = get_supply_pack_list()

	return list(
			list("field" = "shuttle_auth",		"value" = misc_supply_data["shuttle_auth"]),
			list("field" = "order_auth", 		"value" = misc_supply_data["order_auth"]),
			list("field" = "supply_points",		"value" = misc_supply_data["supply_points"]),
			list("field" = "categories",		"value" = misc_supply_data["supply_categories"]),
			list("field" = "contraband",		"value" = misc_supply_data["contraband"]),
			list("field" = "active_category",	"value" = internal_data["supply_category"]),
			list("field" = "shuttle",			"value" = shuttle_status),
			list("field" = "orders",			"value" = orders),
			list("field" = "receipts",			"value" = receipts),
			list("field" = "supply_packs",		"value" = pack_list)
		)


// Command Cartridge:
// Templates
//  *- Status Display Access
//  *- Employment Records
/obj/item/weapon/commcard/head
	name = "\improper Easy-Record DELUXE"
	icon_state = "cart-h"
	ui_templates = list(
			list("name" = "Status Display Access", "template" = "stat_display_access.tmpl"),
			list("name" = "Employment Records", "template" = "emp_records.tmpl")
		)

/obj/item/weapon/commcard/head/New()
	..()
	internal_data["stat_display_line1"] = null
	internal_data["stat_display_line2"] = null
	internal_data["stat_display_active1"] = null
	internal_data["stat_display_active2"] = null
	internal_data["stat_display_special"] = null

/obj/item/weapon/commcard/head/Initialize()
	// Have to register the commcard with the Radio controller to receive updates to the status displays
	radio_controller.add_object(src, 1435)
	..()

/obj/item/weapon/commcard/head/Destroy()
	// Have to unregister the commcard for proper bookkeeping
	radio_controller.remove_object(src, 1435)
	..()

/obj/item/weapon/commcard/head/get_data()
	return list(
			list("field" = "emp_records", "value" = get_emp_records()),
			list("field" = "stat_display", "value" = get_status_display())
		)

// Head of Personnel Cartridge:
// Templates
//  *- Status Display Access
//  *- Employment Records
//  *- Security Records
//  *- Supply Records
//  ?- Supply Bot Access
//  *- Janitorial Locator Magicbox
/obj/item/weapon/commcard/head/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"
	ui_templates = list(
			list("name" = "Status Display Access", "template" = "stat_display_access.tmpl"),
			list("name" = "Employment Records", "template" = "emp_records.tmpl"),
			list("name" = "Security Records", "template" = "sec_records.tmpl"),
			list("name" = "Supply Records", "template" = "supply_records.tmpl"),
			list("name" = "Janitorial Supply Locator", "template" = "janitorialLocator.tmpl")
		)


/obj/item/weapon/commcard/head/hop/get_data()
	var/list/data = ..()

	// Sec records
	data[++data.len] = list("field" = "sec_records", "value" = get_sec_records())

	// Supply records data
	var/list/shuttle_status = get_supply_shuttle_status()
	var/list/orders = get_supply_orders()
	var/list/receipts = get_supply_receipts()
	var/list/misc_supply_data = get_misc_supply_data() // Packaging this stuff externally so it's less hardcoded into the specific cartridge
	var/list/pack_list = list() // List of supply packs within the currently selected category

	if(internal_data["supply_category"])
		pack_list = get_supply_pack_list()

	data[++data.len] = list("field" = "shuttle_auth",	 "value" = misc_supply_data["shuttle_auth"])
	data[++data.len] = list("field" = "order_auth",		 "value" = misc_supply_data["order_auth"])
	data[++data.len] = list("field" = "supply_points",	 "value" = misc_supply_data["supply_points"])
	data[++data.len] = list("field" = "categories",		 "value" = misc_supply_data["supply_categories"])
	data[++data.len] = list("field" = "contraband",		 "value" = misc_supply_data["contraband"])
	data[++data.len] = list("field" = "active_category", "value" = internal_data["supply_category"])
	data[++data.len] = list("field" = "shuttle",		 "value" = shuttle_status)
	data[++data.len] = list("field" = "orders",			 "value" = orders)
	data[++data.len] = list("field" = "receipts",		 "value" = receipts)
	data[++data.len] = list("field" = "supply_packs",	 "value" = pack_list)

	// Janitorial locator magicbox
	data[++data.len] = list("field" = "janidata", "value" = get_janitorial_locations())

	return data


// Head of Security Cartridge:
// Templates
//  *- Status Display Access
//  *- Employment Records
//  *- Security Records
//  *- Security Bot Access
/obj/item/weapon/commcard/head/hos
	name = "\improper R.O.B.U.S.T. DELUXE"
	icon_state = "cart-hos"
	ui_templates = list(
			list("name" = "Status Display Access", "template" = "stat_display_access.tmpl"),
			list("name" = "Employment Records", "template" = "emp_records.tmpl"),
			list("name" = "Security Records", "template" = "sec_records.tmpl"),
			list("name" = "Security Bot Control", "template" = "sec_bot_access.tmpl")
		)

/obj/item/weapon/commcard/head/hos/get_data()
	var/list/data = ..()
	// Sec records
	data[++data.len] = list("field" = "sec_records", "value" = get_sec_records())
	// Sec bot access
	data[++data.len] = list("field" = "sec_bot_access", "value" = get_sec_bot_access())
	return data


// Research Director Cartridge:
// Devices
//  *- Signaler
//  *- Gas Scanner
//  *- Reagent Scanner
// Templates
//  *- Status Display Access
//  *- Employment Records
//  *- Signaler Access
/obj/item/weapon/commcard/head/rd
	name = "\improper Signal Ace DELUXE"
	icon_state = "cart-rd"
	ui_templates = list(
			list("name" = "Status Display Access", "template" = "stat_display_access.tmpl"),
			list("name" = "Employment Records", "template" = "emp_records.tmpl"),
			list("name" = "Integrated Signaler Control", "template" = "signaler_access.tmpl")
		)

/obj/item/weapon/commcard/head/rd/New()
	..()
	internal_devices |= new /obj/item/device/analyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/assembly/signaler(src)

/obj/item/weapon/commcard/head/rd/get_data()
	var/list/data = ..()
	// Signaler access
	data[++data.len] = list("field" = "signaler_access", "value" = get_int_signalers())
	return data


// Chief Medical Officer Cartridge:
// Devices
//  *- Health Analyzer
//  *- Reagent Scanner
//  *- Halogen Counter
// Templates
//  *- Status Display Access
//  *- Employment Records
//  *- Medical Records
/obj/item/weapon/commcard/head/cmo
	name = "\improper Med-U DELUXE"
	icon_state = "cart-cmo"
	ui_templates = list(
			list("name" = "Status Display Access", "template" = "stat_display_access.tmpl"),
			list("name" = "Employment Records", "template" = "emp_records.tmpl"),
			list("name" = "Medical Records", "template" = "med_records.tmpl")
		)

/obj/item/weapon/commcard/head/cmo/New()
	..()
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/head/cmo/get_data()
	var/list/data = ..()
	// Med records
	data[++data.len] = list("field" = "med_records", "value" = get_med_records())
	return data

// Chief Engineer Cartridge:
// Devices
//  *- Gas Scanner
//  *- Halogen Counter
// Templates
//  *- Status Display Access
//  *- Employment Records
//  *- Power Monitoring
/obj/item/weapon/commcard/head/ce
	name = "\improper Power-On DELUXE"
	icon_state = "cart-ce"
	ui_templates = list(
			list("name" = "Status Display Access", "template" = "stat_display_access.tmpl"),
			list("name" = "Employment Records", "template" = "emp_records.tmpl"),
			list("name" = "Power Monitor", "template" = "comm_power_monitor.tmpl")
		)

/obj/item/weapon/commcard/head/ce/New()
	..()
	internal_devices |= new /obj.item/device/analyzer(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/head/ce/Initialize()
	internal_data["grid_sensors"] = find_powernet_sensors()
	internal_data["powernet_target"] = ""

/obj/item/weapon/commcard/head/ce/get_data()
	var/list/data = ..()
	// Add power monitoring data
	data[++data.len] = list("field" = "powernet_monitoring", "value" = get_powernet_monitoring_list())
	data[++data.len] = list("field" = "powernet_target", "value" = get_powernet_target(internal_data["powernet_target"]))
	return data


// Captain Cartridge:
// Devices
//  *- Health analyzer
//  *- Gas Scanner
//  *- Reagent Scanner
//  *- Halogen Counter
//  X- GPS - Balance
//  *- Signaler
// Templates
//  *- Status Display Access
//  *- Employment Records
//  *- Medical Records
//  *- Security Records
//  *- Power Monitoring
//  *- Supply Records
//  X- Supply Bot Access - Mulebots usually break when used
//  *- Security Bot Access
//  *- Janitorial Locator Magicbox
//  X- GPS Access - Balance
//  *- Signaler Access
/obj/item/weapon/commcard/head/captain
	name = "\improper Value-PAK cartridge"
	desc = "Now with 200% more value!"
	icon_state = "cart-c"
	ui_templates = list(
			list("name" = "Status Display Access", "template" = "stat_display_access.tmpl"),
			list("name" = "Employment Records", "template" = "emp_records.tmpl"),
			list("name" = "Medical Records", "template" = "med_records.tmpl"),
			list("name" = "Security Records", "template" = "sec_records.tmpl"),
			list("name" = "Security Bot Control", "template" = "sec_bot_access.tmpl"),
			list("name" = "Power Monitor", "template" = "comm_power_monitor.tmpl"),
			list("name" = "Supply Records", "template" = "supply_records.tmpl"),
			list("name" = "Janitorial Supply Locator", "template" = "janitorialLocator.tmpl"),
			list("name" = "Integrated Signaler Control", "template" = "signaler_access.tmpl")
		)

/obj/item/weapon/commcard/head/captain/New()
	..()
	internal_devices |= new /obj.item/device/analyzer(src)
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)
	internal_devices |= new /obj/item/device/assembly/signaler(src)

/obj/item/weapon/commcard/head/captain/get_data()
	var/list/data = ..()
	//Med records
	data[++data.len] = list("field" = "med_records", "value" = get_med_records())

	// Sec records
	data[++data.len] = list("field" = "sec_records", "value" = get_sec_records())

	// Sec bot access
	data[++data.len] = list("field" = "sec_bot_access", "value" = get_sec_bot_access())

	// Power Monitoring
	data[++data.len] = list("field" = "powernet_monitoring", "value" = get_powernet_monitoring_list())
	data[++data.len] = list("field" = "powernet_target", "value" = get_powernet_target(internal_data["powernet_target"]))

	// Supply records data
	var/list/shuttle_status = get_supply_shuttle_status()
	var/list/orders = get_supply_orders()
	var/list/receipts = get_supply_receipts()
	var/list/misc_supply_data = get_misc_supply_data() // Packaging this stuff externally so it's less hardcoded into the specific cartridge
	var/list/pack_list = list() // List of supply packs within the currently selected category

	if(internal_data["supply_category"])
		pack_list = get_supply_pack_list()

	data[++data.len] = list("field" = "shuttle_auth",	 "value" = misc_supply_data["shuttle_auth"])
	data[++data.len] = list("field" = "order_auth",		 "value" = misc_supply_data["order_auth"])
	data[++data.len] = list("field" = "supply_points",	 "value" = misc_supply_data["supply_points"])
	data[++data.len] = list("field" = "categories",		 "value" = misc_supply_data["supply_categories"])
	data[++data.len] = list("field" = "contraband",		 "value" = misc_supply_data["contraband"])
	data[++data.len] = list("field" = "active_category", "value" = internal_data["supply_category"])
	data[++data.len] = list("field" = "shuttle",		 "value" = shuttle_status)
	data[++data.len] = list("field" = "orders",			 "value" = orders)
	data[++data.len] = list("field" = "receipts",		 "value" = receipts)
	data[++data.len] = list("field" = "supply_packs",	 "value" = pack_list)

	// Janitorial locator magicbox
	data[++data.len] = list("field" = "janidata", "value" = get_janitorial_locations())

	// Signaler access
	data[++data.len] = list("field" = "signaler_access", "value" = get_int_signalers())

	return data


// Mercenary Cartridge
// Templates
//  *- Merc Shuttle Door Controller
/obj/item/weapon/commcard/mercenary
	name = "\improper Detomatix cartridge"
	icon_state = "cart"
	ui_templates = list(
			list("name" = "Shuttle Blast Door Control", "template" = "merc_blast_door_control.tmpl")
		)

/obj/item/weapon/commcard/mercenary/Initialize()
	internal_data["shuttle_door_code"] = "smindicate" // Copied from PDA code
	internal_data["shuttle_doors"] = find_blast_doors()

/obj/item/weapon/commcard/mercenary/get_data()
	var/door_status[0]
	for(var/obj/machinery/door/blast/B in internal_data["shuttle_doors"])
		door_status[++door_status.len] += list(
				"open" = B.density,
				"name" = B.name,
				"ref" = "\ref[B]"
			)

	return list(
			list("field" = "blast_door", "value" = door_status)
		)


// Explorer Cartridge
// Devices
//  *- GPS
// Templates
//  *- GPS Access

// IMPORTANT: NOT MAPPED IN DUE TO BALANCE CONCERNS RE: FINDING THE VICTIMS OF ANTAGS.
// See suit sensors, specifically ease of turning them off, and variable level of settings which may or may not give location
// A GPS in your phone that is either broadcasting position or totally off, and can be hidden in pockets, coats, bags, boxes, etc, is much harder to disable
/obj/item/weapon/commcard/explorer
	name = "\improper Explorator cartridge"
	icon_state = "cart-tox"
	ui_templates = list(
			list("name" = "Integrated GPS", "template" = "gps_access.tmpl")
		)

/obj/item/weapon/commcard/explorer/New()
	..()
	internal_devices |= new /obj/item/device/gps/explorer(src)

/obj/item/weapon/commcard/explorer/get_data()
	var/list/GPS = get_GPS_lists()

	return list(
			list("field" = "gps_access", "value" = GPS[1]),
			list("field" = "gps_signal", "value" = GPS[2]),
			list("field" = "gps_status", "value" = GPS[3])
		)