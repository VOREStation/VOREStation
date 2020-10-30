/obj/machinery/status_display/supply_display
	ignore_friendc = 1
	mode = STATUS_DISPLAY_CUSTOM

/obj/machinery/status_display/supply_display/update()
	if(!..() && mode == STATUS_DISPLAY_CUSTOM)
		message1 = "CARGO"
		message2 = ""

		var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
		if(!shuttle)
			message2 = "Error"
		else if(shuttle.has_arrive_time())
			message2 = "[round(shuttle.eta_seconds() / 60)]:"
			if((shuttle.eta_seconds() % 60) < 10)
				message2 += "0" // Pad to two characters
			message2 += "[shuttle.eta_seconds() % 60]"

			if(shuttle.eta_seconds() < 0)
				message2 = "Late"
			if(length(message2) > CHARS_PER_LINE)
				message2 = "Error"
		else if(shuttle.is_launching())
			if(shuttle.at_station())
				message2 = "Launch"
			else
				message2 = "ETA"
		else
			if(shuttle.at_station())
				message2 = "Docked"
			else
				message2 = "Away"
		update_display(message1, message2)
		return 1
	return 0

/obj/machinery/status_display/supply_display/receive_signal/(datum/signal/signal)
	if(signal.data["command"] == "supply")
		mode = STATUS_DISPLAY_CUSTOM
	else
		..(signal)
