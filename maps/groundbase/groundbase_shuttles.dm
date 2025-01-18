// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo/New(_name)
	..()
	move_direction = WEST
	ceiling_type = /turf/simulated/floor/reinforced/virgo3c

/////EXPLOSHUTTL/////
/datum/shuttle/autodock/overmap/gbexplo
	name = "Exploration Shuttle"
	current_location = "gb_excursion_pad"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/groundbase/exploration)
	fuel_consumption = 1
	move_direction = NORTH

//AXOLOTL
/datum/shuttle/autodock/overmap/axolotl
	name = "Axolotl"
	current_location = "omship_axolotl"
	docking_controller_tag = "axolotl_docking"
	shuttle_area = list(/area/shuttle/axolotl,/area/shuttle/axolotl_cockpit,/area/shuttle/axolotl_engineering,/area/shuttle/axolotl_q1,/area/shuttle/axolotl_q2,/area/shuttle/axolotl_galley,/area/shuttle/axolotl_head)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 5
	ceiling_type = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/shuttle_initializer/axolotl/New(loc, ...)
	shuttle_type = /datum/shuttle/autodock/overmap/axolotl
	..()

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
