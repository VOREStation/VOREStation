
//Exists to handle a few global variables that change enough to justify this. Technically a parallax, but it exhibits a skybox effect.
SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = INIT_ORDER_SKYBOX
	flags = SS_NO_FIRE
	var/static/list/skybox_cache = list()

	var/static/mutable_appearance/normal_space
	var/static/list/dust_cache = list()
	var/static/list/speedspace_cache = list()
	var/static/list/mapedge_cache = list()
	var/static/list/phase_shift_by_x = list()
	var/static/list/phase_shift_by_y = list()

/datum/controller/subsystem/skybox/PreInit()
	//Shuffle some lists
	phase_shift_by_x = get_cross_shift_list(15)
	phase_shift_by_y = get_cross_shift_list(15)

	//Create our 'normal' space appearance
	normal_space = new()
	normal_space.name = "\proper space"
	normal_space.desc = "Space!"
	normal_space.mouse_opacity = 2 //Always fully opaque. It's SPACE there can't be things BEHIND IT.
	normal_space.appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER
	normal_space.plane = SPACE_PLANE
	normal_space.layer = TURF_LAYER
	normal_space.icon = 'icons/turf/space.dmi'
	normal_space.icon_state = "white"
	
	//Static
	for (var/i in 0 to 25)
		var/mutable_appearance/MA = new(normal_space)
		var/image/im = image('icons/turf/space_dust.dmi', "[i]")
		im.plane = DUST_PLANE
		im.alpha = 128 //80
		im.blend_mode = BLEND_ADD
		
		MA.cut_overlays()
		MA.add_overlay(im)

		dust_cache["[i]"] = MA
	
	//Moving
	for (var/i in 0 to 14)
		// NORTH/SOUTH
		var/mutable_appearance/MA = new(normal_space)
		var/image/im = image('icons/turf/space_dust_transit.dmi', "speedspace_ns_[i]")
		im.plane = DUST_PLANE
		im.blend_mode = BLEND_ADD
		MA.cut_overlays()
		MA.add_overlay(im)
		speedspace_cache["NS_[i]"] = MA
		// EAST/WEST
		MA = new(normal_space)
		im = image('icons/turf/space_dust_transit.dmi', "speedspace_ew_[i]")
		im.plane = DUST_PLANE
		im.blend_mode = BLEND_ADD
		
		MA.cut_overlays()
		MA.add_overlay(im)
		
		speedspace_cache["EW_[i]"] = MA
	
	//Over-the-edge images
	for (var/dir in alldirs)
		var/mutable_appearance/MA = new(normal_space)
		var/matrix/M = matrix()
		var/horizontal = (dir & (WEST|EAST))
		var/vertical = (dir & (NORTH|SOUTH))
		M.Scale(horizontal ? 8 : 1, vertical ? 8 : 1)
		MA.transform = M
		MA.appearance_flags = KEEP_APART | TILE_BOUND
		MA.plane = SPACE_PLANE
		MA.layer = 0

		if(dir & NORTH)
			MA.pixel_y = 112
		else if(dir & SOUTH)
			MA.pixel_y = -112

		if(dir & EAST)
			MA.pixel_x = 112
		else if(dir & WEST)
			MA.pixel_x = -112

		mapedge_cache["[dir]"] = MA

	. = ..()

/datum/controller/subsystem/skybox/Initialize()
	. = ..()

/datum/controller/subsystem/skybox/proc/get_skybox(z)
	if(!subsystem_initialized)
		return // WAIT
	if(!skybox_cache["[z]"])
		skybox_cache["[z]"] = generate_skybox(z)
	return skybox_cache["[z]"]

/datum/controller/subsystem/skybox/proc/generate_skybox(z)
	var/datum/skybox_settings/settings = global.using_map.get_skybox_datum(z)
	
	var/new_overlays = list()
	
	var/image/res = image(settings.icon)
	res.appearance_flags = KEEP_TOGETHER

	var/image/base = image(settings.icon, settings.icon_state)
	base.color = settings.color

	if(settings.use_stars)
		var/image/stars = image(settings.icon, settings.star_state)
		stars.appearance_flags = RESET_COLOR
		base.overlays += stars

	new_overlays += base

	if(global.using_map.use_overmap && settings.use_overmap_details)
		var/obj/effect/overmap/visitable/O = get_overmap_sector(z)
		if(istype(O))
			var/image/self_image = O.generate_skybox(z)
			new_overlays += self_image
			//VOREStation Add
			if(isbelly(O.loc)) // Teehee
				base.icon = 'icons/skybox/skybox_vr.dmi'
				base.icon_state = "flesh"
			//VOREStation Add End
			else
				for(var/obj/effect/overmap/visitable/other in O.loc)
					if(other != O)
						new_overlays += other.get_skybox_representation(z)

	// Allow events to apply custom overlays to skybox! (Awesome!)
	for(var/datum/event/E in SSevents.active_events)
		if(E.has_skybox_image && E.isRunning && (z in E.affecting_z))
			new_overlays += E.get_skybox_image()
	
	for(var/image/I in new_overlays)
		I.appearance_flags |= RESET_COLOR

	res.overlays = new_overlays

	return res

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(var/list/zlevels)
	for(var/z in zlevels)
		skybox_cache["[z]"] = generate_skybox(z)

	for(var/client/C in GLOB.clients)
		var/their_z = get_z(C.mob)
		if(!their_z) //Nullspace
			continue
		if(their_z in zlevels)
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
