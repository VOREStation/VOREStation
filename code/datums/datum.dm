//
// datum defines!
// Note: Adding vars to /datum adds a var to EVERYTHING! Don't go overboard.
//

/datum
	var/gc_destroyed //Time when this object was destroyed.
	var/list/active_timers  //for SStimer
	var/weakref/weakref // Holder of weakref instance pointing to this datum
	var/datum_flags = NONE

#ifdef TESTING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
#endif

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)

	//clear timers
	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)

	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.

	tag = null
	SSnanoui.close_uis(src)
	return QDEL_HINT_QUEUE
