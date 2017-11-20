//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
obj/machinery/recharger
	name = "recharger"
	icon = 'icons/obj/stationobjs_vr.dmi' //VOREStation Edit
	icon_state = "recharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 40000	//40 kW
	var/obj/item/charging = null
	var/list/allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton, /obj/item/device/laptop, /obj/item/weapon/cell, /obj/item/device/flashlight, /obj/item/device/electronic_assembly, /obj/item/weapon/weldingtool/electric, /obj/item/ammo_casing/nsfw_batt) //VOREStation Add - NSFW Batteries
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1
	circuit = /obj/item/weapon/circuitboard/recharger

/obj/machinery/recharger/New()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/stack/cable_coil(src, 5)
	RefreshParts()
	..()
	return

/obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	var/allowed = 0
	for (var/allowed_type in allowed_devices)
		if(istype(G, allowed_type)) allowed = 1

	if(allowed)
		if(charging)
			to_chat(user, "<span class='warning'>\A [charging] is already charging here.</span>")
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, "<span class='warning'>The [name] blinks red as you try to insert the item!</span>")
			return
		if(istype(G, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = G
			if(!E.power_supply)
				to_chat(user, "<span class='notice'>Your gun has no power cell.</span>")
				return
			if(E.self_recharge)
				to_chat(user, "<span class='notice'>Your gun has no recharge port.</span>")
				return
		if(istype(G, /obj/item/weapon/gun/energy/staff))
			return
		if(istype(G, /obj/item/device/flashlight))
			var/obj/item/device/flashlight/F = G
			if(!F.power_use)
				return
			if(!F.cell)
				return
		if(istype(G, /obj/item/device/laptop))
			var/obj/item/device/laptop/L = G
			if(!L.stored_computer.battery)
				user << "There's no battery in it!"
				return
		if(istype(G, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/assembly = G
			if(!assembly.battery)
				to_chat(user, "<span class='warning'>The assembly doesn't have a power cell.</span>")
				return
		if(istype(G, /obj/item/weapon/weldingtool/electric))
			var/obj/item/weapon/weldingtool/electric/welder = G
			if(!welder.power_supply)
				to_chat(user, "<span class='notice'>Your welder has no power cell.</span>")
				return

		user.drop_item()
		G.loc = src
		charging = G
		update_icon()
	else if(portable && istype(G, /obj/item/weapon/wrench))
		if(charging)
			to_chat(user, "<span class='warning'>Remove [charging] first!</span>")
			return
		anchored = !anchored
		to_chat(user, "You [anchored ? "attached" : "detached"] the recharger.")
		playsound(loc, G.usesound, 75, 1)
	else if(default_deconstruction_screwdriver(user, G))
		return
	else if(default_deconstruction_crowbar(user, G))
		return

/obj/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

/obj/machinery/recharger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(0)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(1)
		icon_state = icon_state_idle
	else
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(!E.power_supply.fully_charged())
				icon_state = icon_state_charging
				E.power_supply.give(active_power_usage*CELLRATE)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)
			return

		if(istype(charging, /obj/item/weapon/gun/magnetic))
			var/obj/item/weapon/gun/magnetic/M = charging
			if(!M.cell.fully_charged())
				icon_state = icon_state_charging
				M.cell.give(active_power_usage*CELLRATE)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)
			return

		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			if(B.bcell)
				if(!B.bcell.fully_charged())
					icon_state = icon_state_charging
					B.bcell.give(active_power_usage*CELLRATE)
					update_use_power(2)
				else
					icon_state = icon_state_charged
					update_use_power(1)
			else
				icon_state = icon_state_idle
				update_use_power(1)
			return

		if(istype(charging, /obj/item/device/laptop))
			var/obj/item/device/laptop/L = charging
			if(!L.stored_computer.battery.fully_charged())
				icon_state = icon_state_charging
				L.stored_computer.battery.give(active_power_usage*CELLRATE)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)
			return

		if(istype(charging, /obj/item/device/flashlight))
			var/obj/item/device/flashlight/F = charging
			if(F.cell)
				if(!F.cell.fully_charged())
					icon_state = icon_state_charging
					F.cell.give(active_power_usage*CELLRATE)
					update_use_power(2)
				else
					icon_state = icon_state_charged
					update_use_power(1)
			else
				icon_state = icon_state_idle
				update_use_power(1)
			return

		if(istype(charging, /obj/item/weapon/cell))
			var/obj/item/weapon/cell/C = charging
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(active_power_usage*CELLRATE)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)
			return

		if(istype(charging, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/assembly = charging
			if(assembly.battery)
				if(!assembly.battery.fully_charged())
					icon_state = icon_state_charging
					assembly.battery.give(active_power_usage*CELLRATE)
					update_use_power(2)
				else
					icon_state = icon_state_charged
					update_use_power(1)
			else
				icon_state = icon_state_idle
				update_use_power(1)
			return

		//VOREStation Add - NSFW Batteries
		if(istype(charging, /obj/item/ammo_casing/nsfw_batt))
			var/obj/item/ammo_casing/nsfw_batt/batt = charging
			if(batt.shots_left >= initial(batt.shots_left))
				icon_state = icon_state_charged
				update_use_power(1)
			else
				icon_state = icon_state_charging
				batt.shots_left++
				update_use_power(2)
			return
		//VOREStation Add End

		if(istype(charging, /obj/item/weapon/weldingtool/electric))
			var/obj/item/weapon/weldingtool/electric/C = charging
			if(!C.power_supply.fully_charged())
				icon_state = icon_state_charging
				C.power_supply.give(active_power_usage*CELLRATE)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)
			return

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(istype(charging,  /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/E = charging
		if(E.power_supply)
			E.power_supply.emp_act(severity)

	else if(istype(charging, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = charging
		if(B.bcell)
			B.bcell.charge = 0
	..(severity)

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle


/obj/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 25000	//25 kW , It's more specialized than the standalone recharger (guns, batons, and flashlights only) so make it more powerful
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/gun/magnetic, /obj/item/weapon/melee/baton, /obj/item/device/flashlight, /obj/item/weapon/cell/device)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
	circuit = /obj/item/weapon/circuitboard/recharger/wrecharger