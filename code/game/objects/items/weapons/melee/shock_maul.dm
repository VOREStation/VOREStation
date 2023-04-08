/obj/item/weapon/melee/shock_maul
	name = "concussion maul"
	desc = "A heavy-duty concussion hammer, typically used for mining. An iconic weapon for the many uprisings of Mars. It uses a manually engaged concussive-force amplifier unit in the head to multiply impact force, but its weight and the charge up time makes it difficult to use effectively. Devastating if used correctly, but requires skill."
	description_fluff = ""
	icon_state = "sledgehammer"
	item_state = "sledgehammer"
	slot_flags = SLOT_BACK
	force = 35
	var/charge_force_mult = 1.75	//damage multiplier on charged hits
	var/launch_force = 4	//yeet distance
	var/launch_force_disarm = 1.5	//distance multiplier when swinging in disarm mode, since disarm attacks do half damage
	can_cleave = TRUE	//SSSSMITE!
	attackspeed = 14	//very slow!!
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

/obj/item/weapon/melee/shock_maul/New()
	..()
	update_icon()
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
			update_icon()

/obj/item/weapon/melee/shock_maul/update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active"
	else if(!bcell)
		icon_state = "[initial(icon_state)]_nocell"
	else
		icon_state = "[initial(icon_state)]"

	if(icon_state == "[initial(icon_state)]_active")
		set_light(2, 1, lightcolor)
	else
		set_light(0)

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
				to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
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
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/weapon/melee/shock_maul/attack_self(mob/user)
	if(!status && bcell && bcell.charge >= hitcost)
		if(do_after(user, 2 SECONDS))
			status = 1
			to_chat(user, "<span class='notice'>You charge \the [src]. <b>It's hammer time.</b></span>")
			playsound(src, "sparks", 75, 1, -1)
			force *= charge_force_mult
			update_icon()
	else
		status = 0
		to_chat(user, "<span class='notice'>\The [src] is now off.</span>")
		force = initial(force)
		update_icon()
		playsound(src, "sparks", 75, 1, -1)
		if(!bcell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	add_fingerprint(user)

/obj/item/weapon/melee/shock_maul/attack(mob/M, mob/user)
	deductcharge(hitcost)
	return ..()

/obj/item/weapon/melee/shock_maul/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(user.a_intent == I_DISARM)
		launch_force *= launch_force_disarm

	//yeet 'em away, boys!
	if(status)
		var/atom/target_zone = get_edge_target_turf(user,get_dir(user, target))
		target.throw_at(target_zone, launch_force, 2, user, FALSE)
		msg_admin_attack("[key_name(user)] launched [key_name(target)] with \the [src].")

		status = 0
		to_chat(user, "<span class='warning'>\The [src] has discharged!</span>")
		playsound(src, "sparks", 75, 1, -1)
		force = initial(force)
		update_icon()
	powercheck(hitcost)

/obj/item/weapon/melee/shock_maul/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

/obj/item/weapon/melee/shock_maul/get_description_interaction()
	var/list/results = list()

	if(bcell)
		results += "[desc_panel_image("offhand")]to remove the weapon cell."
	else
		results += "[desc_panel_image("weapon cell")]to add a new weapon cell."

	results += ..()

	return results