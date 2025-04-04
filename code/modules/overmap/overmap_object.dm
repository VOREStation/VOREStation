/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"

	/// If set to TRUE will show up on ship sensors for detailed scans
	var/scannable
	/// Description for scans
	var/scanner_desc

	/// Icon file to use for skybox
	var/skybox_icon
	/// Icon state to use for skybox
	var/skybox_icon_state
	/// Shift from lower left corner of skybox
	var/skybox_pixel_x
	/// Shift from lower left corner of skybox
	var/skybox_pixel_y
	/// Cachey
	var/image/cached_skybox_image

	/// For showing to the pilot of the ship, so they see the 'real' appearance, despite others seeing the unknown ones
	var/image/real_appearance

	//light_system = MOVABLE_LIGHT
	light_on = FALSE

	///~~If we need to render a map for cameras and helms for this object~~ basically can you look at and use this as a ship or station.
	var/render_map = FALSE

	// Stuff needed to render the map
	var/map_name
	var/obj/screen/map_view/cam_screen
	/// All the plane masters that need to be applied.
	var/list/cam_plane_masters
	var/obj/screen/background/cam_background

/obj/effect/overmap/Initialize(mapload)
	. = ..()
	if(!global.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(render_map) // Initialize map objects
		map_name = "overmap_[REF(src)]_map"
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

		cam_background = new
		cam_background.assigned_map = map_name
		cam_background.del_on_map_removal = FALSE
		update_screen()

/obj/effect/overmap/Destroy()
	real_appearance?.loc = null
	real_appearance = null

	if(cam_screen)
		QDEL_NULL(cam_screen)
	if(cam_plane_masters)
		QDEL_LIST(cam_plane_masters)
	if(cam_background)
		QDEL_NULL(cam_background)

	return ..()

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation(zlevel)
	if(!cached_skybox_image)
		build_skybox_representation(zlevel)
	return cached_skybox_image

/obj/effect/overmap/proc/build_skybox_representation(zlevel)
	if(!skybox_icon)
		return
	var/image/I = image(icon = skybox_icon, icon_state = skybox_icon_state)
	if(isnull(skybox_pixel_x))
		skybox_pixel_x = rand(200,600)
	if(isnull(skybox_pixel_y))
		skybox_pixel_y = rand(200,600)
	I.pixel_x = skybox_pixel_x
	I.pixel_y = skybox_pixel_y
	cached_skybox_image = I

/obj/effect/overmap/proc/expire_skybox_representation()
	cached_skybox_image = null

/obj/effect/overmap/proc/update_skybox_representation()
	expire_skybox_representation()
	build_skybox_representation()
	for(var/obj/effect/overmap/visitable/O in loc)
		SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/proc/get_scan_data(mob/user)
	var/dat = {"\[b\]Scan conducted at\[/b\]: [stationtime2text()] [stationdate2text()]\n\[b\]Grid coordinates\[/b\]: [x],[y]\n\n[scanner_desc]"}

	return dat

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/**
 * Updates the screen object, which is displayed on all connected helms
 */
/obj/effect/overmap/proc/update_screen()
	if(render_map)
		var/list/visible_turfs = list()
		for(var/turf/T in view(4, get_turf(src)))
			visible_turfs += T

		var/list/bbox = get_bbox_of_atoms(visible_turfs)
		var/size_x = bbox[3] - bbox[1] + 1
		var/size_y = bbox[4] - bbox[2] + 1

		cam_screen?.vis_contents = visible_turfs
		cam_background.icon_state = "clear"
		cam_background.fill_rect(1, 1, size_x, size_y)
		return TRUE
