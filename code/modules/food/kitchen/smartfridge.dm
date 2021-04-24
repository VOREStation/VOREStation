/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	desc = "For storing all sorts of perishable foods!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "fridge_food"
	var/icon_base = "fridge_food" //Iconstate to base all the broken/deny/etc on
	var/icon_contents = "food" //Overlay to put on glass to show contents
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000. //VOREStation Edit - Non-global
	//var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/list/item_records = list()
	var/datum/stored_item/currently_vending = null	//What we're putting out of the machine.
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/wrenchable = 0
	var/datum/wires/smartfridge/wires = null

/obj/machinery/smartfridge/secure
	is_secure = 1
	icon_state = "fridge_sci"
	icon_base = "fridge_sci"
	icon_contents = "chem"

/obj/machinery/smartfridge/New()
	..()
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)

/obj/machinery/smartfridge/Destroy()
	qdel(wires)
	for(var/A in item_records)	//Get rid of item records.
		qdel(A)
	wires = null
	return ..()

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_contents = "chem"

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Biological Sample Storage"
	desc = "A refrigerated storage unit for xenobiological samples."
	icon_contents = "slime"
	req_access = list(access_research)

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/slime_extract))
		return TRUE
	if(istype(O, /obj/item/slimepotion))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	req_one_access = list(access_medical,access_chemistry)

/obj/machinery/smartfridge/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/))
		return 1
	if(istype(O,/obj/item/weapon/storage/pill_bottle/))
		return 1
	if(istype(O,/obj/item/weapon/reagent_containers/pill/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	icon_contents = "drink"
	req_access = list(access_virology)

/obj/machinery/smartfridge/secure/virology/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/beaker/vial/))
		return 1
	if(istype(O,/obj/item/weapon/virusdish/))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry //Is this used anywhere? It's not secure.
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."
	icon_contents = "chem"

/obj/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/storage/pill_bottle) || istype(O,/obj/item/weapon/reagent_containers))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry/virology //Same
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."

/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	icon_state = "fridge_drinks"
	icon_base = "fridge_drinks"
	icon_contents = "drink"

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return 1

/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."
	wrenchable = 1
	icon_state = "drying_rack"
	icon_base = "drying_rack"

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		if (S.dried_type)
			return 1

	if(istype(O, /obj/item/stack/wetleather))
		return 1

	return 0

/obj/machinery/smartfridge/drying_rack/process()
	..()
	if(stat & (BROKEN|NOPOWER))
		return
	if(contents.len)
		dry()
		update_icon()

/obj/machinery/smartfridge/drying_rack/update_icon()
	var/not_working = stat & (BROKEN|NOPOWER)
	var/hasItems
	for(var/datum/stored_item/I in item_records)
		if(I.get_amount())
			hasItems = 1
			break
	if(hasItems)
		if(not_working)
			icon_state = "[icon_base]-plant-off"
		else
			icon_state = "[icon_base]-plant"
	else
		if(not_working)
			icon_state = "[icon_base]-off"
		else
			icon_state = "[icon_base]"

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/datum/stored_item/I in item_records)
		for(var/obj/item/weapon/reagent_containers/food/snacks/S in I.instances)
			if(S.dry) continue
			if(S.dried_type == S.type)
				S.dry = 1
				S.name = "dried [S.name]"
				S.color = "#AAAAAA"
				I.instances -= S
				S.forceMove(get_turf(src))
			else
				var/D = S.dried_type
				new D(get_turf(src))
				qdel(S)
			return

		for(var/obj/item/stack/wetleather/WL in I.instances)
			if(!WL.wetness)
				if(WL.amount)
					WL.forceMove(get_turf(src))
					WL.dry()
				I.instances -= WL
				break

			WL.wetness = max(0, WL.wetness - rand(1, 3))

	return

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

	if(is_secure)
		add_overlay("[icon_base]-sidepanel")

	if(panel_open)
		add_overlay("[icon_base]-panel")

	var/is_off = ""
	if(inoperable())
		is_off = "-off"

	// Fridge contents
	if(contents) //VOREStation Edit - Some fridges do not have visible contents
		switch(contents.len)
			if(0)
				add_overlay("empty[is_off]")
			if(1 to 2)
				add_overlay("[icon_contents]-1[is_off]")
			if(3 to 5)
				add_overlay("[icon_contents]-2[is_off]")
			if(6 to 8)
				add_overlay("[icon_contents]-3[is_off]")
			else
				add_overlay("[icon_contents]-4[is_off]")

	// Fridge top
	var/image/top = image(icon, "[icon_base]-top")
	top.pixel_z = 32
	top.layer = ABOVE_WINDOW_LAYER
	add_overlay(top)

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

	if(istype(O, /obj/item/device/multitool) || O.is_wirecutter())
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

	else if(istype(O, /obj/item/weapon/storage/bag))
		var/obj/item/weapon/storage/bag/P = O
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

	else if(istype(O, /obj/item/weapon/gripper)) // Grippers. ~Mechoid.
		var/obj/item/weapon/gripper/B = O	//B, for Borg.
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

/obj/machinery/smartfridge/proc/stock(obj/item/O)
	var/hasRecord = FALSE	//Check to see if this passes or not.
	for(var/datum/stored_item/I in item_records)
		if((O.type == I.item_path) && (O.name == I.item_name))
			I.add_product(O)
			hasRecord = TRUE
			break
	if(!hasRecord)
		var/datum/stored_item/item = new/datum/stored_item(src, O.type, O.name)
		item.add_product(O)
		item_records.Add(item)
	SStgui.update_uis(src)

/obj/machinery/smartfridge/proc/vend(datum/stored_item/I)
	I.get_product(get_turf(src))
	SStgui.update_uis(src)

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
				amount = input("How many items?", "How many items would you like to take out?", 1) as num|null
			
			if(QDELETED(src) || QDELETED(usr) || !usr.Adjacent(src))
				return FALSE
			
			var/index = text2num(params["index"])
			var/datum/stored_item/I = item_records[index]
			var/count = I.get_amount()

			// Sanity check, there are probably ways to press the button when it shouldn't be possible.
			if(count > 0)
				if((count - amount) < 0)
					amount = count
				for(var/i = 1 to amount)
					vend(I)

			return TRUE
	return FALSE

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_item/I in item_records)
		throw_item = I.get_product(get_turf(src))
		if (!throw_item)
			continue
		break

	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3,src)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	SStgui.update_uis(src)
	return 1

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
