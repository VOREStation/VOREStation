/turf/simulated
	can_start_dirty = FALSE	// We have enough premapped dirt where needed



/turf/simulated/floor/plating
	can_start_dirty = TRUE	// But let maints and decrepit areas have some randomness


/turf/simulated/proc/toggle_climbability() //Again, b
	if(climbable)
		verbs -= /turf/simulated/proc/climb_wall
	else
		verbs += /turf/simulated/proc/climb_wall
	climbable = !climbable
