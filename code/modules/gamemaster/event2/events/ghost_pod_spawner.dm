// Generic subtype for events that make ghost pods.

/datum/event2/event/ghost_pod_spawner
	var/pod_type = null
	var/list/open_turfs = list()

/datum/event2/event/ghost_pod_spawner/set_up()
	for(var/areapath in typesof(using_map.maintenance_areas))
		var/area/A = locate(areapath)
		for(var/turf/simulated/floor/F in A.contents)
			if(!F.check_density())
				open_turfs += F

	if(!open_turfs.len)
		log_debug("Ghost Pod Spawning event failed to find a place to spawn. Aborting.")
		abort()

/datum/event2/event/ghost_pod_spawner/start()
	var/obj/structure/ghost_pod/pod = new pod_type(pick(open_turfs))
	post_pod_creation(pod)

// Override to do things to the pod after it's spawned.
/datum/event2/event/ghost_pod_spawner/proc/post_pod_creation(obj/structure/ghost_pod/pod)
