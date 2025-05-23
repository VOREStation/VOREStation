/*
/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	SEND_SIGNAL(src,COMSIG_OBSERVER_MOVED, old_loc, new_loc)
*/
/atom/movable/proc/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/proc/recursive_dir_set(var/atom/a, var/old_dir, var/new_dir)
	set_dir(new_dir)

/datum/proc/qdel_self()
	qdel(src)

/*
/proc/register_all_movement(var/event_source, var/datum/listener)
	listener.RegisterSignal(event_source,COMSIG_OBSERVER_MOVED, /atom/movable/proc/recursive_move)
	//GLOB.dir_set_event.register(event_source, listener, /atom/proc/recursive_dir_set)

/proc/unregister_all_movement(var/event_source, var/datum/listener)
	listener.UnregisterSignal(event_source,COMSIG_OBSERVER_MOVED)
	//GLOB.dir_set_event.unregister(event_source, listener, /atom/proc/recursive_dir_set)
*/
