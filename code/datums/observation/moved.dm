//	Observer Pattern Implementation: Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has moved using Move() or forceMove().
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			/atom/old_loc: The loc before the move.
//			/atom/new_loc: The loc after the move.

/*
GLOBAL_DATUM_INIT(moved_event, /decl/observ/moved, new)


/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/decl/observ/moved/register(var/atom/movable/mover, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(mover.loc, expected_type))
		register(mover.loc, mover, /atom/movable/proc/recursive_move)
*/
//Deprecated in favor of comsigs

/********************
* Movement Handling *
********************/
/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	am.RegisterSignal(src,COMSIG_OBSERVER_MOVED, /atom/movable/proc/recursive_move, override = TRUE)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	am.UnregisterSignal(src,COMSIG_OBSERVER_MOVED)

// Entered() typically lifts the moved event, but in the case of null-space we'll have to handle it.
/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		SEND_SIGNAL(src,COMSIG_OBSERVER_MOVED, old_loc, null)

/atom/movable/forceMove(atom/destination)
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		SEND_SIGNAL(src,COMSIG_OBSERVER_MOVED, old_loc, null)
