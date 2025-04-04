GLOBAL_DATUM_INIT(overmap_event_handler, /decl/overmap_event_handler, new)

/decl/overmap_event_handler
	var/list/hazard_by_turf = list()
	var/list/ship_events = list()

// Populates overmap with random events!  Should be called once at startup at some point.
/decl/overmap_event_handler/proc/create_events(var/z_level, var/overmap_size, var/number_of_events)
	// Acquire the list of not-yet utilized overmap turfs on this Z-level
	var/list/overmap_turfs = block(locate(OVERMAP_EDGE, OVERMAP_EDGE, z_level), locate(overmap_size - OVERMAP_EDGE, overmap_size - OVERMAP_EDGE, z_level))
	var/list/candidate_turfs = list()
	for(var/turf/T as anything in overmap_turfs)
		if(!(locate(/obj/effect/overmap/visitable) in T))
			candidate_turfs += T

	for(var/i = 1 to number_of_events)
		if(!candidate_turfs.len)
			break
		var/overmap_event_type = pick(subtypesof(/datum/overmap_event))
		var/datum/overmap_event/datum_spawn = new overmap_event_type
		log_debug("Generating cloud of [datum_spawn.count] [datum_spawn] overmap event hazards")

		var/list/event_turfs = acquire_event_turfs(datum_spawn.count, datum_spawn.radius, candidate_turfs, datum_spawn.continuous)
		candidate_turfs -= event_turfs

		for(var/event_turf in event_turfs)
			var/type = pick(datum_spawn.hazards)
			new type(event_turf)

		qdel(datum_spawn)//idk help how do I do this better?

/decl/overmap_event_handler/proc/acquire_event_turfs(var/number_of_turfs, var/distance_from_origin, var/list/candidate_turfs, var/continuous = TRUE)
	number_of_turfs = min(number_of_turfs, candidate_turfs.len)
	candidate_turfs = candidate_turfs.Copy() // Not this proc's responsibility to adjust the given lists

	var/origin_turf = pick(candidate_turfs)
	var/list/selected_turfs = list(origin_turf)
	var/list/selection_turfs = list(origin_turf)
	candidate_turfs -= origin_turf

	while(selection_turfs.len && selected_turfs.len < number_of_turfs)
		var/selection_turf = pick(selection_turfs)
		var/random_neighbour = get_random_neighbour(selection_turf, candidate_turfs, continuous, distance_from_origin)

		if(random_neighbour)
			candidate_turfs -= random_neighbour
			selected_turfs += random_neighbour
			if(get_dist(origin_turf, random_neighbour) < distance_from_origin)
				selection_turfs += random_neighbour
		else
			selection_turfs -= selection_turf

	return selected_turfs

/decl/overmap_event_handler/proc/get_random_neighbour(var/turf/origin_turf, var/list/candidate_turfs, var/continuous = TRUE, var/range)
	var/fitting_turfs
	if(continuous)
		fitting_turfs = origin_turf.CardinalTurfs(FALSE)
	else
		fitting_turfs = trange(range, origin_turf)
	fitting_turfs = shuffle(fitting_turfs)
	for(var/turf/T in fitting_turfs)
		if(T in candidate_turfs)
			return T

/decl/overmap_event_handler/proc/start_hazard(var/obj/effect/overmap/visitable/ship/ship, var/obj/effect/overmap/event/hazard)//make these accept both hazards or events
	if(!(ship in ship_events))
		ship_events += ship

	for(var/event_type in hazard.events)
		if(is_event_active(ship, event_type, hazard.difficulty))//event's already active, don't bother
			continue
		var/datum/event_meta/EM = new(hazard.difficulty, "Overmap event - [hazard.name]", event_type, add_to_queue = FALSE, is_one_shot = TRUE)
		var/datum/event/E = new event_type(EM)
		E.startWhen = 0
		E.endWhen = INFINITY
		// TODO - Leshana - Note: event.setup() is called before these are set!
		E.affecting_z = ship.map_z.Copy()
		E.victim = ship
		LAZYADD(ship_events[ship], E)

/decl/overmap_event_handler/proc/stop_hazard(var/obj/effect/overmap/visitable/ship/ship, var/obj/effect/overmap/event/hazard)
	for(var/event_type in hazard.events)
		var/datum/event/E = is_event_active(ship, event_type, hazard.difficulty)
		if(E)
			E.kill()
			LAZYREMOVE(ship_events[ship], E)

/decl/overmap_event_handler/proc/is_event_active(var/ship, var/event_type, var/severity)
	if(!ship_events[ship])	return
	for(var/datum/event/E in ship_events[ship])
		if(E.type == event_type && E.severity == severity)
			return E

/decl/overmap_event_handler/proc/on_turf_entered(var/turf/new_loc, var/obj/effect/overmap/visitable/ship/ship, var/old_loc)
	if(!istype(ship))
		return
	if(new_loc == old_loc)
		return

	for(var/obj/effect/overmap/event/E in hazard_by_turf[new_loc])
		start_hazard(ship, E)

/decl/overmap_event_handler/proc/on_turf_exited(var/turf/old_loc, var/obj/effect/overmap/visitable/ship/ship, var/new_loc)
	if(!istype(ship))
		return
	if(new_loc == old_loc)
		return

	for(var/obj/effect/overmap/event/E in hazard_by_turf[old_loc])
		if(is_event_included(hazard_by_turf[new_loc], E))
			continue // If new turf has the same event as well... keep it going!
		stop_hazard(ship, E)

/decl/overmap_event_handler/proc/update_hazards(var/turf/T)//catch all updater
	if(!istype(T))
		return

	var/list/active_hazards = list()
	for(var/obj/effect/overmap/event/E in T)
		if(is_event_included(active_hazards, E, TRUE))
			continue
		active_hazards += E

	if(!active_hazards.len)
		hazard_by_turf -= T
	else
		hazard_by_turf |= T
		hazard_by_turf[T] = active_hazards

	for(var/obj/effect/overmap/visitable/ship/ship in T)
		for(var/datum/event/E in ship_events[ship])
			if(is_event_in_turf(E, T))
				continue
			E.kill()
			LAZYREMOVE(ship_events[ship], E)

		for(var/obj/effect/overmap/event/E in active_hazards)
			start_hazard(ship, E)

/decl/overmap_event_handler/proc/is_event_in_turf(var/datum/event/E, var/turf/T)
	for(var/obj/effect/overmap/event/hazard in hazard_by_turf[T])
		if((E in hazard.events) && E.severity == hazard.difficulty)
			return TRUE

/decl/overmap_event_handler/proc/is_event_included(var/list/hazards, var/obj/effect/overmap/event/E, var/equal_or_better)//this proc is only used so it can break out of 2 loops cleanly
	for(var/obj/effect/overmap/event/A in hazards)
		if(istype(A, E.type) || istype(E, A.type))
			if(same_entries(A.events, E.events))
				if(equal_or_better)
					if(A.difficulty >= E.difficulty)
						return TRUE
					else
						hazards -= A // TODO - Improve this SPAGHETTI CODE! Done only when called from update_hazards. ~Leshana
				else
					if(A.difficulty == E.difficulty)
						return TRUE
