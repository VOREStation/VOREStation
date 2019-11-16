/obj/machinery/computer/shuttle_control/web/heist
	name = "skipjack control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Skipjack"

/datum/shuttle/web_shuttle/heist
	name = "Skipjack"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE
	current_area = /area/skipjack_station/start
//	docking_controller_tag = "skipjack_shuttle"
	web_master_type = /datum/shuttle_web_master/heist

/datum/shuttle_web_master/heist
	destination_class = /datum/shuttle_destination/heist
	starting_destination = /datum/shuttle_destination/heist/root



/datum/shuttle_destination/heist/root
	name = "Raider Outpost"
	my_area = /area/skipjack_station/start
	preferred_interim_area = /area/skipjack_station/transit

//	dock_target = "skipjack_base"

	routes_to_make = list(
		/datum/shuttle_destination/heist/orbit = 1 MINUTE,
	)

/datum/shuttle_destination/heist/orbit
	name = "Orbit of Sif"
	my_area = /area/skipjack_station/orbit
	preferred_interim_area = /area/skipjack_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/heist/outside_SC_1d = 30 SECONDS,
		/datum/shuttle_destination/heist/outside_SC_2d = 30 SECONDS,
		/datum/shuttle_destination/heist/outside_SC_3d = 30 SECONDS,
		/datum/shuttle_destination/heist/sky = 30 SECONDS,
	)

/datum/shuttle_destination/heist/outside_SC_1d
	name = "NLS Southern Cross - Aft of First Deck"
	my_area = /area/skipjack_station/firstdeck
	preferred_interim_area = /area/skipjack_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/heist/outside_SC_2d = 0,
		/datum/shuttle_destination/heist/outside_SC_3d = 0,
		/datum/shuttle_destination/heist/docked_SC = 0
	)

/datum/shuttle_destination/heist/outside_SC_2d
	name = "NLS Southern Cross - Fore of Second Deck"
	my_area = /area/skipjack_station/seconddeck
	preferred_interim_area = /area/skipjack_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/heist/outside_SC_1d = 0,
		/datum/shuttle_destination/heist/outside_SC_3d = 0,
		/datum/shuttle_destination/heist/docked_SC = 0
	)

/datum/shuttle_destination/heist/outside_SC_3d
	name = "NLS Southern Cross - Starboard of Third Deck"
	my_area = /area/skipjack_station/thirddeck
	preferred_interim_area = /area/skipjack_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/heist/outside_SC_1d = 0,
		/datum/shuttle_destination/heist/outside_SC_2d = 0,
		/datum/shuttle_destination/heist/docked_SC = 0
	)


/datum/shuttle_destination/heist/docked_SC
	name = "NLS Southern Cross - Arrivals Docking Port"
	my_area = /area/skipjack_station/arrivals_dock
	preferred_interim_area = /area/skipjack_station/transit

//	dock_target = "skipjack_shuttle_dock_airlock"
	announcer = "Southern Cross Docking Computer"

/datum/shuttle_destination/heist/docked_SC/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/heist/docked_SC/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."

/datum/shuttle_destination/heist/sky
	name = "Skies of Sif"
	my_area = /area/skipjack_station/sky
	preferred_interim_area = /area/skipjack_station/sky_transit

	routes_to_make = list(
		/datum/shuttle_destination/heist/planet = 15 SECONDS
	)

/datum/shuttle_destination/heist/planet
	name = "Sif Surface"
	my_area = /area/skipjack_station/planet
	preferred_interim_area = /area/skipjack_station/sky_transit