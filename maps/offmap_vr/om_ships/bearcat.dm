// Compile in the map for CI testing if we're testing compileability of all the maps
#ifdef MAP_TEST
#include "bearcat.dmm"
#endif

// -- Datums -- //
/datum/map_template/om_ships/bearcat
	name = "OM Ship - Bearcat (New Z)"
	desc = "An old salvage ship, abandoned but seemingly intact."
	mappath = "maps/offmap_vr/om_ships/bearcat.dmm"

// The 'shuttle'
/datum/shuttle/autodock/overmap/bearcat
	name = "Bearcat"
	current_location = "omship_spawn_bearcat"
	docking_controller_tag = "bearcat_docking"
	shuttle_area = list(	/area/ship/scrap,
				/area/shuttle/bearcat/cargo,
				/area/shuttle/bearcat/command,
				/area/shuttle/bearcat/command_captain,
				/area/shuttle/bearcat/comms,
				/area/shuttle/bearcat/crew,
				/area/shuttle/bearcat/crew_corridors,
				/area/shuttle/bearcat/crew_dorms,
				/area/shuttle/bearcat/crew_kitchen,
				/area/shuttle/bearcat/crew_medbay,
				/area/shuttle/bearcat/crew_saloon,
				/area/shuttle/bearcat/crew_toilets,
				/area/shuttle/bearcat/crew_wash,
				/area/shuttle/bearcat/dock_central,
				/area/shuttle/bearcat/dock_port,
				/area/shuttle/bearcat/dock_starboard,
				/area/shuttle/bearcat/maintenance,
				/area/shuttle/bearcat/maintenance_atmos,
				/area/shuttle/bearcat/maintenance_engine,
				/area/shuttle/bearcat/maintenance_engine_pod_port,
				/area/shuttle/bearcat/maintenance_engine_pod_starboard,
				/area/shuttle/bearcat/maintenance_enginecontrol,
				/area/shuttle/bearcat/maintenance_power,
				/area/shuttle/bearcat/maintenance_storage,
				/area/shuttle/bearcat/unused1,
				/area/shuttle/bearcat/unused2
				) //it's a miracle this thing works
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 4 //chonker uses more fuel
	move_direction = NORTH
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/bearcat
	name = "IRV Bearcat"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_bearcat"
	shuttle_type = /datum/shuttle/autodock/overmap/bearcat

/obj/effect/overmap/visitable/ship/landable/bearcat
	name = "Binturong-class Salvage Vessel"
	scanner_desc = @{"[i]Registration[/i]: IRV Bearcat
[i]Class:[/i] Corvette
[i]Transponder[/i]: Transmitting \'Keep-Away\' Signal
[b]Notice[/b]: Abandoned under unclear circumstances."}
	known = FALSE
	vessel_mass = 3500
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
	name = "\improper Bearcat"
	has_gravity = 0		//predates artificial gravity - won't matter much due to all the walls to push off of!

/area/shuttle/bearcat/crew
	name = "\improper Bearcat Crew Compartments"
	icon_state = "hallC"

/area/shuttle/bearcat/crew_corridors
	name = "\improper Bearcat Corridors"
	icon_state = "hallC1"

/area/shuttle/bearcat/crew_kitchen
	name = "\improper Bearcat Galley"
	icon_state = "kitchen"

/area/shuttle/bearcat/crew_dorms
	name = "\improper Bearcat Dorms"
	icon_state = "crew_quarters"

/area/shuttle/bearcat/crew_saloon
	name = "\improper Bearcat Saloon"
	icon_state = "conference"

/area/shuttle/bearcat/crew_toilets
	name = "\improper Bearcat Bathrooms"
	icon_state = "toilet"

/area/shuttle/bearcat/crew_wash
	name = "\improper Bearcat Washroom"
	icon_state = "locker"

/area/shuttle/bearcat/crew_medbay
	name = "\improper Bearcat Medical Bay"
	icon_state = "medbay"

/area/shuttle/bearcat/cargo
	name = "\improper Bearcat Cargo Hold"
	icon_state = "quartstorage"

/area/shuttle/bearcat/dock
	name = "\improper Bearcat Docking Bay"
	icon_state = "start"

/area/shuttle/bearcat/dock_central
	name = "\improper Bearcat Passenger Bay"
	icon_state = "start"

/area/shuttle/bearcat/dock_port
	name = "\improper Bearcat Docking Bay Port"
	icon_state = "west"

/area/shuttle/bearcat/dock_starboard
	name = "\improper Bearcat Docking Bay Starboard"
	icon_state = "east"

/area/shuttle/bearcat/unused1
	name = "\improper Bearcat Unused Compartment #1"
	icon_state = "green"

/area/shuttle/bearcat/unused2
	name = "\improper Bearcat Unused Compartment #2"
	icon_state = "yellow"

/area/shuttle/bearcat/unused3
	name = "\improper Bearcat Unused Compartment #3"
	icon_state = "blueold"

/area/shuttle/bearcat/maintenance
	name = "\improper Bearcat Maintenance Compartments"
	icon_state = "storage"

/area/shuttle/bearcat/maintenance_storage
	name = "\improper Bearcat Tools Storage"
	icon_state = "eva"

/area/shuttle/bearcat/maintenance_atmos
	name = "\improper Bearcat Atmospherics Compartment"
	icon_state = "atmos"
	music = list('sound/ambience/ambiatm1.ogg')

/area/shuttle/bearcat/maintenance_power
	name = "\improper Bearcat Power Compartment"
	icon_state = "engine_smes"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/shuttle/bearcat/maintenance_engine
	name = "\improper Bearcat Main Engine Compartment"
	icon_state = "engine"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/shuttle/bearcat/maintenance_engine_pod_port
	name = "\improper Bearcat Port Engine Pod"
	icon_state = "west"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/shuttle/bearcat/maintenance_engine_pod_starboard
	name = "\improper Bearcat Starboard Engine Pod"
	icon_state = "east"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/shuttle/bearcat/maintenance_enginecontrol
	name = "\improper Bearcat Engine Control Room"
	icon_state = "engine_monitoring"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/shuttle/bearcat/command
	name = "\improper Bearcat Command Deck"
	icon_state = "centcom"
	music = list('sound/ambience/signal.ogg')

/area/shuttle/bearcat/command_captain
	name = "\improper Bearcat Captain's Quarters"
	icon_state = "captain"
	music = list('sound/ambience/signal.ogg')

/area/shuttle/bearcat/comms
	name = "\improper Bearcat Communications Relay"
	icon_state = "tcomsatcham"
	music = list('sound/ambience/signal.ogg')
