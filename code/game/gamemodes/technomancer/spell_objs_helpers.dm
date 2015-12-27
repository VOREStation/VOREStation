//Returns 1 if the turf is dense, or if there's dense objects on it, unless told to ignore them.
/turf/proc/check_density(var/ignore_objs = 0)
	if(density)
		return 1
	if(!ignore_objs)
		for(var/atom/movable/stuff in contents)
			if(stuff.density)
				return 1
	return 0