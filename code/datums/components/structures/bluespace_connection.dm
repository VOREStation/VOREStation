/// Bluespace connection component.
/// Given to lockers to make them into portals.
/datum/component/bluespace_connection
	/// Assigned closet
	VAR_PROTECTED/obj/structure/closet/assigned_closet = null
	/// List of possible exits
	var/list/connections = list()
	/// Exit sound that it'll make upon exiting
	var/exit_sound
	// How far things gets thrown
	var/throw_range
	// Turf range when exiting, x
	var/throw_range_x
	// Turf range when exiting, y
	var/throw_range_y

/datum/component/bluespace_connection/Initialize(var/list/connections, exit_sound = 'sound/effects/clang.ogg', throw_range = 3, throw_range_x = 5, throw_range_y = 5)
	assigned_closet = parent
	src.connections = connections
	src.exit_sound = exit_sound
	src.throw_range = throw_range
	src.throw_range_x = throw_range_x
	src.throw_range_y = throw_range_y
	RegisterSignal(assigned_closet, COMSIG_CLOSET_CLOSED, PROC_REF(on_close))

/datum/component/bluespace_connection/Destroy()
	UnregisterSignal(assigned_closet, COMSIG_CLOSET_CLOSED)
	assigned_closet = null
	connections.Cut()
	. = ..()

/datum/component/bluespace_connection/proc/on_close()
	SIGNAL_HANDLER

	if(isemptylist(assigned_closet.contents))
		return

	var/exit_point = pick(connections)

	if(istype(exit_point, /obj/structure/closet))
		var/obj/structure/closet/exit_closet = exit_point
		addtimer(CALLBACK(exit_closet, TYPE_PROC_REF(/obj/structure/closet, open)), 1 SECONDS)

	playsound(exit_point, exit_sound, 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(exit_connection), exit_point, assigned_closet.contents), 1.3 SECONDS)

/datum/component/bluespace_connection/proc/exit_connection(var/atom/exit_point, var/list/contents)
	// Nope, must be closed.
	if(assigned_closet.opened)
		return

	// Connection severed, self-destruct! (If there's no more exits)
	if(QDELETED(exit_point))
		connections -= exit_point // Remove the connection, first.

		if(!connections.len) // No exit points left, bluespace connection severed.
			qdel(src)
		return

	// Now the fun begins
	if(istype(exit_point, /obj/structure/closet))
		var/obj/structure/closet/exit_closet = exit_point
		if(!exit_closet.can_open()) // Bwomp. You're locked now. :)
			for(var/atom/movable/AM in contents)
				AM.forceMove(exit_closet)
			return
		exit_closet.open()

	var/turf/target = throw_target()

	if(contents.len)
		for(var/atom/movable/AM in contents)
			if(QDELETED(AM))
				continue
			AM.forceMove(get_turf(exit_point))
			AM.throw_at(target, throw_range, 1)
		contents.Cut()
	return

/datum/component/bluespace_connection/proc/throw_target()
	return get_offset_target_turf(get_turf(assigned_closet), rand(throw_range_x)-rand(throw_range_x), rand(throw_range_y)-rand(throw_range_y))

/datum/component/bluespace_connection/proc/add_exit(var/exit_point)
	if(exit_point == assigned_closet)
		return FALSE
	connections.Add(exit_point)
	return TRUE
