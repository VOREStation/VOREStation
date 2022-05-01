/////EXPLOSHUTTL/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/gbexplo
	name = "short jump console"
	shuttle_tag = "Exploration Shuttle"
	req_one_access = list(access_pilot)

/obj/effect/overmap/visitable/ship/landable/gbexplo
	name = "Exploration Shuttle"
	desc = "A small shuttle from Rascal's Pass."
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Exploration Shuttle"
	known = TRUE

// A shuttle lateloader landmark

/datum/shuttle/autodock/overmap/gbexplo
	name = "Exploration Shuttle"
	current_location = "gb_excursion_pad"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/groundbase/exploration)
	fuel_consumption = 1
	move_direction = NORTH

/area/shuttle/groundbase/exploration
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Exploration Shuttle"
	requires_power = 1

//////////////////////////////////////////////

// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	move_direction = WEST
	ceiling_type = /turf/simulated/floor/reinforced/virgo3c

////////////////////////////////////////////////

/obj/effect/shuttle_landmark/premade/groundbase
	name = "Rascal's Pass"
	landmark_tag = "groundbase"

///////////////////////////////////////////////

// Escape shuttle
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = EAST

/datum/shuttle/autodock/ferry/emergency
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection
	move_direction = EAST

/datum/shuttle/autodock/ferry/emergency/New()
	radio_connection = radio_controller.add_object(src, frequency, null)
	..()

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

//////////////////////////////////////////////

/////Virgo Flyer/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/ccboat
	name = "Virgo Flyer control console"
	shuttle_tag = "Virgo Flyer"
	req_one_access = list(access_pilot)

/obj/effect/overmap/visitable/ship/landable/ccboat
	name = "NTV Virgo Flyer"
	desc = "A small shuttle from Central Command."
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Virgo Flyer"
	known = TRUE

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/ccboat
	name = "Central Command Shuttlepad"
	base_area = /area/shuttle/centcom/ccbay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "cc_shuttlepad"
	docking_controller = "cc_landing_pad"
	shuttle_type = /datum/shuttle/autodock/overmap/ccboat

/datum/shuttle/autodock/overmap/ccboat
	name = "Virgo Flyer"
	current_location = "cc_shuttlepad"
	docking_controller_tag = "ccboat"
	shuttle_area = /area/shuttle/ccboat
	fuel_consumption = 0
	defer_initialisation = TRUE

/area/shuttle/ccboat
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Virgo Flyer"
	requires_power = 0

/area/shuttle/centcom/ccbay
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "bluwhisqu"
	name = "Central Command Shuttle Bay"
	requires_power = 0
	dynamic_lighting = 0

