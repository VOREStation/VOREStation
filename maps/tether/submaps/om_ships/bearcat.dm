// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "bearcat.dmm"
#endif

// -- Datums -- //
/datum/map_template/om_ships/bearcat
	name = "OM Ship - Bearcat (New Z)"
	desc = "An old salvage or exploration ship, abandoned but possibly repairable."
	mappath = 'bearcat.dmm'

// The 'shuttle'
/datum/shuttle/autodock/overmap/bearcat
	name = "Bearcat"
	current_location = "omship_spawn_bearcat"
	docking_controller_tag = "bearcat_starboard" //technically we have two ports, but the starboard is used as the default as it allows us to hook up to most sites
	shuttle_area = list(
						/area/ship/scrap/,
						/area/ship/scrap/cargo,
						/area/ship/scrap/command,
						/area/ship/scrap/command/captain,
						/area/ship/scrap/comms,
						/area/ship/scrap/crew,
						/area/ship/scrap/crew/corridors,
						/area/ship/scrap/crew/dorms,
						/area/ship/scrap/crew/kitchen,
						/area/ship/scrap/crew/medbay,
						/area/ship/scrap/crew/saloon,
						/area/ship/scrap/crew/toilets,
						/area/ship/scrap/crew/wash,
						/area/ship/scrap/dock,
						/area/ship/scrap/dock/port,
						/area/ship/scrap/dock/starboard,
						/area/ship/scrap/maintenance,
						/area/ship/scrap/maintenance/atmos,
						/area/ship/scrap/maintenance/engine,
						/area/ship/scrap/maintenance/enginecontrol,
						/area/ship/scrap/maintenance/power,
						/area/ship/scrap/maintenance/storage,
						/area/ship/scrap/shuttle,
						/area/ship/scrap/shuttle/ingoing,
						/area/ship/scrap/shuttle/outgoing,
						/area/ship/scrap/unused1,
						/area/ship/scrap/unused2,
						/area/ship/scrap/unused3
						) //oof. the shuttle subarea is unused, but it's here for... well, it's here.
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 5 //chonker uses more fuel
	move_direction = NORTH

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/bearcat
	name = "IRV Bearcat"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_bearcat"
	shuttle_type = /datum/shuttle/autodock/overmap/bearcat

/obj/effect/overmap/visitable/ship/landable/bearcat
	name = "IRV Bearcat"
	desc = "An old and seemingly abandoned salvage ship."
	scanner_desc = @{"[i]Registration[/i]: IRV Bearcat
[i]Class:[/i] Corvette
[i]Transponder[/i]: Transmitting \'Keep-Away\' Signal
[b]Notice[/b]: May be salvagable. No life signs."}
	known = FALSE
	color = "#ee3333" //Reddish, so it looks kinda rusty and beat up
//	initial_generic_waypoints = list("bearcat_dock_w", "bearcat_dock_e")
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Bearcat"

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/bearcat
	name = "short jump console"
	shuttle_tag = "Bearcat"
	req_one_access = list()

// -- Objs -- //
/obj/effect/shuttle_landmark/premade/bearcat/dock_w
	name = "IRV Bearcat - Port Docking Ring"
	landmark_tag = "bearcat_dock_w"

/obj/effect/shuttle_landmark/premade/bearcat/dock_e
	name = "IRV Bearcat - Starboard Docking Ring"
	landmark_tag = "bearcat_dock_e"

/area/ship/scrap
	name = "\improper Bearcat Ship"
	has_gravity = 0		//predates artificial gravity - won't matter much due to all the walls to push off of!

/area/ship/scrap/crew
	name = "\improper Crew Compartemnts"
	icon_state = "hallC"

/area/ship/scrap/crew/corridors
	name = "\improper Corridors"
	icon_state = "hallC1"

/area/ship/scrap/crew/kitchen
	name = "\improper Galley"
	icon_state = "kitchen"

/area/ship/scrap/crew/dorms
	name = "\improper Dorms"
	icon_state = "crew_quarters"

/area/ship/scrap/crew/saloon
	name = "\improper Saloon"
	icon_state = "conference"

/area/ship/scrap/crew/toilets
	name = "\improper Bathrooms"
	icon_state = "toilet"

/area/ship/scrap/crew/wash
	name = "\improper Washroom"
	icon_state = "locker"

/area/ship/scrap/crew/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"

/area/ship/scrap/cargo
	name = "\improper Cargo Hold"
	icon_state = "quartstorage"

/area/ship/scrap/dock
	name = "\improper Docking Bay"
	icon_state = "start"

/area/ship/scrap/dock/port
	name = "\improper Docking Bay Port"
	icon_state = "west"

/area/ship/scrap/dock/starboard
	name = "\improper Docking Bay Starboard"
	icon_state = "east"

/area/ship/scrap/unused1
	name = "\improper Unused Compartment #1"
	icon_state = "green"

/area/ship/scrap/unused2
	name = "\improper Unused Compartment #2"
	icon_state = "yellow"

/area/ship/scrap/unused3
	name = "\improper Unused Compartment #3"
	icon_state = "blueold"

/area/ship/scrap/maintenance
	name = "\improper Maintenance Compartments"
	icon_state = "storage"

/area/ship/scrap/maintenance/storage
	name = "\improper Tools Storage"
	icon_state = "eva"

/area/ship/scrap/maintenance/atmos
	name = "\improper Atmospherics Comparment"
	icon_state = "atmos"
	music = list('sound/ambience/ambiatm1.ogg')

/area/ship/scrap/maintenance/power
	name = "\improper Power Compartment"
	icon_state = "engine_smes"

/area/ship/scrap/maintenance/engine
	name = "\improper Engine Compartments"
	icon_state = "engine"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/ship/scrap/maintenance/enginecontrol
	name = "\improper Engine Control Room"
	icon_state = "engine_monitoring"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/ship/scrap/command
	name = "\improper Command Deck"
	icon_state = "centcom"
	music = list('sound/ambience/signal.ogg')

/area/ship/scrap/command/captain
	name = "\improper Captain's Quarters"
	icon_state = "captain"

/area/ship/scrap/comms
	name = "\improper Communications Relay"
	icon_state = "tcomsatcham"
	music = list('sound/ambience/signal.ogg')

/area/ship/scrap/shuttle/
	requires_power = 0
	luminosity = 1
	dynamic_lighting = 0

/area/ship/scrap/shuttle/ingoing
	name = "\improper Docking Bay #1"
	icon_state = "tcomsatcham"

/area/ship/scrap/shuttle/outgoing
	name = "\improper Docking Bay #1"
	icon_state = "tcomsatcham"