/////Virgo Flyer/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/ccboat
	name = "Virgo Flyer control console"
	shuttle_tag = "Virgo Flyer"
	req_one_access = list(ACCESS_PILOT)

/obj/effect/overmap/visitable/ship/landable/ccboat
	name = "NTV Virgo Flyer"
	desc = "A small shuttle from Central Command."
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Virgo Flyer"
	known = TRUE

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/ccboat
	name = "Central Command Shuttlepad"
	base_area = /area/shuttle/centcom/ccbay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "cc_shuttlepad"
	docking_controller = "cc_landing_pad"
	shuttle_type = /datum/shuttle/autodock/overmap/ccboat

/datum/shuttle/autodock/overmap/ccboat
	name = "Virgo Flyer"
	current_location = "cc_shuttlepad"
	docking_controller_tag = "ccboat"
	shuttle_area = /area/shuttle/ccboat
	fuel_consumption = 0
	defer_initialisation = TRUE

/area/shuttle/ccboat
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Virgo Flyer"
	requires_power = 0

/area/shuttle/centcom/ccbay
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "bluwhisqu"
	name = "Central Command Shuttle Bay"
	requires_power = 0
	dynamic_lighting = 0

// Minitest overmap
/obj/effect/overmap/visitable/sector/virgo_minitest/station
	name = "Minitest Station"
	desc = "The Virgo Minitest Station.  A small base useful for testing and loading quickly!"
	base = 1
	start_x = 10
	start_y = 10
	initial_generic_waypoints = list("nav_shared_space", "nav_station_inside", "nav_station_docking1", "nav_station_docking2")

/obj/effect/overmap/visitable/sector/virgo_minitest/carpfarm
	name = "Carp Farm"
	desc = "Abandond space carp farming facility."
	start_x = 12
	start_y = 7

/obj/effect/overmap/visitable/sector/virgo_minitest/beach
	name = "Beach Planet"
	desc = "A beach in space.  Or on a planet.  Its a hack."
	in_space = 0
	start_x = 8
	start_y = 16

//
// Making Overmap Shuttle into a Landable Ship
//

/obj/effect/overmap/visitable/ship/landable/overmapdemo
	name = "VSS Overmap Demo"
	desc = "Small little shuttle nonetheless capable of overmap travel!"
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Overmap-Demo"

// Shared landmark for docking at the station
/obj/effect/shuttle_landmark/station_dockpoint1
	name = "Station Docking Point 1"
	landmark_tag = "nav_station_docking1"
	docking_controller = "station_dock1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/station_dockpoint2
	name = "Station Docking Point 2"
	landmark_tag = "nav_station_docking2"
	docking_controller = "station_dock2"
	base_turf = /turf/space
	base_area = /area/space

// Shared landmark for docking *inside* the station
/obj/effect/shuttle_landmark/station_inside
	name = "Internal Hangar"
	landmark_tag = "nav_station_inside"
	docking_controller = "station_hangar"
	base_turf = /turf/simulated/floor/tiled
	base_area = /area/bridge

/obj/effect/shuttle_landmark/shared_space
	name = "Somewhere In Space"
	landmark_tag = "nav_shared_space"
	base_turf = /turf/space
	base_area = /area/space

// Ferry Demo
/obj/effect/shuttle_landmark/ferrydemo_space
	name = "Ferry-Demo Space Hover Point"
	landmark_tag = "nav_ferrydemo_space"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/transit/ferrydemo_transit
	name = "Ferry-Demo Transient Point"
	landmark_tag = "nav_ferrydemo_transit"
	flags = SLANDMARK_FLAG_AUTOSET

// Multi Demo
/obj/effect/shuttle_landmark/multidemo_start
	name = "Multi-Demo Starting Point"
	landmark_tag = "nav_multidemo_start"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/multidemo_nearby
	name = "Multi-Demo Nearby"
	landmark_tag = "nav_multidemo_nearby"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/transit/multidemo_transit
	name = "Multi-Demo Transient Point"
	landmark_tag = "nav_multidemo_transit"
	flags = SLANDMARK_FLAG_AUTOSET

// Transit Demo
/obj/effect/shuttle_landmark/transit/webdemo_transit
	name = "Web-Demo Transient Point"
	landmark_tag = "nav_webdemo_transit"
	flags = SLANDMARK_FLAG_AUTOSET

// Web Demo
/obj/effect/shuttle_landmark/webdemo_faraway
	name = "\"Deep\" Space"
	landmark_tag = "nav_webdemo_faraway"
	flags = SLANDMARK_FLAG_AUTOSET
