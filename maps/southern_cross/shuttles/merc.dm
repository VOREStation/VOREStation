/*
/datum/shuttle/multi_shuttle/mercenary
	name = "Mercenary"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE
	origin = /area/syndicate_station/start
	interim = /area/syndicate_station/transit
	start_location = "Mercenary Ship"
	destinations = list(
		"Northwest of First Deck" = /area/syndicate_station/firstdeck,
		"Northeast of the Second deck" = /area/syndicate_station/seconddeck,
		"Southeast of Third deck" = /area/syndicate_station/thirddeck,
		"Planetside" = /area/syndicate_station/planet,
		"Docking Port" = /area/syndicate_station/arrivals_dock,
		)
	docking_controller_tag = "merc_shuttle"
	destination_dock_targets = list(
		"Forward Operating Base" = "merc_base",
		"Docking Port" = "nuke_shuttle_dock_airlock",
		)
	announcer = "Southern Cross Docking Computer"

/datum/shuttle/multi_shuttle/mercenary/New()
	arrival_message = "Attention, vessel docking with the Southern Cross."
	departure_message = "Attention, vessel docking with the Southern Cross."
	..()
*/

/obj/machinery/computer/shuttle_control/web/syndicate
	name = "mercenary shuttle control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Mercenary"

/datum/shuttle/web_shuttle/syndicate
	name = "Mercenary"
	visible_name = "Unknown Vessel"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE
	current_area = /area/syndicate_station/start
	docking_controller_tag = "merc_shuttle"
	web_master_type = /datum/shuttle_web_master/syndie
	flight_time_modifier = 2	// Assumption that 'larger ship + few engines = slower'

/datum/shuttle_web_master/syndie
	destination_class = /datum/shuttle_destination/syndie
	starting_destination = /datum/shuttle_destination/syndie/root



/datum/shuttle_destination/syndie/root
	name = "Mercenary Asteroid"
	my_area = /area/syndicate_station/start
	preferred_interim_area = /area/syndicate_station/transit

	dock_target = "merc_base"

	routes_to_make = list(
		/datum/shuttle_destination/syndie/orbit = 1.5 MINUTES,
	)

/datum/shuttle_destination/syndie/orbit
	name = "Orbit of Sif"
	my_area = /area/syndicate_station/orbit
	preferred_interim_area = /area/syndicate_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/syndie/outside_SC_1d = 30 SECONDS,
		/datum/shuttle_destination/syndie/outside_SC_2d = 30 SECONDS,
		/datum/shuttle_destination/syndie/outside_SC_3d = 30 SECONDS,
		/datum/shuttle_destination/syndie/sky = 30 SECONDS
	)

/datum/shuttle_destination/syndie/outside_SC_1d
	name = "NLS Southern Cross - Fore Port of First Deck"
	my_area = /area/syndicate_station/firstdeck
	preferred_interim_area = /area/syndicate_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/syndie/outside_SC_2d = 0,
		/datum/shuttle_destination/syndie/outside_SC_3d = 0,
		/datum/shuttle_destination/syndie/docked_SC = 0
	)

/datum/shuttle_destination/syndie/outside_SC_2d
	name = "NLS Southern Cross - Fore Starboard of Second Deck"
	my_area = /area/syndicate_station/seconddeck
	preferred_interim_area = /area/syndicate_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/syndie/outside_SC_1d = 0,
		/datum/shuttle_destination/syndie/outside_SC_3d = 0,
		/datum/shuttle_destination/syndie/docked_SC = 0
	)

/datum/shuttle_destination/syndie/outside_SC_3d
	name = "NLS Southern Cross - Aft Starboard of Third Deck"
	my_area = /area/syndicate_station/thirddeck
	preferred_interim_area = /area/syndicate_station/transit

	routes_to_make = list(
		/datum/shuttle_destination/syndie/outside_SC_1d = 0,
		/datum/shuttle_destination/syndie/outside_SC_2d = 0,
		/datum/shuttle_destination/syndie/docked_SC = 0
	)

/datum/shuttle_destination/syndie/docked_SC
	name = "NLS Southern Cross - Arrivals Docking Port"
	my_area = /area/syndicate_station/arrivals_dock
	preferred_interim_area = /area/syndicate_station/transit

	dock_target = "nuke_shuttle_dock_airlock"
	announcer = "Southern Cross Docking Computer"

/datum/shuttle_destination/syndie/docked_SC/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived to the Arrivals Dock."

/datum/shuttle_destination/syndie/docked_SC/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed the Arrivals Dock."

/datum/shuttle_destination/syndie/sky
	name = "Skies of Sif"
	my_area = /area/syndicate_station/sky
	preferred_interim_area = /area/syndicate_station/sky_transit

	routes_to_make = list(
		/datum/shuttle_destination/syndie/planet = 15 SECONDS
	)

/datum/shuttle_destination/syndie/planet
	name = "Sif Surface"
	my_area = /area/syndicate_station/planet
	preferred_interim_area = /area/syndicate_station/sky_transit