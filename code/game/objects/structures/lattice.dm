/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = FALSE
	anchored = TRUE
	w_class = ITEMSIZE_NORMAL
	plane = PLATING_PLANE

/obj/structure/lattice/Initialize(mapload)
	. = ..()

	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/mineral) || istype(src.loc, /turf/simulated/shuttle/plating/airless/carry)))
		return INITIALIZE_HINT_QDEL

	for(var/obj/structure/lattice/LAT in src.loc)
		if(LAT != src)
			log_debug("Found multiple lattices at '[log_info_line(loc)]'") //VOREStation Edit, why was this a runtime, it's harmless
			return INITIALIZE_HINT_QDEL
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "latticeblank"
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays()

/obj/structure/lattice/Destroy()
	for (var/dir in cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays(src.loc)
	if(istype(loc, /turf/simulated/open))
		var/turf/simulated/open/O = loc
		spawn(1)
			if(istype(O)) // If we built a new floor with the lattice, the open turf won't exist anymore.
				O.update() // This lattice may be supporting things on top of it.  If it's being deleted, they need to fall down.
	. = ..()

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
	return

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if(istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(C.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = C.get_welder()
		if(WT.welding == 1)
			if(WT.remove_fuel(0, user))
				to_chat(user, span_notice("Slicing lattice joints ..."))
			new /obj/item/stack/rods(src.loc, 1) //VOREstation Edit: Return the same amount of rods used to build this.
			qdel(src)
		return
	if(istype(C, /obj/item/stack/rods)) //VOREstation Edit: Modernizes upgrading lattices into catwalks.
		upgrade(C, user)
		//VOREstation Edit End
		return
	return

/obj/structure/lattice/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/space)))
	//	qdel(src)
	spawn(1)
		cut_overlays()

		var/dir_sum = 0

		for (var/direction in cardinal)
			if(locate(/obj/structure/lattice, get_step(src, direction)))
				dir_sum += direction
			else
				if(!(istype(get_step(src, direction), /turf/space)))
					dir_sum += direction

		icon_state = "lattice[dir_sum]"
		return

//Vorestation Edit: Moves upgrading lattices to their own proc for other stuff to call. Also makes them instant.
/obj/structure/lattice/proc/upgrade(obj/item/stack/rods/R, mob/user)
	to_chat(user, span_notice("You start connecting \the [R.name] to \the [src.name] ..."))
	R.use(1)
	src.alpha = 0 // Note: I don't know why this is set, Eris did it, just trusting for now. ~Leshana
	new /obj/structure/catwalk(src.loc)
	qdel(src)
