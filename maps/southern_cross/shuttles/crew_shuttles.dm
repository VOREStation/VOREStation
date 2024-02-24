//Shuttle 1

/obj/machinery/computer/shuttle_control/web/shuttle1
	name = "shuttle control console"
	shuttle_tag = "Shuttle 1"
	req_access = list(access_pilot)

/datum/shuttle/autodock/web_shuttle/shuttle1
	name = "Shuttle 1"
	warmup_time = 0
	shuttle_area = /area/shuttle/shuttle1/start
	current_location = "hangar_1"
	docking_controller_tag = "shuttle1_shuttle"
	web_master_type = /datum/shuttle_web_master/shuttle1
	autopilot = TRUE
	can_autopilot = TRUE
	autopilot_delay = 60
	autopilot_first_delay = 150 // Five minutes at roundstart. Two minutes otherwise.

/datum/shuttle_web_master/shuttle1
	destination_class = /datum/shuttle_destination/shuttle1
	autopath_class = /datum/shuttle_autopath/shuttle1
	starting_destination = /datum/shuttle_destination/shuttle1/root

/datum/shuttle_autopath/shuttle1/to_outpost
	start = /datum/shuttle_destination/shuttle1/root

	path_nodes = list(
		/datum/shuttle_destination/shuttle1/outside_SC,
		/datum/shuttle_destination/shuttle1/sif_orbit,
		/datum/shuttle_destination/shuttle1/sky,
		/datum/shuttle_destination/shuttle1/main_base
	)

/datum/shuttle_autopath/shuttle1/to_home
	start = /datum/shuttle_destination/shuttle1/main_base

	path_nodes = list(
		/datum/shuttle_destination/shuttle1/sky,
		/datum/shuttle_destination/shuttle1/sif_orbit,
		/datum/shuttle_destination/shuttle1/outside_SC,
		/datum/shuttle_destination/shuttle1/root
	)

//Shuttle 2

/obj/machinery/computer/shuttle_control/web/shuttle2
	name = "shuttle control console"
	shuttle_tag = "Shuttle 2"
	req_access = list(access_pilot)

/datum/shuttle/autodock/web_shuttle/shuttle2
	name = "Shuttle 2"
	warmup_time = 0
	shuttle_area = /area/shuttle/shuttle2/start
	current_location = "hangar_2"
	docking_controller_tag = "shuttle2_shuttle"
	web_master_type = /datum/shuttle_web_master/shuttle2
	autopilot = TRUE
	can_autopilot = TRUE
	autopilot_delay = 60
	autopilot_first_delay = 270 // Nine minutes at roundstart. Two minutes otherwise. This should leave when the first shuttle departs the outpost.

/datum/shuttle_web_master/shuttle2
	destination_class = /datum/shuttle_destination/shuttle2
	autopath_class = /datum/shuttle_autopath/shuttle2
	starting_destination = /datum/shuttle_destination/shuttle2/root

/datum/shuttle_autopath/shuttle2/to_outpost
	start = /datum/shuttle_destination/shuttle2/root

	path_nodes = list(
		/datum/shuttle_destination/shuttle2/outside_SC,
		/datum/shuttle_destination/shuttle2/sif_orbit,
		/datum/shuttle_destination/shuttle2/sky,
		/datum/shuttle_destination/shuttle2/main_base
	)

/datum/shuttle_autopath/shuttle2/to_home
	start = /datum/shuttle_destination/shuttle2/main_base

	path_nodes = list(
		/datum/shuttle_destination/shuttle2/sky,
		/datum/shuttle_destination/shuttle2/sif_orbit,
		/datum/shuttle_destination/shuttle2/outside_SC,
		/datum/shuttle_destination/shuttle2/root
	)



/datum/shuttle_destination/shuttle1/root
	name = "Southern Cross Hangar One"
	my_landmark = "hangar_1"
	preferred_interim_tag = "shuttle1_transit"

	radio_announce = 1
	announcer = "Southern Cross Docking Computer"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/outside_SC = 0,
	)

/datum/shuttle_destination/shuttle1/root/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to Hangar One."

/datum/shuttle_destination/shuttle1/root/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Hangar One."

/datum/shuttle_destination/shuttle2/root
	name = "Southern Cross Hangar Two"
	my_landmark = "hangar_2"
	preferred_interim_tag = "shuttle2_transit"

	radio_announce = 1
	announcer = "Southern Cross Docking Computer"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/outside_SC = 0,
	)

/datum/shuttle_destination/shuttle2/root/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to Hangar Two."

/datum/shuttle_destination/shuttle2/root/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed Hangar Two."


/datum/shuttle_destination/shuttle1/outside_SC
	name = "Outside of NLS Southern Cross"
	my_landmark = "shuttle1_seconddeck"
	preferred_interim_tag = "shuttle1_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/sif_orbit = 25 SECONDS,
		/datum/shuttle_destination/shuttle1/docked_SC = 0
	)

/datum/shuttle_destination/shuttle2/outside_SC
	name = "Outside of NLS Southern Cross"
	my_landmark = "shuttle2_seconddeck"
	preferred_interim_tag = "shuttle2_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/sif_orbit = 25 SECONDS,
		/datum/shuttle_destination/shuttle2/docked_SC = 0
	)


/datum/shuttle_destination/shuttle1/docked_SC
	name = "Southern Cross Docking Port"
	my_landmark = "shuttle1_arrivals_dock"
	preferred_interim_tag = "shuttle1_transit"

	radio_announce = 1
	announcer = "Southern Cross Docking Computer"

/datum/shuttle_destination/shuttle1/docked_SC/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/shuttle1/docked_SC/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."


/datum/shuttle_destination/shuttle2/docked_SC
	name = "Southern Cross Docking Port"
	my_landmark = "shuttle2_arrivals_dock"
	preferred_interim_tag = "shuttle2_transit"

	radio_announce = 1
	announcer = "Southern Cross Docking Computer"

/datum/shuttle_destination/shuttle2/docked_SC/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/shuttle2/docked_SC/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."


/datum/shuttle_destination/shuttle1/sif_orbit
	name = "Sif Orbit"
	my_landmark = "shuttle1_orbit"
	preferred_interim_tag = "shuttle1_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/sky = 25 SECONDS
	)

/datum/shuttle_destination/shuttle2/sif_orbit
	name = "Sif Orbit"
	my_landmark = "shuttle2_orbit"
	preferred_interim_tag = "shuttle2_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/sky = 25 SECONDS
	)


/datum/shuttle_destination/shuttle1/sky
	name = "Skies of Sif"
	my_landmark = "shuttle1_sky"
	preferred_interim_tag = "shuttle1_sky_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle1/main_base = 10 SECONDS,
		/datum/shuttle_destination/shuttle1/mining_base = 10 SECONDS
	)

/datum/shuttle_destination/shuttle2/sky
	name = "Skies of Sif"
	my_landmark = "shuttle2_sky"
	preferred_interim_tag = "shuttle2_sky_transit"

	routes_to_make = list(
		/datum/shuttle_destination/shuttle2/main_base = 10 SECONDS,
		/datum/shuttle_destination/shuttle2/mining_base = 10 SECONDS
	)


/datum/shuttle_destination/shuttle1/main_base
	name = "Main Outpost"
	my_landmark = "shuttle1_planet"
	preferred_interim_tag = "shuttle1_sky_transit"

	radio_announce = 1
	announcer = "Outpost Automated ATC"

/datum/shuttle_destination/shuttle1/main_base/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Main Outpost."

/datum/shuttle_destination/shuttle1/main_base/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Main Outpost."

/datum/shuttle_destination/shuttle2/main_base
	name = "Main Outpost"
	my_landmark = "shuttle2_planet"
	preferred_interim_tag = "shuttle2_sky_transit"

	radio_announce = 1
	announcer = "Outpost Automated ATC"

/datum/shuttle_destination/shuttle2/main_base/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Main Outpost."

/datum/shuttle_destination/shuttle2/main_base/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Main Outpost."


/datum/shuttle_destination/shuttle1/mining_base
	name = "Wilderness Landing Site"
	// Note: Left area under this landmark as /area/shuttle/shuttle1/mining so it doesn't get seeded with POIs
	my_landmark = "shuttle1_mining"
	preferred_interim_tag = "shuttle1_sky_transit"

	radio_announce = 1
	announcer = "Outpost Automated ATC"

/datum/shuttle_destination/shuttle1/mining_base/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Wilderness Area."

/datum/shuttle_destination/shuttle1/mining_base/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Wilderness Area."

/datum/shuttle_destination/shuttle2/mining_base
	name = "Wilderness Landing Site "
	// Note: Left area under this landmark as /area/shuttle/shuttle2/mining so it doesn't get seeded with POIs
	my_landmark = "shuttle2_mining"
	preferred_interim_tag = "shuttle2_sky_transit"

	radio_announce = 1
	announcer = "Outpost Automated ATC"

/datum/shuttle_destination/shuttle2/mining_base/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Wilderness Area."

/datum/shuttle_destination/shuttle2/mining_base/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Wilderness Area."