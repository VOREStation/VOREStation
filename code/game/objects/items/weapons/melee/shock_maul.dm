/obj/item/weapon/melee/shock_maul
	name = "concussion maul"
	desc = "A heavy-duty concussion hammer, typically used for mining. An iconic weapon for the many uprisings of Mars. It uses a manually engaged concussive-force amplifier unit in the head to multiply impact force, but its weight and the charge up time makes it difficult to use effectively. Devastating if used correctly, but requires skill."
	icon_state = "forcemaul"
	item_state = "forcemaul"
	slot_flags = SLOT_BACK
	force = 35
	var/unwielded_force_divisor = 0.25
	var/wielded = 0
	var/force_unwielded = 8.75
	var/wieldsound = null
	var/unwieldsound = null
	var/charge_force_mult = 1.75	//damage multiplier on charged hits
	var/launch_force = 3	//yeet distance
	var/launch_force_unwielded = 1	//awful w/ one hand, but still gets a little distance
	var/launch_force_disarm = 1.5	//distance multiplier when swinging in disarm mode, since disarm attacks do half damage
	var/weaken_force = 2	//stun power
	var/weaken_force_unwielded = 0	//can't stun at all if used onehanded
	var/weaken_force_disarm = 1.5	//stun multiplier when in disarm mode
	can_cleave = TRUE	//SSSSMITE!
	attackspeed = 15	//very slow!!
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
	var/obj/item/weapon/cell/bcell = null
	var/hitcost = 600	//you get 4 hits out of a standard cell

/obj/item/weapon/melee/shock_maul/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = initial(force)
		launch_force = initial(launch_force)
		weaken_force = initial(weaken_force)
		name = "[initial(name)] (wielded)"
		update_icon()
	else
		wielded = 0
		force = force_unwielded
		launch_force = launch_force_unwielded
		weaken_force = weaken_force_unwielded
		name = "[initial(name)]"
	update_icon()
	..()

/obj/item/weapon/melee/shock_maul/New()
	..()
	update_held_icon()
	return

/obj/item/weapon/melee/shock_maul/get_cell()
	return bcell

/obj/item/weapon/melee/shock_maul/MouseDrop(obj/over_object as obj)
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

/obj/item/weapon/melee/shock_maul/loaded/New() //this one starts with a cell pre-installed.
	..()
	bcell = new/obj/item/weapon/cell/device/weapon(src)
	update_icon()
	return

/obj/item/weapon/melee/shock_maul/proc/deductcharge(var/chrgdeductamt)
	if(status == 1)		//Only deducts charge when it's on
		if(bcell)
			if(bcell.checked_use(chrgdeductamt))
				return 1
			else
				return 0
	return null

/obj/item/weapon/melee/shock_maul/proc/powercheck(var/chrgdeductamt)
	if(bcell)
		if(bcell.charge < chrgdeductamt)
			status = 0
			update_held_icon()

/obj/item/weapon/melee/shock_maul/update_icon()
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

/obj/item/weapon/melee/shock_maul/dropped()
	..()
	if(status)
		status = 0
		visible_message("<span class='warning'>\The [src]'s grip safety engages!</span>")
	update_held_icon()

/obj/item/weapon/melee/shock_maul/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		if(bcell)
			. += "<span class='notice'>The concussion maul is [round(bcell.percent())]% charged.</span>"
		if(!bcell)
			. += "<span class='warning'>The concussion maul does not have a power source installed.</span>"

/obj/item/weapon/melee/shock_maul/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(istype(W, /obj/item/weapon/cell/device))
			if(!bcell)
				user.drop_item()
				W.loc = src
				bcell = W
				to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
				update_held_icon()
			else
				to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
		else
			to_chat(user, "<span class='notice'>This cell is not fitted for [src].</span>")

/obj/item/weapon/melee/shock_maul/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(bcell)
			bcell.update_icon()
			user.put_in_hands(bcell)
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			status = 0
			update_held_icon()
			return
		..()
	else
		return ..()

/obj/item/weapon/melee/shock_maul/attack_self(mob/user)
	if(!status && bcell && bcell.charge >= hitcost)
		if(do_after(user, 2 SECONDS))
			status = 1
			user.visible_message("<span class='warning'>[user] charges \the [src]!</span>","<span class='warning'>You charge \the [src]. <b>It's hammer time!</b></span>")
			playsound(src, "sparks", 75, 1, -1)
			update_held_icon()
			force *= charge_force_mult
	else if(status)
		status = 0
		user.visible_message("<span class='notice'>[user] safely disengages \the [src]'s power fifeld.</span>","<span class='notice'>\The [src] is now off.</span>")
		update_held_icon()
		playsound(src, "sparks", 75, 1, -1)
		if(!bcell)
			to_chat(user, "<span class='warning'>\The [src] does not have a power source!</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] is out of charge.</span>")
	add_fingerprint(user)

/obj/item/weapon/melee/shock_maul/attack(mob/M, mob/user)
	deductcharge(hitcost)
	return ..()

/obj/item/weapon/melee/shock_maul/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(user.a_intent == I_DISARM)
		launch_force *= launch_force_disarm
		weaken_force *= weaken_force_disarm

	//yeet 'em away, boys!
	if(status)
		var/atom/target_zone = get_edge_target_turf(user,get_dir(user, target))
		target.throw_at(target_zone, launch_force, 2, user, FALSE)
		target.Weaken(weaken_force)

		status = 0
		user.visible_message("<span class='warning'>\The [src] discharges with a thunderous, hair-raising crackle!</span>")
		playsound(src, "sparks", 75, 1, -1)
		update_held_icon()
	powercheck(hitcost)

/obj/item/weapon/melee/shock_maul/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	if(status)
		status = 0
		visible_message("<span class='warning'>\The [src]'s power field hisses and sputters out.</span>")
		update_held_icon()
	..()

/obj/item/weapon/melee/shock_maul/get_description_interaction()
	var/list/results = list()

	if(bcell)
		results += "[desc_panel_image("offhand")]to remove the weapon cell."
	else
		results += "[desc_panel_image("weapon cell")]to add a new weapon cell."

	results += ..()

	return results