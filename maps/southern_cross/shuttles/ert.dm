/obj/machinery/computer/shuttle_control/multi/response
	name = "response shuttle console"
	shuttle_tag = "Response Operations"
	req_access = list(access_cent_specops)
/*
/datum/shuttle/multi_shuttle/response
	name = "Response Operations"
	warmup_time = 5
	origin = /area/shuttle/response_ship/start
	interim = /area/shuttle/response_ship/transit
	start_location = "Response Team Ship"
	destinations = list(
		"Northwest of First deck" = /area/shuttle/response_ship/firstdeck,
		"Southeast of Second deck" = /area/shuttle/response_ship/seconddeck,
		"Northeast of Third deck" = /area/shuttle/response_ship/thirddeck,
		"Planetside Site" = /area/shuttle/response_ship/planet,
		"Docking Port" = /area/shuttle/response_ship/arrivals_dock,
		)
	docking_controller_tag = "response_shuttle"
	destination_dock_targets = list(
		"Response Team Base" = "response_ship",
		"Docking Port" = "response_shuttle_dock_airlock",
		)
*/
/obj/machinery/computer/shuttle_control/web/ert
	name = "response shuttle control console"
	req_access = list(access_cent_specops)
	shuttle_tag = "Response Operations"

/datum/shuttle/web_shuttle/ert
	name = "Response Operations"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = FALSE
	current_area = /area/shuttle/response_ship/start
	docking_controller_tag = "response_shuttle"
	web_master_type = /datum/shuttle_web_master/ert
	flight_time_modifier = 0.5	// High speed low drag etc

/datum/shuttle_web_master/ert
	destination_class = /datum/shuttle_destination/ert
	starting_destination = /datum/shuttle_destination/ert/root


/datum/shuttle_destination/ert/root
	name = "Central Command"
	my_area = /area/shuttle/response_ship/start
	preferred_interim_area = /area/shuttle/response_ship/transit

	dock_target = "response_base"

	routes_to_make = list(
		/datum/shuttle_destination/ert/orbit = 1 MINUTE,
	)

/datum/shuttle_destination/ert/orbit
	name = "Orbit of Sif"
	my_area = /area/shuttle/response_ship/orbit
	preferred_interim_area = /area/shuttle/response_ship/transit

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_SC_1d = 30 SECONDS,
		/datum/shuttle_destination/ert/outside_SC_2d = 30 SECONDS,
		/datum/shuttle_destination/ert/outside_SC_3d = 30 SECONDS,
		/datum/shuttle_destination/ert/sky = 30 SECONDS
	)

/datum/shuttle_destination/ert/outside_SC_1d
	name = "NLS Southern Cross - Fore Port of First Deck"
	my_area = /area/shuttle/response_ship/firstdeck
	preferred_interim_area = /area/shuttle/response_ship/transit

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_SC_2d = 0,
		/datum/shuttle_destination/ert/outside_SC_3d = 0,
		/datum/shuttle_destination/ert/docked_SC = 0
	)


/datum/shuttle_destination/ert/outside_SC_2d
	name = "NLS Southern Cross - Aft Starboard of Second Deck"
	my_area = /area/shuttle/response_ship/seconddeck
	preferred_interim_area = /area/shuttle/response_ship/transit

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_SC_1d = 0,
		/datum/shuttle_destination/ert/outside_SC_3d = 0,
		/datum/shuttle_destination/ert/docked_SC = 0
	)

/datum/shuttle_destination/ert/outside_SC_3d
	name = "NLS Southern Cross - Aft Starboard of Third Deck"
	my_area = /area/shuttle/response_ship/thirddeck
	preferred_interim_area = /area/shuttle/response_ship/transit

	routes_to_make = list(
		/datum/shuttle_destination/ert/outside_SC_1d = 0,
		/datum/shuttle_destination/ert/outside_SC_2d = 0,
		/datum/shuttle_destination/ert/docked_SC = 0
	)

/datum/shuttle_destination/ert/docked_SC
	name = "NLS Southern Cross - Arrivals Docking Port"
	my_area = /area/shuttle/response_ship/arrivals_dock
	preferred_interim_area = /area/shuttle/response_ship/transit

	dock_target = "response_shuttle_dock_airlock"
	announcer = "Southern Cross Docking Computer"

/datum/shuttle_destination/ert/docked_SC/get_arrival_message()
	return "Attention, the Emergency Response Team's shuttle has arrived to the Arrivals Dock."

/datum/shuttle_destination/ert/docked_SC/get_departure_message()
	return "Attention, the Emergency Response Team's shuttle has departed the Arrivals Dock."

/datum/shuttle_destination/ert/sky
	name = "Skies of Sif"
	my_area = /area/shuttle/response_ship/sky
	preferred_interim_area = /area/shuttle/response_ship/sky_transit

	routes_to_make = list(
		/datum/shuttle_destination/ert/planet = 15 SECONDS
	)

/datum/shuttle_destination/ert/planet
	name = "Sif Surface"
	my_area = /area/shuttle/response_ship/planet
	preferred_interim_area = /area/shuttle/response_ship/sky_transit