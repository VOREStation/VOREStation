// Communicator peripherals

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

// Engineering Cartridge:
// Devices
//  *- Halogen Counter
// Templates
//  -- Power Monitor
/obj/item/weapon/commcard/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	ui_templates = list(list("name" = "Power Monitor", "template" = "comm_power_monitor.tmpl"))

/obj/item/weapon/commcard/engineering/New()
	..()
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/engineering/get_data()
	// Fetch power monitor data


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
	//Med records
	//Med scanner
	//Halogen counter

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
//  -- Janitorial Locator Magicbox
/obj/item/weapon/commcard/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."

/obj/item/weapon/commcard/janitor/get_data()
	// Fetch janitorial locator


// Service Cartridge:
// Templates
//  -- Recipe Lists
/obj/item/weapon/commcard/service
	name = "\improper Serv-U Pro"
	desc = "A data cartridge designed to serve YOU!"
	//I'm gonna regret this but recipes menu

/obj/item/weapon/commcard/service/get_data()
	// Add list of recipes to ui template
	// SEE: /code/modules/food/recipe_dump.dm


// Signal Cartridge:
// Devices
//  *- Signaler
// Templates
//  -- Signaler Access
/obj/item/weapon/commcard/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."
	ui_templates = list(
			list("name" = "Signaller", "template" = "signaler.tmpl")
		)

/obj/item/weapon/commcard/signal/New()
	..()
	internal_devices |= new /obj/item/device/assembly/signaler(src)
	// I'm probably gonna regret this too

/obj/item/weapon/commcard/signal/get_data()
	signallers[0]
	for(var/obj/item/device/assembly/signaler/S in internal_devices)
		world << "Found [S]"
		unit[0]
		unit[++unit.len] = list("tab" = "Code", "value" = S.code)
		unit[++unit.len] = list("tab" = "Frequency", "value" = S.frequency)

		signallers[++signallers.len] = unit

	return list(
			list("field" = "signallers", "value" = signallers)
		)


// Science Cartridge:
// Devices
//  *- Signaler
//  *- Reagent Scanner
//  *- Gas Scanner
// Templates
//  -- Signaler Access
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


// Mining Cartridge:
// Templates
//  -- Ore Processing Recipes
/obj/item/weapon/commcard/miner
	name = "\improper Drill-Jockey 4.5"
	desc = "It's covered in some sort of sand."

/obj/item/weapon/commcard/miner/get_data()
	// Add ore recipes to ui template


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
//  -- Recipe Lists
//  -- Janitorial Locator Magicbox
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
//  -- Signaler Access
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
//  -- Power Monitoring
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
//  -- GPS
//  *- Signaler
// Templates
//  -- Status Display Access
//  *- Employment Records
//  *- Medical Records
//  *- Security Records
//  -- Power Monitoring
//  -- Supply Records
//  -- Supply Bot Access
//  *- Security Bot Access
//  -- Janitorial Locator Magicbox
//  -- GPS Access
//  -- Signaler Access
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
//  -- GPS
// Templates
//  -- GPS Access
/obj/item/weapon/commcard/explorer
	name = "\improper Explorator cartridge"
	icon_state = "cart-tox"
	//GPS

/obj/item/weapon/commcard/explorer/New()
	..()
	internal_devices |= new /obj/item/device/gps(src)

/obj/item/weapon/commcard/explorer/get_data()
	// GPS Access