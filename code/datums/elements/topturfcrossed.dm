/datum/component/topturfcrossed
	var/atom/movable/our_owner
	var/turf/our_old_turf = null

/datum/component/topturfcrossed/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	our_owner = parent

/datum/component/topturfcrossed/Destroy(force)
	. = ..()
	our_owner = null
	our_old_turf = null

/datum/component/topturfcrossed/RegisterWithParent()
	our_owner.AddComponent(/datum/component/recursive_move) // Required if we want to be useful at all
	RegisterSignal(our_owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_location_change))
	update_turf_signals(get_turf(our_owner))

/datum/component/topturfcrossed/UnregisterFromParent()
	UnregisterSignal(our_owner, COMSIG_MOVABLE_MOVED)
	update_turf_signals(null)

/datum/component/topturfcrossed/proc/handle_location_change(datum/source, atom/old_loc, atom/new_loc)
	SIGNAL_HANDLER
	if(!our_owner)
		return
	update_turf_signals(new_loc)

/// Updates the topmost turf we are registered to when we are moved.
/datum/component/topturfcrossed/proc/update_turf_signals(atom/new_loc)
	// Our turf is the exact same, don't change anything!
	if(new_loc && our_old_turf)
		var/turf/check_valid = isturf(new_loc) ? new_loc : get_turf(new_loc)
		if(check_valid == our_old_turf)
			return
	// Always remove the signal from our old turf when registering the new one
	if(our_old_turf)
		UnregisterSignal(our_old_turf, COMSIG_OBSERVER_TURF_ENTERED)
		our_old_turf = null
	// Only register the turf signal if we are inside something, otherwise we'd get DOUBLECROSSED
	if(new_loc && !isturf(our_owner.loc))
		var/turf/find_new = isturf(new_loc) ? new_loc : get_turf(new_loc)
		if(find_new)
			RegisterSignal(find_new, COMSIG_OBSERVER_TURF_ENTERED, PROC_REF(handle_turf_entered))
			our_old_turf = find_new

/// Forwards the Cross() call from the turf to the object registered
/datum/component/topturfcrossed/proc/handle_turf_entered(datum/source, datum/weakref/WF, oldloc)
	SIGNAL_HANDLER
	var/atom/movable/crosser = WF?.resolve()
	if(QDELETED(crosser) || QDELETED(our_owner))
		return
	if(isturf(our_owner.loc))
		return
	if(crosser == our_owner)
		return
	our_owner.Crossed(crosser)



//the bikehorn of testing
/obj/item/bikehorn/topturf_testing
	name = "bikehorn of testing"
	desc = "honk if you're working correctly"

/obj/item/bikehorn/topturf_testing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/topturfcrossed)

/obj/item/bikehorn/topturf_testing/Crossed(atom/movable/AM)
	. = ..()
	to_chat(world, "[src] crossed by [AM], was inside [loc]")
