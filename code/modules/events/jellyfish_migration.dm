/datum/event/jellyfish_migration
	startWhen		= 0		// Start immediately
	announceWhen	= 45	// Adjusted by setup
	endWhen			= 75	// Adjusted by setup
	var/jellyfish_cap	= 20
	var/list/spawned_jellyfish = list()

/datum/event/jellyfish_migration/setup()
	announceWhen = rand(30, 60) // 1 to 2 minutes
	endWhen += severity * 25
	jellyfish_cap = 2 + 3 ** severity // No more than this many at once regardless of waves. (5, 11, 29)

/datum/event/jellyfish_migration/start()
	affecting_z -= global.using_map.sealed_levels // Space levels only please!
	..()

/datum/event/jellyfish_migration/announce()
	var/announcement = ""
	if(severity == EVENT_LEVEL_MAJOR)
		announcement = "Massive migration of unknown biological entities has been detected near [location_name()], please stand-by."
	else
		announcement = "Unknown biological [spawned_jellyfish.len == 1 ? "entity has" : "entities have"] been detected near [location_name()], please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")

/datum/event/jellyfish_migration/tick()
	if(activeFor % 5 != 0)
		return // Only process every 10 seconds.
	if(count_spawned_jellyfish() < jellyfish_cap)
		spawn_fish(rand(3, 3 + severity * 2) - 1, 1, severity + 2)

/datum/event/jellyfish_migration/proc/spawn_fish(var/num_groups, var/group_size_min, var/group_size_max, var/dir)
	if(isnull(dir))
		dir = (victim && prob(80)) ? victim.fore_dir : pick(GLOB.cardinal)

	// Check if any landmarks exist! These will use the carp spawn since they already would spawn in these similar spots.
	var/list/spawn_locations = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn" && (C.z in affecting_z))
			spawn_locations.Add(C.loc)
	if(spawn_locations.len) // Okay we've got landmarks, lets use those!
		shuffle_inplace(spawn_locations)
		num_groups = min(num_groups, spawn_locations.len)
		for (var/i = 1, i <= num_groups, i++)
			var/group_size = rand(group_size_min, group_size_max)
			for (var/j = 0, j < group_size, j++)
				spawn_one_jellyfish(spawn_locations[i])
		return

	// Okay we did *not* have any landmarks, so lets do our best!
	var/i = 1
	while (i <= num_groups)
		var/Z = pick(affecting_z)
		var/group_size = rand(group_size_min, group_size_max)
		var/turf/map_center = locate(round(world.maxx/2), round(world.maxy/2), Z)
		var/turf/group_center = pick_random_edge_turf(dir, Z, TRANSITIONEDGE + 2)
		var/list/turfs = getcircle(group_center, 2)
		for (var/j = 0, j < group_size, j++)
			var/mob/living/simple_mob/animal/M = spawn_one_jellyfish(turfs[(i % turfs.len) + 1])
			// Ray trace towards middle of the map to find where they can stop just outside of structure/ship.
			var/turf/target
			for(var/turf/T in getline(get_turf(M), map_center))
				if(!T.is_space())
					break;
				target = T
			if(target)
				M.ai_holder?.give_destination(target) // Ask jellyfish to swim towards the middle of the map
		i++

// Spawn a single jellyfish at given location.
/datum/event/jellyfish_migration/proc/spawn_one_jellyfish(var/loc)
	var/mob/living/simple_mob/animal/M = new /mob/living/simple_mob/vore/alienanimals/space_jellyfish(loc)
	GLOB.destroyed_event.register(M, src, PROC_REF(on_jellyfish_destruction))
	spawned_jellyfish.Add(M)
	return M

// Counts living jellyfish spawned by this event.
/datum/event/jellyfish_migration/proc/count_spawned_jellyfish()
	. = 0
	for(var/mob/living/simple_mob/animal/M as anything in spawned_jellyfish)
		if(!QDELETED(M) && M.stat != DEAD)
			. += 1

// If jellyfish is bomphed, remove it from the list.
/datum/event/jellyfish_migration/proc/on_jellyfish_destruction(var/mob/M)
	spawned_jellyfish -= M
	GLOB.destroyed_event.unregister(M, src, PROC_REF(on_jellyfish_destruction))

/datum/event/jellyfish_migration/end()
	. = ..()
	// Clean up jellyfish that died in space for some reason.
	spawn(0)
		for(var/mob/living/simple_mob/SM in spawned_jellyfish)
			if(SM.stat == DEAD)
				var/turf/T = get_turf(SM)
				if(istype(T, /turf/space))
					if(prob(75))
						qdel(SM)
			CHECK_TICK

// Overmap version
/datum/event/jellyfish_migration/overmap/announce()
	return
