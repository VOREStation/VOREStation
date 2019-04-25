/obj/structure/portal_subtle
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 0
	anchored = 1
	var/obj/structure/portal/target

/obj/structure/portal/Destroy()
	if(target)
		target.target = null
		target = null
	return ..()

/obj/structure/portal/Bumped(mob/M as mob|obj)
	if(istype(M,/mob) && !(istype(M,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	spawn(0)
		src.teleport(M)
		return
	return

/obj/structure/portal/Crossed(AM as mob|obj)
	if(istype(AM,/mob) && !(istype(AM,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/structure/portal/attack_hand(mob/user as mob)
	if(istype(user) && !(istype(user,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	spawn(0)
		src.teleport(user)
		return
	return

/obj/structure/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			src.icon_state = "portal1"
			do_noeffect_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		else
			do_noeffect_teleport(M, target, 0) ///You will appear adjacent to the beacon
