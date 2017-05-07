/obj/machinery/computer/shuttle_control/tether_backup
	name = "tether backup shuttle control console"
	shuttle_tag = "Tether Backup"

/obj/machinery/computer/shuttle_control/multi/tether_antag_ground
	name = "land crawler control console"
	shuttle_tag = "Land Crawler"

/obj/machinery/computer/shuttle_control/multi/tether_antag_space
	name = "protoshuttle control console"
	shuttle_tag = "Proto"

//
// "Tram" Emergency Shuttle
// Becuase the tram only has its own doors and no corresponding station doors, a docking controller is overkill.
// Just open the gosh darn doors!  Also we avoid having a physical docking controller obj for gameplay reasons.
/datum/shuttle/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection

/datum/shuttle/ferry/emergency/init_docking_controllers()
	docking_controller_tag = null
	dock_target_station = null
	dock_target_offsite = null
	radio_connection = radio_controller.add_object(src, frequency, null)
	..()

/datum/shuttle/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)
