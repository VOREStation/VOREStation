//
// datum defines!
// Note: Adding vars to /datum adds a var to EVERYTHING! Don't go overboard.
//

/datum
	var/gc_destroyed //Time when this object was destroyed.
	var/weakref/weakref // Holder of weakref instance pointing to this datum
	var/is_processing = FALSE // If this datum is in an MC processing list, this will be set to its name.

#ifdef TESTING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
#endif

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.
	tag = null
	nanomanager.close_uis(src)
	return QDEL_HINT_QUEUE
