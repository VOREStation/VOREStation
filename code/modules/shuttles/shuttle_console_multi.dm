/obj/machinery/computer/shuttle_control/multi
	ui_template = "shuttle_control_console_multi.tmpl"

/obj/machinery/computer/shuttle_control/multi/get_ui_data(var/datum/shuttle/autodock/multi/shuttle)
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

/obj/machinery/computer/shuttle_control/multi/handle_topic_href(var/datum/shuttle/autodock/multi/shuttle, var/list/href_list)
	if((. = ..()) != null)
		return

	if(href_list["pick"])
		var/dest_key = input("Choose shuttle destination", "Shuttle Destination") as null|anything in shuttle.get_destinations()
		if(dest_key && CanInteract(usr, global.default_state))
			shuttle.set_destination(dest_key, usr)
		return TOPIC_REFRESH

	if(href_list["toggle_cloaked"])
		if(!shuttle.can_cloak)
			return TOPIC_HANDLED
		shuttle.cloaked = !shuttle.cloaked
		if(shuttle.legit)
			to_chat(usr, "<span class='notice'>Ship ATC inhibitor systems have been [(shuttle.cloaked ? "activated. The station will not" : "deactivated. The station will")] be notified of our arrival.</span>")
		else
			to_chat(usr, "<span class='warning'>Ship stealth systems have been [(shuttle.cloaked ? "activated. The station will not" : "deactivated. The station will")] be warned of our arrival.</span>")
		return TOPIC_REFRESH
