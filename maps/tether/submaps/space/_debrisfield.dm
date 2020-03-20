// -- Datums -- //

/obj/effect/overmap/visitable/sector/debrisfield
	name = "Debris Field"
	desc = "Space junk galore."
	icon_state = "dust1"
	known = FALSE
	color = "#ee3333" //Redish, so it stands out against the other debris-like icons
	initial_generic_waypoints = list("tether_excursion_debrisfield")

// -- Objs -- //


/obj/effect/step_trigger/teleporter/debrisfield_loop/north/New()
	..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/south/New()
	..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/west/New()
	..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/east/New()
	..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/debrisfield
	name = "away mission initializer - debrisfield"

/obj/away_mission_init/debrisfield/Initialize()
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

/area/tether_away/debrisfield
	name = "Away Mission - Debris Field"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"

/area/tether_away/debrisfield/explored
	icon_state = "debrisexplored"

/area/tether_away/debrisfield/unexplored
	icon_state = "debrisunexplored"

/area/tether_away/debrisfield/derelict
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

//TFF 26/12/19 - Sub-areas for the APCs.
/area/tether_away/debrisfield/derelict/ai_access_port
	name = "POI - Abandoned Derelict AI Acess Port"

/area/tether_away/debrisfield/derelict/ai_access_starboard
	name = "POI - Abandoned Derelict AI Access Starboard"

/area/tether_away/debrisfield/derelict/ai_chamber
	name = "POI - Abandoned Derelict AI Chamber"

/area/tether_away/debrisfield/derelict/bridge
	name = "POI - Abandoned Derelict Bridge"

/area/tether_away/debrisfield/derelict/interior
	name = "POI - Abandoned Derelict Interior"