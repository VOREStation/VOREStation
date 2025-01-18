// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo/New(_name)
	..()
	move_direction = WEST
	ceiling_type = /turf/simulated/floor/reinforced/virgo3c

////////////////////////////////////////////////

// Escape shuttle
/datum/shuttle/autodock/ferry/emergency/escape/New()
	..()
	move_direction = EAST

/datum/shuttle/autodock/ferry/emergency/New()
	..()
	move_direction = EAST

/datum/shuttle/autodock/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = "escape_shuttle_hatch"
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = "escape_shuttle_hatch"
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)
