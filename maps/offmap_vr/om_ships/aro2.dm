// Compile in the map for CI testing if we're testing compileability of all the maps
#ifdef MAP_TEST
#include "aro2.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/aro2
	name = "OM Ship - Aronai 2.0 (New Z)"
	desc = "It's Aronai! As a spaceship."
	mappath = 'aro2.dmm'

/area/aro2
	requires_power = 1

/area/aro2/cockpit
	name = "Aronai - Cockpit"
/area/aro2/room1
	name = "Aronai - Room1"
/area/aro2/room2
	name = "Aronai - Room2"
/area/aro2/room3
	name = "Aronai - Room3"
/area/aro2/frontroom
	name = "Aronai - Front Living"
/area/aro2/dining
	name = "Aronai - Dining"
/area/aro2/boatdeck
	name = "Aronai - Boat Deck"
/area/aro2/surfluid
	name = "Aronai - Surfluid Res"
/area/aro2/portbay
	name = "Aronai - Port Bay"
/area/aro2/starboardbay
	name = "Aronai - Starboard Bay"
/area/aro2/powerarea
	name = "Aronai - Power"
/area/aro2/airarea
	name = "Aronai - Air"
/area/aro2/observation
	name = "Aronai - Observation"

/area/shuttle/aroboat2
	name = "Aronai - Ship's Boat"
	requires_power = 1
	dynamic_lighting = 1

/turf/simulated/floor/water/indoors/surfluid
	name = "surfluid pool"
	desc = "A pool of inky-black fluid that shimmers oddly in the light if hit just right."
	description_info = "Surfluid is KHI's main method of production, using swarms of nanites to process raw materials into finished products at the cost of immense amounts of energy."
	color = "#222222"
	outdoors = OUTDOORS_NO
	reagent_type = "liquid_protean"

// The 'ship'
/obj/effect/overmap/visitable/ship/aro2
	name = "spacecraft"
	desc = "Spacefaring vessel. Friendly IFF detected."
	name = "Aronai Sieyes"
	scanner_desc = @{"[i]Registration[/i]: Aronai Sieyes
[i]Class[/i]: Small Frigate (Low Displacement)
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Automated vessel"}
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("aronai2_fore", "aronai2_aft", "aronai2_port", "aronai2_starboard")
	initial_restricted_waypoints = list("Aro's Boat" = list("omship_spawn_aroboat2"))
	fore_dir = NORTH

	skybox_icon = 'aro2.dmi' //Art by Nia Tahl, see ATTRIBUTIONS.md
	skybox_icon_state = "skybox"
	skybox_pixel_x = 80
	skybox_pixel_y = 100

/obj/effect/overmap/visitable/ship/aro2/build_skybox_representation()
	..()
	if(!cached_skybox_image)
		return
	cached_skybox_image.add_overlay("glow")

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/aroboat2
	name = "boat control console"
	shuttle_tag = "Aro's Boat"
	req_one_access = list(access_cent_general)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/aroboat2
	name = "Aronai's Boat Bay"
	base_area = /area/aro2/boatdeck
	base_turf = /turf/simulated/floor/water/indoors/surfluid
	landmark_tag = "omship_spawn_aroboat2"
	docking_controller = "aroship2_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/aroboat2

// The 'shuttle'
/datum/shuttle/autodock/overmap/aroboat2
	name = "Aro's Boat"
	current_location = "omship_spawn_aroboat2"
	docking_controller_tag = "aroboat2_docker"
	shuttle_area = /area/shuttle/aroboat2
	fuel_consumption = 0
	defer_initialisation = TRUE
