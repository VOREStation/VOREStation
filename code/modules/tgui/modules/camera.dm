/datum/tgui_module/camera
	name = "Security Cameras"
	tgui_id = "CameraConsole"

	var/access_based = FALSE
	var/list/network = list()
	var/list/additional_networks = list()

	var/obj/machinery/camera/active_camera
	var/list/concurrent_users = list()

	// Stuff needed to render the map
	var/map_name
	var/const/default_map_size = 15
	var/obj/screen/map_view/cam_screen
	/// All the plane masters that need to be applied.
	var/list/cam_plane_masters
	var/obj/screen/background/cam_background
	var/obj/screen/background/cam_foreground
	var/obj/screen/skybox/local_skybox
	// Stuff for moving cameras
	var/turf/last_camera_turf

/datum/tgui_module/camera/New(host, list/network_computer)
	. = ..()
	if(!LAZYLEN(network_computer))
		access_based = TRUE
	else
		network = network_computer
	map_name = "camera_console_[REF(src)]_map"
	// Initialize map objects
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"

	cam_plane_masters = get_tgui_plane_masters()

	for(var/obj/screen/instance as anything in cam_plane_masters)
		instance.assigned_map = map_name
		instance.del_on_map_removal = FALSE
		instance.screen_loc = "[map_name]:CENTER"

	local_skybox = new()
	local_skybox.assigned_map = map_name
	local_skybox.del_on_map_removal = FALSE
	local_skybox.screen_loc = "[map_name]:CENTER,CENTER"
	cam_plane_masters += local_skybox

	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE

	var/mutable_appearance/scanlines = mutable_appearance('icons/effects/static.dmi', "scanlines")
	scanlines.alpha = 50
	scanlines.layer = FULLSCREEN_LAYER

	var/mutable_appearance/noise = mutable_appearance('icons/effects/static.dmi', "1 light")
	noise.layer = FULLSCREEN_LAYER

	cam_foreground = new
	cam_foreground.assigned_map = map_name
	cam_foreground.del_on_map_removal = FALSE
	cam_foreground.plane = PLANE_FULLSCREEN
	cam_foreground.add_overlay(scanlines)
	cam_foreground.add_overlay(noise)

/datum/tgui_module/camera/Destroy()
	if(active_camera)
		UnregisterSignal(active_camera, COMSIG_OBSERVER_MOVED)
	active_camera = null
	last_camera_turf = null
	qdel(cam_screen)
	QDEL_LIST(cam_plane_masters)
	qdel(cam_background)
	qdel(cam_foreground)
	return ..()

/datum/tgui_module/camera/tgui_interact(mob/user, datum/tgui/ui = null)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui)
	var/turf/newturf = get_turf(active_camera)
	var/area/B = newturf?.loc // No cam tracking in dorms!
	// Show static if can't use the camera
	if(!active_camera?.can_use() || B?.flag_check(AREA_BLOCK_TRACKING))
		show_camera_static()
	if(!ui)
		var/user_ref = REF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			concurrent_users += user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			playsound(tgui_host(), 'sound/machines/terminal_on.ogg', 25, FALSE)
		// Register map objects
		user.client.register_map_obj(cam_screen)
		for(var/plane in cam_plane_masters)
			user.client.register_map_obj(plane)
		user.client.register_map_obj(cam_background)
		user.client.register_map_obj(cam_foreground)
		// Open UI
		ui = new(user, src, tgui_id, name)
		ui.open()

/datum/tgui_module/camera/tgui_data()
	var/list/data = list()
	data["activeCamera"] = null
	if(active_camera)
		data["activeCamera"] = list(
			name = active_camera.c_tag,
			status = active_camera.status,
		)
	return data

/datum/tgui_module/camera/tgui_static_data(mob/user)
	var/list/data = ..()
	data["mapRef"] = map_name
	var/list/cameras = get_available_cameras(user)
	data["cameras"] = list()
	data["allNetworks"] = list()
	for(var/i in cameras)
		var/obj/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
			networks = C.network
		))
		data["allNetworks"] |= C.network
	return data

/datum/tgui_module/camera/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	if(action && !issilicon(ui.user))
		playsound(tgui_host(), "terminal_type", 50, 1)

	if(action == "switch_camera")
		var/c_tag = params["name"]
		var/list/cameras = get_available_cameras(ui.user)
		var/obj/machinery/camera/C = cameras["[ckey(c_tag)]"]
		if(active_camera)
			UnregisterSignal(active_camera, COMSIG_OBSERVER_MOVED)
		if(C)
			active_camera = C
			active_camera.AddComponent(/datum/component/recursive_move)
			RegisterSignal(active_camera, COMSIG_OBSERVER_MOVED, PROC_REF(update_active_camera_screen))
		playsound(tgui_host(), get_sfx("terminal_type"), 25, FALSE)
		update_active_camera_screen()
		return TRUE

	if(action == "pan")
		var/dir = params["dir"]
		var/turf/T = get_turf(active_camera)
		for(var/i in 1 to 10)
			T = get_step(T, dir)
		if(T)
			var/obj/machinery/camera/target
			var/best_dist = INFINITY

			var/list/possible_cameras = get_available_cameras(ui.user)
			for(var/obj/machinery/camera/C in get_area(T))
				if(!possible_cameras["[ckey(C.c_tag)]"])
					continue
				var/dist = get_dist(C, T)
				if(dist < best_dist)
					best_dist = dist
					target = C

			if(target)
				if(active_camera)
					UnregisterSignal(active_camera, COMSIG_OBSERVER_MOVED)
				active_camera = target
				active_camera.AddComponent(/datum/component/recursive_move)
				RegisterSignal(active_camera, COMSIG_OBSERVER_MOVED, PROC_REF(update_active_camera_screen))
				playsound(tgui_host(), get_sfx("terminal_type"), 25, FALSE)
				update_active_camera_screen()
				. = TRUE

/datum/tgui_module/camera/proc/update_active_camera_screen()
	SIGNAL_HANDLER
	if(!active_camera)
		show_camera_static()
		return TRUE

	var/turf/newturf = get_turf(active_camera)
	var/area/B = newturf?.loc // No cam tracking in dorms!
	// Show static if can't use the camera
	if(!active_camera.can_use() || B?.flag_check(AREA_BLOCK_TRACKING))
		show_camera_static()
		return TRUE

	// If we're not forcing an update for some reason and the cameras are in the same location,
	// we don't need to update anything.
	// Most security cameras will end here as they're not moving.
	if(newturf == last_camera_turf)
		return

	// Cameras that get here are moving, and are likely attached to some moving atom such as cyborgs.
	last_camera_turf = get_turf(active_camera)

	var/list/visible_turfs = list()
	for(var/turf/T in (active_camera.isXRay() \
			? range(active_camera.view_range, newturf) \
			: view(active_camera.view_range, newturf)))
		visible_turfs += T

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

	cam_foreground.fill_rect(1, 1, size_x, size_y)

	local_skybox.cut_overlays()
	local_skybox.add_overlay(SSskybox.get_skybox(get_z(newturf)))
	local_skybox.scale_to_view(size_x)
	local_skybox.set_position("CENTER", "CENTER", (world.maxx>>1) - newturf.x, (world.maxy>>1) - newturf.y)

// Returns the list of cameras accessible from this computer
// This proc operates in two distinct ways depending on the context in which the module is created.
// It can either return a list of cameras sharing the same the internal `network` variable, or
// It can scan all station networks and determine what cameras to show based on the access of the user.
/datum/tgui_module/camera/proc/get_available_cameras(mob/user)
	var/list/all_networks = list()
	// Access Based
	if(access_based)
		for(var/network in using_map.station_networks)
			if(can_access_network(user, get_camera_access(network), 1))
				all_networks.Add(network)
		for(var/network in using_map.secondary_networks)
			if(can_access_network(user, get_camera_access(network), 0))
				all_networks.Add(network)
	// Network Based
	else
		all_networks = network.Copy()

	if(additional_networks)
		all_networks += additional_networks

	var/list/D = list()
	for(var/obj/machinery/camera/C in cameranet.cameras)
		if(!C.network)
			stack_trace("Camera in a cameranet has no camera network")
			continue
		if(!(islist(C.network)))
			stack_trace("Camera in a cameranet has a non-list camera network")
			continue
		var/list/tempnetwork = C.network & all_networks
		if(tempnetwork.len)
			D["[ckey(C.c_tag)]"] = C
	return D

/datum/tgui_module/camera/proc/can_access_network(mob/user, network_access, station_network = 0)
	// No access passed, or 0 which is considered no access requirement. Allow it.
	if(!network_access)
		return 1

	if(station_network)
		return check_access(user, network_access) || check_access(user, access_security) || check_access(user, access_heads)
	else
		return check_access(user, network_access)

/datum/tgui_module/camera/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, default_map_size, default_map_size)
	local_skybox.cut_overlays()

/datum/tgui_module/camera/tgui_close(mob/user)
	. = ..()
	var/user_ref = REF(user)
	var/is_living = isliving(user)
	// living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	if(user.client)
		user.client.clear_map(map_name)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living)
		if(active_camera)
			UnregisterSignal(active_camera, COMSIG_OBSERVER_MOVED)
		active_camera = null
		playsound(tgui_host(), 'sound/machines/terminal_off.ogg', 25, FALSE)

// NTOS Version
// Please note, this isn't a very good replacement for converting modular computers 100% to TGUI
// If/when that is done, just move all the PC_ specific data and stuff to the modular computers themselves
// instead of copying this approach here.
/datum/tgui_module/camera/ntos
	ntos = TRUE

// ERT Version provides some additional networks.
/datum/tgui_module/camera/ntos/ert
	additional_networks = list(NETWORK_ERT, NETWORK_CRESCENT)

// Hacked version also provides some additional networks,
// but we want it to show *all* the networks 24/7, so we convert it into a non-access-based UI.
/datum/tgui_module/camera/ntos/hacked
	additional_networks = list(NETWORK_MERCENARY, NETWORK_ERT, NETWORK_CRESCENT)

/datum/tgui_module/camera/ntos/hacked/New(host)
	. = ..(host, using_map.station_networks.Copy())

/datum/tgui_module/camera/bigscreen/tgui_state(mob/user)
	return GLOB.tgui_physical_state_bigscreen
