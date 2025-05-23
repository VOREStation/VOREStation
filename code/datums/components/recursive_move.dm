/**
 * Recursive move listener
 * Can be added willy-nilly to anything where the COMSIG_OBSERVER_MOVE signal should also trigger on a parent moving.
 * Previously there was a system where COMSIG_OBSERVER_MOVE was always recursively propogated, but that was unnecessary bloat.
 */
/datum/component/recursive_move
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS //This makes it so pretty much nothing happens when a duplicate component is created since we don't actually override InheritComponent
	var/atom/movable/holder
	var/list/parents = list()
	var/noparents = FALSE

/datum/component/recursive_move/RegisterWithParent()
	. = ..()
	holder = parent
	RegisterSignal(holder, COMSIG_PARENT_QDELETING, PROC_REF(on_holder_qdel))
	spawn(0) // Delayed action if our holder is spawned in nullspace and then loc = target, hopefully this catches it. VV Add item does this, for example.
		if(!QDELETED(src))
			setup_parents()

/datum/component/recursive_move/proc/setup_parents()
	if(length(parents)) // safety check just incase this was called without clearing
		reset_parents()
	var/atom/movable/cur_parent = holder?.loc // first loc could be null
	var/recursion = 0 // safety check - max iterations
	while(istype(cur_parent) && (recursion < 64))
		if(cur_parent == cur_parent.loc) //safety check incase a thing is somehow inside itself, cancel
			log_debug("RECURSIVE_MOVE: Parent is inside itself. ([holder]) ([holder.type])")
			reset_parents()
			break
		if(cur_parent in parents) //safety check incase of circular contents. (A inside B, B inside C, C inside A), cancel
			log_debug("RECURSIVE_MOVE: Parent is inside a circular inventory. ([holder]) ([holder.type])")
			reset_parents()
			break
		recursion++
		parents += cur_parent
		RegisterSignal(cur_parent, COMSIG_ATOM_EXITED, PROC_REF(heirarchy_changed))
		RegisterSignal(cur_parent, COMSIG_PARENT_QDELETING, PROC_REF(on_qdel))

		cur_parent = cur_parent.loc

	if(recursion >= 64) // If we escaped due to iteration limit, cancel
		log_debug("RECURSIVE_MOVE: Parent hit recursion limit. ([holder]) ([holder.type])")
		reset_parents()
		parents.Cut()

	if(length(parents))
		//Only need to watch top parent for movement. Everything is covered by Exited
		RegisterSignal(parents[parents.len], COMSIG_ATOM_ENTERING, PROC_REF(top_moved))

	//If we have no parents of type atom/movable then we wait to see if that changes, checking every time our holder moves.
	if(!length(parents) && !noparents)
		noparents = TRUE
		RegisterSignal(holder, COMSIG_ATOM_ENTERING, PROC_REF(setup_parents))

	if(length(parents) && noparents)
		noparents = FALSE
		UnregisterSignal(holder, COMSIG_ATOM_ENTERING)


/datum/component/recursive_move/proc/unregister_signals()
	if(noparents) // safety check
		noparents = FALSE
		UnregisterSignal(holder, COMSIG_ATOM_ENTERING)
	if(!length(parents))
		return
	for(var/atom/movable/cur_parent in parents)
		UnregisterSignal(cur_parent, COMSIG_PARENT_QDELETING)
		UnregisterSignal(cur_parent, COMSIG_ATOM_EXITED)

	UnregisterSignal(parents[parents.len], COMSIG_ATOM_ENTERING)

//Parent at top of heirarchy moved.
/datum/component/recursive_move/proc/top_moved(var/atom/movable/am, var/atom/new_loc, var/atom/old_loc)
	SIGNAL_HANDLER
	SEND_SIGNAL(holder, COMSIG_OBSERVER_MOVED, old_loc, new_loc)

//One of the parents other than the top parent moved.
/datum/component/recursive_move/proc/heirarchy_changed(var/atom/old_loc, var/atom/movable/am, var/atom/new_loc)
	SIGNAL_HANDLER
	SEND_SIGNAL(holder, COMSIG_OBSERVER_MOVED, old_loc, new_loc)
	//Rebuild our list of parents
	reset_parents()
	setup_parents()

//Some things will move their contents on qdel so we should prepare ourselves to be moved.
//If this qdel does destroy our holder, on_holder_qdel will handle preperations for GC
/datum/component/recursive_move/proc/on_qdel()
	reset_parents()
	noparents = TRUE
	RegisterSignal(holder, COMSIG_ATOM_ENTERING, PROC_REF(setup_parents))

/datum/component/recursive_move/proc/on_holder_qdel()
	UnregisterSignal(holder, COMSIG_PARENT_QDELETING)
	reset_parents()
	holder = null
	qdel(src)

/datum/component/recursive_move/Destroy()
	. = ..()
	reset_parents()
	if(holder) UnregisterSignal(holder, COMSIG_PARENT_QDELETING)
	holder = null

/datum/component/recursive_move/proc/reset_parents()
	unregister_signals()
	parents.Cut()

//the banana peel of testing stays
/obj/item/bananapeel/testing
	name = "banana peel of testing"
	desc = "spams world log with debugging information"

/obj/item/bananapeel/testing/proc/shmove(var/atom/source, var/atom/old_loc, var/atom/new_loc)
	world.log << "the [source] moved from [old_loc]([old_loc.x],[old_loc.y],[old_loc.z]) to [new_loc]([new_loc.x],[new_loc.y],[new_loc.z])"

/obj/item/bananapeel/testing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/recursive_move)
	RegisterSignal(src, COMSIG_OBSERVER_MOVED, PROC_REF(shmove))
