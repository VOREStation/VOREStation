/obj/structure/redgate
	name = "redgate"
	desc = "It leads to someplace else!"
	icon = 'icons/obj/redgate.dmi'
	icon_state = "off"
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	pixel_x = -16

	var/obj/structure/redgate/target

/obj/structure/redgate/Destroy()
	if(target)
		target.target = null
		target = null
		target.icon_state = "off"
		target.density = FALSE

	return ..()

/obj/structure/redgate/proc/teleport(var/mob/M as mob)
	if (!istype(M,/mob/living))		//We only want mob/living, no bullets or mechs or AI eyes or items
		return
	if(!M.ckey)		//We only want players, no bringing the weird stuff on the other side back
		return

	if(!target)
		icon_state = "off"
		density = FALSE

	var/turf/place = get_turf(target)
	var/possible_turfs = place.AdjacentTurfs()
	if(isemptylist(possible_turfs))
		to_chat(M, "<span class='notice'>Something blocks your way.</span>")
		return
	temptarg = pick(possible_turfs)
	do_safe_teleport(M, temptarg, 0)

/obj/structure/redgate/Bumped(mob/M as mob)
	src.teleport(M)
	return

/obj/structure/redgate/Crossed(mob/M as mob)
	src.teleport(M)
	return

/obj/structure/redgate/attack_hand(mob/M as mob)
	src.teleport(M)
	return

/obj/structure/redgate/attack_ghost(var/mob/observer/dead/user)
	if(target && user?.client?.holder)
		user.forceMove(get_turf(target))
	else return

/obj/structure/redgate/away/Initialize()
	. = ..()
	for(var/obj/structure/redgate/g in world)
		if(istype(g, /obj/structure/redgate))
			if(g.target)
				continue
			else if(g.z in using_map.station_levels)
				target = g
				g.target = src
				icon_state = "on"
				g.icon_state = "on"
				density = TRUE
				g.density = TRUE
				break
			else if(g != src)
				target = g
				g.target = src
				icon_state = "on"
				g.icon_state = "on"
				density = TRUE
				g.density = TRUE
				break
	if(!target)
		log_and_message_admins("An away redgate spawned but wasn't able to find a gateway to link to. If this appeared at roundstart, something has gone wrong, otherwise if you spawn another gate they should connect.")
