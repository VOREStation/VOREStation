//backpack item
/obj/item/device/personal_shield_generator
	name = "personal shield generator"
	desc = "A personal shield generator."
	icon = 'icons/obj/items_vr.dmi' //Placeholder
	icon_state = "shield_pack" //Placeholder
	item_state = "defibunit" //Placeholder
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_HUGE //It's a giant shield generator!!!
	unacidable = TRUE
	origin_tech = list(TECH_BIO = 4, TECH_POWER = 2) //Set this to better stuff later.
	action_button_name = "Toggle Shield"

	var/obj/item/weapon/gun/energy/gun/generator/active_weapon
	var/obj/item/weapon/cell/device/bcell = null
	var/generator_hit_cost = 100			// Power used when a special effect (such as a bullet being blocked) is performed!
	var/generator_active_cost = 10			// Power used when turned on.
	var/has_weapon = 1
	var/shield_active = 0 					// If the shield gen is active.
	var/energy_modifier = 25				// 40 damage absorbed per 1000 charge. If the charge used is > the cell's remaining charge, the excess is dealt to the user!

/obj/item/device/personal_shield_generator/get_cell()
	return bcell

/obj/item/device/personal_shield_generator/New() //starts without a cell for rnd
	..()
	if(ispath(bcell))
		bcell = new bcell(src)

	if(has_weapon)
		if(ispath(active_weapon))
			active_weapon = new active_weapon(src, src)
			active_weapon.power_supply = bcell
		else
			active_weapon = new(src, src)
			active_weapon.power_supply = bcell
	else
		verbs -= /obj/item/device/personal_shield_generator/verb/weapon_toggle
	update_icon()

/obj/item/device/personal_shield_generator/Destroy()
	. = ..()
	QDEL_NULL(active_weapon)
	QDEL_NULL(bcell)

/obj/item/device/personal_shield_generator/loaded //starts with a cell
	bcell = /obj/item/weapon/cell/device/weapon/recharge


/obj/item/device/personal_shield_generator/update_icon()
	if(shield_active)
		icon_state = "shield_back_active"
	else
		icon_state = "shield_pack"

/obj/item/device/personal_shield_generator/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The installed cell has has a power rating of [bcell.maxcharge] and is [round(bcell.percent() )]% charged ."
		. += "It reads that it can take [bcell.charge/energy_modifier] more damage before the shield goes down."
		if(bcell.self_recharge && bcell.charge_amount)
			. += "This model is self charging and will take [bcell.maxcharge/bcell.charge_amount] seconds to fully charge from empty."


/* //This would be cool, but we need sprites.
	cut_overlays()

	if(has_weapon && active_weapon && active_weapon.loc == src) //in case gun gets destroyed somehow.
		add_overlay("[initial(icon_state)]-paddles")
	if(bcell)
		if(bcell.check_charge(generator_hit_cost)) //Can we take a blow?
			add_overlay("[initial(icon_state)]-powered")
		else if(has_weapon && active_weapon)
			if(bcell.check_charge(active_weapon.charge_cost)) //We got enough to go pew pew?
				add_overlay("[initial(icon_state)]-powered")

		var/ratio = CEILING(bcell.percent()/25, 1) * 25
		add_overlay("[initial(icon_state)]-charge[ratio]")
	else
		add_overlay("[initial(icon_state)]-nocell")
*/

/obj/item/device/personal_shield_generator/ui_action_click()
	toggle_shield()

/obj/item/device/personal_shield_generator/attack_hand(mob/user)
	if(loc == user)
		toggle_shield()
	else
		..()

/obj/item/device/personal_shield_generator/AltClick(mob/living/user)
	weapon_toggle()

/obj/item/device/personal_shield_generator/MouseDrop()
	if(ismob(src.loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = src.loc
		if(!M.unEquip(src))
			return
		src.add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)


/obj/item/device/personal_shield_generator/attackby(obj/item/weapon/W, mob/user, params) //This should never happen unless admin spawns in an empty one.
	if(W == active_weapon)
		reattach_gun(user)
	else if(istype(W, /obj/item/weapon/cell))
		if(bcell)
			to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
		else if(!istype(W, /obj/item/weapon/cell/device/weapon)) //Weapon cells only!
			to_chat(user, "<span class='notice'>This cell will not fit in the device.</span>")
		else
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			bcell = W
			to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
			update_icon()

	else if(W.is_screwdriver())
		if(bcell)
			if(istype(bcell, /obj/item/weapon/cell/device/weapon/recharge)) //No stealing self charging batteries!
				to_chat(user, "<span class='notice'>You can not remove the cell from \the [src] without destroying the unit.</span>")
				return
			else
				bcell.update_icon()
				bcell.forceMove(get_turf(src.loc))
				bcell = null
				to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
				update_icon()
	else
		return ..()

/* //TODO
/obj/item/device/personal_shield_generator/emag_act(var/remaining_charges, var/mob/user)
	if(active_weapon)
		. = active_weapon.emag_act(user)
		update_icon()
	return
*/

//Gun stuff


/obj/item/device/personal_shield_generator/verb/toggle_shield()
	set name = "Toggle Shield"
	set category = "Object"

	var/mob/living/carbon/human/user = usr

	if(user.last_special > world.time)
		return
	user.last_special = world.time + 10 //No spamming!

	if(!bcell || !bcell.check_charge(generator_hit_cost))
		to_chat(user, "<span class='warning'>You require a charged cell to do this!</span>")
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before starting the shield up!</span>")
		return
	else
		if(shield_active)
			shield_active = !shield_active //Deactivate the shield!
			to_chat(user, "<span class='warning'>You deactive the shield!</span>")
			user.remove_modifiers_of_type(/datum/modifier/shield_projection)
			STOP_PROCESSING(SSobj, src)
		else
			shield_active = !shield_active
			to_chat(user, "<span class='warning'>You activate the shield!</span>")
			user.add_modifier(/datum/modifier/shield_projection)
			START_PROCESSING(SSobj, src) //Let's only bother draining power when we're being used!
	update_icon()

/obj/item/device/personal_shield_generator/verb/weapon_toggle() //Make this work on Alt-Click
	set name = "Toggle Gun"
	set category = "Object"

	var/mob/living/carbon/human/user = usr

	if(user.last_special > world.time)
		return
	user.last_special = world.time + 10 //No spamming!
	if(!active_weapon)
		to_chat(user, "<span class='warning'>The gun is missing!</span>")
		return

	if(active_weapon.loc != src)
		reattach_gun(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [active_weapon].</span>")
	else
		if(!usr.put_in_hands(active_weapon)) //Detach the gun into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the gun!</span>")
		update_icon() //success

/obj/item/device/personal_shield_generator/process()
	if(shield_active)
		bcell.use(generator_active_cost)
	if(bcell.charge < generator_hit_cost) //Out of charge...
		shield_active = 0
		if(istype(loc, /mob/living/carbon/human)) //We on someone? Tell them it turned off.
			var/mob/living/carbon/human/user = loc
			to_chat(user, "<span class='warning'>The shield deactivates.!</span>")
			user.remove_modifiers_of_type(/datum/modifier/shield_projection)
			STOP_PROCESSING(SSobj, src)



//checks that the base unit is in the correct slot to be used
/obj/item/device/personal_shield_generator/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == src)
		return 1
	//RIGSuit compatability. This shouldn't be possible, however, except for select RIGs.
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_s_store) == src)
		return 1

	return 0

/obj/item/device/personal_shield_generator/dropped(mob/user)
	..()
	reattach_gun(user) //A gun attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/device/personal_shield_generator/proc/reattach_gun(mob/user)
	if(!active_weapon) return

	if(ismob(active_weapon.loc))
		var/mob/M = active_weapon.loc
		if(M.drop_from_inventory(active_weapon, src))
			to_chat(user, "<span class='notice'>\The [active_weapon] snaps back into the main unit.</span>")
	else
		active_weapon.forceMove(src)

	update_icon()

/*
	Base Unit Subtypes
*/

/obj/item/device/personal_shield_generator/belt
	name = "personal shield generator"
	desc = "A personal shield generator."
	icon_state = "shield_back_active"
	item_state = "shield_pack"
	w_class = ITEMSIZE_LARGE //No putting these in backpacks!
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 5, TECH_POWER = 3)
	has_weapon = 0 //No gun with the belt!

/obj/item/device/personal_shield_generator/belt/loaded
	bcell = /obj/item/weapon/cell/device/weapon/recharge

/obj/item/device/personal_shield_generator/belt/update_icon()
	if(shield_active)
		icon_state = "shield_back_active"
	else
		icon_state = "shield_pack"


//The gun

/obj/item/weapon/gun/energy/gun/generator //The gun attached to the personal shield generator.
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms, the LAEP80 Thor is a versatile energy based pistol, capable of switching between low and high \
	capacity projectile settings. In other words: Stun or Kill."
	description_fluff = "Lawson Arms is Hephaestus Industries’ main personal-energy-weapon branding, often sold alongside MarsTech projectile \
	weapons to security and law enforcement agencies."
	icon_state = "egunstun"
	item_state = null //so the human update icon uses the icon_state instead.
	fire_delay = 8
	use_external_power = TRUE
	cell_type = null //No cell! It runs off the cell in the shield_gen!

	projectile_type = /obj/item/projectile/beam/stun/med
	modifystate = "egunstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="egunstun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="egunkill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 480),
		) //Zero charge_cost since it's handled per shot.

	var/obj/item/device/personal_shield_generator/shield_generator //The generator we are linked to!
	var/wielded = 0
	var/cooldown = 0
	var/busy = 0

/obj/item/weapon/gun/energy/gun/generator/New(newloc, obj/item/device/personal_shield_generator/shield_gen)
	..(newloc)
	shield_generator = shield_gen
	power_supply = shield_generator.bcell

/* //Unused. Use for large guns.
/obj/item/weapon/gun/energy/gun/generator/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		name = "[initial(name)] (wielded)"
	else
		wielded = 0
		name = initial(name)
	update_icon()
	..()
*/

/obj/item/weapon/gun/energy/gun/generator/proc/can_use(mob/user, mob/M)
	if(busy)
		return 0
	if(!check_charge(charge_cost))
		to_chat(user, "<span class='warning'>\The [src] doesn't have enough charge left to do that.</span>")
		return 0
	if(!wielded && !isrobot(user))
		to_chat(user, "<span class='warning'>You need to wield the gun with both hands before you can use it on someone!</span>")
		return 0
	if(cooldown)
		to_chat(user, "<span class='warning'>\The [src] are re-energizing!</span>")
		return 0
	return 1

/* //TODO: Emp act.
/obj/item/weapon/shockpaddles/emp_act(severity)
	var/new_safety = rand(0, 1)
	if(safety != new_safety)
		safety = new_safety
		if(safety)
			make_announcement("beeps, \"Safety protocols enabled!\"", "notice")
			playsound(src, 'sound/machines/defib_safetyon.ogg', 50, 0)
		else
			make_announcement("beeps, \"Safety protocols disabled!\"", "warning")
			playsound(src, 'sound/machines/defib_safetyoff.ogg', 50, 0)
		update_icon()
	..()
*/

/obj/item/weapon/gun/energy/gun/generator/dropped(mob/user)
	..() //update twohanding
	if(shield_generator)
		shield_generator.reattach_gun(user)

/obj/item/weapon/gun/energy/proc/check_charge(var/charge_amt) //In case using any other guns.
	return 0

/obj/item/weapon/gun/energy/proc/checked_use(var/charge_amt) //In case using any other guns.
	return 0

/obj/item/weapon/gun/energy/gun/generator/check_charge(var/charge_amt)
	return (shield_generator.bcell && shield_generator.bcell.check_charge(charge_amt))

/obj/item/weapon/gun/energy/gun/generator/checked_use(var/charge_amt)
	return (shield_generator.bcell && shield_generator.bcell.checked_use(charge_amt))