//Normal map defs
#define Z_LEVEL_GB_BOTTOM  					1
#define Z_LEVEL_GB_MIDDLE  					2
#define Z_LEVEL_GB_TOP     					3
#define Z_LEVEL_CENTCOM						4
#define Z_LEVEL_MISC						5
#define Z_LEVEL_MINING						6
#define Z_LEVEL_BEACH						7
#define Z_LEVEL_BEACH_CAVE					8
#define Z_LEVEL_AEROSTAT					9
#define Z_LEVEL_AEROSTAT_SURFACE			10
#define Z_LEVEL_DEBRISFIELD					11
#define Z_LEVEL_FUELDEPOT					12
#define Z_LEVEL_OFFMAP1						13
#define Z_LEVEL_GATEWAY						14
#define Z_LEVEL_OM_ADVENTURE				15

//Camera networks
#define NETWORK_HALLS "Halls"

/datum/map/groundbase/New()
	..()
	var/choice = pickweight(list(
		"endo"
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/groundbase
	name = "RascalsPass"
	full_name = "NSB Rascal's Pass"
	path = "groundbase"

	use_overmap = TRUE
	overmap_z = Z_LEVEL_MISC
	overmap_size = 25
	overmap_event_areas = 15
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/groundbase

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("endo")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'


	holomap_smoosh = list(list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP))

	station_name  = "NSB Rascal's Pass"
	station_short = "Rascal's Pass"
	facility_type = "base"
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
	shuttle_name = "Crew Transport"
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


	meteor_strike_areas = list(
		/area/groundbase/level3,
		/area/groundbase/level2,
		/area/groundbase/level1
		)


	default_skybox = /datum/skybox_settings/groundbase

	unit_test_exempt_areas = list(		//These are all outside
		/area/groundbase/level1,
		/area/groundbase/level1/ne,
		/area/groundbase/level1/nw,
		/area/groundbase/level1/se,
		/area/groundbase/level1/sw,
		/area/groundbase/level1/centsquare,
		/area/groundbase/level1/northspur,
		/area/groundbase/level1/eastspur,
		/area/groundbase/level1/westspur,
		/area/groundbase/level1/southeastspur,
		/area/groundbase/level1/southwestspur,
		/area/groundbase/level2,
		/area/groundbase/level2/ne,
		/area/groundbase/level2/nw,
		/area/groundbase/level2/se,
		/area/groundbase/level2/sw,
		/area/groundbase/level3,
		/area/groundbase/level3/ne,
		/area/groundbase/level3/nw,
		/area/groundbase/level3/se,
		/area/groundbase/level3/sw,
		/area/maintenance/groundbase/level1/netunnel,
		/area/maintenance/groundbase/level1/nwtunnel,
		/area/maintenance/groundbase/level1/setunnel,
		/area/maintenance/groundbase/level1/stunnel,
		/area/maintenance/groundbase/level1/swtunnel,
		/area/groundbase/science/picnic,
		/area/groundbase/medical/patio,
		/area/groundbase/civilian/hydroponics/out
		)

	unit_test_exempt_from_atmos = list()


	lateload_z_levels = list(
		list("Groundbase - Central Command"),
		list("Groundbase - Misc"), //Shuttle transit zones, holodeck templates, OM
		list("V3c Underground"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface"),
		list("Debris Field - Z1 Space"),
		list("Fuel Depot - Z1 Space"),
		list("Offmap Ship - Talon V2")
		)

	lateload_gateway = list(
		list("Carp Farm"),
		list("Snow Field"),
		list("Listening Post"),
		list(list("Honleth Highlands A", "Honleth Highlands B")),
		list("Arynthi Lake Underground A","Arynthi Lake A"),
		list("Arynthi Lake Underground B","Arynthi Lake B"),
		list("Eggnog Town Underground","Eggnog Town"),
		list("Wild West")
		)

	lateload_overmap = list(
		list("Grass Cave")
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP,
		Z_LEVEL_MISC,
		Z_LEVEL_BEACH,
		Z_LEVEL_AEROSTAT
		)

	planet_datums_to_make = list(
		/datum/planet/virgo3b,
		/datum/planet/virgo3c,
		/datum/planet/virgo4)

/datum/map/groundbase/get_map_info()
	. = list()
	. +=  "[full_name] is a recently established base on one of Virgo 3's moons."
	return jointext(., "<br>")


/datum/map/groundbase/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_MINING, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_MINING, 64, 64)         // Create the mining ore distribution map.
	return 1

/datum/skybox_settings/groundbase
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/virgo3c
	expected_z_levels = list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP,
		Z_LEVEL_CENTCOM
		)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_LEVEL_BEACH
	)

/obj/effect/landmark/map_data/groundbase
	height = 3

/obj/effect/overmap/visitable/sector/virgo3b
	name = "Virgo 3B"
	desc = "Full of phoron, and home to the NSB Adephagia."
	scanner_desc = @{"[i]Registration[/i]: NSB Adephagia
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	known = TRUE
	in_space = TRUE

	icon = 'icons/obj/overmap_vr.dmi'
	icon_state = "virgo3b"

	skybox_icon = 'icons/skybox/virgo3b.dmi'
	skybox_icon_state = "small"
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	initial_generic_waypoints = list()
	initial_restricted_waypoints = list()

	extra_z_levels = list()

/obj/effect/overmap/visitable/sector/virgo3c
	name = "Virgo 3C"
	desc = "A small, volcanically active moon."
	scanner_desc = @{"[i]Registration[/i]: NSB Rascal's Pass
[i]Class[/i]: Installation
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Base, authorized personnel only"}
	known = TRUE
	in_space = TRUE

	icon = 'icons/obj/overmap.dmi'
	icon_state = "lush"

	skybox_icon = null
	skybox_icon_state = null
	skybox_pixel_x = 0
	skybox_pixel_y = 0

	initial_generic_waypoints = list("groundbase")
	initial_restricted_waypoints = list("Exploration Shuttle" = list("gbexplo"))

	extra_z_levels = list()


// For making the 6-in-1 holomap, we calculate some offsets
#define SHIP_MAP_SIZE 140 // Width and height of compiled in tether z levels.
#define SHIP_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define SHIP_HOLOMAP_MARGIN_X ((HOLOMAP_ICON_SIZE - (2*SHIP_MAP_SIZE) - SHIP_HOLOMAP_CENTER_GUTTER) / 2) // 80
#define SHIP_HOLOMAP_MARGIN_Y ((HOLOMAP_ICON_SIZE - (2*SHIP_MAP_SIZE)) / 2) // 30

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/groundbase
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_XENOARCH_EXEMPT|MAP_LEVEL_PERSIST
	holomap_legend_x = 220
	holomap_legend_y = 160

/datum/map_z_level/groundbase/level_one
	z = Z_LEVEL_GB_BOTTOM
	name = "Level 1"
	base_turf = /turf/simulated/floor/outdoors/newdirt_nograss/virgo3c
	transit_chance = 0
	holomap_offset_x = SHIP_HOLOMAP_MARGIN_X
	holomap_offset_y = SHIP_HOLOMAP_MARGIN_Y

/datum/map_z_level/groundbase/deck_two
	z = Z_LEVEL_GB_MIDDLE
	name = "Level 2"
	base_turf = /turf/simulated/open/virgo3c
	transit_chance = 0
	holomap_offset_x = SHIP_HOLOMAP_MARGIN_X
	holomap_offset_y = SHIP_HOLOMAP_MARGIN_Y + SHIP_MAP_SIZE

/datum/map_z_level/groundbase/deck_three
	z = Z_LEVEL_GB_TOP
	name = "Level 3"
	base_turf = /turf/simulated/open/virgo3c
	transit_chance = 0
	holomap_offset_x = HOLOMAP_ICON_SIZE - SHIP_HOLOMAP_MARGIN_X - SHIP_MAP_SIZE
	holomap_offset_y = SHIP_HOLOMAP_MARGIN_Y + SHIP_MAP_SIZE

/datum/map_template/gb_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/////STATIC LATELOAD/////

/datum/map_template/gb_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)

/datum/map_template/gb_lateload/gb_centcom
	name = "Groundbase - Central Command"
	desc = "Central Command lives here!"
	mappath = 'gb-centcomm.dmm'

	associated_map_datum = /datum/map_z_level/gb_lateload/gb_centcom

/datum/map_z_level/gb_lateload/gb_centcom
	z = Z_LEVEL_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks

/area/centcom //Just to try to make sure there's not space!!!
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_template/gb_lateload/gb_misc
	name = "Groundbase - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = 'gb-misc.dmm'

	associated_map_datum = /datum/map_z_level/gb_lateload/misc

/datum/map_z_level/gb_lateload/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "gb-mining.dm"
/datum/map_template/gb_lateload/mining
	name = "V3c Underground"
	desc = "The caves underneath the survace of Virgo 3C"
	mappath = 'maps/groundbase/gb-mining.dmm'

	associated_map_datum = /datum/map_z_level/gb_lateload/mining

/datum/map_template/gb_lateload/mining/on_map_loaded(z)
	. = ..()
//	seed_submaps(list(Z_LEVEL_MINING), 60, /area/gb_mine/unexplored, /datum/map_template/space_rocks)	//POI seeding
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_MINING, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/mining(null, 1, 1, Z_LEVEL_MINING, 64, 64)

/datum/map_z_level/gb_lateload/mining
	z = Z_LEVEL_MINING
	name = "V3c Underground"
	base_turf = /turf/simulated/floor/outdoors/newdirt_nograss/virgo3c
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

#include "../expedition_vr/aerostat/_aerostat.dm"
/datum/map_template/common_lateload/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	mappath = 'maps/expedition_vr/aerostat/aerostat.dmm'
	associated_map_datum = /datum/map_z_level/common_lateload/away_aerostat

/////EXPLOSHUTTL/////
// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/gbexplo
	name = "Shuttle control console"
	shuttle_tag = "gbexplo"
	req_one_access = list(access_pilot)

/obj/effect/overmap/visitable/ship/landable/gbexplo
	name = "Exploration Shuttle"
	desc = "A small shuttle from Rascal's Pass."
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY
	shuttle = "gbexplo"
	known = TRUE

// A shuttle lateloader landmark

/datum/shuttle/autodock/overmap/gbexplo
	name = "Exploration Shuttlepad"
	current_location = "ex_shuttlepad"
	docking_controller_tag = "ex_docker"
	shuttle_area = list(/area/shuttle/groundbase/exploration)
	fuel_consumption = 1
	defer_initialisation = TRUE

/area/shuttle/groundbase/exploration
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "yelwhitri"
	name = "Exploration Shuttle"
	requires_power = 1

//////////////////////////////////////////////

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

////////////////////////////////////////////////

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

/obj/effect/shuttle_landmark/premade/groundbase
	name = "Rascal's Pass"
	landmark_tag = "groundbase"

/obj/effect/step_trigger/teleporter/to_mining
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = 0
/obj/effect/step_trigger/teleporter/to_mining/Initialize()
	. = ..()
	teleport_x = x
	teleport_y = y ++
	teleport_z = Z_LEVEL_MINING

/obj/effect/step_trigger/teleporter/from_mining
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = 0
/obj/effect/step_trigger/teleporter/from_mining/Initialize()
	. = ..()
	teleport_x = x
	teleport_y = y --
	teleport_z = Z_LEVEL_GB_BOTTOM
