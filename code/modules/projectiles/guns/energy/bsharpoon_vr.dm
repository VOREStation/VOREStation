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
	var/firable = TRUE
	var/transforming = 0
	var/failure_chance = 15 // This can become negative with part tiers above 3, which helps offset penalties
	var/obj/item/weapon/stock_parts/scanning_module/scanmod

/obj/item/weapon/bluespace_harpoon/Initialize()
	. = ..()
	scanmod = new(src)
	update_fail_chance()

/obj/item/weapon/bluespace_harpoon/examine(var/mob/user)
	. = ..()
	if(Adjacent(user))
		. += "It has [scanmod ? scanmod : "no scanner module"] installed."

/obj/item/weapon/bluespace_harpoon/proc/update_fail_chance()
	if(scanmod)
		failure_chance = initial(failure_chance) - (scanmod.rating * 5)
	else
		failure_chance = 75 // You can't even use it if there's no scanmod, but why not.

/obj/item/weapon/bluespace_harpoon/attackby(var/obj/item/I, var/mob/living/user)
	if(!istype(user))
		return

	if(I.is_screwdriver())
		if(!scanmod)
			to_chat(user, "<span class='warning'>There's no scanner module installed!</span>")
			return
		var/turf/T = get_turf(src)
		to_chat(user, "<span class='notice'>You remove [scanmod] from [src].</span>")
		playsound(src, I.usesound, 75, 1)
		scanmod.forceMove(T)
		scanmod = null
		update_fail_chance()
	else if(istype(I, /obj/item/weapon/stock_parts/scanning_module))
		if(scanmod)
			to_chat(user, "<span class='warning'>There's already [scanmod] installed! Remove it first.</span>")
			return
		user.remove_from_mob(I)
		I.forceMove(src)
		scanmod = I
		to_chat(user, "<span class='notice'>You install [scanmod] into [src].</span>")
		update_fail_chance()
	else
		return ..()

/obj/item/weapon/bluespace_harpoon/afterattack(atom/A, mob/user as mob)
	if(!user || !A || isstorage(A))
		return
	if(!scanmod)
		to_chat(user,"<span class = 'warning'>The scanning module has been removed from [src]!</span>")
		return
	if(transforming)
		to_chat(user,"<span class = 'warning'>You can't fire while \the [src] transforming!</span>")
		return
	if(!firable)
		to_chat(user,"<span class = 'warning'>\The [src] is recharging...</span>")
		return
	if(is_jammed(A) || is_jammed(user))
		firable = FALSE
		VARSET_IN(src, firable, TRUE, 30 SECONDS)
		to_chat(user,"<span class = 'warning'>\The [src] shot fizzles due to interference!</span>")
		playsound(src, 'sound/weapons/wave.ogg', 60, 1)
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

	firable = FALSE
	VARSET_IN(src, firable, TRUE, 30 SECONDS)
	playsound(src, 'sound/weapons/wave.ogg', 60, 1)

	user.visible_message("<span class='warning'>[user] fires \the [src]!</span>","<span class='warning'>You fire \the [src]!</span>")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, A)
	s.start()
	s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, user)
	s.start()

	var/turf/FromTurf = mode ? get_turf(user) : get_turf(A)
	var/turf/ToTurf = mode ? get_turf(A) : get_turf(user)

	var/recievefailchance = failure_chance
	var/sendfailchance = failure_chance
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
