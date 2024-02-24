
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
// Overmap Shuttle Demo
//

/datum/shuttle/autodock/overmap/overmapdemo
	name = "Overmap-Demo"
	warmup_time = 0
	shuttle_area = /area/shuttle/overmapdemo
	current_location = "nav_station_docking2"
	docking_controller_tag = "overmapdemo_docker"
	fuel_consumption = 0 // Override to infinate fuel for now.

/area/shuttle/overmapdemo
	name = "Overmap-Demo Suttle"
	music = "music/escape.ogg"
	icon_state = "shuttle"


//
// Making Overmap Shuttle into a Landable Ship
//

/obj/effect/overmap/visitable/ship/landable/overmapdemo
	name = "VSS Overmap Demo"
	desc = "Small little shuttle nonetheless capable of overmap travel!"
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Overmap-Demo"
