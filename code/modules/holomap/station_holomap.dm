//
// Wall mounted holomap of the station
//
/obj/machinery/station_map
	name = "station holomap"
	desc = "A virtual map of the surrounding station."
	icon = 'icons/obj/machines/stationmap.dmi'
	icon_state = "station_map"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	density = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 500
	circuit = /obj/item/circuitboard/station_map
	vis_flags = VIS_HIDE // They have an emissive that looks bad in openspace due to their wall-mounted nature

	// TODO - Port use_auto_lights from /vg - for now declare here
	var/use_auto_lights = 1
	var/light_power_on = 1
	var/light_range_on = 2
	light_color = "#64C864"

	var/mob/watching_mob = null
	var/image/small_station_map = null
	var/image/floor_markings = null
	var/image/panel = null

	var/original_zLevel = 1	// zLevel on which the station map was initialized.
	var/bogus = TRUE		// set to 0 when you initialize the station map on a zLevel that has its own icon formatted for use by station holomaps.
	var/datum/station_holomap/holomap_datum

/obj/machinery/station_map/New()
	..()
	flags |= ON_BORDER // Why? It doesn't help if its not density

/obj/machinery/station_map/Initialize()
	. = ..()
	holomap_datum = new()
	original_zLevel = loc.z
	SSholomaps.station_holomaps += src
	if(SSholomaps.holomaps_initialized)
		setup_holomap()

/obj/machinery/station_map/Destroy()
	SSholomaps.station_holomaps -= src
	stopWatching()
	holomap_datum = null
	. = ..()

/obj/machinery/station_map/proc/setup_holomap()
	bogus = FALSE
	var/turf/T = get_turf(src)
	original_zLevel = T.z
	if(!("[HOLOMAP_EXTRA_STATIONMAP]_[original_zLevel]" in SSholomaps.extraMiniMaps))
		bogus = TRUE
		holomap_datum.initialize_holomap_bogus()
		update_icon()
		return

	holomap_datum.initialize_holomap(T, reinit = TRUE)

	small_station_map = image(SSholomaps.extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[original_zLevel]"], dir = dir)

	floor_markings = image('icons/obj/machines/stationmap.dmi', "decal_station_map")
	floor_markings.dir = src.dir

	spawn(1) //When built from frames, need to allow time for it to set pixel_x and pixel_y
		update_icon()

/obj/machinery/station_map/attack_hand(var/mob/user)
	if(watching_mob && (watching_mob != user))
		to_chat(user, span_warning("Someone else is currently watching the holomap."))
		return
	if(user.loc != loc)
		to_chat(user, span_warning("You need to stand in front of \the [src]."))
		return
	startWatching(user)

// Let people bump up against it to watch
/obj/machinery/station_map/Bumped(var/atom/movable/AM)
	if(!watching_mob && isliving(AM) && AM.loc == loc)
		startWatching(AM)

/obj/machinery/station_map/Uncross(atom/movable/mover, turf/target)
	if(get_dir(mover, target) == reverse_dir[dir])
		return FALSE
	return TRUE
/obj/machinery/station_map/proc/startWatching(var/mob/user)
	// Okay, does this belong on a screen thing or what?
	// One argument is that this is an "in game" object becuase its in the world.
	// But I think it actually isn't.  The map isn't holo projected into the whole room, (maybe strat one is!)
	// But for this, the on screen object just represents you leaning in and looking at it closely.
	// So it SHOULD be a screen object.
	// But it is not QUITE a hud either.  So I think it shouldn't go in /datum/hud
	// Okay? Yeah.  Lets use screen objects but manage them manually here in the item.
	// That might be a mistake... I'd rather they be managed by some central hud management system.
	// But the /vg code, while the screen obj is managed, its still adding and removing image, so this is
	// just as good.

	// EH JUST HACK IT FOR NOW SO WE CAN SEE HOW IT LOOKS! STOP OBSESSING, ITS BEEN AN HOUR NOW!

	// TODO - This part!! ~Leshana
	if(isliving(user) && anchored && !(stat & (NOPOWER|BROKEN)))
		if(user.client)
			holomap_datum.station_map.loc = global_hud.holomap  // Put the image on the holomap hud
			holomap_datum.station_map.alpha = 0 // Set to transparent so we can fade in
			animate(holomap_datum.station_map, alpha = 255, time = 5, easing = LINEAR_EASING)
			flick("station_map_activate", src)
			// Wait, if wea re not modifying the holomap_obj... can't it be part of the global hud?
			user.client.screen |= global_hud.holomap // TODO - HACK! This should be there permenently really.
			user.client.images |= holomap_datum.station_map

			watching_mob = user
			watching_mob.AddComponent(/datum/component/recursive_move)
			RegisterSignal(watching_mob, COMSIG_OBSERVER_MOVED, /obj/machinery/station_map/proc/checkPosition)
			//GLOB.dir_set_event.register(watching_mob, src, /obj/machinery/station_map/proc/checkPosition)
			RegisterSignal(watching_mob, COMSIG_OBSERVER_DESTROYED, /obj/machinery/station_map/proc/stopWatching)
			update_use_power(USE_POWER_ACTIVE)

			if(bogus)
				to_chat(user, span_warning("The holomap failed to initialize. This area of space cannot be mapped."))
			else
				to_chat(user, span_notice("A hologram of the station appears before your eyes."))

/obj/machinery/station_map/attack_ai(var/mob/living/silicon/robot/user)
	return // TODO - Implement for AI ~Leshana
	// user.station_holomap.toggleHolomap(user, isAI(user))

/obj/machinery/station_map/process()
	if((stat & (NOPOWER|BROKEN)) || !anchored)
		stopWatching()

/obj/machinery/station_map/proc/checkPosition()
	if(!watching_mob || (watching_mob.loc != loc) || (dir != watching_mob.dir))
		stopWatching()

/obj/machinery/station_map/proc/stopWatching()
	if(watching_mob)
		if(watching_mob.client)
			animate(holomap_datum.station_map, alpha = 0, time = 5, easing = LINEAR_EASING)
			var/mob/M = watching_mob
			spawn(5) //we give it time to fade out
				M.client.images -= holomap_datum.station_map
		UnregisterSignal(watching_mob, COMSIG_OBSERVER_MOVED)
		//GLOB.dir_set_event.unregister(watching_mob, src)
		UnregisterSignal(watching_mob, COMSIG_OBSERVER_DESTROYED)
	watching_mob = null
	update_use_power(USE_POWER_IDLE)

/obj/machinery/station_map/power_change()
	. = ..()
	update_icon()
	// TODO - Port use_auto_lights from /vg - For now implement it manually here
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on)

/obj/machinery/station_map/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/station_map/update_icon()
	if(!holomap_datum)
		return //Not yet.

	cut_overlays()
	if(stat & BROKEN)
		icon_state = "station_mapb"
	else if((stat & NOPOWER) || !anchored)
		icon_state = "station_map0"
	else
		icon_state = "station_map"

		if(bogus)
			holomap_datum.initialize_holomap_bogus()
		else
			small_station_map = image(SSholomaps.extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[original_zLevel]"], dir = src.dir)
			add_overlay(small_station_map)
			holomap_datum.initialize_holomap(get_turf(src))

	// Put the little "map" overlay down where it looks nice
	if(floor_markings)
		floor_markings.dir = src.dir
		floor_markings.pixel_x = -src.pixel_x
		floor_markings.pixel_y = -src.pixel_y
		add_overlay(floor_markings)

	if(panel_open)
		add_overlay("station_map-panel")
	else
		cut_overlay("station_map-panel")

/obj/machinery/station_map/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	return ..()

/obj/machinery/station_map/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(50))
				qdel(src)
			else
				set_broken()
		if(3)
			if (prob(25))
				set_broken()

/datum/frame/frame_types/station_map
	name = "Station Map Frame"
	frame_class = "display"
	frame_size = 3
	frame_style = "wall"
	x_offset = WORLD_ICON_SIZE
	y_offset = WORLD_ICON_SIZE
	circuit = /obj/item/circuitboard/station_map
	icon_override = 'icons/obj/machines/stationmap.dmi'

/datum/frame/frame_types/station_map/get_icon_state(var/state)
	return "station_map_frame_[state]"

/obj/structure/frame
	layer = ABOVE_WINDOW_LAYER

/obj/item/circuitboard/station_map
	name = T_BOARD("Station Map")
	board_type = new /datum/frame/frame_types/station_map
	build_path = /obj/machinery/station_map
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	req_components = list()

/datum/holomap_marker
	var/x
	var/y
	var/z
	var/offset_x = -8
	var/offset_y = -8
	var/filter
	var/id // used for icon_state of the marker on maps
	var/icon = 'icons/holomap_markers.dmi'
	var/color //used by path rune markers

/obj/effect/landmark/holomarker
	delete_me = TRUE

	var/filter = HOLOMAP_FILTER_STATIONMAP
	var/id = "generic"

/obj/effect/landmark/holomarker/Initialize()
	. = ..()
	var/datum/holomap_marker/holomarker = new()
	holomarker.id = id
	holomarker.filter = filter
	holomarker.x = src.x
	holomarker.y = src.y
	holomarker.z = src.z
	holomap_markers["[id]_\ref[src]"] = holomarker
