/*
/atom/movable/proc/recursive_move(atom/movable/am, old_loc, new_loc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_ATTEMPTED_MOVE, old_loc, new_loc)
*/
/atom/movable/proc/move_to_destination(atom/movable/am, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/proc/recursive_dir_set(atom/a, old_dir, new_dir)
	set_dir(new_dir)

/datum/proc/qdel_self()
	SIGNAL_HANDLER
	qdel(src)

/*
/proc/register_all_movement(event_source, datum/listener)
	listener.RegisterSignal(event_source, COMSIG_MOVABLE_ATTEMPTED_MOVE, /atom/movable/proc/recursive_move)
	//GLOB.dir_set_event.register(event_source, listener, /atom/proc/recursive_dir_set)

/proc/unregister_all_movement(event_source, datum/listener)
	listener.UnregisterSignal(event_source, COMSIG_MOVABLE_ATTEMPTED_MOVE)
	//GLOB.dir_set_event.unregister(event_source, listener, /atom/proc/recursive_dir_set)
*/
