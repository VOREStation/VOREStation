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
		target.toggle_portal()
		target = null
		set_light(0)

	return ..()

/obj/structure/redgate/proc/teleport(var/mob/M as mob)
	if (!istype(M,/mob/living))		//We only want mob/living, no bullets or mechs or AI eyes or items
		return
	if(!M.ckey)		//We only want players, no bringing the weird stuff on the other side back
		return

	if(!target)
		toggle_portal()

	var/turf/place = get_turf(target)
	var/possible_turfs = place.AdjacentTurfs()
	if(isemptylist(possible_turfs))
		to_chat(M, "<span class='notice'>Something blocks your way.</span>")
		return
	var/turf/temptarg = pick(possible_turfs)
	do_safe_teleport(M, temptarg, 0)

/obj/structure/redgate/proc/toggle_portal()
	if(target)
		icon_state = "on"
		density = TRUE
		plane = ABOVE_MOB_PLANE
		set_light(5, 0.75, "#da5656")
	else
		icon_state = "off"
		density = FALSE
		plane = OBJ_PLANE
		set_light(0)

/obj/structure/redgate/Bumped(mob/M as mob)
	src.teleport(M)
	return

/obj/structure/redgate/Crossed(mob/M as mob)
	src.teleport(M)
	return

/obj/structure/redgate/attack_hand(mob/M as mob)
	if(density)
		src.teleport(M)
	else
		if(!find_partner())
			to_chat(M, "<span class='warning'>The [src] remains off... seems like it doesn't have a destination.</span>")


/obj/structure/redgate/attack_ghost(var/mob/observer/dead/user)
	if(target && user?.client?.holder)
		user.forceMove(get_turf(target))
	else
		return ..()

/obj/structure/redgate/away/Initialize()
	. = ..()
	if(!find_partner())
		log_and_message_admins("An away redgate spawned but wasn't able to find a gateway to link to. If this appeared at roundstart, something has gone wrong, otherwise if you spawn another gate they should connect.")

/obj/structure/redgate/proc/find_partner()
	for(var/obj/structure/redgate/g in world)
		if(istype(g, /obj/structure/redgate))
			if(g.target)
				continue
			else if(g == src)
				continue
			else if(g.z in using_map.station_levels)
				target = g
				g.target = src
				toggle_portal()
				target.toggle_portal()
				break
			else if(g != src)
				target = g
				g.target = src
				toggle_portal()
				target.toggle_portal()
				break
	if(!target)
		return FALSE
	else
		return TRUE

/area/redgate
	name = "redgate"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "redblacir"

/area/redgate/wilds
	name = "wilderness"

/area/redgate/structure
	name = "structure"
	icon_state = "redwhisqu"

/area/redgate/structure/powered
	requires_power = 0

/area/redgate/lit
	dynamic_lighting = 0

/area/redgate/structure/powered/teppi_ranch
	name = "ranch"

/area/redgate/structure/powered/teppi_ranch/barn
	name = "barn"

/obj/item/weapon/paper/teppiranch
	name = "elegantly scrawled note"
	info = {"<i>Goeleigh,<BR><BR>

	This isn't how I wanted to give this message to you. They say that the light is coming this way, and we won't even know it's here until it's upon us. There's no way to know when it will arrive, so we can't really afford to wait around. My family has secured us a ride on a ship, and we'll be going to one of the rimward colonies. They say that they are making strides to build some new kind of gate there, something that will take us far from that light, somewhere safe. We can't really bring the animals, but perhaps you can make some arrangements for them.<BR><BR>

	As soon as you read this, get yourself out of here and come find us. We left you enough money to make the trip in the usual spot. We'll be in the registry once we arrive. We're waiting for you.<BR><BR>

	Yours, Medley</i>"}
