////////////////SHUTTLE TIME///////////////////

/////EXPLORATION SHUTTLE
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/stellardelight/exploration
	name = "boat control console"
	shuttle_tag = "Exploration Shuttle"
	req_one_access = null
	ai_control = TRUE

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/exploration
	name = "Exploration Shuttle Landing Pad"
	base_area = /area/stellardelight/deck1/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "sd_explo"
	docking_controller = "explodocker_bay"

/////MINING SHUTTLE
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/stellardelight/mining
	name = "boat control console"
	shuttle_tag = "Mining Shuttle"
	req_one_access = null
	ai_control = TRUE

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/mining
	name = "Mining Shuttle Landing Pad"
	base_area = /area/stellardelight/deck1/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "sd_mining"
	docking_controller = "miningdocker_bay"

/////STARSTUFF/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/sdboat
	name = "Starstuff control console"
	shuttle_tag = "Starstuff"
	req_one_access = list(access_pilot)

/obj/effect/overmap/visitable/ship/landable/sd_boat
	name = "NTV Starstuff"
	desc = "A small shuttle from the NRV Stellar Delight."
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Starstuff"
	known = TRUE

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/sdboat
	name = "Port Shuttlepad"
	base_area = /area/stellardelight/deck3/exterior
	base_turf = /turf/simulated/floor/reinforced/airless
	landmark_tag = "port_shuttlepad"
	docking_controller = "sd_port_landing"

/area/shuttle/sdboat/fore
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Starstuff Cockpit"
	requires_power = 1

/area/shuttle/sdboat/aft
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Starstuff Crew Compartment"
	requires_power = 1

/////LANDING LANDMARKS/////
/obj/effect/shuttle_landmark/premade/sd/deck1/portairlock
	name = "Near Deck 1 Port Airlock"
	landmark_tag = "sd-1-23-54"
/obj/effect/shuttle_landmark/premade/sd/deck1/aft
	name = "Near Deck 1 Aft"
	landmark_tag = "sd-1-67-15"
/obj/effect/shuttle_landmark/premade/sd/deck1/fore
	name = "Near Deck 1 Fore"
	landmark_tag = "sd-1-70-130"
/obj/effect/shuttle_landmark/premade/sd/deck1/starboard
	name = "Near Deck 1 Starboard"
	landmark_tag = "sd-1-115-85"

/obj/effect/shuttle_landmark/premade/sd/deck2/port
	name = "Near Deck 2 Port"
	landmark_tag = "sd-2-25-98"
/obj/effect/shuttle_landmark/premade/sd/deck2/starboard
	name = "Near Deck 2 Starboard"
	landmark_tag = "sd-2-117-98"

/obj/effect/shuttle_landmark/premade/sd/deck3/portairlock
	name = "Near Deck 3 Port Airlock"
	landmark_tag = "sd-3-22-78"
/obj/effect/shuttle_landmark/premade/sd/deck3/portlanding
	name = "Near Deck 3 Port Landing Pad"
	landmark_tag = "sd-3-36-33"
/obj/effect/shuttle_landmark/premade/sd/deck3/starboardlanding
	name = "Near Deck 3 Starboard Landing Pad"
	landmark_tag = "sd-3-104-33"
/obj/effect/shuttle_landmark/premade/sd/deck3/starboardairlock
	name = "Near Deck 3 Starboard Airlock"
	landmark_tag = "sd-3-120-78"

/obj/item/paper/dockingcodes/sd
	name = "Stellar Delight Docking Codes"
