//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	circuit = /obj/item/circuitboard/shuttle_console/explore
	tgui_subtemplate = "ShuttleControlConsoleExploration"

/obj/machinery/computer/shuttle_control/explore/shuttlerich_tgui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/total_gas = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				total_gas += fuel_tank.air_contents.total_moles

		var/fuel_span = "good"
		if(total_gas < shuttle.fuel_consumption * 2)
			fuel_span = "bad"

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_usage" = shuttle.fuel_consumption * 100,
			"remaining_fuel" = round(total_gas, 0.01) * 100,
			"fuel_span" = fuel_span
		)

/obj/machinery/computer/shuttle_control/explore/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	var/datum/shuttle/autodock/overmap/shuttle = SSshuttles.shuttles[shuttle_tag]
	if(!istype(shuttle))
		to_chat(ui.user, span_warning("Unable to establish link with the shuttle."))
		return TRUE

	if(ismob(ui.user))
		shuttle.operator_skill = ui.user.get_skill_value(/datum/skill/pilot)

	switch(action)
		if("pick")
			var/list/possible_d = shuttle.get_possible_destinations()
			var/D
			if(possible_d.len)
				D = tgui_input_list(ui.user, "Choose shuttle destination", "Shuttle Destination", possible_d)
			else
				to_chat(ui.user,span_warning("No valid landing sites in range."))
			possible_d = shuttle.get_possible_destinations()
			if(CanInteract(ui.user, GLOB.tgui_default_state) && (D in possible_d))
				shuttle.set_destination(possible_d[D])
			return TRUE
