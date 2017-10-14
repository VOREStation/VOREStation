//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external
	name = "hull shield generator"
	var/global/list/blockedturfs =  list(
		/turf/space,
		/turf/simulated/open,
		/turf/simulated/floor/outdoors,
	)
/obj/machinery/shield_gen/external/New()
	..()

//Search for space turfs within range that are adjacent to a simulated turf.
/obj/machinery/shield_gen/external/get_shielded_turfs_on_z_level(var/turf/gen_turf)
	var/list/out = list()

	if (!gen_turf)
		return

	var/turf/T
	for (var/x_offset = -field_radius; x_offset <= field_radius; x_offset++)
		for (var/y_offset = -field_radius; y_offset <= field_radius; y_offset++)
			T = locate(gen_turf.x + x_offset, gen_turf.y + y_offset, gen_turf.z)
			if (is_type_in_list(T,blockedturfs))
				//check neighbors of T
				if (locate(/turf/simulated/) in orange(1, T))
					out += T
	return out