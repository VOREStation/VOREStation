/obj/item/device/assembly_holder
	name = "Assembly"
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "holder"
	item_state = "assembly"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 10

	var/secured = 0
	var/obj/item/device/assembly/a_left = null
	var/obj/item/device/assembly/a_right = null
	var/obj/special_assembly = null

/obj/item/device/assembly_holder/proc/attach(var/obj/item/device/assembly/D, var/obj/item/device/assembly/D2, var/mob/user)
	if(!D || !D2)
		return FALSE
	
	if(!istype(D) || !istype(D2))
		return FALSE

	if(D.secured || D2.secured)
		return FALSE
	
	if(user)
		user.remove_from_mob(D)
		user.remove_from_mob(D2)

	D.holder = src
	D2.holder = src
	D.forceMove(src)
	D2.forceMove(src)
	a_left = D
	a_right = D2
	name = "[D.name]-[D2.name] assembly"
	update_icon()
	user.put_in_hands(src)

	return TRUE

/obj/item/device/assembly_holder/proc/detached()
	return

/obj/item/device/assembly_holder/update_icon()
	cut_overlays()
	if(a_left)
		add_overlay("[a_left.icon_state]_left")
		for(var/O in a_left.attached_overlays)
			add_overlay("[O]_l")
	if(a_right)
		add_overlay("[a_right.icon_state]_right")
		for(var/O in a_right.attached_overlays)
			add_overlay("[O]_r")
	if(master)
		master.update_icon()

/obj/item/device/assembly_holder/examine(mob/user)
	. = ..()
	if ((in_range(src, user) || src.loc == user))
		if (src.secured)
			. += "\The [src] is ready!"
		else
			. += "\The [src] can be attached!"

/obj/item/device/assembly_holder/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(isturf(old_loc))
		unsense_proximity(callback = .HasProximity, center = old_loc)
	if(isturf(loc))
		sense_proximity(callback = .HasProximity)

/obj/item/device/assembly_holder/HasProximity(turf/T, atom/movable/AM, old_loc)
	if(a_left)
		a_left.HasProximity(T, AM, old_loc)
	if(a_right)
		a_right.HasProximity(T, AM, old_loc)

/obj/item/device/assembly_holder/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(a_left)
		a_left.Crossed(AM)
	if(a_right)
		a_right.Crossed(AM)

/obj/item/device/assembly_holder/on_found(mob/finder as mob)
	if(a_left)
		a_left.on_found(finder)
	if(a_right)
		a_right.on_found(finder)

/obj/item/device/assembly_holder/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()

/obj/item/device/assembly_holder/attack_hand()//Perhapse this should be a holder_pickup proc instead, can add if needbe I guess
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()
	..()

/obj/item/device/assembly_holder/attackby(var/obj/item/weapon/W, var/mob/user)
	if(W.is_screwdriver())
		if(!a_left || !a_right)
			to_chat(user, "<span class='warning'> BUG:Assembly part missing, please report this!</span>")
			return
		a_left.toggle_secure()
		a_right.toggle_secure()
		secured = !secured
		if(secured)
			to_chat(user, "<span class='notice'>\The [src] is ready!</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] can now be taken apart!</span>")
		update_icon()
		return
	else
		..()

/obj/item/device/assembly_holder/attack_self(var/mob/user)
	src.add_fingerprint(user)
	if(src.secured)
		if(!a_left || !a_right)
			to_chat(user, "<span class='warning'> BUG:Assembly part missing, please report this!</span>")
			return
		if(istype(a_left,a_right.type))//If they are the same type it causes issues due to window code
			switch(alert("Which side would you like to use?",,"Left","Right"))
				if("Left")	a_left.attack_self(user)
				if("Right")	a_right.attack_self(user)
			return
		else
			if(!istype(a_left,/obj/item/device/assembly/igniter))
				a_left.attack_self(user)
			if(!istype(a_right,/obj/item/device/assembly/igniter))
				a_right.attack_self(user)
	else
		var/turf/T = get_turf(src)
		if(!T)
			return 0
		if(a_left)
			a_left.holder = null
			a_left.forceMove(T)
		if(a_right)
			a_right.holder = null
			a_right.forceMove(T)
		qdel(src)

/obj/item/device/assembly_holder/proc/process_activation(var/obj/D, var/normal = 1)
	if(!D)
		return 0
	if(!secured)
		visible_message("[bicon(src)] *beep* *beep*", "*beep* *beep*")
	if((normal) && (a_right) && (a_left))
		if(a_right != D)
			a_right.pulsed(0)
		if(a_left != D)
			a_left.pulsed(0)
	if(master)
		master.receive_signal()
	return 1

/obj/item/device/assembly_holder/hear_talk(mob/M, list/message_pieces, verb)
	if(a_right)
		a_right.hear_talk(M, message_pieces, verb)
	if(a_left)
		a_left.hear_talk(M, message_pieces, verb)

/obj/item/device/assembly_holder/timer_igniter
	name = "timer-igniter assembly"

/obj/item/device/assembly_holder/timer_igniter/New()
	..()

	var/obj/item/device/assembly/igniter/ign = new(src)
	ign.secured = 1
	ign.holder = src

	var/obj/item/device/assembly/timer/tmr = new(src)
	tmr.time = 5
	tmr.secured = 1
	tmr.holder = src

	a_left = tmr
	a_right = ign
	secured = 1
	update_icon()
	name = initial(name) + " ([tmr.time] secs)"

	loc.verbs += /obj/item/device/assembly_holder/timer_igniter/verb/configure

/obj/item/device/assembly_holder/timer_igniter/detached()
	loc.verbs -= /obj/item/device/assembly_holder/timer_igniter/verb/configure
	..()

/obj/item/device/assembly_holder/timer_igniter/verb/configure()
	set name = "Set Timer"
	set category = "Object"
	set src in usr

	if ( !(usr.stat || usr.restrained()) )
		var/obj/item/device/assembly_holder/holder
		if(istype(src,/obj/item/weapon/grenade/chem_grenade))
			var/obj/item/weapon/grenade/chem_grenade/gren = src
			holder=gren.detonator
		var/obj/item/device/assembly/timer/tmr = holder.a_left
		if(!istype(tmr,/obj/item/device/assembly/timer))
			tmr = holder.a_right
		if(!istype(tmr,/obj/item/device/assembly/timer))
			to_chat(usr, "<span class='notice'>This detonator has no timer.</span>")
			return

		if(tmr.timing)
			to_chat(usr, "<span class='notice'>Clock is ticking already.</span>")
		else
			var/ntime = input("Enter desired time in seconds", "Time", "5") as num
			if (ntime>0 && ntime<1000)
				tmr.time = ntime
				name = initial(name) + "([tmr.time] secs)"
				to_chat(usr, "<span class='notice'>Timer set to [tmr.time] seconds.</span>")
			else
				to_chat(usr, "<span class='notice'>Timer can't be [ntime<=0?"negative":"more than 1000 seconds"].</span>")
	else
		to_chat(usr, "<span class='notice'>You cannot do this while [usr.stat?"unconscious/dead":"restrained"].</span>")
