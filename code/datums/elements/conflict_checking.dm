/**
 * Simple conflict checking for getting number of conflicting things on someone with the same ID.
 */
/datum/element/conflict_checking
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 1
	/// we don't need to KNOW who has us, only our ID.
	var/id

/datum/element/conflict_checking/Attach(datum/target, id)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	if(!length(id))
		. = ELEMENT_INCOMPATIBLE
		CRASH("Invalid ID in conflict checking element.")
	if(isnull(src.id))
		src.id = id
	RegisterSignal(target, COMSIG_CONFLICT_ELEMENT_CHECK, PROC_REF(check))

/datum/element/conflict_checking/proc/check(datum/source, id_to_check)
	if(id == id_to_check)
		return ELEMENT_CONFLICT_FOUND

/**
 * Counts number of conflicts on something that have a conflict checking element.
 */
/atom/proc/ConflictElementCount(id)
	. = 0
	for(var/i in GetAllContents())
		var/atom/movable/AM = i
		if(SEND_SIGNAL(AM, COMSIG_CONFLICT_ELEMENT_CHECK, id) & ELEMENT_CONFLICT_FOUND)
			++.
