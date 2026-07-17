/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 45
	var/iterations = 0               // Number of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this value.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 5           // Cell becomes alive with this many live neighbors.

// Automata-specific procs and processing.
/datum/random_map/automata/seed_map()
	return // Do not seed, we use rust-g for this now

/datum/random_map/automata/generate_map()
	var/map_string = rustg_cave_system_generator_generate("[limit_x]", "[limit_y]", "\[]", "25", "1.5", "1", "30", "1", "15", "[initial_wall_cell]", "[iterations]", "6", "4", "1")

	map = list()
	map.len = length(map_string)

	for(var/i in 1 to length(map_string))
		map[i] = (map_string[i] == "1") ? FLOOR_CHAR : WALL_CHAR

/datum/random_map/automata/get_additional_spawns(value, turf/T)
	return
