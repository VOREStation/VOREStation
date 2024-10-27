/proc/verdigris_generate_automata(limit_x, limit_y, iterations, initial_wall_cell) as /list
	RETURN_TYPE(/list)
	return VERDIGRIS_CALL("generate_automata", limit_x, limit_y, iterations, initial_wall_cell)
