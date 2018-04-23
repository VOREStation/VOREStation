// Communicator peripherals

/obj/item/weapon/commcard
	name = "generic commcard"
	desc = "A peripheral plug-in for personal communicators."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = ITEMSIZE_TINY

	var/list/internal_devices = list()
	var/list/active_devices = list()
	var/list/ui_templates = list()

/obj/item/weapon/commcard/proc/get_device_status()
	var/list/L = list()
	var/i = 1
	for(var/obj/I in internal_devices)
		if(I in active_devices)
			L[++L.len] = list("name" = "\proper[I.name]", "active" = 1, "index" = i++)
		else
			L[++L.len] = list("name" = I.name, "active" = 0, "index" = i++)
	return L

/obj/item/weapon/commcard/proc/get_data()
	return list()

/obj/item/weapon/commcard/engineering
	name = "\improper Power-ON cartridge"
	icon_state = "cart-e"
	ui_templates = list(list("name" = "Power Monitor", "template" = "comm_power_monitor.tmpl"))
	//Power monitor template
	//Halogen counter

/obj/item/weapon/commcard/engineering/New()
	..()
	internal_devices |= new /obj/item/device/halogen_counter(src)
	// Add power monitor template

/obj/item/weapon/commcard/atmos
	name = "\improper BreatheDeep cartridge"
	icon_state = "cart-a"
	//Gas scanner

/obj/item/weapon/commcard/atmos/New()
	..()
	internal_devices |= new /obj/item/device/analyzer(src)

/obj/item/weapon/commcard/medical
	name = "\improper Med-U cartridge"
	icon_state = "cart-m"
	ui_templates = list(list("name" = "Medical Records", "template" = "med_records.tmpl"), list("name" = "test", "template" = "comm2.tmpl")) // List of list for when multiple templates
	//Med records template
	//Med scanner
	//Halogen counter

/obj/item/weapon/commcard/medical/New()
	..()
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/medical/get_data()
	var/med_records[0]
	for(var/datum/data/record/M in sortRecord(data_core.medical))
		var/record[0]
		record[++record.len] = list("tab" = "Name", "val" = M.fields["name"])
		record[++record.len] = list("tab" = "ID", "val" = M.fields["id"])
		record[++record.len] = list("tab" = "Blood Type", "val" = M.fields["b_type"])
		record[++record.len] = list("tab" = "DNA #", "val" = M.fields["b_dna"])
		record[++record.len] = list("tab" = "Gender", "val" = M.fields["id_gender"])
		record[++record.len] = list("tab" = "Entity Classification", "val" = M.fields["brain_type"])
		record[++record.len] = list("tab" = "Minor Disorders", "val" = M.fields["mi_dis"])
		record[++record.len] = list("tab" = "Major Disorders", "val" = M.fields["ma_dis"])
		record[++record.len] = list("tab" = "Allergies", "val" = M.fields["alg"])
		record[++record.len] = list("tab" = "Condition", "val" = M.fields["cdi"])
		record[++record.len] = list("tab" = "Notes", "val" = M.fields["notes"])

		med_records[++med_records.len] = list("name" = M.fields["name"], "record" = record)
	return list(list("field" = "med_records", "value" = med_records))

/obj/item/weapon/commcard/medical/chemistry
	name = "\improper ChemWhiz cartridge"
	icon_state = "cart-chem"
	//Reagent scanner

/obj/item/weapon/commcard/medical/chemistry/New()
	..()
	internal_devices |= new /obj/item/device/reagent_scanner(src)

/obj/item/weapon/commcard/int_aff
	name = "\improper P.R.O.V.E. cartridge"
	icon_state = "cart-s"
	ui_templates = list(list("name" = "Employment Records", "template" = "emp_records.tmpl"))
	//Emp records

/obj/item/weapon/commcard/int_aff/New()
	..()

/obj/item/weapon/commcard/int_aff/get_data()
	var/emp_records[0]
	for(var/datum/data/record/G in sortRecord(data_core.general))
		var/record[0]
		record[++record.len] = list("tab" = "Name", "val" = G.fields["name"])
		record[++record.len] = list("tab" = "ID", "val" = G.fields["id"])
		record[++record.len] = list("tab" = "Rank", "val" = G.fields["rank"])
		record[++record.len] = list("tab" = "Fingerprint", "val" = G.fields["fingerprint"])
		record[++record.len] = list("tab" = "Entity Classification", "val" = G.fields["brain_type"])
		record[++record.len] = list("tab" = "Sex", "val" = G.fields["sex"])
		record[++record.len] = list("tab" = "Species", "val" = G.fields["species"])
		record[++record.len] = list("tab" = "Age", "val" = G.fields["age"])
		record[++record.len] = list("tab" = "Notes", "val" = G.fields["notes"])

		emp_records[++emp_records.len] = list("name" = G.fields["name"], "record" = record)
	return list(list("field" = "emp_records", "value" = emp_records))

/obj/item/weapon/commcard/security
	name = "\improper R.O.B.U.S.T. cartridge"
	icon_state = "cart-s"
	ui_templates = list(list("name" = "Security Records", "template" = "sec_records.tmpl"), list("name" = "Security Bot Controller", "template" = "sec_bot_access.tmpl"))
	//Sec records
	//Sec bot access template

/obj/item/weapon/commcard/security/New()
	..()
	//Add sec records to ui template
	//Add sec bot access template

/obj/item/weapon/commcard/security/get_data()
	var/sec_records[0]
	for(var/datum/data/record/G in sortRecord(data_core.general))
		var/record[0]
		record[++record.len] = list("tab" = "Name", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Sex", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Species", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Age", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Rank", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Fingerprint", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Physical Status", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Mental Status", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Criminal Status", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Major Crimes", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Minor Crimes", "val" = G.fields[""])
		record[++record.len] = list("tab" = "Notes", "val" = G.fields["notes"])

		sec_records[++sec_records.len] = list("name" = G.fields["name"], "record" = record)
	return list(list("field" = "sec_records", "value" = sec_records))

/obj/item/weapon/commcard/security/detective
	name = "\improper D.E.T.E.C.T. cartridge"
	icon_state = "cart-s"
	//Med records

/obj/item/weapon/commcard/security/detective/New()
	var/list/data = ..()
	var/med_records[0]
	for(var/datum/data/record/M in sortRecord(data_core.medical))
		var/record[0]
		record[++record.len] = list("tab" = "Name", "val" = M.fields["name"])
		record[++record.len] = list("tab" = "ID", "val" = M.fields["id"])
		record[++record.len] = list("tab" = "Blood Type", "val" = M.fields["b_type"])
		record[++record.len] = list("tab" = "DNA #", "val" = M.fields["b_dna"])
		record[++record.len] = list("tab" = "Gender", "val" = M.fields["id_gender"])
		record[++record.len] = list("tab" = "Entity Classification", "val" = M.fields["brain_type"])
		record[++record.len] = list("tab" = "Minor Disorders", "val" = M.fields["mi_dis"])
		record[++record.len] = list("tab" = "Major Disorders", "val" = M.fields["ma_dis"])
		record[++record.len] = list("tab" = "Allergies", "val" = M.fields["alg"])
		record[++record.len] = list("tab" = "Condition", "val" = M.fields["cdi"])
		record[++record.len] = list("tab" = "Notes", "val" = M.fields["notes"])

		med_records[++med_records.len] = list("name" = M.fields["name"], "record" = record)
	data[++data.len] = list("field" = "med_records", "value" = med_records)

/obj/item/weapon/commcard/janitor
	name = "\improper CustodiPRO cartridge"
	desc = "The ultimate in clean-room design."
	//Janitorial Supplies Locator

/obj/item/weapon/commcard/janitor/New()
	..()
	// Add janitoral locator template

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
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/analyzer(src)

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
	// Add signaller access template
	internal_devices |= new /obj/item/device/analyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)


/obj/item/weapon/commcard/head/cmo
	name = "\improper Med-U DELUXE"
	icon_state = "cart-cmo"
	//Med records
	//Med scanner
	//Health analyzer
	//Reagent scanner
	//Halogen counter

/obj/item/weapon/commcard/head/cmo/New()
	..()
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)

/obj/item/weapon/commcard/head/ce
	name = "\improper Power-On DELUXE"
	icon_state = "cart-ce"
	//Power monitor
	//Gas scanner
	//Halogen counter

/obj/item/weapon/commcard/head/ce/New()
	..()
	internal_devices |= new /obj.item/device/analyzer(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)
	// Add power monitor to ui template

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
	//Gas analyzer
	//Health analyzer
	//Reagent scanner
	//Halogen counter

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
	internal_devices |= new /obj.item/device/analyzer(src)
	internal_devices |= new /obj/item/device/healthanalyzer(src)
	internal_devices |= new /obj/item/device/reagent_scanner(src)
	internal_devices |= new /obj/item/device/halogen_counter(src)


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
	internal_devices |= new /obj/item/device/gps(src)
	// Add GPS access to ui template