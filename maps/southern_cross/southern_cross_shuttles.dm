// Cargo shuttle.
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 10
	shuttle_area = /area/shuttle/supply
	landmark_offsite = "supply_offsite"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

/obj/effect/shuttle_landmark/southern_cross/supply_offsite
	name = "Centcom Supply Depot"
	landmark_tag = "supply_offsite"
	base_area = /area/centcom/command
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/southern_cross/supply_station
	name = "Station"
	landmark_tag = "supply_station"
	docking_controller = "cargo_bay"

//Admin
/obj/machinery/computer/shuttle_control/administration
	name = "shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "Administration"

/datum/shuttle/autodock/ferry/administration
	name = "Administration"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 0
	shuttle_area = /area/shuttle/administration/centcom
	landmark_offsite = "admin_offsite"
	landmark_station = "admin_station"
	docking_controller_tag = "admin_shuttle"

/obj/effect/shuttle_landmark/southern_cross/admin_offsite
	name = "Centcom"
	landmark_tag = "admin_offsite"
	docking_controller = "admin_shuttle_bay"
	base_area = /area/centcom/command
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/southern_cross/admin_station
	name = "SC Dock 2-E"
	landmark_tag = "admin_station"
	docking_controller = "admin_shuttle_dock_airlock"

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

/obj/effect/shuttle_landmark/southern_cross/transport1_offsite
	name = "Centcom"
	landmark_tag = "transport1_offsite"
	docking_controller = "centcom_shuttle_bay"
	base_area = /area/centcom/command
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/southern_cross/transport1_station
	name = "SC Dock 3-A"
	landmark_tag = "transport1_station"
	docking_controller = "centcom_shuttle_dock_airlock"


//Merc

//Skipjack
/*
/obj/machinery/computer/shuttle_control/multi/skipjack
	name = "skipjack control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Skipjack"



/datum/shuttle/multi_shuttle/skipjack/New()
	arrival_message = "Attention.  Unidentified object approaching the station."
	departure_message = "Attention.  Unidentified object exiting local space.  Unidentified object expected to escape Kara gravity well with current velocity."
	..()
*/



//Ninja Shuttle.

/*
/obj/machinery/computer/shuttle_control/multi/ninja
	name = "stealth shuttle control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Ninja"

/datum/shuttle/multi_shuttle/ninja
	name = "Ninja"
	warmup_time = 0
	origin = /area/ninja_dojo/start
	interim = /area/ninja_dojo/transit
	start_location = "Clan Dojo"
	destinations = list(
		"South of First Deck" = /area/ninja_dojo/firstdeck,
		"North of Second Deck" = /area/ninja_dojo/seconddeck,
		"East of Third Deck" = /area/ninja_dojo/thirddeck,
		"Planet Outposts" = /area/ninja_dojo/planet,
		"Docking Port" = /area/ninja_dojo/arrivals_dock,
		)
	docking_controller_tag = "ninja_shuttle"
	destination_dock_targets = list(
		"Dojo Outpost" = "ninja_base",
		"Docking Port" = "ninja_shuttle_dock_airlock",
		)
	announcer = "Southern Cross Sensor Array"
	arrival_message = "Attention, anomalous sensor reading detected entering station proximity."
	departure_message = "Attention, anomalous sensor reading detected leaving station proximity."
*/





//Trade Ship

/obj/machinery/computer/shuttle_control/merchant
	name = "merchant shuttle control console"
	icon_keyboard = "power_key"
	icon_screen = "shuttle"
	shuttle_tag = "Merchant"

/datum/shuttle/autodock/ferry/merchant
	name = "Merchant"
	location = FERRY_LOCATION_OFFSITE
	warmup_time = 0
	shuttle_area = /area/shuttle/merchant/home
	landmark_station = "merchant_station"
	landmark_offsite = "merchant_offsite"
	docking_controller_tag = "trade_shuttle"

/obj/effect/shuttle_landmark/southern_cross/merchant_offsite
	name = "Trade Station"
	landmark_tag = "merchant_offsite"
	docking_controller = "trade_shuttle_bay"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/southern_cross/merchant_station
	name = "SC Dock 1-E"
	landmark_tag = "merchant_station"
	docking_controller = "trade_shuttle_dock_airlock"

// Arrivals Shuttle
/datum/shuttle/autodock/ferry/arrivals/southern_cross
	name = "Arrivals"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/arrival/pre_game
	landmark_offsite = "arrivals_offsite"
	landmark_station = "arrivals_station"
	docking_controller_tag = "arrivals_shuttle"

/obj/effect/shuttle_landmark/southern_cross/arrivals_offsite
	name = "Transit to Station"
	landmark_tag = "arrivals_offsite"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/southern_cross/arrivals_station
	name = "SC Dock 2-C/D"
	landmark_tag = "arrivals_station"
	docking_controller = "arrivals_dock"

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
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/obj/effect/shuttle_landmark/southern_cross/escape/offsite
	name = "Centcom"
	landmark_tag = "escape_offsite"
	docking_controller = "centcom_dock"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/southern_cross/escape/station
	name = "Station Escape Dock"
	landmark_tag = "escape_station"
	docking_controller = "escape_dock"

/obj/effect/shuttle_landmark/southern_cross/escape/transit
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
/obj/effect/shuttle_landmark/southern_cross/escape_pod##NUMBER/station { \
	name = "Station"; \
	landmark_tag = "escape_pod_"+ #NUMBER +"_station"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	base_area = /area/space; \
	base_turf = /turf/simulated/floor/airless; \
} \
/obj/effect/shuttle_landmark/southern_cross/escape_pod##NUMBER/offsite { \
	name = "Recovery"; \
	landmark_tag = "escape_pod_"+ #NUMBER +"_offsite"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_recovery"; \
} \
/obj/effect/shuttle_landmark/southern_cross/escape_pod##NUMBER/transit { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_transit"; \
	landmark_flags = LANDMARK_CREATES_SAFE_SITE; \
}

ESCAPE_POD(1)
ESCAPE_POD(2)
ESCAPE_POD(3)
ESCAPE_POD(4)
ESCAPE_POD(5)
ESCAPE_POD(6)
ESCAPE_POD(7)
ESCAPE_POD(8)

#undef ESCAPE_POD

// Cryostorage Escape Pod
/datum/shuttle/autodock/ferry/escape_pod/escape_pod_cryo
	name = "Cryostorage Shuttle"
	location = FERRY_LOCATION_STATION
	warmup_time = 0
	shuttle_area = /area/shuttle/cryo/station
	landmark_station = "cryostorage_station"
	landmark_offsite = "cryostorage_offsite"
	landmark_transition = "cryostorage_transit"
	docking_controller_tag = "cryostorage_shuttle"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

/obj/effect/shuttle_landmark/southern_cross/cryostorage_station
	name = "Station Cryostorage Dock"
	landmark_tag = "cryostorage_station"
	docking_controller = "cryostorage_shuttle_berth"
	base_area = /area/space
	base_turf = /turf/simulated/floor/airless

/obj/effect/shuttle_landmark/southern_cross/cryostorage_offsite
	name = "Recovery"
	landmark_tag = "cryostorage_offsite"
	docking_controller = "cryostorage_shuttle_recovery"

/obj/effect/shuttle_landmark/southern_cross/cryostorage_transit
	landmark_tag = "cryostorage_transit"
	landmark_flags = LANDMARK_CREATES_SAFE_SITE

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

/obj/effect/shuttle_landmark/southern_cross/large_escape_pod1/station
	name = "Station"
	landmark_tag = "large_escape_pod1_station"
	docking_controller = "large_escape_pod_1_berth"
	base_area = /area/maintenance/firstdeck/centralstarboard
	base_turf = /turf/simulated/floor/airless

/obj/effect/shuttle_landmark/southern_cross/large_escape_pod1/offsite
	name = "Recovery"
	landmark_tag = "large_escape_pod1_offsite"
	docking_controller = "large_escape_pod_1_recovery"

/obj/effect/shuttle_landmark/southern_cross/large_escape_pod1/transit
	landmark_tag = "large_escape_pod1_transit"
	landmark_flags = LANDMARK_CREATES_SAFE_SITE

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

/obj/effect/shuttle_landmark/southern_cross/large_escape_pod2/station
	name = "Station"
	landmark_tag = "large_escape_pod2_station"
	docking_controller = "large_escape_pod_2_berth"
	base_area = /area/maintenance/firstdeck/centralport
	base_turf = /turf/simulated/floor/airless

/obj/effect/shuttle_landmark/southern_cross/large_escape_pod2/offsite
	name = "Recovery"
	landmark_tag = "large_escape_pod2_offsite"
	docking_controller = "large_escape_pod_2_recovery"

/obj/effect/shuttle_landmark/southern_cross/large_escape_pod2/transit
	landmark_tag = "large_escape_pod2_transit"
	landmark_flags = LANDMARK_CREATES_SAFE_SITE


// Destination datums



// Mercenary Shuttle


// Ninja shuttle
/*
/datum/shuttle/multi_shuttle/skipjack
	name = "Skipjack"
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE
	origin = /area/skipjack_station/start
	interim = /area/skipjack_station/transit
	destinations = list(
		"North of First deck" = /area/skipjack_station/firstdeck,
		"West of Second deck" = /area/skipjack_station/seconddeck,
		"East of Third deck" = /area/skipjack_station/thirddeck,
		"Planet" = /area/skipjack_station/planet,
		"Docking Port" = /area/skipjack_station/arrivals_dock,
		)
	docking_controller_tag = "skipjack_shuttle"
	destination_dock_targets = list(
		"Raider Outpost" = "skipjack_base",
		"Docking Port" = "skipjack_shuttle_dock_airlock",
		)
	announcer = "Automated Traffic Control"
*/



// Heist shuttle
