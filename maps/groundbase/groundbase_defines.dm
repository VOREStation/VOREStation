/datum/map/groundbase/New()
	..()
	var/choice = pickweight(list(
		"virgo3C" = 200,
		"rp2" = 200,
		"logo1" = 20,
		"logo2" = 20,
		"gateway" = 5
	))
	if(choice)
		lobby_screens = list(choice)

/datum/map/groundbase
	name = "RascalsPass"
	full_name = "NSB Rascal's Pass"
	path = "groundbase"

	use_overmap = TRUE
	overmap_z = Z_NAME_ALIAS_MISC
	overmap_size = 62
	overmap_event_areas = 100
	usable_email_tlds = list("virgo.nt")

	zlevel_datum_type = /datum/map_z_level/groundbase

	lobby_icon = 'icons/misc/title_vr.dmi'
	lobby_screens = list("logo1")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'


	holomap_smoosh = list(list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP,
		))

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
	shuttle_called_message = "A scheduled crew transfer to the %dock_name% is occuring. The shuttle will arrive shortly. Those departing should proceed to the upper level on the west side of the main facility within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_name = "Crew Transport"
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has departed. Estimate %ETA% until arrival at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule shuttle has been called. It will arrive at the upper level on the west side of the main facility in approximately %ETA%."
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
							NETWORK_HALLS,
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
							NETWORK_TALON_SHIP,
							)

	bot_patrolling = FALSE

	allowed_spawns = list("Gateway","Cryogenic Storage","Cyborg Storage","ITV Talon Cryo")
	spawnpoint_died = /datum/spawnpoint/cryo
	spawnpoint_left = /datum/spawnpoint/gateway
	spawnpoint_stayed = /datum/spawnpoint/cryo


	meteor_strike_areas = list(
		/area/groundbase/level3,
		/area/groundbase/level2,
		/area/groundbase/level1,
		)


	default_skybox = /datum/skybox_settings/groundbase

	unit_test_exempt_areas = list(		//These are all outside
		/area/groundbase/cargo/bay,
		/area/groundbase/civilian/bar/upper,
		/area/groundbase/exploration/shuttlepad,
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
		/area/groundbase/level2/northspur,
		/area/groundbase/level2/eastspur,
		/area/groundbase/level2/westspur,
		/area/groundbase/level2/southeastspur,
		/area/groundbase/level2/southwestspur,
		/area/groundbase/level3,
		/area/groundbase/level3/ne,
		/area/groundbase/level3/nw,
		/area/groundbase/level3/se,
		/area/groundbase/level3/sw,
		/area/groundbase/level3/ne/open,
		/area/groundbase/level3/nw/open,
		/area/groundbase/level3/se/open,
		/area/groundbase/level3/sw/open,
		/area/maintenance/groundbase/level1/netunnel,
		/area/maintenance/groundbase/level1/nwtunnel,
		/area/maintenance/groundbase/level1/setunnel,
		/area/maintenance/groundbase/level1/stunnel,
		/area/maintenance/groundbase/level1/swtunnel,
		/area/groundbase/science/picnic,
		/area/groundbase/medical/patio,
		/area/groundbase/civilian/hydroponics/out,
		/area/groundbase/level3/escapepad,
		/area/maintenance/groundbase/poi/caves,
		/area/submap/groundbase/poi,
		/area/maintenance/groundbase/poi/caves,
		/area/groundbase/unexplored/outdoors,
		/area/groundbase/unexplored/rock,
		/area/groundbase/engineering/solarshed,
		/area/groundbase/engineering/solarfield,
		)

	unit_test_exempt_from_atmos = list()

	unit_test_z_levels = list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP,
		)

	lateload_z_levels = list(
		list(Z_NAME_GB_CENTCOM),
		list(Z_NAME_GB_MISC), //Shuttle transit zones, holodeck templates, OM
		list(Z_NAME_GB_MINING),
		list(Z_NAME_BEACH, Z_NAME_BEACH_CAVE),
		list(Z_NAME_AEROSTAT, Z_NAME_AEROSTAT_SURFACE),
		list(Z_NAME_DEBRISFIELD),
		list(Z_NAME_FUELDEPOT),
		list(Z_NAME_OFFMAP1),
		)

	lateload_gateway = list(
		list(Z_NAME_GATEWAY_CARP_FARM),
		list(Z_NAME_GATEWAY_SNOW_FIELD),
		list(Z_NAME_GATEWAY_LISTENING_POST),
		list(list(Z_NAME_GATEWAY_HONLETH_A, Z_NAME_GATEWAY_HONLETH_B)),
		list(Z_NAME_GATEWAY_ARYNTHI_CAVE_A, Z_NAME_GATEWAY_ARYNTHI_A),
		list(Z_NAME_GATEWAY_ARYNTHI_CAVE_B, Z_NAME_GATEWAY_ARYNTHI_B),
		list(Z_NAME_GATEWAY_WILD_WEST),
		)

	lateload_overmap = list(
		list(Z_NAME_OM_GRASS_CAVE),
		)

	lateload_redgate = list(
		list(Z_NAME_REDGATE_TEPPI_RANCH),
		list(Z_NAME_REDGATE_INNLAND),
//		list(Z_NAME_REDGATE_ABANDONED_ISLAND),	//This will come back later
		list(Z_NAME_REDGATE_DARK_ADVENTURE),
		list(Z_NAME_REDGATE_EGGNOG_CAVE,Z_NAME_REDGATE_EGGNOG_TOWN),
		list(Z_NAME_REDGATE_STAR_DOG),
		list(Z_NAME_REDGATE_HOTSPRINGS),
		list(Z_NAME_REDGATE_RAIN_CITY),
		list(Z_NAME_REDGATE_ISLANDS_UNDERWATER,Z_NAME_REDGATE_ISLANDS),
		list(Z_NAME_REDGATE_MOVING_TRAIN, Z_NAME_REDGATE_MOVING_TRAIN_UPPER),
		list(Z_NAME_REDGATE_FANTASY_DUNGEON, Z_NAME_REDGATE_FANTASY_TOWN),
		list(Z_NAME_REDGATE_LASERDOME),
		list(Z_NAME_REDGATE_CASCADING_FALLS),
		list(Z_NAME_REDGATE_JUNGLE_CAVE, Z_NAME_REDGATE_JUNGLE),
		list(Z_NAME_REDGATE_FACILITY),
		)

	lateload_gb_north = list(
		list(Z_NAME_GB_WILDS_N1),
		list(Z_NAME_GB_WILDS_N2),
		)
	lateload_gb_south = list(
		list(Z_NAME_GB_WILDS_S1),
		list(Z_NAME_GB_WILDS_S2),
		list(Z_NAME_GB_WILDS_S3),
		)
	lateload_gb_east = list(
		list(Z_NAME_GB_WILDS_E1),
		list(Z_NAME_GB_WILDS_E2),
		)
	lateload_gb_west = list(
		list(Z_NAME_GB_WILDS_W1),
		list(Z_NAME_GB_WILDS_W2),
		)

	ai_shell_restricted = TRUE
	ai_shell_allowed_levels = list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP,
		Z_NAME_ALIAS_MISC,
		Z_NAME_BEACH,
		Z_NAME_AEROSTAT,
		)

	planet_datums_to_make = list(
		/datum/planet/virgo3b,
		/datum/planet/virgo3c,
		/datum/planet/virgo4,
		)

/datum/map/groundbase/get_map_info()
	. = list()
	. +=  "[full_name] is a recently established base on one of Virgo 3's moons."
	return jointext(., "<br>")

/datum/map/groundbase/perform_map_generation()	//Z_LEVEL_GB_BOTTOM,Z_LEVEL_GB_MIDDLE,Z_LEVEL_GB_TOP

	seed_submaps(list(Z_LEVEL_GB_BOTTOM,Z_LEVEL_GB_MIDDLE,Z_LEVEL_GB_TOP), 100, /area/groundbase/unexplored/outdoors, /datum/map_template/groundbase/outdoor)	//Outdoor POIs
	seed_submaps(list(Z_LEVEL_GB_BOTTOM,Z_LEVEL_GB_MIDDLE), 200, /area/groundbase/unexplored/rock, /datum/map_template/groundbase/maintcaves)	//Cave POIs
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_NAME_GB_MINING, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_NAME_GB_MINING, 64, 64)         // Create the mining ore distribution map.
	return 1

/datum/skybox_settings/groundbase
	icon_state = "space5"
	use_stars = FALSE

/datum/planet/virgo3c
	expected_z_levels = list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP,
		Z_NAME_ALIAS_GB_WILDS_N,
		Z_NAME_ALIAS_GB_WILDS_S,
		Z_NAME_ALIAS_GB_WILDS_E,
		Z_NAME_ALIAS_GB_WILDS_W
		)
/datum/planet/virgo3b
	expected_z_levels = list(
		Z_NAME_ALIAS_CENTCOM
	)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_NAME_BEACH
	)

/obj/effect/overmap/visitable/sector/virgo3b
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
	extra_z_levels = list(
		Z_NAME_GB_MINING,
		Z_NAME_ALIAS_GB_WILDS_N,
		Z_NAME_ALIAS_GB_WILDS_S,
		Z_NAME_ALIAS_GB_WILDS_E,
		Z_NAME_ALIAS_GB_WILDS_W
		)

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
	return ..()

/datum/map_z_level/gb_lateload/New(datum/map/map, mapZ)
	z = mapZ
	return ..(map)

/datum/map_template/gb_lateload/gb_centcom
	name = Z_NAME_GB_CENTCOM
	desc = "Central Command lives here!"
	mappath = "maps/groundbase/gb-centcomm.dmm"
	name_alias = Z_NAME_ALIAS_CENTCOM

	associated_map_datum = /datum/map_z_level/gb_lateload/gb_centcom

/datum/map_z_level/gb_lateload/gb_centcom
	//z = Z_NAME_ALIAS_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks

/area/centcom //Just to try to make sure there's not space!!!
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_template/gb_lateload/gb_misc
	name = Z_NAME_GB_MISC
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "maps/groundbase/gb-misc.dmm"
	name_alias = Z_NAME_ALIAS_MISC

	associated_map_datum = /datum/map_z_level/gb_lateload/misc

/datum/map_z_level/gb_lateload/misc
	//z = Z_NAME_ALIAS_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "groundbase_mining.dm"
/datum/map_template/gb_lateload/mining
	name = Z_NAME_GB_MINING
	desc = "The caves underneath the survace of Virgo 3C"
	mappath = "maps/groundbase/gb-mining.dmm"

	associated_map_datum = /datum/map_z_level/gb_lateload/mining

/datum/map_template/gb_lateload/mining/on_map_loaded(z)
	. = ..()
//	seed_submaps(list(z), 60, /area/gb_mine/unexplored, /datum/map_template/space_rocks)	//POI seeding
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/gb_mining(null, 1, 1, z, 64, 64)

/datum/map_z_level/gb_lateload/mining
	//z = Z_NAME_GB_MINING
	name = Z_NAME_GB_MINING
	base_turf = /turf/simulated/floor/outdoors/newdirt_nograss/virgo3c
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

#include "../expedition_vr/aerostat/_aerostat.dm"
/datum/map_template/common_lateload/away_aerostat
	name = Z_NAME_AEROSTAT
	desc = "The Virgo 2 Aerostat away mission."
	mappath = "maps/expedition_vr/aerostat/aerostat.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_aerostat

////////////////////////////////////////////////////////////////////////

/datum/map_template/gb_lateload/wilds
	name = "GB Wilderness Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = null

/datum/map_z_level/gb_lateload/gb_north_wilds
	name = "GB North Wilderness"
	//z = Z_NAME_ALIAS_GB_WILDS_N
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_z_level/gb_lateload/gb_south_wilds
	name = "GB South Wilderness"
	//z = Z_NAME_ALIAS_GB_WILDS_S
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_z_level/gb_lateload/gb_east_wilds
	name = "GB East Wilderness"
	//z = Z_NAME_ALIAS_GB_WILDS_E
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_z_level/gb_lateload/gb_west_wilds
	name = "GB West Wilderness"
	//z = Z_NAME_ALIAS_GB_WILDS_W
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_template/gb_lateload/wilds/north/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, z, 64, 64)

/datum/map_template/gb_lateload/wilds/south/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, z, 64, 64)

/datum/map_template/gb_lateload/wilds/east/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, z, 64, 64)

/datum/map_template/gb_lateload/wilds/west/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, z, 64, 64)

// North Wilds
/datum/map_template/gb_lateload/wilds/north
	name_alias = Z_NAME_ALIAS_GB_WILDS_N

/datum/map_template/gb_lateload/wilds/north/type1
	name = Z_NAME_GB_WILDS_N1
	desc = "Wilderness"
	mappath = "maps/groundbase/northwilds/northwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_north_wilds

/datum/map_template/gb_lateload/wilds/north/type2
	name = Z_NAME_GB_WILDS_N2
	desc = "Wilderness"
	mappath = "maps/groundbase/northwilds/northwilds2.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_north_wilds

// South Wilds
/datum/map_template/gb_lateload/wilds/south
	name_alias = Z_NAME_ALIAS_GB_WILDS_S

/datum/map_template/gb_lateload/wilds/south/type1
	name = Z_NAME_GB_WILDS_S1
	desc = "Wilderness"
	mappath = "maps/groundbase/southwilds/southwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_south_wilds

/datum/map_template/gb_lateload/wilds/south/type2
	name = Z_NAME_GB_WILDS_S2
	desc = "Wilderness"
	mappath = "maps/groundbase/southwilds/southwilds2.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_south_wilds

/datum/map_template/gb_lateload/wilds/south/type3
	name = Z_NAME_GB_WILDS_S3
	desc = "Wilderness"
	mappath = "maps/groundbase/southwilds/southwilds3.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_south_wilds

/*
/datum/map_template/gb_lateload/wilds/south/type3/on_map_loaded(z)
	. = ..()
	 Using landmarks for this now.
	seed_submaps(list(z), 6, /area/submap/groundbase/poi/wildvillage/plot/square, /datum/map_template/groundbase/wildvillage/square)	//POI seeding
	seed_submaps(list(z), 2, /area/submap/groundbase/poi/wildvillage/plot/wide, /datum/map_template/groundbase/wildvillage/wide)
	seed_submaps(list(z), 1, /area/submap/groundbase/poi/wildvillage/plot/long, /datum/map_template/groundbase/wildvillage/long)
*/

// East Wilds
/datum/map_template/gb_lateload/wilds/east
	name_alias = Z_NAME_ALIAS_GB_WILDS_E

/datum/map_template/gb_lateload/wilds/east/type1
	name = Z_NAME_GB_WILDS_E1
	desc = "Wilderness"
	mappath = "maps/groundbase/eastwilds/eastwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_east_wilds

/datum/map_template/gb_lateload/wilds/east/type2
	name = Z_NAME_GB_WILDS_E2
	desc = "Wilderness"
	mappath = "maps/groundbase/eastwilds/eastwilds2.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_east_wilds

// West Wilds
/datum/map_template/gb_lateload/wilds/west
	name_alias = Z_NAME_ALIAS_GB_WILDS_W

/datum/map_template/gb_lateload/wilds/west/type1
	name = Z_NAME_GB_WILDS_W1
	desc = "Wilderness"
	mappath = "maps/groundbase/westwilds/westwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_west_wilds

/datum/map_template/gb_lateload/wilds/west/type2
	name = Z_NAME_GB_WILDS_W2
	desc = "Wilderness"
	mappath = "maps/groundbase/westwilds/westwilds2.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_west_wilds

/*
/datum/map_template/gb_lateload/wilds/north1/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 60, /area/om_adventure/grasscave/unexplored, /datum/map_template/om_adventure/outdoor)
	seed_submaps(list(z), 60, /area/om_adventure/grasscave/rocks, /datum/map_template/om_adventure/cave)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/grasscave(null, 1, 1, z, 64, 64)
*/

////////////////////////////////////////////////////////////////////////
