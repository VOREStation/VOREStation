/* Morgue stuff
 * Contains:
 *		Morgue
 *		Morgue trays
 *		Creamatorium
 *		Creamatorium trays
 */

/*
 * Morgue
 */

/obj/structure/morgue
	name = "morgue"
	desc = "A refrigerated unit used to store bodies, or for surreptitious naps."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = TRUE
	var/obj/structure/m_tray/connected = null
	var/list/occupants = list()
	anchored = TRUE
	unacidable = TRUE

/obj/structure/morgue/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/morgue/proc/get_occupants()
	occupants.Cut()
	for(var/mob/living/carbon/human/H in contents)
		occupants += H
	for(var/obj/structure/closet/body_bag/B in contents)
		occupants += B.get_occupants()

/obj/structure/morgue/proc/update(var/broadcast=0)
	if (src.connected)
		src.icon_state = "morgue0"
	else
		if (src.contents.len)
			src.icon_state = "morgue2"
			get_occupants()
			for (var/mob/living/carbon/human/H in occupants)
				if(H.isSynthetic() || H.suiciding || !H.ckey || !H.client || (NOCLONE in H.mutations) || (H.species && H.species.flags & NO_SCAN))
					src.icon_state = "morgue2"
					break
				else
					src.icon_state = "morgue3"
					if(broadcast)
						global_announcer.autosay("[src] was able to establish a mental interface with occupant.", "[src]", "Medical")
		else
			src.icon_state = "morgue1"
	return

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/morgue/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/morgue/attack_hand(mob/user as mob)
	if (src.connected)
		close()
	else
		open()
	src.add_fingerprint(user)
	update()
	return


/obj/structure/morgue/proc/close()
	for(var/atom/movable/A as mob|obj in src.connected.loc)
		if (!( A.anchored ))
			A.forceMove(src)
	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	qdel(src.connected)
	src.connected = null


/obj/structure/morgue/proc/open()
	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	src.connected = new /obj/structure/m_tray( src.loc )
	step(src.connected, src.dir)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, src.dir)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "morgue0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "morguet"
		src.connected.set_dir(src.dir)
	else
		qdel(src.connected)
		src.connected = null


/obj/structure/morgue/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		var/t = tgui_input_text(user, "What would you like the label to be?", text("[]", src.name), null)
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, usr) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = text("Morgue- '[]'", t)
		else
			src.name = "Morgue"
	src.add_fingerprint(user)
	return

/obj/structure/morgue/relaymove(mob/user as mob)
	if (user.stat)
		return
	if (user in src.occupants)
		open()

/*
 * Morgue tray
 */
/obj/structure/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "morguet"
	density = TRUE
	plane = TURF_PLANE
	var/obj/structure/morgue/connected = null
	anchored = TRUE
	throwpass = 1

/obj/structure/m_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/m_tray/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/m_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
			//Foreach goto(26)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/m_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, "<span class='warning'>\The [user] stuffs [O] into [src]!</span>")
	return


/*
 * Crematorium
 */

GLOBAL_LIST_BOILERPLATE(all_crematoriums, /obj/structure/morgue/crematorium)

/obj/structure/morgue/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "crema1"
	var/cremating = 0
	var/id = 1
	var/locked = 0

/obj/structure/morgue/crematorium/update()
	if (src.connected)
		src.icon_state = "crema0"
	else
		if (src.contents.len)
			src.icon_state = "crema2"
		else
			src.icon_state = "crema1"
	return

/obj/structure/morgue/crematorium/attack_hand(mob/user as mob)
	if (cremating)
		to_chat(usr, "<span class='warning'>It's locked.</span>")
		return
	if ((src.connected) && (src.locked == 0))
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		//src.connected = null
		qdel(src.connected)
	else if (src.locked == 0)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/m_tray/c_tray( src.loc )
		step(src.connected, dir) //Vorestation Edit
		src.connected.layer = OBJ_LAYER
		var/turf/T = get_step(src, dir) //Vorestation Edit
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "crema0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "cremat"
		else
			//src.connected = null
			qdel(src.connected)
	src.add_fingerprint(user)
	update()

/obj/structure/morgue/crematorium/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		var/t = tgui_input_text(user, "What would you like the label to be?", text("[]", src.name), null)
		if (user.get_active_hand() != P)
			return
		if ((!in_range(src, usr) > 1 && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = text("Crematorium- '[]'", t)
		else
			src.name = "Crematorium"
	src.add_fingerprint(user)
	return

/obj/structure/morgue/crematorium/relaymove(mob/user as mob)
	if (user.stat || locked)
		return
	src.connected = new /obj/structure/m_tray/c_tray( src.loc )
	step(src.connected, EAST)
	src.connected.layer = OBJ_LAYER
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "crema0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "cremat"
	else
		qdel(src.connected)
		src.connected = null
	return

/obj/structure/morgue/crematorium/proc/cremate(atom/A, mob/user as mob)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		for (var/mob/M in viewers(src))
			to_chat(M, "<span class='warning'>You hear a hollow crackle.</span>")
			return

	else
		if(!isemptylist(src.search_contents_for(/obj/item/weapon/disk/nuclear)))
			to_chat(user, "You get the feeling that you shouldn't cremate one of the items in the cremator.")
			return

		for (var/mob/M in viewers(src))
			to_chat(M, "<span class='warning'>You hear a roar as the crematorium activates.</span>")

		cremating = 1
		locked = 1

		for(var/mob/living/M in contents)
			if (M.stat!=2)
				if (!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C = M
					if (C.can_feel_pain())
						C.emote("scream")

			M.death(1)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = 0
		locked = 0
		playsound(src, 'sound/machines/ding.ogg', 50, 1)
	return


/*
 * Crematorium tray
 */
/obj/structure/m_tray/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "cremat"

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	req_access = list(access_crematorium)
	id = 1

/obj/machinery/button/crematorium/attack_hand(mob/user as mob)
	if(..())
		return
	if(src.allowed(user))
		for (var/obj/structure/morgue/crematorium/C in all_crematoriums)
			if (C.id == id)
				if (!C.cremating)
					C.cremate(user)
	else
		to_chat(user, "<span class='warning'>Access denied.</span>")
