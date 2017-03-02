/turf/simulated/floor/outdoors/snow
	name = "snow"
	icon_state = "snow"
	edge_blending_priority = 5
	movement_cost = 2
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks,
		/turf/simulated/floor/outdoors/dirt
		)
	var/list/crossed_dirs = list()

/turf/simulated/floor/outdoors/snow/Entered(atom/A)
	if(isliving(A))
		var/mdir = "[A.dir]"
		crossed_dirs[mdir] = 1
		update_icon()
	. = ..()

/turf/simulated/floor/outdoors/snow/update_icon()
	overlays.Cut()
	..()
	for(var/d in crossed_dirs)
		overlays += image(icon = 'icons/turf/outdoors.dmi', icon_state = "snow_footprints", dir = text2num(d))

/turf/simulated/floor/outdoors/snow/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/shovel))
		to_chat(user, "<span class='notice'>You begin to remove \the [src] with your [W].</span>")
		if(do_after(user, 4 SECONDS))
			to_chat(user, "<span class='notice'>\The [src] has been dug up, and now lies in a pile nearby.</span>")
			new /obj/item/stack/material/snow(src)
			demote()
		else
			to_chat(user, "<span class='notice'>You decide to not finish removing \the [src].</span>")
	else
		..()
