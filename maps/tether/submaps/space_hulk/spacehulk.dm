// -- Datums -- //

/datum/shuttle_destination/excursion/space_hulk
	name = "Derelict Ship"
	my_area = /area/shuttle/excursion/space_hulk
	preferred_interim_area = /area/shuttle/excursion/space_moving
	skip_me = TRUE

	routes_to_make = list(
		/datum/shuttle_destination/excursion/bluespace = 75 SECONDS // Longer because the shuttle is assumed to have to intricately navigate and dock in one of the 'bays'.
	)

// -- Objs -- //

//This is a special type of object which will build our shuttle paths, only if this map loads
//You do need to place this object on the map somewhere.
/obj/shuttle_connector/space_hulk
	name = "shuttle connector - spacehulk"
	shuttle_name = "Excursion Shuttle"
	//This list needs to be in the correct order, and start with the one that connects to the rest of the shuttle 'network'
	destinations = list(/datum/shuttle_destination/excursion/bluespace, /datum/shuttle_destination/excursion/space_hulk)

//This object simply performs any map setup that needs to happen on our map if it loads.
//As with the above, you do need to place this object on the map somewhere.
/obj/away_mission_init/space_hulk
	name = "away mission initializer - space_hulk"

/obj/away_mission_init/space_hulk/Initialize()
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

// -- Areas -- //

/area/shuttle/excursion/space_hulk
	name = "\improper Excursion Shuttle - Space Hulk"
	base_turf = /turf/space

// -- Space Hulk Areas -- //
/area/tether_away/space_hulk
	name = "\improper Away Mission - Space Hulk"
	icon_state = "away"
	base_turf = /turf/space
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/tether_away/space_hulk/hangar
	name = "\improper Away Mission - Main Hangar"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/airless
	dynamic_lighting = TRUE

/area/tether_away/space_hulk/ship_depths
	name = "\improper Away Mission - Space Hulk Depths"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/airless
	requires_power = TRUE
	dynamic_lighting = TRUE

/area/tether_away/space_hulk/explored
	name = "Away Mission - Space Hulk (E)"
	icon_state = "explored"

/area/tether_away/space_hulk/unexplored
	name = "Away Mission - Space Hulk (UE)"
	icon_state = "unexplored"
