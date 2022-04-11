// -------------- Protector -------------
/obj/item/weapon/gun/energy/gun/protector
	name = "secure small energy gun"
	desc = "The LAEP95 'Protector' is another firearm from Lawson Arms and "+TSC_HEPH+", unlike the Perun this is designed for issue to non-security staff. It contains a detachable cell, and an alert-level-locked lethal mode, only usable on code blue and higher. It also features an integrated flashlight!"

	description_info = "This gun can only be fired in lethal mode while on higher security alert levels. It is legal for sec to carry for this reason, since it cannot be used for lethal force until SOP allows it, in essence."
	description_fluff = "A lighter weapon designed for non-security staff, this gun has a wireless connection to the computer's datacore to ensure it can't be used without authorization from heads of staff who have raised the alert level. Until then, *click*!"
	description_antag = "The gun can be emagged to remove the lethal security level restriction, allowing it to be fired on lethal mode at all times."

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "prot"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	fire_sound = 'sound/weapons/Taser.ogg'
	projectile_type = /obj/item/projectile/beam/stun

	modifystate = "stun"

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)

	charge_sections = 3 //For the icon
	ammo_x_offset = 2
	ammo_y_offset = 0
	can_flashlight = TRUE
	light_state = "prot_light"
	flight_x_offset = 0
	flight_y_offset = 0

	w_class = ITEMSIZE_SMALL

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="stun", charge_cost = 400),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="kill", charge_cost = 800),
		)

	var/emagged = FALSE

/obj/item/weapon/gun/energy/gun/protector/special_check(mob/user)
	if(!emagged && mode_name == "lethal" && get_security_level() == "green")
		to_chat(user,"<span class='warning'>The trigger refuses to depress while on the lethal setting under security level green!</span>")
		return FALSE

	return ..()


/obj/item/weapon/gun/energy/gun/protector/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(!emagged)
		emagged = TRUE
		to_chat(user,"<span class='warning'>You disable the alert level locking mechanism on \the [src]!</span>")

	return TRUE

//Update icons from /tg/, so fancy! Use this more!
/obj/item/weapon/gun/energy/gun/protector/update_icon()
	cut_overlays()
	var/ratio = 0

	/* Don't have one for this gun
	var/itemState = null
	if(!initial(item_state))
		itemState = icon_state
	*/

	var/iconState = "[icon_state]_charge"
	if (modifystate)
		add_overlay("[icon_state]_[modifystate]")
		iconState += "_[modifystate]"
		/* Don't have one for this gun
		if(itemState)
			itemState += "[modifystate]"
		*/
	if(power_supply)
		ratio = CEILING(((power_supply.charge / power_supply.maxcharge) * charge_sections), 1)

		if(power_supply.charge < charge_cost)
			add_overlay("[icon_state]_empty")
		else
			if(!shaded_charge)
				var/mutable_appearance/charge_overlay = mutable_appearance(icon, iconState)
				for(var/i = ratio, i >= 1, i--)
					charge_overlay.pixel_x = ammo_x_offset * (i - 1)
					add_overlay(charge_overlay)
			else
				add_overlay("[icon_state]_[modifystate][ratio]")

	if(can_flashlight & gun_light)
		var/mutable_appearance/flashlight_overlay = mutable_appearance(icon, light_state)
		flashlight_overlay.pixel_x = flight_x_offset
		flashlight_overlay.pixel_y = flight_y_offset
		add_overlay(flashlight_overlay)

	/* Don't have one for this gun
	if(itemState)
		itemState += "[ratio]"
		item_state = itemState
	*/

/obj/item/weapon/gun/energy/gun/protector/unlocked
	emagged = TRUE
	name = "small energy gun"
	desc = "The LAEP95 'Protector' is another firearm from Lawson Arms and "+TSC_HEPH+", unlike the Perun this is designed for issue to non-security staff. It contains a detachable cell. It also features an integrated flashlight!"
