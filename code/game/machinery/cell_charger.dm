/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 60000	//60 kW. (this the power drawn when charging)
	var/efficiency = 60000 //will provide the modified power rate when upgraded
	power_channel = EQUIP
	var/obj/item/weapon/cell/charging = null
	var/chargelevel = -1
	circuit = /obj/item/weapon/circuitboard/cell_charger

/obj/machinery/cell_charger/Initialize()
	. = ..()
	default_apply_parts()
	add_overlay("ccharger1")

/obj/machinery/cell_charger/update_icon()
	if(!anchored)
		cut_overlays()
		icon_state = "ccharger2"

	if(charging && !(stat & (BROKEN|NOPOWER)))
		var/newlevel = 	round(charging.percent() * 4.0 / 99)
		//to_world("nl: [newlevel]")

		if(chargelevel != newlevel)

			cut_overlays()
			add_overlay("ccharger-o[newlevel]")

			chargelevel = newlevel

		add_overlay(image(charging.icon, charging.icon_state))
		add_overlay("ccharger-[charging.connector_type]-on")

	else if(anchored)
		cut_overlays()
		icon_state = "ccharger0"
		add_overlay("ccharger1")

/obj/machinery/cell_charger/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 5)
		. += "[charging ? "[charging]" : "Nothing"] is in [src]."
		if(charging)
			. += "Current charge: [charging.charge] / [charging.maxcharge]"

/obj/machinery/cell_charger/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/weapon/cell) && anchored)
		if(istype(W, /obj/item/weapon/cell/device))
			to_chat(user, "<span class='warning'>\The [src] isn't fitted for that type of cell.</span>")
			return
		if(charging)
			to_chat(user, "<span class='warning'>There is already [charging] in [src].</span>")
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, "<span class='warning'>\The [src] blinks red as you try to insert [W]!</span>")
				return

			user.drop_item()
			W.loc = src
			charging = W
			user.visible_message("[user] inserts [charging] into [src].", "You insert [charging] into [src].")
			chargelevel = -1
		update_icon()
	else if(W.is_wrench())
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] [src] [anchored ? "to" : "from"] the ground")
		playsound(src, W.usesound, 75, 1)
		update_icon()
	else if(default_deconstruction_screwdriver(user, W))
		return
	else if(default_deconstruction_crowbar(user, W))
		return
	else if(default_part_replacement(user, W))
		return

/obj/machinery/cell_charger/attack_hand(mob/user)
	add_fingerprint(user)

	if(charging)
		user.put_in_hands(charging)
		charging.update_icon()
		user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")

		charging = null
		chargelevel = -1
		update_icon()

/obj/machinery/cell_charger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(charging)
			user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")
			charging.loc = src.loc
			charging.update_icon()
			charging = null
			update_icon()

/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)


/obj/machinery/cell_charger/process()
	//to_world("ccpt [charging] [stat]")
	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(USE_POWER_OFF)
		return

	if(charging && !charging.fully_charged())
		charging.give(efficiency*CELLRATE)
		update_use_power(USE_POWER_ACTIVE)

		update_icon()
	else
		update_use_power(USE_POWER_IDLE)

/obj/machinery/cell_charger/RefreshParts()
	var/E = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = active_power_usage * (1+ (E - 1)*0.5)