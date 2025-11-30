/datum/component/turfslip
	var/mob/living/owner
	var/slipping_dir = null
	var/slip_dist = 1
	var/dirtslip = FALSE

/datum/component/turfslip/Initialize()
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	slipping_dir = owner.dir
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(move_react))

/datum/component/turfslip/proc/start_slip(var/turf/simulated/start, var/is_dirt)
	var/slip_stun = 6
	var/floor_type = "wet"
	var/already_slipping = (slip_dist > 1)

	// Handle dirt slipping
	dirtslip = is_dirt
	if(dirtslip)
		slip_stun = 10
		if(start.dirt > 50)
			floor_type = "dirty"
		else if(start.is_outdoors())
			floor_type = "uneven"

	// Unlucky behavior
	if(HAS_TRAIT(owner, TRAIT_UNLUCKY) && start.wet)
		slip_dist = rand(5,9) // Random longer distances on slip
		slip_stun = 10
		dirtslip = FALSE

	else
		// Proper sliding behavior
		switch(start.wet)
			if(TURFSLIP_WET)
				// Slipping on wet turf doesn't push you a turf
				owner.slip("the [floor_type] floor", slip_stun)
				qdel(src)
				return

			if(TURFSLIP_LUBE)
				floor_type = "slippery"
				slip_dist = 99 //Skill issue.
				slip_stun = 10
				dirtslip = FALSE

			if(TURFSLIP_ICE)
				floor_type = "icy"
				slip_dist = 1
				slip_stun = 4
				dirtslip = FALSE

	// Only start the slip timer if we are not already sliding
	if(!already_slipping)
		owner.slip("the [floor_type] floor", slip_stun)
		addtimer(CALLBACK(src, PROC_REF(next_slip)), 1)

/datum/component/turfslip/proc/move_react(atom/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	// Can the mob slip?
	if(QDELETED(owner) || !isturf(owner.loc))
		qdel(src)
		return

	// Can the turf be slipped on?
	var/turf/simulated/ground = get_turf(owner)
	if(!ground)
		qdel(src)
		return
	if(!ground.check_slipping(owner,dirtslip))
		// End our slip if we have no more slip remaining
		if(slip_dist <= 0)
			qdel(src)
			return
		// reduce absurd slip distances to something reasonable if we are no longer standing on lube
		if(slip_dist > 4)
			slip_dist = 4

	else if(ground.wet == TURFSLIP_LUBE)
		// Lube slips forever, if we re-enter the lube then restore our slip
		slip_dist = 99

	addtimer(CALLBACK(src, PROC_REF(next_slip)), 1)

/datum/component/turfslip/proc/next_slip()
	// check tile for next slip
	owner.is_slipping = TRUE
	if(!step(owner, slipping_dir) || dirtslip) // done sliding, failed to move, dirt also only slips once
		slip_dist = 0
		qdel(src)
		return
	// Kill the slip if it's over
	if(!--slip_dist)
		qdel(src)
		return

/datum/component/turfslip/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	owner.inertia_dir = 0
	owner.is_slipping = FALSE
	owner = null
	slip_dist = 0
	. = ..()


////////////////////////////////////////////////////////////////////////////////////////
// Helper proc
////////////////////////////////////////////////////////////////////////////////////////
/turf/proc/check_slipping(mob/living/M,dirtslip)
	return FALSE

/turf/simulated/check_slipping(mob/living/M,dirtslip)
	if(M.buckled)
		return FALSE
	if(M.is_incorporeal()) // Mar!
		return FALSE
	if(ishuman(M))
		var/mob/living/carbon/human/humie = M
		if(humie.shoes && (humie.shoes.item_flags & NOSLIP)) // Includes activated magboots too
			return FALSE
		if(humie.species && (humie.species.flags & NO_SLIP))
			return FALSE
	if(isanimal(M)) // Simplemobs have their own slip logic
		var/mob/living/simple_mob/simple = M
		return simple.animal_slip(wet, dirtslip)
	if(!wet && !(dirtslip && (dirt > 50 || is_outdoors() == OUTDOORS_YES)))
		return FALSE
	if(wet == TURFSLIP_WET && M.m_intent == I_WALK)
		return FALSE
	return TRUE
