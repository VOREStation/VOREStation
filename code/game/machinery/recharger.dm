GLOBAL_LIST_INIT(allowed_recharger_devices, list(
	/obj/item/gun/energy,
	/obj/item/gun/magnetic,
	/obj/item/melee/baton,
	/obj/item/modular_computer,
	/obj/item/computer_hardware/battery_module,
	/obj/item/cell,
	/obj/item/suit_cooling_unit/emergency,
	/obj/item/flashlight,
	/obj/item/electronic_assembly,
	/obj/item/weldingtool/electric,
	/obj/item/ammo_magazine/smart,
	/obj/item/flash,
	/obj/item/defib_kit,
	/obj/item/ammo_casing/microbattery,
	/obj/item/paicard,
	/obj/item/personal_shield_generator,
	/obj/item/gun/projectile/cell_loaded,
	/obj/item/ammo_magazine/cell_mag
	))

GLOBAL_LIST_INIT(allowed_wallcharger_devices, list(
	/obj/item/gun/energy,
	/obj/item/gun/magnetic,
	/obj/item/melee/baton,
	/obj/item/flashlight,
	/obj/item/cell/device
	))

GLOBAL_LIST_INIT(recharger_battery_exempt, list(
	/obj/item/ammo_casing/microbattery,
	/obj/item/paicard,
	/obj/item/gun/projectile/cell_loaded,
	/obj/item/ammo_magazine/cell_mag
	))

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj/machinery/recharger
	name = "recharger"
	desc = "A standard recharger for all devices that use power."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 4
	active_power_usage = 40000	//40 kW
	var/efficiency = 40000 //will provide the modified power rate when upgraded
	var/obj/item/charging = null
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	///If we can be wrenched and moved around or not.
	var/portable = TRUE
	///If we can charge everything or use a smaller list.
	var/small = FALSE
	circuit = /obj/item/circuitboard/recharger

/obj/machinery/recharger/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/recharger/examine(mob/user)
	. = ..()

	if(get_dist(user, src) <= 5)
		. += "[charging ? "[charging]" : "Nothing"] is in [src]."
		if(charging)
			var/obj/item/cell/C = charging.get_cell()
			if(C)				// Sometimes we get things without cells in it.
				. += "Current charge: [C.charge] / [C.maxcharge]"

/obj/machinery/recharger/attackby(obj/item/G as obj, mob/user as mob)
	if((!small && is_type_in_list(G, GLOB.allowed_recharger_devices)) || (small && is_type_in_list(G, GLOB.allowed_wallcharger_devices)))
		if(charging)
			to_chat(user, span_warning("\A [charging] is already charging here."))
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			to_chat(user, span_warning("\The [src] blinks red as you try to insert [G]!"))
			return
		if(istype(G, /obj/item/gun/energy))
			var/obj/item/gun/energy/E = G
			if(E.self_recharge)
				to_chat(user, span_notice("\The [E] has no recharge port."))
				return
		if(istype(G, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = G
			if(!C.battery_module)
				to_chat(user, span_notice("\The [C] does not have a battery installed. "))
				return
		if(istype(G, /obj/item/flash))
			var/obj/item/flash/F = G
			if(F.use_external_power)
				to_chat(user, span_notice("\The [F] has no recharge port."))
				return
		if(istype(G, /obj/item/weldingtool/electric))
			var/obj/item/weldingtool/electric/EW = G
			if(EW.use_external_power)
				to_chat(user, span_notice("\The [EW] has no recharge port."))
				return
		if(!G.get_cell() && !is_type_in_list(G, GLOB.recharger_battery_exempt))
			to_chat(user, "\The [G] does not have a battery installed.")
			return
		if(istype(G, /obj/item/paicard))
			var/obj/item/paicard/ourcard = G
			if(ourcard.panel_open)
				to_chat(user, span_warning("\The [ourcard] won't fit in the recharger with its panel open."))
				return
			if(ourcard.pai)
				if(ourcard.pai.stat == CONSCIOUS)
					to_chat(user, span_warning("\The [ourcard] boops... it doesn't need to be recharged!"))
					return
			else
				to_chat(user, span_warning("\The [ourcard] doesn't have a personality!"))
				return
		if(HAS_TRAIT(user, TRAIT_UNLUCKY) && prob(10))
			user.visible_message("[user] inserts [charging] into [src] backwards!", "You insert [charging] into [src] backwards!")
			user.drop_item()
			G.loc = get_turf(src)
			return
		user.drop_item()
		G.loc = src
		charging = G
		update_icon()
		user.visible_message("[user] inserts [charging] into [src].", "You insert [charging] into [src].")

	else if(portable && G.has_tool_quality(TOOL_WRENCH))
		if(charging)
			to_chat(user, span_warning("Remove [charging] first!"))
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
	if(isrobot(user) && Adjacent(user)) // Borgs can remove the cell if they are near enough
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

	//PAI Cards
	else if(istype(charging, /obj/item/paicard))
		var/obj/item/paicard/pcard = charging
		if(pcard.is_damage_critical())
			pcard.forceMove(get_turf(src))
			charging = null
			pcard.damage_random_component()
			update_icon()
		else if(pcard.pai.bruteloss)
			pcard.pai.adjustBruteLoss(-5)
		else if(pcard.pai.fireloss)
			pcard.pai.adjustFireLoss(-5)
		else
			charging = null
			update_icon()
			src.visible_message(span_notice("\The [src] ejects the [pcard]!"))
			pcard.forceMove(get_turf(src))
			pcard.pai.full_restore()
	//Charging cell-loaded guns.
	else if(istype(charging, /obj/item/gun/projectile/cell_loaded))
		var/obj/item/gun/projectile/cell_loaded/cellgun = charging
		var/obj/item/ammo_magazine/magazine = cellgun.ammo_magazine //CAN BE NULL.
		var/obj/item/ammo_casing/microbattery/batt = cellgun.chambered //CAN BE NULL.

		//First, we charge the currently chambered battery if there is one.
		if(batt && !(batt.shots_left >= initial(batt.shots_left)))
			icon_state = icon_state_charging
			batt.shots_left++
			update_use_power(USE_POWER_ACTIVE)
			return
		//Second, we charge the batteries in the magazine.
		else if(magazine && LAZYLEN(magazine.stored_ammo))
			for(var/obj/item/ammo_casing/microbattery/shot_to_charge in magazine)
				if(shot_to_charge.shots_left >= initial(shot_to_charge.shots_left))
					continue
				shot_to_charge.shots_left++
				icon_state = icon_state_charging
				update_use_power(USE_POWER_ACTIVE)
				return //only heal one at a time.
		//If the chambered battery AND the magazine are all full, we are done.
		icon_state = icon_state_charged
		update_use_power(USE_POWER_IDLE)
		return
	//Charging cell magazines
	else if(istype(charging, /obj/item/ammo_magazine/cell_mag))
		var/obj/item/ammo_magazine/cell_mag/magazine = charging
		if(LAZYLEN(magazine.stored_ammo))
			for(var/obj/item/ammo_casing/microbattery/shot_to_charge in magazine)
				if(shot_to_charge.shots_left >= initial(shot_to_charge.shots_left))
					continue
				shot_to_charge.shots_left++
				icon_state = icon_state_charging
				update_use_power(USE_POWER_ACTIVE)
				return
		icon_state = icon_state_charged
		update_use_power(USE_POWER_IDLE)
		return
	else
		//Everything Else
		var/obj/item/cell/C = charging.get_cell()
		if(istype(C))
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(CELLRATE*efficiency)
				update_use_power(USE_POWER_ACTIVE)
			else
				icon_state = icon_state_charged
				update_use_power(USE_POWER_IDLE)

		//NSFW Batteries
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

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(charging)
		var/obj/item/cell/C = charging.get_cell()
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
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
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
	small = TRUE
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = FALSE
	circuit = /obj/item/circuitboard/recharger/wrecharger
