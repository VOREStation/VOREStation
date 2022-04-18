/*
CONTAINS:
Deployable items
*/

/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = FALSE
	density = TRUE
	icon_state = "barrier0"
	var/health = 100.0
	var/maxhealth = 100.0
	var/locked = 0.0
//	req_access = list(access_maint_tunnels)

/obj/machinery/deployable/barrier/New()
	..()

	icon_state = "barrier[locked]"

/obj/machinery/deployable/barrier/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/card/id/))
		if(allowed(user))
			if	(emagged < 2.0)
				locked = !locked
				anchored = !anchored
				icon_state = "barrier[locked]"
				if((locked == 1.0) && (emagged < 2.0))
					to_chat(user, "Barrier lock toggled on.")
					return
				else if((locked == 0.0) && (emagged < 2.0))
					to_chat(user, "Barrier lock toggled off.")
					return
			else
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
				return
		return
	else if(W.is_wrench())
		if(health < maxhealth)
			health = maxhealth
			emagged = 0
			req_access = list(access_security)
			visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
			return
		else if(emagged > 0)
			emagged = 0
			req_access = list(access_security)
			visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
			return
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * 0.75
			if("brute")
				health -= W.force * 0.5
		playsound(src, 'sound/weapons/smash.ogg', 50, 1)
		CheckHealth()
		..()

/obj/machinery/deployable/barrier/proc/CheckHealth()
	if(health <= 0)
		explode()
	return

/obj/machinery/deployable/barrier/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	playsound(src, 'sound/weapons/smash.ogg', 50, 1)
	user.do_attack_animation(src)
	health -= damage
	CheckHealth()
	return

/obj/machinery/deployable/barrier/take_damage(var/damage)
	health -= damage
	CheckHealth()
	return

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			health -= 25
			CheckHealth()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[locked]"

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target)//So bullets will fly over and stuff.
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	return FALSE

/obj/machinery/deployable/barrier/proc/explode()

	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

/*	var/obj/item/stack/rods/ =*/
	new /obj/item/stack/rods(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	explosion(src.loc,-1,-1,0)
	if(src)
		qdel(src)

/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if(emagged == 0)
		emagged = 1
		LAZYCLEARLIST(req_access)
		LAZYCLEARLIST(req_one_access)
		to_chat(user, "You break the ID authentication lock on \the [src].")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
	else if(emagged == 1)
		emagged = 2
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1