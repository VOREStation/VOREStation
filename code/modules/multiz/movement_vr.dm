
/*/mob/handle_fall(var/turf/landing)
	for(var/mob/M in landing)
		if(M != src && M.CheckFall(src))
			return 1
	for(var/atom/A in landing)
		if(!A.CanPass(src, src.loc, 1, 0))
			return FALSE
	// TODO - Stairs should operate thru a different mechanism, not falling, to allow side-bumping.

	// Now lets move there!
	if(!Move(landing))
		return 1

	// Detect if we made a silent landing.
	if(locate(/obj/structure/stairs) in landing)
		return 1

	if(isopenspace(oldloc))
		oldloc.visible_message("\The [src] falls down through \the [oldloc]!", "You hear something falling through the air.")

	// If the turf has density, we give it first dibs
	if (landing.density && landing.CheckFall(src))
		return

	// First hit objects in the turf!
	for(var/atom/movable/A in landing)
		if(A != src && A.CheckFall(src))
			return

	// If none of them stopped us, then hit the turf itself
	landing.CheckFall(src)
*/
/mob/handle_fall(var/turf/landing)
	var/mob/drop_mob= locate(/mob, loc)
	if(drop_mob)
		lattice.visible_message("<span class='danger'>\The [drop_mob] is dropped onto by \the [src]!</span>")
		drop_mob.fall_impact(src)

	// Then call parent to have us actually fall
	return ..()
/mob/CheckFall(var/atom/movable/falling_atom)
	return falling_atom.fall_impact(src)

/mob/fall_impact(var/atom/hit_atom)
	if(ismob(hit_atom))
		var/mob/M = hit_atom
		M.visible_message("<span class='danger'>\The [src] falls onto \the [M]!</span>")
		M.Weaken(8)

/mob/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return 1