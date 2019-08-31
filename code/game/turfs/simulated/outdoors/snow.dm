/turf/simulated/floor/outdoors/snow
	name = "snow"
	icon_state = "snow"
	edge_blending_priority = 6
	movement_cost = 2
	initial_flooring = /decl/flooring/snow
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks,
		/turf/simulated/floor/outdoors/dirt
		)
	var/list/crossed_dirs = list()


/turf/simulated/floor/outdoors/snow/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't make footprints.
			return ..()
		var/mdir = "[A.dir]"
		crossed_dirs[mdir] = 1
		update_icon()
	. = ..()

/turf/simulated/floor/outdoors/snow/update_icon()
	..()
	for(var/d in crossed_dirs)
		add_overlay(image(icon = 'icons/turf/outdoors.dmi', icon_state = "snow_footprints", dir = text2num(d)))

/turf/simulated/floor/outdoors/snow/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/shovel))
		to_chat(user, "<span class='notice'>You begin to remove \the [src] with your [W].</span>")
		if(do_after(user, 4 SECONDS * W.toolspeed))
			to_chat(user, "<span class='notice'>\The [src] has been dug up, and now lies in a pile nearby.</span>")
			new /obj/item/stack/material/snow(src)
			demote()
		else
			to_chat(user, "<span class='notice'>You decide to not finish removing \the [src].</span>")
	else
		..()

/turf/simulated/floor/outdoors/snow/attack_hand(mob/user as mob)
	visible_message("[user] starts scooping up some snow.", "You start scooping up some snow.")
	if(do_after(user, 1 SECOND))
		var/obj/S = new /obj/item/stack/material/snow(user.loc)
		user.put_in_hands(S)
		visible_message("[user] scoops up a pile of snow.", "You scoop up a pile of snow.")
	return

/turf/simulated/floor/outdoors/ice
	name = "ice"
	icon_state = "ice"
	desc = "Looks slippery."

/turf/simulated/floor/outdoors/ice/Entered(var/mob/living/M)
	sleep(1 * world.tick_lag)
	if(istype(M, /mob/living))
		if(M.stunned == 0)
			to_chat(M, "<span class='warning'>You slide across the ice!</span>")
		M.SetStunned(1)
		step(M,M.dir)

// Ice that is used for, say, areas floating on water or similar.
/turf/simulated/floor/outdoors/shelfice
	name = "ice"
	icon_state = "ice"
	desc = "Looks slippery."
	movement_cost = 4
