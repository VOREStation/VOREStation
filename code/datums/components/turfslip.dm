/datum/component/turfslip
	var/mob/living/owner
	var/slip_dist = TURFSLIP_LUBE * 0
	var/dirtslip = FALSE

/datum/component/turfslip/Initialize()
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(move_react))

/datum/component/turfslip/proc/start_slip(var/turf/simulated/start, var/is_dirt)
	var/slip_stun = 6
	var/floor_type = "wet"
	var/already_slipping = (slip_dist > 0)

	// Handle dirt slipping
	dirtslip = is_dirt
	if(dirtslip)
		slip_stun = 10
		if(start.dirt > 50)
			floor_type = "dirty"
		else if(start.is_outdoors())
			floor_type = "uneven"

	// Proper sliding behavior
	switch(start.wet)
		if(TURFSLIP_LUBE)
			floor_type = "slippery"
			slip_dist = 4
			slip_stun = 10
			dirtslip = FALSE
		if(TURFSLIP_ICE)
			floor_type = "icy"
			slip_stun = 4
			slip_dist = rand(1,3)
			dirtslip = FALSE

	// Only start the slip timer if we are not already sliding
	if(!already_slipping)
		owner.slip("the [floor_type] floor", slip_stun)
		addtimer(CALLBACK(src, PROC_REF(next_slip)), 1)

/datum/component/turfslip/proc/move_react(atom/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER

	// Can the mob slip?
	if(QDELETED(owner) || isbelly(owner.loc))
		qdel(src)
		return

	// Can the turf be slipped on?
	var/turf/simulated/ground = get_turf(owner)
	if(!ground || !ground.check_slipping(owner,dirtslip))
		qdel(src)
		return

	addtimer(CALLBACK(src, PROC_REF(next_slip)), 1)

/datum/component/turfslip/proc/next_slip()
	// check tile for next slip
	if(!step(owner, owner.dir) || dirtslip) // done sliding, failed to move, dirt also only slips once
		qdel(src)
		return
	// Kill the slip if it's over
	if(!--slip_dist)
		qdel(src)
		return

/datum/component/turfslip/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	owner.inertia_dir = 0
	owner = null
	slip_dist = 0
	. = ..()


////////////////////////////////////////////////////////////////////////////////////////
// Helper proc
////////////////////////////////////////////////////////////////////////////////////////
/turf/proc/check_slipping(var/mob/living/M)
	return FALSE

/turf/simulated/check_slipping(var/mob/living/M,var/dirtslip)
	if(M.buckled)
		return FALSE
	if(!wet && !(dirtslip && (dirt > 50 || is_outdoors() == OUTDOORS_YES)))
		return FALSE
	if(wet == TURFSLIP_WET && M.m_intent == I_WALK)
		return FALSE
	return TRUE
