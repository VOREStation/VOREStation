/datum/event/drone_pod_drop
	var/turf/land_target = null
	var/attempt_amount = 10

/datum/event/drone_pod_drop/setup()
	startWhen = rand(8,15)

	var/land_spot_list = list()
	var/target_spot

	for(var/obj/effect/landmark/land_spot in landmarks_list)
		if(land_spot.name == "droppod_landing" && !(land_spot in land_spot_list))
			land_spot_list += land_spot

	target_spot = pick(land_spot_list)
	land_target =  get_turf(target_spot)

	if(!land_target)
		kill()
	else
		landmarks_list -= target_spot
		qdel(target_spot)

/datum/event/drone_pod_drop/announce()
	command_announcement.Announce("An unidentified drone pod has been detected on a collision course towards the [location_name()]. Open and examine at your own risk.", "[location_name()] Sensor Network")

/datum/event/drone_pod_drop/start()
	if(!land_target)
		kill()

	new /datum/random_map/droppod/supply(null, land_target.x-2, land_target.y-2, land_target.z, supplied_drops = list(/obj/structure/ghost_pod/manual/lost_drone/dogborg))
