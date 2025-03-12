//Why is this in here when it's not a subtype of cell_loaded? Because it has a similar function, and I couldn't be assed to find a better suited spot.

/obj/item/gun/projectile/multi_cannon
	name = "Curabitur Cannon"
	desc = "A cannon developed by Curabitur Scimed, this weapon incorporates both Vey-Med and precursor technology to create a medical alternative to chemicals on the field."
	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "healcannon"

	description_info = "Created to fulfill the needs and wants of the Curabitur Scimed personell during rescue operations, the Healcannon is a marvel of reverse-engineering and utilization of unknown technologies. \
	It makes use of the Vey-Med ML-3 'Medigun' microbattery technology, combining the effects of multiple 'microbatteries' into single 'macrobatteries' that are built around precursor void cores, \
	allowing for the batteries to self-charge for prolonged field use. However, the weakened beams caused by the use of ununderstood technology created a need for a VERY strong focus, \
	which lead to the Healcannon becoming a very bulky tool. Fortunately, it's not as heavy as it looks."

	w_class = ITEMSIZE_LARGE
	load_method = SINGLE_CASING
	max_shells = 1
	handle_casings = HOLD_CASINGS
	auto_eject = FALSE
	caliber = "macrobat"
	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "multicannon"
	slot_flags = SLOT_BACK
	recoil = FALSE

/obj/item/gun/projectile/multi_cannon/update_icon()
	. = ..()
	cut_overlays()
	var/istate = "healcannon_0"
	var/indicator_colour = null
	if(istype(chambered,/obj/item/ammo_casing/macrobattery)) //should never not happen. but. you never, never know with this damn, cursed game.
		var/obj/item/ammo_casing/macrobattery/bat = chambered
		indicator_colour = bat.bat_colour
		if(bat.charge)
			istate = "healcannon_20"
			var/percent_charged = round((bat.charge/bat.max_charge)*100)
			switch(percent_charged)
				if(21 to 40)
					istate = "healcannon_40"
				if(41 to 60)
					istate = "healcannon_60"
				if(61 to 80)
					istate = "healcannon_80"
				if(81 to INFINITY)//gotta cover any admemes/other ways to get above max charge here.
					istate = "healcannon_100"
		else
			indicator_colour = null

	var/image/x = image(icon = icon, icon_state = istate)
	x.color = indicator_colour
	add_overlay(x)

/obj/item/gun/projectile/multi_cannon/load_ammo()
	.=..()
	consume_next_projectile()
	update_icon()

/obj/item/gun/projectile/multi_cannon/unload_ammo(mob/user, var/allow_dump=1)
	.=..()
	update_icon()
	chambered = null

/obj/item/gun/projectile/multi_cannon/get_ammo_count() // Custom handling for the Curabitur.
	if(istype(chambered, /obj/item/ammo_casing/macrobattery))
		var/obj/item/ammo_casing/macrobattery/battery = chambered
		if(battery.charge) // Does the battery have charge?
			return battery.charge // This should safely return the amount of shots we have. Every time we fire, we decrement charge by 1, at least in all the cells I can see.
		else // No charge in the battery.
			return 0 // Return 0 ammo to the HUD.
	else if(chambered == null)
		return 0
	else
		CRASH("/obj/item/gun/projectile/multi_cannon/get_ammo_count() was called from [src] but did not have a valid magazine loaded, somehow! Chambered is currently [chambered].")
