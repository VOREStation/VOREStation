// Generic subtype for events that make ghost pods.

/datum/event2/event/ghost_pod_spawner
	var/pod_type = null
	var/list/desired_turf_areas = list() // If this is left empty, it will default to a global list of 'station' turfs.
	var/list/free_turfs = list()

/datum/event2/event/ghost_pod_spawner/set_up()
	free_turfs = find_random_turfs(5, desired_turf_areas)

	if(!free_turfs.len)
		log_debug("Ghost Pod Spawning event failed to find a place to spawn. Aborting.")
		abort()
		return

/datum/event2/event/ghost_pod_spawner/start()
	var/obj/structure/ghost_pod/pod = new pod_type(pick(free_turfs))
	post_pod_creation(pod)

// Override to do things to the pod after it's spawned.
/datum/event2/event/ghost_pod_spawner/proc/post_pod_creation(obj/structure/ghost_pod/pod)
