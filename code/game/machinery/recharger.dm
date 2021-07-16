//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj/machinery/recharger
	name = "recharger"
	desc = "A standard recharger for all devices that use power."
	icon = 'icons/obj/stationobjs_vr.dmi' //VOREStation Edit
	icon_state = "recharger0"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 4
	active_power_usage = 40000	//40 kW
	var/efficiency = 40000 //will provide the modified power rate when upgraded
	var/obj/item/charging = null
	var/list/allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton, /obj/item/modular_computer, /obj/item/weapon/computer_hardware/battery_module, /obj/item/weapon/cell, /obj/item/device/suit_cooling_unit/emergency, /obj/item/device/flashlight, /obj/item/device/electronic_assembly, /obj/item/weapon/weldingtool/electric, /obj/item/ammo_magazine/smart, /obj/item/device/flash, /obj/item/device/defib_kit, /obj/item/ammo_casing/microbattery)  //VOREStation Add - NSFW Batteries
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1
	circuit = /obj/item/weapon/circuitboard/recharger

/obj/machinery/recharger/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/recharger/examine(mob/user)
	. = ..()

	if(get_dist(user, src) <= 5)
		. += "[charging ? "[charging]" : "Nothing"] is in [src]."
		if(charging)
			var/obj/item/weapon/cell/C = charging.get_cell()
			. += "Current charge: [C.charge] / [C.maxcharge]"

/obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	var/allowed = 0
	for (var/allowed_type in allowed_devices)
		if(istype(G, allowed_type)) allowed = 1

	if(allowed)
		if(charging)
			to_chat(user, "<span class='warning'>\A [charging] is already charging here.</span>")
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, "<span class='warning'>\The [src] blinks red as you try to insert [G]!</span>")
			return
		if(istype(G, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = G
			if(E.self_recharge)
				to_chat(user, "<span class='notice'>\The [E] has no recharge port.</span>")
				return
		if(istype(G, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = G
			if(!C.battery_module)
				to_chat(user, "<span class='notice'>\The [C] does not have a battery installed. </span>")
				return
		if(istype(G, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = G
			if(B.use_external_power)
				to_chat(user, "<span class='notice'>\The [B] has no recharge port.</span>")
				return
		if(istype(G, /obj/item/device/flash))
			var/obj/item/device/flash/F = G
			if(F.use_external_power)
				to_chat(user, "<span class='notice'>\The [F] has no recharge port.</span>")
				return
		if(istype(G, /obj/item/weapon/weldingtool/electric))
			var/obj/item/weapon/weldingtool/electric/EW = G
			if(EW.use_external_power)
				to_chat(user, "<span class='notice'>\The [EW] has no recharge port.</span>")
				return
		if(!G.get_cell() && !istype(G, /obj/item/ammo_casing/microbattery))	//VOREStation Edit: NSFW charging
			to_chat(user, "\The [G] does not have a battery installed.")
			return

		user.drop_item()
		G.loc = src
		charging = G
		update_icon()
		user.visible_message("[user] inserts [charging] into [src].", "You insert [charging] into [src].")

	else if(portable && G.is_wrench())
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] [src].")
		playsound(src, G.usesound, 75, 1)
	else if(default_deconstruction_screwdriver(user, G))
		return
	else if(default_deconstruction_crowbar(user, G))
		return
	else if(default_part_replacement(user, G))
		return

/obj/machinery/recharger/attack_hand(mob/user as mob)
	if(!Adjacent(user))
		return FALSE
	add_fingerprint(user)

	if(charging)
		user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

/obj/machinery/recharger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(charging)
			user.visible_message("[user] removes [charging] from [src].", "You remove [charging] from [src].")
			charging.update_icon()
			charging.loc = src.loc
			charging = null
			update_icon()

/obj/machinery/recharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(USE_POWER_OFF)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(USE_POWER_IDLE)
		icon_state = icon_state_idle
	else
		var/obj/item/weapon/cell/C = charging.get_cell()
		if(istype(C))
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(CELLRATE*efficiency)
				update_use_power(USE_POWER_ACTIVE)
			else
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)

		//VOREStation Add - NSFW Batteries
		else if(istype(charging, /obj/item/ammo_casing/microbattery))
			var/obj/item/ammo_casing/microbattery/batt = charging
			if(batt.shots_left >= initial(batt.shots_left))
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)
			else
				icon_state = icon_state_charging
				batt.shots_left++
				update_use_power(USE_POWER_ACTIVE)
			return
		//VOREStation Add End

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(charging)
		var/obj/item/weapon/cell/C = charging.get_cell()
		if(istype(C))
			C.emp_act(severity)

	..(severity)

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle

/obj/machinery/recharger/RefreshParts()
	var/E = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = active_power_usage * (1+ (E - 1)*0.5)

/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	desc = "A more powerful recharger designed for energy weapons."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	active_power_usage = 60000	//60 kW , It's more specialized than the standalone recharger (guns, batons, and flashlights only) so make it more powerful
	efficiency = 60000
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/gun/magnetic, /obj/item/weapon/melee/baton, /obj/item/device/flashlight, /obj/item/weapon/cell/device)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
	circuit = /obj/item/weapon/circuitboard/recharger/wrecharger
