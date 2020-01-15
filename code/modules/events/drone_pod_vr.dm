/datum/event/drone_pod_drop
	var/turf/land_target = null
	var/attempt_amount = 10

/datum/event/drone_pod_drop/setup()
	startWhen = rand(8,15)
	announceWhen = startWhen + 5
	if(LAZYLEN(using_map.meteor_strike_areas))
		var/turf/potential_target = null
		for(var/i=1, i <= attempt_amount, i++)
			potential_target = pick(get_area_turfs(pick(using_map.meteor_strike_areas)))
			if(potential_target.x < 7 || potential_target.x > world.maxx-7 || potential_target.y < 7 || potential_target.y > world.maxy-7)
				continue
			else
				land_target = potential_target
				break

	if(!land_target)
		kill()

/datum/event/meteor_strike/announce()
	command_announcement.Announce("An unidentified drone pod has been detected landing near the surface facilty. Open and examine at your own risk.", "NanoTrasen Orbital Monitoring")

/datum/event/drone_pod_drop/start()
	if(istype(land_target, /turf/simulated/open))
		while(istype(land_target, /turf/simulated/open))
			land_target = GetBelow(land_target)
	if(!land_target)
		kill()

	new /datum/random_map/droppod/supply(null, land_target.x-2, land_target.y-2, land_target.z, supplied_drops = list(/obj/structure/ghost_pod/manual/lost_drone/dogborg))