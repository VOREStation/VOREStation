#define ICON_CELL 1
#define ICON_CAP 2
#define ICON_BAD 4
#define ICON_CHARGE 8
#define ICON_READY 16
#define ICON_LOADED 32

/obj/item/gun/magnetic
	name = "improvised coilgun"
	desc = "A coilgun hastily thrown together out of a basic frame and advanced power storage components. Is it safe for it to be duct-taped together like that?"
	icon_state = "coilgun"
	item_state = "coilgun"
	icon = 'icons/obj/railgun.dmi'
//	one_handed_penalty = 15
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_ILLEGAL = 2, TECH_MAGNET = 4)
	w_class = ITEMSIZE_LARGE

	var/obj/item/cell/cell                              // Currently installed powercell.
	var/obj/item/stock_parts/capacitor/capacitor        // Installed capacitor. Higher rating == faster charge between shots. Set to a path to spawn with one of that type.
	var/removable_components = TRUE                            // Whether or not the gun can be dismantled.
	var/gun_unreliable = 15                                    // Percentage chance of detonating in your hands.

	var/obj/item/loaded                                        // Currently loaded object, for retrieval/unloading.
	var/load_type = /obj/item/stack/rods                       // Type of stack to load with.
	projectile_type = /obj/item/projectile/bullet/magnetic 	   // Actual fire type, since this isn't throw_at rod launcher.

	var/power_cost = 950                                       // Cost per fire, should consume almost an entire basic cell.
	var/power_per_tick                                         // Capacitor charge per process(). Updated based on capacitor rating.

	var/state = 0

/obj/item/gun/magnetic/Initialize()
	. = ..()
	// So you can have some spawn with components
	if(ispath(cell))
		cell = new cell(src)
	if(ispath(capacitor))
		capacitor = new capacitor(src)
		capacitor.charge = capacitor.max_charge
	if(ispath(loaded))
		loaded = new loaded(src)

	START_PROCESSING(SSobj, src)

	if(capacitor)
		power_per_tick = (power_cost*0.15) * capacitor.rating

	update_icon()

/obj/item/gun/magnetic/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	QDEL_NULL(loaded)
	QDEL_NULL(capacitor)
	. = ..()

/obj/item/gun/magnetic/get_cell()
	return cell

/obj/item/gun/magnetic/process()
	if(capacitor)
		if(cell)
			if(capacitor.charge < capacitor.max_charge && cell.checked_use(power_per_tick))
				capacitor.charge(power_per_tick)
		else
			capacitor.use(capacitor.charge * 0.05)

	update_state() // May update icon, only if things changed.

/obj/item/gun/magnetic/proc/update_state()
	var/newstate = 0

	// Parts or lack thereof
	if(removable_components)
		if(cell)
			newstate |= ICON_CELL
		if(capacitor)
			newstate |= ICON_CAP

	// Functional state
	if(!cell || !capacitor)
		newstate |= ICON_BAD
	else if(capacitor.charge < power_cost)
		newstate |= ICON_CHARGE
	else
		newstate |= ICON_READY

	// Ammo indicator
	if(loaded)
		newstate |= ICON_LOADED

	// Only update if the state has changed
	var/needs_update = FALSE
	if(state != newstate)
		needs_update = TRUE

	state = newstate

	if(needs_update)
		update_icon()

/obj/item/gun/magnetic/update_icon()
	cut_overlays()
	if(state & ICON_CELL)
		add_overlay("[icon_state]_cell")
	if(state & ICON_CAP)
		add_overlay("[icon_state]_capacitor")
	if(state & ICON_BAD)
		add_overlay("[icon_state]_red")
	if(state & ICON_CHARGE)
		add_overlay("[icon_state]_amber")
	if(state & ICON_READY)
		add_overlay("[icon_state]_green")
	if(state & ICON_LOADED)
		add_overlay("[icon_state]_loaded")

	..()

/obj/item/gun/magnetic/proc/show_ammo()
	var/list/ammotext = list()
	if(loaded)
		ammotext += span_notice("It has \a [loaded] loaded.")

	return ammotext

/obj/item/gun/magnetic/examine(var/mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		. += show_ammo()

		if(cell)
			. += span_notice("The installed [cell.name] has a charge level of [round((cell.charge/cell.maxcharge)*100)]%.")
		if(capacitor)
			. += span_notice("The installed [capacitor.name] has a charge level of [round((capacitor.charge/capacitor.max_charge)*100)]%.")

		if(state & ICON_BAD)
			. += span_notice("The capacitor charge indicator is blinking [span_red("red")]. Maybe you should check the cell or capacitor.")
		else
			if(state & ICON_CHARGE)
				. += span_notice("The capacitor charge indicator is [span_orange("amber")].")
			else
				. += span_notice("The capacitor charge indicator is [span_green("green")].")

/obj/item/gun/magnetic/attackby(var/obj/item/thing, var/mob/user)

	if(removable_components)
		if(istype(thing, /obj/item/cell))
			if(cell)
				to_chat(user, span_warning("\The [src] already has \a [cell] installed."))
				return
			cell = thing
			user.drop_from_inventory(cell, src)
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " slots \the [cell] into \the [src]."))
			update_icon()
			return

		if(thing.has_tool_quality(TOOL_SCREWDRIVER))
			if(!capacitor)
				to_chat(user, span_warning("\The [src] has no capacitor installed."))
				return
			user.put_in_hands(capacitor)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " unscrews \the [capacitor] from \the [src]."))
			playsound(src, thing.usesound, 50, 1)
			capacitor = null
			update_icon()
			return

		if(istype(thing, /obj/item/stock_parts/capacitor))
			if(capacitor)
				to_chat(user, span_warning("\The [src] already has \a [capacitor] installed."))
				return
			capacitor = thing
			user.drop_from_inventory(capacitor, src)
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			power_per_tick = (power_cost*0.15) * capacitor.rating
			user.visible_message(span_infoplain(span_bold("\The [user]") + " slots \the [capacitor] into \the [src]."))
			update_icon()
			return

	if(istype(thing, load_type))

		if(loaded)
			to_chat(user, span_warning("\The [src] already has \a [loaded] loaded."))
			return

		// This is not strictly necessary for the magnetic gun but something using
		// specific ammo types may exist down the track.
		var/obj/item/stack/ammo = thing
		if(!istype(ammo))
			loaded = thing
			user.drop_from_inventory(thing)
			thing.forceMove(src)
		else
			loaded = new load_type(src, 1)
			ammo.use(1)

		user.visible_message(span_infoplain(span_bold("\The [user]") + " loads \the [src] with \the [loaded]."))
		playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return
	. = ..()

/obj/item/gun/magnetic/attack_hand(var/mob/user)
	if(user.get_inactive_hand() == src)
		var/obj/item/removing

		if(loaded)
			removing = loaded
			loaded = null
		else if(cell && removable_components)
			removing = cell
			cell = null

		if(removing)
			removing.forceMove(get_turf(src))
			user.put_in_hands(removing)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " removes \the [removing] from \the [src]."))
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/gun/magnetic/proc/check_ammo()
	return loaded

/obj/item/gun/magnetic/proc/use_ammo()
	qdel(loaded)
	loaded = null

/obj/item/gun/magnetic/consume_next_projectile()

	if(!check_ammo() || !capacitor || capacitor.charge < power_cost)
		return

	use_ammo()
	capacitor.use(power_cost)
	update_icon()

	if(gun_unreliable && prob(gun_unreliable))
		spawn(3) // So that it will still fire - considered modifying Fire() to return a value but burst fire makes that annoying.
			visible_message(span_danger("\The [src] explodes with the force of the shot!"))
			explosion(get_turf(src), -1, 0, 2)
			qdel(src)

	return new projectile_type(src)

/obj/item/gun/magnetic/fuelrod
	name = "Fuel-Rod Cannon"
	desc = "A bulky weapon designed to fire reactor core fuel rods at absurd velocities... who thought this was a good idea?!"
	description_antag = "This device is capable of firing reactor fuel assemblies, acquired from a R-UST fuel compressor and an appropriate fueltype. Be warned, Supermatter rods may have unforseen consequences."
	description_fluff = "Morpheus' second entry into the arms manufacturing field, the Morpheus B.F.G, or 'Big Fuel-rod Gun' made some noise when it was initially sent to the market. By noise, they mean it was rapidly declared 'incredibly dangerous to the wielder and civilians within a mile radius alike'."
	icon_state = "fuelrodgun"
	item_state = "coilgun"
	icon = 'icons/obj/railgun.dmi'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ILLEGAL = 5, TECH_MAGNET = 4)
	w_class = ITEMSIZE_LARGE

	removable_components = TRUE
	gun_unreliable = 0

	load_type = /obj/item/fuel_assembly
	projectile_type = /obj/item/projectile/bullet/magnetic/fuelrod

	power_cost = 500

/obj/item/gun/magnetic/fuelrod/consume_next_projectile()
	if(!check_ammo() || !capacitor || capacitor.charge < power_cost)
		return

	if(loaded) //Safety.
		if(istype(loaded, /obj/item/fuel_assembly))
			var/obj/item/fuel_assembly/rod = loaded
			if(rod.fuel_type == MAT_COMPOSITE || rod.fuel_type == MAT_DEUTERIUM) //Safety check for rods spawned in without a fueltype.
				projectile_type = /obj/item/projectile/bullet/magnetic/fuelrod
			else if(rod.fuel_type == MAT_TRITIUM)
				projectile_type = /obj/item/projectile/bullet/magnetic/fuelrod/tritium
			else if(rod.fuel_type == MAT_PHORON)
				projectile_type = /obj/item/projectile/bullet/magnetic/fuelrod/phoron
			else if(rod.fuel_type == MAT_SUPERMATTER)
				projectile_type = /obj/item/projectile/bullet/magnetic/fuelrod/supermatter
				visible_message(span_danger("The barrel of \the [src] glows a blinding white!"))
				spawn(5)
					visible_message(span_danger("\The [src] begins to rattle, its acceleration chamber collapsing in on itself!"))
					removable_components = FALSE
					spawn(15)
						audible_message(span_critical("\The [src]'s power supply begins to overload as the device crumples!"), runemessage = "VWRRRRRRRR") //Why are you still holding this?
						playsound(src, 'sound/effects/grillehit.ogg', 10, 1)
						var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
						var/turf/T = get_turf(src)
						sparks.set_up(2, 1, T)
						sparks.start()
						spawn(15)
							visible_message(span_critical("\The [src] explodes in a blinding white light!"))
							explosion(src.loc, -1, 1, 2, 3)
							qdel(src)
			else
				projectile_type = /obj/item/projectile/bullet/magnetic/fuelrod

	use_ammo()
	capacitor.use(power_cost)
	update_icon()

	return new projectile_type(src)

/obj/item/gun/magnetic/fuelrod/New()
	cell = new /obj/item/cell/high
	capacitor = new /obj/item/stock_parts/capacitor
	. = ..()

#undef ICON_CELL
#undef ICON_CAP
#undef ICON_BAD
#undef ICON_CHARGE
#undef ICON_READY
#undef ICON_LOADED
