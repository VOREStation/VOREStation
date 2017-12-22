//Shuttle 1

/obj/machinery/computer/shuttle_control/web/shuttle1
	name = "shuttle control console"
	shuttle_tag = "Shuttle 1"

/datum/shuttle/web_shuttle/shuttle1
	name = "Shuttle 1"
	warmup_time = 0
	current_area = /area/shuttle/shuttle1/start
	docking_controller_tag = "shuttle1_shuttle"
	web_master_type = /datum/shuttle_web_master/shuttle1

/datum/shuttle_web_master/shuttle1
	destination_class = /datum/shuttle_destination/shuttle1
	starting_destination = /datum/shuttle_destination/shuttle1/root

//Shuttle 2

/obj/machinery/computer/shuttle_control/web/shuttle2
	name = "shuttle control console"
	shuttle_tag = "Shuttle 2"

/datum/shuttle/web_shuttle/shuttle2
	name = "Shuttle 2"
	warmup_time = 0
	current_area = /area/shuttle/shuttle2/start
	docking_controller_tag = "shuttle2_shuttle"
	web_master_type = /datum/shuttle_web_master/shuttle2

/datum/shuttle_web_master/shuttle2
	destination_class = /datum/shuttle_destination/shuttle2
	starting_destination = /datum/shuttle_destination/shuttle2/root

/datum/shuttle_destination/shuttle1/root
	name = "Southern Cross Hangar One"
	my_area = /area/shuttle/shuttle1/start
	preferred_interim_area = /area/shuttle/shuttle1/transit

	dock_target = "hangar_1"
	announcer = "Southern Cross Docking Computer"
	arrival_message = "Attention, shuttle one has arrived to Hangar One."
	departure_message = "Attention, shuttle one has departed Hangar One."

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/outside_SC = 0,
	)

/datum/shuttle_destination/shuttle2/root
	name = "Southern Cross Hangar Two"
	my_area = /area/shuttle/shuttle2/start
	preferred_interim_area = /area/shuttle/shuttle2/transit

	dock_target = "hangar_2"
	announcer = "Southern Cross Docking Computer"
	arrival_message = "Attention, shuttle one has arrived to Hangar Two."
	departure_message = "Attention, shuttle one has departed Hangar Two."

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/outside_SC = 0,
	)


/datum/shuttle_destination/shuttle1/outside_SC
	name = "Outside of NLS Southern Cross"
	my_area = /area/shuttle/shuttle1/seconddeck
	preferred_interim_area = /area/shuttle/shuttle1/transit

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/sif_orbit = 1 MINUTE,
		/datum/shuttle_destination/shuttle1/docked_SC = 0
	)

/datum/shuttle_destination/shuttle2/outside_SC
	name = "Outside of NLS Southern Cross"
	my_area = /area/shuttle/shuttle2/seconddeck
	preferred_interim_area = /area/shuttle/shuttle2/transit

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/sif_orbit = 1 MINUTE,
		/datum/shuttle_destination/shuttle2/docked_SC = 0
	)


/datum/shuttle_destination/shuttle1/docked_SC
	name = "Southern Cross Docking Port"
	my_area = /area/shuttle/shuttle1/arrivals_dock
	preferred_interim_area = /area/shuttle/shuttle1/transit

	dock_target = "shuttle1_dock_airlocksc"
	announcer = "Southern Cross Docking Computer"
	arrival_message = "Attention, shuttle one has arrived to the Arrivals Dock."
	departure_message = "Attention, shuttle one has departed the Arrivals Dock."

/datum/shuttle_destination/shuttle2/docked_SC
	name = "Southern Cross Docking Port"
	my_area = /area/shuttle/shuttle2/arrivals_dock
	preferred_interim_area = /area/shuttle/shuttle2/transit

	dock_target = "shuttle2_dock_airlocksc"
	announcer = "Southern Cross Docking Computer"
	arrival_message = "Attention, shuttle two has arrived to the Arrivals Dock."
	departure_message = "Attention, shuttle two has departed the Arrivals Dock."


/datum/shuttle_destination/shuttle1/sif_orbit
	name = "Sif Orbit"
	my_area = /area/shuttle/shuttle1/orbit
	preferred_interim_area = /area/shuttle/shuttle1/transit

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/sky = 1 MINUTE
	)

/datum/shuttle_destination/shuttle2/sif_orbit
	name = "Sif Orbit"
	my_area = /area/shuttle/shuttle2/orbit
	preferred_interim_area = /area/shuttle/shuttle2/transit

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/sky = 1 MINUTE
	)


/datum/shuttle_destination/shuttle1/sky
	name = "Skies of Sif"
	my_area = /area/shuttle/shuttle1/sky
	preferred_interim_area = /area/shuttle/shuttle1/sky_transit

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/main_base = 30 SECONDS,
		/datum/shuttle_destination/shuttle1/mining_base = 30 SECONDS
	)

/datum/shuttle_destination/shuttle2/sky
	name = "Skies of Sif"
	my_area = /area/shuttle/shuttle2/sky
	preferred_interim_area = /area/shuttle/shuttle2/sky_transit

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/main_base = 30 SECONDS,
		/datum/shuttle_destination/shuttle2/mining_base = 30 SECONDS
	)


/datum/shuttle_destination/shuttle1/main_base
	name = "Main Outpost"
	my_area = /area/shuttle/shuttle1/planet
	preferred_interim_area = /area/shuttle/shuttle1/sky_transit

	dock_target = "surface_dock_1"
	announcer = "Outpost Automated ATC"
	arrival_message = "Attention, shuttle one has arrived to the Main Outpost."
	departure_message = "Attention, shuttle one has departed the Main Outpost."

/datum/shuttle_destination/shuttle2/main_base
	name = "Main Outpost"
	my_area = /area/shuttle/shuttle2/planet
	preferred_interim_area = /area/shuttle/shuttle2/sky_transit

	dock_target = "surface_dock_2"
	announcer = "Outpost Automated ATC"
	arrival_message = "Attention, shuttle two has arrived to the Main Outpost."
	departure_message = "Attention, shuttle two has departed the Main Outpost."


/datum/shuttle_destination/shuttle1/mining_base
	name = "Mining Outpost"
	my_area = /area/shuttle/shuttle1/mining
	preferred_interim_area = /area/shuttle/shuttle1/sky_transit

	dock_target = "mining_dock_1"
	announcer = "Outpost Automated ATC"
	arrival_message = "Attention, shuttle one has arrived to the Mining Outpost."
	departure_message = "Attention, shuttle one has departed the Mining Outpost."

/datum/shuttle_destination/shuttle2/mining_base
	name = "Mining Outpost"
	my_area = /area/shuttle/shuttle2/mining
	preferred_interim_area = /area/shuttle/shuttle2/sky_transit

	dock_target = "mining_dock_2"
	announcer = "Outpost Automated ATC"
	arrival_message = "Attention, shuttle two has arrived to the Mining Outpost."
	departure_message = "Attention, shuttle two has departed the Mining Outpost."