/obj/machinery/computer/shuttle_control/multi
	circuit = /obj/item/circuitboard/shuttle_console/multi
	tgui_subtemplate = "ShuttleControlConsoleMulti"

/obj/machinery/computer/shuttle_control/multi/shuttlerich_tgui_data(var/datum/shuttle/autodock/multi/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"destination_name" = shuttle.next_location ? shuttle.next_location.name : "No destination set.",
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"can_cloak" = shuttle.can_cloak ? 1 : 0,
			"cloaked" = shuttle.cloaked ? 1 : 0,
			"legit" = shuttle.legit ? 1 : 0,
			// "engines_charging" = ((shuttle.last_move + (shuttle.cooldown SECONDS)) > world.time), // Replaced by longer warmup_time
		)

/obj/machinery/computer/shuttle_control/multi/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/datum/shuttle/autodock/multi/shuttle = SSshuttles.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(ui.user, span_warning("Unable to establish link with the shuttle."))
		return TRUE

	switch(action)
		if("pick")
			var/dest_key = tgui_input_list(ui.user, "Choose shuttle destination", "Shuttle Destination", shuttle.get_destinations())
			if(dest_key && CanInteract(ui.user, GLOB.tgui_default_state))
				shuttle.set_destination(dest_key, ui.user)
			return TRUE

		if("toggle_cloaked")
			if(!shuttle.can_cloak)
				return TRUE
			shuttle.cloaked = !shuttle.cloaked
			if(shuttle.legit)
				to_chat(ui.user, span_notice("Ship ATC inhibitor systems have been [(shuttle.cloaked ? "activated. The station will not" : "deactivated. The station will")] be notified of our arrival."))
			else
				to_chat(ui.user, span_warning("Ship stealth systems have been [(shuttle.cloaked ? "activated. The station will not" : "deactivated. The station will")] be warned of our arrival."))
			return TRUE
