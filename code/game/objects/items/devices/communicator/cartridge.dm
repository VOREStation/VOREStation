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
	var/list/ui_templates = list()     // List of lists for when multiple templates
	var/list/internal_data = list()	   // Data that shouldn't be updated every time nanoUI updates, due to the time complexity of regenerating it, will be stored within the device. I'd really rather not have to, but powernet monitor iterates over machine


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

		world << "Valid gps_target"

		switch(href_list["gps_action"])
			if("Power")
				world << "Setting tracking to [href_list["value"]]"
				G.tracking = text2num(href_list["value"])

			if("Long_Range")
				world << "Setting local_mode to [href_list["value"]]"
				G.local_mode = text2num(href_list["value"])

			if("Hide_Signal")
				world << "Setting hide_signal to [href_list["value"]]"
				G.hide_signal = text2num(href_list["value"])

			if("Tag")
				var/mob/user = locate(href_list["user"])
				if(!istype(user)) // Ref no longer valid
					return

				var/newTag = input(user, "Please enter desired tag.", G.tag) as text|null

				world << "Setting Tag to [newTag]"

				if(newTag)
					G.tag = newTag


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

/obj/item/weapon/commcard/int_aff/New()
	..()

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
			list("name" = "Security Bot Controller", "template" = "sec_bot_access.tmpl")
		)

/obj/item/weapon/commcard/security/New()
	..()

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
	// I'm probably gonna regret this too

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
//  -- Supply Records
//  -- Supply Bot Access
/obj/item/weapon/commcard/supply
	name = "\improper Space Parts & Space Vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"

/obj/item/weapon/commcard/supply/get_data()
	// Add supply records to ui template
	// Add supply bot access to ui template


// Command Cartridge:
// Templates
//  -- Status Display Access
//  *- Employment Records
/obj/item/weapon/commcard/head
	name = "\improper Easy-Record DELUXE"
	icon_state = "cart-h"

/obj/item/weapon/commcard/head/get_data()
	// Add status display to ui template
	// Add employment records to ui template


// Head of Personnel Cartridge:
// Templates
//  -- Status Display Access
//  *- Employment Records
//  *- Security Records
//  -- Supply Records
//  -- Supply Bot Access
//  X- Recipe Lists - See service cartridge
//  *- Janitorial Locator Magicbox
/obj/item/weapon/commcard/head/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"

/obj/item/weapon/commcard/head/hop/get_data()
	var/list/data = ..()
	// Sec records
	// Supply records
	// Supply bot access
	// Janitorial locator magicbox
	// Recipe lists
	return data


// Head pf Security Cartridge:
// Templates
//  -- Status Display Access
//  *- Employment Records
//  *- Security Records
//  *- Security Bot Access
/obj/item/weapon/commcard/head/hos
	name = "\improper R.O.B.U.S.T. DELUXE"
	icon_state = "cart-hos"

/obj/item/weapon/commcard/head/hos/get_data()
	var/list/data = ..()
	// Add sec records to ui template
	// Add sec bot access to ui template
	return data


// Research Director Cartridge:
// Devices
//  *- Signaler
//  *- Gas Scanner
//  *- Reagent Scanner
// Templates
//  -- Status Display Access
//  *- Employment Records
//  *- Signaler Access
/obj/item/weapon/commcard/head/rd
	name = "\improper Signal Ace DELUXE"
	icon_state = "cart-rd"

/obj/item/weapon/commcard/head/rd/New()
	..()
	internal_devices |= new /obj/item/device/analyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/assembly/signaler(src)

/obj/item/weapon/commcard/head/rd/get_data()
	var/list/data = ..()
	// Status Display
	// Employment Records
	// Signaler Access
	return data


// Chief Medical Officer Cartridge:
// Devices
//  *- Health Analyzer
//  *- Reagent Scanner
//  *- Halogen Counter
// Templates
//  -- Status Display Access
//  *- Employment Records
//  *- Medical Records
/obj/item/weapon/commcard/head/cmo
	name = "\improper Med-U DELUXE"
	icon_state = "cart-cmo"

/obj/item/weapon/commcard/head/cmo/New()
	..()
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/head/cmo/get_data()
	var/list/data = ..()
	// Med records
	return data

// Chief Engineer Cartridge:
// Devices
//  *- Gas Scanner
//  *- Halogen Counter
// Templates
//  -- Status Display Access
//  *- Employment Records
//  *- Power Monitoring
/obj/item/weapon/commcard/head/ce
	name = "\improper Power-On DELUXE"
	icon_state = "cart-ce"

/obj/item/weapon/commcard/head/ce/New()
	..()
	internal_devices |= new /obj.item/device/analyzer(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/head/ce/get_data()
	var/list/data = ..()
	// Add power monitor to ui template
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
//  -- Status Display Access
//  *- Employment Records
//  *- Medical Records
//  *- Security Records
//  *- Power Monitoring
//  -- Supply Records
//  -- Supply Bot Access
//  *- Security Bot Access
//  *- Janitorial Locator Magicbox
//  X- GPS Access - Balance
//  *- Signaler Access
/obj/item/weapon/commcard/head/captain
	name = "\improper Value-PAK cartridge"
	desc = "Now with 200% more value!"
	icon_state = "cart-c"

/obj/item/weapon/commcard/head/captain/New()
	..()
	internal_devices |= new /obj.item/device/analyzer(src)
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)


// Mercenary Cartridge
// Templates
//  -- Syndicate Shuttle Door Controller
/obj/item/weapon/commcard/mercenary
	name = "\improper Detomatix cartridge"
	icon_state = "cart"

/obj/item/weapon/commcard/mercenary/get_data()
	// Syndi shuttle door controller
	// Fuck if I know how that thing works


// Explorer Cartridge
// Devices
//  *- GPS
// Templates
//  *- GPS Access

// IMPORTANT: NOT MAPPED IN DUE TO BALANCE CONCERNS RE: FINDING THE VICTIMS OF ANTAGS.
// See suit sensors, specifically ease of turning them off, and variable level of settings which may or may not give location
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
	var/list/GPS = get_GPS_list()

	return list(
			list("field" = "gps_access", "value" = GPS[1]),
			list("field" = "gps_signal", "value" = GPS[2]),
			list("field" = "gps_status", "value" = GPS[3])
		)