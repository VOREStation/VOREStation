/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000. //VOREStation Edit - Non-global
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
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
	icon = 'icons/obj/vending.dmi'
	icon_state = "seeds"
	icon_on = "seeds"
	icon_off = "seeds-off"

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Biological Sample Storage"
	desc = "A refrigerated storage unit for xenobiological samples."
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
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
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
	req_access = list(access_virology)
	icon_state = "smartfridge_virology"
	icon_on = "smartfridge_virology"
	icon_off = "smartfridge_virology-off"

/obj/machinery/smartfridge/secure/virology/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/beaker/vial/))
		return 1
	if(istype(O,/obj/item/weapon/virusdish/))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."

/obj/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/storage/pill_bottle) || istype(O,/obj/item/weapon/reagent_containers))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return 1

/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."
	wrenchable = 1
	icon_state = "drying_rack"
	icon_on = "drying_rack_on"
	icon_off = "drying_rack"
	icon_panel = "drying_rack-panel"

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		if (S.dried_type)
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
	overlays.Cut()
	var/not_working = stat & (BROKEN|NOPOWER)
	if(not_working)
		icon_state = icon_off
	else
		icon_state = icon_on
	var/hasItems
	for(var/datum/stored_item/I in item_records)
		if(I.get_amount())
			hasItems = 1
			break
	if(hasItems)
		overlays += "drying_rack_filled"
		if(!not_working)
			overlays += "drying_rack_drying"

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
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.is_screwdriver())
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		playsound(src, O.usesound, 50, 1)
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, icon_panel)
		GLOB.nanomanager.update_uis(src)
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
	GLOB.nanomanager.update_uis(src)

/obj/machinery/smartfridge/proc/vend(datum/stored_item/I)
	I.get_product(get_turf(src))
	GLOB.nanomanager.update_uis(src)

/obj/machinery/smartfridge/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/smartfridge/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	ui_interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure

	var/list/items[0]
	for (var/i=1 to length(item_records))
		var/datum/stored_item/I = item_records[i]
		var/count = I.get_amount()
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(I.item_name)), "vend" = i, "quantity" = count)))

	if(items.len > 0)
		data["contents"] = items

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/smartfridge/Topic(href, href_list)
	if(..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = GLOB.nanomanager.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if(href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if(href_list["vend"])
		var/index = text2num(href_list["vend"])
		var/amount = text2num(href_list["amount"])
		var/datum/stored_item/I = item_records[index]
		var/count = I.get_amount()

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(count > 0)
			if((count - amount) < 0)
				amount = count
			for(var/i = 1 to amount)
				vend(I)

		return 1
	return 0

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
	return 1

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0
	if(usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf)))
		if(!allowed(usr) && !emagged && locked != -1 && href_list["vend"])
			to_chat(usr, "<span class='warning'>Access denied.</span>")
			return 0
	return ..()
