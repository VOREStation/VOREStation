///////// Smart Mags /////////

/obj/item/ammo_magazine/smart
	name = "smart magazine"
	icon_state = "smartmag-empty"
	desc = "A Hephaestus Industries brand Smart Magazine. It uses advanced matter manipulation technology to create bullets from energy. Simply present your loaded gun or magazine to the Smart Magazine."
	multiple_sprites = 1
	max_ammo = 5
	mag_type = MAGAZINE

	caliber = null 	 //Set later
	ammo_type = null //Set later
	initial_ammo = 0 //Ensure no problems with no ammo_type or caliber set

	can_remove_ammo = FALSE	// Interferes with batteries

	var/production_time = 6 SECONDS		// Delay in between bullets forming
	var/last_production_time = 0		// Used in determining if we should make a new bullet
	var/production_cost = null			// Set when an ammo type is scanned in
	var/production_modifier = 2			// Multiplier on the ammo_casing's matter cost
	var/production_delay = 75			// If we're in a gun, how long since it last shot do we need to wait before making bullets?

	var/obj/item/gun/holding_gun = null	// What gun are we in, if any?

	var/obj/item/cell/device/attached_cell = null	// What cell are we using, if any?

	var/emagged = 0		// If you emag the smart mag, you can get the bullets out by clicking it

/obj/item/ammo_magazine/smart/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/ammo_magazine/smart/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/ammo_magazine/smart/process()
	if(!holding_gun)	// Yes, this is awful, sorry. Don't know a better way to figure out if we've been moved into or out of a gun.
		if(istype(src.loc, /obj/item/gun))
			holding_gun = src.loc

	if(caliber && ammo_type && attached_cell)
		if(stored_ammo.len == max_ammo)
			last_production_time = world.time	// Otherwise the max_ammo var is basically always off by 1
			return
		if(holding_gun && world.time < holding_gun.last_shot + production_delay)	// Same as recharging energy weapons.
			return
		if(world.time > last_production_time + production_time)
			last_production_time = world.time
			produce()

/obj/item/ammo_magazine/smart/examine(mob/user)
	. = ..()

	if(attached_cell)
		. += span_notice("\The [src] is loaded with a [attached_cell.name]. It is [round(attached_cell.percent())]% charged.")
	else
		. += span_warning("\The [src] does not appear to have a power source installed.")

/obj/item/ammo_magazine/smart/update_icon()
	if(attached_cell)
		icon_state = "smartmag-filled"
	else
		icon_state = "smartmag-empty"

// Emagging lets you remove bullets from your bullet-making magazine
/obj/item/ammo_magazine/smart/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, span_notice("You overload \the [src]'s security measures causing widespread destabilisation. It is likely you could empty \the [src] now."))
		emagged = TRUE
		can_remove_ammo = TRUE
		return TRUE
	return FALSE

/obj/item/ammo_magazine/smart/attackby(var/obj/item/I as obj, mob/user)
	if(istype(I, /obj/item/cell/device))
		if(attached_cell)
			to_chat(user, span_notice("\The [src] already has a [attached_cell.name] attached."))
			return
		else
			to_chat(user, "You begin inserting \the [I] into \the [src].")
			if(do_after(user, 25))
				user.drop_item()
				I.forceMove(src)
				attached_cell = I
				user.visible_message("[user] installs a cell in \the [src].", "You install \the [I] into \the [src].")
				update_icon()
				return

	else if(I.has_tool_quality(TOOL_SCREWDRIVER))
		if(attached_cell)
			to_chat(user, "You begin removing \the [attached_cell] from \the [src].")
			if(do_after(user, 10))	// Faster than doing it by hand
				attached_cell.update_icon()
				attached_cell.forceMove(get_turf(src.loc))
				attached_cell = null
				user.visible_message("[user] removes a cell from \the [src].", "You remove \the [attached_cell] from \the [src].")
				update_icon()
				return

	else if(istype(I, /obj/item/ammo_magazine) || istype(I, /obj/item/ammo_casing))
		scan_ammo(I, user)

	..()

/obj/item/ammo_magazine/smart/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(src.loc == user)
		scan_ammo(target, user)
	..()

// You can remove the power cell from the magazine by hand, but it's way slower than using a screwdriver
/obj/item/ammo_magazine/smart/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(attached_cell)
			to_chat(user, "You struggle to remove \the [attached_cell] from \the [src].")
			if(do_after(user, 40))
				attached_cell.update_icon()
				user.put_in_hands(attached_cell)
				attached_cell = null
				user.visible_message("[user] removes a cell from \the [src].", "You remove \the [attached_cell] from \the [src].")
				update_icon()
				return
	..()

// Classic emp_act, just drains the battery
/obj/item/ammo_magazine/smart/emp_act(severity)
	..()
	if(attached_cell)
		attached_cell.emp_act(severity)

// Finds the cell for the magazine, used by rechargers
/obj/item/ammo_magazine/smart/get_cell()
	return attached_cell

// Removes energy from the attached cell when creating new bullets
/obj/item/ammo_magazine/smart/proc/chargereduction()
	return attached_cell && attached_cell.checked_use(production_cost)

// Sets how much energy is drained to make each bullet
/obj/item/ammo_magazine/smart/proc/set_production_cost(var/obj/item/ammo_casing/A)
	var/list/matters = ammo_repository.get_materials_from_object(A)
	var/tempcost
	for(var/key in matters)
		var/value = matters[key]
		tempcost += value * production_modifier
	production_cost = tempcost

// Scans a magazine or ammo casing and tells the smart mag to start making those, if it can
/obj/item/ammo_magazine/smart/proc/scan_ammo(atom/target, mob/user)

	var/new_caliber = caliber		// Tracks what our new caliber will be
	var/new_ammo_type = ammo_type	// Tracks what our new ammo_type will be

	if(istype(target, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/M = target
		if(!new_caliber)
			new_caliber = M.caliber	// If caliber isn't set, set it now

		if(new_caliber && new_caliber != M.caliber)	// If we still don't have a caliber, or if our caliber doesn't match the thing we're scanning, give up
			return
		else
			new_ammo_type = M.ammo_type

	if(istype(target, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = target

		if(!new_caliber)
			new_caliber = C.caliber	// If caliber isn't set, set it now

		if(new_caliber && new_caliber != C.caliber)	// If we still don't have a caliber, or if our caliber doesn't match the thing we're scanning, give up
			return
		else
			new_ammo_type = C.type

	var/change = FALSE	// If we've changed caliber or ammo_type, display the built message.
	var/msg = "You scan \the [target] with \the [src], copying \the [target]'s "
	if(new_caliber != caliber)	// This should never happen without the ammo_type switching too
		change = TRUE
		msg += "caliber and "
	if(new_ammo_type != ammo_type)
		change = TRUE
		msg += "ammunition type."

	if(change)
		to_chat(user, span_notice("[msg]"))
		caliber = new_caliber
		ammo_type = new_ammo_type
		set_production_cost(ammo_type)	// Update our cost

	return

// Actually makes the bullets
/obj/item/ammo_magazine/smart/proc/produce()
	if(chargereduction())
		var/obj/item/ammo_casing/W = new ammo_type(src)
		stored_ammo.Insert(1, W) //add to the head of the list
		return 1
	return 0


// This verb clears out the smart mag's copied data, but only if it's empty
/obj/item/ammo_magazine/smart/verb/clear_ammo_data()
	set name = "Clear Ammo Data"
	set category = "Object"
	set src in usr

	if(!isliving(src.loc))	// Needs to be in your hands to reset
		return

	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return
	if(H.stat)
		return

	if(LAZYLEN(stored_ammo))
		to_chat(H, span_warning("You can't reset \the [src] unless it's empty!"))
		return

	to_chat(H, span_notice("You clear \the [src]'s data buffers."))

	caliber = null
	ammo_type = null
	production_cost = null

	return
