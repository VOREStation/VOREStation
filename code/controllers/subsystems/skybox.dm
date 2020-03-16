
//Exists to handle a few global variables that change enough to justify this. Technically a parallax, but it exhibits a skybox effect.
SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = INIT_ORDER_SKYBOX
	flags = SS_NO_FIRE
	var/list/skybox_cache = list()

/datum/controller/subsystem/skybox/Initialize()
	. = ..()

/datum/controller/subsystem/skybox/Recover()
	skybox_cache = SSskybox.skybox_cache

/datum/controller/subsystem/skybox/proc/get_skybox(z)
	if(!skybox_cache["[z]"])
		skybox_cache["[z]"] = generate_skybox(z)
		if(global.using_map.use_overmap)
			var/obj/effect/overmap/visitable/O = map_sectors["[z]"]
			if(istype(O))
				for(var/zlevel in O.map_z)
					skybox_cache["[zlevel]"] = skybox_cache["[z]"]
	return skybox_cache["[z]"]

/datum/controller/subsystem/skybox/proc/generate_skybox(z)
	var/datum/skybox_settings/settings = global.using_map.get_skybox_datum(z)

	var/image/res = image(settings.icon)
	res.appearance_flags = KEEP_TOGETHER

	var/image/base = image(settings.icon, settings.icon_state)
	//base.color = background_color

	if(settings.use_stars)
		var/image/stars = image(settings.icon, settings.star_state)
		stars.appearance_flags = RESET_COLOR
		base.overlays += stars

	res.overlays += base

	if(global.using_map.use_overmap && settings.use_overmap_details)
		var/obj/effect/overmap/visitable/O = map_sectors["[z]"]
		if(istype(O))
			var/image/overmap = image(settings.icon_state)
			overmap.overlays += O.generate_skybox()
			for(var/obj/effect/overmap/visitable/other in O.loc)
				if(other != O)
					overmap.overlays += other.get_skybox_representation()
			overmap.appearance_flags = RESET_COLOR
			res.overlays += overmap

	// TODO - Allow events to apply custom overlays to skybox! (Awesome!)
	//for(var/datum/event/E in SSevent.active_events)
	//	if(E.has_skybox_image && E.isRunning && (z in E.affecting_z))
	//		res.overlays += E.get_skybox_image()

	return res

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(var/list/zlevels)
	for(var/z in zlevels)
		skybox_cache["[z]"] = generate_skybox(z)

	for(var/client/C)
		C.update_skybox(1)

// Settings datum that maps can override to play with their skyboxes
/datum/skybox_settings
	var/icon = 'icons/skybox/skybox.dmi' //Path to our background. Lets us use anything we damn well please. Skyboxes need to be 736x736
	var/icon_state = "dyable"
	var/color
	var/random_color = FALSE
	
	var/use_stars = TRUE
	var/star_icon = 'icons/skybox/skybox.dmi'
	var/star_state = "stars"

	var/use_overmap_details = TRUE //Do we try to draw overmap visitables in our sector on the map?

/datum/skybox_settings/New()
	..()
	if(random_color)
		color = rgb(rand(0,255), rand(0,255), rand(0,255))
