//RD 'gun'
/obj/item/weapon/bluespace_harpoon
	name = "bluespace harpoon"
	desc = "For climbing on bluespace mountains!"

	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "harpoon-2"

	w_class = ITEMSIZE_NORMAL

	throw_speed = 4
	throw_range = 20

	origin_tech = list(TECH_BLUESPACE = 5)

	var/mode = 1  // 1 mode - teleport you to turf  0 mode teleport turf to you
	var/last_fire = 0
	var/transforming = 0

/obj/item/weapon/bluespace_harpoon/afterattack(atom/A, mob/user as mob)
	var/current_fire = world.time
	if(!user || !A)
		return
	if(transforming)
		to_chat(user,"<span class = 'warning'>You can't fire while \the [src] transforming!</span>")
		return
	if(!(current_fire - last_fire >= 30 SECONDS))
		to_chat(user,"<span class = 'warning'>\The [src] is recharging...</span>")
		return
	if(is_jammed(A) || is_jammed(user))
		to_chat(user,"<span class = 'warning'>\The [src] shot fizzles due to interference!</span>")
		last_fire = current_fire
		playsound(user, 'sound/weapons/wave.ogg', 60, 1)
		return
	var/turf/T = get_turf(A)
	if(!T || (T.check_density() && mode == 1))
		to_chat(user,"<span class = 'warning'>That's a little too solid to harpoon into!</span>")
		return
	var/turf/ownturf = get_turf(src)
	if(ownturf.z != T.z || get_dist(T,ownturf) > world.view)
		to_chat(user, "<span class='warning'>The target is out of range!</span>")
		return
	if(get_area(A).flags & BLUE_SHIELDED)
		to_chat(user, "<span class='warning'>The target area protected by bluespace shielding!</span>")
		return
	if(!(A in view(user, world.view)))
		to_chat(user, "<span class='warning'>Harpoon fails to lock on the obstructed target!</span>")
		return

	last_fire = current_fire
	playsound(user, 'sound/weapons/wave.ogg', 60, 1)

	user.visible_message("<span class='warning'>[user] fires \the [src]!</span>","<span class='warning'>You fire \the [src]!</span>")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, A)
	s.start()
	s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, user)
	s.start()

	var/turf/FromTurf = mode ? get_turf(user) : get_turf(A)
	var/turf/ToTurf = mode ? get_turf(A) : get_turf(user)

	var/recievefailchance = 5
	var/sendfailchance = 5
	if(istype(user, /mob/living))
		var/mob/living/L = user
		if(LAZYLEN(L.buckled_mobs))
			for(var/rider in L.buckled_mobs)
				sendfailchance += 15

	if(mode)
		if(user in FromTurf)
			if(prob(sendfailchance))
				user.forceMove(pick(trange(24,user)))
			else
				user.forceMove(ToTurf)
	else
		for(var/obj/O in FromTurf)
			if(O.anchored) continue
			if(prob(recievefailchance))
				O.forceMove(pick(trange(24,user)))
			else
				O.forceMove(ToTurf)

		for(var/mob/living/M in FromTurf)
			if(prob(recievefailchance))
				M.forceMove(pick(trange(24,user)))
			else
				M.forceMove(ToTurf)

/obj/item/weapon/bluespace_harpoon/attack_self(mob/living/user as mob)
	return chande_fire_mode(user)

/obj/item/weapon/bluespace_harpoon/verb/chande_fire_mode(mob/user as mob)
	set name = "Change fire mode"
	set category = "Object"
	set src in oview(1)
	if(transforming) return
	mode = !mode
	transforming = 1
	to_chat(user,"<span class = 'info'>You change \the [src]'s mode to [mode ? "transmiting" : "receiving"].</span>")
	update_icon()

/obj/item/weapon/bluespace_harpoon/update_icon()
	if(transforming)
		switch(mode)
			if(0)
				flick("harpoon-2-change", src)
				icon_state = "harpoon-1"
			if(1)
				flick("harpoon-1-change",src)
				icon_state = "harpoon-2"
		transforming = 0
