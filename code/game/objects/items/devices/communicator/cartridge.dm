// Communicator peripherals

/obj/item/weapon/commcard
	name = "generic commcard"
	desc = "A peripheral plug-in for personal communicators."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = ITEMSIZE_TINY

	var/list/internal_devices = list()
	var/list/ui_templates = list()

/obj/item/weapon/commcard/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	//Power monitor
	//Halogen counter

/obj/item/weapon/commcard/engineering/New()
	..()
	//Add power monitor to ui template

/obj/item/weapon/commcard/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"
	//Gas scanner

/obj/item/weapon/commcard/atmos/New()
	..()
	//var/obj/item/[Gas scanner]/S = new(src)
	//internal_devices.Add(S)

/obj/item/weapon/commcard/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	//Med records
	//Med scanner
	//Halogen counter

/obj/item/weapon/commcard/medical/New()
	..()
	var/obj/item/device/healthanalyzer/H = new(src)
	internal_devices.Add(H)
	//Add med records to ui template

/obj/item/weapon/commcard/medical/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"
	//Reagent scanner

/obj/item/weapon/commcard/medical/chemistry/New()
	..()
	var/obj/item/device/reagent_scanner/R = new(src)
	internal_devices.Add(R)

/obj/item/weapon/commcard/medical/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-s"
	//Security records

/obj/item/weapon/commcard/medical/detective/New()
	..()
	// Add sec records to ui template

/obj/item/weapon/commcard/int_aff
	name = "\improper P.R.O.V.E. cartridge"
	icon_state = "cart-s"
	//Sec records

/obj/item/weapon/commcard/int_aff/New()
	..()
	//Add sec records to ui template

/obj/item/weapon/commcard/int_aff/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	//Sec bot access

/obj/item/weapon/commcard/int_aff/security/New()
	..()
	//Add sec bot access to ui template

/obj/item/weapon/commcard/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	//Janitorial Supplies Locator

/obj/item/weapon/commcard/janitor/New()
	..()
	// Add janitoral locator to ui template

/obj/item/weapon/commcard/service
	name = "\improper Serv-U Pro"
	desc = "A data cartridge designed to serve YOU!"
	//I'm gonna regret this but recipes menu

/obj/item/weapon/commcard/service/New()
	..()
	// Add list of recipes to ui template
	// SEE: /code/modules/food/recipe_dump.dm

/obj/item/weapon/commcard/signal
	name = "generic signaler cartridge"
	desc = "A data cartridge with an integrated radio signaler module."
	//Signaller

/obj/item/weapon/commcard/signal/New()
	..()
	// Make a signaller, add it to internal devices
	// Access the signaller through the ui template
	// I'm probably gonna regret this too

/obj/item/weapon/commcard/signal/science
	name = "\improper Signal Ace 2 cartridge"
	desc = "Complete with integrated radio signaler!"
	icon_state = "cart-tox"
	//Reagent scanner
	//Gas scanner

/obj/item/weapon/commcard/signal/science/New()
	..()
	var/obj/item/device/reagent_scanner/R = new(src)
	//var/obj/item/[Gas scanner]/S = new(src)
	//internal_devices.Add(S)
	internal_devices.Add(R)

/obj/item/weapon/commcard/quartermaster
	name = "\improper Space Parts & Space Vendors cartridge"
	desc = "Perfect for the Quartermaster on the go!"
	icon_state = "cart-q"
	//Supply records
	//Supply bot access

/obj/item/weapon/commcard/quartermaster/New()
	..()
	// Add supply records to ui template
	// Add supply bot access to ui template

/obj/item/weapon/commcard/miner
	name = "\improper Drill-Jockey 4.5"
	desc = "It's covered in some sort of sand."
	//Ore processing instructions?!

/obj/item/weapon/commcard/miner/New()
	..()
	// Add ore recipes to ui template

/obj/item/weapon/commcard/head
	name = "\improper Easy-Record DELUXE"
	icon_state = "cart-h"
	//Status display
	//Employment records

/obj/item/weapon/commcard/head/New()
	..()
	// Add status display to ui template
	// Add employment records to ui template

/obj/item/weapon/commcard/head/hop
	name = "\improper HumanResources9001 cartridge"
	icon_state = "cart-h"
	//Sec records
	//Supply records
	//Supply bot access
	//Janitorial Supplies Locator
	//Service menu

/obj/item/weapon/commcard/head/hop/New()
	..()
	// Add sec records to ui template
	// Add supply records to ui template
	// Add supply bot access to ui template
	// Add janitorial supplies locator to template
	// Add service menu to template

/obj/item/weapon/commcard/head/hos
	name = "\improper R.O.B.U.S.T. DELUXE"
	icon_state = "cart-hos"
	// Sec records
	// Sec bot access

/obj/item/weapon/commcard/head/hos/New()
	..()
	// Add sec records to ui template
	// Add sec bot access to ui template

/obj/item/weapon/commcard/head/rd
	name = "\improper Signal Ace DELUXE"
	icon_state = "cart-rd"
	//Signaller
	//Gas scanner
	//Reagent scanner

/obj/item/weapon/commcard/head/rd/New()
	..()
	// Add signaller to internal devices
	// Add signaller access to ui template
	var/obj/item/device/reagent_scanner/R = new(src)
	//var/obj/item/[Gas scanner]/S = new(src)
	//internal_devices.Add(S)
	internal_devices.Add(R)


/obj/item/weapon/commcard/head/cmo
	name = "\improper Med-U DELUXE"
	icon_state = "cart-cmo"
	//Med records
	//Med scanner
	//Reagent scanner
	//Halogen counter

/obj/item/weapon/commcard/head/cmo/New()
	..()
	var/obj/item/device/healthanalyzer/H = new(src)
	var/obj/item/device/reagent_scanner/R = new(src)
	internal_devices.Add(R)
	internal_devices.Add(H)

/obj/item/weapon/commcard/head/ce
	name = "\improper Power-On DELUXE"
	icon_state = "cart-ce"
	//Power monitor
	//Gas scanner
	//Halogen counter

/obj/item/weapon/commcard/head/ce/New()
	..()
	// Add power monitor to ui template
	// Add gas scanner to internal devices

/obj/item/weapon/commcard/head/captain
	name = "\improper Value-PAK cartridge"
	desc = "Now with 200% more value!"
	icon_state = "cart-c"
	//Literally everything:
	//Power monitor
	//Med records
	//Sec records
	//Supply records
	//Med scanner
	//Reagent scanner
	//Gas scanner
	//Supply bot access
	//Sec bot access
	//Janitorial supply locator

/obj/item/weapon/commcard/head/captain/New()
	..()
	// Add med records to ui template
	// Add sec records to ui template
	// Add supply records to ui template
	// Add supply bot access to ui template
	// Add sec bot access to ui template
	// Add power monitor to ui template
	// Add janitorial locator to ui template
	// Add service menu to ui template
	// Add gas scanner to internal devices
	var/obj/item/device/healthanalyzer/H = new(src)
	var/obj/item/device/reagent_scanner/R = new(src)
	internal_devices.Add(R)
	internal_devices.Add(H)

/obj/item/weapon/commcard/mercenary
	name = "\improper Detomatix cartridge"
	icon_state = "cart"
	//Syndi shuttle door controller

/obj/item/weapon/commcard/mercenary/New()
	..()
	// Fuck if I know how that thing works

/obj/item/weapon/commcard/explorer
	name = "\improper Explorator cartridge"
	icon_state = "cart-tox"
	//GPS

/obj/item/weapon/commcard/explorer/New()
	..()
	var/obj/item/device/gps/G = new(src)
	internal_devices.Add(G)
	// Add GPS access to ui template