//---------- external shield generator
//generates an energy field that loops around any built up area in space (is useless inside) halts movement and airflow, is blocked by walls, windows, airlocks etc

/obj/machinery/shield_gen/external
	name = "hull shield generator"
	var/global/list/blockedturfs =  list(
		/turf/space,
		/turf/simulated/floor/outdoors,
		/turf/simulated/open
	)

/obj/machinery/shield_gen/external/advanced
	name = "advanced hull shield generator"
	desc = "A machine that generates a field of energy optimized for blocking meteorites when activated.  This version comes with a more efficent shield matrix."
	energy_conversion_rate = 0.0012

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
				if(istype(T, /turf/simulated/open))
					if((locate(/obj/structure/catwalk) in T) || !T.is_outdoors())	// Don't cover catwalks or indoor turfs.
						continue
					for(var/turf/simulated/Turf in orange(1, T))	// check adjacent turfs
						if(!Turf.is_outdoors() && !is_type_in_list(Turf, blockedturfs))
							out |= T
							break
						if(Turf.is_outdoors() && (!is_type_in_list(Turf, blockedturfs) || (locate(/obj/structure/catwalk) in Turf)))	// Is it outdoors, and not a turf we can shield, or a catwalked turf?
							out |= T
							break
				else
					for(var/i in orange(1, T))
						if(istype(i, /turf/simulated) && !is_type_in_list(i,blockedturfs))
							out |= T
							break

	return out
