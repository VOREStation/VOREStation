//This shuttle traverses a "web" of route_datums to have a wider range of places to go and make flying feel like movement is actually occuring.
/datum/shuttle/autodock/web_shuttle
	flags = SHUTTLE_FLAGS_ZERO_G
	var/visible_name = null // The pretty name shown to people in announcements, since the regular name var is used internally for other things.
	var/cloaked = FALSE
	var/can_cloak = FALSE
	var/cooldown = 0
	var/last_move = 0	//the time at which we last moved
	var/datum/shuttle_web_master/web_master = null
	var/web_master_type = null
	var/flight_time_modifier = 1.0
	var/autopilot = FALSE
	var/can_autopilot = FALSE
	var/autopilot_delay = 60 // How many ticks to not do anything when not following an autopath. Should equal two minutes.
	var/autopilot_first_delay = null // If your want your shuttle to stay for a different amount of time for the first time, set this.
	var/can_rename = TRUE // Lets the pilot rename the shuttle. Only available once.
	category = /datum/shuttle/autodock/web_shuttle
	var/list/obj/item/clothing/head/pilot/helmets

/datum/shuttle/autodock/web_shuttle/New()
	web_master = new web_master_type(src)
	build_destinations()
	if(autopilot)
		flags |= SHUTTLE_FLAGS_PROCESS
		process_state = DO_AUTOPILOT
		if(autopilot_first_delay)
			autopilot_delay = autopilot_first_delay
	if(!visible_name)
		visible_name = name
	helmets = list()
	..()

/datum/shuttle/autodock/web_shuttle/Destroy()
	QDEL_NULL(web_master)
	helmets.Cut()
	return ..()

/datum/shuttle/autodock/web_shuttle/current_dock_target()
	// TODO - Probably don't even need to override this right?  Debug testing code below will check!
	. = web_master?.get_current_destination()?.my_landmark?.docking_controller?.id_tag
	if (. != ..())
		warning("Web shuttle [src] had current_dock_target()=[.] but autodock.current_dock_target() = [..()]")

/datum/shuttle/autodock/web_shuttle/perform_shuttle_move()
	..()
	last_move = world.time

/datum/shuttle/autodock/web_shuttle/short_jump()
	. = ..()
	update_helmets()

/datum/shuttle/autodock/web_shuttle/long_jump()
	. = ..()
	update_helmets()

/datum/shuttle/autodock/web_shuttle/on_shuttle_departure()
	. = ..()
	web_master.on_shuttle_departure()
	update_helmets()

/datum/shuttle/autodock/web_shuttle/on_shuttle_arrival()
	. = ..()
	active_docking_controller = current_location.docking_controller
	update_docking_target(current_location)
	web_master.on_shuttle_arrival()
	update_helmets()

/datum/shuttle/autodock/web_shuttle/proc/build_destinations()
	return

/datum/shuttle/autodock/web_shuttle/process()
	update_helmets()

	if(moving_status == SHUTTLE_IDLE)
		if(web_master.autopath) // We're currently flying a path.
			autopilot_say("Continuing route.")
			web_master.process_autopath()

		else // Otherwise we are about to start one or just finished one.
			if(autopilot_delay > 0) // Wait for awhile so people can get on and off.
				if(active_docking_controller && shuttle_docking_controller) // Dock to the destination if possible.
					var/docking_status = shuttle_docking_controller.get_docking_status()
					if(docking_status == "undocked")
						dock()
						autopilot_say("Docking.")
						return
					else if(docking_status == "docking")
						return // Give it a few more ticks to finish docking.

				if(autopilot_delay % 10 == 0) // Every ten ticks.
					var/seconds_left = autopilot_delay * 2
					if(seconds_left >= 60) // A minute
						var/minutes_left = FLOOR(seconds_left / 60, 1)
						seconds_left = seconds_left % 60
						autopilot_say("Departing in [minutes_left] minute\s[seconds_left ? ", [seconds_left] seconds":""].")
					else
						autopilot_say("Departing in [seconds_left] seconds.")
				autopilot_delay--

			else // Time to go.
				if(active_docking_controller && shuttle_docking_controller) // Undock if possible.
					var/docking_status = shuttle_docking_controller.get_docking_status()
					if(docking_status == "docked")
						undock()
						autopilot_say("Undocking.")
						return
					else if(docking_status == "undocking")
						return // Give it a few more ticks to finish undocking.

				autopilot_delay = initial(autopilot_delay)
				autopilot_say("Taking off.")
				web_master.process_autopath()

/datum/shuttle/autodock/web_shuttle/proc/update_helmets()
	for(var/obj/item/clothing/head/pilot/H as anything in helmets)
		if(QDELETED(H))
			helmets -= H
			continue
		if(!H.shuttle_comp || !(get_area(H) in shuttle_area))
			H.shuttle_comp = null
			H.audible_message(span_warning("\The [H] pings as it loses it's connection with the ship."), runemessage = "ping")
			H.update_hud("discon")
			helmets -= H
		else
			H.update_hud(moving_status)

/datum/shuttle/autodock/web_shuttle/proc/adjust_autopilot(on)
	if(on)
		if(autopilot)
			return
		autopilot = TRUE
		autopilot_delay = initial(autopilot_delay)
		SSshuttles.process_shuttles |= src
		if(process_state == IDLE_STATE)
			process_state = DO_AUTOPILOT
	else
		if(!autopilot)
			return
		autopilot = FALSE
		SSshuttles.process_shuttles -= src
		if (process_state == DO_AUTOPILOT)
			process_state = initial(process_state)

/datum/shuttle/autodock/web_shuttle/proc/autopilot_say(message) // Makes the autopilot 'talk' to the passengers.
	var/padded_message = span_game(span_say(span_name("shuttle autopilot") + " states, \"[message]\""))
	message_passengers(padded_message)

/datum/shuttle/autodock/web_shuttle/proc/rename_shuttle(mob/user)
	if(!can_rename)
		to_chat(user, span_warning("You can't rename this vessel."))
		return
	var/new_name = tgui_input_text(user, "Please enter a new name for this vessel. Note that you can only set its name once, so choose wisely.", "Rename Shuttle", visible_name)
	var/sanitized_name = sanitizeName(new_name, MAX_NAME_LEN, TRUE)
	if(sanitized_name)
		//can_rename = FALSE //VOREStation Removal
		to_chat(user, span_notice("You've renamed the vessel to '[sanitized_name]'."))
		message_admins("[key_name_admin(user)] renamed shuttle '[visible_name]' to '[sanitized_name]'.")
		visible_name = sanitized_name
	else
		to_chat(user, span_warning("The name you supplied was invalid. Try another name."))

/obj/machinery/computer/shuttle_control/web
	name = "flight computer"
	icon_state = "flightcomp_center"
	icon_keyboard = "flight_center_key"
	icon_screen = "flight_center"
	var/list/my_doors //Should be list("id_tag" = "Pretty Door Name", ...)
	var/list/my_sensors //Should be list("id_tag" = "Pretty Sensor Name", ...)
	tgui_subtemplate = "ShuttleControlConsoleWeb"
	skip_act = TRUE

// Note - Searching own area for doors/sensors is fine for legacy web shuttles as they are single-area.
//        However if this code is copied to future multi-area shuttles, should search in all shuttle areas
/obj/machinery/computer/shuttle_control/web/Initialize()
	. = ..()
	var/area/my_area = get_area(src)
	if(my_doors)
		var/list/find_doors = my_doors
		my_doors = list()
		for(var/obj/machinery/door/airlock/A in my_area)
			if(A.id_tag in find_doors)
				my_doors[find_doors[A.id_tag]] = A
				find_doors -= A.id_tag
		for(var/lost in find_doors)
			log_shuttle("[my_area] shuttle computer couldn't find [lost] door!")

	if(my_sensors)
		var/list/find_sensors = my_sensors
		my_sensors = list()
		for(var/obj/machinery/shuttle_sensor/S in my_area)
			if(S.id_tag in find_sensors)
				my_sensors[find_sensors[S.id_tag]] = S
				find_sensors -= S.id_tag
		for(var/lost in find_sensors)
			log_shuttle("[my_area] shuttle computer couldn't find [lost] sensor!")

/obj/machinery/computer/shuttle_control/web/attackby(obj/I, mob/user)
	var/datum/shuttle/autodock/web_shuttle/shuttle = SSshuttles.shuttles[shuttle_tag]
	if(shuttle && istype(I,/obj/item/clothing/head/pilot))
		var/obj/item/clothing/head/pilot/H = I
		H.shuttle_comp = src
		shuttle.helmets |= I
		to_chat(user, span_notice("You register the helmet with the ship's console."))
		shuttle.update_helmets()
		return

	return ..()

/obj/machinery/computer/shuttle_control/web/tgui_data(mob/user)
	var/list/data = list()

	var/list/routes[0]
	var/datum/shuttle/autodock/web_shuttle/shuttle = SSshuttles.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(user, span_warning("Unable to establish link with the shuttle."))
		return

	var/list/R = shuttle.web_master.get_available_routes()
	for(var/i = 1 to length(R))
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

	var/list/doors = list()
	if(my_doors)
		for(var/doorname in my_doors)
			var/obj/machinery/door/airlock/A = my_doors[doorname]
			if(A)
				doors[doorname] = list("bolted" = A.locked, "open" = !A.density)

	var/list/sensors = list()
	if(my_sensors)
		for(var/sensorname in my_sensors)
			var/obj/machinery/shuttle_sensor/S = my_sensors[sensorname]
			if(S)
				sensors[sensorname] = S.air_list()

	data = list(
		"shuttle_location" = shuttle_location,
		"future_location" = future_location,
		"shuttle_state" = shuttle_state,
		"routes" = routes,
		"has_docking" = shuttle.shuttle_docking_controller? 1 : 0,
		"skip_docking" = shuttle.skip_docking_checks(),
		"is_moving" = shuttle.moving_status != SHUTTLE_IDLE,
		"docking_status" = shuttle.shuttle_docking_controller? shuttle.shuttle_docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.shuttle_docking_controller? shuttle.shuttle_docking_controller.override_enabled : null,
		"is_in_transit" = shuttle.has_arrive_time(),
		"travel_progress" = between(0, percent_finished, 100),
		"time_left" = round( (total_time - elapsed_time) / 10),
		"can_cloak" = shuttle.can_cloak ? 1 : 0,
		"cloaked" = shuttle.cloaked ? 1 : 0,
		"can_autopilot" = shuttle.can_autopilot ? 1 : 0,
		"autopilot" = shuttle.autopilot ? 1 : 0,
		"can_rename" = shuttle.can_rename ? 1 : 0,
		"doors" = doors,
		"sensors" = sensors,
		"subtemplate" = tgui_subtemplate,
	)

	return data

/obj/machinery/computer/shuttle_control/web/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/datum/shuttle/autodock/web_shuttle/WS = SSshuttles.shuttles[shuttle_tag]
	if(!istype(WS))
		message_admins("ERROR: Shuttle computer ([src]) ([shuttle_tag]) could not find their shuttle in the shuttles list.")
		return

	if(WS.moving_status != SHUTTLE_IDLE)
		to_chat(ui.user, span_blue("[WS.visible_name] is busy moving."))
		return

	switch(action)
		if("rename_command")
			WS.rename_shuttle(ui.user)

		if("dock_command")
			if(WS.autopilot)
				to_chat(ui.user, span_warning("The autopilot must be disabled before you can control the vessel manually."))
				return
			WS.dock()

		if("undock_command")
			if(WS.autopilot)
				to_chat(ui.user, span_warning("The autopilot must be disabled before you can control the vessel manually."))
				return
			WS.undock()

		if("toggle_cloaking")
			if(!WS.can_cloak)
				return
			WS.cloaked = !WS.cloaked
			if(WS.cloaked)
				to_chat(ui.user, span_danger("Ship stealth systems have been activated. The station will not be warned of our arrival."))
			else
				to_chat(ui.user, span_danger("Ship stealth systems have been deactivated. The station will be warned of our arrival."))

		if("toggle_autopilot")
			WS.adjust_autopilot(!WS.autopilot)

		if("traverse")
			if(WS.autopilot)
				to_chat(ui.user, span_warning("The autopilot must be disabled before you can control the vessel manually."))
				return

			if((WS.last_move + WS.cooldown) > world.time)
				to_chat(ui.user, span_red("The ship's drive is inoperable while the engines are charging."))
				return

			var/index = text2num(params["traverse"])
			var/datum/shuttle_route/new_route = WS.web_master.current_destination.routes[index]
			if(!istype(new_route))
				message_admins("ERROR: Shuttle computer was asked to traverse a nonexistant route.")
				return

			if(!check_docking(, ui.user, WS))
				return TRUE

			var/datum/shuttle_destination/target_destination = new_route.get_other_side(WS.web_master.current_destination)
			if(!istype(target_destination))
				message_admins("ERROR: Shuttle computer was asked to travel to a nonexistant destination.")
				return

			WS.next_location = target_destination.my_landmark
			if(!can_move(WS, ui.user))
				return

			WS.web_master.future_destination = target_destination
			to_chat(ui.user, span_notice("[WS.visible_name] flight computer received command."))
			WS.web_master.reset_autopath() // Deviating from the path will almost certainly confuse the autopilot, so lets just reset its memory.

			var/travel_time = new_route.travel_time * WS.flight_time_modifier
			// TODO - Leshana - Change this to use proccess stuff of autodock!
			if(new_route.interim && new_route.travel_time)
				WS.long_jump(target_destination.my_landmark, new_route.interim, travel_time / 10)
			else
				WS.short_jump(target_destination.my_landmark)

//check if we're undocked, give option to force launch
/obj/machinery/computer/shuttle_control/web/proc/check_docking(mob/user, datum/shuttle/autodock/MS)
	if(MS.skip_docking_checks() || MS.check_undocked())
		return 1

	var/choice = tgui_alert(user, "The shuttle is currently docked! Please undock before continuing.","Error",list("Cancel","Force Launch"))
	if(!choice || choice == "Cancel")
		return 0

	choice = tgui_alert(user, "Forcing a shuttle launch while docked may result in severe injury, death and/or damage to property. Are you sure you wish to continue?", "Force Launch", list("Force Launch", "Cancel"))
	if(choice || choice == "Cancel")
		return 0

	return 1

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

//An object for creating a shuttle destination to dynamically loaded maps
/obj/shuttle_connector
	name = "shuttle connector"
	var/shuttle_name					//Text name of the shuttle to connect to
	var/list/destinations				//Make sure this STARTS with a destination that builds a route to one that always exists as an anchor.

/obj/shuttle_connector/Initialize()
	. = ..()
	RegisterSignal(SSshuttles,COMSIG_OBSERVER_SHUTTLE_ADDED,PROC_REF(setup_routes))

/obj/shuttle_connector/Destroy()
	UnregisterSignal(SSshuttles,COMSIG_OBSERVER_SHUTTLE_ADDED)
	. = ..()

// This is called whenever a shuttle is initialized.  If its our shuttle, do our thing!
/obj/shuttle_connector/proc/setup_routes(var/new_shuttle)
	var/datum/shuttle/autodock/web_shuttle/ES = SSshuttles.shuttles[shuttle_name]
	if(ES != new_shuttle)
		return // Its not our shuttle! Ignore!
	if(destinations && istype(ES))
		var/datum/shuttle_web_master/WM = ES.web_master

		for(var/new_dest in destinations)
			var/datum/shuttle_destination/D = new new_dest(WM)
			WM.destinations += D

			for(var/type_to_link in D.routes_to_make)
				var/travel_delay = D.routes_to_make[type_to_link]
				D.link_destinations(WM.get_destination_by_type(type_to_link), D.preferred_interim_tag, travel_delay)
	else
		warning("[log_info_line()]'s shuttle [global.log_info_line(ES)] initialized but destinations:[destinations]")

	qdel(src)

//A sensor for detecting air outside shuttles! Handy, that.
/obj/machinery/shuttle_sensor
	name = "environment sensor"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_standby"
	var/id_tag

/obj/machinery/shuttle_sensor/process()
	return PROCESS_KILL //nty

/obj/machinery/shuttle_sensor/proc/air_list()
	. = list("reading" = FALSE)
	var/turf/T = get_step(src,dir)

	if(isnull(T))
		return

	var/list/aircontents
	var/datum/gas_mixture/environment = T.return_air()
	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	if(total_moles)
		var/o2_level = environment.gas["oxygen"]/total_moles
		var/n2_level = environment.gas["nitrogen"]/total_moles
		var/co2_level = environment.gas["carbon_dioxide"]/total_moles
		var/phoron_level = environment.gas["phoron"]/total_moles
		var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)
		aircontents = list(\
			"pressure" = "[round(pressure,0.1)]",\
			"nitrogen" = "[round(n2_level*100,0.1)]",\
			"oxygen" = "[round(o2_level*100,0.1)]",\
			"carbon_dioxide" = "[round(co2_level*100,0.1)]",\
			"phoron" = "[round(phoron_level*100,0.01)]",\
			"other" = "[round(unknown_level, 0.01)]",\
			"temp" = "[round(environment.temperature-T0C,0.1)]",\
			"reading" = TRUE\
			)

	if(aircontents)
		return aircontents
