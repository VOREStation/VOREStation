//Normal map defs
#define Z_LEVEL_SHIP_LOW					1
#define Z_LEVEL_SHIP_MID					2
#define Z_LEVEL_SHIP_HIGH					3
#define Z_LEVEL_CENTCOM						4
#define Z_LEVEL_MISC						5
#define Z_LEVEL_BEACH						6
#define Z_LEVEL_BEACH_CAVE					7
#define Z_LEVEL_AEROSTAT					8
#define Z_LEVEL_AEROSTAT_SURFACE			9
#define Z_LEVEL_DEBRISFIELD					10
#define Z_LEVEL_FUELDEPOT					11
#define Z_LEVEL_OVERMAP						12
#define Z_LEVEL_OFFMAP1						13
#define Z_LEVEL_GATEWAY						14

//Camera networks
#define NETWORK_HALLS "Halls"
#define NETWORK_TCOMMS "Telecommunications" //Using different from Polaris one for better name
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_EXPLORATION "Exploration"
#define NETWORK_XENOBIO "Xenobiology"

/datum/map/stellar_delight/New()
	..()
	var/choice = pickweight(list(
		"logo1" = 50,
		"logo2" = 50,
		"gateway" = 5,
		"youcanttaketheskyfromme" = 200
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/stellar_delight
	name = "Virgo"
	full_name = "NRV Stellar Delight"
	path = "stellardelight"

	use_overmap = TRUE
	overmap_z = Z_LEVEL_OVERMAP
	overmap_size = 99
	overmap_event_areas = 200
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/stellar_delight

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("youcanttaketheskyfromme")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

	accessible_z_levels = list(
		Z_LEVEL_SHIP_LOW = 100,
		Z_LEVEL_SHIP_MID = 100,
		Z_LEVEL_SHIP_HIGH = 100
		)

/*
	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH))
*/
	station_name  = "NRV Stellar Delight"
	station_short = "Stellar Delight"
	dock_name     = "Virgo-3B Colony"
	dock_type     = "surface"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Virgo-Erigone"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The shuttle has departed. Estimate %ETA% until arrival at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The shuttle will arrive shortly. Those departing should proceed to deck three, aft within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Evacuation Shuttle"
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has departed. Estimate %ETA% until arrival at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule shuttle has been called. It will arrive at deck three, aft in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation shuttle has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIRCUITS,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_EXPLORATION,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_OUTSIDE,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_TELECOM,
							NETWORK_HALLS
							)
	secondary_networks = list(
							NETWORK_ERT,
							NETWORK_MERCENARY,
							NETWORK_THUNDER,
							NETWORK_COMMUNICATORS,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_POWER,
							NETWORK_ALARM_FIRE,
							NETWORK_TALON_HELMETS,
							NETWORK_TALON_SHIP
							)

	bot_patrolling = FALSE

	allowed_spawns = list("Gateway","Cryogenic Storage","Cyborg Storage","ITV Talon Cryo")
	spawnpoint_died = /datum/spawnpoint/cryo
	spawnpoint_left = /datum/spawnpoint/gateway
	spawnpoint_stayed = /datum/spawnpoint/cryo

	/*
	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)
	*/

	default_skybox = /datum/skybox_settings/stellar_delight

	unit_test_exempt_areas = list()

	unit_test_exempt_from_atmos = list() //it maint


	lateload_z_levels = list(
		list("Ship - Central Command"),
		list("Ship - Misc"), //Shuttle transit zones, holodeck templates, etc
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface"),
		list("Debris Field - Z1 Space"),
		list("Fuel Depot - Z1 Space"),
		list("Overmap"),
		list("Offmap Ship - Talon V2")
		)

	lateload_single_pick = list(
		list("Carp Farm"),
		list("Snow Field"),
		list("Listening Post"),
		list(list("Honleth Highlands A", "Honleth Highlands B")),
		list("Arynthi Lake Underground A","Arynthi Lake A"),
		list("Arynthi Lake Underground B","Arynthi Lake B"),
		list("Eggnog Town Underground","Eggnog Town"),
		list("Wild West")
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_SHIP_LOW,
		Z_LEVEL_SHIP_MID,
		Z_LEVEL_SHIP_HIGH,
		Z_LEVEL_MISC,
		Z_LEVEL_BEACH,
		Z_LEVEL_AEROSTAT
		)

/*
	belter_docked_z = 		list(Z_LEVEL_SPACE_LOW)
	belter_transit_z =	 	list(Z_LEVEL_MISC)
	belter_belt_z = 		list(Z_LEVEL_ROGUEMINE_1,
						 		 Z_LEVEL_ROGUEMINE_2)

	mining_station_z =		list(Z_LEVEL_SPACE_LOW)
	mining_outpost_z =		list(Z_LEVEL_SURFACE_MINE)
*/
	lateload_single_pick = null //Nothing right now.

	planet_datums_to_make = list(/datum/planet/virgo3b,
								/datum/planet/virgo4)

/datum/map/stellar_delight/get_map_info()
	. = list()
	. +=  "The [full_name] is a recently commissioned multi-role starship assigned to patrol the Virgo-Erigone system. Its mission is flexible, being a response vessel, the [station_short] is assigned to respond to emergencies in the system, and to investigate anomalous activities where a more specialized vessel is unavailable.<br>"
	. +=  "Humanity has spread across the stars and has met many species on similar or even more advanced terms than them - it's a brave new world and many try to find their place in it . <br>"
	. +=  "Though Virgo-Erigone is not important for the great movers and shakers, it sees itself in the midst of the interests of a reviving alien species of the Zorren, corporate and subversive interests and other exciting dangers the Periphery has to face.<br>"
	. +=  "As an employee or contractor of NanoTrasen, operators of the Adephagia and one of the galaxy's largest corporations, you're probably just here to do a job."
	return jointext(., "<br>")

/*
/datum/map/stellar_delight/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SURFACE_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SURFACE_MINE, 64, 64)         // Create the mining ore distribution map.

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SOLARS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_SOLARS, 64, 64)         // Create the mining ore distribution map.

	return 1
*/

/datum/skybox_settings/stellar_delight
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/virgo3b
	expected_z_levels = list(Z_LEVEL_CENTCOM)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_LEVEL_BEACH
	)

// For making the 6-in-1 holomap, we calculate some offsets
#define SHIP_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define SHIP_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define SHIP_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE) - TETHER_HOLOMAP_CENTER_GUTTER) / 2) // 80
#define SHIP_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (2*TETHER_MAP_SIZE)) / 2) // 30

/obj/effect/landmark/map_data/stellar_delight
	height = 3

/obj/effect/overmap/visitable/ship/stellar_delight
	name = "NRV Stellar Delight"
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "stellar_delight_g"
	desc = "Spacefaring vessel. Friendly IFF detected."
	scanner_desc = @{"[i]Registration[/i]: NRV Stellar Delight
[i]Class[/i]: Nanotrasen Response Vessel
[i]Transponder[/i]: Transmitting (CIV), non-hostile"
[b]Notice[/b]: A response vessel registered to Nanotrasen."}
	vessel_mass = 25000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("starboard_shuttlepad","port_shuttlepad","sd-1-23-54","sd-1-67-15","sd-1-70-130","sd-1-115-85","sd-2-25-98","sd-2-117-98","sd-3-22-78","sd-3-36-33","sd-3-104-33","sd-3-120-78")
	initial_restricted_waypoints = list("Exploration Shuttle" = list("sd_explo"), "Mining Shuttle" = list("sd_mining"))
	levels_for_distress = list(Z_LEVEL_OFFMAP1, Z_LEVEL_BEACH, Z_LEVEL_AEROSTAT, Z_LEVEL_DEBRISFIELD, Z_LEVEL_FUELDEPOT)
	unowned_areas = list(/area/shuttle/sdboat)
	known = TRUE
	start_x = 2
	start_y = 2

	fore_dir = NORTH

	skybox_icon = 'stelardelightskybox.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 450
	skybox_pixel_y = 200

/obj/effect/overmap/visitable/ship/stellar_delight/build_skybox_representation()
	..()
	if(!cached_skybox_image)
		return
	cached_skybox_image.add_overlay("glow")


// We have a bunch of stuff common to the station z levels
/datum/map_z_level/stellar_delight
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/stellar_delight/deck_one
	z = Z_LEVEL_SHIP_LOW
	name = "Deck 1"
	base_turf = /turf/space
	transit_chance = 100

/datum/map_z_level/stellar_delight/deck_two
	z = Z_LEVEL_SHIP_MID
	name = "Deck 2"
	base_turf = /turf/simulated/open
	transit_chance = 100

/datum/map_z_level/stellar_delight/deck_three
	z = Z_LEVEL_SHIP_HIGH
	name = "Deck 3"
	base_turf = /turf/simulated/open
	transit_chance = 100

/datum/map_template/ship_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/////STATIC LATELOAD/////

/datum/map_template/ship_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)

/datum/map_template/ship_lateload/ship_centcom
	name = "Ship - Central Command"
	desc = "Central Command lives here!"
	mappath = 'ship_centcom.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/ship_centcom

/datum/map_z_level/ship_lateload/ship_centcom
	z = Z_LEVEL_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks

/area/centcom //Just to try to make sure there's not space!!!
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_template/ship_lateload/ship_misc
	name = "Ship - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = 'ship_misc.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/misc

/datum/map_z_level/ship_lateload/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_template/ship_lateload/overmap
	name = "Overmap"
	desc = "Overmap lives here :3"
	mappath = 'overmap.dmm'

	associated_map_datum = /datum/map_z_level/ship_lateload/overmap

/datum/map_z_level/ship_lateload/overmap
	z = Z_LEVEL_OVERMAP
	name = "Overmap"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "../expedition_vr/aerostat/_aerostat_science_outpost.dm"
/datum/map_template/common_lateload/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	mappath = 'maps/expedition_vr/aerostat/aerostat_science_outpost.dmm'
	associated_map_datum = /datum/map_z_level/common_lateload/away_aerostat



////////////////SHUTTLE TIME///////////////////

//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_station"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = SOUTH
	docking_controller_tag = "escape_shuttle"

/datum/shuttle/autodock/ferry/escape_pod/portescape
	name = "Port Escape Pod"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/stellardelight/deck2/portescape
	warmup_time = 0
	landmark_station = "port_ship_berth"
	landmark_offsite = "port_escape_cc"
	landmark_transition = "port_escape_transit"
	docking_controller_tag = "port_escape_pod"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = EAST

/datum/shuttle/autodock/ferry/escape_pod/starboardescape
	name = "Starboard Escape Pod"
	location = FERRY_LOCATION_STATION
	shuttle_area = /area/stellardelight/deck2/starboardescape
	warmup_time = 0
	landmark_station = "starboard_ship_berth"
	landmark_offsite = "starboard_escape_cc"
	landmark_transition = "starboard_escape_transit"
	docking_controller_tag = "starboard_escape_pod"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	move_direction = WEST


//////////////////////////////////////////////////////////////
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_station"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	move_direction = WEST

/////EXPLORATION SHUTTLE
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/stellardelight/exploration
	name = "boat control console"
	shuttle_tag = "Exploration Shuttle"
	req_one_access = null

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/exploration
	name = "Exploration Shuttle Landing Pad"
	base_area = /area/stellardelight/deck1/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "sd_explo"
	docking_controller = "explodocker_bay"
	shuttle_type = /datum/shuttle/autodock/overmap/exboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/exboat
	name = "Exploration Shuttle"
	current_location = "sd_explo"
	docking_controller_tag = "explodocker"
	shuttle_area = /area/stellardelight/deck1/exploshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE
	range = 1

/////MINING SHUTTLE
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/stellardelight/mining
	name = "boat control console"
	shuttle_tag = "Mining Shuttle"
	req_one_access = null

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/mining
	name = "Mining Shuttle Landing Pad"
	base_area = /area/stellardelight/deck1/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "sd_mining"
	docking_controller = "miningdocker_bay"
	shuttle_type = /datum/shuttle/autodock/overmap/mineboat

// The 'shuttle'
/datum/shuttle/autodock/overmap/mineboat
	name = "Mining Shuttle"
	current_location = "sd_mining"
	docking_controller_tag = "miningdocker"
	shuttle_area = /area/stellardelight/deck1/miningshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE
	range = 1

/////STARSTUFF/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/sdboat
	name = "Starstuff control console"
	shuttle_tag = "Starstuff"
	req_one_access = list(access_pilot)

/obj/effect/overmap/visitable/ship/landable/sd_boat
	name = "NTV Starstuff"
	desc = "A small shuttle from the NRV Stellar Delight."
	vessel_mass = 1000
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
	shuttle_type = /datum/shuttle/autodock/overmap/sdboat

/datum/shuttle/autodock/overmap/sdboat
	name = "Starstuff"
	current_location = "port_shuttlepad"
	docking_controller_tag = "sd_bittyshuttle" 
	shuttle_area = list(/area/shuttle/sdboat,/area/shuttle/sdboat/aft)
	fuel_consumption = 2
	defer_initialisation = TRUE

/area/shuttle/sdboat
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Starstuff Cockpit"
	requires_power = 1

/area/shuttle/sdboat/aft
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Starstuff Crew Compartment"
	requires_power = 1

/////Virgo Flyer/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/ccboat
	name = "Virgo Flyer control console"
	shuttle_tag = "Virgo Flyer"
	req_one_access = list(access_pilot)

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

/obj/item/weapon/paper/dockingcodes/sd
	name = "Stellar Delight Docking Codes"
	codes_from_z = Z_LEVEL_SHIP_LOW

/////FOR CENTCOMM (at least)/////
/obj/effect/overmap/visitable/sector/virgo3b
	name = "Virgo 3B"
	desc = "Full of phoron, and home to the NSB Adephagia."
	scanner_desc = @{"[i]Registration[/i]: NSB Adephagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	known = TRUE
	
	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "virgo3b"

	skybox_icon = 'icons/skybox/virgo3b.dmi'
	skybox_icon_state = "small"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	initial_restricted_waypoints = list("Central Command Shuttlepad" = list("cc_shuttlepad"))

/////SD Starts at V3b to pick up crew refuel and repair (And to make sure it doesn't spawn on hazards)
/obj/effect/overmap/visitable/sector/virgo3b/Initialize()
	. = ..()
	for(var/obj/effect/overmap/visitable/ship/stellar_delight/sd in world)
		sd.forceMove(loc, SOUTH)
		return

/obj/effect/overmap/visitable/sector/virgo3b/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/virgo3b/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/effect/overmap/visitable/sector/virgo3b/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttles.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		atc.msg(message)

/obj/item/weapon/paper/sdshield
	name = "ABOUT THE SHIELD GENERATOR"
	info = "<H1>ABOUT THE SHIELD GENERATOR</H1><BR><BR>If you&#39;re up here you are more than likely worried about hitting rocks or some other such thing. It is good to worry about such things as that is an inevitability.<BR><BR>The Stellar Delight is a rather compact vessel, so a setting of 55 to the range will just barely cover her aft. <BR><BR>It is recommended that you turn off all of the different protection types except multi dimensional warp and whatever it is you&#39;re worried about running into. (probably meteors (hyperkinetic)). <BR><BR>With only those two and all the other default settings, the shield uses more than 6 MW to run, which is more than the ship can ordinarily produce. AS SUCH, it is also recommended that you reduce the input cap to whatever you find reasonable (being as it defaults to 1 MW, which is the entirety of the stock power supply) and activate and configure the shield BEFORE you need it. <BR><BR>The shield takes some time to expand its range to the desired specifications, and on top of that, under the default low power setting, takes around 40 seconds to spool up. Once it is active, the fully charged internal capacitors will last for around 1 to 2 minutes before depleting fully. You can increase the passive energy use to decrease the spool up time, but it also uses the stored energy much faster, so, that is not recommended except in dire emergencies.<BR><BR>So, this shield is not intended to be run indefinitely, unless you seriously beef up the ship&#39;s engine and power supply.<BR><BR>Fortunately, if you&#39;ve got a good pilot, you shouldn&#39;t really need the shield generator except in rare cases and only for short distances. Still, it is a good idea to configure the shield to be ready before you need it.<BR><BR>Good luck out there - <I>Budly Gregington</I>"

/obj/item/weapon/book/manual/sd_guide
	name = "Stellar Delight User's Guide"
	icon = 'icons/obj/library.dmi'
	icon_state ="newscodex"
	item_state = "newscodex"
	author = "Central Command"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Stellar Delight User's Guide"

/obj/item/weapon/book/manual/sd_guide/New()
	..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Stellar Delight Operations</h1>
				<br><br>
				Welcome to the Stellar Delight! Before you get started there are a few things you ought to know.
				<br><br>
				The Stellar Delight is a Nanotrasen response vessel operating in the Virgo-Erigone system. It's primary duty is in answering calls for help, investigating anomalies in space around the system, and generally responding to requests from Central Command or whoever else needs the services the vessel can provide. It has fully functioning security, medical, and research facilities, as well as a host of civillian facilities, in addition to the standard things one might expect to find on such a ship. That is to say, the ship doesn't have a highly defined specialization, it is just as capable as a small space station might be.
				<br><br>
				Notably though, there are some research facilities that are not safe to carry around. There is a refurbished Aerostat that has been set up over Virgo 2 that posesses a number of different, more dangerous research facilities.  The command staff of this vessel has access to its docking codes in their offices. 
				<br><br>
				Mining and Exploration will probably also want to disembark to do their respective duties.
				<br><br>
				The ship is ordinarily protected from many space hazards by an array of point defense turrets, however, it should be noted that this defense network is not infallible. If the ship encounters a dangerous environment, occasionally hazardous material may slip past the network and damage the ship.
				<br><br><br>
				<h1>Before Moving the Ship</h1>
				<br><br>
				The ship requires power to fuel and run its engines and sensors. While there may be some charge in the ship at the start of the shift, it is <b>HIGHLY RECOMMENDED</b> that the engine be started before attempting to move the ship. If any of the components responsible for moving the ship lose power (including but not limited to the helm control console and the thrusters), then you will be incapable of adjusting the ship's speed or heading until the problem is resolved. 
				<br><br>
				Additionally, the shield generator should be configured before the ship moves, as it takes time to calibrate before it can be activated. The shield should not be run indefinitely however, as it uses more power than the ship ordinarily generates. You can however activate it for a short time if you know that you need to proceed through a dangerous reigon of space. For more information, see the configuration guide sheet in the shield control room on deck 3, aft of the Command Office section.
				<br><br><br>
				<h1>Starting and Moving the Ship</h1>
				<br><br>
				The ship can of course move around on its own, but a few steps need to/should be taken before you can do so. 
				<br><br>
				-FIRST. <b>You should appoint a pilot.</b> If there isn't a pilot, or the pilot isn't responding, you should fax for a pilot. If no pilots respond to the fax within a reasonable timeframe, then, if you are qualified to fly Nanotrasen spacecraft you may fly the ship. Appointing a pilot to the bridge however should always be done even if you know how to fly and have access to the helm control console. <i><b>Refusing to attempt to appoint a pilot and just flying the ship yourself can be grounds for demotion to pilot.</i></b>
				<br><br>
				-SECOND. In order for the ship to move one must start the engines. The ship's fuel pump in Atmospherics must be turned on and configured. Atmospheric technicians may elect to modify the fuel mix to help the ship go faster or make the fuel last longer. Either way, once the fuel pump is on, you may use the engine control console on the bridge to activate the engines. 
				<br><br>
				Once these steps have been taken, the helm control console should respond to input commands from the pilot.
				<br><br><br>
				<h1>Disembarking</h1>
				<br><br>
				Being a response vessel, the Stellar Delight has 3 shuttles in total. 
				<br><br>
				The mining and exploration shuttles are located in the aft of deck 1 between their respective departments. Both of these shuttles are short jump shuttles, meaning, they are not suitable for more than ferrying people back and forth between the ship and the present destination. They do have a small range that they can traverse in their bluespace hops, but they must be within one 'grid square' of a suitable landing site to jump. As such, it is recommended that you avoid flying away from wherever either of these shuttles are without establishing a flight plan with the away teams to indicate a time of returning. In cases where the mining team and the exploration team want to go to different places, it may be necessary to fly from one location to the other now and then to facilitate both operations. However, it is recommended that exploration and mining be encouraged to enter the same operations areas, as the mining team is poorly armed, and the exploration team is ideally equipped for offsite defense and support of ship personnel.
				<br><br>
				There is also the Starstuff, a long range capable shuttle which is ordinarily docked on the port landing pad of deck 3. This shuttle is meant for general crew transport, but does require a pilot to be flown.
				<br><br>
				In cases where the shuttles will be docking with another facility, such as the Science outpost on the Virgo 2 Aerostat, docking codes may be required in order to be accessed. Anywhere requiring such codes will need to have them entered into the given shuttle's short jump console. It is recommended that anyone operating such a shuttle take note of the Stellar Delight's docking codes, as they will need them to dock with the ship. Any Nanotrasen owned facility that requires them that your ship has authorization to access will have the codes stored in the Command Offices. 
				<br><br>
				A final note on disembarking. While it may not necessarily be their job to do so, it is highly encouraged for the Command staff to attempt to involve volunteers in off ship operations as necessary. Just make sure to let let it be known what kind of operation is happening when you ask. This being a response ship, it is very good to get as much help to handle whatever the issue is as thoroughly as possible. 
				<br><br>
				All that said, have a safe trip. - Central Command Officer <i>Alyssa Trems</i>				</body>
			</html>
			"}

//The pathfinder doesn't have a OM shuttle that they are in charge of, and so, doesn't need pilot access. 
//Mostly to prevent explo from just commandeering the Starstuff as the explo shuttle without involving a pilot every round.
/datum/job/pathfinder
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)
	minimal_access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_explorer, access_gateway, access_pathfinder)

//Same as above, to discorage explo from taking off with the small ship without asking, SAR should not need pilot access.
/datum/job/sar
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_eva, access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue)