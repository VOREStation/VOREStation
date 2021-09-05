//Cynosure Shuttles

// Arrivals Shuttle
/datum/shuttle/autodock/ferry/arrivals/cynosure
	name = "Arrivals"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/arrival/pre_game
	landmark_offsite = "arrivals_offsite"
	landmark_station = "arrivals_station"
	docking_controller_tag = "arrivals_shuttle"
	ceiling_type = /turf/simulated/floor/reinforced

/obj/effect/shuttle_landmark/cynosure/arrivals_offsite
	name = "Transit to Station"
	landmark_tag = "arrivals_offsite"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/cynosure/arrivals_station
	name = "Cynosure Arrivals Pad	"
	landmark_tag = "arrivals_station"
	docking_controller = "arrivals_dock"

// Cargo shuttle.

/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 10
	shuttle_area = /area/shuttle/supply
	landmark_offsite = "supply_offsite"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	ceiling_type = /turf/simulated/floor/reinforced
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

/obj/effect/shuttle_landmark/cynosure/supply_offsite
	name = "Centcom Supply Depot"
	landmark_tag = "supply_offsite"
	base_area = /area/centcom/command
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/cynosure/supply_station
	name = "Station"
	landmark_tag = "supply_station"
	docking_controller = "cargo_bay"

//Transport

/obj/machinery/computer/shuttle_control/centcom
	name = "shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "Centcom"

/datum/shuttle/autodock/ferry/centcom
	name = "Centcom"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 0
	shuttle_area = /area/shuttle/transport1/centcom
	landmark_offsite = "transport1_offsite"
	landmark_station = "transport1_station"
	docking_controller_tag = "centcom_shuttle"

/obj/effect/shuttle_landmark/cynosure/transport1_offsite
	name = "Centcom"
	landmark_tag = "transport1_offsite"
	docking_controller = "centcom_shuttle_bay"
	base_area = /area/centcom/command
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/cynosure/transport1_station
	name = "SC Dock 3-A"
	landmark_tag = "transport1_station"
	docking_controller = "centcom_shuttle_dock_airlock"

//Escape Pods

/datum/shuttle/autodock/ferry/emergency/centcom
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 10
	shuttle_area = /area/shuttle/escape/centcom
	landmark_offsite = "escape_offsite"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit";
	docking_controller_tag = "escape_shuttle"
	ceiling_type = /turf/simulated/floor/reinforced/
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/obj/effect/shuttle_landmark/cynosure/escape/offsite
	name = "Centcom"
	landmark_tag = "escape_offsite"
	docking_controller = "centcom_dock"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/cynosure/escape/station
	name = "Cynosure Departures Pad"
	landmark_tag = "escape_station"
	docking_controller = "escape_dock"

/obj/effect/shuttle_landmark/cynosure/escape/transit
	landmark_tag = "escape_transit"

// Escape Pods - Save me from typing this eight billion times
#define ESCAPE_POD(NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/escape_pod##NUMBER { \
	name = "Escape Pod " + #NUMBER; \
	location = FERRY_LOCATION_STATION; \
	warmup_time = 0; \
	shuttle_area = /area/shuttle/escape_pod##NUMBER/station; \
	docking_controller_tag = "escape_pod_" + #NUMBER; \
	landmark_station = "escape_pod_"+ #NUMBER +"_station"; \
	landmark_offsite = "escape_pod_"+ #NUMBER +"_offsite"; \
	landmark_transition = "escape_pod_"+ #NUMBER +"_transit"; \
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN; \
} \
/obj/effect/shuttle_landmark/cynosure/escape_pod##NUMBER/station { \
	name = "Station"; \
	landmark_tag = "escape_pod_"+ #NUMBER +"_station"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	base_area = /area/space; \
	base_turf = /turf/simulated/floor/airless; \
} \
/obj/effect/shuttle_landmark/cynosure/escape_pod##NUMBER/offsite { \
	name = "Recovery"; \
	landmark_tag = "escape_pod_"+ #NUMBER +"_offsite"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_recovery"; \
} \
/obj/effect/shuttle_landmark/cynosure/escape_pod##NUMBER/transit { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_transit"; \
	flags = SLANDMARK_FLAG_AUTOSET; \
}

ESCAPE_POD(1)

#undef ESCAPE_POD

// Large Escape Pod 1
/datum/shuttle/autodock/ferry/escape_pod/large_escape_pod1
	name = "Large Escape Pod 1"
	location = FERRY_LOCATION_STATION
	warmup_time = 0
	shuttle_area = /area/shuttle/large_escape_pod1/station
	landmark_station = "large_escape_pod1_station"
	landmark_offsite = "large_escape_pod1_offsite"
	landmark_transition = "large_escape_pod1_transit"
	docking_controller_tag = "large_escape_pod_1"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/obj/effect/shuttle_landmark/cynosure/large_escape_pod1/station
	name = "Station"
	landmark_tag = "large_escape_pod1_station"
	docking_controller = "large_escape_pod_1_berth"
	base_area = /area/surface/outpost/research/xenoarcheology/surface
	base_turf = /turf/simulated/floor/airless

/obj/effect/shuttle_landmark/cynosure/large_escape_pod1/offsite
	name = "Recovery"
	landmark_tag = "large_escape_pod1_offsite"
	docking_controller = "large_escape_pod_1_recovery"

/obj/effect/shuttle_landmark/cynosure/large_escape_pod1/transit
	landmark_tag = "large_escape_pod1_transit"
	flags = SLANDMARK_FLAG_AUTOSET

// Large Escape Pod 2
/datum/shuttle/autodock/ferry/escape_pod/large_escape_pod2
	name = "Large Escape Pod 2"
	location = FERRY_LOCATION_STATION
	warmup_time = 0
	shuttle_area = /area/shuttle/large_escape_pod2/station
	landmark_station = "large_escape_pod2_station"
	landmark_offsite = "large_escape_pod2_offsite"
	landmark_transition = "large_escape_pod2_transit"
	docking_controller_tag = "large_escape_pod_2"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/obj/effect/shuttle_landmark/cynosure/large_escape_pod2/station
	name = "Station"
	landmark_tag = "large_escape_pod2_station"
	docking_controller = "large_escape_pod_2_berth"
	base_area = /area/surface/station/hallway/primary/secondfloor/east
	base_turf = /turf/simulated/floor/airless

/obj/effect/shuttle_landmark/cynosure/large_escape_pod2/offsite
	name = "Recovery"
	landmark_tag = "large_escape_pod2_offsite"
	docking_controller = "large_escape_pod_2_recovery"

/obj/effect/shuttle_landmark/cynosure/large_escape_pod2/transit
	landmark_tag = "large_escape_pod2_transit"
	flags = SLANDMARK_FLAG_AUTOSET

//Cynosure Station Docks

/obj/effect/shuttle_landmark/cynosure/pads/pad3
	name = "Shuttle Pad Three"
	landmark_tag = "nav_pad3_cynosure"
	docking_controller = "pad3"
	base_area = /area/surface/outside/station/shuttle/pad3
	base_turf = /turf/simulated/floor/plating/sif/planetuse

/obj/effect/shuttle_landmark/cynosure/pads/pad4
	name = "Shuttle Pad Four"
	landmark_tag = "nav_pad4_cynosure"
	docking_controller = "pad4"
	base_area = /area/surface/outside/station/shuttle/pad4
	base_turf = /turf/simulated/floor/plating/sif/planetuse

//Tcomms Sat Docks

/obj/effect/shuttle_landmark/cynosure/tcomms
	name = "Telecommunications Satellite"
	landmark_tag = "nav_telecomm_dockarm"
	docking_controller = "tcomdock_airlock"
	base_area = /area/space
	base_turf = /turf/space


// Explorer Shuttle

/datum/shuttle/autodock/overmap/explorer_shuttle
	name = "Exploration Shuttle"
	warmup_time = 0
	current_location = "nav_pad4_cynosure"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/exploration/general, /area/shuttle/exploration/cockpit, /area/shuttle/exploration/cargo)
	fuel_consumption = 3
	ceiling_type = /turf/simulated/floor/reinforced/airless

/obj/effect/overmap/visitable/ship/landable/explorer_shuttle
	name = "Exploration Shuttle"
	desc = "The exploration team's shuttle."
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Exploration Shuttle"

/obj/machinery/computer/shuttle_control/explore/explorer_shuttle
	name = "takeoff and landing console"
	shuttle_tag = "Exploration Shuttle"
	req_one_access = list(access_explorer)

/*
// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "generic_shuttle.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/hybrid
    name = "OM Ship - Generic Shuttle"
    desc = "A small privately-owned vessel."
    mappath = 'generic_shuttle.dmm'
    annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/generic_shuttle/eng
    name = "\improper Private Vessel - Engineering"
    icon_state = "shuttle2"
    requires_power = 1

/area/shuttle/generic_shuttle/gen
    name = "\improper Private Vessel - General"
    icon_state = "shuttle2"
    requires_power = 1

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/generic_shuttle
    name = "short jump console"
    shuttle_tag = "Private Vessel"
    req_one_access = list(access_pilot)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/generic_shuttle
    name = "Origin - Private Vessel"
    base_area = /area/space
    base_turf = /turf/space
    landmark_tag = "omship_spawn_generic_shuttle"
    shuttle_type = /datum/shuttle/autodock/overmap/generic_shuttle

// The 'shuttle'
/datum/shuttle/autodock/overmap/generic_shuttle
    name = "Private Vessel"
    current_location = "omship_spawn_generic_shuttle"
    docking_controller_tag = "generic_shuttle_docker"
    shuttle_area = list(/area/shuttle/generic_shuttle/eng, /area/shuttle/generic_shuttle/gen)
    defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/generic_shuttle
    scanner_name = "Private Vessel"
    scanner_desc = @{"[i]Registration[/i]: PRIVATE
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
    vessel_mass = 1000
    vessel_size = SHIP_SIZE_TINY
    shuttle = "Private Vessel"
*/