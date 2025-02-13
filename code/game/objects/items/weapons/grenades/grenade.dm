/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	slot_flags = SLOT_MASK|SLOT_BELT

	var/active = 0
	var/det_time = 50
	var/loadable = TRUE
	var/arm_sound = 'sound/weapons/armbomb.ogg'
	var/hud_state = "grenade_he" // TGMC Ammo HUD Port
	var/hud_state_empty = "grenade_empty" // TGMC Ammo HUD Port

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, span_warning("Huh? How does this thing work?"))

		activate(user)
		add_fingerprint(user)
		addtimer(CALLBACK(src, PROC_REF(detonate)), 5, TIMER_DELETE_ME)
		return 0
	return 1


/*/obj/item/grenade/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (istype(target, /obj/item/storage)) return ..() // Trying to put it in a full container
	if (istype(target, /obj/item/gun/grenadelauncher)) return ..()
	if((user.get_active_hand() == src) && (!active) && (clown_check(user)) && target.loc != src.loc)
		to_chat(user, span_warning("You prime the [name]! [det_time/10] seconds!"))
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(src, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		addtimer(CALLBACK(src, PROC_REF(detonate)), det_time, TIMER_DELETE_ME)
		user.set_dir(get_dir(user, target))
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
	return*/


/obj/item/grenade/examine(mob/user)
	. = ..()
	if(get_dist(user, src) == 0)
		if(det_time > 1)
			. += "The timer is set to [det_time/10] seconds."
		else if(det_time == null)
			. += "\The [src] is set for instant detonation."


/obj/item/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, span_warning("You prime \the [name]! [det_time/10] seconds!"))

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[key_name_admin(user)] primed \a [src.name]")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(src, arm_sound, 75, 1, -3)

	addtimer(CALLBACK(src, PROC_REF(detonate)), det_time, TIMER_DELETE_ME)


/obj/item/grenade/proc/detonate()
//	playsound(src, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)


/obj/item/grenade/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, span_notice("You set the [name] for 1 second detonation time."))
			if (10)
				det_time = 30
				to_chat(user, span_notice("You set the [name] for 3 second detonation time."))
			if (30)
				det_time = 50
				to_chat(user, span_notice("You set the [name] for 5 second detonation time."))
			if (50)
				det_time = 1
				to_chat(user, span_notice("You set the [name] for instant detonation."))
		add_fingerprint(user)
	..()
	return

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/grenade/vendor_action(var/obj/machinery/vending/V)
	activate(V)
