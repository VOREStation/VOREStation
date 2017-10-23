//This shuttle traverses a "web" of route_datums to have a wider range of places to go and make flying feel like movement is actually occuring.
/datum/shuttle/web_shuttle
	flags = SHUTTLE_FLAGS_NONE
	var/cloaked = FALSE
	var/can_cloak = FALSE
	var/cooldown = 5 SECONDS
	var/last_move = 0	//the time at which we last moved
	var/area/current_area = null
	var/datum/shuttle_web_master/web_master = null
	var/web_master_type = null
	var/flight_time_modifier = 1.0
	category = /datum/shuttle/web_shuttle

/datum/shuttle/web_shuttle/New()
	current_area = locate(current_area)
	web_master = new web_master_type(src)
	build_destinations()
	..()

/datum/shuttle/web_shuttle/Destroy()
	qdel(web_master)
	return ..()


/datum/shuttle/web_shuttle/current_dock_target()
	if(web_master)
		return web_master.current_dock_target()

/datum/shuttle/web_shuttle/move(var/area/origin, var/area/destination)
	..()
	last_move = world.time

/datum/shuttle/web_shuttle/on_shuttle_departure()
	web_master.on_shuttle_departure()

/datum/shuttle/web_shuttle/on_shuttle_arrival()
	web_master.on_shuttle_arrival()

/datum/shuttle/web_shuttle/proc/build_destinations()
	return

/obj/machinery/computer/shuttle_control/web
	name = "flight computer"
	icon_state = "flightcomp_center"
	icon_keyboard = "flight_center_key"
	icon_screen = "flight_center"

// Fairly copypasta-y.
/obj/machinery/computer/shuttle_control/web/attack_hand(mob/user)
	if(..(user))
		return
	src.add_fingerprint(user)

	ui_interact(user)

	/*
	// If nanoUI falls over and you want a non-nanoUI UI, feel free to uncomment this section.
	var/datum/shuttle/web_shuttle/WS = shuttle_controller.shuttles[shuttle_tag]
	if(!istype(WS))
		message_admins("ERROR: Shuttle computer ([src]) ([shuttle_tag]) could not find their shuttle in the shuttles list.")
		return

	var/list/dat = list()
	dat += "<center>[shuttle_tag] Ship Control<hr>"

	if(WS.moving_status != SHUTTLE_IDLE)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		var/area/areacheck = get_area(src)
		dat += "Location: [areacheck.name]<br>"

		if((WS.last_move + WS.cooldown) > world.time)
			dat += "<font color='red'>Engines charging.</font><br>"
		else
			dat += "<font color='green'>Engines ready.</font><br>"

		if(WS.can_cloak)
			dat += "<br><b><A href='?src=\ref[src];toggle_cloak=[1]'>Toggle cloaking field</A></b><br>"

		for(var/datum/shuttle_route/route in WS.current_destination.routes)
			dat += "<b><a href='?src=\ref[src];traverse=\ref[route]'>[route.display_route(WS.current_destination)]</a></b><br>"


	//Docking
		dat += "<br><br>"
		if(WS.skip_docking_checks())
			dat += "Docking Status: <font color='grey'>Not in use.</font>"
		else
			var/override_en = WS.docking_controller.override_enabled
			var/docking_status = WS.docking_controller.get_docking_status()

			dat += "Docking Status: "
			switch(docking_status)
				if("undocked")
					dat += "<font color='[override_en? "red" : "grey"]'>Undocked</font>"
				if("docking")
					dat += "<font color='[override_en? "red" : "yellow"]'>Docking</font>"
				if("undocking")
					dat += "<font color='[override_en? "red" : "yellow"]'>Undocking</font>"
				if("docked")
					dat += "<font color='[override_en? "red" : "green"]'>Docked</font>"

			if(override_en)
				dat += " <font color='red'>(Override Enabled)</font>"

			dat += ". <A href='?src=\ref[src];refresh=[1]'>\[Refresh\]</A><br><br>"

			switch(docking_status)
				if("undocked")
					dat += "<b><A href='?src=\ref[src];dock_command=[1]'>Dock</A></b>"
				if("docked")
					dat += "<b><A href='?src=\ref[src];undock_command=[1]'>Undock</A></b>"
		dat += "</center>"

	user << browse(dat.Join(), "window=[shuttle_tag]shuttlecontrol;size=300x300")
	*/


/obj/machinery/computer/shuttle_control/web/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/list/routes[0]
	var/datum/shuttle/web_shuttle/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if(!istype(shuttle))
		return

	var/list/R = shuttle.web_master.get_available_routes()
	for (var/i = 1 to length(R))
		var/datum/shuttle_route/route = R[i]
		var/travel_time = null
		var/travel_modifier = shuttle.flight_time_modifier
		if(route.travel_time == 0)
			travel_time = "Instant"
		else if( (route.travel_time * travel_modifier) >= 1 MINUTE)
			travel_time = "[ (route.travel_time * travel_modifier) / (1 MINUTE)] minute\s"
		else
			travel_time = "[ (route.travel_time * travel_modifier) / (1 SECOND)] second\s"
		routes.Add(list(list("name" = html_encode(capitalize(route.display_route(shuttle.web_master.current_destination) )), "index" = i, "travel_time" = travel_time)))


	var/shuttle_location = shuttle.web_master.current_destination.name // Destination related, not loc.
	var/future_location = null
	if(shuttle.web_master.future_destination)
		future_location = shuttle.web_master.future_destination.name

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE)
			shuttle_state = "idle"
		if(SHUTTLE_WARMUP)
			shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT)
			shuttle_state = "in_transit"


	// For the progress bar.
	var/elapsed_time = world.time - shuttle.depart_time
	var/total_time = shuttle.arrive_time - shuttle.depart_time
	var/percent_finished = 0

	if(total_time) // Need to check or we might divide by zero.
		percent_finished = (elapsed_time / total_time) * 100

	data = list(
		"shuttle_location" = shuttle_location,
		"future_location" = future_location,
		"shuttle_state" = shuttle_state,
		"routes" = routes,
		"has_docking" = shuttle.docking_controller? 1 : 0,
		"skip_docking" = shuttle.skip_docking_checks(),
		"is_moving" = shuttle.moving_status != SHUTTLE_IDLE,
		"docking_status" = shuttle.docking_controller? shuttle.docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.docking_controller? shuttle.docking_controller.override_enabled : null,
		"is_in_transit" = shuttle.has_arrive_time(),
		"travel_progress" = between(0, percent_finished, 100),
		"time_left" = round( (total_time - elapsed_time) / 10),
		"can_cloak" = shuttle.can_cloak ? 1 : 0,
		"cloaked" = shuttle.cloaked ? 1 : 0
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "flight.tmpl", "[shuttle_tag] Flight Computer", 470, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/computer/shuttle_control/web/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/datum/shuttle/web_shuttle/WS = shuttle_controller.shuttles[shuttle_tag]
	if(!istype(WS))
		message_admins("ERROR: Shuttle computer ([src]) ([shuttle_tag]) could not find their shuttle in the shuttles list.")
		return

	if(href_list["refresh"])
		ui_interact(usr)

	if (WS.moving_status != SHUTTLE_IDLE)
		usr << "<font color='blue'>[shuttle_tag] vessel is busy moving.</font>"
		return

	if(href_list["dock_command"])
		WS.dock()

	if(href_list["undock_command"])
		WS.undock()

	if(href_list["cloak_command"])
		if(!WS.can_cloak)
			return
		WS.cloaked = TRUE
		to_chat(usr, "<span class='danger'>Ship stealth systems have been activated. The station will not be warned of our arrival.</span>")

	if(href_list["uncloak_command"])
		if(!WS.can_cloak)
			return
		WS.cloaked = FALSE
		to_chat(usr, "<span class='danger'>Ship stealth systems have been deactivated. The station will be warned of our arrival.</span>")

	if(href_list["traverse"])
		if((WS.last_move + WS.cooldown) > world.time)
			usr << "<font color='red'>The ship's drive is inoperable while the engines are charging.</font>"
			return

		var/index = text2num(href_list["traverse"])
		var/datum/shuttle_route/new_route = WS.web_master.current_destination.routes[index]
		if(!istype(new_route))
			message_admins("ERROR: Shuttle computer was asked to traverse a nonexistant route.")
			return

		if(!check_docking(WS))
	//		updateUsrDialog()
			ui_interact(usr)
			return

		var/datum/shuttle_destination/target_destination = new_route.get_other_side(WS.web_master.current_destination)
		if(!istype(target_destination))
			message_admins("ERROR: Shuttle computer was asked to travel to a nonexistant destination.")
			return

		WS.web_master.future_destination = target_destination
		to_chat(usr, "<span class='notice'>[shuttle_tag] flight computer received command.</span>")

		var/travel_time = new_route.travel_time * WS.flight_time_modifier

		if(new_route.interim && new_route.travel_time)
			WS.long_jump(WS.current_area, target_destination.my_area, new_route.interim, travel_time / 10)
		else
			WS.short_jump(WS.current_area, target_destination.my_area)

	ui_interact(usr)

// Props, for now.
/obj/structure/flight_left
	name = "flight computer meters"
	desc = "You hope the pilot knows what this does."
	icon = 'icons/obj/flight_computer.dmi'
	icon_state = "left"
	density = TRUE
	anchored = TRUE

/obj/structure/flight_right
	name = "flight computer panel"
	desc = "Probably shouldn't open it."
	icon = 'icons/obj/flight_computer.dmi'
	icon_state = "right"
	density = TRUE
	anchored = TRUE
