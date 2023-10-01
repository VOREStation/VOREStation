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
	var/dropnoms_active = TRUE

/obj/item/weapon/bluespace_harpoon/Initialize()
	. = ..()
	scanmod = new(src)
	update_fail_chance()

/obj/item/weapon/bluespace_harpoon/examine(var/mob/user)
	. = ..()
	. += "It is currently in [mode ? "transmitting" : "receiving"] mode."
	. += "Spatial rearrangement is [dropnoms_active ? "active" : "inactive"]."
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

	if(I.has_tool_quality(TOOL_SCREWDRIVER))
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
	if(!T || (T.check_density(ignore_mobs = TRUE) && mode == 1))
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

	var/mob/living/living_user = user
	var/can_dropnom = TRUE
	if(!dropnoms_active || !istype(living_user))
		can_dropnom = FALSE

	if(mode)
		if(user in FromTurf)
			if(prob(sendfailchance))
				user.forceMove(pick(trange(24,user)))
			else
				user.forceMove(ToTurf)
				var/vore_happened = FALSE
				if(can_dropnom && living_user.can_be_drop_pred)
					var/obj/belly/belly_dest
					if(living_user.vore_selected)
						belly_dest = living_user.vore_selected
					else if(living_user.vore_organs.len)
						belly_dest = pick(living_user.vore_organs)
					if(belly_dest)
						for(var/mob/living/prey in ToTurf)
							if(prey != user && prey.can_be_drop_prey)
								prey.forceMove(belly_dest)
								vore_happened = TRUE
								to_chat(prey, "<span class='danger'>[living_user] materializes around you, as you end up in their [belly_dest]!</span>")
								to_chat(living_user, "<span class='notice'>You materialize around [prey] as they end up in your [belly_dest]!</span>")
				if(can_dropnom && !vore_happened && living_user.can_be_drop_prey)
					var/mob/living/pred
					for(var/mob/living/potential_pred in ToTurf)
						if(potential_pred != user && potential_pred.can_be_drop_pred)
							pred = potential_pred
					if(pred)
						var/obj/belly/belly_dest
						if(pred.vore_selected)
							belly_dest = pred.vore_selected
						else if(pred.vore_organs.len)
							belly_dest = pick(pred.vore_organs)
						if(belly_dest)
							living_user.forceMove(belly_dest)
							to_chat(pred, "<span class='notice'>[living_user] materializes inside you as they end up in your [belly_dest]!</span>")
							to_chat(living_user, "<span class='danger'>You materialize inside [pred] as you end up in their [belly_dest]!</span>")

	else
		for(var/obj/O in FromTurf)
			if(O.anchored) continue
			if(prob(recievefailchance))
				O.forceMove(pick(trange(24,user)))
			else
				O.forceMove(ToTurf)

		var/user_vored = FALSE

		for(var/mob/living/M in FromTurf)
			if(prob(recievefailchance))
				M.forceMove(pick(trange(24,user)))
			else
				M.forceMove(ToTurf)
				if(can_dropnom && living_user.can_be_drop_pred && M.can_be_drop_prey)
					var/obj/belly/belly_dest
					if(living_user.vore_selected)
						belly_dest = living_user.vore_selected
					else if(living_user.vore_organs.len)
						belly_dest = pick(living_user.vore_organs)
					if(belly_dest)
						M.forceMove(belly_dest)
						to_chat(living_user, "<span class='notice'>[M] materializes inside you as they end up in your [belly_dest]!</span>")
						to_chat(M, "<span class='danger'>You materialize inside [living_user] as you end up in their [belly_dest]!</span>")
				else if(can_dropnom && living_user.can_be_drop_prey && M.can_be_drop_pred && !user_vored)
					var/obj/belly/belly_dest
					if(M.vore_selected)
						belly_dest = M.vore_selected
					else if(M.vore_organs.len)
						belly_dest = pick(M.vore_organs)
					if(belly_dest)
						living_user.forceMove(belly_dest)
						user_vored = TRUE
						to_chat(living_user, "<span class='danger'>[M] materializes around you, as you end up in their [belly_dest]!</span>")
						to_chat(M, "<span class='notice'>You materialize around [living_user] as they end up in your [belly_dest]!</span>")


/obj/item/weapon/bluespace_harpoon/attack_self(mob/living/user as mob)
	return chande_fire_mode(user)

/obj/item/weapon/bluespace_harpoon/verb/chande_fire_mode(mob/user as mob)
	set name = "Change Fire Mode"
	set category = "Object"
	set src in range(0)

	if(transforming) return
	mode = !mode
	transforming = 1
	to_chat(user,"<span class = 'info'>You change \the [src]'s mode to [mode ? "transmiting" : "receiving"].</span>")
	update_icon()

/obj/item/weapon/bluespace_harpoon/verb/chande_dropnom_mode(mob/user as mob)
	set name = "Toggle Spatial Rearrangement"
	set category = "Object"
	set src in range(0)

	dropnoms_active = !dropnoms_active
	to_chat(user,"<span class = 'info'>You switch \the [src]'s spatial rearrangement [dropnoms_active ? "on" : "off"]. (Telenoms [dropnoms_active ? "enabled" : "disabled"])</span>")

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
