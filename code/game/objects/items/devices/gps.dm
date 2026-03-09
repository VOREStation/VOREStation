GLOBAL_LIST_EMPTY(GPS_list)

/obj/item/gps
	name = "global positioning system"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network. Alt+click to toggle power."
	icon = 'icons/obj/gps.dmi'
	icon_state = "gps-gen"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 2, TECH_MAGNET = 1)
	matter = list(MAT_STEEL = 500)

	var/gps_tag = "GEN0"
	var/emped = FALSE
	var/tracking = FALSE		// Will not show other signals or emit its own signal if false.
	var/long_range = FALSE		// If true, can see farther, depending on get_map_levels().
	var/local_mode = FALSE		// If true, only GPS signals of the same Z level are shown.
	var/hide_signal = FALSE		// If true, signal is not visible to other GPS devices.
	var/can_hide_signal = FALSE	// If it can toggle the above var.

	var/mob/holder
	var/is_in_processing_list = FALSE
	var/list/tracking_devices
	var/list/showing_tracked_names
	var/obj/compass_holder/compass
	var/theme
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

	///Var for attack_self chain
	var/special_handling = FALSE

/obj/item/gps/Initialize(mapload)
	. = ..()
	compass = new(src)
	GLOB.GPS_list += src
	name = "global positioning system ([gps_tag])"
	update_holder()
	update_icon()

/obj/item/gps/proc/check_visible_to_holder()
	. = (holder && (holder.get_active_hand() == src || holder.get_inactive_hand() == src))

/obj/item/gps/proc/update_holder()

	if(holder && loc != holder)
		UnregisterSignal(holder, COMSIG_MOVABLE_ATTEMPTED_MOVE)
		//GLOB.dir_set_event.unregister(holder, src)
		holder.client?.screen -= compass
		holder = null

	if(istype(loc, /mob))
		holder = loc
		RegisterSignal(holder, COMSIG_MOVABLE_ATTEMPTED_MOVE, PROC_REF(update_compass), override = TRUE)
		holder.AddComponent(/datum/component/recursive_move)
		//GLOB.dir_set_event.register(holder, src, PROC_REF(update_compass))

	if(holder && tracking)
		if(!is_in_processing_list)
			START_PROCESSING(SSobj, src)
			is_in_processing_list = TRUE
		if(holder.client)
			if(check_visible_to_holder())
				holder.client.screen |= compass
			else
				holder.client.screen -= compass
	else
		STOP_PROCESSING(SSobj, src)
		is_in_processing_list = FALSE
		if(holder?.client)
			holder.client.screen -= compass

/obj/item/gps/pickup()
	. = ..()
	update_holder()

/obj/item/gps/equipped_robot()
	. = ..()
	update_holder()

/obj/item/gps/equipped()
	. = ..()
	update_holder()

/obj/item/gps/dropped(mob/user)
	. = ..()
	update_holder()

/obj/item/gps/process()
	if(!tracking)
		is_in_processing_list = FALSE
		return PROCESS_KILL
	update_holder()
	if(holder)
		update_compass(src, TRUE)

/obj/item/gps/Destroy()
	STOP_PROCESSING(SSobj, src)
	is_in_processing_list = FALSE
	GLOB.GPS_list -= src
	update_holder()
	QDEL_NULL(compass)
	. = ..()

/obj/item/gps/proc/can_track(var/obj/item/gps/other, var/reachable_z_levels)
	if(!other.tracking || other.emped || other.hide_signal || is_vore_jammed(other))
		return FALSE
	var/turf/origin = get_turf(src)
	var/turf/target = get_turf(other)
	if(!istype(origin) || !istype(target))
		return FALSE
	if(origin.z == target.z)
		return TRUE
	if(local_mode)
		return FALSE
	reachable_z_levels = reachable_z_levels || using_map.get_map_levels(origin.z, long_range)
	return (target.z in reachable_z_levels)

/obj/item/gps/proc/update_compass(atom/movable/source, var/update_compass_icon)
	SIGNAL_HANDLER
	compass.hide_waypoints(FALSE)
	var/turf/my_turf = get_turf(src)
	for(var/thing in tracking_devices)
		var/obj/item/gps/gps = locate(thing)
		if(!istype(gps) || QDELETED(gps))
			LAZYREMOVE(tracking_devices, thing)
			LAZYREMOVE(showing_tracked_names, thing)
			continue
		var/turf/gps_turf = get_turf(gps)
		var/gps_tag = LAZYACCESS(showing_tracked_names, thing) ? gps.gps_tag : null
		if(istype(gps_turf))
			compass.set_waypoint("\ref[gps]", gps_tag, gps_turf.x, gps_turf.y, gps_turf.z, LAZYACCESS(tracking_devices, "\ref[gps]"))
		else
			compass.set_waypoint("\ref[gps]", gps_tag, 0, 0, 0, LAZYACCESS(tracking_devices, "\ref[gps]"))
		if(can_track(gps) && gps_turf && my_turf && gps_turf.z == my_turf.z)
			compass.show_waypoint("\ref[gps]")
	compass.rebuild_overlay_lists(update_compass_icon)

/obj/item/gps/click_alt(mob/user)
	toggletracking(user)

/obj/item/gps/proc/toggletracking(mob/living/user)
	if(!istype(user))
		return
	if(emped)
		to_chat(user, "It's busted!")
		return

	toggle_tracking()
	if(tracking)
		to_chat(user, "[src] is no longer tracking, or visible to other GPS devices.")
	else
		to_chat(user, "[src] is now tracking, and visible to other GPS devices.")

/obj/item/gps/proc/toggle_tracking()
	tracking = !tracking
	if(tracking)
		if(!is_in_processing_list)
			is_in_processing_list = TRUE
			START_PROCESSING(SSobj, src)
			update_compass(src, TRUE)
	else
		is_in_processing_list = FALSE
		STOP_PROCESSING(SSobj, src)
		update_compass(src)
	update_holder()
	update_icon()

/obj/item/gps/emp_act(severity, recursive)
	if(emped) // Without a fancy callback system, this will have to do.
		return
	var/severity_modifier = severity ? severity : 4 // In case emp_act gets called without any arguments.
	var/duration = 5 MINUTES / severity_modifier
	emped = TRUE
	update_icon()

	spawn(duration)
		emped = FALSE
		update_icon()
		visible_message("\The [src] appears to be functional again.")

/obj/item/gps/update_icon()
	cut_overlays()
	if(emped)
		add_overlay("emp")
	else if(tracking)
		add_overlay("working")

/obj/item/gps/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(special_handling)
		return FALSE

	tgui_interact(user)

/obj/item/gps/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/gps/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Gps", name)
		ui.open()

/obj/item/gps/tgui_static_data(mob/user)
	. = ..()
	var/robot_theme
	if(isrobot(loc))
		var/mob/living/silicon/robot/robot_owner = loc
		robot_theme = robot_owner.get_ui_theme()
	.["theme"] = theme || robot_theme

// Compiles all the data not available directly from the GPS
// Like the positions and directions to all other GPS units
/obj/item/gps/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)

	var/turf/curr = get_turf(src)
	var/area/my_area = get_area(src)

	var/list/data = list(
		"currentArea" = strip_improper(my_area.name),
		"power" = tracking,
		"tag" = gps_tag,
		"localMode" = local_mode,
		"currentCoords" = "[curr.x], [curr.y], [curr.z]",
		"currentZName" = strip_improper(using_map.get_zlevel_name(curr.z)),
		"canHide" = can_hide_signal,
		"isHidden" = hide_signal
	)

	var/z_level_det = using_map.get_map_levels(curr.z, long_range)
	var/list/gps_list = list()
	for(var/obj/item/gps/current_gps in GLOB.GPS_list - src)

		if(!can_track(current_gps, z_level_det))
			continue

		var/area/gps_area = get_area(current_gps)
		var/turf/gps_turf = get_turf(current_gps)

		var/is_local = (curr.z == gps_turf.z)
		var/dist = get_dist(curr, gps_turf)
		var/is_poi = istype(current_gps, /obj/item/gps/internal/poi)

		if(is_poi && is_local)
			dist = round(dist, 10)

		var/list/gps_data = list(
			"ref" = "\ref[current_gps]",
			"gpsTag" = current_gps.gps_tag,
			"areaName" = strip_improper(gps_area.get_name()),
			"zName" = strip_improper(using_map.get_zlevel_name(gps_turf.z)),
			"local" = is_local,
			"trackingColor" = LAZYACCESS(tracking_devices, "\ref[current_gps]"),
			"trackingName" = LAZYACCESS(showing_tracked_names, "\ref[current_gps]"),
		)

		if(!is_poi || is_local)
			gps_data["degrees"] = round(Get_Angle(curr, gps_turf))
			gps_data["coords"] = "[gps_turf.x], [gps_turf.y], [gps_turf.z]"
			gps_data["dist"] = dist

		UNTYPED_LIST_ADD(gps_list, gps_data)

	data["signals"] = gps_list

	return data

/obj/item/gps/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			toggle_tracking()
			return TRUE
		if("rename")
			var/new_name = sanitize(params["value"], 11)
			if(!new_name)
				return FALSE
			gps_tag = uppertext(new_name)
			name = "global positioning system ([gps_tag])"
			return TRUE
		if("localMode")
			local_mode = !local_mode
			return TRUE
		if("hideSignal")
			if(!can_hide_signal)
				return FALSE
			hide_signal = !hide_signal
			return TRUE
		if("trackLabel")
			var/gps_ref = params["ref"]
			if(!gps_ref)
				return FALSE
			var/obj/item/gps/gps = locate(gps_ref)
			if(istype(gps) && !QDELETED(gps) && !LAZYACCESS(showing_tracked_names, gps_ref))
				LAZYSET(showing_tracked_names, gps_ref, TRUE)
			else
				LAZYREMOVE(showing_tracked_names, gps_ref)
			return TRUE
		if("stopTrack")
			var/gps_ref = params["ref"]
			if(!gps_ref)
				return FALSE
			compass.clear_waypoint(gps_ref)
			LAZYREMOVE(tracking_devices, gps_ref)
			LAZYREMOVE(showing_tracked_names, gps_ref)
			update_compass(src, TRUE)
			return TRUE
		if("startTrack")
			var/gps_ref = params["ref"]
			if(!gps_ref)
				return FALSE
			var/obj/item/gps/gps = locate(gps_ref)
			if(!istype(gps) || QDELETED(gps))
				return FALSE
			LAZYSET(tracking_devices, gps_ref, "#00ffff")
			LAZYSET(showing_tracked_names, gps_ref, TRUE)
			update_compass(src, TRUE)
			return TRUE
		if("trackColor")
			var/gps_ref = params["ref"]
			if(!gps_ref)
				return FALSE
			var/obj/item/gps/gps = locate(gps_ref)
			if(!istype(gps) || QDELETED(gps))
				return FALSE
			var/new_colour = sanitize_hexcolor(params["color"])
			if(!new_colour)
				return FALSE
			LAZYSET(tracking_devices, gps_ref, new_colour)
			update_compass(src, TRUE)
			return TRUE

/obj/item/gps/on // Defaults to off to avoid polluting the signal list with a bunch of GPSes without owners. If you need to spawn active ones, use these.
	tracking = TRUE

/obj/item/gps/command
	icon_state = "gps-com"
	gps_tag = "COM0"

/obj/item/gps/command/on
	tracking = TRUE

/obj/item/gps/security
	icon_state = "gps-sec"
	gps_tag = "SEC0"

/obj/item/gps/security/on
	tracking = TRUE

/obj/item/gps/security/hos
	icon_state = "gps-sec-hos"
	gps_tag = "HOS0"

/obj/item/gps/security/hos/on
	tracking = TRUE

/obj/item/gps/medical
	icon_state = "gps-med"
	gps_tag = "MED0"

/obj/item/gps/medical/on
	tracking = TRUE

/obj/item/gps/medical/cmo
	icon_state = "gps-med-cmo"
	gps_tag = "CMO0"

/obj/item/gps/medical/cmo/on
	tracking = TRUE

/obj/item/gps/science
	icon_state = "gps-sci"
	gps_tag = "SCI0"

/obj/item/gps/science/on
	tracking = TRUE

/obj/item/gps/science/rd
	icon_state = "gps-sci-rd"
	gps_tag = "RD0"

/obj/item/gps/science/rd/on
	tracking = TRUE

/obj/item/gps/engineering
	icon_state = "gps-eng"
	gps_tag = "ENG0"

/obj/item/gps/engineering/on
	tracking = TRUE

/obj/item/gps/engineering/atmos
	icon_state = "gps-eng-atm"
	gps_tag = "ATM0"

/obj/item/gps/engineering/atmos/on
	tracking = TRUE

/obj/item/gps/engineering/ce
	icon_state = "gps-eng-ce"
	gps_tag = "CE0"

/obj/item/gps/engineering/ce/on
	tracking = TRUE

/obj/item/gps/mining
	icon_state = "gps-mine"
	gps_tag = "MINE0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life. Alt+click to toggle power."

/obj/item/gps/mining/on
	tracking = TRUE

/obj/item/gps/explorer
	icon_state = "gps-exp"
	gps_tag = "EXP0"
	desc = "A positioning system helpful for rescuing trapped or injured explorers, keeping one on you at all times while exploring might just save your life. Alt+click to toggle power."

/obj/item/gps/explorer/on
	tracking = TRUE

/obj/item/gps/robot
	icon_state = "gps-borg"
	gps_tag = "SYNTH0"
	desc = "A synthetic internal positioning system. Used as a recovery beacon for damaged synthetic assets, or a collaboration tool for mining or exploration teams. \
	Alt+click to toggle power."
	tracking = TRUE // On by default.

/obj/item/gps/internal // Base type for immobile/internal GPS units.
	icon_state = "internal"
	gps_tag = "Eerie Signal"
	desc = "Report to a coder immediately."
	invisibility = INVISIBILITY_MAXIMUM
	tracking = TRUE // Meant to point to a location, so it needs to be on.
	anchored = TRUE

/obj/item/gps/internal/base
	gps_tag = "NT_BASE"
	desc = "A homing signal from NanoTrasen's outpost."

/obj/item/gps/internal/poi
	gps_tag = "Unidentified Signal"
	desc = "A signal that seems forboding."

/obj/item/gps/syndie
	icon_state = "gps-syndie"
	gps_tag = "NULL"
	desc = "A positioning system that has extended range and can detect other GPS device signals without revealing its own. How that works is best left a mystery. Alt+click to toggle power."
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	long_range = TRUE
	hide_signal = TRUE
	can_hide_signal = TRUE
	theme = "syndicate"
