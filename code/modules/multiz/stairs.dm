#define STAIR_MOVE_DELAY 10 // Animation delay for non-living objects moving up/down stairs

/obj/structure/stairs
	name = "Stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/structures/multiz.dmi'
	icon_state = "stair"
	opacity = 0
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	layer = STAIRS_LAYER

/obj/structure/stairs/Initialize()
	. = ..()
	if(check_integrity())
		update_icon()

// Returns TRUE if the stairs are a complete and connected unit, FALSE if a piece is missing or obstructed
// Will attempt to reconnect broken pieces
// Parameters:
//  - B1: Loc of bottom stair
//  - B2: Loc of middle stair
//  - T1: Openspace over bottom stair
//  - T2: Loc of top stair, over middle stair
/obj/structure/stairs/proc/check_integrity(var/obj/structure/stairs/bottom/B = null,
										   var/obj/structure/stairs/middle/M = null,
										   var/obj/structure/stairs/top/T = null,
										   var/turf/simulated/open/O = null)

	// Base cases: Something is missing!
	// The parent type doesn't know enough about the positional relations to find neighbors, only evaluate if they're connected
	if(!istype(B) || !istype(M) || !istype(T) || !istype(O))
		return FALSE

	// Case 1: In working order
	if(B.top == T && M.bottom == B && T.bottom == B && \
			get_turf(M) == get_step(B, B.dir) && O == GetAbove(B) && get_turf(T) == GetAbove(M))
		return TRUE

	// Case 2: The top is linked to someone else
	if(istype(T.bottom) && T.bottom != B)
		return FALSE

	// Case 3: The bottom is linked to someone else
	if(istype(B.top) && B.top != T)
		return FALSE

	// Case 4: They're unlinked
	B.dir = get_dir(get_turf(B), get_turf(M))
	B.top = T
	B.middle = M
	T.dir	 = B.dir
	T.middle = M
	T.bottom = B
	M.dir	 = B.dir
	M.top	 = T
	M.bottom = B
	return TRUE

// Used to actually move stuff up/down stairs. Removed from Crossed for special cases
/obj/structure/stairs/proc/use_stairs(var/atom/movable/AM, var/atom/oldloc)
	return

/obj/structure/stairs/proc/use_stairs_instant(var/atom/movable/AM)
	return

//////////////////////////////////////////////////////////////////////
// Bottom piece that you step ontor //////////////////////////////////
//////////////////////////////////////////////////////////////////////
/obj/structure/stairs/bottom
	icon_state = "stair_l"
	var/obj/structure/stairs/top/top = null
	var/obj/structure/stairs/middle/middle = null

/obj/structure/stairs/bottom/Initialize()
	. = ..()
	if(!GetAbove(src))
		warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

/obj/structure/stairs/bottom/Destroy()
	if(top)
		top.bottom = null
	if(middle)
		middle.bottom = null
	..()

// These are necessarily fairly similar, but because the positional relations are different, we have to copy-pasta a fair bit
/obj/structure/stairs/bottom/check_integrity(var/obj/structure/stairs/bottom/B = null,
											 var/obj/structure/stairs/middle/M = null,
											 var/obj/structure/stairs/top/T = null,
											 var/turf/simulated/open/O = null)

	// In the case where we're provided all the pieces, just try connecting them.
	// In order: all exist, they are appropriately adjacent, and they can connect
	if(istype(B) && istype(M) && istype(T) && istype(O) && \
			B.Adjacent(M) && (GetBelow(O) == get_turf(B)) && T.Adjacent(O) && \
			..())
		return TRUE

	// If we're already configured, just check those
	else if(istype(top) && istype(middle))
		O = locate(/turf/simulated/open) in GetAbove(src)
		if(..(src, middle, top, O))
			return TRUE

	var/turf/B2 = get_step(src, src.dir)
	O = GetAbove(src)
	var/turf/T2 = GetAbove(B2)

	// T1 is the same regardless of B1's dir, so we can enforce it here
	if(!istype(O))
		return FALSE

	T = locate(/obj/structure/stairs/top)    in T2
	M = locate(/obj/structure/stairs/middle) in B2

	// If you set the dir, that's the dir it *wants* to connect in. It only chooses the others if that doesn't work
	// Everything is simply linked in our original direction
	if(istype(M) && istype(T) && ..(src, M, T, O))
		return TRUE

	// Else, we have to look in other directions
	for(var/dir in cardinal - src.dir)
		B2 = get_step(src, dir)
		T2 = GetAbove(B2)
		if(!istype(B2) || !istype(T2))
			continue

		T = locate(/obj/structure/stairs/top)    in T2
		M = locate(/obj/structure/stairs/middle) in B2
		if(..(src, M, T, O))
			return TRUE

	// Out of the dir check, we have no valid neighbors, and thus are not complete.
	return FALSE

/obj/structure/stairs/bottom/Crossed(var/atom/movable/AM, var/atom/oldloc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.has_AI())
			use_stairs(AM, oldloc)
	..()

/obj/structure/stairs/bottom/use_stairs(var/atom/movable/AM, var/atom/oldloc)
	// If we're coming from the top of the stairs, don't trap us in an infinite staircase
	// Or if we fell down the openspace
	if((top in oldloc) || oldloc == GetAbove(src))
		return
	//VOREStation Addition Start
	if(istype(AM, /obj/effect/plant))
		return
	//VOREStation Addition End
	if(isobserver(AM)) // Ghosts have their own methods for going up and down
		return
	if(AM.pulledby) // Animating the movement of pulled things is handled when the puller goes up the stairs
		return

	if(AM.has_buckled_mobs()) // Similarly, the rider entering the turf will bring along whatever they're buckled to
		return

	var/list/atom/movable/pulling = list() // Will also include grabbed mobs
	if(isliving(AM))
		var/mob/living/L = AM

		if(L.grabbed_by.len) // Same as pulledby, whoever's holding you will keep you from going down stairs.
			return

		if(L.buckled)
			pulling |= L.buckled

		// If the object is pulling or grabbing anything, we'll want to move those too. A grab chain may be disrupted in doing so.
		if(L.pulling && !L.pulling.anchored)
			pulling |= L.pulling
		for(var/obj/item/weapon/grab/G in list(L.l_hand, L.r_hand))
			pulling |= G.affecting

	// If the stairs aren't broken, go up.
	if(check_integrity())
		AM.dir = src.dir

		// Bring the pulled/grabbed object(s) along behind us
		for(var/atom/movable/P in pulling)
			P.forceMove(get_turf(src)) // They will move onto the turf but won't get past the check earlier in crossed. Aligns animation more cleanly


		// Move to Top
		AM.forceMove(get_turf(top))

		// If something is being pulled, bring it along directly to avoid the mob being torn away from it due to movement delays
		for(var/atom/movable/P in pulling)
			P.forceMove(get_turf(top)) // Just bring it along directly, no fussing with animation timing
			if(isliving(P))
				var/mob/living/L = P
				if(L.client)
					L.client.Process_Grab() // Update any miscellanous grabs, possibly break grab-chains

	return TRUE

/obj/structure/stairs/bottom/use_stairs_instant(var/atom/movable/AM)
	if(isobserver(AM)) // Ghosts have their own methods for going up and down
		return
	//VOREStation Addition Start
	if(istype(AM, /obj/effect/plant))
		return
	//VOREStation Addition End
	if(isliving(AM))
		var/mob/living/L = AM

		if(L.grabbed_by.len) // Same as pulledby, whoever's holding you will keep you from going down stairs.
			return

		if(L.buckled)
			L.buckled.forceMove(get_turf(top))

		L.forceMove(get_turf(top))

		// If the object is pulling or grabbing anything, we'll want to move those too. A grab chain may be disrupted in doing so.
		if(L.pulling && !L.pulling.anchored)
			var/atom/movable/P = L.pulling
			P.forceMove(get_turf(top))
			L.start_pulling(P)

		for(var/obj/item/weapon/grab/G in list(L.l_hand, L.r_hand))
			G.affecting.forceMove(get_turf(top))

		if(L.client)
			L.client.Process_Grab()
	else
		AM.forceMove(get_turf(top))


//////////////////////////////////////////////////////////////////////
// Middle piece that you are animated onto/off of ////////////////////
//////////////////////////////////////////////////////////////////////
/obj/structure/stairs/middle
	icon_state = "stair_u"
	opacity   = TRUE
	density   = TRUE // Too high to simply step up on
	climbable = TRUE // But they can be climbed if the bottom is out

	var/obj/structure/stairs/top/top = null
	var/obj/structure/stairs/bottom/bottom = null

/obj/structure/stairs/middle/Initialize()
	. = ..()
	if(!GetAbove(src))
		warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

/obj/structure/stairs/middle/Destroy()
	if(top)
		top.middle = null
	if(bottom)
		bottom.middle = null
	..()

// These are necessarily fairly similar, but because the positional relations are different, we have to copy-pasta a fair bit
/obj/structure/stairs/middle/check_integrity(var/obj/structure/stairs/bottom/B = null,
											 var/obj/structure/stairs/middle/M = null,
											 var/obj/structure/stairs/top/T = null,
											 var/turf/simulated/open/O = null)

	// In the  case where we're provided all the pieces, just try connecting them.
	// In order: all exist, they are appropriately adjacent, and they can connect
	if(istype(B) && istype(M) && istype(T) && istype(O) && \
			B.Adjacent(M) && (GetBelow(O) == B.loc) && T.Adjacent(O) && \
			..())
		return TRUE

	else if(istype(top) && istype(bottom))
		O = locate(/turf/simulated/open) in GetAbove(bottom)
		if(..(bottom, src, top, O))
			return TRUE

	var/turf/B1 = get_step(src, turn(src.dir, 180))
	O = GetAbove(B1)
	var/turf/T2 = GetAbove(src)

	B = locate(/obj/structure/stairs/bottom) in B1
	T = locate(/obj/structure/stairs/top)    in T2

	// Top is static for Middle stair, if it's invalid we can't do much
	if(!istype(T))
		return FALSE

	// If you set the dir, that's the dir it *wants* to connect in. It only chooses the others if that doesn't work
	// Everything is simply linked in our original direction
	if(istype(B1) && istype(T2) && istype(O) && ..(B, src, T, O))
		return TRUE

	// Else, we have to look in other directions
	for(var/dir in cardinal - src.dir)
		B1 = get_step(src, turn(dir, 180))
		O = GetAbove(B1)
		if(!istype(B1) || !istype(O))
			continue

		B = locate(/obj/structure/stairs/bottom) in B1
		if(..(B, src, T, O))
			return TRUE

	// The middle stair has some further special logic, in that it can be climbed, and so is technically valid if only the top exists
	// T is enforced by a prior if
	T.middle = src
	src.top = T
	src.dir = T.dir
	return TRUE

/obj/structure/stairs/middle/MouseDrop_T(mob/target, mob/user)
	. = ..()
	if(check_integrity())
		do_climb(user)
		user.forceMove(get_turf(top)) // You can't really drag things when you have to climb up the gap in the stairs yourself

/obj/structure/stairs/middle/Bumped(mob/user)
	if(check_integrity() && bottom && (bottom in get_turf(user))) // Bottom must be enforced because the middle stairs don't actually need the bottom
		bottom.use_stairs_instant(user)

//////////////////////////////////////////////////////////////////////
// Top piece that you step onto //////////////////////////////////////
//////////////////////////////////////////////////////////////////////
/obj/structure/stairs/top
	icon_state = "stair_l" // Darker, marginally less contrast w/ openspace
	var/obj/structure/stairs/middle/middle = null
	var/obj/structure/stairs/bottom/bottom = null

/obj/structure/stairs/top/Initialize()
	. = ..()
	if(!GetBelow(src))
		warning("Stair created without level below: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

/obj/structure/stairs/top/Destroy()
	if(middle)
		middle.top = null
	if(bottom)
		bottom.top = null
	..()

// These are necessarily fairly similar, but because the positional relations are different, we have to copy-pasta a fair bit
/obj/structure/stairs/top/check_integrity(var/obj/structure/stairs/bottom/B = null,
										  var/obj/structure/stairs/middle/M = null,
										  var/obj/structure/stairs/top/T = null,
										  var/turf/simulated/open/O = null)

	// In the  case where we're provided all the pieces, just try connecting them.
	// In order: all exist, they are appropriately adjacent, and they can connect
	if(istype(B) && istype(M) && istype(T) && istype(O) && \
			B.Adjacent(M) && (GetBelow(O) == B.loc) && T.Adjacent(O) && \
			(. = ..()))
		return

	else if(istype(middle) && istype(bottom))
		O = locate(/turf/simulated/open) in GetAbove(bottom)
		if(..(bottom, middle, src, O))
			return TRUE


	O = get_step(src, turn(src.dir, 180))
	var/turf/B1 = GetBelow(O)
	var/turf/B2 = GetBelow(src)

	B = locate(/obj/structure/stairs/bottom) in B1
	M = locate(/obj/structure/stairs/middle) in B2

	// Middle stair is static for Top stair, so if it's invalid we can't do much
	if(!istype(M))
		return FALSE

	// If you set the dir, that's the dir it *wants* to connect in. It only chooses the others if that doesn't work
	// Everything is simply linked in our original direction
	if(istype(B) && istype(O) && (. = ..(B, M, src, O)))
		return

	// Else, we have to look in other directions
	for(var/dir in cardinal - src.dir)
		O = get_step(src, turn(dir, 180))
		B1 = GetBelow(O)
		if(!istype(B1) || !istype(O))
			continue

		B = locate(/obj/structure/stairs/bottom) in B1
		if((. = ..(B, M, src, O)))
			return

	// Out of the dir check, we have no valid neighbors, and thus are not complete. `.` was set by ..()
	return

/obj/structure/stairs/top/Crossed(var/atom/movable/AM, var/atom/oldloc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.has_AI())
			use_stairs(AM, oldloc)
	..()

/obj/structure/stairs/top/Uncrossed(var/atom/movable/AM)
	// Going down stairs from the topstair piece
	if(AM.dir == turn(dir, 180) && isturf(AM.loc) && check_integrity())
		use_stairs_instant(AM)
		return

/obj/structure/stairs/top/use_stairs(var/atom/movable/AM, var/atom/oldloc)
	// If we're coming from the bottom of the stairs, don't trap us in an infinite staircase
	// Or if we climb up the middle
	if((bottom in oldloc) || oldloc == GetBelow(src))
		return
	//VOREStation Addition Start
	if(istype(AM, /obj/effect/plant))
		return
	//VOREStation Addition End
	if(isobserver(AM)) // Ghosts have their own methods for going up and down
		return
	if(AM.pulledby) // Animating the movement of pulled things is handled when the puller goes up the stairs
		return

	if(AM.has_buckled_mobs()) // Similarly, the rider entering the turf will bring along whatever they're buckled to
		return

	var/list/atom/movable/pulling = list() // Will also include grabbed mobs
	if(isliving(AM))
		var/mob/living/L = AM

		if(L.grabbed_by.len) // Same as pulledby, whoever's holding you will keep you from going down stairs.
			return

		if(L.buckled)
			pulling |= L.buckled

		// If the object is pulling or grabbing anything, we'll want to move those too. A grab chain may be disrupted in doing so.
		if(L.pulling && !L.pulling.anchored)
			pulling |= L.pulling
		for(var/obj/item/weapon/grab/G in list(L.l_hand, L.r_hand))
			pulling |= G.affecting

	// If the stairs aren't broken, go up.
	if(check_integrity())
		AM.dir = turn(src.dir, 180)
		// Bring the pulled/grabbed object(s) along behind us
		for(var/atom/movable/P in pulling)
			P.forceMove(get_turf(src)) // They will move onto the turf but won't get past the check earlier in crossed. Aligns animation more cleanly

		// Move to Top
		AM.forceMove(get_turf(bottom))

		// If something is being pulled, bring it along directly to avoid the mob being torn away from it due to movement delays
		for(var/atom/movable/P in pulling)
			P.forceMove(get_turf(bottom)) // Just bring it along directly, no fussing with animation timing
			if(isliving(P))
				var/mob/living/L = P
				if(L.client)
					L.client.Process_Grab() // Update any miscellanous grabs, possibly break grab-chains

	return TRUE

/obj/structure/stairs/top/use_stairs_instant(var/atom/movable/AM)
	if(isobserver(AM)) // Ghosts have their own methods for going up and down
		return
	//VOREStation Addition Start
	if(istype(AM, /obj/effect/plant))
		return
	//VOREStation Addition End
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.grabbed_by.len) // Same as pulledby, whoever's holding you will keep you from going down stairs.
			return

		if(L.buckled)
			L.buckled.forceMove(get_turf(bottom))

		var/atom/movable/P = null
		if(L.pulling && !L.pulling.anchored)
			P = L.pulling
			P.forceMove(get_turf(L))

		L.forceMove(get_turf(bottom))

		// If the object is pulling or grabbing anything, we'll want to move those too. A grab chain may be disrupted in doing so.
		if(P)
			P.forceMove(get_turf(bottom))
			L.start_pulling(P)

		for(var/obj/item/weapon/grab/G in list(L.l_hand, L.r_hand))
			G.affecting.forceMove(get_turf(bottom))

		if(L.client)
			L.client.Process_Grab()
	else
		AM.forceMove(get_turf(bottom))

// Mapping pieces, placed at the bottommost part of the stairs
/obj/structure/stairs/spawner
	name = "Stairs spawner"
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""

/obj/structure/stairs/spawner/Initialize()
	..()
	var/turf/B1 = get_step(get_turf(src), turn(dir, 180))
	var/turf/B2 = get_turf(src)
	var/turf/T1 = GetAbove(B1)
	var/turf/T2 = GetAbove(B2)

	if(!istype(B1) || !istype(B2))
		warning("Stair created at invalid loc: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL
	if(!istype(T1) || !istype(T2))
		warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

	// Spawn the stairs
	// Railings sold separately
	var/turf/simulated/open/O = T1
	var/obj/structure/stairs/top/T 	  = new(T2)
	var/obj/structure/stairs/middle/M = new(B2)
	var/obj/structure/stairs/bottom/B = new(B1)
	if(!isopenspace(O))
		O = new(O)

	B.dir = dir
	M.dir = dir
	T.dir = dir
	B.check_integrity(B, M, T, O)

	return INITIALIZE_HINT_QDEL

// For ease of spawning. While you *can* spawn the base type and set its dir, this is useful for adminbus and a little bit quicker to map in
/obj/structure/stairs/spawner/north
	dir = NORTH
	bound_height = 64
	//bound_y = -32
	pixel_y = -32

/obj/structure/stairs/spawner/south
	dir = SOUTH
	bound_height = 64

/obj/structure/stairs/spawner/east
	dir = EAST
	bound_width = 64
	//bound_x = -32
	pixel_x = -32

/obj/structure/stairs/spawner/west
	dir = WEST
	bound_width = 64
