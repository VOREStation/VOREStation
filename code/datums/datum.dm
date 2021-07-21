//
// datum defines!
// Note: Adding vars to /datum adds a var to EVERYTHING! Don't go overboard.
//

/datum
	var/gc_destroyed //Time when this object was destroyed.
	var/list/active_timers  //for SStimer
	var/list/datum_components //for /datum/components
	var/list/comp_lookup
	var/list/list/signal_procs // List of lists
	var/signal_enabled = FALSE
	var/weakref/weakref // Holder of weakref instance pointing to this datum
	var/datum_flags = NONE

#ifdef REFERENCE_TRACKING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
	#ifdef REFERENCE_TRACKING_DEBUG
	///Stores info about where refs are found, used for sanity checks and testing
	var/list/found_refs
	#endif
#endif

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)

	//clear timers
	var/list/timers = active_timers
	active_timers = null
	for(var/datum/timedevent/timer as anything in timers)
		if (timer.spent)
			continue
		qdel(timer)

	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.

	//BEGIN: ECS SHIT
	signal_enabled = FALSE

	var/list/dc = datum_components
	if(dc)
		var/all_components = dc[/datum/component]
		if(length(all_components))
			for(var/datum/component/C as anything in all_components)
				qdel(C, FALSE, TRUE)
		else
			var/datum/component/C = all_components
			qdel(C, FALSE, TRUE)
		dc.Cut()

	var/list/lookup = comp_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/datum/component/comp as anything in comps)
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		comp_lookup = lookup = null

	for(var/target in signal_procs)
		UnregisterSignal(target, signal_procs[target])
	//END: ECS SHIT

	tag = null
	SStgui.close_uis(src)
	return QDEL_HINT_QUEUE
