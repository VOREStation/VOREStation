

/atom/var/pressure_resistance = ONE_ATMOSPHERE
/atom/var/can_atmos_pass = ATMOS_PASS_YES

// Purpose: Determines if airflow is allowed between T and loc.
// Called by: Airflow.
// Inputs: The turf the airflow is from, which may not be the same as loc. is_zone is for conditionally disallowing merging.
// Outputs: Boolean if airflow can pass.
/atom/proc/CanZASPass(turf/T, is_zone)
	// Behaviors defined here so when people directly call c_airblock it will still obey can_atmos_pass
	switch(can_atmos_pass)
		if(ATMOS_PASS_YES)
			return TRUE
		if(ATMOS_PASS_NO)
			return FALSE
		if(ATMOS_PASS_DENSITY)
			return !density
		if(ATMOS_PASS_PROC)
			// Cowardly refuse to recursively self-call CanZASPass. The hero BYOND needs?
			CRASH("can_atmos_pass = ATMOS_PASS_PROC but CanZASPass not overridden on [src] ([type])")
		else
			CRASH("Invalid can_atmos_pass = [can_atmos_pass] on [src] ([type])")

<<<<<<< HEAD
=======

>>>>>>> 4cc54b8295c... Merge pull request #8766 from Spookerton/spkrtn/fix/canpass2
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
/atom/proc/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	return (AIR_BLOCKED*!CanZASPass(other, FALSE))|(ZONE_BLOCKED*!CanZASPass(other, TRUE))

/turf/c_airblock(turf/other)
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
	for(var/atom/movable/M as anything in contents)
		switch(M.can_atmos_pass)
			if(ATMOS_PASS_YES)
				continue
			if(ATMOS_PASS_NO)
				return BLOCKED
			if(ATMOS_PASS_DENSITY)
				if(M.density)
					return BLOCKED
			if(ATMOS_PASS_PROC)
				result |= M.c_airblock(other)
		if(result == BLOCKED) return BLOCKED
	return result
