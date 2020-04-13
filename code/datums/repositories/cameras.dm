var/global/datum/repository/cameras/camera_repository = new()

/proc/invalidateCameraCache()
	camera_repository.networks.Cut()
	camera_repository.invalidated = 1
	camera_repository.camera_cache_id = (++camera_repository.camera_cache_id % 999999)

/datum/repository/cameras
	var/list/networks
	var/invalidated = 1
	var/camera_cache_id = 1

/datum/repository/cameras/New()
	networks = list()
	..()

/datum/repository/cameras/proc/cameras_in_network(var/network, var/list/zlevels)
	setup_cache()
	var/list/network_list = networks[network]
	if(LAZYLEN(zlevels))
		var/list/filtered_cameras = list()
		for(var/list/C in network_list)
			//Camera is marked as always-visible
			if(C["omni"])
				filtered_cameras[++filtered_cameras.len] = C
				continue
			//Camera might be in an adjacent zlevel
			var/camz = C["z"]
			if(!camz) //It's inside something (helmet, communicator, etc) or nullspace or who knows
				camz = get_z(locate(C["camera"]) in cameranet.cameras)
			if(camz in zlevels)
				filtered_cameras[++filtered_cameras.len] = C //Can't add lists to lists with +=
		return filtered_cameras
	else
		return network_list

/datum/repository/cameras/proc/setup_cache()
	if(!invalidated)
		return
	invalidated = 0

	cameranet.process_sort()
	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/cam = C.nano_structure()
		for(var/network in C.network)
			if(!networks[network])
				networks[network] = list()
			var/list/netlist = networks[network]
			netlist[++netlist.len] = cam
