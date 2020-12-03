// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "itglight.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/itglight
	name = "OM Ship - ITG Dauntless (New Z)"
	desc = "A small, well armed interstellar cargo ship!!"
	mappath = 'itglight.dmm'

/area/itglight
	requires_power = 1
	icon_state = "purple"

/area/itglight/cockpit
	name = "Dauntless - Cockpit"
/area/itglight/captain
	name = "Dauntless - Captain's Quarters"
/area/itglight/readyroom
	name = "Dauntless - Ready Room"
/area/itglight/metingroom
	name = "Dauntless - Meeting Room"
/area/itglight/forehall
	name = "Dauntless - Fore Hall"
/area/itglight/starboardcargo
	name = "Dauntless - Starboard Cargo Bay"
/area/itglight/starboardhighsec
	name = "Dauntless - Starboard Secure Cargo"
/area/itglight/starboarddocking
	name = "Dauntless - Starboard Docking Port"
/area/itglight/portcargo
	name = "Dauntless - Port Cargo Bay"
/area/itglight/porthighsec
	name = "Dauntless - Port Secure Cargo"
/area/itglight/portdocking
	name = "Dauntless - Port Docking Port"
/area/itglight/common
	name = "Dauntless - Common Area"
/area/itglight/lockers
	name = "Dauntless - Locker Room"
/area/itglight/passengersleeping
	name = "Dauntless - Passenger Sleeping Barracks"
/area/itglight/showers
	name = "Dauntless - Showers"
/area/itglight/restrooms
	name = "Dauntless - Restrooms"
/area/itglight/afthall
	name = "Dauntless - Aft Hall"
/area/itglight/medbay
	name = "Dauntless - Medbay"
/area/itglight/kitchen
	name = "Dauntless - Kitchen"
/area/itglight/crew1
	name = "Dauntless - Crew Quarters - 1"
/area/itglight/crew2
	name = "Dauntless - Crew Quarters - 2"
/area/itglight/crew3
	name = "Dauntless - Crew Quarters - 3"
/area/itglight/crew4
	name = "Dauntless - Crew Quarters - 4"
/area/itglight/shuttlebay
	name = "Dauntless - Shuttle Bay"
/area/itglight/shuttledeck
	name = "Dauntless - Shuttle Deck"
/area/itglight/starboardengi
	name = "Dauntless - Starboard Engineering"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/starboardsolars
	name = "Dauntless - Starboard Solars"
/area/itglight/portengi
	name = "Dauntless - Port Engineering"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/portsolars
	name = "Dauntless - Port Solars"

/area/shuttle/itglightshuttle
	name = "ITG Shuttlecraft"
	requires_power = 1
	dynamic_lighting = 1

// The 'Dauntless'
/obj/effect/overmap/visitable/ship/itglight
	name = "spacecraft"
	desc = "Spacefaring vessel. Friendly IFF detected."
	scanner_name = "ITG Dauntless"
	scanner_desc = @{"[i]Registration[/i]: ITG Dauntless
[i]Class[/i]: Small Frigate (Low Displacement)
[i]Transponder[/i]: Transmitting (CIV), non-hostile"}
	color = "#d98c1a" //orng
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("itglight_fore", "itglight_aft", "itglight_port", "itglight_starboard", "itglight_port_dock", "itglight_starboard_dock")
	initial_restricted_waypoints = list("ITG Shuttlecraft" = list("omship_spawn_itglightshuttle"))
	fore_dir = NORTH

	skybox_icon = 'aro2.dmi' //Art by Nia Tahl, see ATTRIBUTIONS.md
	skybox_icon_state = "skybox"
	skybox_pixel_x = 80
	skybox_pixel_y = 100

/obj/effect/overmap/visitable/ship/itglight/build_skybox_representation()
	..()
	if(!cached_skybox_image)
		return
	cached_skybox_image.add_overlay("glow")

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/itglightshuttle
	name = "shuttle control console"
	shuttle_tag = "ITG Shuttlecraft"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/itglightshuttle
	name = "ITG Dauntless - Shuttle Bay"
	base_area = /area/itglight/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "omship_spawn_itglightshuttle"
	docking_controller = "itglight_shuttlebay"
	shuttle_type = /datum/shuttle/autodock/overmap/itglightshuttle

// The 'shuttle'
/datum/shuttle/autodock/overmap/itglightshuttle
	name = "ITG Shuttlecraft"
	current_location = "omship_spawn_itglightshuttle"
	docking_controller_tag = "itglightshuttle_docker"
	shuttle_area = /area/shuttle/itglightshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE