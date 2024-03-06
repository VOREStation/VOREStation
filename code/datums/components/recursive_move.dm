/**
 * This component behaves similar to connect_loc_behalf but for all turfs in range, hooking into a signal on each of them.
 * Just like connect_loc_behalf, It can react to that signal on behalf of a seperate listener.
 * Good for components, though it carries some overhead. Can't be an element as that may lead to bugs.
 */
/datum/component/recursive_move
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS //This makes it so pretty much nothing happens when a duplicate component is created since we don't actually override InheritComponent
	var/atom/movable/holder
	var/list/parents = list()
	var/noparents = FALSE

/datum/component/recursive_move/Initialize()
	holder = parent
	setup_parents()
	RegisterSignal(holder, COMSIG_PARENT_QDELETING, PROC_REF(on_holder_qdel))

/datum/component/recursive_move/proc/setup_parents()
	var/atom/movable/cur_parent = holder.loc
	while(istype(cur_parent))
		parents += cur_parent
		RegisterSignal(cur_parent, COMSIG_ATOM_EXITED, PROC_REF(heirarchy_changed))
		RegisterSignal(cur_parent, COMSIG_PARENT_QDELETING, PROC_REF(on_qdel))
		cur_parent = cur_parent.loc

	if(length(parents))
		//Only need to watch top parent for movement. Everything is covered by Exited
		RegisterSignal(parents[parents.len], COMSIG_ATOM_ENTERING, PROC_REF(top_moved))

	//If we have no parents of type atom/movable then we wait to see if that changes, checking every time our holder moves.
	if(!length(parents) && !noparents)
		noparents = TRUE
		RegisterSignal(parent, COMSIG_ATOM_ENTERING, PROC_REF(setup_parents))

	if(length(parents) && noparents)
		noparents = FALSE
		UnregisterSignal(parent, COMSIG_ATOM_ENTERING)


/datum/component/recursive_move/proc/unregister_signals()
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

/datum/component/recursive_move/proc/heirarchy_changed(var/atom/old_loc, var/atom/movable/am, var/atom/new_loc)
	SIGNAL_HANDLER
	SEND_SIGNAL(holder, COMSIG_OBSERVER_MOVED, old_loc, new_loc)
	//Rebuild our list of parents
	reset_parents()
	setup_parents()

/datum/component/recursive_move/proc/on_qdel()
	reset_parents()
	noparents = TRUE
	RegisterSignal(parent, COMSIG_ATOM_ENTERING, PROC_REF(setup_parents))

/datum/component/recursive_move/proc/on_holder_qdel()
	reset_parents()
	qdel(src)

/datum/component/recursive_move/Destroy()
	reset_parents()

/datum/component/recursive_move/proc/reset_parents()
	unregister_signals()
	parents.Cut()

//the banana peel of testing stays
/obj/item/weapon/bananapeel/testing
	name = "banana peel of testing"
	desc = "spams world log with debugging information"

/obj/item/weapon/bananapeel/testing/proc/shmove(var/atom/source, var/atom/old_loc, var/atom/new_loc)
	world.log << "the [source] moved from [old_loc]([old_loc.x],[old_loc.y],[old_loc.z]) to [new_loc]([new_loc.x],[new_loc.y],[new_loc.z])"

/obj/item/weapon/bananapeel/testing/Initialize()
	AddComponent(/datum/component/recursive_move)
	RegisterSignal(src, COMSIG_OBSERVER_MOVED, PROC_REF(shmove))
