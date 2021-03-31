// -- Datums -- //

/obj/effect/overmap/visitable/sector/guttersite
	name = "Gutter Site"
	desc = "A shoddy asteroid installation."
	scanner_desc = @{"[i]Transponder[/i]: Strong Comms Signal
[b]Notice[/b]: WARNING! KEEP OUT! MEMBERS ONLY!"}
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "guttersite"
	known = FALSE
	color = "#ee3333" //Redish, so it stands out against the other debris-like icons
	initial_generic_waypoints = list("guttersite_lshuttle", "guttersite_sshuttle", "guttersite_mshuttle")

// -- Objs -- //
/obj/effect/shuttle_landmark/premade/guttersite/sshuttle
	name = "Gutter - Small Shuttle"
	landmark_tag = "guttersite_sshuttle"

/obj/effect/shuttle_landmark/premade/guttersite/lshuttle
	name = "Gutter - Large Shuttle"
	landmark_tag = "guttersite_lshuttle"

/obj/effect/shuttle_landmark/premade/guttersite/mshuttle
	name = "Gutter - Medi Shuttle"
	landmark_tag = "guttersite_mshuttle"

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/guttersite
	name = "away mission initializer - guttersite"

/obj/away_mission_init/guttersite/Initialize()
	initialized = TRUE
	return INITIALIZE_HINT_QDEL

/area/tether_away/guttersite
	name = "Away Mission - guttersite"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"

/area/tether_away/guttersite/explored
	icon_state = "debrisexplored"

/area/tether_away/guttersite/unexplored
	icon_state = "debrisunexplored"

/area/tether_away/guttersite/derelict
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

//TFF 26/12/19 - Sub-areas for the APCs.
/area/tether_away/guttersite/engines
	name = "Gutter - Gutter Engineering"

/area/tether_away/guttersite/security
	name = "Gutter - Gutter Security and Holding"

/area/tether_away/guttersite/docking
	name = "Gutter - Gutter Docks"

/area/tether_away/guttersite/office
	name = "Gutter - Gutter Offices"

/area/tether_away/guttersite/atmos
	name = "Gutter - Gutter Atmospherics"

/area/tether_away/guttersite/maint
	name = "Gutter - Gutter Maintenance"

/area/tether_away/guttersite/vault
	name = "Gutter - Gutter Vault"

/area/tether_away/guttersite/bridge
	name = "Gutter - Gutter Bridge"

/area/tether_away/guttersite/walkway
	name = "Gutter - Gutter Walkway"

/area/tether_away/guttersite/medbay
	name = "Gutter - Gutter Medbay"

/area/tether_away/guttersite/commons
	name = "Gutter - Gutter Commons"

/area/tether_away/guttersite/storage
	name = "Gutter - Gutter Tool Storage"

/area/tether_away/guttersite/teleporter
	name = "Gutter - Gutter Teleporter"
