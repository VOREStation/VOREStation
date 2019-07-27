var/list/GPS_list = list()

/obj/item/device/gps
	name = "global positioning system"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network. Alt+click to toggle power."
	icon = 'icons/obj/gps.dmi'
	icon_state = "gps-gen"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MATERIAL = 2, TECH_BLUESPACE = 2, TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/gps_tag = "GEN0"
	var/emped = FALSE
	var/tracking = FALSE		// Will not show other signals or emit its own signal if false.
	var/long_range = FALSE		// If true, can see farther, depending on get_map_levels().
	var/local_mode = FALSE		// If true, only GPS signals of the same Z level are shown.
	var/hide_signal = FALSE		// If true, signal is not visible to other GPS devices.
	var/can_hide_signal = FALSE	// If it can toggle the above var.

/obj/item/device/gps/Initialize()
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

 // Compiles all the data not available directly from the GPS
 // Like the positions and directions to all other GPS units
/obj/item/device/gps/proc/display_list()
	var/list/dat = list()

	var/turf/curr = get_turf(src)
	var/area/my_area = get_area(src)

	dat["my_area_name"] = my_area.name
	dat["curr_x"] = curr.x
	dat["curr_y"] = curr.y
	dat["curr_z"] = curr.z
	dat["curr_z_name"] = using_map.get_zlevel_name(curr.z)
	dat["gps_list"] = list()
	dat["z_level_detection"] = using_map.get_map_levels(curr.z, long_range)

	for(var/obj/item/device/gps/G in GPS_list - src)
		if(!G.tracking || G.emped || G.hide_signal)
			continue

		var/turf/T = get_turf(G)
		if(local_mode && curr.z != T.z)
			continue
		if(!(T.z in dat["z_level_detection"]))
			continue

		var/gps_data[0]
		gps_data["ref"] = G
		gps_data["gps_tag"] = G.gps_tag

		var/area/A = get_area(G)
		gps_data["area_name"] = A.name
		if(istype(A, /area/submap))
			gps_data["area_name"] = "Unknown Area" // Avoid spoilers.

		gps_data["z_name"] = using_map.get_zlevel_name(T.z)
		gps_data["direction"] = get_adir(curr, T)
		gps_data["degrees"] = round(Get_Angle(curr,T))
		gps_data["distX"] = T.x - curr.x
		gps_data["distY"] = T.y - curr.y
		gps_data["distance"] = get_dist(curr, T)
		gps_data["local"] = (curr.z == T.z)
		gps_data["x"] = T.x
		gps_data["y"] = T.y

		dat["gps_list"][++dat["gps_list"].len] = gps_data

	return dat

/obj/item/device/gps/proc/display(mob/user)
	if(!tracking)
		to_chat(user, "The device is off. Alt-click it to turn it on.")
		return
	if(emped)
		to_chat(user, "It's busted!")
		return

	var/list/dat = list()
	var/list/gps_data = display_list()

	dat += "Current location: [gps_data["my_area_name"]] <b>([gps_data["curr_x"]], [gps_data["curr_y"]], [gps_data["curr_z_name"]])</b>"
	dat += "[hide_signal ? "Tagged" : "Broadcasting"] as '[gps_tag]'. <a href='?src=\ref[src];tag=1'>\[Change Tag\]</a> \
	<a href='?src=\ref[src];range=1'>\[Toggle Scan Range\]</a> \
	[can_hide_signal ? "<a href='?src=\ref[src];hide=1'>\[Toggle Signal Visibility\]</a>":""]"

	if(gps_data["gps_list"].len)
		dat += "Detected signals;"
		for(var/gps in gps_data["gps_list"])
			if(istype(gps_data["ref"], /obj/item/device/gps/internal/poi))
				dat += "    [gps["gps_tag"]]: [gps["area_name"]] - [gps["local"] ? "[gps["direction"]] Dist: [round(gps["distance"], 10)]m" : "in \the [gps["z_name"]]"]"
			else
				dat += "    [gps["gps_tag"]]: [gps["area_name"]], ([gps["x"]], [gps["y"]]) - [gps["local"] ? "[gps["direction"]] Dist: [gps["distX"] ? "[abs(round(gps["distX"], 1))]m [(gps["distX"] > 0) ? "E" : "W"], " : ""][gps["distY"] ? "[abs(round(gps["distY"], 1))]m [(gps["distY"] > 0) ? "N" : "S"]" : ""]" : "in \the [gps["z_name"]]"]"
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

/obj/item/device/gps/command
	icon_state = "gps-com"
	gps_tag = "COM0"

/obj/item/device/gps/command/on
	tracking = TRUE

/obj/item/device/gps/security
	icon_state = "gps-sec"
	gps_tag = "SEC0"

/obj/item/device/gps/security/on
	tracking = TRUE

/obj/item/device/gps/medical
	icon_state = "gps-med"
	gps_tag = "MED0"

/obj/item/device/gps/medical/on
	tracking = TRUE

/obj/item/device/gps/science
	icon_state = "gps-sci"
	gps_tag = "SCI0"

/obj/item/device/gps/science/on
	tracking = TRUE

/obj/item/device/gps/engineering
	icon_state = "gps-eng"
	gps_tag = "ENG0"

/obj/item/device/gps/engineering/on
	tracking = TRUE

/obj/item/device/gps/mining
	icon_state = "gps-mine"
	gps_tag = "MINE0"
	desc = "A positioning system helpful for rescuing trapped or injured miners, keeping one on you at all times while mining might just save your life. Alt+click to toggle power."

/obj/item/device/gps/mining/on
	tracking = TRUE

/obj/item/device/gps/explorer
	icon_state = "gps-exp"
	gps_tag = "EXP0"
	desc = "A positioning system helpful for rescuing trapped or injured explorers, keeping one on you at all times while exploring might just save your life. Alt+click to toggle power."

/obj/item/device/gps/explorer/on
	tracking = TRUE

/obj/item/device/gps/robot
	icon_state = "gps-borg"
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
	var/list/gps_data = display_list()

	dat += "Current location: [gps_data["my_area_name"]] <b>([gps_data["curr_x"]], [gps_data["curr_y"]], [gps_data["curr_z_name"]])</b>"
	dat += "[hide_signal ? "Tagged" : "Broadcasting"] as '[gps_tag]'. <a href='?src=\ref[src];tag=1'>\[Change Tag\]</a> \
	<a href='?src=\ref[src];range=1'>\[Toggle Scan Range\]</a> \
	[can_hide_signal ? "<a href='?src=\ref[src];hide=1'>\[Toggle Signal Visibility\]</a>":""]"

	if(gps_data["gps_list"].len)
		dat += "Detected signals;"
		for(var/gps in gps_data["gps_list"])
			dat += "     [gps["gps_tag"]]: [gps["area_name"]] ([gps["x"]], [gps["y"]], [gps["z_name"]]) [gps["local"] ? "Dist: [gps["distance"]]m Dir: [gps["degrees"]]° ([gps["direction"]])" :""]"
	else
		dat += "No other signals detected."

	var/result = dat.Join("<br>")
	to_chat(user, result)
