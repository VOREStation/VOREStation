/obj/item/melee/shock_maul
	name = "concussion maul"
	desc = "A heavy-duty concussion hammer typically used for mining, as it can pulverize and break rocks without damaging denser ores if used correctly. If used incorrectly, there are very few things it cannot smash; this fact made it an iconic weapon for the many uprisings of Mars. It uses a manually engaged concussive-force amplifier unit in the head to multiply impact power, but its weight and the charge up time makes it difficult to use effectively. Devastating if used correctly, but requires skill. It also appears to have a sling attached, so that you can carry it on your back if you need to."
	description_info = "The concussion maul can be manually charged to massively increase its damage, grant a powerful knockback and short stun effect, and allow it to instantly destroy certain obstacles. This takes a moment (and some battery charge upon impact), but is devastating if used correctly. You can also switch to Disarm intent in order increase the inflicted stun duration and knockback distance, at the cost of reducing the damage dealt. You can manually depower the maul to save charge (or for safety purposes), and the maul features a grip safety that will depower it if it is dropped or otherwise unequipped."
	icon_state = "forcemaul"
	item_state = "forcemaul"
	slot_flags = SLOT_BACK

	//stopping power/lethality
	force = 35
	armor_penetration = 20		//the sheer impact force bypasses quite a bit of armour
	var/unwielded_force_divisor = 0.25
	var/wielded = 0
	var/force_unwielded = 8.75
	var/wieldsound = null
	var/unwieldsound = null
	var/charge_time = 2 SECONDS		//how long it takes to charge the hammer
	var/charge_force_mult = 1.75	//damage and AP multiplier on charged hits
	var/launch_force = 3	//yeet distance
	var/launch_force_unwielded = 1	//awful w/ one hand, but still gets a little distance
	var/launch_force_disarm = 1.5	//distance multiplier when swinging in disarm mode, since disarm attacks do half damage
	var/weaken_force = 2	//stun power
	var/weaken_force_unwielded = 0	//can't stun at all if used onehanded
	var/weaken_force_disarm = 1.5	//stun multiplier when in disarm mode

	//mining interacts
	var/excavation_amount = 200
	var/destroy_artefacts = TRUE	//sorry, breaks stuff

	can_cleave = TRUE	//SSSSMITE!
	attackspeed = 12	//very slow!!
	sharp = FALSE
	edge = FALSE
	throwforce = 25
	flags = NOCONDUCT
	w_class = ITEMSIZE_HUGE
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("beaten","slammed","smashed","mauled","hammered","bludgeoned")
	var/lightcolor = "#D3FDFD"
	var/status = 0		//whether the thing is on or not
	var/obj/item/cell/bcell = null
	var/hitcost = 400	//you get 6 hits out of a standard cell

/obj/item/melee/shock_maul/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		if(status)
			force = initial(force)*charge_force_mult
			armor_penetration *= charge_force_mult
		else
			force = initial(force)
			armor_penetration = initial(armor_penetration)
		launch_force = initial(launch_force)
		weaken_force = initial(weaken_force)
		name = "[initial(name)] (wielded)"
		update_icon()
	else
		wielded = 0
		if(status)
			force = force_unwielded*charge_force_mult
			armor_penetration *= charge_force_mult
		else
			force = force_unwielded
			armor_penetration = initial(armor_penetration)
		launch_force = launch_force_unwielded
		weaken_force = weaken_force_unwielded
		name = "[initial(name)]"
	update_icon()
	..()

/obj/item/melee/shock_maul/Initialize(mapload)
	. = ..()
	update_held_icon()

/obj/item/melee/shock_maul/get_cell()
	return bcell

/obj/item/melee/shock_maul/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		//makes sure that the thing is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /obj/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.u_equip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.u_equip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

/obj/item/melee/shock_maul/loaded/Initialize(mapload) //this one starts with a cell pre-installed.
	. = ..()
	bcell = new/obj/item/cell/device/weapon(src)
	update_icon()

/obj/item/melee/shock_maul/proc/deductcharge()
	if(status == 1)		//Only deducts charge when it's on
		if(bcell)
			if(bcell.checked_use(hitcost))
				return 1
			else
				return 0
	return null

/obj/item/melee/shock_maul/proc/powercheck()
	if(bcell)
		if(bcell.charge < hitcost)
			status = 0
			update_held_icon()

/obj/item/melee/shock_maul/update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active[wielded]"
		item_state = icon_state
	else if(!bcell)
		icon_state = "[initial(icon_state)]_nocell[wielded]"
		item_state = icon_state
	else
		icon_state = "[initial(icon_state)][wielded]"
		item_state = icon_state

	if(icon_state == "[initial(icon_state)]_active[wielded]")
		set_light(2, 1, lightcolor)
	else
		set_light(0)

/obj/item/melee/shock_maul/dropped(mob/user)
	..()
	if(status)
		status = 0
		visible_message(span_warning("\The [src]'s grip safety engages!"))
	update_held_icon()

/obj/item/melee/shock_maul/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		if(bcell)
			. += span_notice("The concussion maul is [round(bcell.percent())]% charged.")
		if(!bcell)
			. += span_warning("The concussion maul does not have a power source installed.")

/obj/item/melee/shock_maul/attackby(obj/item/W, mob/user)
	if(!user.IsAdvancedToolUser())
		return
	if(istype(W, /obj/item/cell))
		if(istype(W, /obj/item/cell/device))
			if(!bcell)
				user.drop_item()
				W.loc = src
				bcell = W
				to_chat(user, span_notice("You install a cell in \the [src]."))
				update_held_icon()
			else
				to_chat(user, span_notice("\The [src] already has a cell."))
		else
			to_chat(user, span_notice("This cell is not fitted for [src]."))

/obj/item/melee/shock_maul/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(!user.IsAdvancedToolUser())
			return
		else if(bcell)
			bcell.update_icon()
			user.put_in_hands(bcell)
			bcell = null
			to_chat(user, span_notice("You remove the cell from the [src]."))
			status = 0
			update_held_icon()
			return
		..()
	else
		return ..()

/obj/item/melee/shock_maul/attack_self(mob/user)
	if(!user.IsAdvancedToolUser())
		return
	if(!status && bcell && bcell.charge >= hitcost)
		if(do_after(user, charge_time))
			status = 1
			user.visible_message(span_warning("[user] charges \the [src]!"),span_warning("You charge \the [src]. <b>It's hammer time!</b>"))
			playsound(src, "sparks", 75, 1, -1)
			update_held_icon()
	else if(status)
		status = 0
		user.visible_message(span_notice("[user] safely disengages \the [src]'s power field."),span_notice("\The [src] is now off."))
		update_held_icon()
		playsound(src, "sparks", 75, 1, -1)
		if(!bcell)
			to_chat(user, span_warning("\The [src] does not have a power source!"))
	else
		to_chat(user, span_warning("\The [src] is out of charge."))
	add_fingerprint(user)

/obj/item/melee/shock_maul/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded && status)
		deductcharge()
		status = 0
		user.visible_message(span_warning("\The [src] discharges with a thunderous, hair-raising crackle!"))
		playsound(src, 'sound/weapons/resonator_blast.ogg', 100, 1, -1)
		update_held_icon()
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			visible_message(span_warning("\The [W] crumples under the force of the impact!"))
			W.shatter()
		else if(istype(A,/obj/structure/barricade))
			var/obj/structure/barricade/B = A
			visible_message(span_warning("\The [B] crumples under the force of the impact!"))
			B.dismantle()
		else if(istype(A,/obj/structure/grille))
			visible_message(span_warning("\The [A] crumples under the force of the impact!"))
			qdel(A)
		powercheck(hitcost)

/obj/item/melee/shock_maul/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(user.a_intent == I_DISARM)
		launch_force *= launch_force_disarm
		weaken_force *= weaken_force_disarm

	//yeet 'em away, boys!
	if(status)
		var/atom/target_zone = get_edge_target_turf(user,get_dir(user, target))
		if(!target.anchored)	//unless they're secured in place, natch
			target.throw_at(target_zone, launch_force, 2, user, FALSE)
		target.Weaken(weaken_force)

		deductcharge()
		status = 0
		user.visible_message(span_warning("\The [src] discharges with a thunderous, hair-raising crackle!"))
		playsound(src, 'sound/weapons/resonator_blast.ogg', 100, 1, -1)
		update_held_icon()
	powercheck(hitcost)

/obj/item/melee/shock_maul/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	if(status)
		status = 0
		visible_message(span_warning("\The [src]'s power field hisses and sputters out."))
		update_held_icon()
	..()

/obj/item/melee/shock_maul/get_description_interaction()
	var/list/results = list()

	if(bcell)
		results += "[desc_panel_image("offhand")]to remove the weapon cell."
	else
		results += "[desc_panel_image("weapon cell")]to add a new weapon cell."

	results += ..()

	return results
