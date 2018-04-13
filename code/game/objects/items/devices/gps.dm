var/list/GPS_list = list()

/obj/item/device/gps
	name = "global positioning system"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network. Alt+click to toggle power."
	icon = 'icons/obj/gps.dmi'
	icon_state = "gps-c"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 2, TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/gps_tag = "COM0"
	var/emped = FALSE
	var/tracking = FALSE		// Will not show other signals or emit its own signal if false.
	var/long_range = FALSE		// If true, can see farther, depending on get_map_levels().
	var/local_mode = FALSE		// If true, only GPS signals of the same Z level are shown.
	var/hide_signal = FALSE		// If true, signal is not visible to other GPS devices.
	var/can_hide_signal = FALSE	// If it can toggle the above var.

/obj/item/device/gps/initialize()
	. = ..()
	GPS_list += src
	name = "global positioning system ([gps_tag])"
	update_icon()

/obj/item/device/gps/Destroy()
	GPS_list -= src
	return ..()

/obj/item/device/gps/AltClick(mob/user)
	toggletracking(user)

/obj/item/device/gps/proc/toggletracking(mob/living/user)
	if(!istype(user))
		return
	if(emped)
		to_chat(user, "It's busted!")
		return
	if(tracking)
		to_chat(user, "[src] is no longer tracking, or visible to other GPS devices.")
		tracking = FALSE
		update_icon()
	else
		to_chat(user, "[src] is now tracking, and visible to other GPS devices.")
		tracking = TRUE
		update_icon()

/obj/item/device/gps/emp_act(severity)
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

/obj/item/device/gps/update_icon()
	overlays.Cut()
	if(emped)
		overlays += image(icon, src, "emp")
	else if(tracking)
		overlays += image(icon, src, "working")

/obj/item/device/gps/attack_self(mob/user)
	display(user)

/obj/item/device/gps/proc/display(mob/user)
	if(!tracking)
		to_chat(user, "The device is off. Alt-click it to turn it on.")
		return
	if(emped)
		to_chat(user, "It's busted!")
		return

	var/list/dat = list()

	var/turf/curr = get_turf(src)
	var/area/my_area = get_area(src)
	dat += "Current location: [my_area.name] <b>([curr.x], [curr.y], [using_map.get_zlevel_name(curr.z)])</b>"
	dat += "[hide_signal ? "Tagged" : "Broadcasting"] as '[gps_tag]'. <a href='?src=\ref[src];tag=1'>\[Change Tag\]</a> \
	<a href='?src=\ref[src];range=1'>\[Toggle Scan Range\]</a> \
	[can_hide_signal ? "<a href='?src=\ref[src];hide=1'>\[Toggle Signal Visibility\]</a>":""]"

	var/list/signals = list()

	for(var/gps in GPS_list)
		var/obj/item/device/gps/G = gps
		if(G.emped || !G.tracking || G.hide_signal || G == src) // Their GPS isn't on or functional.
			continue
		var/turf/T = get_turf(G)
		var/z_level_detection = using_map.get_map_levels(curr.z, long_range)

		if(local_mode && T.z != curr.z) // Only care about the current z-level.
			continue
		else if(!(T.z in z_level_detection)) // Too far away.
			continue

		var/area/their_area = get_area(G)
		var/area_name = their_area.name
		if(istype(their_area, /area/submap))
			area_name = "Unknown Area" // Avoid spoilers.
		var/Z_name = using_map.get_zlevel_name(T.z)
		var/direction = get_adir(curr, T)
		var/distX = T.x - curr.x
		var/distY = T.y - curr.y
		var/distance = get_dist(curr, T)
		var/local = curr.z == T.z ? TRUE : FALSE

		if(istype(gps, /obj/item/device/gps/internal/poi))
			signals += "    [G.gps_tag]: [area_name] - [local ? "[direction] Dist: [round(distance, 10)]m" : "in \the [Z_name]"]"
		else
			signals += "    [G.gps_tag]: [area_name], ([T.x], [T.y]) - [local ? "[direction] Dist: [distX ? "[abs(round(distX, 1))]m [(distX > 0) ? "E" : "W"], " : ""][distY ? "[abs(round(distY, 1))]m [(distY > 0) ? "N" : "S"]" : ""]" : "in \the [Z_name]"]"

	if(signals.len)
		dat += "Detected signals;"
		for(var/line in signals)
			dat += line
	else
		dat += "No other signals detected."

	var/result = dat.Join("<br>")
	to_chat(user, result)

/obj/item/device/gps/Topic(var/href, var/list/href_list)
	if(..())
		return 1

	if(href_list["tag"])
		var/a = input("Please enter desired tag.", name, gps_tag) as text
		a = uppertext(copytext(sanitize(a), 1, 11))
		if(in_range(src, usr))
			gps_tag = a
			name = "global positioning system ([gps_tag])"
			to_chat(usr, "You set your GPS's tag to '[gps_tag]'.")

	if(href_list["range"])
		local_mode = !local_mode
		to_chat(usr, "You set the signal receiver to [local_mode ? "'NARROW'" : "'BROAD'"].")

	if(href_list["hide"])
		if(!can_hide_signal)
			return
		hide_signal = !hide_signal
		to_chat(usr, "You set the device to [hide_signal ? "not " : ""]broadcast a signal while scanning for other signals.")

/obj/item/device/gps/on // Defaults to off to avoid polluting the signal list with a bunch of GPSes without owners. If you need to spawn active ones, use these.
	tracking = TRUE

/obj/item/device/gps/science
	icon_state = "gps-s"
	gps_tag = "SCI0"

/obj/item/device/gps/science/on
	tracking = TRUE

/obj/item/device/gps/engineering
	icon_state = "gps-e"
	gps_tag = "ENG0"

/obj/item/device/gps/engineering/on
	tracking = TRUE

/obj/item/device/gps/mining
	icon_state = "gps-m"
	gps_tag = "MINE0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life. Alt+click to toggle power."

/obj/item/device/gps/mining/on
	tracking = TRUE

/obj/item/device/gps/explorer
	icon_state = "gps-ex"
	gps_tag = "EX0"
	desc = "A positioning system helpful for rescuing trapped or injured explorers, keeping one on you at all times while exploring might just save your life. Alt+click to toggle power."

/obj/item/device/gps/explorer/on
	tracking = TRUE

/obj/item/device/gps/robot
	icon_state = "gps-b"
	gps_tag = "SYNTH0"
	desc = "A synthetic internal positioning system. Used as a recovery beacon for damaged synthetic assets, or a collaboration tool for mining or exploration teams. \
	Alt+click to toggle power."
	tracking = TRUE // On by default.

/obj/item/device/gps/internal // Base type for immobile/internal GPS units.
	icon_state = "internal"
	gps_tag = "Eerie Signal"
	desc = "Report to a coder immediately."
	invisibility = INVISIBILITY_MAXIMUM
	tracking = TRUE // Meant to point to a location, so it needs to be on.
	anchored = TRUE

/obj/item/device/gps/internal/base
	gps_tag = "NT_BASE"
	desc = "A homing signal from NanoTrasen's outpost."

/obj/item/device/gps/internal/poi
	gps_tag = "Unidentified Signal"
	desc = "A signal that seems forboding."

/obj/item/device/gps/syndie
	icon_state = "gps-syndie"
	gps_tag = "NULL"
	desc = "A positioning system that has extended range and can detect other GPS device signals without revealing its own. How that works is best left a mystery. Alt+click to toggle power."
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	long_range = TRUE
	hide_signal = TRUE
	can_hide_signal = TRUE

/obj/item/device/gps/syndie/display(mob/user)
	if(!tracking)
		to_chat(user, "The device is off. Alt-click it to turn it on.")
		return
	if(emped)
		to_chat(user, "It's busted!")
		return

	var/list/dat = list()

	var/turf/curr = get_turf(src)
	var/area/my_area = get_area(src)
	dat += "Current location: [my_area.name] <b>([curr.x], [curr.y], [using_map.get_zlevel_name(curr.z)])</b>"
	dat += "[hide_signal ? "Tagged" : "Broadcasting"] as '[gps_tag]'. <a href='?src=\ref[src];tag=1'>\[Change Tag\]</a> \
	<a href='?src=\ref[src];range=1'>\[Toggle Scan Range\]</a> \
	[can_hide_signal ? "<a href='?src=\ref[src];hide=1'>\[Toggle Signal Visibility\]</a>":""]"

	var/list/signals = list()

	for(var/gps in GPS_list)
		var/obj/item/device/gps/G = gps
		if(G.emped || !G.tracking || G.hide_signal || G == src) // Their GPS isn't on or functional.
			continue
		var/turf/T = get_turf(G)
		var/z_level_detection = using_map.get_map_levels(curr.z, long_range)

		if(local_mode && T.z != curr.z) // Only care about the current z-level.
			continue
		else if(!(T.z in z_level_detection)) // Too far away.
			continue

		var/area/their_area = get_area(G)
		var/area_name = their_area.name
		if(istype(their_area, /area/submap))
			area_name = "Unknown Area" // Avoid spoilers.
		var/Z_name = using_map.get_zlevel_name(T.z)
		var/coord = "[T.x], [T.y], [Z_name]"
		var/degrees = round(Get_Angle(curr, T))
		var/direction = get_adir(curr, T)
		var/distance = get_dist(curr, T)
		var/local = curr.z == T.z ? TRUE : FALSE

		signals += "     [G.gps_tag]: [area_name] ([coord]) [local ? "Dist: [distance]m Dir: [degrees]° ([direction])":""]"

	if(signals.len)
		dat += "Detected signals;"
		for(var/line in signals)
			dat += line
	else
		dat += "No other signals detected."

	var/result = dat.Join("<br>")
	to_chat(user, result)
