/*
 * Procs for counting active players in different situations. Returns the number of active players within the given cutoff.
 */

/datum/metric/proc/count_all_outdoor_mobs(var/cutoff = 75)
	var/num = 0
	for(var/mob/living/L in player_list)
		var/turf/T = get_turf(L)
		if(istype(T) && !istype(T, /turf/space) && T.outdoors)
			if(assess_player_activity(L) >= cutoff)
				num++
	return num

/datum/metric/proc/count_all_space_mobs(var/cutoff = 75, var/respect_z = TRUE)
	var/num = 0
	for(var/mob/living/L in player_list)
		var/turf/T = get_turf(L)
		if(istype(T, /turf/space) && istype(T.loc, /area/space))
			if(respect_z && !(L.z in using_map.station_levels))
				continue
			if(assess_player_activity(L) >= cutoff)
				num++
	return num
