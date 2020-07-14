//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/security
	name = "security camera monitor"
	desc = "Used to access the various cameras on the station."

	icon_keyboard = "security_key"
	icon_screen = "cameras"
	light_color = "#a91515"
	circuit = /obj/item/weapon/circuitboard/security

	var/mapping = 0//For the overview file, interesting bit of code.

	var/list/network = list()
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

/obj/machinery/computer/security/Initialize()
	. = ..()
	if(!LAZYLEN(network))
		network = using_map.station_networks.Copy()
	map_name = "camera_console_[REF(src)]_map"
	// Initialize map objects
	cam_screen = new
	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"
	cam_plane_masters = list()
	
	for(var/plane in subtypesof(/obj/screen/plane_master))
		var/obj/screen/instance = new plane()
		instance.assigned_map = map_name
		instance.del_on_map_removal = FALSE
		instance.screen_loc = "[map_name]:CENTER"
		cam_plane_masters += instance

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

/obj/machinery/computer/security/Destroy()
	qdel(cam_screen)
	QDEL_LIST(cam_plane_masters)
	qdel(cam_background)
	qdel(cam_foreground)
	return ..()

/obj/machinery/computer/security/tgui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/tgui_state/state = GLOB.tgui_default_state)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	// Show static if can't use the camera
	if(!active_camera?.can_use())
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
			playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)
			use_power(active_power_usage)
		// Register map objects
		user.client.register_map_obj(cam_screen)
		for(var/plane in cam_plane_masters)
			user.client.register_map_obj(plane)
		user.client.register_map_obj(cam_background)
		user.client.register_map_obj(cam_foreground)
		// Open UI
		ui = new(user, src, ui_key, "CameraConsole", name, 870, 708, master_ui, state)
		ui.open()

/obj/machinery/computer/security/tgui_data()
	var/list/data = list()
	data["network"] = network
	data["activeCamera"] = null
	if(active_camera)
		data["activeCamera"] = list(
			name = active_camera.c_tag,
			status = active_camera.status,
		)
	return data

/obj/machinery/computer/security/tgui_static_data()
	var/list/data = list()
	data["mapRef"] = map_name
	var/list/cameras = get_available_cameras()
	data["cameras"] = list()
	for(var/i in cameras)
		var/obj/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
		))
	return data

/obj/machinery/computer/security/tgui_act(action, params)
	if(..())
		return

	if(action == "switch_camera")
		var/c_tag = params["name"]
		var/list/cameras = get_available_cameras()
		var/obj/machinery/camera/C = cameras[c_tag]
		active_camera = C
		playsound(src, get_sfx("terminal_type"), 25, FALSE)

		// Show static if can't use the camera
		if(!active_camera?.can_use())
			show_camera_static()
			return TRUE

		var/list/visible_turfs = list()
		for(var/turf/T in (C.isXRay() \
				? range(C.view_range, C) \
				: view(C.view_range, C)))
			visible_turfs += T

		var/list/bbox = get_bbox_of_atoms(visible_turfs)
		var/size_x = bbox[3] - bbox[1] + 1
		var/size_y = bbox[4] - bbox[2] + 1

		cam_screen.vis_contents = visible_turfs
		cam_background.icon_state = "clear"
		cam_background.fill_rect(1, 1, size_x, size_y)

		cam_foreground.fill_rect(1, 1, size_x, size_y)

		local_skybox.cut_overlays()
		local_skybox.add_overlay(SSskybox.get_skybox(get_z(C)))
		local_skybox.scale_to_view(size_x)
		local_skybox.set_position("CENTER", "CENTER", (world.maxx>>1) - C.x, (world.maxy>>1) - C.y)

		return TRUE

// Returns the list of cameras accessible from this computer
/obj/machinery/computer/security/proc/get_available_cameras()
	if(z > 6) // Weird holdover from the old camera console code, not sure why this restriction was in place-- related to is_away_level not existing?
		return list()
	var/list/L = list()
	for(var/obj/machinery/camera/C in cameranet.cameras)
		// if((is_away_level(z) || is_away_level(C.z)) && (C.z != z))//if on away mission, can only receive feed from same z_level cameras
			// continue
		L.Add(C)
	var/list/D = list()
	for(var/obj/machinery/camera/C in L)
		if(!C.network)
			stack_trace("Camera in a cameranet has no camera network")
			continue
		if(!(islist(C.network)))
			stack_trace("Camera in a cameranet has a non-list camera network")
			continue
		var/list/tempnetwork = C.network & network
		if(tempnetwork.len)
			D["[C.c_tag]"] = C
	return D

/obj/machinery/computer/security/attack_hand(mob/user)
	if(stat || ..())
		user.unset_machine()
		return

	tgui_interact(user)

/obj/machinery/computer/security/attack_ai(mob/user)
	to_chat(user, "<span class='notice'>You realise its kind of stupid to access a camera console when you have the entire camera network at your metaphorical fingertips</span>")
	return

/obj/machinery/computer/security/proc/show_camera_static()
	cam_screen.vis_contents.Cut()
	cam_background.icon_state = "scanline2"
	cam_background.fill_rect(1, 1, default_map_size, default_map_size)
	local_skybox.cut_overlays()

//Camera control: arrow keys.
/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon_state = "wallframe"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	icon_keyboard = null
	icon_screen = null
	light_range_on = 0
	network = list(NETWORK_THUNDER)
	density = 0
	circuit = null

/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, why do they never have anything interesting on these things?"
	icon = 'icons/obj/status_display.dmi'
	icon_screen = "entertainment"
	light_color = "#FFEEDB"
	light_range_on = 2
	network = list(NETWORK_THUNDER)
	circuit = /obj/item/weapon/circuitboard/security/telescreen/entertainment
	var/obj/item/device/radio/radio = null

/obj/machinery/computer/security/telescreen/entertainment/Initialize()
	. = ..()
	radio = new(src)
	radio.listening = TRUE
	radio.broadcasting = FALSE
	radio.set_frequency(ENT_FREQ)
	radio.canhear_range = 7 // Same as default sight range.
	power_change()

/obj/machinery/computer/security/telescreen/entertainment/power_change()
	..()
	if(radio)
		if(stat & NOPOWER)
			radio.on = FALSE
		else
			radio.on = TRUE

/obj/machinery/computer/security/wooden_tv
	name = "security camera monitor"
	desc = "An old TV hooked into the station's camera network."
	icon_state = "television"
	icon_keyboard = null
	icon_screen = "detective_tv"
	circuit = /obj/item/weapon/circuitboard/security/tv
	light_color = "#3848B3"
	light_power_on = 0.5

/obj/machinery/computer/security/mining
	name = "outpost camera monitor"
	desc = "Used to watch over mining operations."
	icon_keyboard = "mining_key"
	icon_screen = "mining"
	network = list("Mining Outpost")
	circuit = /obj/item/weapon/circuitboard/security/mining
	light_color = "#F9BBFC"

/obj/machinery/computer/security/engineering
	name = "engineering camera monitor"
	desc = "Used to monitor fires and breaches."
	icon_keyboard = "power_key"
	icon_screen = "engie_cams"
	circuit = /obj/item/weapon/circuitboard/security/engineering
	light_color = "#FAC54B"

/obj/machinery/computer/security/engineering/New()
	if(!network)
		network = engineering_networks.Copy()
	..()

/obj/machinery/computer/security/nuclear
	name = "head mounted camera monitor"
	desc = "Used to access the built-in cameras in helmets."
	icon_state = "syndicam"
	network = list(NETWORK_MERCENARY)
	circuit = null

/obj/machinery/computer/security/nuclear/New()
	..()
	req_access = list(150)