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

/obj/effect/overmap/Initialize()
	. = ..()
	if(!global.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

/obj/effect/overmap/Destroy()
	real_appearance?.loc = null
	real_appearance = null
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
