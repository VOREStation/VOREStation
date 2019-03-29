// -- Datums -- //

/datum/shuttle_destination/excursion/debrisfield
	name = "Debris Field"
	my_area = /area/shuttle/excursion/debrisfield
	preferred_interim_area = /area/shuttle/excursion/space_moving
	skip_me = TRUE

	routes_to_make = list(
		/datum/shuttle_destination/excursion/virgo3b_orbit = 30 SECONDS
	)

// -- Objs -- //

/obj/shuttle_connector/debrisfield
	name = "shuttle connector - debrisfield"
	shuttle_name = "Excursion Shuttle"
	destinations = list(/datum/shuttle_destination/excursion/debrisfield)

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/debrisfield
	name = "away mission initializer - debrisfield"

/obj/away_mission_init/debrisfield/Initialize()
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/debrisfield
	name = "\improper Excursion Shuttle - Debris Field"

/area/tether_away/debrisfield/space/poi
	name = "Away Mission - Debris Field"
	icon_state = "space"
