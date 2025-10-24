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

/// Use this one when using a global list of exits
/// Giving this to any locker will connect it to the network, allowing extra or none at any given point.
/datum/component/bluespace_connection/permanent_network

/datum/component/bluespace_connection/Initialize(var/list/connections, exit_sound = 'sound/effects/clang.ogg', throw_range = 3, throw_range_x = 5, throw_range_y = 5)
	assigned_closet = parent

	if(!istype(assigned_closet, /obj/structure/closet)) // Might expand this in the future? For now, it only goes on closets.
		return COMPONENT_INCOMPATIBLE

	src.connections = connections
	src.exit_sound = exit_sound
	src.throw_range = throw_range
	src.throw_range_x = throw_range_x
	src.throw_range_y = throw_range_y

/datum/component/bluespace_connection/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CLOSET_CLOSED, PROC_REF(on_close))
	RegisterSignal(parent, COMSIG_ATOM_HITBY, PROC_REF(on_hit))
	
/datum/component/bluespace_connection/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_CLOSET_CLOSED, COMSIG_ATOM_HITBY))

/datum/component/bluespace_connection/Destroy()
	assigned_closet = null
	. = ..()

/datum/component/bluespace_connection/proc/on_close()
	SIGNAL_HANDLER

	if(isemptylist(assigned_closet.contents))
		return

	var/exit_point = pick(connections)

	if(exit_point == assigned_closet)
		sever_connection(exit_point)
		return

	if(istype(exit_point, /obj/structure/closet))
		var/obj/structure/closet/exit_closet = exit_point
		exit_closet.visible_message(span_notice("\The [exit_closet] rumbles..."), span_notice("Something rumbles..."))
		exit_closet.animate_shake()
		addtimer(CALLBACK(exit_closet, TYPE_PROC_REF(/obj/structure/closet, open)), 1 SECONDS)

	playsound(exit_point, exit_sound, 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(exit_connection), exit_point, assigned_closet.contents), 1.3 SECONDS)

/datum/component/bluespace_connection/proc/exit_connection(var/atom/exit_point, var/list/contents)
	// Nope, must be closed.
	if(assigned_closet.opened)
		return

	if(QDELETED(exit_point))
		sever_connection(exit_point)
		return

	// Now the fun begins
	if(istype(exit_point, /obj/structure/closet))
		var/obj/structure/closet/exit_closet = exit_point
		if(!exit_closet.can_open()) // Bwomp. You're locked now. :)
			for(var/atom/movable/AM in contents)
				do_noeffect_teleport(AM, exit_closet, 0, 1)
			return
		exit_closet.open()

	var/turf/target = throw_target()

	if(contents.len)
		for(var/atom/movable/AM in contents)
			if(QDELETED(AM))
				continue
			do_noeffect_teleport(AM, get_turf(exit_point), 0, 1)
			if(!isbelly(exit_point))
				AM.throw_at(target, throw_range, 1)
		contents.Cut()
	return

/datum/component/bluespace_connection/proc/on_hit()
	SIGNAL_HANDLER

	if(assigned_closet.opened)
		assigned_closet.close()
	return

/datum/component/bluespace_connection/proc/throw_target()
	return get_offset_target_turf(get_turf(assigned_closet), rand(throw_range_x)-rand(throw_range_x), rand(throw_range_y)-rand(throw_range_y))

/datum/component/bluespace_connection/proc/add_exit(var/exit_point)
	connections.Add(exit_point)
	return TRUE

/datum/component/bluespace_connection/proc/sever_connection(var/removed_exit)
	connections -= removed_exit

	do_sparks()

	if(!connections.len) // No exit points left, bluespace connection severed.
		qdel(src)

	return TRUE

/datum/component/bluespace_connection/permanent_network/sever_connection(removed_exit)
	do_sparks()
	return TRUE

/datum/component/bluespace_connection/proc/do_sparks()
	playsound(assigned_closet, 'sound/effects/sparks6.ogg', 100, TRUE)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
	sparks.set_up(2, 1, assigned_closet.loc)
	sparks.start()
