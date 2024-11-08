/obj/item/chameleon
	name = "chameleon projector"
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 4, TECH_MAGNET = 4)
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_item = /obj/item/trash/cigbutt
	var/saved_icon = 'icons/inventory/face/item.dmi'
	var/saved_icon_state = "cigbutt"
	var/saved_overlays

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/chameleon/dropped()
	disrupt()
	..()

/obj/item/chameleon/equipped()
	..()
	disrupt()
	..()

/obj/item/chameleon/attack_self(mob/user)
	toggle(user)

/obj/item/chameleon/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(!active_dummy)
		if(istype(target,/obj/item) && !istype(target, /obj/item/disk/nuclear))
			playsound(src, 'sound/weapons/flash.ogg', 100, 1, -6)
			to_chat(user, span_notice("Scanned [target]."))
			saved_item = target.type
			saved_icon = target.icon
			saved_icon_state = target.icon_state
			saved_overlays = target.overlays

/obj/item/chameleon/proc/toggle(mob/user)
	if(!can_use || !saved_item) return
	if(active_dummy)
		eject_all()
		playsound(src, 'sound/effects/pop.ogg', 100, 1, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(user, span_notice("You deactivate the [src]."))
		var/obj/effect/overlay/T = new /obj/effect/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), T), 0.8 SECONDS, TIMER_DELETE_ME)
	else
		playsound(src, 'sound/effects/pop.ogg', 100, 1, -6)
		var/obj/O = new saved_item(src)
		if(!O) return
		if(istype(user.loc, /obj/item/holder)) // This doesn't go well...
			return
		var/obj/effect/dummy/chameleon/C = new /obj/effect/dummy/chameleon(user.loc)
		C.activate(O, user, saved_icon, saved_icon_state, saved_overlays, src)
		qdel(O)
		to_chat(user, span_notice("You activate the [src]."))
		var/obj/effect/overlay/T = new/obj/effect/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), T), 0.8 SECONDS, TIMER_DELETE_ME)

/obj/item/chameleon/proc/disrupt(var/delete_dummy = 1)
	if(active_dummy)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = 0
		addtimer(CALLBACK(src, PROC_REF(allow_use)), 5 SECONDS, TIMER_DELETE_ME)

/obj/item/chameleon/proc/allow_use()
	can_use = 1

/obj/item/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.loc = active_dummy.loc
		if(ismob(A))
			var/mob/M = A
			M.reset_view(null)

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	var/can_move = 1
	var/obj/item/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(var/obj/O, var/mob/M, new_icon, new_iconstate, new_overlays, var/obj/item/chameleon/C)
	name = O.name
	desc = O.desc
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	set_dir(O.dir)
	M.loc = src
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	for(var/mob/M in src)
		to_chat(M, span_warning("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/attack_hand()
	for(var/mob/M in src)
		to_chat(M, span_warning("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act()
	for(var/mob/M in src)
		to_chat(M, span_warning("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/bullet_act()
	for(var/mob/M in src)
		to_chat(M, span_warning("Your chameleon-projector deactivates."))
	..()
	master.disrupt()

/obj/effect/dummy/chameleon/proc/allow_move()
	can_move = 1

/obj/effect/dummy/chameleon/relaymove(var/mob/user, direction)
	if(istype(loc, /turf/space)) return //No magical space movement!

	if(can_move)
		can_move = 0
		switch(user.bodytemperature)
			if(300 to INFINITY)
				addtimer(CALLBACK(src, PROC_REF(allow_move)), 1 SECOND, TIMER_DELETE_ME)
			if(295 to 300)
				addtimer(CALLBACK(src, PROC_REF(allow_move)), 1.3 SECONDS, TIMER_DELETE_ME)
			if(280 to 295)
				addtimer(CALLBACK(src, PROC_REF(allow_move)), 1.6 SECONDS, TIMER_DELETE_ME)
			if(260 to 280)
				addtimer(CALLBACK(src, PROC_REF(allow_move)), 2 SECONDS, TIMER_DELETE_ME)
			else
				addtimer(CALLBACK(src, PROC_REF(allow_move)), 2.5 SECONDS, TIMER_DELETE_ME)
		step(src, direction)
	return

/obj/effect/dummy/chameleon/Destroy()
	master.disrupt(0)
	..()
