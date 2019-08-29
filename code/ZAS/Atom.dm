

/atom/var/pressure_resistance = ONE_ATMOSPHERE
/atom/var/can_atmos_pass = ATMOS_PASS_YES

// Purpose: Determines if the object can pass this atom.
// Called by: Movement.
// Inputs: The moving atom, target turf.
// Outputs: Boolean if can pass.
// Airflow and ZAS zones now uses CanZASPass() instead of this proc.
/atom/proc/CanPass(atom/movable/mover, turf/target)
	return !density

// Purpose: Determines if airflow is allowed between T and loc.
// Called by: Airflow.
// Inputs: The turf the airflow is from, which may not be the same as loc. is_zone is for conditionally disallowing merging.
// Outputs: Boolean if airflow can pass.
/atom/proc/CanZASPass(turf/T, is_zone)
	switch(can_atmos_pass)
		if(ATMOS_PASS_DENSITY)
			return !density
		else
			return can_atmos_pass

/turf/can_atmos_pass = ATMOS_PASS_NO

/turf/CanPass(atom/movable/mover, turf/target)
	if(!target) return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

/turf/CanZASPass(turf/T, is_zone)
	if(T.blocks_air || src.blocks_air)
		return FALSE
	for(var/obj/obstacle in src)
		if(!obstacle.CanZASPass(T, is_zone))
			return FALSE
	if(T != src)
		for(var/obj/obstacle in T)
			if(!obstacle.CanZASPass(src, is_zone))
				return FALSE
	return TRUE

//Convenience function for atoms to update turfs they occupy
/atom/movable/proc/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		air_master.mark_for_update(turf)

	return 1

//Basically another way of calling CanPass(null, other, 0, 0) and CanPass(null, other, 1.5, 1).
//Returns:
// 0 - Not blocked
// AIR_BLOCKED - Blocked
// ZONE_BLOCKED - Not blocked, but zone boundaries will not cross.
// BLOCKED - Blocked, zone boundaries will not cross even if opened.
atom/proc/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	return (AIR_BLOCKED*!CanZASPass(other, FALSE))|(ZONE_BLOCKED*!CanZASPass(other, TRUE))

turf/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	if(((blocks_air & AIR_BLOCKED) || (other.blocks_air & AIR_BLOCKED)))
		return BLOCKED

	//Z-level handling code. Always block if there isn't an open space.
	#ifdef MULTIZAS
	if(other.z != src.z)
		if(other.z < src.z)
			if(!istype(src, /turf/simulated/open)) return BLOCKED
		else
			if(!istype(other, /turf/simulated/open)) return BLOCKED
	#endif

	if(((blocks_air & ZONE_BLOCKED) || (other.blocks_air & ZONE_BLOCKED)))
		if(z == other.z)
			return ZONE_BLOCKED
		else
			return AIR_BLOCKED

	var/result = 0
	for(var/mm in contents)
		var/atom/movable/M = mm
		result |= M.c_airblock(other)
		if(result == BLOCKED) return BLOCKED
	return result
