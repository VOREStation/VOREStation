/obj/item/gun_new/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(special_handling)
		return FALSE
	switch_firemodes(user)

/obj/item/gun_new/proc/switch_firemodes(mob/user)
	if(firemodes.len <= 1)
		return null

	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode_new/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	to_chat(user, span_notice("\The [src] is now set to [new_mode.name]."))
	user.hud_used.update_ammo_hud(user, src) // TGMC Ammo HUD

	if(new_mode)
		update_icon()
	return new_mode

/obj/item/gun_new/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_sel.selecting == O_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT) //point blank shooting
		if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A && A != user)
			PreFire(A,user) //They're using the new gun system, locate what they're aiming at.
			return
		else
			Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'

/obj/item/gun_new/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/dnalockingchip))
		if(dna_lock)
			to_chat(user, span_notice("\The [src] already has a [attached_lock]."))
			return
		to_chat(user, span_notice("You insert \the [A] into \the [src]."))
		user.drop_item()
		A.loc = src
		attached_lock = A
		dna_lock = 1
		verbs += /obj/item/gun_new/verb/remove_dna
		verbs += /obj/item/gun_new/verb/give_dna
		verbs += /obj/item/gun_new/verb/allow_dna
		return

	if(A.has_tool_quality(TOOL_SCREWDRIVER))
		if(dna_lock && attached_lock && !attached_lock.controller_lock)
			to_chat(user, span_notice("You begin removing \the [attached_lock] from \the [src]."))
			playsound(src, A.usesound, 50, 1)
			if(do_after(user, 25 * A.toolspeed, target = src))
				to_chat(user, span_notice("You remove \the [attached_lock] from \the [src]."))
				user.put_in_hands(attached_lock)
				dna_lock = 0
				attached_lock = null
				verbs -= /obj/item/gun_new/verb/remove_dna
				verbs -= /obj/item/gun_new/verb/give_dna
				verbs -= /obj/item/gun_new/verb/allow_dna
		else
			to_chat(user, span_warning("\The [src] is not accepting modifications at this time."))
	..()

/obj/item/gun_new/emag_act(var/remaining_charges, var/mob/user)
	if(dna_lock && attached_lock.controller_lock)
		to_chat(user, span_notice("You short circuit the internal locking mechanisms of \the [src]!"))
		attached_lock.controller_dna = null
		attached_lock.controller_lock = 0
		attached_lock.stored_dna = list()
		return 1

/obj/item/gun_new/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /atom/movable/screen) ))
			return ..()

		//makes sure that the thing is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /atom/movable/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.u_equip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.u_equip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)
