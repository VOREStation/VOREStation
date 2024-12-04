/* This is an admin tool to control all shuttles, including overmap & classic. */

/datum/tgui_module/admin_shuttle_controller
	name = "Admin Shuttle Controller"
	tgui_id = "AdminShuttleController"

/datum/tgui_module/admin_shuttle_controller/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/shuttles = list()
	for(var/shuttle_name in SSshuttles.shuttles)
		var/datum/shuttle/S = SSshuttles.shuttles[shuttle_name]
		shuttles.Add(list(list(
			"name" = shuttle_name,
			"ref" = REF(S),
			"current_location" = S.get_location_name(),
			"status" = S.moving_status,
		)))
	data["shuttles"] = shuttles

	var/list/overmap_ships = list()
	for(var/obj/effect/overmap/visitable/ship/S as anything in SSshuttles.ships)
		overmap_ships.Add(list(list(
			"name" = S.name,
			"ref" = REF(S),
		)))
	data["overmap_ships"] = overmap_ships

	return data

/datum/tgui_module/admin_shuttle_controller/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tgui_module/admin_shuttle_controller/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return

	switch(action)
		if("adminobserve")
			var/datum/shuttle/S = locate(params["ref"])
			if(istype(S))
				var/client/C = ui.user.client
				if(!isobserver(ui.user))
					C.admin_ghost()
				spawn(2)
					C.jumptoturf(get_turf(S.current_location))
			else if(istype(S, /obj/effect/overmap/visitable))
				var/obj/effect/overmap/visitable/V = S
				var/client/C = ui.user.client
				if(!isobserver(ui.user))
					C.admin_ghost()
				spawn(2)
					var/atom/target
					if(LAZYLEN(V.generic_waypoints))
						target =  V.generic_waypoints[1]
					else if(LAZYLEN(V.restricted_waypoints))
						target =  V.restricted_waypoints[1]
					else
						to_chat(C, span_warning("Unable to jump to [V]."))
						return
					var/turf/T = get_turf(target)
					if(!istype(T))
						to_chat(C, span_warning("Unable to jump to [V]."))
						return
					C.jumptoturf(T)
			return TRUE
		if("classicmove")
			var/datum/shuttle/S = locate(params["ref"])
			if(istype(S, /datum/shuttle/autodock/multi))
				var/datum/shuttle/autodock/multi/shuttle = S
				var/dest_key = tgui_input_list(ui.user, "Choose shuttle destination", "Shuttle Destination", shuttle.get_destinations())
				if(dest_key)
					shuttle.set_destination(dest_key, ui.user)
					shuttle.launch(src)
			else if(istype(S, /datum/shuttle/autodock/overmap))
				var/datum/shuttle/autodock/overmap/shuttle = S
				var/list/possible_d = shuttle.get_possible_destinations()
				var/D
				if(!LAZYLEN(possible_d))
					to_chat(ui.user, span_warning("There are no possible destinations for [shuttle] ([shuttle.type])"))
					return FALSE
				D = tgui_input_list(ui.user, "Choose shuttle destination", "Shuttle Destination", possible_d)
				if(D)
					shuttle.set_destination(possible_d[D])
					shuttle.launch()
			else if(istype(S, /datum/shuttle/autodock))
				var/datum/shuttle/autodock/shuttle = S
				if(tgui_alert(ui.user, "Are you sure you want to launch [shuttle]?", "Launching Shuttle", list("Yes", "No")) == "Yes")
					shuttle.launch(src)
			else
				to_chat(ui.user, span_notice("The shuttle control panel isn't quite sure how to move [S] ([S?.type])."))
				return FALSE
			to_chat(ui.user, span_notice("Launching shuttle [S]."))
			return TRUE
		if("overmap_control")
			var/obj/effect/overmap/visitable/ship/V = locate(params["ref"])
			if(istype(V))
				var/datum/tgui_module/ship/fullmonty/F = new(src, V)
				F.tgui_interact(ui.user, null, ui)

			return TRUE
