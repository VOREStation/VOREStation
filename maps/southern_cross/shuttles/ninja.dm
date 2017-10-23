/obj/machinery/computer/shuttle_control/web/ninja
	name = "stealth shuttle control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Ninja"

/datum/shuttle/web_shuttle/ninja
	name = "Ninja"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE
	current_area = /area/ninja_dojo/start
	docking_controller_tag = "ninja_shuttle"
	web_master_type = /datum/shuttle_web_master/ninja

/datum/shuttle_web_master/ninja
	destination_class = /datum/shuttle_destination/ninja
	starting_destination = /datum/shuttle_destination/ninja/root

/datum/shuttle_destination/ninja/root
	name = "Dojo Outpost"
	my_area = /area/ninja_dojo/start
	preferred_interim_area = /area/ninja_dojo/sky_transit

	dock_target = "ninja_base"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/sky = 30 SECONDS,
	)

/datum/shuttle_destination/ninja/orbit
	name = "Orbit of Sif"
	my_area = /area/ninja_dojo/orbit
	preferred_interim_area = /area/ninja_dojo/transit

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_SC_1d = 1 MINUTE,
		/datum/shuttle_destination/ninja/outside_SC_2d = 1 MINUTE,
		/datum/shuttle_destination/ninja/outside_SC_3d = 1 MINUTE,
		/datum/shuttle_destination/ninja/sky = 1 MINUTE,
	)

/datum/shuttle_destination/ninja/outside_SC_1d
	name = "NLS Southern Cross - Aft of First Deck"
	my_area = /area/ninja_dojo/firstdeck
	preferred_interim_area = /area/ninja_dojo/transit

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_SC_2d = 0,
		/datum/shuttle_destination/ninja/outside_SC_3d = 0,
		/datum/shuttle_destination/ninja/docked_SC = 0
	)

/datum/shuttle_destination/ninja/outside_SC_2d
	name = "NLS Southern Cross - Fore of Second Deck"
	my_area = /area/ninja_dojo/seconddeck
	preferred_interim_area = /area/ninja_dojo/transit

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_SC_1d = 0,
		/datum/shuttle_destination/ninja/outside_SC_3d = 0,
		/datum/shuttle_destination/ninja/docked_SC = 0
	)

/datum/shuttle_destination/ninja/outside_SC_3d
	name = "NLS Southern Cross - Starboard of Third Deck"
	my_area = /area/ninja_dojo/thirddeck
	preferred_interim_area = /area/ninja_dojo/transit

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_SC_1d = 0,
		/datum/shuttle_destination/ninja/outside_SC_2d = 0,
		/datum/shuttle_destination/ninja/docked_SC = 0
	)


/datum/shuttle_destination/ninja/docked_SC
	name = "NLS Southern Cross - Arrivals Docking Port"
	my_area = /area/ninja_dojo/arrivals_dock
	preferred_interim_area = /area/ninja_dojo/transit

	dock_target = "ninja_shuttle_dock_airlock"
	announcer = "Southern Cross Docking Computer"
	arrival_message = "Attention, a shuttle has arrived to the Arrivals Dock."
	departure_message = "Attention, a shuttle has departed the Arrivals Dock."

/datum/shuttle_destination/ninja/sky
	name = "Skies of Sif"
	my_area = /area/ninja_dojo/sky
	preferred_interim_area = /area/ninja_dojo/sky_transit

	routes_to_make = list(
		/datum/shuttle_destination/ninja/planet = 30 SECONDS
	)

/datum/shuttle_destination/ninja/planet
	name = "Sif Surface"
	my_area = /area/ninja_dojo/planet
	preferred_interim_area = /area/ninja_dojo/sky_transit