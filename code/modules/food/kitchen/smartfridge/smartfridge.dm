/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	desc = "For storing all sorts of things! This one doesn't accept any of them!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	var/icon_base = "smartfridge" //Iconstate to base all the broken/deny/etc on
	var/icon_contents = "misc" //Overlay to put on glass to show contents
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/list/item_records = list()
	var/datum/stored_item/currently_vending = null	//What we're putting out of the machine.
	var/stored_datum_type = /datum/stored_item
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/wrenchable = 0
	var/datum/wires/smartfridge/wires = null
	var/persistent = null // Path of persistence datum used to track contents

/obj/machinery/smartfridge/secure
	is_secure = 1

/obj/machinery/smartfridge/Initialize()
	. = ..()
	if(persistent)
		SSpersistence.track_value(src, persistent)
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)
	update_icon()

/obj/machinery/smartfridge/Destroy()
	qdel(wires)
	for(var/A in item_records)	//Get rid of item records.
		qdel(A)
	wires = null
	if(persistent)
		SSpersistence.forget_value(src, persistent)
	return ..()

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj)
	return FALSE

/obj/machinery/smartfridge/process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfridge/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/smartfridge/update_icon()
	cut_overlays()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[icon_base]-off"
	else
		icon_state = icon_base

	if(panel_open)
		add_overlay("[icon_base]-panel")

	// Fridge contents
	switch(contents.len)
		if(1 to 3)
			add_overlay("[icon_base]-[icon_contents]1")
		if(3 to 6)
			add_overlay("[icon_base]-[icon_contents]2")
		if(6 to INFINITY)
			add_overlay("[icon_base]-[icon_contents]3")

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.is_screwdriver())
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		playsound(src, O.usesound, 50, 1)
		update_icon()
		return

	if(wrenchable && default_unfasten_wrench(user, O, 20))
		return

	if(istype(O, /obj/item/multitool) || O.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return

	if(stat & NOPOWER)
		to_chat(user, "<span class='notice'>\The [src] is unpowered and useless.</span>")
		return

	if(accept_check(O))
		user.remove_from_mob(O)
		stock(O)
		user.visible_message("<span class='notice'>[user] has added \the [O] to \the [src].</span>", "<span class='notice'>You add \the [O] to \the [src].</span>")
		sortTim(item_records, /proc/cmp_stored_item_name)

	else if(istype(O, /obj/item/storage/bag))
		var/obj/item/storage/bag/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				P.remove_from_storage(G) //fixes ui bug - Pull Request 5515
				stock(G)
				plants_loaded = 1
		if(plants_loaded)
			user.visible_message("<span class='notice'>[user] loads \the [src] with \the [P].</span>", "<span class='notice'>You load \the [src] with \the [P].</span>")
			if(P.contents.len > 0)
				to_chat(user, "<span class='notice'>Some items are refused.</span>")

	else if(istype(O, /obj/item/gripper)) // Grippers. ~Mechoid.
		var/obj/item/gripper/B = O	//B, for Borg.
		if(!B.wrapped)
			to_chat(user, "\The [B] is not holding anything.")
			return
		else
			var/B_held = B.wrapped
			to_chat(user, "You use \the [B] to put \the [B_held] into \the [src].")
		return

	else
		to_chat(user, "<span class='notice'>\The [src] smartly refuses [O].</span>")
		return 1

/obj/machinery/smartfridge/secure/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		locked = -1
		to_chat(user, "You short out the product lock on [src].")
		return 1

/obj/machinery/smartfridge/proc/find_record(var/obj/item/O)
	for(var/datum/stored_item/I as anything in item_records)
		if((O.type == I.item_path) && (O.name == I.item_name))
			return I
	return null

/obj/machinery/smartfridge/proc/stock(obj/item/O)
	var/datum/stored_item/I = find_record(O)
	if(!istype(I))
		I = new stored_datum_type(src, O.type, O.name)
		item_records.Add(I)
	I.add_product(O)
	SStgui.update_uis(src)
	update_icon()

/obj/machinery/smartfridge/proc/vend(datum/stored_item/I, var/count)
	var/amount = I.get_amount()
	// Sanity check, there are probably ways to press the button when it shouldn't be possible.
	if(amount <= 0)
		return

	for(var/i = 1 to min(amount, count))
		I.get_product(get_turf(src))
	SStgui.update_uis(src)
	update_icon()

/obj/machinery/smartfridge/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/smartfridge/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	tgui_interact(user)

/obj/machinery/smartfridge/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SmartVend", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/smartfridge/tgui_data(mob/user)
	. = list()

	var/list/items = list()
	for(var/i=1 to length(item_records))
		var/datum/stored_item/I = item_records[i]
		var/count = I.get_amount()
		if(count > 0)
			items.Add(list(list("name" = html_encode(capitalize(I.item_name)), "index" = i, "amount" = count)))

	.["contents"] = items
	.["name"] = name
	.["locked"] = locked
	.["secure"] = is_secure

/obj/machinery/smartfridge/tgui_act(action, params)
	if(..())
		return TRUE

	add_fingerprint(usr)
	switch(action)
		if("Release")
			var/amount = 0
			if(params["amount"])
				amount = params["amount"]
			else
				amount = tgui_input_number(usr, "How many items?", "How many items would you like to take out?", 1)
			
			if(QDELETED(src) || QDELETED(usr) || !usr.Adjacent(src))
				return FALSE
			
			var/index = text2num(params["index"])
			if(index < 1 || index > LAZYLEN(item_records))
				return TRUE
			
			vend(item_records[index], amount)
			return TRUE
	return FALSE

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return FALSE

	for(var/datum/stored_item/I in item_records)
		throw_item = I.get_product(get_turf(src))
		if (!throw_item)
			continue
		break

	if(!throw_item)
		return FALSE
	spawn(0)
		throw_item.throw_at(target,16,3,src)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	SStgui.update_uis(src)
	return TRUE

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/tgui_act(action, params)
	if(stat & (NOPOWER|BROKEN))
		return TRUE
	if(usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf)))
		if(!allowed(usr) && !emagged && locked != -1 && action == "Release")
			to_chat(usr, "<span class='warning'>Access denied.</span>")
			return TRUE
	return ..()
