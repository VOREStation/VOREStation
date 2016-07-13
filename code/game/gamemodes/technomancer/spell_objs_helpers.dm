//Returns 1 if the turf is dense, or if there's dense objects on it, unless told to ignore them.
/turf/proc/check_density(var/ignore_objs = 0)
	if(density)
		return 1
	if(!ignore_objs)
		for(var/atom/movable/stuff in contents)
			if(stuff.density)
				return 1
	return 0

// Used to distinguish friend from foe.
/obj/item/weapon/spell/proc/is_ally(var/mob/living/L)
	if(L == owner) // The best ally is ourselves.
		return 1
	if(L.mind && technomancers.is_antagonist(L.mind)) // This should be done better since we might want opposing technomancers later.
		return 1
	if(istype(L, /mob/living/simple_animal/hostile)) // Mind controlled simple mobs count as allies too.
		var/mob/living/simple_animal/SA = L
		if(owner in SA.friends)
			return 1
	return 0

/obj/item/weapon/spell/proc/allowed_to_teleport()
	if(owner && owner.z in config.admin_levels)
		return 0
	return 1