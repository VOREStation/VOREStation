/*
 * This is the home of multi-tile movement checks, and thus here be dragons. You are warned.
 */

/atom/movable/proc/check_multi_tile_move_density_dir(var/stepdir)
	if(!locs || !locs.len)
		return TRUE

	if(bound_height > 32 || bound_width > 32)
		var/safe_move = TRUE
		var/list/checked_turfs = list()
		for(var/turf/T in locs)
			var/turf/Tcheck = get_step(T, stepdir)
			if(Tcheck in checked_turfs)
				continue
			if(Tcheck in locs)
				checked_turfs |= Tcheck
				continue
			if(!(Tcheck in locs))
				if(!T.Exit(src, Tcheck))
					safe_move = FALSE
				if(!Tcheck.Enter(src, T))
					safe_move = FALSE
			checked_turfs |= Tcheck
			if(!safe_move)
				break
		return safe_move
	return TRUE
