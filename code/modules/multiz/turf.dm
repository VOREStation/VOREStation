/// Multiz support override for CanZPass
/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density && isopenspace(GetAbove(src)) // VOREStation Edit

/// Multiz support override for CanZPass
/turf/simulated/open/CanZPass(atom, direction)
	return 1

/// Multiz support override for CanZPass
/turf/space/CanZPass(atom, direction)
	return 1

/// WARNING WARNING
/// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
/// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
/// We do it because moving signals over was needlessly expensive, and bloated a very commonly used bit of code
/turf/proc/multiz_turf_del(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_DEL, T, dir)

/turf/proc/multiz_turf_new(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, T, dir)

//
// Open Space - "empty" turf that lets stuff fall thru it to the layer below
//

GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)

/atom/movable/openspace_backdrop
	name = "openspace_backdrop"

	anchored = TRUE

	icon = 'icons/turf/floors.dmi'
	icon_state = "grey"
	plane = OPENSPACE_BACKDROP_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_ID

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/floors.dmi'
	icon_state = "invisible"
	desc = "Watch your step!"
	density = FALSE
	plane = OPENSPACE_PLANE
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	dynamic_lighting = 0 // Someday lets do proper lighting z-transfer.  Until then we are leaving this off so it looks nicer.
	can_build_into_floor = TRUE
	can_dirty = FALSE // It's open space
	can_start_dirty = FALSE

/turf/simulated/open/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/open/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/open/LateInitialize()
	..()
	ASSERT(HasBelow(z))
	add_overlay(GLOB.openspace_backdrop_one_for_all, TRUE) //Special grey square for projecting backdrop darkness filter on it.
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/open/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, FALSE)
	update_icon()

/turf/simulated/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall()

/turf/simulated/open/proc/update()
	for(var/atom/movable/A in src)
		A.fall()

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(var/atom/movable/AM, var/speed)
	. = ..()
	AM.fall()

/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(Adjacent(user))
		var/depth = 1
		for(var/T = GetBelow(src); isopenspace(T); T = GetBelow(T))
			depth += 1
		. += "It is about [depth] levels deep."

/turf/simulated/open/update_icon()
	cut_overlays()
	update_icon_edge()

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


/turf/simulated/floor/glass
	name = "glass floor"
	desc = "Dont jump on it, or do, I'm not your mom."
	icon = 'icons/turf/flooring/glass.dmi'
	icon_state = "glass-0"
	base_icon_state = "glass"
	/*
	baseturfs = /turf/simulated/openspace
	intact = FALSE //this means wires go on top
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	*/

// /turf/simulated/floor/glass/setup_broken_states()
//	return list("glass-damaged1", "glass-damaged2", "glass-damaged3")

/turf/simulated/floor/glass/Initialize()
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/floor/glass/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, TRUE)
	blend_icons()

// TG's icon blending method because I don't want to redo all the icon states AAA

//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
/turf/simulated/floor/glass/proc/blend_icons()
	var/new_junction = NONE

	for(var/direction in cardinal) //Cardinal case first.
		var/turf/T = get_step(src, direction)
		if(istype(T, type))
			new_junction |= direction

	if(!(new_junction & (NORTH|SOUTH)) || !(new_junction & (EAST|WEST)))
		icon_state = "[base_icon_state]-[new_junction]"
		return

	if(new_junction & NORTH)
		if(new_junction & WEST)
			var/turf/T = get_step(src, NORTHWEST)
			if(istype(T, type))
				new_junction |= (1<<7)

		if(new_junction & EAST)
			var/turf/T = get_step(src, NORTHEAST)
			if(istype(T, type))
				new_junction |= (1<<4)

	if(new_junction & SOUTH)
		if(new_junction & WEST)
			var/turf/T = get_step(src, SOUTHWEST)
			if(istype(T, type))
				new_junction |= (1<<6)

		if(new_junction & EAST)
			var/turf/T = get_step(src, SOUTHEAST)
			if(istype(T, type))
				new_junction |= (1<<5)

	icon_state = "[base_icon_state]-[new_junction]"

/turf/simulated/floor/glass/reinforced
	name = "reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/flooring/reinf_glass.dmi'
	icon_state = "reinf_glass-0"
	base_icon_state = "reinf_glass"

// /turf/simulated/floor/glass/reinforced/setup_broken_states()
//	return list("reinf_glass-damaged1", "reinf_glass-damaged2", "reinf_glass-damaged3")
