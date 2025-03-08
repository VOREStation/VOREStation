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
	overmap_z = Z_LEVEL_MISC
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
		/area/groundbase/engineering/solarfield
		)

	unit_test_exempt_from_atmos = list()

	unit_test_z_levels = list(
		Z_LEVEL_GB_BOTTOM,
		Z_LEVEL_GB_MIDDLE,
		Z_LEVEL_GB_TOP
	)

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
		list("Gateway - Carp Farm"),
		list("Gateway - Snow Field"),
		list("Gateway - Listening Post"),
		list(list("Gateway - Honleth Highlands A", "Gateway - Honleth Highlands B")),
		list("Gateway - Arynthi Lake Underground A","Gateway - Arynthi Lake A"),
		list("Gateway - Arynthi Lake Underground B","Gateway - Arynthi Lake B"),
		list("Gateway - Wild West")
		)

	lateload_overmap = list(
		list("Grass Cave")
		)

	lateload_redgate = list(
		list("Redgate - Teppi Ranch"),
		list("Redgate - Innland"),
//		list("Redgate - Abandoned Island"),	//This will come back later
		list("Redgate - Dark Adventure"),
		list("Redgate - Eggnog Town Underground","Redgate - Eggnog Town"),
		list("Redgate - Star Dog"),
		list("Redgate - Hotsprings"),
		list("Redgate - Rain City"),
		list("Redgate - Islands Underwater","Redgate - Islands"),
		list("Redgate - Moving Train", "Redgate - Moving Train Upper Level"),
		list("Redgate - Fantasy Dungeon", "Redgate - Fantasy Town"),
		list("Redgate - Laserdome"),
		list("Redgate - Cascading Falls"),
		list("Redgate - Jungle Underground", "Redgate - Jungle"),
		list("Redgate - Facility")
		)

	lateload_gb_north = list(
		list("Northern Wilds 1"),
		list("Northern Wilds 2")
		)
	lateload_gb_south = list(
		list("Southern Wilds 1"),
		list("Southern Wilds 2"),
		list("Southern Wilds 3")
		)
	lateload_gb_east = list(
		list("Eastern Wilds 1"),
		list("Eastern Wilds 2")
		)
	lateload_gb_west = list(
		list("Western Wilds 1"),
		list("Western Wilds 2")
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

/datum/map/groundbase/perform_map_generation()	//Z_LEVEL_GB_BOTTOM,Z_LEVEL_GB_MIDDLE,Z_LEVEL_GB_TOP

	seed_submaps(list(Z_LEVEL_GB_BOTTOM,Z_LEVEL_GB_MIDDLE,Z_LEVEL_GB_TOP), 100, /area/groundbase/unexplored/outdoors, /datum/map_template/groundbase/outdoor)	//Outdoor POIs
	seed_submaps(list(Z_LEVEL_GB_BOTTOM,Z_LEVEL_GB_MIDDLE), 200, /area/groundbase/unexplored/rock, /datum/map_template/groundbase/maintcaves)	//Cave POIs
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
		Z_LEVEL_GB_WILD_N,
		Z_LEVEL_GB_WILD_S,
		Z_LEVEL_GB_WILD_E,
		Z_LEVEL_GB_WILD_W
		)
/datum/planet/virgo3b
	expected_z_levels = list(
		Z_LEVEL_CENTCOM
	)
/datum/planet/virgo4
	expected_z_levels = list(
		Z_LEVEL_BEACH
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
	mappath = "maps/groundbase/gb-centcomm.dmm"

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
	mappath = "maps/groundbase/gb-misc.dmm"

	associated_map_datum = /datum/map_z_level/gb_lateload/misc

/datum/map_z_level/gb_lateload/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "groundbase_mining.dm"
/datum/map_template/gb_lateload/mining
	name = "V3c Underground"
	desc = "The caves underneath the survace of Virgo 3C"
	mappath = "maps/groundbase/gb-mining.dmm"

	associated_map_datum = /datum/map_z_level/gb_lateload/mining

/datum/map_template/gb_lateload/mining/on_map_loaded(z)
	. = ..()
//	seed_submaps(list(Z_LEVEL_MINING), 60, /area/gb_mine/unexplored, /datum/map_template/space_rocks)	//POI seeding
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_MINING, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/gb_mining(null, 1, 1, Z_LEVEL_MINING, 64, 64)

/datum/map_z_level/gb_lateload/mining
	z = Z_LEVEL_MINING
	name = "V3c Underground"
	base_turf = /turf/simulated/floor/outdoors/newdirt_nograss/virgo3c
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

#include "../expedition_vr/aerostat/_aerostat.dm"
/datum/map_template/common_lateload/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
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
	z = Z_LEVEL_GB_WILD_N
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_z_level/gb_lateload/gb_south_wilds
	name = "GB South Wilderness"
	z = Z_LEVEL_GB_WILD_S
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_z_level/gb_lateload/gb_east_wilds
	name = "GB East Wilderness"
	z = Z_LEVEL_GB_WILD_E
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_z_level/gb_lateload/gb_west_wilds
	name = "GB West Wilderness"
	z = Z_LEVEL_GB_WILD_W
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_CONTACT|MAP_LEVEL_CONSOLES

/datum/map_template/gb_lateload/wilds/north/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_GB_WILD_N, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, Z_LEVEL_GB_WILD_N, 64, 64)

/datum/map_template/gb_lateload/wilds/south/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_GB_WILD_S, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, Z_LEVEL_GB_WILD_N, 64, 64)

/datum/map_template/gb_lateload/wilds/east/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_GB_WILD_E, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, Z_LEVEL_GB_WILD_N, 64, 64)

/datum/map_template/gb_lateload/wilds/west/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_GB_WILD_W, world.maxx, world.maxy)
	new /datum/random_map/noise/ore/mining(null, 1, 1, Z_LEVEL_GB_WILD_N, 64, 64)


/datum/map_template/gb_lateload/wilds/north/type1
	name = "Northern Wilds 1"
	desc = "Wilderness"
	mappath = "maps/groundbase/northwilds/northwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_north_wilds
/datum/map_template/gb_lateload/wilds/north/type2
	name = "Northern Wilds 2"
	desc = "Wilderness"
	mappath = "maps/groundbase/northwilds/northwilds2.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_north_wilds

/datum/map_template/gb_lateload/wilds/south/type1
	name = "Southern Wilds 1"
	desc = "Wilderness"
	mappath = "maps/groundbase/southwilds/southwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_south_wilds
/datum/map_template/gb_lateload/wilds/south/type2
	name = "Southern Wilds 2"
	desc = "Wilderness"
	mappath = "maps/groundbase/southwilds/southwilds2.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_south_wilds
/datum/map_template/gb_lateload/wilds/south/type3
	name = "Southern Wilds 3"
	desc = "Wilderness"
	mappath = "maps/groundbase/southwilds/southwilds3.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_south_wilds
/datum/map_template/gb_lateload/wilds/south/type3/on_map_loaded(z)
	. = ..()
	// Using landmarks for this now.
	//seed_submaps(list(Z_LEVEL_GB_WILD_S), 6, /area/submap/groundbase/poi/wildvillage/plot/square, /datum/map_template/groundbase/wildvillage/square)	//POI seeding
	//seed_submaps(list(Z_LEVEL_GB_WILD_S), 2, /area/submap/groundbase/poi/wildvillage/plot/wide, /datum/map_template/groundbase/wildvillage/wide)
	//seed_submaps(list(Z_LEVEL_GB_WILD_S), 1, /area/submap/groundbase/poi/wildvillage/plot/long, /datum/map_template/groundbase/wildvillage/long)

/datum/map_template/gb_lateload/wilds/east/type1
	name = "Eastern Wilds 1"
	desc = "Wilderness"
	mappath = "maps/groundbase/eastwilds/eastwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_east_wilds
/datum/map_template/gb_lateload/wilds/east/type2
	name = "Eastern Wilds 2"
	desc = "Wilderness"
	mappath = "maps/groundbase/eastwilds/eastwilds2.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_east_wilds

/datum/map_template/gb_lateload/wilds/west/type1
	name = "Western Wilds 1"
	desc = "Wilderness"
	mappath = "maps/groundbase/westwilds/westwilds1.dmm"
	associated_map_datum = /datum/map_z_level/gb_lateload/gb_west_wilds
/datum/map_template/gb_lateload/wilds/west/type2
	name = "Western Wilds 2"
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
