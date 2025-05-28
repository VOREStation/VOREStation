// Those turfs replace the fall from sky step striggers
/turf/Entered(var/atom/movable/am, var/atom/old_loc)
	..()
	if(!am.can_fall())
		return
	if(isliving(am))
		var/mob/living/L = am
		if(L.flying)
			return
	var/datum/planet/planet = find_planet()
	if(!planet)
		return
	trigger_fall(am, planet)

/turf/proc/trigger_fall(var/atom/movable/am, var/datum/planet/destination)
	if(!destination)
		message_admins("ERROR: planetary_fall step trigger lacks a planet to fall onto.")
		return
	if(!destination.planet_floors.len)
		message_admins("ERROR: planetary_fall step trigger's list of outdoor floors was empty.")
		return
	var/turf/simulated/T = null
	var/safety = 100 // Infinite loop protection.
	while(!T && safety)
		var/turf/simulated/candidate = pick(destination.planet_floors)
		if(!istype(candidate) || istype(candidate, /turf/simulated/sky))
			safety--
			continue
		else if(candidate && !candidate.is_outdoors())
			safety--
			continue
		else
			T = candidate
			break

	if(!T)
		message_admins("ERROR: planetary_fall step trigger could not find a suitable landing turf.")
		return

	if(isobserver(am))
		am.forceMove(T) // Harmlessly move ghosts.
		return

	am.forceMove(T)
	// Living things should probably be logged when they fall...
	if(isliving(am))
		message_admins("\The [am] fell out of the sky.")
	// ... because they're probably going to die from it.
	am.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.

/turf/proc/find_planet()
	return
