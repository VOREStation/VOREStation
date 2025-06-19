// A subtype that involves spawning mobs like carp, rogue drones, spiders, etc.

/datum/event2/event/mob_spawning
	var/list/spawned_mobs = list()
	var/use_map_edge_with_landmarks = TRUE // Use both landmarks and spawning from the "edge" of the map. Otherise uses landmarks over map edge.
	var/landmark_name = "carpspawn" // Which landmark to use for spawning.

// Spawns a specific mob from the "edge" of the map, and makes them go towards the station.
// Can also use landmarks, if desired.
/datum/event2/event/mob_spawning/proc/spawn_mobs_in_space(mob_type, number_of_groups, min_size_of_group, max_size_of_group, dir)
	if(isnull(dir))
		dir = pick(GLOB.cardinal)

	var/list/valid_z_levels = get_location_z_levels()
	valid_z_levels -= using_map.sealed_levels // Space levels only please!

	// Check if any landmarks exist!
	var/list/spawn_locations = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == landmark_name && (C.z in valid_z_levels))
			spawn_locations.Add(C.loc)

	var/prioritize_landmarks = TRUE
	if(use_map_edge_with_landmarks && prob(50))
		prioritize_landmarks = FALSE // One in two chance to come from the edge instead.

	if(spawn_locations.len && prioritize_landmarks) // Okay we've got landmarks, lets use those!
		shuffle_inplace(spawn_locations)
		number_of_groups = min(number_of_groups, spawn_locations.len)
		var/i = 1
		while (i <= number_of_groups)
			var/group_size = rand(min_size_of_group, max_size_of_group)
			for (var/j = 0, j < group_size, j++)
				spawn_one_mob(spawn_locations[i], mob_type)
			i++
		return

	// Okay we did *not* have any landmarks, or we're being told to do both, so lets do our best!
	var/i = 1
	while(i <= number_of_groups)
		var/z_level = pick(valid_z_levels)
		var/group_size = rand(min_size_of_group, max_size_of_group)
		var/turf/map_center = locate(round(world.maxx/2), round(world.maxy/2), z_level)
		var/turf/group_center = pick_random_edge_turf(dir, z_level, TRANSITIONEDGE + 2)
		var/list/turfs = getcircle(group_center, 2)
		for(var/j = 0, j < group_size, j++)
			// On larger maps, BYOND gets in the way of letting simple_mobs path to the closest edge of the station.
			// So instead we need to simulate the mob's travel, then spawn them somewhere still hopefully off screen.

			// Find a turf to be the edge of the map.
			var/turf/edge_of_map = turfs[(i % turfs.len) + 1]

			// Now walk a straight line towards the center of the map, until we find a non-space tile.
			var/turf/edge_of_station = null

			var/list/space_line = list() // This holds all space tiles on the line. Will be used a bit later.
			for(var/turf/T in getline(edge_of_map, map_center))
				if(!T.is_space())
					break // We found the station!
				space_line += T
				edge_of_station = T

			// Now put the mob somewhere on the line, hopefully off screen.
			// I wish this was higher than 8 but the BYOND internal A* algorithm gives up sometimes when using
			// 16 or more.
			// In the future, a new AI stance that handles long distance travel using getline() could work.
			var/max_distance = 8
			var/turf/spawn_turf = null
			for(var/turf/point as anything in space_line)
				if(get_dist(point, edge_of_station) <= max_distance)
					spawn_turf = point
					break

			if(spawn_turf)
				// Finally, make the simple_mob go towards the edge of the station.
				var/mob/living/simple_mob/M = spawn_one_mob(spawn_turf, mob_type)
				if(edge_of_station)
					M.ai_holder?.give_destination(edge_of_station) // Ask simple_mobs to fly towards the edge of the station.
		i++

/datum/event2/event/mob_spawning/proc/spawn_one_mob(new_loc, mob_type)
	var/mob/living/simple_mob/M = new mob_type(new_loc)
	RegisterSignal(M, COMSIG_OBSERVER_DESTROYED, PROC_REF(on_mob_destruction))
	spawned_mobs += M
	return M

// Counts living simple_mobs spawned by this event.
/datum/event2/event/mob_spawning/proc/count_spawned_mobs()
	. = 0
	for(var/mob/living/simple_mob/M as anything in spawned_mobs)
		if(!QDELETED(M) && M.stat != DEAD)
			. += 1

// If simple_mob is bomphed, remove it from the list.
/datum/event2/event/mob_spawning/proc/on_mob_destruction(mob/M)
	SIGNAL_HANDLER
	spawned_mobs -= M
	UnregisterSignal(M, COMSIG_OBSERVER_DESTROYED)
