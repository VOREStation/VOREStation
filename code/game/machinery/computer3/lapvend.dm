/obj/machinery/lapvend
	name = "Laptop Vendor"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "robotics"
	anchored = 1
	density = 1
	var/obj/machinery/computer3/laptop/vended/newlap = null
	var/obj/item/device/laptop/relap = null
	var/vendmode = 0

	var/cardreader = 0
	var/floppy = 0
	var/radionet = 0
	var/camera = 0
	var/network = 0
	var/power = 0


/obj/machinery/lapvend/New()
	..()
	spawn(4)
		power_change()
		return
	return


/obj/machinery/lapvend/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/obj/item/weapon/card/id/I = W.GetID()

	if(default_unfasten_wrench(user, W, 20))
		return

	if(vendmode == 1 && I)
		scan_id(I, W)
		vendmode = 0
		nanomanager.update_uis(src)
	if(vendmode == 2 && I)
		if(reimburse_id(I, W))
			vendmode = 0
			nanomanager.update_uis(src)
	if(vendmode == 0)
		if(istype(W, /obj/item/device/laptop))
			var/obj/item/device/laptop/L = W
			relap = L
			calc_reimburse(L)
			usr.drop_item()
			L.loc = src
			vendmode = 2
			to_chat(user, "<span class='notice'>You slot your [L.name] into \The [src.name]</span>")
			nanomanager.update_uis(src)
	else
		..()


/obj/machinery/lapvend/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	ui_interact(user)

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/lapvend/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	data["mode"] = vendmode
	data["cardreader"] = cardreader
	data["floppy"] = floppy
	data["radionet"] = radionet
	data["camera"] = camera
	data["network"] = network
	data["power"] = power
	data["total"] = total()

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "laptop_vendor.tmpl", src.name, 480, 425)
		ui.set_initial_data(data)
		ui.open()
		//ui.set_auto_update(5)

/obj/machinery/lapvend/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.stat || usr.restrained())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
	switch(href_list["choice"])
		if("single_add")
			cardreader = 1
		if ("dual_add")
			cardreader = 2
		if ("floppy_add")
			floppy = 1
		if ("radio_add")
			radionet = 1
		if ("camnet_add")
			camera = 1
		if ("area_add")
			network = 1
		if ("prox_add")
			network = 2
		if ("cable_add")
			network = 3
		if ("high_add")
			power = 1
		if ("super_add")
			power = 2

		if ("cardreader_rem")
			cardreader = 0
		if ("floppy_rem")
			floppy = 0
		if ("radio_rem")
			radionet = 0
		if ("camnet_rem")
			camera = 0
		if ("network_rem")
			network = 0
		if ("power_rem")
			power = 0

		if("vend")
			vendmode = 1

		if("cancel")
			if(relap)
				relap.loc = src.loc
				relap = null
			vendmode = 0

	src.add_fingerprint(usr)
	nanomanager.update_uis(src)

/obj/machinery/lapvend/proc/vend()
	if(cardreader > 0)
		if(cardreader == 1)
			newlap.spawn_parts += (/obj/item/part/computer/cardslot)
		else
			newlap.spawn_parts += (/obj/item/part/computer/cardslot/dual)
	if(floppy == 1)
		newlap.spawn_parts += (/obj/item/part/computer/storage/removable)
	if(radionet == 1)
		newlap.spawn_parts += (/obj/item/part/computer/networking/radio)
	if(camera == 1)
		newlap.spawn_parts += (/obj/item/part/computer/networking/cameras)
	if (network == 1)
		newlap.spawn_parts += (/obj/item/part/computer/networking/area)
	if (network == 2)
		newlap.spawn_parts += (/obj/item/part/computer/networking/prox)
	if (network == 3)
		newlap.spawn_parts += (/obj/item/part/computer/networking/cable)
	if (power == 1)
		newlap.battery.maxcharge = 1000
		newlap.battery.charge = 1000
	if (power == 2)
		newlap.battery.maxcharge = 1750
		newlap.battery.charge = 1750

	newlap.spawn_parts()

/obj/machinery/lapvend/proc/scan_id(var/obj/item/weapon/card/id/C, var/obj/item/I)
	visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	var/datum/money_account/CH = get_account(C.associated_account_number)
	if(!CH)
		to_chat(usr, "\icon[src]<span class='warning'>No valid account number is associated with this card.</span>")
		return
	if(CH.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		if(vendor_account)
			var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
			var/datum/money_account/D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
			if(D)
				transfer_and_vend(D, C)
			else
				to_chat(usr, "\icon[src]<span class='warning'>Unable to access vendor account. Please record the machine ID and call [using_map.boss_short] Support.</span>")
		else
			to_chat(usr, "\icon[src]<span class='warning'>Unable to access vendor account. Please record the machine ID and call [using_map.boss_short] Support.</span>")
	else
		transfer_and_vend(CH, C)


// Transfers money and vends the laptop.
/obj/machinery/lapvend/proc/transfer_and_vend(var/datum/money_account/D, var/obj/item/weapon/card/C)
	var/transaction_amount = total()
	if(transaction_amount <= D.money)

		//transfer the money
		D.money -= transaction_amount
		vendor_account.money += transaction_amount
		//Transaction logs
		var/datum/transaction/T = new()
		T.target_name = "[vendor_account.owner_name] (via [src.name])"
		T.purpose = "Purchase of Laptop"
		if(transaction_amount > 0)
			T.amount = "([transaction_amount])"
		else
			T.amount = "[transaction_amount]"
		T.source_terminal = src.name
		T.date = current_date_string
		T.time = stationtime2text()
		D.transaction_log.Add(T)
		//
		T = new()
		T.target_name = D.owner_name
		T.purpose = "Purchase of Laptop"
		T.amount = "[transaction_amount]"
		T.source_terminal = src.name
		T.date = current_date_string
		T.time = stationtime2text()
		vendor_account.transaction_log.Add(T)

		newlap = new /obj/machinery/computer3/laptop/vended(src.loc)

		choose_progs(C)
		vend()
		newlap.close_laptop()
		newlap = null
		cardreader = 0
		floppy = 0
		radionet = 0
		camera = 0
		network = 0
		power = 0
	else
		to_chat(usr, "\icon[src]<span class='warning'>You don't have that much money!</span>")

/obj/machinery/lapvend/proc/total()
	var/total = 0

	if(cardreader == 1)
		total += 50
	if(cardreader == 2)
		total += 125
	if(floppy == 1)
		total += 50
	if(radionet == 1)
		total += 50
	if(camera == 1)
		total += 100
	if(network == 1)
		total += 75
	if(network == 2)
		total += 50
	if(network == 3)
		total += 25
	if(power == 1)
		total += 175
	if(power == 2)
		total += 250

	return total

/obj/machinery/lapvend/proc/choose_progs(var/obj/item/weapon/card/id/C)
	if(access_security in C.access)
		newlap.spawn_files += (/datum/file/program/secure_data)
		newlap.spawn_files += (/datum/file/camnet_key)
		newlap.spawn_files += (/datum/file/program/security)
	if(access_armory in C.access)
		newlap.spawn_files += (/datum/file/program/prisoner)
	if(access_atmospherics in C.access)
		newlap.spawn_files += (/datum/file/program/atmos_alert)
	if(access_change_ids in C.access)
		newlap.spawn_files += (/datum/file/program/card_comp)
	if(access_heads in C.access)
		newlap.spawn_files += (/datum/file/program/communications)
	if((access_medical in C.access) || (access_forensics_lockers in C.access)) //Gives detective the medical records program, but not the crew monitoring one.
		newlap.spawn_files += (/datum/file/program/med_data)
		if (access_medical in C.access)
			newlap.spawn_files += (/datum/file/program/crew)
	if(access_engine in C.access)
		newlap.spawn_files += (/datum/file/program/powermon)
	if(access_research in C.access)
		newlap.spawn_files += (/datum/file/camnet_key/research)
		newlap.spawn_files += (/datum/file/camnet_key/bombrange)
		newlap.spawn_files += (/datum/file/camnet_key/xeno)
	if(access_rd in C.access)
		newlap.spawn_files += (/datum/file/program/borg_control)
	if(access_cent_specops in C.access)
		newlap.spawn_files += (/datum/file/camnet_key/creed)
	newlap.spawn_files += (/datum/file/program/arcade)
	newlap.spawn_files += (/datum/file/camnet_key/entertainment)
	//Atlantis: Each laptop gets "invisible" program/security - REQUIRED for camnetkeys to work.
	newlap.spawn_files += (/datum/file/program/security/hidden)
	newlap.update_spawn_files()

/obj/machinery/lapvend/proc/calc_reimburse(var/obj/item/device/laptop/L)
	if(istype(L.stored_computer.cardslot,/obj/item/part/computer/cardslot))
		cardreader = 1
	if(istype(L.stored_computer.cardslot,/obj/item/part/computer/cardslot/dual))
		cardreader = 2
	if(istype(L.stored_computer.floppy,/obj/item/part/computer/storage/removable))
		floppy = 1
	if(istype(L.stored_computer.radio,/obj/item/part/computer/networking/radio))
		radionet = 1
	if(istype(L.stored_computer.camnet,/obj/item/part/computer/networking/cameras))
		camera = 1
	if(istype(L.stored_computer.net,/obj/item/part/computer/networking/area))
		network = 1
	if(istype(L.stored_computer.net,/obj/item/part/computer/networking/prox))
		network = 2
	if(istype(L.stored_computer.net,/obj/item/part/computer/networking/cable))
		network = 3
	if(istype(L.stored_computer.battery, /obj/item/weapon/cell/high))
		power = 1
	if(istype(L.stored_computer.battery, /obj/item/weapon/cell/super))
		power = 2



/obj/machinery/lapvend/proc/reimburse_id(var/obj/item/weapon/card/id/C, var/obj/item/I)
	visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	var/datum/money_account/CH = get_account(C.associated_account_number)
	if(!CH)
		to_chat(usr, "\icon[src]<span class='warning'>No valid account number is associated with this card.</span>")
		return 0
	if(CH.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		if(vendor_account)
			var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
			var/datum/money_account/D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
			if(D)
				transfer_and_reimburse(D)
				return 1
			else
				to_chat(usr, "\icon[src]<span class='warning'>Unable to access vendor account. Please record the machine ID and call [using_map.boss_short] Support.</span>")
				return 0
		else
			to_chat(usr, "\icon[src]<span class='warning'>Unable to access vendor account. Please record the machine ID and call [using_map.boss_short] Support.</span>")
			return 0
	else
		transfer_and_reimburse(CH)
		return 1

/obj/machinery/lapvend/proc/transfer_and_reimburse(var/datum/money_account/D)
	var/transaction_amount = total()
	//transfer the money
	D.money += transaction_amount
	vendor_account.money -= transaction_amount

	//Transaction logs
	var/datum/transaction/T = new()
	T.target_name = "[vendor_account.owner_name] (via [src.name])"
	T.purpose = "Return purchase of Laptop"
	if(transaction_amount > 0)
		T.amount = "([transaction_amount])"
	else
		T.amount = "[transaction_amount]"
	T.source_terminal = src.name
	T.date = current_date_string
	T.time = stationtime2text()
	D.transaction_log.Add(T)
	//
	T = new()
	T.target_name = D.owner_name
	T.purpose = "Return purchase of Laptop"
	T.amount = "[transaction_amount]"
	T.source_terminal = src.name
	T.date = current_date_string
	T.time = stationtime2text()
	vendor_account.transaction_log.Add(T)

	qdel(relap)
	vendmode = 0
	cardreader = 0
	floppy = 0
	radionet = 0
	camera = 0
	network = 0
	power = 0
