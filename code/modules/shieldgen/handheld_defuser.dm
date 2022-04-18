/obj/item/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	description_info = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern), in a similar way the floor mounted variant does. It is, however, portable and run by an internal battery. Can be recharged with a regular recharger."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "hdiffuser_off"
<<<<<<< HEAD
	origin_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_ILLEGAL = 2)
	var/obj/item/weapon/cell/device/cell
	var/enabled = 0


/obj/item/weapon/shield_diffuser/Initialize()
=======
	var/obj/item/cell/device/cell
	var/enabled = 0


/obj/item/shield_diffuser/Initialize()
	cell = new(src)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	. = ..()
	cell = new(src)

<<<<<<< HEAD
/obj/item/weapon/shield_diffuser/Destroy()
	QDEL_NULL(cell)
=======
/obj/item/shield_diffuser/Destroy()
	qdel(cell)
	cell = null
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	if(enabled)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/shield_diffuser/get_cell()
	return cell

/obj/item/shield_diffuser/process()
	if(!enabled)
		return PROCESS_KILL

	for(var/direction in cardinal)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/shield/S in shielded_tile)
			// 10kJ per pulse, but gap in the shield lasts for longer than regular diffusers.
			if(istype(S) && !S.diffused_for && !S.disabled_for && cell.checked_use(10 KILOWATTS * CELLRATE))
				S.diffuse(20)
		// Legacy shield support
		for(var/obj/effect/energy_field/S in shielded_tile)
			if(istype(S) && cell.checked_use(10 KILOWATTS * CELLRATE))
				qdel(S)

/obj/item/shield_diffuser/update_icon()
	if(enabled)
		icon_state = "hdiffuser_on"
	else
		icon_state = "hdiffuser_off"

<<<<<<< HEAD
/obj/item/weapon/shield_diffuser/attack_self(mob/user)
=======
/obj/item/shield_diffuser/attack_self()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	enabled = !enabled
	update_icon()
	if(enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	to_chat(user, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/item/shield_diffuser/examine(mob/user)
	. = ..()
	. += "The charge meter reads [cell ? cell.percent() : 0]%"
	. += "It is [enabled ? "enabled" : "disabled"]."
