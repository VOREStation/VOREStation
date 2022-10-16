/weakref
	var/ref
	var/ref_name
	var/ref_type


/weakref/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_IWILLGC


/weakref/New(datum/thing)
	ref = "\ref[thing]"
	ref_name = "[thing]"
	ref_type = thing.type


/weakref/proc/resolve()
	var/datum/thing = locate(ref)
	if (thing && thing.weakref == src)
		return thing
	return null


/proc/weakref(datum/thing)
	if (!istype(thing) || QDELING(thing))
		return
	if (!thing.weakref)
		thing.weakref = new /weakref (thing)
	return thing.weakref
