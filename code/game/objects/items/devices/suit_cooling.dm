/obj/item/device/suit_cooling_unit
	name = "portable suit cooling unit"
	desc = "A portable heat sink and liquid cooled radiator that can be hooked up to a space suit's existing temperature controls to provide industrial levels of cooling."
	w_class = ITEMSIZE_LARGE
	icon = 'icons/obj/suit_cooler.dmi'
	icon_state = "suitcooler0"
	item_state = "coolingpack"
	slot_flags = SLOT_BACK

	//copied from tank.dm
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
	action_button_name = "Toggle Heatsink"

	matter = list(MAT_STEEL = 15000, MAT_GLASS = 3500)
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2)

	var/on = 0				//is it turned on?
	var/cover_open = 0		//is the cover open?
	var/obj/item/weapon/cell/cell = /obj/item/weapon/cell/high
	var/max_cooling = 15				// in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 3			// charge per second at max_cooling
	var/thermostat = T20C

	//TODO: make it heat up the surroundings when not in space

/obj/item/device/suit_cooling_unit/ui_action_click()
	toggle(usr)

/obj/item/device/suit_cooling_unit/Initialize()
	. = ..()
	if(ispath(cell))
		cell = new cell(src)

/obj/item/device/suit_cooling_unit/Destroy()
	qdel_null(cell)
	return ..()

/obj/item/device/suit_cooling_unit/process()
	if (!on || !cell)
		return PROCESS_KILL

	if (!ismob(loc))
		return

	if (!attached_to_suit(loc))		//make sure they have a suit and we are attached to it
		return

	var/mob/living/carbon/human/H = loc

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()
	var/efficiency = 1 - H.get_pressure_weakness(environment.return_pressure())	// You need to have a good seal for effective cooling
	var/temp_adj = 0										// How much the unit cools you. Adjusted later on.
	var/env_temp = get_environment_temperature()			// This won't save you from a fire
	var/thermal_protection = H.get_heat_protection(env_temp)	// ... unless you've got a good suit.

	if(thermal_protection < 0.99)		//For some reason, < 1 returns false if the value is 1.
		temp_adj = min(H.bodytemperature - max(thermostat, env_temp), max_cooling)
	else
		temp_adj = min(H.bodytemperature - thermostat, max_cooling)

	if (temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj/max_cooling)*charge_consumption

	H.bodytemperature -= temp_adj*efficiency

	cell.use(charge_usage)

	if(cell.charge <= 0)
		turn_off(1)

/obj/item/device/suit_cooling_unit/proc/get_environment_temperature()
	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(istype(H.loc, /obj/mecha))
			var/obj/mecha/M = H.loc
			return M.return_temperature()
		else if(istype(H.loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/cc = H.loc
			return cc.air_contents.temperature

	var/turf/T = get_turf(src)
	if(istype(T, /turf/space))
		return 0	//space has no temperature, this just makes sure the cooling unit works in space

	var/datum/gas_mixture/environment = T.return_air()
	if (!environment)
		return 0

	return environment.temperature

/obj/item/device/suit_cooling_unit/proc/attached_to_suit(mob/M)
	if (!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M

	if (!H.wear_suit || (H.s_store != src && H.back != src))
		return 0

	return 1

/obj/item/device/suit_cooling_unit/proc/turn_on()
	if(!cell)
		return
	if(cell.charge <= 0)
		return

	on = 1
	START_PROCESSING(SSobj, src)
	updateicon()

/obj/item/device/suit_cooling_unit/proc/turn_off(var/failed)
	if(failed) visible_message("\The [src] clicks and whines as it powers down.")
	on = 0
	STOP_PROCESSING(SSobj, src)
	updateicon()

/obj/item/device/suit_cooling_unit/attack_self(var/mob/user)
	if(cover_open && cell)
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.loc = get_turf(loc)

		cell.add_fingerprint(user)
		cell.update_icon()

		to_chat(user, "You remove \the [src.cell].")
		src.cell = null
		updateicon()
		return

	toggle(user)

/obj/item/device/suit_cooling_unit/proc/toggle(var/mob/user)
	if(on)
		turn_off()
	else
		turn_on()
	to_chat(user, "<span class='notice'>You switch \the [src] [on ? "on" : "off"].</span>")

/obj/item/device/suit_cooling_unit/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (W.is_screwdriver())
		if(cover_open)
			cover_open = 0
			to_chat(user, "You screw the panel into place.")
		else
			cover_open = 1
			to_chat(user, "You unscrew the panel.")
		playsound(src, W.usesound, 50, 1)
		updateicon()
		return

	if (istype(W, /obj/item/weapon/cell))
		if(cover_open)
			if(cell)
				to_chat(user, "There is a [cell] already installed here.")
			else
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "You insert the [cell].")
		updateicon()
		return

	return ..()

/obj/item/device/suit_cooling_unit/proc/updateicon()
	cut_overlays()
	if(cover_open)
		if(cell)
			icon_state = "suitcooler1"
		else
			icon_state = "suitcooler2"
		return

	icon_state = "suitcooler0"

	if(!cell || !on)
		return

	switch(round(cell.percent()))
		if(86 to INFINITY)
			add_overlay("battery-0")
		if(69 to 85)
			add_overlay("battery-1")
		if(52 to 68)
			add_overlay("battery-2")
		if(35 to 51)
			add_overlay("battery-3")
		if(18 to 34)
			add_overlay("battery-4")
		if(-INFINITY to 17)
			add_overlay("battery-5")

/obj/item/device/suit_cooling_unit/examine(mob/user)
	. = ..()

	if(Adjacent(user))

		if (on)
			if (attached_to_suit(src.loc))
				. += "It's switched on and running."
			else
				. += "It's switched on, but not attached to anything."
		else
			. += "It is switched off."

		if (cover_open)
			if(cell)
				. += "The panel is open, exposing the [cell]."
			else
				. += "The panel is open."

		if (cell)
			. += "The charge meter reads [round(cell.percent())]%."
		else
			. += "It doesn't have a power cell installed."

/obj/item/device/suit_cooling_unit/emergency
	icon_state = "esuitcooler"
	cell = /obj/item/weapon/cell
	w_class = ITEMSIZE_NORMAL

/obj/item/device/suit_cooling_unit/emergency/updateicon()
	return

/obj/item/device/suit_cooling_unit/emergency/get_cell()
	if(on)
		return null // Don't let recharging happen while we're on
	return cell

/obj/item/device/suit_cooling_unit/emergency/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (W.is_screwdriver())
		to_chat(user, "<span class='warning'>This cooler's cell is permanently installed!</span>")
		return

	return ..()
