#define CHARGER_EMPTY 0
#define CHARGER_WORKING 1
#define CHARGER_DONE 2

/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "recharger"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	power_channel = EQUIP
	idle_power_usage = 5
	active_power_usage = 60000	//60 kW. (this the power drawn when charging)
	circuit = /obj/item/weapon/circuitboard/cell_charger
	
	var/efficiency = 60000 //will provide the modified power rate when upgraded
	var/obj/item/weapon/cell/charging = null
	var/charging_vis_flags = NONE
	var/charge_state = CHARGER_EMPTY

/obj/machinery/cell_charger/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/cell_charger/update_icon()
	var/new_state
	if(!anchored)
		new_state = "[initial(icon_state)]4"
		return

	if(stat & (BROKEN|NOPOWER))
		new_state = "[initial(icon_state)]3"
		return

	switch(charge_state)
		if(CHARGER_EMPTY)
			new_state = "[initial(icon_state)]0"
		if(CHARGER_WORKING)
			new_state = "[initial(icon_state)]1"
		if(CHARGER_DONE)
			new_state = "[initial(icon_state)]2"
	
	if(icon_state != new_state)
		icon_state = new_state

/obj/machinery/cell_charger/proc/insert_item(obj/item/W, mob/user)
	if(!W || !user)
		return

	user.drop_item()
	charging = W
	charging.loc = src
	charging_vis_flags = charging.vis_flags
	charging.vis_flags = VIS_INHERIT_ID
	vis_contents += charging
	
	charge_state = CHARGER_WORKING
	update_icon()

	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(USE_POWER_OFF)
	else
		update_use_power(USE_POWER_ACTIVE)

/obj/machinery/cell_charger/proc/remove_item(mob/user)
	if(!charging || !user)
		return

	vis_contents -= charging
	charging.vis_flags = charging_vis_flags
	user.put_in_hands(charging)
	charging = null

	charge_state = CHARGER_EMPTY

	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(USE_POWER_OFF)
	else
		update_use_power(USE_POWER_IDLE)
	
	update_icon()

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

			insert_item(W, user)
			user.visible_message("[user] inserts [charging] into [src].", "You insert [charging] into [src].")
		update_icon()
	else if(W.is_wrench())
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] [src] [anchored ? "to" : "from"] the ground")
		playsound(src, W.usesound, 75, 1)
	else if(default_deconstruction_screwdriver(user, W))
		return
	else if(default_deconstruction_crowbar(user, W))
		return
	else if(default_part_replacement(user, W))
		return

/obj/machinery/cell_charger/attack_hand(mob/user)
	add_fingerprint(user)

	if(charging)
		remove_item(user)
		user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")

/obj/machinery/cell_charger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(charging)
			remove_item(user)
			user.visible_message("[user] disconnects [charging] from [src].", "You disconnect [charging] from [src].")
			

/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)

/obj/machinery/cell_charger/power_change()
	. = ..()
	update_icon()

/obj/machinery/cell_charger/process()
	//to_world("ccpt [charging] [stat]")
	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(USE_POWER_OFF)
		return

	if(charging)
		if(!charging.fully_charged())
			charge_state = CHARGER_WORKING
			charging.give(efficiency*CELLRATE)
			update_use_power(USE_POWER_ACTIVE)
		else
			charge_state = CHARGER_DONE
			update_use_power(USE_POWER_IDLE)
		update_icon()

/obj/machinery/cell_charger/RefreshParts()
	var/E = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = active_power_usage * (1+ (E - 1)*0.5)

#undef CHARGER_EMPTY
#undef CHARGER_WORKING
#undef CHARGER_DONE