#define KILL_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_dead_value;
#define REVIVE_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_live_value;

/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 55
	var/iterations = 0               // Number of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this value.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 5           // Cell becomes alive with this many live neighbors.

// Automata-specific procs and processing.
/datum/random_map/automata/seed_map()
	return // Do not seed, we use Verdigris for this now

/datum/random_map/automata/generate_map()
	map = verdigris_generate_automata(limit_x, limit_y, iterations, initial_wall_cell)

/datum/random_map/automata/get_additional_spawns(value, turf/T)
	return

#undef KILL_CELL
#undef REVIVE_CELL
