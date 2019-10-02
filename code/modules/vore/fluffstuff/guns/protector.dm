// -------------- Protector -------------
/obj/item/weapon/gun/energy/protector
	name = "small energy gun"
	desc = "The KHI-98a 'Protector' is the first firearm custom-designed for Nanotrasen by KHI. It features a powerful stun mode, and \
	an alert-level-locked lethal mode, only usable on code blue and higher. It also features an integrated flashlight!"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)

	description_info = "This gun can only be fired in lethal mode while on higher security alert levels. It is legal for sec to carry for this reason, since it cannot be used for lethal force until SOP allows it, in essence."
	description_fluff = "The first 'commission' from a Kitsuhana citizen for NanoTrasen, this gun has a wireless connection to the computer's datacore to ensure it can't be used without authorization from heads of staff who have raised the alert level. Until then, *click*!"
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

	firemodes = list(
	list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/protector, modifystate="stun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="kill", fire_sound='sound/weapons/gauss_shoot.ogg'),
	)

	var/emagged = FALSE

/obj/item/weapon/gun/energy/protector/special_check(mob/user)
	if(!emagged && mode_name == "lethal" && get_security_level() == "green")
		to_chat(user,"<span class='warning'>The trigger refuses to depress while on the lethal setting under security level green!</span>")
		return FALSE

	return ..()


/obj/item/weapon/gun/energy/protector/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(!emagged)
		emagged = TRUE
		to_chat(user,"<span class='warning'>You disable the alert level locking mechanism on \the [src]!</span>")

	return TRUE

//Update icons from /tg/, so fancy! Use this more!
/obj/item/weapon/gun/energy/protector/update_icon()
	overlays.Cut()
	var/ratio = 0

	/* Don't have one for this gun
	var/itemState = null
	if(!initial(item_state))
		itemState = icon_state
	*/

	var/iconState = "[icon_state]_charge"
	if (modifystate)
		overlays += "[icon_state]_[modifystate]"
		iconState += "_[modifystate]"
		/* Don't have one for this gun
		if(itemState)
			itemState += "[modifystate]"
		*/
	if(power_supply)
		ratio = CEILING(((power_supply.charge / power_supply.maxcharge) * charge_sections), 1)

		if(power_supply.charge < charge_cost)
			overlays += "[icon_state]_empty"
		else
			if(!shaded_charge)
				var/mutable_appearance/charge_overlay = mutable_appearance(icon, iconState)
				for(var/i = ratio, i >= 1, i--)
					charge_overlay.pixel_x = ammo_x_offset * (i - 1)
					overlays += charge_overlay
			else
				overlays += "[icon_state]_[modifystate][ratio]"

	if(can_flashlight & gun_light)
		var/mutable_appearance/flashlight_overlay = mutable_appearance(icon, light_state)
		flashlight_overlay.pixel_x = flight_x_offset
		flashlight_overlay.pixel_y = flight_y_offset
		overlays += flashlight_overlay

	/* Don't have one for this gun
	if(itemState)
		itemState += "[ratio]"
		item_state = itemState
	*/


// Protector beams
/obj/item/projectile/beam/stun/protector
	name = "protector stun beam"
	icon_state = "omnilaser" //A little more cyan
	light_color = "#00C6FF"
	agony = 50 //Normal is 40 when this was set
	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni
