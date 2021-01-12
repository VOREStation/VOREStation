/obj/structure/portal_subtle
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/failchance = 0
	anchored = 1
	var/obj/structure/portal_subtle/target

/obj/structure/portal_subtle/Destroy()
	if(target)
		target.target = null
		target = null
	return ..()

/obj/structure/portal_subtle/Bumped(mob/M as mob|obj)
	if(istype(M,/mob) && !(istype(M,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	spawn(0)
		src.teleport(M)
		return
	return

/obj/structure/portal_subtle/Crossed(AM as mob|obj)
	if(istype(AM,/mob) && !(istype(AM,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/structure/portal_subtle/attack_hand(mob/user as mob)
	if(istype(user) && !(istype(user,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	spawn(0)
		src.teleport(user)
		return
	return

/obj/structure/portal_subtle/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(target, /obj/structure/portal_subtle))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			src.icon_state = "portal1"
			do_noeffect_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		else
			do_noeffect_teleport(M, target, 0) ///You will appear on the beacon

/obj/structure/portal_gateway
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs_vr.dmi'
	icon_state = "portalgateway"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	anchored = 1

/obj/structure/portal_gateway/Bumped(mob/M as mob|obj)
	if(istype(M,/mob) && !(istype(M,/mob/living)))
		return	//do not send ghosts, zshadows, ai eyes, etc
	var/obj/effect/landmark/dest = pick(eventdestinations)
	if(dest)
		M << 'sound/effects/phasein.ogg'
		playsound(src, 'sound/effects/phasein.ogg', 100, 1)
		M.forceMove(dest.loc)
		if(istype(M, /mob/living) && dest.abductor)
			var/mob/living/L = M
			//Situations to get the mob out of
			if(L.buckled)
				L.buckled.unbuckle_mob()
			if(istype(L.loc,/obj/mecha))
				var/obj/mecha/ME = L.loc
				ME.go_out()
			else if(istype(L.loc,/obj/machinery/sleeper))
				var/obj/machinery/sleeper/SL = L.loc
				SL.go_out()
			else if(istype(L.loc,/obj/machinery/recharge_station))
				var/obj/machinery/recharge_station/RS = L.loc
				RS.go_out()
			if(!issilicon(L)) //Don't drop borg modules...
				var/list/mob_contents = list() //Things which are actually drained as a result of the above not being null.
				mob_contents |= L // The recursive check below does not add the object being checked to its list.
				mob_contents |= recursive_content_check(L, mob_contents, recursion_limit = 3, client_check = 0, sight_check = 0, include_mobs = 1, include_objects = 1, ignore_show_messages = 1)
				for(var/obj/item/weapon/holder/I in mob_contents)
					var/obj/item/weapon/holder/H = I
					var/mob/living/MI = H.held_mob
					MI.forceMove(get_turf(H))
					if(!issilicon(MI)) //Don't drop borg modules...
						for(var/obj/item/II in MI)
							if(istype(II,/obj/item/weapon/implant) || istype(II,/obj/item/device/nif))
								continue
							MI.drop_from_inventory(II, dest.loc)
					var/obj/effect/landmark/finaldest = pick(awayabductors)
					MI.forceMove(finaldest.loc)
					sleep(1)
					MI.Paralyse(10)
					MI << 'sound/effects/bamf.ogg'
					to_chat(MI,"<span class='warning'>You're starting to come to. You feel like you've been out for a few minutes, at least...</span>")
				for(var/obj/item/I in L)
					if(istype(I,/obj/item/weapon/implant) || istype(I,/obj/item/device/nif))
						continue
					L.drop_from_inventory(I, dest.loc)
			var/obj/effect/landmark/finaldest = pick(awayabductors)
			L.forceMove(finaldest.loc)
			sleep(1)
			L.Paralyse(10)
			L << 'sound/effects/bamf.ogg'
			to_chat(L,"<span class='warning'>You're starting to come to. You feel like you've been out for a few minutes, at least...</span>")
	return
