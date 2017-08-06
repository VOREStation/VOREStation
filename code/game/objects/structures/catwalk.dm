// Based on catwalk.dm from https://github.com/Endless-Horizon/CEV-Eris
/obj/structure/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these things."
	density = 0
	anchored = 1.0

/obj/structure/catwalk/initialize()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			warning("Duplicate [type] in [loc] ([x], [y], [z])")
			qdel(C)
	update_icon()

/obj/structure/catwalk/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/catwalk/L in orange(location, 1))
		L.update_icon()

/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in cardinal)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	//NORTHEAST
	if(connectdir & NORTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHEAST)))
			diagonalconnect |= 1
	//SOUTHEAST
	if(connectdir & SOUTH && connectdir & EAST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHEAST)))
			diagonalconnect |= 2
	//NORTHWEST
	if(connectdir & NORTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, NORTHWEST)))
			diagonalconnect |= 4
	//SOUTHWEST
	if(connectdir & SOUTH && connectdir & WEST)
		if(locate(/obj/structure/catwalk, get_step(src, SOUTHWEST)))
			diagonalconnect |= 8

	icon_state = "catwalk[connectdir]-[diagonalconnect]"


/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
	return

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.isOn())
			if(WT.remove_fuel(0, user))
				to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
				new /obj/item/stack/rods(src.loc)
				new /obj/item/stack/rods(src.loc)
				new /obj/structure/lattice(src.loc)
				qdel(src)
	return ..()

/obj/structure/catwalk/Crossed()
	. = ..()
	if(isliving(usr))
		playsound(src, pick('sound/effects/footstep/catwalk1.ogg', 'sound/effects/footstep/catwalk2.ogg', 'sound/effects/footstep/catwalk3.ogg', 'sound/effects/footstep/catwalk4.ogg', 'sound/effects/footstep/catwalk5.ogg'), 25, 1)

/obj/structure/catwalk/CheckExit(atom/movable/O, turf/target)
	if(O.checkpass(PASSGRILLE))
		return 1
	if(target && target.z < src.z)
		return 0
	return 1