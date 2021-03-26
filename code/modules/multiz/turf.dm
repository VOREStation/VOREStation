/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density && isopenspace(GetAbove(src)) // VOREStation Edit

/turf/simulated/open/CanZPass(atom, direction)
	return 1

/turf/space/CanZPass(atom, direction)
	return 1

//
// Open Space - "empty" turf that lets stuff fall thru it to the layer below
//

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	desc = "\..."
	density = 0
	plane = OPENSPACE_PLANE_START
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	dynamic_lighting = 0 // Someday lets do proper lighting z-transfer.  Until then we are leaving this off so it looks nicer.
	can_build_into_floor = TRUE

	var/turf/below

/turf/simulated/open/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/open/post_change()
	..()
	update()

/turf/simulated/open/ChangeTurf(var/turf/N, var/tell_universe, var/force_lighting_update, var/preserve_outdoors)
	var/turf/T = GetBelow(src)
	if(T)
		GLOB.turf_entered_event.unregister(T, src, .proc/BelowOpenUpdated)
		GLOB.turf_exited_event.unregister(T, src, .proc/BelowOpenUpdated)
	. = ..()

/turf/simulated/open/Initialize()
	. = ..()
	ASSERT(HasBelow(z))
	update()
	var/turf/T = GetBelow(src)
	if(T)
		GLOB.turf_entered_event.register(T, src, .proc/BelowOpenUpdated)
		GLOB.turf_exited_event.register(T, src, .proc/BelowOpenUpdated)


/turf/simulated/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall()

/turf/simulated/open/proc/BelowOpenUpdated(turf/T, atom/movable/AM, old_loc)
	if(isobj(AM) && GLOB.open_space_initialised && !AM.invisibility)
		SSopen_space.add_turf(src, 1)

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(var/atom/movable/AM, var/speed)
	. = ..()
	AM.fall()

/turf/simulated/open/proc/update()
	plane = OPENSPACE_PLANE + src.z
	below = GetBelow(src)
	turf_changed_event.register(below, src, /turf/simulated/open/update_icon)
	levelupdate()
	below.update_icon() // So the 'ceiling-less' overlay gets added.
	for(var/atom/movable/A in src)
		A.fall()
	if(GLOB.open_space_initialised)
		SSopen_space.add_turf(src, TRUE)

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(Adjacent(user))
		var/depth = 1
		for(var/T = GetBelow(src); isopenspace(T); T = GetBelow(T))
			depth += 1
		. += "It is about [depth] levels deep."

/**
* Update icon and overlays of open space to be that of the turf below, plus any visible objects on that turf.
*/
/turf/simulated/open/update_icon()
	cut_overlays() // Edit - Overlays are being crashy when modified.
	update_icon_edge()// Add - Get grass into open spaces and whatnot.
	if(below)
		// Skybox lives on its own plane, if we don't set it to see that, then open space tiles over true space tiles see white nothingness below
		if(is_space())
			plane = SPACE_PLANE
		else
			plane = OPENSPACE_PLANE + src.z

		var/below_is_open = isopenspace(below)

		if(below_is_open)
			underlays = below.underlays
		else
			var/image/bottom_turf = image(icon = below.icon, icon_state = below.icon_state, dir=below.dir, layer=below.layer)
			bottom_turf.plane = src.plane
			bottom_turf.color = below.color
			underlays = list(bottom_turf)
		copy_overlays(below)

		// get objects (not mobs, they are handled by /obj/zshadow)
		var/list/o_img = list()
		for(var/obj/O in below)
			if(O.invisibility) continue // Ignore objects that have any form of invisibility
			if(O.loc != below) continue // Ignore multi-turf objects not directly below
			var/image/temp2 = image(O, dir = O.dir, layer = O.layer)
			if(temp2.icon == null)
				temp2.icon_state = null
			temp2.plane = src.plane
			temp2.color = O.color
			temp2.overlays += O.overlays
			// TODO Is pixelx/y needed?
			o_img += temp2
		add_overlay(o_img)

		if(!below_is_open)
			add_overlay(SSopen_space.over_OS_darkness)

		return 0
	return PROCESS_KILL

// Straight copy from space.
/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	//To lay cable.
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return TRUE

/turf/simulated/open/is_space()
	var/turf/below = GetBelow(src)
	return !below || below.is_space()

/turf/simulated/open/is_solid_structure()
	return locate(/obj/structure/lattice, src) //counts as solid structure if it has a lattice (same as space)

/turf/simulated/open/is_safe_to_enter(mob/living/L)
	if(L.can_fall())
		for(var/obj/O in contents)
			if(!O.CanFallThru(L, GetBelow(src)))
				return TRUE // Can't fall through this, like lattice or catwalk.
	return ..()
